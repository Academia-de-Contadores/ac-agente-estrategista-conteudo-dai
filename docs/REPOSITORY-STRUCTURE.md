# Estrutura do repositório de agente

Este guia é a referência normativa para decidir onde cada artefato do agente vive.
O conteúdo canônico é independente da plataforma; o runtime recebe uma tradução
controlada dele.

## Árvore completa

```text
.
├── agent.yaml
├── objectives/                 # missão, métricas e não-objetivos
├── identity/                   # papel, autoridade, voz e valores
├── instructions/               # prompt, guardrails e workflows permanentes
├── skills/                     # procedimentos acionáveis e suas avaliações
├── knowledge/                  # fontes curadas disponíveis ao modelo
├── connectors/                 # contratos de sistemas externos, Actions e RAG
├── adapters/                   # tradução do núcleo para cada plataforma
├── profiles/                   # recortes aprovados do mesmo agente
├── evaluations/                # cenários, rubricas, segurança e regressão
├── tests/                      # verificações executáveis do repositório
├── scripts/                    # manutenção e validação
├── governance/                 # políticas, contribuição, release e riscos
├── decisions/                  # ADRs de decisões duradouras
├── docs/                       # documentação humana de operação e arquitetura
├── reports/                    # evidências datadas de execuções e auditorias
├── relations/                  # manifestos de relações externas, quando houver
├── .gitignore                  # regras para não versionar arquivos locais
├── .github/                    # owners, modelo de PR e automações GitHub
├── README.md                   # porta de entrada
├── HOW-TO-USE.md               # manual operacional
└── CHANGELOG.md                # histórico de mudanças relevantes
```

A árvore é completa no nível raiz dos arquivos versionados e deliberadamente
abreviada nas subárvores: cada entrada terminada em `/` representa seu conteúdo
interno, descrito nas seções abaixo. Quando uma árvore usar `...`, ele terá o mesmo
sentido — itens internos não enumerados, e não caminhos alternativos. Pastas vazias
usam `.gitkeep` até receberem conteúdo. `relations/` não deve ser criada vazia:
use-a somente com manifesto de tipo, alvo, finalidade e dependência.

## Fronteiras que não podem se confundir

| Pares | Use o primeiro quando | Use o segundo quando | Exemplo |
| --- | --- | --- | --- |
| `docs/` / `knowledge/` | ensina uma pessoa a manter o repositório | o modelo consulta o conteúdo para responder | manual / PDF de legislação |
| `instructions/` / `skills/` | a regra vale sempre | há procedimento acionável específico | guardrail / briefing |
| `connectors/` / `adapters/` | descreve acesso externo | empacota para uma plataforma | OpenAPI / configuração ChatGPT |
| `decisions/` / `reports/` | registra escolha duradoura | registra execução ou auditoria datada | ADR / relatório |

## Objectives

- **O que é:** `objectives/` explica por que o agente existe e como medir sucesso.
- **Entra:** `mission.md`, `success-metrics.md` e `non-goals.md`.
- **Não entra:** personalidade, prompt, procedimento ou integração.
- **Exemplo:** métrica para respostas com evidência verificável.
- **Avaliação ou revisão:** owner revisa; avalie e versione se mudar escopo ou sucesso.

## Identity

- **O que é:** `identity/` define papel, domínio, autoridade, voz e valores.
- **Entra:** `identity.md` e `soul.md`.
- **Não entra:** regras detalhadas, Knowledge ou segredos.
- **Exemplo:** tom profissional e limites de autoridade em `soul.md`.
- **Avaliação ou revisão:** soul, autoridade ou domínio são críticos; exigem owner e regressão.

## Instructions

- **O que é:** `instructions/` determina como o agente atua permanentemente.
- **Entra:** `system.md`, `guardrails.md` e workflows gerais.
- **Não entra:** capability sob demanda (skill) ou schema de API.
- **Exemplo:** prompt em `instructions/system.md` e regras em `guardrails.md`.
- **Avaliação ou revisão:** toda mudança comportamental exige avaliação; guardrail exige segurança.

## Skills

- **O que é:** `skills/` reúne procedimentos reutilizáveis e acionáveis.
- **Entra:** `skills/<nome>/SKILL.md` e `skills/<nome>/evaluations/`.
- **Não entra:** regra de toda resposta, dado bruto ou credencial.
- **Exemplo:** `skills/example-skill/SKILL.md` para estruturar briefing.
- **Avaliação ou revisão:** cada mudança requer cenário direcionado e regressão aplicável.

