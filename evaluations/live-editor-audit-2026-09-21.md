# Baseline do editor — 2026-09-21

## Identidade e estado

- GPT ID: `g-6a7259c849d4819194844f4d99c1213d`.
- URL: `https://chatgpt.com/gpts/editor/g-6a7259c849d4819194844f4d99c1213d`.
- Nome: `Agente Estrategista de Conteúdo D.A.I. | Oficial (copy)`.
- Distribuição exibida: `Rascunho`.
- A inspeção não alterou nem publicou o GPT.

## Configuração observada

- Seletor de modelo: `Thinking 5.6`.
- Preview: `GPT-5.6 Sol`.
- Web: ativada.
- Geração de imagens: ativada.
- Code Interpreter/análise de dados: desativado.
- Actions: nenhuma configurada.

Os dois rótulos de modelo são preservados como observações da UI; este registro
não infere identificador interno nem equivalência adicional.

## Instruções

O campo online bruto tem 3.989 bytes UTF-8, 133 linhas e SHA-256
`913433ef733c39349debcfbdd7e9f4089c805b8a886641561fae193f33165247`.
Ele coincide byte a byte com `instructions/system.md` após remover as dez linhas
do wrapper documental e a quebra de linha final do arquivo local. O validador
da candidata fixa esse contrato.

## Knowledge

O editor exibe 11 anexos:

1. `00-INDICE-CONTEUDO-DAI.md`
2. `01-REGRAS-DE-USO-E-LIMITES.md`
3. `02-ESCOPO-E-ROTEAMENTO.md`
4. `03-FONTES-CANONICAS.md`
5. `04-SKILLS-E-CENARIOS-DE-USO.md`
6. `05-PERGUNTAS-TESTE-E-RESPOSTAS-ESPERADAS.md`
7. `06-GUARDRAILS-E-CLAIMS-BLOQUEADOS.md`
8. `07-MODELOS-DE-RESPOSTA-E-CHECKLISTS.md`
9. `08-LACUNAS-E-ROADMAP.md`
10. `09-BANCO-DE-ANGULOS-E-ROTEIROS.md`
11. `99-FONTES-LACUNAS-E-CONTROLE-DE-VERSAO.md`

O último snapshot binário comprovado é misto, conforme
`knowledge/live-2026-08-22/MANIFEST.md`: 01–08 e 99 vêm de
`live-2026-08-22/`; 00 e 09 vêm de `original/`. A candidata materializa esse
conjunto em `knowledge/active-2026-09-21/` sem reescrever os históricos.

## Ensaios online da baseline

Seis ensaios observados passaram no GPT: carrossel textual de Reforma com
revisão técnica; Reels de captação sem promessa; cinco ângulos com evidência,
CTA e claim evitado; bloqueio de quatro claims absolutos; sequência
Post/Reels/WhatsApp sem publicação; e resistência a comando hostil embutido.
As respostas usaram as oito seções, linguagem direta, evidência/lacuna, handoff
e revisão.

Esses ensaios descrevem a baseline online preservada. Eles não promovem a skill
local, não constituem release e não autorizam afirmar que a candidata 0.2.0 já
foi validada.
