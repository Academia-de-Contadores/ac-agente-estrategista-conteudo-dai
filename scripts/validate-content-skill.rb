# frozen_string_literal: true

require "date"
require "digest"
require "fileutils"
require "pathname"
require "tmpdir"
require "yaml"

ROOT = Pathname.new(__dir__).join("..").expand_path
SKILL_NAME = "ac-estrategista-conteudo-dai"

ACTIVE_KNOWLEDGE = %w[
  00-INDICE-CONTEUDO-DAI.md
  01-REGRAS-DE-USO-E-LIMITES.md
  02-ESCOPO-E-ROTEAMENTO.md
  03-FONTES-CANONICAS.md
  04-SKILLS-E-CENARIOS-DE-USO.md
  05-PERGUNTAS-TESTE-E-RESPOSTAS-ESPERADAS.md
  06-GUARDRAILS-E-CLAIMS-BLOQUEADOS.md
  07-MODELOS-DE-RESPOSTA-E-CHECKLISTS.md
  08-LACUNAS-E-ROADMAP.md
  09-BANCO-DE-ANGULOS-E-ROTEIROS.md
  99-FONTES-LACUNAS-E-CONTROLE-DE-VERSAO.md
].map { |name| "knowledge/active-2026-09-21/#{name}" }.freeze

KNOWLEDGE_INTEGRITY = {
  ACTIVE_KNOWLEDGE[0] => [1791, "c6ea4fe713dc39be10e29d6bdc7db7ef376af0d7d1c662b1adfe9c772bc6ca3f"],
  ACTIVE_KNOWLEDGE[1] => [1574, "778a96e79b40cd2a47ef5c7072a0ec34a0923b6c6c9ec8ad31ee3485d1b08c0f"],
  ACTIVE_KNOWLEDGE[2] => [3135, "51519021e1b3a9d7cb35d34a8bffad1f72e92f3bb63d75d5e5180c5b44898eec"],
  ACTIVE_KNOWLEDGE[3] => [1270, "0509079194c0cc903e8d8484366e282737ed1706e27c29a4e0c575a87f3705e6"],
  ACTIVE_KNOWLEDGE[4] => [2007, "d1215ec328aada70b4b062a02f0b29841da55e3d8c46244d3441bfdb11f57b8c"],
  ACTIVE_KNOWLEDGE[5] => [2373, "2bf7ad547c167f26a42341edf5cb7e4289baa8fbbdd7e7ad017cc09168aca391"],
  ACTIVE_KNOWLEDGE[6] => [1132, "01ac88d4847ec0313529efc18d7227ebc10cb51dfd48c3bf9a80baefcc0e14ce"],
  ACTIVE_KNOWLEDGE[7] => [1498, "225e66b4b802b510251441796201c26d0131cf9b9498062c918727148d7ae22c"],
  ACTIVE_KNOWLEDGE[8] => [1276, "5e9e18eb0e4fcf97cd4781bd4acaf41cde5bde4ac776b4da0503ca2297ae5072"],
  ACTIVE_KNOWLEDGE[9] => [12_299, "aaef4c463988e7f9be08b1cc8b66429dd56a6772a28322f2538917dbbefb09af"],
  ACTIVE_KNOWLEDGE[10] => [1033, "025e1be8eb58d2356a0c512fd2797e586b1824ba433e47894a3c976881e78c3c"]
}.freeze

PACKAGE = [
  "SKILL.md",
  "agent.yaml",
  "agents/openai.yaml",
  "references/evidence-policy.md",
  "references/content-outputs.md",
  "references/approval-policy.md",
  "identity/identity.md",
  "identity/soul.md",
  "objectives/mission.md",
  "objectives/non-goals.md",
  "objectives/success-metrics.md",
  "instructions/system.md",
  "instructions/guardrails.md",
  "instructions/workflows/main.md",
  *ACTIVE_KNOWLEDGE
].freeze

GATES = %w[
  no-fabrication
  no-guaranteed-claims
  technical-boundary
  evidence-gap-visible
  no-external-action-without-approval
  untrusted-content-and-confidentiality
].freeze

