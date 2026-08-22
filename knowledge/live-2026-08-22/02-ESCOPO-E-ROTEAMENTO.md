---
title: Escopo e roteamento - Conteudo Marketing DAI
type: knowledge-routing
status: draft
produto: Desafio Contadora CEO com IA
pilar: agentes
departamento: Conteudo Marketing DAI
fonte_tipo: curadoria
origem: agents/knowledge
data_criacao: 2026-07-04
data_consulta: 2026-07-04
entra_no_rag: reference_only
confiabilidade: interna_curada
tags:
  - academia-contadores/dcceo/agentes
---

# Escopo e roteamento - Conteudo Marketing DAI

## Escopo central
- hooks
- roteiros
- anuncios
- copy
- dores reais
- DCCEO
- Reforma
- IA
- processos
- gestao
- QA de claims

## Quando chamar este agente
- Quando a demanda envolver hooks.
- Quando a demanda envolver roteiros.
- Quando a demanda envolver anuncios.
- Quando a demanda envolver copy.
- Quando a demanda envolver dores reais.
- Quando a demanda envolver DCCEO.
- Quando a demanda envolver Reforma.
- Quando a demanda envolver IA.

## Quando encaminhar para outro agente
| Sinais | Agente destino | Dados minimos |
|---|---|---|
| nota, NCM, CFOP, XML, NFS-e, SEFAZ, prefeitura | Fiscal | documento fiscal, regime, periodo, UF/municipio, ERP, operacao |
| folha, admissao, ferias, rescisao, CCT, eSocial, DCTFWeb, FGTS | DP | competencia, empregado anonimizado, CCT/ACT, evento, sistema |
| abertura, alteracao, baixa, CNAE, contrato social, Junta, REDESIM | Societario | UF/municipio, atividade, socios, documentos, evento societario |
| cliente novo, transferencia, cadastro, acessos, certificado, Dominio | Onboarding Cliente | tipo de entrada, documentos, acessos, ERP, departamentos afetados |
| balancete, conciliacao, fechamento, ECD, ECF, SPED | Contabil | periodo, documentos, saldos, integracoes fiscal/DP |
| pendencia, prazo, responsavel, status, evidencia, Notion | Notion/Gestao | base de tarefas, responsavel, vencimento, status e evidencia |
| lead, proposta, follow-up, escopo, objeção | Comercial | perfil, dor, faturamento, escopo esperado, urgencia |
| post, anuncio, copy, hook, roteiro | Conteudo/Marketing/DAI | produto, publico, dor real, prova, claim seguro |
| CBS, IBS, split, credito, cClassTrib, Reforma | Reforma | ano, operacao, documento fiscal, ERP, fonte vigente |

## Contratos principais
| Origem | Destino | Entrada/Handoff | Saida esperada |
|---|---|---|---|
| Concierge | Todos | demanda classificada + dados faltantes + risco | agente destino responde ou pede mais dados |
| Comercial | Onboarding | diagnostico, escopo vendido, promessas, urgencias | checklist de entrada e handoffs |
| Onboarding | Fiscal | dados fiscais, regime, notas, ERP, acessos, prefeitura/SEFAZ | parametrizacao e checklist fiscal |
| Onboarding | DP | funcionarios, CCT, folha, eSocial, beneficios | checklist DP e riscos |
| Onboarding | Contabil | historico, documentos, saldos, extratos, contador anterior | lacunas de fechamento |
| Onboarding | Societario | evento societario, documentos, socios, contrato | procedimento societario revisavel |
| Departamentos | Notion/Gestao | tarefas, prazos, evidencias, responsaveis | status operacional e relatorios |
| Fiscal | Reforma | CBS/IBS/split/cClassTrib/DFe/ERP | orientacao consultiva com fonte vigente |
