# Como usar este repositório canônico

## Visão geral

Este repositório canônico separa o núcleo do agente — objetivos, identidade e
instruções — de suas capacidades, Knowledge, integrações e traduções para
plataformas. O Git é a fonte de verdade: a plataforma de execução recebe uma
reconstrução do conteúdo versionado, nunca o contrário sem revisão.

## Começo rápido

1. Abra uma branch do repositório canônico que será alterado.
2. Defina ID, nome, versão e referências em `agent.yaml`.
3. Preencha missão, métricas e não-objetivos; depois identidade e comportamento.
4. Adicione avaliações, rode a suíte e abra um pull request conforme
   `governance/CONTRIBUTING.md`.

## Criar um agente novo

Para iniciar um agente novo, crie um repositório a partir do template canônico e
então siga este fluxo no novo repositório canônico. Substitua os exemplos em
`objectives/`, `identity/` e `instructions/` antes de criar capabilities. O prompt
principal fica em `instructions/system.md`; regras de segurança, limites e
aprovações ficam em `instructions/guardrails.md`. Registre cada componente
utilizado em `agent.yaml` e mantenha o primeiro escopo pequeno e avaliável.

## Importar um agente existente

Converta o prompt atual para `instructions/system.md` e separe regras permanentes
em `instructions/guardrails.md`. Inventarie anexos, procedimentos, Actions e
configurações, eliminando segredos e dados operacionais. Importe conteúdo usado
pelo modelo para `knowledge/`, procedimentos repetíveis para `skills/` e schemas
de integrações para `connectors/`; só publique após uma avaliação de regressão.

## Alterar o comportamento

Classifique a mudança como editorial, funcional ou crítica. Edite o componente
canônico responsável: objetivo não é identidade, regra geral não é skill e
integração não é adapter. Atualize avaliações antes de mudanças comportamentais,
a versão e o changelog quando exigidos pela política, e peça revisão humana para
mudanças críticas.

## Adicionar Knowledge

`knowledge/` recebe conteúdo curado que o modelo poderá consultar: `.md`, `.txt`,
`.pdf`, `.csv`, JSON de referência, imagens e planilhas. Para cada fonte, mantenha
um manifesto versionado com fonte, data, licença e hash; o manifesto descreve o
material sem incluir credenciais ou dados proibidos. Não coloque aqui manuais de
manutenção, conversas, logs, dados de clientes, corpora brutos ou índices RAG.
Avalie a resposta e a segurança quando o conteúdo puder alterar comportamento ou
risco.

## Adicionar uma skill

Crie `skills/<nome>/SKILL.md` com gatilho, entradas, passos, saída, limites,
handoff humano e dependências. Inclua casos em `skills/<nome>/evaluations/` e
registre a skill em `agent.yaml` quando ela fizer parte do agente. Uma skill é um
procedimento acionável; uma regra aplicada sempre pertence a `instructions/`.

## Adicionar um connector ou Action

Um conector descreve o acesso a um sistema externo, sem conter seu segredo. Para
uma Action, versione o OpenAPI em `connectors/actions/<nome>/openapi.yaml`, junto
com exemplos sintéticos, permissões, fallback e avaliações de indisponibilidade.
Endpoints privados e credenciais existem somente no runtime por variáveis de
ambiente; registre apenas seus nomes e o contrato público de uso.

## Criar profiles e adapters

Profiles recortam a distribuição por público, risco ou canal; adapters traduzem o
agente canônico para uma plataforma. Cada `profile.yaml` e `adapter.yaml` declara
`canonical_agent_version` igual a `agent.version`. Documente limitações do destino
e não replique nem redefina missão, identidade ou instruções canônicas.

## Testar e validar

Execute sempre:

```bash
bash tests/validate-agent-repo.test.sh
bash scripts/validate-agent-repo.sh
git diff --check
```

Acrescente avaliações de cenário, segurança, regressão ou conector conforme o
risco. O primeiro comando prova os casos negativos do validador; o segundo valida
o repositório que será publicado.

## Publicar uma mudança

Revise o diff, atualize `CHANGELOG.md` e `agent.yaml` se houver versão nova, e
sincronize profiles/adapters. Crie uma branch, faça commits claros, abra PR com
classe, riscos e evidências de avaliação, e obtenha a revisão humana exigida. Use
squash merge; não publique diretamente em `main`.

## Recriar em outra plataforma

Parta de `agent.yaml`, copie o núcleo canônico e conecte skills, Knowledge e
contratos suportados pelo destino. Traduza limitações em `adapters/<plataforma>/`,
sem mudar o comportamento central. Injete credenciais no runtime, execute as
avaliações e registre qualquer diferença material como adapter, decisão ou risco.

## Segurança e arquivos que não entram no Git

Nunca versione segredo, `.env`, chave privada, credencial, conversa, dado de
cliente, log, exportação operacional, corpus ou índice RAG. O validador também
bloqueia artefatos vetoriais e arquivos maiores que 5 MB. Em caso de exposição,
pare a publicação, revogue e rotacione o segredo e siga
`governance/DATA-AND-SECRETS.md`.

## Onde encontrar ajuda

Use `docs/REPOSITORY-STRUCTURE.md` para decidir o destino de um arquivo,
`governance/CONTRIBUTING.md` para o processo, e as políticas em `governance/` para
dados, mudanças, release e riscos. Quando o impacto não estiver claro, registre a
lacuna no pull request e peça decisão ao owner antes de alterar o núcleo.
