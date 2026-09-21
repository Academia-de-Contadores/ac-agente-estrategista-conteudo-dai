#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"

fail() {
  echo "validation error: $*" >&2
  exit 1
}

required=(
  README.md
  HOW-TO-USE.md
  docs/REPOSITORY-STRUCTURE.md
  agent.yaml
  objectives/mission.md
  objectives/success-metrics.md
  objectives/non-goals.md
  identity/soul.md
  identity/identity.md
  instructions/system.md
  instructions/guardrails.md
  instructions/workflows/main.md
  SKILL.md
  skill-runtime.yaml
  agents/openai.yaml
  references/evidence-policy.md
  references/content-outputs.md
  references/approval-policy.md
  evaluations/parity/questions.yaml
  reports/online-parity-2026-09-21.md
  reports/validation-2026-09-21.md
  scripts/validate-content-skill.rb
  governance/CONTRIBUTING.md
  governance/CHANGE-POLICY.md
  governance/RELEASE-POLICY.md
  governance/DATA-AND-SECRETS.md
  governance/RISK-REGISTER.md
)

for relative_path in "${required[@]}"; do
  test -f "$root/$relative_path" || fail "missing required file: $relative_path"
done

required_structure_sections=(
  "Manifesto agent.yaml"
  "Arquivos ignorados"
  GitHub
  "Documentos raiz"
  Objectives
  Identity
  Instructions
  Skills
  Knowledge
  Connectors
  Adapters
  Profiles
  "Evaluations e tests"
  Scripts
  Governance
  "Decisions, docs e reports"
  Relations
)

for section in "${required_structure_sections[@]}"; do
  grep -Fqx "## $section" "$root/docs/REPOSITORY-STRUCTURE.md" || \
    fail "missing required repository-structure section: $section"
done

read_agent_scalar() {
  local field="$1"
  awk '
    /^agent:[[:space:]]*$/ { in_agent = 1; next }
    in_agent && /^[^[:space:]]/ { exit }
    in_agent && index($0, "  " field ":") == 1 {
      value = $0
      sub("^  " field ":[[:space:]]*", "", value)
      sub(/[[:space:]]*#.*/, "", value)
      gsub(/^[[:space:]"'\'' ]+|[[:space:]"'\'' ]+$/, "", value)
      print value
      exit
    }
  ' field="$field" "$root/agent.yaml"
}

agent_id="$(read_agent_scalar id || true)"
test -n "$agent_id" || fail "agent.id must not be empty"

agent_version="$(read_agent_scalar version || true)"
test -n "$agent_version" || fail "agent.version must not be empty"

awk '
  /^evaluations:[[:space:]]*$/ { in_evaluations = 1; next }
  in_evaluations && /^[^[:space:]]/ { exit(found ? 0 : 1) }
  in_evaluations && /^  -[[:space:]]*[^[:space:]]/ { found = 1 }
  END { exit(found ? 0 : 1) }
' "$root/agent.yaml" || fail "evaluations must contain at least one reference"

evaluation_is_referenced() {
  local relative_path="$1"
  grep -Fqx "  - $relative_path" "$root/agent.yaml"
}

scenario_field_is_nonempty() {
  local path="$1"
  local field="$2"

  awk -v heading="## $field" '
    $0 == heading {
      found = 1
      next
    }
    found && /^##[[:space:]]/ {
      stopped = 1
    }
    found && !stopped && $0 !~ /^[[:space:]]*$/ {
      nonempty = 1
    }
    END {
      exit(found && nonempty ? 0 : 1)
    }
  ' "$path"
}

validate_scenario_file() {
  local relative_path="$1"
  local scenario_id="$2"
  local path="$root/$relative_path"
  local field

  test -f "$path" || fail "missing Task 5 scenario: $relative_path"
  grep -Eq "^# ${scenario_id}[[:space:]]+—[[:space:]]+.+$" "$path" || \
    fail "scenario must have a nonempty $scenario_id title: $relative_path"
  evaluation_is_referenced "$relative_path" || \
    fail "scenario is not referenced by agent.yaml: $relative_path"

  for field in "Entrada" "Saída esperada" "Evidência" "Falha"; do
    scenario_field_is_nonempty "$path" "$field" || \
      fail "scenario field '$field' must be present and nonempty: $relative_path"
  done
}