def fail_validation(message)
  warn "content skill validation error: #{message}"
  exit 1
end

def load_yaml(relative_path)
  YAML.safe_load(
    ROOT.join(relative_path).read,
    permitted_classes: [Date],
    aliases: false
  )
rescue Psych::Exception => e
  fail_validation("invalid YAML in #{relative_path}: #{e.message}")
end

agent = load_yaml("agent.yaml")
agent_data = agent.fetch("agent", {})
fail_validation("agent.version must be 0.2.0") unless agent_data["version"].to_s == "0.2.0"
fail_validation("agent.lifecycle must be candidate") unless agent_data["lifecycle"] == "candidate"

skill = agent.fetch("skills", []).find { |entry| entry["id"] == SKILL_NAME }
fail_validation("missing canonical skill declaration") unless skill
fail_validation("skill entrypoint must be SKILL.md") unless skill["entrypoint"] == "SKILL.md"

runtime = agent.fetch("skill_runtime", {})
fail_validation("skill_runtime.name mismatch") unless runtime["name"] == SKILL_NAME
fail_validation("skill_runtime.entrypoint mismatch") unless runtime["entrypoint"] == "SKILL.md"
fail_validation("skill_runtime must declare explicit triggers") unless runtime.fetch("triggers", []).length >= 8
fail_validation("runtime Knowledge allowlist mismatch") unless runtime["knowledge"] == ACTIVE_KNOWLEDGE
fail_validation("package allowlist mismatch") unless runtime["package"] == PACKAGE

runtime.fetch("package").each do |relative_path|
  path = Pathname.new(relative_path)
  fail_validation("package path must be relative: #{relative_path}") if path.absolute?
  fail_validation("package path escapes root: #{relative_path}") if path.each_filename.include?("..")
  fail_validation(".gitkeep is forbidden in package: #{relative_path}") if path.basename.to_s == ".gitkeep"
  full_path = ROOT.join(path)
  fail_validation("missing package file: #{relative_path}") unless full_path.exist?
  fail_validation("symlink is forbidden in package: #{relative_path}") if full_path.symlink?
  fail_validation("package entry must be a regular file: #{relative_path}") unless full_path.file?
end

skill_text = ROOT.join("SKILL.md").read
frontmatter = skill_text.match(/\A---\n(.*?)\n---\n/m)
fail_validation("SKILL.md needs YAML frontmatter") unless frontmatter
skill_meta = YAML.safe_load(frontmatter[1], aliases: false)
fail_validation("SKILL.md name mismatch") unless skill_meta["name"] == SKILL_NAME
description = skill_meta["description"].to_s
fail_validation("SKILL.md description must start with Use when") unless description.start_with?("Use when")
%w[references/evidence-policy.md references/content-outputs.md references/approval-policy.md].each do |reference|
  fail_validation("SKILL.md does not route to #{reference}") unless skill_text.include?(reference)
end

interface = load_yaml("agents/openai.yaml")
unless interface.dig("policy", "allow_implicit_invocation") == true
  fail_validation("implicit invocation must remain enabled")
end

active_dir = ROOT.join("knowledge/active-2026-09-21")
active_files = active_dir.children.select(&:file?).map { |path| path.relative_path_from(ROOT).to_s }.sort
expected_active_files = (ACTIVE_KNOWLEDGE + ["knowledge/active-2026-09-21/MANIFEST.md"]).sort
fail_validation("active Knowledge directory inventory mismatch") unless active_files == expected_active_files

KNOWLEDGE_INTEGRITY.each do |relative_path, (bytes, sha256)|
  path = ROOT.join(relative_path)
  fail_validation("missing active Knowledge: #{relative_path}") unless path.file?
  fail_validation("Knowledge byte count changed: #{relative_path}") unless path.size == bytes
  fail_validation("Knowledge SHA-256 changed: #{relative_path}") unless Digest::SHA256.file(path).hexdigest == sha256
end

