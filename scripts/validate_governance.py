#!/usr/bin/env python3
"""Validate central governance contracts or one curated agent repository."""

from __future__ import annotations

import argparse
import csv
import hashlib
import json
import os
from pathlib import Path, PurePosixPath
import re
import sys
from typing import Any

try:
    import yaml
    from jsonschema import Draft202012Validator
    from jsonschema.exceptions import SchemaError
except ImportError as exc:  # pragma: no cover - exercised by deployment setup
    raise SystemExit(f"VALIDATOR_DEPENDENCY_MISSING: {exc}") from exc


SLUG = re.compile(r"^[a-z0-9]+(?:-[a-z0-9]+)*$")
SHA256 = re.compile(r"^[a-f0-9]{64}$")
GOVERNANCE_ROOT = Path(__file__).resolve().parents[1]
EXTERNAL_STATES = ("configured_external", "fingerprint_pass", "e2e_pass", "published")
REQUIRED_CENTRAL_FILES = (
    "catalog/agents.yaml",
    "schemas/agent.schema.json",
    "schemas/knowledge-manifest.schema.json",
    "schemas/evidence-status.schema.json",
    "sync/source-map.yaml",
    "sync/allowlist.yaml",
    "shared/guardrails/global.yaml",
    "contracts/levy-comment-decision.yaml",
    "templates/agent-repository/README.md",
    "templates/agent-repository/agent.yaml",
    "templates/agent-repository/knowledge/manifest.yaml",
    "templates/agent-repository/evidence/status.yaml",
    "templates/agent-repository/.github/workflows/validate-agent.yml.template",
    "reports/2026-08-07-knowledge-packs/levy-comments-matrix.csv",
    ".github/CODEOWNERS",
    ".github/PULL_REQUEST_TEMPLATE/central-governance.md",
    ".github/PULL_REQUEST_TEMPLATE/agent-repository.md",
    ".github/workflows/validate-governance.yml",
    ".github/workflows/reusable-validate-agent.yml",
    "docs/governance/README.md",
)


class ValidationFailure(Exception):
    def __init__(self, code: str, detail: str) -> None:
        super().__init__(detail)
        self.code = code
        self.detail = detail


def reject(code: str, detail: str) -> None:
    raise ValidationFailure(code, detail)


def load_document(path: Path) -> dict[str, Any]:
    try:
        payload = json.loads(path.read_text(encoding="utf-8"))
    except json.JSONDecodeError:
        try:
            payload = yaml.safe_load(path.read_text(encoding="utf-8"))
        except yaml.YAMLError as exc:
            reject("INVALID_YAML", f"{path}: {exc}")
    except (OSError, UnicodeError) as exc:
        reject("DOCUMENT_READ_ERROR", f"{path}: {exc}")
    if not isinstance(payload, dict):
        reject("INVALID_DOCUMENT", f"{path} must contain a mapping")
    return payload


def validate_schema(payload: dict[str, Any], schema_name: str) -> None:
    schema_path = GOVERNANCE_ROOT / "schemas" / schema_name
    require_file(schema_path, "SCHEMA_MISSING")
    schema = json.loads(schema_path.read_text(encoding="utf-8"))
    errors = sorted(Draft202012Validator(schema).iter_errors(payload), key=lambda error: list(error.absolute_path))
    if errors:
        error = errors[0]
        location = ".".join(str(part) for part in error.absolute_path) or "<root>"
        reject("SCHEMA_VALIDATION_ERROR", f"{schema_name}:{location}: {error.message}")


def load_content_policy() -> tuple[set[str], int]:
    allowlist = load_document(GOVERNANCE_ROOT / "sync" / "allowlist.yaml")
    guardrail = load_document(GOVERNANCE_ROOT / "shared" / "guardrails" / "global.yaml")
    allowed = set(allowlist.get("allowed_extensions", []))
    knowledge = guardrail.get("knowledge", {})
    forbidden = set(knowledge.get("forbidden_extensions", [])) if isinstance(knowledge, dict) else set()
    if not allowed or allowed & forbidden:
        reject("EXTENSION_POLICY_INVALID", f"allowed={sorted(allowed)} forbidden={sorted(forbidden)}")
    max_uploads = knowledge.get("max_upload_files") if isinstance(knowledge, dict) else None
    if not isinstance(max_uploads, int):
        reject("GUARDRAIL_INVALID", "knowledge.max_upload_files")
    return allowed, max_uploads


