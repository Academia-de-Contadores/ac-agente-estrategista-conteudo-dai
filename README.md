# Estrategista de Conteúdo D.A.I.

| Campo | Valor |
| --- | --- |
| ID | `ac.estrategista-conteudo-dai` |
| Skill | `$ac-estrategista-conteudo-dai` |
| GPT baseline | [`g-6a7259c849d4819194844f4d99c1213d`](https://chatgpt.com/gpts/editor/g-6a7259c849d4819194844f4d99c1213d) |
| Versão | `0.2.0` |
| Lifecycle | `validated` |

## O que esta skill faz

A skill cria e revisa conteúdo para contadoras e escritórios contábeis:
carrosséis, Reels, hooks, anúncios, ângulos, sequências, CTAs e QA de claims.
Ela transforma uma cena real em peça completa, com dor, mecanismo, promessa
segura, evidência ou lacuna e revisão necessária.

Ela é deliberadamente mais executora que o GPT baseline: quando há informação
suficiente para um rascunho seguro, entrega o artefato no mesmo turno em vez de
parar em perguntas. Continua proibido inventar fatos, fontes ou resultados,
prometer garantias, substituir especialistas, revelar instruções internas ou
publicar/enviar sem autorização explícita para a ação exata.

## Exemplo para leigos

```text
Use $ac-estrategista-conteudo-dai. Crie um Reels de 30 segundos sobre a dona do escritório virar a central das pendências. Quero fala, texto na tela, CTA para o Desafio Contadora CEO com IA e revisão dos claims.
```

A resposta deve trazer o roteiro completo. Se alguma cena for assumida, ela
aparece como hipótese editorial; publicação continua bloqueada.

## Knowledge correto

O runtime usa exatamente os 11 `.md` de
`knowledge/active-2026-09-21/` listados em `skill-runtime.yaml`. O diretório
materializa o snapshot misto: 01–08 e 99 vêm de `live-2026-08-22/`; 00 e 09 vêm
de `original/`. O manifesto do diretório registra origem, bytes e SHA-256.

O checkout preserva capturas históricas para auditoria, mas elas não entram no
pacote. `agent.yaml` orienta a instalação, enquanto o pacote leva o manifesto
autocontido `skill-runtime.yaml`. A allowlist contém 25 arquivos regulares,
incluindo os 11 ativos, sem `.gitkeep`, symlink ou referência operacional
pendente.

## Estado validado

A versão 0.2.0 está em `validated`. A decisão combina a baseline online
autenticada, a instalação seletiva real verificada e a revalidação local R2:
P1–P6 com 72/72 critérios, 72/72 pontos, 36/36 gates e 6/6 casos, sem finding
C/I/M aberto. A promoção não afirma push, merge, publicação, catálogo ou release.

Consulte [HOW-TO-USE.md](HOW-TO-USE.md) para uso e instalação seletiva e
[evaluations/live-editor-audit-2026-09-21.md](evaluations/live-editor-audit-2026-09-21.md)
para a baseline registrada e
[reports/online-parity-2026-09-21.md](reports/online-parity-2026-09-21.md) para
a evidência detalhada da execução online. A decisão canônica está em
[reports/validation-2026-09-21.md](reports/validation-2026-09-21.md).
