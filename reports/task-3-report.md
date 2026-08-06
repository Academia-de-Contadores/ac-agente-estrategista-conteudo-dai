# Relatório da Task 3 — publicação do template

Data: 2026-08-06

## Resultado

- Remoto: https://github.com/Academia-de-Contadores/academia-contadores-agent-template
- Visibilidade: privada.
- Repositório-template: sim.
- Branch padrão: `main`.
- Push inicial: commit `7d13fe8` (`fix: assign confirmed code owner`).
- `CODEOWNERS`: `@LevyDeSales` cobre `identity/`, `instructions/`,
  `connectors/`, `governance/` e `.github/`.

## Validação local anterior à publicação

Executado a partir do diretório pai:

```bash
bash academia-contadores-agent-template/tests/validate-agent-repo.test.sh
bash academia-contadores-agent-template/scripts/validate-agent-repo.sh
```

Resultado: ambos os comandos terminaram com exit code `0`; o teste estrutural e
o validador imprimiram suas mensagens de aprovação.

## Publicação e configuração

```bash
gh repo create Academia-de-Contadores/academia-contadores-agent-template \
  --private --source academia-contadores-agent-template --remote origin --push
gh api --method PATCH \
  repos/Academia-de-Contadores/academia-contadores-agent-template \
  -F is_template=true
```

O GitHub confirmou `private: true`, `is_template: true` e
`default_branch: main`.

## Ruleset e segurança

A consulta à API de rulesets retornou HTTP 403:

> Upgrade to GitHub Pro or make this repository public to enable this feature.

Por isso não foi possível criar o ruleset de `main` que exigiria pull request,
uma aprovação e o status check `validate`, e bloquearia force push e deleção.
Branch protection também não está disponível para este repositório privado no
plano atual. Portanto, `main` permanece sem proteção; o repositório não foi
tornado público e a limitação não foi contornada.

A tentativa de ativar `secret_scanning` e
`secret_scanning_push_protection` retornou HTTP 422:

> Secret scanning is not available for this repository.

`.github/CODEOWNERS` solicita a revisão de `@LevyDeSales` em pull requests e
`.github/workflows/validate.yml` publica o job `validate`, mas ambos são
sinalização/solicitação de revisão: sem ruleset ou branch protection, não são
gates de merge nem impedem push direto para `main`. O controle preventivo
ativo é local: `scripts/validate-agent-repo.sh` rejeita nomes e artefatos
sensíveis conhecidos, caminhos de índices RAG e arquivos maiores que 5 MB
antes da publicação.
