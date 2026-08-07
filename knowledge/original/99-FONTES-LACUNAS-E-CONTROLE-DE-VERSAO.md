---
title: 99 FONTES LACUNAS E CONTROLE DE VERSAO
type: knowledge-note
status: draft
produto: Desafio Contadora CEO com IA
pilar: agentes
departamento: dp
fonte_tipo: knowledge_pack
origem: knowledge/dp
data_criacao: 2026-07-04
data_consulta: 2026-07-04
entra_no_rag: reference_only
confiabilidade: interna_curada
tags:
  - academia-contadores/dcceo/agentes
---

# Fontes, Lacunas E Controle De Versao

Data de curadoria: 2026-06-27.

Objetivo: registrar fontes usadas, criterios de conversao, lacunas e gates de publicacao do Agente DP.

## PDFs Fonte

| Fonte | Paginas estimadas na extracao | Caracteristica | Uso no pack |
|---|---:|---|---|
| `POP DP 01.pdf` | 96 | POP operacional com passos de eSocial, FGTS Digital, DCTFWeb e rotinas | checklist operacional e obrigacoes |
| `GUIA+COMPLETO+DP+-+2025 (1).pdf` | 193 | guia amplo com sumario, conceitos, eSocial, beneficios, admissao, ferias, rescisao | fonte ampla e conceitos |
| `modulo 1 processos de admissao.pdf` | 49 | slides de admissao e fase inicial do eSocial | admissao, CTPS, CBO, grupos e eSocial |
| `Modulo 02.pdf` | 60 | contratos, jornadas e fase 2 do eSocial | contratos e jornada |
| `Modulo 03 e 04.pdf` | 57 | ferias e 13o salario | ferias, 13o e ocorrencias |
| `Modulo 5 e 6 - Folha de Pagamento.pdf` | 58 | folha, proventos, descontos e encargos | folha, ponto e beneficios |
| `Modulo 7 - Rescisoes.pdf` | 87 | modalidades e cuidados de rescisao | rescisao e riscos |
| `Modulo 8 - SST e Principais Duvidas do DP.pdf` | 12 | SST, eventos, CAT, ASO e duvidas recorrentes | SST e eSocial |

Manifesto tecnico: `tmp/pdfs/dp_extracted/manifest.json`.

## Criterios De Curadoria

- PDFs foram usados como fonte de conteudo, nao copiados integralmente.
- Apostilas e slides foram transformados em checklists e orientacoes praticas.
- Capas, licencas, rodapes, repeticoes e ruido visual foram descartados.
- Tabelas e prazos foram tratados como dependentes de verificacao atual.
- Conteudo sensivel foi convertido em regra de escalonamento humano.

## QA Externo

Firecrawl:

- tentativa de pesquisa retornou erro de autenticacao/transporte;
- nao foi usado como fonte final.

Apify:

- tentativa de busca retornou token invalido;
- nao foi usado como fonte final.

Fallback:

- usar busca web e fonte oficial no momento de publicacao/teste do GPT;
- fontes oficiais sugeridas:
  - OpenAI GPTs e Knowledge: https://help.openai.com/en/articles/8554397-creating-and-editing-gpts
  - OpenAI Data Analysis: https://help.openai.com/en/articles/8437071-data-analysis-with-chatgpt
  - CTPS Digital: https://www.gov.br/pt-br/servicos/obter-a-carteira-de-trabalho
  - DET: https://det.sit.trabalho.gov.br/
  - eSocial documentacao tecnica: https://www.gov.br/esocial/
  - FGTS Digital: https://www.gov.br/trabalho-e-emprego/pt-br/assuntos/fgtsdigital

## Lacunas Que Exigem Checagem Atual

- tabelas de INSS, IRRF e salario-familia;
- salario minimo;
- prazos vigentes de eventos;
- layouts e manuais do eSocial;
- FGTS Digital;
- DCTFWeb;
- DET;
- CCT/ACT;
- regras sindicais;
- normas de SST;
- procedimentos de cada sistema de folha.

## Claims Bloqueados

- "calculo definitivo";
- "parecer trabalhista";
- "sem risco";
- "sem multa";
- "envio correto garantido";
- "dispensa laudo";
- "nao precisa consultar CCT";
- "substitui DP/contador/juridico";
- "pode demitir";
- "pode pagar por fora";
- "guia esta correta";
- "resposta pronta para cliente sem revisao".

## Gate Para Publicar

Publicar o GPT apenas depois de:

1. subir estes Markdowns no Knowledge;
2. remover PDFs brutos do Knowledge principal, mantendo-os como auditoria local;
3. colar o prompt final;
4. ativar Web Search e Data Analysis;
5. manter Canvas desligado se o modelo recomendado for GPT-5.5 e houver incompatibilidade;
6. manter Image Generation desligado;
7. rodar bateria de testes;
8. corrigir falhas `FAIL`;
9. validar conta nao-dona com permissao de chat;
10. registrar versao publicada.

## Versao

| Versao | Data | Status | Observacao |
|---|---|---|---|
| v1.0 | 2026-06-27 | pronto para QA no GPT Builder | Knowledge curado, prompt e testes locais criados |