validate_scenario_group() {
  local directory="$1"
  local prefix="$2"
  local expected_count="$3"
  local label="$4"
  local count index relative_path

  count="$(
    find "$root/$directory" -maxdepth 1 -type f -name "${prefix}*.md" |
      wc -l |
      tr -d '[:space:]'
  )"
  test "$count" = "$expected_count" || \
    fail "$label must contain exactly $expected_count ${prefix} scenario files"

  index=1
  while test "$index" -le "$expected_count"; do
    relative_path="$directory/${prefix}${index}.md"
    validate_scenario_file "$relative_path" "${prefix}${index}"
    index=$((index + 1))
  done
}

validate_scenario_group evaluations/scenarios T 5 "core task coverage"
validate_scenario_group evaluations/regression H 3 "scope and handoff coverage"
validate_scenario_group evaluations/security S 3 "security coverage"

if awk '
  /^connectors:[[:space:]]*$/ { in_connectors = 1; next }
  in_connectors && /^[^[:space:]]/ { exit }
  in_connectors && /rag|searchDayRagCorpus/ { found = 1 }
  END { exit(found ? 0 : 1) }
' "$root/agent.yaml"; then
  validate_scenario_group evaluations/regression C 1 \
    "connector-unavailable coverage"
else
  connector_scenario_count="$(
    find "$root/evaluations/regression" -maxdepth 1 -type f -name 'C*.md' |
      wc -l |
      tr -d '[:space:]'
  )"
  test "$connector_scenario_count" = "0" || \
    fail "connector-unavailable scenarios require a declared RAG connector"
fi

while IFS= read -r -d '' path; do
  name="$(basename "$path")"
  relative_path="${path#"$root/"}"
  case "$name" in
    .env|.env.*|id_rsa|id_dsa|id_ecdsa|id_ed25519|*.pem|*.key|*.p12|*.pfx|\
    credentials*.json|*.sqlite|*.sqlite3|*.ndjson|*.jsonl|*.npy|*.npz|*.faiss|\
    *.index|*.hnsw|*.parquet|corpus*.json|corpus*.csv|*.zip)
      fail "forbidden file: $relative_path"
      ;;
  esac

  case "/$relative_path/" in
    */chroma/*|*/.chroma/*|*/vector_store/*|*/vectorstore/*)
      fail "forbidden RAG artifact path: $relative_path"
      ;;
  esac

  size="$(wc -c < "$path" | tr -d '[:space:]')"
  if [ "$size" -gt 5000000 ]; then
    fail "file exceeds 5 MB: $relative_path"
  fi
done < <(find "$root" -type f ! -path "$root/.git/*" -print0)

validate_versioned_components() {
  local collection="$1"
  local manifest="$2"
  local component_dir component_manifest version

  while IFS= read -r -d '' component_dir; do
    component_manifest="$component_dir/$manifest"
    test -f "$component_manifest" || \
      fail "missing $manifest in ${component_dir#"$root/"}"

    version="$({
      awk '
        /^canonical_agent_version:[[:space:]]*/ {
          value = $0
          sub(/^canonical_agent_version:[[:space:]]*/, "", value)
          sub(/[[:space:]]*#.*/, "", value)
          gsub(/^[[:space:]"'\'' ]+|[[:space:]"'\'' ]+$/, "", value)
          print value
          exit
        }
      ' "$component_manifest"
    } || true)"
    test -n "$version" || \
      fail "canonical_agent_version must not be empty in ${component_manifest#"$root/"}"
    test "$version" = "$agent_version" || \
      fail "canonical_agent_version must equal agent.version in ${component_manifest#"$root/"}"
  done < <(find "$root/$collection" -mindepth 1 -maxdepth 1 -type d -print0)
}

validate_versioned_components profiles profile.yaml
validate_versioned_components adapters adapter.yaml

ruby "$root/scripts/validate-content-skill.rb"

echo "agent repository validation passed"
