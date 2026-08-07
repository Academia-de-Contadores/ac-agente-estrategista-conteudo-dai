---
title: Modelos - Agente DP
type: knowledge-templates
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

# Modelos de resposta e checklists - Agente DP

## Modelo 1 - Resposta operacional segura
```markdown
### Resposta curta
[Explique o caminho seguro em 2 a 4 linhas.]

### Dados que preciso confirmar
- competencia/data;
- tipo de evento;
- CCT/ACT aplicavel;
- status no sistema;
- documentos/recibos/guias;
- se ha estabilidade, afastamento, SST ou risco.

### Checklist operacional
1. Conferir dados no sistema.
2. Conferir CCT/ACT ou fonte oficial se for temporal.
3. Conferir recibos/eventos/guias/evidencias.
4. Registrar pendencias.
5. Encaminhar para revisao humana se houver risco.

### Ponto de atencao
[Explique o risco.]

### Proxima acao segura
[Acao de 15 minutos sem decisao final.]
```

## Modelo 2 - Pedido de calculo
```markdown
Posso montar uma simulacao e listar os parametros para conferencia, mas o valor final precisa ser validado no sistema de folha, na CCT/ACT e por responsavel tecnico.

Parametros necessarios:
- [listar]

Roteiro de conferencia:
1. [passo]
2. [passo]
3. [passo]
```

## Modelo 3 - Evidencia DCTFWeb / FGTS Digital
```markdown
### O que conferir
- competencia;
- recibo de fechamento/transmissao;
- guia gerada;
- comprovante de envio ao cliente;
- responsavel;
- data/hora;
- pendencia no Notion/sistema;
- print ou protocolo, sem dados sensiveis.

### Risco
Sem evidencia, o problema deixa de ser so tecnico e vira falha de gestao.
```

## Modelo 4 - Handoff para Onboarding
```markdown
Agente destino: Onboarding Cliente
Motivo: entrada/transferencia de cliente com impacto DP
Dados DP necessarios:
- empregados/pro-labore/estagiarios/autonomos;
- CCT/ACT/categoria;
- sistema de folha/Dominio;
- status eSocial/DCTFWeb/FGTS;
- beneficios/jornada/ponto;
- documentos pendentes.
```
