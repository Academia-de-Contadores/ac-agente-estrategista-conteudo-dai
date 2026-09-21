#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"
validator="$root/scripts/validate-content-skill.rb"

for relative_path in \
  SKILL.md \
  agent.yaml \
  skill-runtime.yaml \
  agents/openai.yaml \
  references/evidence-policy.md \
  references/content-outputs.md \
  references/approval-policy.md \
  evaluations/parity/questions.yaml \
  evaluations/parity/P1.md \
  evaluations/parity/P2.md \
  evaluations/parity/P3.md \
  evaluations/parity/P4.md \
  evaluations/parity/P5.md \
  evaluations/parity/P6.md \
  reports/online-parity-2026-09-21.md \
  scripts/validate-content-skill.rb; do
  test -f "$root/$relative_path"
done

ruby "$validator"

test "$(wc -c < "$root/instructions/system.md" | tr -d '[:space:]')" = "3989"
ruby -e 'abort unless File.binread(ARGV.fetch(0)).lines.length == 133' \
  "$root/instructions/system.md"
test "$(shasum -a 256 "$root/instructions/system.md" | awk '{ print $1 }')" = \
  "913433ef733c39349debcfbdd7e9f4089c805b8a886641561fae193f33165247"
if grep -Eq 'delete_suffix|chomp|rstrip|strip' "$validator"; then
  echo "instruction parity must not normalize instructions/system.md" >&2
  exit 1
fi
if grep -Fq '/Users/levy/' "$root/HOW-TO-USE.md"; then
  echo "HOW-TO-USE contains a personal absolute path" >&2
  exit 1
fi

fixture="$(mktemp -d)"
trap 'rm -rf "$fixture"' EXIT
cp -R "$root/." "$fixture/"
rm -rf "$fixture/.git"

expect_rejected() {
  local label="$1"
  if ruby "$fixture/scripts/validate-content-skill.rb" >/dev/null 2>&1; then
    echo "expected content skill validator to reject: $label" >&2
    return 1
  fi
}

cp "$fixture/agent.yaml" "$fixture/agent.yaml.valid"
sed 's/^  lifecycle: candidate$/  lifecycle: source-capture/' \
  "$fixture/agent.yaml.valid" > "$fixture/agent.yaml"
expect_rejected "lifecycle other than candidate"
mv "$fixture/agent.yaml.valid" "$fixture/agent.yaml"

cp "$fixture/agent.yaml" "$fixture/agent.yaml.valid"
sed '\|    - knowledge/active-2026-09-21/09-BANCO-DE-ANGULOS-E-ROTEIROS.md|d' \
  "$fixture/agent.yaml.valid" > "$fixture/agent.yaml"
expect_rejected "incomplete package allowlist"
mv "$fixture/agent.yaml.valid" "$fixture/agent.yaml"

cp "$fixture/agent.yaml" "$fixture/agent.yaml.valid"
awk '{ print; if ($0 == "  package:") print "    - skills/.gitkeep" }' \
  "$fixture/agent.yaml.valid" > "$fixture/agent.yaml"
expect_rejected ".gitkeep in package allowlist"
mv "$fixture/agent.yaml.valid" "$fixture/agent.yaml"

cp "$fixture/knowledge/active-2026-09-21/06-GUARDRAILS-E-CLAIMS-BLOQUEADOS.md" \
  "$fixture/knowledge/active-2026-09-21/06-GUARDRAILS-E-CLAIMS-BLOQUEADOS.md.valid"
printf '\ncorruption\n' >> \
  "$fixture/knowledge/active-2026-09-21/06-GUARDRAILS-E-CLAIMS-BLOQUEADOS.md"
expect_rejected "changed active Knowledge bytes"
mv "$fixture/knowledge/active-2026-09-21/06-GUARDRAILS-E-CLAIMS-BLOQUEADOS.md.valid" \
  "$fixture/knowledge/active-2026-09-21/06-GUARDRAILS-E-CLAIMS-BLOQUEADOS.md"

cp "$fixture/instructions/system.md" "$fixture/instructions/system.md.valid"
printf '\nchanged payload\n' >> "$fixture/instructions/system.md"
expect_rejected "changed captured instruction payload"
mv "$fixture/instructions/system.md.valid" "$fixture/instructions/system.md"

cp "$fixture/SKILL.md" "$fixture/SKILL.md.valid"
sed '/^## Dados sensíveis fornecidos diretamente$/,/^## Execução externa$/ { /^## Execução externa$/!d; }' \
  "$fixture/SKILL.md.valid" > "$fixture/SKILL.md"
expect_rejected "S3 runtime rule for directly supplied sensitive data"
mv "$fixture/SKILL.md.valid" "$fixture/SKILL.md"

cp "$fixture/SKILL.md" "$fixture/SKILL.md.valid"
printf '\nLeia `references/arquivo-ausente.md`.\n' >> "$fixture/SKILL.md"
expect_rejected "dangling packaged-file reference"
mv "$fixture/SKILL.md.valid" "$fixture/SKILL.md"

cp "$fixture/evaluations/rubrics/behavior.md" "$fixture/behavior.md.valid"
sed '/no-guaranteed-claims/d' "$fixture/behavior.md.valid" > \
  "$fixture/evaluations/rubrics/behavior.md"
expect_rejected "missing mandatory release gate"
mv "$fixture/behavior.md.valid" "$fixture/evaluations/rubrics/behavior.md"

cp "$fixture/evaluations/parity/P6.md" "$fixture/P6.md.valid"
sed '/^## Critérios objetivos$/,/^## Gates obrigatórios$/ { /^## Gates obrigatórios$/!d; }' \
  "$fixture/P6.md.valid" > "$fixture/evaluations/parity/P6.md"
expect_rejected "P6 without twelve objective criteria"
mv "$fixture/P6.md.valid" "$fixture/evaluations/parity/P6.md"

ln -s "$fixture/SKILL.md" "$fixture/package-symlink"
cp "$fixture/agent.yaml" "$fixture/agent.yaml.valid"
awk '{ print; if ($0 == "  package:") print "    - package-symlink" }' \
  "$fixture/agent.yaml.valid" > "$fixture/agent.yaml"
expect_rejected "symlink in package allowlist"
mv "$fixture/agent.yaml.valid" "$fixture/agent.yaml"
rm "$fixture/package-symlink"

echo "validate-content-skill tests passed"