## Knowledge

- **O que é:** `knowledge/` é a base curada que pode ser fornecida ao modelo.
- **Entra:** `.md`, `.txt`, `.pdf`, `.csv`, JSON de referência, imagens, planilhas e manifesto de fonte/data/licença/hash.
- **Não entra:** manual de manutenção, segredo, dado de cliente, conversa, log, corpus ou índice vetorial.
- **Exemplo:** PDF de legislação com manifesto de proveniência.
- **Avaliação ou revisão:** avalie respostas e segurança; revise licença, classe de dados e tamanho.

## Connectors

- **O que é:** `connectors/` contém contratos de sistemas externos, APIs, Actions e RAG.
- **Entra:** schema, OpenAPI, exemplo sintético, permissões, fallback e testes.
- **Não entra:** token, endpoint privado, corpus, índice RAG, log ou segredo de runtime.
- **Exemplo:** `connectors/actions/<nome>/openapi.yaml` ou `connectors/rag/contract.yaml`.
- **Avaliação ou revisão:** teste indisponibilidade/autorização; escrita externa e dados sensíveis são críticos.

## Adapters

- **O que é:** `adapters/` traduz o agente canônico para um destino de execução.
- **Entra:** `adapter.yaml`, limitações documentadas e `canonical_agent_version`.
- **Não entra:** redefinição de missão, identidade, prompt canônico ou segredo.
- **Exemplo:** `adapters/example-platform/adapter.yaml`.
- **Avaliação ou revisão:** verifique equivalência e versão; revise novas permissões ou riscos.

## Profiles

- **O que é:** `profiles/` cria recortes por público, risco ou canal.
- **Entra:** `profile.yaml`, restrições e `canonical_agent_version` igual a `agent.version`.
- **Não entra:** novo agente independente ou mudança silenciosa do núcleo.
- **Exemplo:** `profiles/example-public-safe/profile.yaml`.
- **Avaliação ou revisão:** teste os limites; revise público, dados, autoridade ou risco.

## Evaluations e tests

- **O que é:** `evaluations/` guarda comportamento; `tests/` guarda verificações executáveis.
- **Entra:** cenários, rubricas, segurança, regressões e scripts de teste.
- **Não entra:** resultado efêmero de execução, que vai para `reports/`.
- **Exemplo:** `evaluations/security/` e `tests/validate-agent-repo.test.sh`.
- **Avaliação ou revisão:** mudança funcional requer caso direcionado; crítica requer suíte e revisão humana.

## Scripts

- **O que é:** `scripts/` contém comandos versionados de manutenção e validação.
- **Entra:** automações reprodutíveis como `validate-agent-repo.sh`.
- **Não entra:** prompt, regra de decisão do agente, segredo ou resultado gerado.
- **Exemplo:** `scripts/validate-agent-repo.sh`.
- **Avaliação ou revisão:** mude com teste de comportamento; revise acesso externo ou processamento de dados.

## Governance

- **O que é:** `governance/` reúne regras de contribuição, mudanças, release, dados e riscos.
- **Entra:** políticas normativas e responsabilidades de revisão.
- **Não entra:** decisão arquitetural pontual (ADR) ou relatório de auditoria.
- **Exemplo:** `governance/CHANGE-POLICY.md` e `DATA-AND-SECRETS.md`.
- **Avaliação ou revisão:** política exige revisão humana; dados, autoridade e publicação são críticos.

## Decisions, docs e reports

- **O que é:** `decisions/` preserva ADRs, `docs/` orienta pessoas e `reports/` guarda evidência datada.
- **Entra:** ADR com contexto/alternativas, manual/arquitetura e resultado com comandos reais.
- **Não entra:** Knowledge do modelo, regra permanente ou segredo.
- **Exemplo:** ADR de aprovação humana, este guia e relatório de migração.
- **Avaliação ou revisão:** ADR e documentação normativa exigem revisão; report não substitui avaliação.

## Relations

- **O que é:** `relations/` explicita dependências com agentes ou serviços.
- **Entra:** manifesto de tipo, alvo, finalidade, owner e dependência.
- **Não entra:** cópia de connector, credencial ou pasta vazia.
- **Exemplo:** manifesto que registra dependência de outro agente canônico.
- **Avaliação ou revisão:** crie quando a relação for real; avalie falha e revise impacto em escopo, dados ou autoridade.
