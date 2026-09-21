# Estrutura do repositório de agente

Este guia é a referência normativa para decidir onde cada artefato do agente vive.
O conteúdo canônico é independente da plataforma; o runtime recebe uma tradução
controlada dele.

## Árvore completa

```text
.
├── SKILL.md                    # entrada operacional distribuível
├── agent.yaml
├── skill-runtime.yaml          # manifesto autocontido do pacote instalado
├── agents/                     # metadados de interface e invocação
├── references/                 # contratos consultados sob demanda pela skill
├── objectives/                 # missão, métricas e não-objetivos
├── identity/                   # papel, autoridade, voz e valores
├── instructions/               # prompt, guardrails e workflows permanentes
├── skills/                     # reservado para capabilities internas futuras
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

## Manifesto agent.yaml

- **O que é:** `agent.yaml` é o índice legível por máquina da versão canônica: identifica o agente e referencia seus componentes versionados.
- **Entra:** schema, ID, nome, versão, lifecycle, owners e caminhos para objectives, identity, instructions, skills, connectors, evaluations, profiles e adapters existentes.
- **Não entra:** prompt completo, personalidade, conteúdo de Knowledge, credencial, dado de cliente ou referência para arquivo inexistente.
- **Exemplo:** `agent.version: 0.2.0` acompanhado das avaliações e dos `canonical_agent_version` correspondentes em profiles e adapters.
- **Avaliação ou revisão:** toda mudança exige validação do manifesto; ID, lifecycle, versão, permissões, componentes ou caminhos requerem revisão do owner e avaliações proporcionais ao impacto.

`agent.yaml` é a fonte da instalação no repositório. `skill-runtime.yaml` entra
no pacote e repete somente os caminhos empacotados; o validador exige igualdade
entre as allowlists e rejeita referência operacional para arquivo ausente.

## Arquivos ignorados

- **O que é:** `.gitignore` impede que artefatos locais conhecidos sejam adicionados por engano, mas não substitui inspeção, validador ou remoção de um segredo já versionado.
- **Entra:** padrões de ambiente local, chaves, credenciais, bancos, logs, índices vetoriais, caches e saídas geradas que nunca formam o agente canônico.
- **Não entra:** regra usada para esconder conteúdo canônico obrigatório, exceção para versionar dados proibidos ou afirmação de que um arquivo ignorado é seguro.
- **Exemplo:** `.env*`, `*.key`, `*.sqlite`, `*.jsonl`, `chroma/`, `vector_store/` e `__pycache__/`.
- **Avaliação ou revisão:** revise junto com o validador sempre que surgir novo formato sensível ou gerado; confirme que nenhum arquivo já rastreado escapa ao controle.

## GitHub

- **O que é:** `.github/` reúne colaboração e automação específicas do GitHub; ela apoia o fluxo do repositório sem redefinir o agente.
- **Entra:** `CODEOWNERS`, template de pull request e workflows que executam validações reprodutíveis sem segredo embutido.
- **Não entra:** identidade, instrução, Knowledge, credencial, regra disponível somente no GitHub ou alegação de proteção que não esteja efetivamente configurada no remoto.
- **Exemplo:** `.github/workflows/validate.yml` executa `bash scripts/validate-agent-repo.sh`; `CODEOWNERS` solicita revisão para áreas sensíveis.
- **Avaliação ou revisão:** mudanças de owner, permissões, eventos, Actions ou gates exigem revisão humana e teste do workflow; confirme separadamente as proteções configuradas no remoto.

## Documentos raiz

- **O que é:** os documentos raiz orientam pessoas: `README.md` apresenta o agente, `HOW-TO-USE.md` ensina operação e reconstrução e `CHANGELOG.md` registra mudanças relevantes.
- **Entra:** propósito e estado derivados de `agent.yaml` e `objectives/`, links para normas, procedimentos de uso e histórico versionado.
- **Não entra:** comportamento canônico no lugar de `instructions/`, Knowledge no lugar de `knowledge/`, relatório datado, segredo ou afirmação operacional não verificada.
- **Exemplo:** o README aponta para este guia e o HOW-TO-USE; o changelog registra uma alteração funcional na versão correspondente.
- **Avaliação ou revisão:** revise links, metadados e consistência com o manifesto; alteração normativa ou de procedimento requer owner, e mudança apenas editorial não substitui avaliações comportamentais quando o núcleo também muda.

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

- **O que é:** `SKILL.md` é a entrada operacional desta distribuição;
  `references/` guarda contratos carregados sob demanda e `agents/openai.yaml`
  define a interface. `skills/` fica reservado a capabilities internas futuras.
- **Entra:** `SKILL.md`, referências necessárias e avaliações em `evaluations/`.
- **Não entra:** regra de toda resposta, dado bruto ou credencial.
- **Exemplo:** `SKILL.md` roteia para `references/content-outputs.md`.
- **Avaliação ou revisão:** cada mudança requer cenário direcionado e regressão aplicável.

## Knowledge

- **O que é:** `knowledge/` é a base curada que pode ser fornecida ao modelo.
- **Entra:** `.md`, `.txt`, `.pdf`, `.csv`, JSON de referência, imagens, planilhas e manifesto de fonte/data/licença/hash.
- **Não entra:** manual de manutenção, segredo, dado de cliente, conversa, log, corpus ou índice vetorial.
- **Exemplo:** `knowledge/active-2026-09-21/` materializa os 11 anexos da allowlist.
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
