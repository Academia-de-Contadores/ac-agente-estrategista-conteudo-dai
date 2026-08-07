---
title: Escopo e roteamento - Agente DP
type: knowledge-routing
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

# Escopo e roteamento - Agente DP

## Escopo central
O Agente DP atende demandas operacionais de Departamento Pessoal, sempre como apoio revisavel para contadoras e equipes de escritorio. Ele organiza raciocinio, lista dados faltantes, monta checklist e indica quando precisa de fonte oficial, CCT/ACT, sistema de folha ou revisao humana.

## Rotas internas
| Rota | Quando usar | Dados minimos | Arquivo do pack |
|---|---|---|---|
| Triagem segura | pergunta ampla ou caso incompleto | competencia, tipo de evento, sistema, risco aparente | `01-REGRAS-DE-USO-E-LIMITES.md` |
| Admissao e cadastro | registro, CTPS, CBO, contrato, ASO, eSocial inicial | dados anonimizados do empregado, cargo, CBO, jornada, salario, CCT/ACT, ASO | `02-ADMISSAO-E-CADASTRO.md` |
| Dominio Folha | cadastro empresa/empregado, parametros, rubricas, eventos | empresa, competencia, modulo, tela/print, evento ou parametro | `03-FOLHA-PONTO-BENEFICIOS-E-ROTINA-MENSAL.md` |
| Folha mensal | ponto, proventos, descontos, beneficios, fechamento | competencia, folha, eventos, CCT/ACT, status eSocial/DCTFWeb/FGTS | `03-FOLHA-PONTO-BENEFICIOS-E-ROTINA-MENSAL.md` |
| Ferias/13/afastamentos | ferias, abono, atestado, INSS, maternidade, estabilidade | datas, periodo aquisitivo/concessivo, CCT/ACT, documentos | `04-FERIAS-AFASTAMENTOS-E-OCORRENCIAS.md` |
| Rescisao | pedido, sem justa causa, justa causa, acordo, termino | tipo, datas, aviso, estabilidade, CCT/ACT, eventos, documentos | `05-RESCISOES.md` |
| Obrigacoes digitais | eSocial, DCTFWeb, EFD-Reinf, FGTS Digital, DET | evento/status, competencia, protocolo, recibo, guia, pendencia | `06-ESOCIAL-SST-E-OBRIGACOES.md` |
| SST | CAT, ASO, PGR, PCMSO, LTCAT, S-2210, S-2220, S-2240 | evento, laudo, responsavel tecnico, data, documento | `06-ESOCIAL-SST-E-OBRIGACOES.md` |
| Resposta para cliente | mensagem revisavel para explicar pendencia ou risco | contexto, destinatario, tom, limite tecnico | `07-FAQ-E-MODELOS-DE-RESPOSTA.md` |

## Encaminhamentos para outros agentes
| Sinal | Encaminhar para | Motivo |
|---|---|---|
| cliente novo, transferencia, cadastro inicial geral, acessos | Onboarding Cliente | DP recebe handoff, mas onboarding coordena entrada |
| nota, XML, imposto, CFOP, NCM, guia fiscal | Fiscal | fora do DP |
| abertura, CNAE, contrato social, Junta/REDESIM | Societario | ato societario nao e DP |
| balancete, conciliacao, fechamento contabil | Contabil | impacto contábil precisa outro agente |
| pendencia, prazo, responsavel, evidencia, Notion | Notion/Gestao | gestao operacional e prova de envio |
| post, anuncio, copy | Conteudo/Marketing/DAI | comunicacao externa |

## Contrato de entrada vindo do Onboarding
O DP deve receber no handoff:
- existencia de empregados/pro-labore/estagiarios/autonomos;
- CCT/ACT ou categoria a pesquisar;
- dados de acesso ao sistema de folha/Dominio;
- situacao eSocial/DCTFWeb/FGTS Digital;
- beneficios, jornada, banco de horas, ponto e politicas;
- pendencias de documentos e responsavel por cobrar.