def require_file(path: Path, code: str = "REQUIRED_FILE_MISSING") -> None:
    if not path.is_file():
        reject(code, str(path))


def iter_package_paths(root: Path) -> list[Path]:
    paths: list[Path] = []
    for package_dir in (root / "prompt", root / "knowledge", root / "evidence"):
        if not package_dir.exists():
            continue
        for current, directories, filenames in os.walk(package_dir, followlinks=False):
            current_path = Path(current)
            for name in directories + filenames:
                paths.append(current_path / name)
    return paths


def validate_package_tree(root: Path) -> None:
    for path in iter_package_paths(root):
        relative = path.relative_to(root)
        if path.is_symlink():
            reject("SYMLINK_FORBIDDEN", relative.as_posix())
        if any(part in {".git", ".obsidian"} for part in relative.parts):
            reject("RESTRICTED_PATH", relative.as_posix())


def safe_relative_path(raw_path: object) -> PurePosixPath:
    if not isinstance(raw_path, str):
        reject("INVALID_MANIFEST_PATH", repr(raw_path))
    relative = PurePosixPath(raw_path)
    if relative.is_absolute() or ".." in relative.parts:
        reject("INVALID_MANIFEST_PATH", raw_path)
    if len(relative.parts) < 3 or relative.parts[:2] not in {
        ("knowledge", "source"),
        ("knowledge", "upload"),
    }:
        reject("INVALID_MANIFEST_PATH", raw_path)
    return relative


def validate_text_content(path: Path, relative: PurePosixPath, allowed_extensions: set[str]) -> bytes:
    if path.suffix.lower() not in allowed_extensions:
        reject("FORBIDDEN_EXTENSION", relative.as_posix())
    try:
        content = path.read_bytes()
    except OSError as exc:
        reject("MANIFEST_FILE_MISSING", f"{relative}: {exc}")
    if b"\x00" in content:
        reject("BINARY_CONTENT", relative.as_posix())
    try:
        text = content.decode("utf-8")
    except UnicodeDecodeError:
        reject("BINARY_CONTENT", relative.as_posix())
    if re.search(r"(?i)(?:OPENAI_API_KEY\s*=\s*|\bsk-(?:proj-)?)[A-Za-z0-9_-]{16,}", text):
        reject("SECRET_DETECTED", relative.as_posix())
    if re.search(r"\b\d{3}\.\d{3}\.\d{3}-\d{2}\b", text) or re.search(
        r"\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}\b", text, re.IGNORECASE
    ):
        reject("PII_DETECTED", relative.as_posix())
    return content


