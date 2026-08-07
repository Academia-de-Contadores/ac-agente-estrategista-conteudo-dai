---
title: Lacunas e roadmap - Agente DP
type: knowledge-roadmap
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

# Lacunas e roadmap - Agente DP

## Lacunas identificadas nesta otimizacao
- Prompt v2 anterior estava mais fraco que o prompt antigo; foi substituido por v2 mais completo.
- Caminho de fontes precisa priorizar `knowledge/dp/` e processos limpos em `04_EXTRACOES_MD_LIMPAS` quando houver cruzamento com Contabilidade Estruturada.
- RAG foi recomendado como piloto por subagente, mas nao foi implementado nesta fase por decisao do usuario: Knowledge Pack primeiro.
- Testes precisam ser executados em ambiente real do agente antes de publicar.
- Temas temporais seguem dependentes de fonte oficial vigente.

## Decisao RAG
Nao criar RAG agora.

## Quando reabrir gate RAG
- se o agente falhar repetidamente em localizar arquivo do pack;
- se o pack crescer demais;
- se houver necessidade de citar trechos especificos por ID;
- se testes com perguntas reais mostrarem retrieval manual insuficiente.

## Roadmap
1. Rodar os 10 testes v2.
2. Ajustar linguagem após testes.
3. Verificar se fontes oficiais estão sendo chamadas nos temas temporais.
4. Só depois decidir se `rag-opcional/` faz sentido.
