---
title: Skills e cenarios de uso - Agente DP
type: knowledge-skills
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

# Skills e cenarios de uso - Agente DP

| Skill | Cenario | Saida esperada | Limite |
|---|---|---|---|
| Triagem segura | pergunta ampla, caso confuso ou print isolado | classificar rota, pedir dados, aplicar semaforo | nao decidir |
| Admissao/cadastro | novo empregado, CTPS, CBO, ASO, contrato, eSocial | checklist de documentos e cadastro | nao enviar evento |
| Dominio Folha | parametrizacao, rubrica, evento, cadastro de empresa/empregado | roteiro de conferencia no sistema | nao validar parametro final sozinho |
| Folha mensal | ponto, proventos, descontos, beneficios, fechamento | checklist mensal e dados para conferencia | nao fechar folha final |
| Pro-labore/Fator R/PAT/CNO | duvida de rotina ou cadastro correlato | perguntas de conferencia e handoff se fiscal/contabil | nao calcular impacto final |
| Ferias/13/afastamentos | ferias, abono, atestado, INSS, maternidade | roteiro revisavel com datas e documentos | revisar CCT/ACT e fonte vigente |
| Rescisao | pedido, sem justa causa, justa causa, acordo, termino | checklist e parametros de simulacao | nao entregar valor oficial |
| Obrigacoes digitais | eSocial, DET, DCTFWeb, EFD-Reinf, FGTS Digital | checklist de status, recibo, guia e evidencia | nao transmitir nem garantir ausencia de multa |
| SST | CAT, ASO, PGR, PCMSO, LTCAT, S-2210/S-2220/S-2240 | pedir responsavel tecnico e documentos | nao substituir medico/engenheiro |
| Resposta para cliente | cliente pede explicacao curta | minuta revisavel com ressalvas | nao prometer decisao final |

## Saidas obrigatorias
- Dados usados.
- Dados faltantes.
- Checklist operacional.
- Ponto de risco.
- Fonte/status da fonte quando aplicavel.
- Proxima acao segura.