def validate_agent_repository(root: Path) -> None:
    root = root.resolve()
    validate_package_tree(root)
    agent_path = root / "agent.yaml"
    manifest_path = root / "knowledge" / "manifest.yaml"
    evidence_path = root / "evidence" / "status.yaml"
    for path in (agent_path, manifest_path, evidence_path):
        require_file(path)

    agent = load_document(agent_path)
    manifest = load_document(manifest_path)
    evidence = load_document(evidence_path)
    allowed_extensions, max_uploads = load_content_policy()

    agent_id = agent.get("id")
    if not isinstance(agent_id, str) or not SLUG.fullmatch(agent_id):
        reject("INVALID_AGENT_ID", repr(agent_id))
    aliases = agent.get("aliases")
    if not isinstance(aliases, list) or not aliases or any(
        not isinstance(alias, str) or not SLUG.fullmatch(alias) for alias in aliases
    ):
        reject("INVALID_ALIAS", repr(aliases))
    if agent.get("repository") != f"ac-agente-{agent_id}":
        reject("REPOSITORY_MISMATCH", repr(agent.get("repository")))
    if agent.get("owner") != "@G09c":
        reject("OWNER_MISMATCH", repr(agent.get("owner")))
    validate_schema(agent, "agent.schema.json")

    prompt_path = agent.get("prompt_path")
    if not isinstance(prompt_path, str) or not re.fullmatch(r"prompt/[^/]+\.md", prompt_path):
        reject("INVALID_PROMPT_PATH", repr(prompt_path))
    prompt = root / prompt_path
    require_file(prompt, "PROMPT_MISSING")
    prompt_content = validate_text_content(prompt, PurePosixPath(prompt_path), allowed_extensions)
    prompt_provenance_path = root / "evidence" / "prompt-provenance.yaml"
    if prompt_provenance_path.exists():
        prompt_provenance = load_document(prompt_provenance_path)
        if prompt_provenance.get("agent_id") != agent_id:
            reject("PROMPT_PROVENANCE_AGENT_MISMATCH", str(prompt_provenance_path))
        if prompt_provenance.get("path") != prompt_path:
            reject("PROMPT_PROVENANCE_PATH_MISMATCH", str(prompt_provenance_path))
        if prompt_provenance.get("snapshot_status") != agent.get("prompt_comparison", {}).get("status"):
            reject("PROMPT_PROVENANCE_STATUS_MISMATCH", str(prompt_provenance_path))
        if prompt_provenance.get("external_configuration") != "not_verified":
            reject("PROMPT_EXTERNAL_STATE_PROMOTED", str(prompt_provenance_path))
        if prompt_provenance.get("sha256") != hashlib.sha256(prompt_content).hexdigest():
            reject("PROMPT_HASH_MISMATCH", prompt_path)

    if manifest.get("agent_id") != agent_id:
        reject("MANIFEST_AGENT_MISMATCH", repr(manifest.get("agent_id")))
    counts = manifest.get("counts")
    files = manifest.get("files")
    if not isinstance(counts, dict) or not isinstance(files, list):
        reject("INVALID_MANIFEST", "counts and files are required")
    active_upload = counts.get("active_upload")
    if not isinstance(active_upload, int) or active_upload < 0:
        reject("INVALID_UPLOAD_COUNT", repr(active_upload))
    if active_upload > max_uploads:
        reject("UPLOAD_LIMIT", str(active_upload))
    validate_schema(manifest, "knowledge-manifest.schema.json")

    actual_files: set[PurePosixPath] = set()
    for governed_dir in (root / "knowledge" / "source", root / "knowledge" / "upload"):
        if not governed_dir.exists():
            continue
        for current, _, filenames in os.walk(governed_dir, followlinks=False):
            for filename in sorted(filenames):
                path = Path(current) / filename
                relative = PurePosixPath(path.relative_to(root).as_posix())
                validate_text_content(path, relative, allowed_extensions)
                actual_files.add(relative)

    seen_paths: set[PurePosixPath] = set()
    for entry in files:
        if not isinstance(entry, dict):
            reject("INVALID_MANIFEST_ENTRY", repr(entry))
        relative = safe_relative_path(entry.get("path"))
        if relative in seen_paths:
            reject("DUPLICATE_MANIFEST_PATH", relative.as_posix())
        seen_paths.add(relative)

    unmanifested = sorted(actual_files - seen_paths, key=str)
    if unmanifested:
        reject("UNMANIFESTED_FILE", unmanifested[0].as_posix())
    missing = sorted(seen_paths - actual_files, key=str)
    if missing:
        reject("MANIFEST_FILE_MISSING", missing[0].as_posix())

    actual_uploads = 0
    for entry in files:
        relative = safe_relative_path(entry.get("path"))
        if re.search(r"(?:^|[-_])(prompt|instructions?)(?:[-_.]|$)", relative.name, re.IGNORECASE):
            reject("PROMPT_IN_KNOWLEDGE", relative.as_posix())
        role = entry.get("role")
        upload = entry.get("upload")
        if upload is not (role == "upload_active"):
            reject("ROLE_UPLOAD_MISMATCH", relative.as_posix())
        expected_directory = "upload" if role == "upload_active" else "source"
        if relative.parts[1] != expected_directory:
            reject("ROLE_DIRECTORY_MISMATCH", relative.as_posix())
        content = validate_text_content(root.joinpath(*relative.parts), relative, allowed_extensions)
        expected_hash = entry.get("sha256")
        if not isinstance(expected_hash, str) or not SHA256.fullmatch(expected_hash):
            reject("INVALID_HASH", relative.as_posix())
        actual_hash = hashlib.sha256(content).hexdigest()
        if actual_hash != expected_hash:
            reject("HASH_MISMATCH", relative.as_posix())
        if entry.get("role") == "upload_active" and entry.get("upload") is True:
            actual_uploads += 1
    if actual_uploads != active_upload:
        reject("UPLOAD_COUNT_MISMATCH", f"declared={active_upload} actual={actual_uploads}")

    for state in EXTERNAL_STATES:
        if evidence.get(state) != "not_verified":
            reject("EXTERNAL_STATE_PROMOTED", f"{state}={evidence.get(state)!r}")
    validate_schema(evidence, "evidence-status.schema.json")

    print(f"AGENT_VALIDATION_OK id={agent_id} uploads={actual_uploads} files={len(files)}")


