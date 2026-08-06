#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"

fail() {
  echo "validation error: $*" >&2
  exit 1
}

required=(
  README.md
  agent.yaml
  objectives/mission.md
  objectives/success-metrics.md
  objectives/non-goals.md
  identity/soul.md
  identity/identity.md
  instructions/system.md
  instructions/guardrails.md
  governance/CONTRIBUTING.md
  governance/CHANGE-POLICY.md
  governance/RELEASE-POLICY.md
  governance/DATA-AND-SECRETS.md
  governance/RISK-REGISTER.md
)

for relative_path in "${required[@]}"; do
  test -f "$root/$relative_path" || fail "missing required file: $relative_path"
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

echo "agent repository validation passed"
