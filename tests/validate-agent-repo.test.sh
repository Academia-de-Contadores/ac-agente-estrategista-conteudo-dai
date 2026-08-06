#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"
validator="$root/scripts/validate-agent-repo.sh"

for f in README.md agent.yaml objectives/mission.md objectives/success-metrics.md \
  objectives/non-goals.md identity/soul.md identity/identity.md instructions/system.md \
  instructions/guardrails.md governance/CONTRIBUTING.md governance/CHANGE-POLICY.md \
  governance/RELEASE-POLICY.md governance/DATA-AND-SECRETS.md \
  governance/RISK-REGISTER.md \
  .github/CODEOWNERS .github/PULL_REQUEST_TEMPLATE.md .github/workflows/validate.yml \
  scripts/validate-agent-repo.sh; do
  test -f "$root/$f"
done

test "$(awk '$2 == "@LevyDeSales" { count++ } END { print count + 0 }' \
  "$root/.github/CODEOWNERS")" = "5"
if grep -qF '@Academia-de-Contadores/agent-owners' "$root/.github/CODEOWNERS"; then
  echo "CODEOWNERS references nonexistent agent-owners team" >&2
  exit 1
fi

bash "$validator"

fixture="$(mktemp -d)"
trap 'rm -rf "$fixture"' EXIT
cp -R "$root/." "$fixture/"
rm -rf "$fixture/.git"
mkdir -p "$fixture/profiles/validation-fixture" \
  "$fixture/adapters/validation-fixture"
printf '%s\n' \
  'schema_version: 1' \
  'name: validation-fixture' \
  'canonical_agent_version: 0.1.0' \
  > "$fixture/profiles/validation-fixture/profile.yaml"
printf '%s\n' \
  'schema_version: 1' \
  'name: validation-fixture' \
  'canonical_agent_version: 0.1.0' \
  'target: validation-fixture' \
  > "$fixture/adapters/validation-fixture/adapter.yaml"

expect_rejected() {
  local name="$1"
  if bash "$fixture/scripts/validate-agent-repo.sh" >/dev/null 2>&1; then
    echo "expected validator to reject $name" >&2
    return 1
  fi
}

cp "$fixture/agent.yaml" "$fixture/agent.yaml.valid"
sed 's/^  id: .*/  id:/' "$fixture/agent.yaml.valid" > "$fixture/agent.yaml"
expect_rejected "an empty agent.id"
mv "$fixture/agent.yaml.valid" "$fixture/agent.yaml"

cp "$fixture/agent.yaml" "$fixture/agent.yaml.valid"
sed '/^evaluations:/,/^profiles:/ { /^profiles:/!d; }' \
  "$fixture/agent.yaml.valid" > "$fixture/agent.yaml"
expect_rejected "an agent manifest without evaluations"
mv "$fixture/agent.yaml.valid" "$fixture/agent.yaml"

for forbidden in .env .env.local id_rsa id_ed25519 signing-key.pem private.key \
  credentials-test.json data.sqlite chroma.sqlite3 events.ndjson corpus.jsonl \
  embeddings.npy vectors.faiss vector.index bundle.zip; do
  : > "$fixture/$forbidden"
  expect_rejected "$forbidden"
  rm "$fixture/$forbidden"
done

mkdir "$fixture/vector_store"
: > "$fixture/vector_store/documents.bin"
expect_rejected "a vector_store artifact directory"
rm -rf "$fixture/vector_store"

dd if=/dev/zero of="$fixture/size-boundary.bin" bs=1000000 count=5 >/dev/null 2>&1
bash "$fixture/scripts/validate-agent-repo.sh" >/dev/null
printf x >> "$fixture/size-boundary.bin"
expect_rejected "a file larger than 5 MB decimal"
rm "$fixture/size-boundary.bin"

cp "$fixture/profiles/validation-fixture/profile.yaml" "$fixture/profile.yaml.valid"
sed 's/^canonical_agent_version:.*/canonical_agent_version: 9.9.9/' \
  "$fixture/profile.yaml.valid" > "$fixture/profiles/validation-fixture/profile.yaml"
expect_rejected "a profile targeting another agent.version"
mv "$fixture/profile.yaml.valid" "$fixture/profiles/validation-fixture/profile.yaml"

cp "$fixture/adapters/validation-fixture/adapter.yaml" "$fixture/adapter.yaml.valid"
sed 's/^canonical_agent_version:.*/canonical_agent_version: 9.9.9/' \
  "$fixture/adapter.yaml.valid" > "$fixture/adapters/validation-fixture/adapter.yaml"
expect_rejected "an adapter targeting another agent.version"
mv "$fixture/adapter.yaml.valid" "$fixture/adapters/validation-fixture/adapter.yaml"

dd if=/dev/zero of="$fixture/too-large.bin" bs=1000000 count=6 >/dev/null 2>&1
expect_rejected "a file larger than 5 MB"
rm "$fixture/too-large.bin"

cp "$fixture/profiles/validation-fixture/profile.yaml" "$fixture/profile.yaml.valid"
sed '/canonical_agent_version:/d' "$fixture/profile.yaml.valid" > \
  "$fixture/profiles/validation-fixture/profile.yaml"
expect_rejected "a profile without canonical_agent_version"
mv "$fixture/profile.yaml.valid" "$fixture/profiles/validation-fixture/profile.yaml"

cp "$fixture/adapters/validation-fixture/adapter.yaml" "$fixture/adapter.yaml.valid"
sed '/canonical_agent_version:/d' "$fixture/adapter.yaml.valid" > \
  "$fixture/adapters/validation-fixture/adapter.yaml"
expect_rejected "an adapter without canonical_agent_version"
mv "$fixture/adapter.yaml.valid" "$fixture/adapters/validation-fixture/adapter.yaml"

echo "validate-agent-repo tests passed"