def validate_levy_matrix(path: Path, evidence_root: Path) -> int:
    require_file(path, "LEVY_MATRIX_MISSING")
    contract = load_document(GOVERNANCE_ROOT / "contracts" / "levy-comment-decision.yaml")
    with path.open(encoding="utf-8", newline="") as handle:
        reader = csv.DictReader(handle)
        rows = list(reader)
    if not rows:
        reject("LEVY_MATRIX_EMPTY", str(path))
    required_columns = set(contract.get("required_columns", []))
    if not required_columns.issubset(set(reader.fieldnames or [])):
        reject("LEVY_COLUMNS_MISSING", str(path))
    allowed_statuses = {
        "scope_status": set(contract.get("allowed_scope_statuses", [])),
        "resolution_status": set(contract.get("allowed_resolution_statuses", [])),
        "decision_status": set(contract.get("allowed_decision_statuses", [])),
    }
    for index, row in enumerate(rows, start=2):
        if not row.get("technical_decision", "").strip():
            reject("LEVY_DECISION_MISSING", f"{path}:{index}")
        if not row.get("evidence_reference", "").strip():
            reject("LEVY_EVIDENCE_MISSING", f"{path}:{index}")
        for field, allowed in allowed_statuses.items():
            if row.get(field) not in allowed:
                reject("LEVY_STATUS_INVALID", f"{path}:{index}:{field}={row.get(field)!r}")
        evidence_reference = PurePosixPath(row["evidence_reference"])
        if evidence_reference.is_absolute() or ".." in evidence_reference.parts:
            reject("LEVY_EVIDENCE_NOT_FOUND", f"{path}:{index}")
        if not evidence_root.joinpath(*evidence_reference.parts).is_file():
            reject("LEVY_EVIDENCE_NOT_FOUND", f"{path}:{index}:{evidence_reference}")
        digest = row.get("comment_body_sha256", "")
        if not SHA256.fullmatch(digest):
            reject("LEVY_HASH_INVALID", f"{path}:{index}")
        if not row.get("author_login", "").strip():
            reject("LEVY_AUTHOR_MISSING", f"{path}:{index}")
    return len(rows)


def validate_workflow(path: Path) -> None:
    text = path.read_text(encoding="utf-8")
    if "permissions:\n  contents: read\n" not in text:
        reject("WORKFLOW_PERMISSIONS", str(path))
    uses = re.findall(r"^\s*-?\s*uses:\s*([^\s#]+)", text, re.MULTILINE)
    if not uses:
        reject("WORKFLOW_ACTION_MISSING", str(path))
    for action in uses:
        if not re.fullmatch(r"actions/(?:checkout|setup-python)@[a-f0-9]{40}", action):
            reject("WORKFLOW_ACTION_UNPINNED", f"{path}: {action}")


