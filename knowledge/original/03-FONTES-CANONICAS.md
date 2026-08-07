---
title: Fontes canonicas - Agente DP
type: knowledge-sources
status: draft
produto: Desafio Contadora CEO com IA
pilar: agentes
departamento: DP
fonte_tipo: curadoria
data_criacao: 2026-07-04
data_consulta: 2026-07-04
entra_no_rag: reference_only
confiabilidade: interna_curada
tags:
  - academia-contadores/dcceo/agentes
---

# Fontes canonicas - Agente DP

## Fontes internas principais
| Fonte | Status | Uso |
|---|---|---|
| `knowledge/dp/00-INDICE-DP.md` | canonical_pack | entrada principal do Knowledge Pack |
| `knowledge/dp/01-REGRAS-DE-USO-E-LIMITES.md` | canonical_pack | limites, fonte, dados sensiveis e semaforo |
| `knowledge/dp/02-ADMISSAO-E-CADASTRO.md` | canonical_pack | admissao, cadastro, CTPS, CBO, ASO e eSocial inicial |
| `knowledge/dp/03-FOLHA-PONTO-BENEFICIOS-E-ROTINA-MENSAL.md` | canonical_pack | folha, ponto, beneficios, Dominio Folha e rotina mensal |
| `knowledge/dp/04-FERIAS-AFASTAMENTOS-E-OCORRENCIAS.md` | canonical_pack | ferias, 13o, atestados, afastamentos e estabilidade |
| `knowledge/dp/05-RESCISOES.md` | canonical_pack | desligamentos e verbas rescisorias como roteiro revisavel |
| `knowledge/dp/06-ESOCIAL-SST-E-OBRIGACOES.md` | canonical_pack | eSocial, DCTFWeb, FGTS Digital, DET e SST |
| `knowledge/dp/07-FAQ-E-MODELOS-DE-RESPOSTA.md` | canonical_pack | modelos de resposta e atendimento |
| `agents/dp/PROMPT-AGENTE-DP-CONTADORAS.md` | reference_only | prompt antigo maduro usado como fonte de comportamento |
| `agents/dp/_curated/09-prompt-v2-thread.md` | reference_only | prompt v2 desta thread |
| `01_CONTABILIDADE_ESTRUTURADA_PROCESSOS/04_EXTRACOES_MD_LIMPAS/DP/lote-01/` | reference_only | processos DP extraidos e validados no projeto maior |
| `01_CONTABILIDADE_ESTRUTURADA_PROCESSOS/05_SINTESES_POR_DEPARTAMENTO/sintese-dp-lote-01.md` | reference_only | sintese departamental |
| `01_CONTABILIDADE_ESTRUTURADA_PROCESSOS/06_PARECER_CONTADOR_SENIOR/parecer-contador-senior-dp-lote-01.md` | reference_only | parecer de risco e aplicabilidade |

## Fontes oficiais quando houver regra atual
Usar fonte oficial vigente antes de afirmar prazo, tabela, layout, evento ou regra temporal:
- eSocial;
- Receita Federal / DCTFWeb;
- FGTS Digital;
- DET;
- MTE;
- INSS;
- Planalto;
- CCT/ACT aplicavel.

## Decisao RAG desta thread
Nao criar RAG agora.

Justificativa: o Knowledge Pack DP ja esta modular e legivel. O subagente sugeriu piloto controlado, mas a decisao coordenadora e testar primeiro o pack simples. Se futuramente houver falha de recuperacao, registrar em `08-LACUNAS-E-ROADMAP.md` antes de criar qualquer `rag-opcional/`.