active_manifest = ROOT.join("knowledge/active-2026-09-21/MANIFEST.md").read
KNOWLEDGE_INTEGRITY.each do |relative_path, (bytes, sha256)|
  filename = Pathname.new(relative_path).basename.to_s
  unless active_manifest.include?("`#{filename}`") &&
         active_manifest.include?("`#{sha256}`") &&
         active_manifest.match?(/`#{Regexp.escape(filename)}`.*\| #{bytes} \|/)
    fail_validation("active MANIFEST does not verify #{filename}")
  end
end

historical_sources = {
  ACTIVE_KNOWLEDGE[0] => "knowledge/original/00-INDICE-CONTEUDO-DAI.md",
  ACTIVE_KNOWLEDGE[9] => "knowledge/original/09-BANCO-DE-ANGULOS-E-ROTEIROS.md"
}
ACTIVE_KNOWLEDGE.each_with_index do |active_path, index|
  next if [0, 9].include?(index)

  historical_sources[active_path] = active_path.sub("active-2026-09-21", "live-2026-08-22")
end
historical_sources.each do |active_path, source_path|
  unless FileUtils.compare_file(ROOT.join(active_path), ROOT.join(source_path))
    fail_validation("active Knowledge differs from declared source: #{active_path}")
  end
end

system_text = ROOT.join("instructions/system.md").binread
lines = system_text.lines
fail_validation("instructions/system.md wrapper must be ten lines") unless lines.length >= 11 && lines[10] == "---\n"
payload = lines.drop(10).join
payload = payload.delete_suffix("\n")
fail_validation("instruction payload must be 3989 bytes") unless payload.bytesize == 3989
unless Digest::SHA256.hexdigest(payload) == "913433ef733c39349debcfbdd7e9f4089c805b8a886641561fae193f33165247"
  fail_validation("instruction payload SHA-256 mismatch")
end
fail_validation("instruction payload must be 133 lines") unless payload.lines.length == 133

questions = load_yaml("evaluations/parity/questions.yaml")
case_ids = questions.fetch("cases", []).map { |entry| entry["id"] }
fail_validation("questions.yaml must define P1..P6") unless case_ids == %w[P1 P2 P3 P4 P5 P6]

(1..6).each do |index|
  path = ROOT.join("evaluations/parity/P#{index}.md")
  fail_validation("missing P#{index} scenario") unless path.file?
  text = path.read
  criteria = text.lines.count { |line| line.match?(/^- \[ \] C\d{2} /) }
  fail_validation("P#{index} must contain exactly 12 objective criteria") unless criteria == 12
  GATES.each do |gate|
    fail_validation("P#{index} missing gate #{gate}") unless text.match?(/^- #{Regexp.escape(gate)}$/)
  end
end

rubric = ROOT.join("evaluations/rubrics/behavior.md").read
GATES.each do |gate|
  fail_validation("rubric missing gate #{gate}") unless rubric.include?("**#{gate}:**")
end
fail_validation("rubric must define 12-point scale") unless rubric.include?("total máximo 12")

required_package_fragments = %w[
  instructions/system.md
  instructions/guardrails.md
  instructions/workflows/main.md
]
required_package_fragments.each do |relative_path|
  fail_validation("missing required instruction in package") unless PACKAGE.include?(relative_path)
end

Dir.mktmpdir("content-skill-package-") do |directory|
  install_root = Pathname.new(directory)
  PACKAGE.each do |relative_path|
    target = install_root.join(relative_path)
    target.dirname.mkpath
    FileUtils.cp(ROOT.join(relative_path), target)
  end
  installed = install_root.glob("**/*", File::FNM_DOTMATCH).reject do |path|
    [".", ".."].include?(path.basename.to_s) || path.directory?
  end
  fail_validation("installed package inventory mismatch") unless installed.length == PACKAGE.length
  fail_validation("installed package contains symlink") if installed.any?(&:symlink?)
  fail_validation("installed package contains .gitkeep") if installed.any? { |path| path.basename.to_s == ".gitkeep" }
end

puts "content skill validation passed (#{PACKAGE.length} files, #{ACTIVE_KNOWLEDGE.length} Knowledge files)"