def validate_central(root: Path, levy_override: Path | None) -> None:
    root = root.resolve()
    for relative in REQUIRED_CENTRAL_FILES:
        require_file(root / relative, "CENTRAL_FILE_MISSING")

    for schema_path in sorted((root / "schemas").glob("*.schema.json")):
        schema = json.loads(schema_path.read_text(encoding="utf-8"))
        if schema.get("$schema") != "https://json-schema.org/draft/2020-12/schema":
            reject("SCHEMA_DRAFT_MISMATCH", str(schema_path))
        if schema.get("type") != "object" or not schema.get("required"):
            reject("SCHEMA_CONTRACT_INVALID", str(schema_path))
        try:
            Draft202012Validator.check_schema(schema)
        except SchemaError as exc:
            reject("SCHEMA_CONTRACT_INVALID", f"{schema_path}: {exc.message}")

    load_content_policy()

    catalog = (root / "catalog" / "agents.yaml").read_text(encoding="utf-8")
    agent_ids = re.findall(r"^  - id: ([a-z0-9-]+)$", catalog, re.MULTILINE)
    repositories = re.findall(r"^    repository: (ac-agente-[a-z0-9-]+)$", catalog, re.MULTILINE)
    if len(agent_ids) != 9 or len(set(agent_ids)) != 9 or len(repositories) != 9:
        reject("CENTRAL_CATALOG_INVALID", f"agents={len(agent_ids)} repositories={len(repositories)}")
    if "owner: \"@G09c\"" not in catalog:
        reject("CENTRAL_OWNER_MISSING", "catalog/agents.yaml")

    source_map = (root / "sync" / "source-map.yaml").read_text(encoding="utf-8")
    if source_map.count("source_read_only: true") != 9 or source_map.count("promotion_authorized: false") != 9:
        reject("SOURCE_MAP_POLICY_INVALID", "sync/source-map.yaml")
    for contract in ("status: pending_human_review", "source_policy: vault_read_only"):
        if contract not in source_map:
            reject("SOURCE_MAP_POLICY_INVALID", contract)

    template = (root / "templates" / "agent-repository" / "README.md").read_text(encoding="utf-8")
    for contract in ("prompt/instructions.md", "knowledge/manifest.yaml", "SHA-256", "20"):
        if contract not in template:
            reject("TEMPLATE_CONTRACT_INVALID", contract)

    codeowners = (root / ".github" / "CODEOWNERS").read_text(encoding="utf-8")
    if not re.search(r"^\*\s+@G09c\s*$", codeowners, re.MULTILINE):
        reject("CODEOWNER_MISSING", "@G09c")
    validate_workflow(root / ".github" / "workflows" / "validate-governance.yml")
    validate_workflow(root / ".github" / "workflows" / "reusable-validate-agent.yml")

    levy_path = levy_override or root / "reports" / "2026-08-07-knowledge-packs" / "levy-comments-matrix.csv"
    levy_count = validate_levy_matrix(levy_path, root)
    print(f"CENTRAL_VALIDATION_OK agents={len(agent_ids)} levy_comments={levy_count}")


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("root", type=Path, help="central or agent repository root")
    parser.add_argument("--central", action="store_true", help="validate central governance contracts")
    parser.add_argument("--levy-matrix", type=Path, help="override the Levy matrix path")
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    try:
        if args.central:
            validate_central(args.root, args.levy_matrix)
        elif args.levy_matrix:
            validate_levy_matrix(args.levy_matrix, args.root.resolve())
            print("LEVY_VALIDATION_OK")
        else:
            validate_agent_repository(args.root)
    except ValidationFailure as exc:
        print(f"{exc.code}: {exc.detail}")
        return 1
    except (OSError, UnicodeError, json.JSONDecodeError) as exc:
        print(f"VALIDATION_ERROR: {exc}")
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
