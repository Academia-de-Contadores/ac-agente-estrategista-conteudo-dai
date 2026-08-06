# Estrategista de Conteúdo D.A.I. Oficial

| Campo | Valor |
| --- | --- |
| ID | `ac.estrategista-conteudo-dai` |
| Versão | `0.1.0` |
| Lifecycle | `source-capture` |

Este repositório contém o núcleo canônico deste agente da Academia de Contadores.
Profiles e adapters apenas o recortam ou traduzem para um destino; eles não redefinem o comportamento canônico.

## Início rápido

1. Crie um repositório privado a partir deste template.
2. Atualize `agent.yaml`, `objectives/`, `identity/` e `instructions/` para o
   agente real.
3. Registre capacidades em `skills/`, conteúdo curado em `knowledge/` e contratos
   externos em `connectors/`; nunca registre credenciais.
4. Adicione avaliações para cada mudança comportamental e execute:

   ```bash
   bash tests/validate-agent-repo.test.sh
   bash scripts/validate-agent-repo.sh
   ```

5. Siga o processo de contribuição antes de abrir um pull request.

## Guias do repositório

- [Como usar e reconstruir o agente](HOW-TO-USE.md)
- [Estrutura e destino de cada arquivo](docs/REPOSITORY-STRUCTURE.md)
- [Como contribuir](governance/CONTRIBUTING.md)
- [Política de dados e segredos](governance/DATA-AND-SECRETS.md)
- [Política de mudanças](governance/CHANGE-POLICY.md)

## Proteções no GitHub

O repositório remoto é privado e está marcado como template. No plano atual da
organização, a API do GitHub não disponibiliza rulesets para este repositório
privado (HTTP 403) nem secret scanning/push protection (HTTP 422). Enquanto
essas proteções remotas não estiverem disponíveis, `main` permanece sem
proteção: rulesets e branch protection não estão disponíveis para repositórios
privados no plano atual. `CODEOWNERS` e o workflow `validate` apenas sinalizam
e solicitam revisão; não são gates de merge. O controle preventivo ativo é a
validação local por `scripts/validate-agent-repo.sh`, que bloqueia arquivos
proibidos e arquivos maiores que 5 MB antes da publicação. Consulte
`reports/task-3-report.md` para a evidência e os limites exatos.
