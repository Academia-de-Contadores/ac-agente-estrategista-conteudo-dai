# Ficha de captura da fonte

## Estado reconfirmado em 2026-09-21

- Auditoria corrente: `evaluations/live-editor-audit-2026-09-21.md`.
- Nome online: `Agente Estrategista de Conteúdo D.A.I. | Oficial (copy)`;
  status `Rascunho`.
- Instruções online: 3.989 bytes, 133 linhas e SHA-256
  `913433ef733c39349debcfbdd7e9f4089c805b8a886641561fae193f33165247`;
  paridade byte a byte direta com `instructions/system.md`, sem wrapper,
  quebra final acrescentada ou normalização no validador. Os metadados de
  captura permanecem nesta ficha, fora do payload.
- Knowledge: 11 nomes reconfirmados; conjunto binário ativo materializado em
  `knowledge/active-2026-09-21/` a partir do snapshot misto de 2026-08-22.
- Modelo: `Thinking 5.6` no seletor e `GPT-5.6 Sol` no preview.
- Recursos: web e geração de imagens ativadas; Code Interpreter desativado;
  nenhuma Action configurada.
- Seis ensaios online autenticados qualificaram o baseline com 72/72 pontos e
  36/36 gates; fingerprints completos estão em
  `reports/online-parity-2026-09-21.md`. Os outputs brutos não foram versionados
  e o resultado não declara a candidata local como validada.

## Registro histórico — 2026-08-06

- **source_status:** accessible
- **data da captura:** 2026-08-06
- **URL exata do editor/fonte:** https://chatgpt.com/gpts/editor/g-6a7259c849d4819194844f4d99c1213d
- **nome no editor:** Agente Estrategista de Conteúdo D.A.I. | Oficial (copy)
- **distribuição observada:** rascunho privado
- **responsável:** Academia-de-Contadores
- **método de recuperação:** inspeção somente leitura da configuração no editor autenticado; nenhuma conversa pública foi usada.
- **status de recuperação:** nome, descrição, instruções, starters, metadados do Knowledge, modelo e capacidades acessíveis; conteúdo dos anexos e configuração de autenticação/endpoint não recuperados.

## Campos acessíveis

- **Descrição:** Agente Estrategista de Conteúdo D.A.I. do Desafio Contadora CEO com IA, com criação, revisão de claims e validação humana.
- **Quebra-gelos:** `Me ajude a gerar um carrossel`; `Transforme essa dúvida em um conteúdo `; `Crie um roteiro de reels pra captar clientes`.
- **Modelo recomendado:** Nenhum modelo recomendado foi observado naquela
  captura. O estado visual reconfirmado acima substitui esta observação histórica.
- **Busca na web:** ativada.
- **Geração de imagens:** ativada.
- **Intérprete de código/análise de dados:** desativado.
- **Actions:** a interface mostrou somente a opção de criar nova Action; esquema, autenticação e endpoint não ficaram visíveis.
- **Knowledge (somente nomes e tipos visíveis):**
  - `08-LACUNAS-E-ROADMAP.md`
  - `05-PERGUNTAS-TESTE-E-RESPOSTAS-ESPERADAS.md`
  - `01-REGRAS-DE-USO-E-LIMITES.md`
  - `06-GUARDRAILS-E-CLAIMS-BLOQUEADOS.md`
  - `09-BANCO-DE-ANGULOS-E-ROTEIROS.md`
  - `07-MODELOS-DE-RESPOSTA-E-CHECKLISTS.md`
  - `02-ESCOPO-E-ROTEAMENTO.md`
  - `04-SKILLS-E-CENARIOS-DE-USO.md`
  - `03-FONTES-CANONICAS.md`
  - `99-FONTES-LACUNAS-E-CONTROLE-DE-VERSAO.md`
  - `00-INDICE-CONTEUDO-DAI.md`

## Mapeamento canônico

- **Objetivos:** descrição do editor e escopo expresso nas instruções; ver `objectives/`.
- **Identidade:** trecho explícito de identidade capturado; ver `identity/identity.md`.
- **Soul/tom:** source_status: unavailable; o editor não expõe campo Soul separado; ver `identity/soul.md`.
- **Instruções:** campo integral, sem wrapper específico do GPT Builder, em `instructions/system.md`.
- **Guardrails:** índice das seções `Risco e limite`, `Risco e limite`, `Claims e decisoes bloqueadas` em `instructions/guardrails.md`; o texto normativo permanece em `instructions/system.md` para evitar duplicação.
- **Workflows:** índice das seções `Formato obrigatorio de resposta`, `Rota identificada`, `Handoffs aceitos`, `Resposta padrao`, `Rota identificada` em `instructions/workflows/main.md`.
- **Skills:** padrões comportamentais estão no campo de instruções e em nomes de anexos; os corpos dos anexos não foram acessados, portanto nenhuma skill independente foi inventada.
- **Conectores:** nenhum conector canônico configurado; capacidades de plataforma foram registradas apenas como metadados.
- **Knowledge:** somente metadados de nomes/tipos; corpos, corpus, índices e exports não foram copiados.

## Dados omitidos

Foram deliberadamente omitidos tokens, credenciais, autenticação, endpoints privados,
conversas de usuários, dados de clientes, logs, arquivos anexos, corpus e índices RAG.
A observação histórica da interface sobre um wrapper de plataforma não descreve
uma transformação do arquivo atual: `instructions/system.md` é agora o campo
online bruto exato, e qualquer metadado documental vive nesta ficha.

## Atualização — recuperação integral do Knowledge (2026-08-07)

- Os 11 anexos exibidos no editor foram baixados diretamente e preservados em `knowledge/original/`.
- `knowledge/MANIFEST.md` registra nome, tamanho e SHA-256 de cada arquivo.
- Esta atualização substitui, para o estado atual do repositório, as observações históricas acima que diziam que os corpos dos anexos não haviam sido recuperados.
- Tokens, credenciais, conversas de usuários, dados de clientes, logs e índices externos continuam fora do repositório.
