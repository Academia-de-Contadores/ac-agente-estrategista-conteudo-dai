# Template canônico de agente

Este repositório é a base agnóstica de plataforma para agentes da Academia de
Contadores. O núcleo canônico fica em `objectives/`, `identity/` e
`instructions/`; skills descrevem capacidades reutilizáveis, conectores
descrevem integrações externas, perfis restringem uma versão canônica e
adaptadores traduzem essa versão para um destino sem redefinir seu comportamento.

## Como usar

1. Crie um repositório privado a partir deste template.
2. Substitua os valores de exemplo em `agent.yaml` e nos documentos canônicos.
3. Mantenha cada perfil e adaptador vinculado por `canonical_agent_version`.
4. Adicione uma avaliação para toda mudança comportamental.
5. Execute `bash tests/validate-agent-repo.test.sh` antes de abrir um pull request.

O Git é a fonte de verdade. Segredos, conversas, dados de clientes, logs,
corpora ou índices RAG e exportações operacionais não podem ser versionados.
Endpoints privados e credenciais são fornecidos em runtime por variáveis de
ambiente; somente seus nomes pertencem aos contratos do repositório.

Consulte `governance/` para classificação de mudanças, revisão, versionamento,
tratamento de dados e riscos.

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
