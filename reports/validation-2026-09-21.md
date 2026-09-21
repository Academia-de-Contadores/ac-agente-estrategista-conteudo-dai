# Validação canônica da skill 0.2.0 — 2026-09-21

## Decisão

**VALIDATED.** A skill `$ac-estrategista-conteudo-dai`, versão 0.2.0, atende
os critérios estruturais, de instalação seletiva e comportamentais definidos
para promoção. A decisão altera somente o lifecycle local para `validated`;
não houve push, merge, publicação, catálogo ou release.

## Identidade e integridade da fonte

- GPT ID: `g-6a7259c849d4819194844f4d99c1213d`.
- Instruções online materializadas em `instructions/system.md`: 3.989 bytes,
  133 linhas e SHA-256 exato
  `913433ef733c39349debcfbdd7e9f4089c805b8a886641561fae193f33165247`.
- Knowledge ativo: exatamente 11 arquivos declarados em `skill-runtime.yaml`;
  os bytes e hashes individuais continuam protegidos pelo validador.
- P1–P6, as instruções online e os 11 arquivos ativos de Knowledge não foram
  modificados por esta promoção.

## Evidência de instalação seletiva pré-promoção

A instalação real no caminho lógico
`$CODEX_HOME/skills/ac-estrategista-conteudo-dai` foi inspecionada antes da
promoção e estava byte a byte igual ao pacote de origem naquele momento. Esse
é um caminho lógico relativo ao diretório de configuração do Codex, não um
caminho literal dependente de usuário:

- 25 arquivos regulares;
- 11 arquivos de Knowledge ativos;
- 0 symlinks;
- 0 `.gitkeep`;
- SHA-256 agregado:
  `68a9df4a7ba54e0686a8613585c93d7767f1f414279327187e07b0b81ac7e140`.

O hash agregado é o SHA-256 da saída de `shasum -a 256` para os 25 arquivos,
ordenados pelo caminho relativo em locale C. A promoção adiciona `version` e
`lifecycle` a `skill-runtime.yaml` e atualiza
`objectives/success-metrics.md`; por isso a instalação real anterior deixa de
representar o pacote promovido. Essa necessidade foi atendida pela reinstalação
pós-promoção registrada abaixo.

## Reinstalação seletiva pós-promoção

Em 2026-09-21, o pacote promovido foi reinstalado no mesmo caminho lógico e
validado contra a origem:

- 25 arquivos regulares;
- 11 arquivos de Knowledge ativos;
- 0 symlinks;
- 0 `.gitkeep`;
- byte a byte igual ao pacote de origem;
- `quick_validate.py`: PASS;
- `scripts/validate-content-skill.rb`: PASS;
- SHA-256 agregado:
  `45d7d110aec9a27f5cbf5cbfa15f0af5c1548b4d90a25eed0ba46220c7a8ec30`.

## Evidência online e local

- Baseline online autenticada:
  `reports/online-parity-2026-09-21.md`, com 72/72 pontos e 36/36 gates.
- Revisão corretiva final no commit
  `d324bc9296b0a6e093c881d9d6acdf44c4512526`: C0/I0/M0.
- Forward local no commit
  `5e366596fa75b0b4d352e10606c4aaa6e502b4fb`: outputs P1–P6 preservados.
- R1 histórica bloqueada:
  `evaluations/parity/local-parity-evaluation-2026-09-21.md`.
- Correção do blocker `F-BLOCKER-001` no commit
  `54eb7bfc81125e38eed4cabcb18c4a8c2577e038`: prompts alinhados byte a byte e
  por hash ao contrato online.
- R2 final no commit
  `5be973f532474ead58592a7889bbf58903d54486`:
  72/72 critérios, 72/72 pontos, 36/36 gates e 6/6 casos qualificados.
- Findings finais: C0/I0/M0; crítico 0, importante 0, menor 0.

## Conclusão operacional

O blocker histórico permanece documentado na R1 e resolvido na R2. A versão
0.2.0 passa a `validated`. O pacote promovido contém os mesmos 25 caminhos e os
mesmos 11 Knowledge, mas dois arquivos empacotados mudaram. A instalação
simulada do pacote promovido passou o `quick_validate.py`, sem symlink ou
`.gitkeep`, com SHA-256 agregado
`45d7d110aec9a27f5cbf5cbfa15f0af5c1548b4d90a25eed0ba46220c7a8ec30`;
a reinstalação real posterior também passou as verificações e está byte a byte
sincronizada com o pacote promovido.
