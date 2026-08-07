#!/usr/bin/env bash
set -euo pipefail
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
bash "$root/scripts/validate-agent-repo.sh"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
cp -R "$root/." "$tmp/repo"
find "$tmp/repo" -name .git -type d -prune -exec rm -rf {} + 2>/dev/null || true
upload="$(find "$tmp/repo/knowledge/upload" -type f | sort | head -1)"
printf '
drift
' >> "$upload"
output="$(python3 "$tmp/repo/scripts/validate_governance.py" "$tmp/repo" || true)"
grep -q 'HASH_MISMATCH' <<< "$output"
tmp_prompt="$(mktemp -d)"
cp -R "$root/." "$tmp_prompt/repo"
find "$tmp_prompt/repo" -name .git -type d -prune -exec rm -rf {} + 2>/dev/null || true
printf '
drift
' >> "$tmp_prompt/repo/prompt/instructions.md"
prompt_output="$(python3 "$tmp_prompt/repo/scripts/validate_governance.py" "$tmp_prompt/repo" || true)"
grep -q 'PROMPT_HASH_MISMATCH' <<< "$prompt_output"
rm -rf "$tmp_prompt"
