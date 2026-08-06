# Task 2 report

## Status

Concluída localmente no branch `main`, em repositório Git isolado e sem remote.

## Arquivos

- Manifesto e documentação: `agent.yaml`, `README.md`, `CHANGELOG.md`, `.gitignore`.
- Núcleo: `objectives/`, `identity/` e `instructions/`.
- Exemplos: skill com avaliação, conector RAG com contrato e indisponibilidade,
  perfil versionado e adaptador versionado.
- Governança e GitHub: cinco políticas, `CODEOWNERS`, template de pull request e
  workflow de validação.
- Verificação: `scripts/validate-agent-repo.sh` e
  `tests/validate-agent-repo.test.sh`.

## Evidência RED/GREEN

- RED: `bash tests/validate-agent-repo.test.sh` retornou exit `1`; o trace parou em
  `test -f .../README.md`, confirmando a ausência estrutural esperada.
- GREEN: `bash tests/validate-agent-repo.test.sh && bash scripts/validate-agent-repo.sh`
  retornou exit `0` com `validate-agent-repo tests passed` e
  `agent repository validation passed`.

## Commit da implementação

`29fcd7ad93ecf26aad9f799b017211a01a9c3ded`

## Pontos de atenção

- `CODEOWNERS` usa o owner confirmado `@LevyDeSales` nas cinco áreas protegidas.
- Ruleset, secret scanning e push protection pertencem à Task 3 e não foram criados.
- O validador local e o workflow não dependem de `yq` nem de outra biblioteca
  externa.

## Fix round 1

- RED: `bash tests/validate-agent-repo.test.sh` retornou exit `1` com
  `expected validator to reject an agent manifest without evaluations`.
- GREEN: o mesmo teste e `bash scripts/validate-agent-repo.sh` retornaram exit `0`.
- O workflow agora chama diretamente o validador; `agent.yaml` declara avaliações.
- O validador rejeita variantes de `.env`, chaves privadas e artefatos comuns de
  corpus/vector store, exige versão canônica igual a `agent.version` e aplica o
  limite decimal estrito: 5.000.000 bytes são aceitos e 5.000.001 são rejeitados.

## Correção de CODEOWNERS

- RED: o teste estrutural retornou exit `1`; o trace mostrou `test 0 = 5` para as
  cinco entradas esperadas de `@LevyDeSales`.
- GREEN: o teste estrutural e o validador retornaram exit `0` após substituir o
  time inexistente pelo owner confirmado em todas as áreas protegidas.
