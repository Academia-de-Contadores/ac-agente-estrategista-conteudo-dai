# Política de release

Use versionamento semântico. MAJOR quebra contrato ou amplia risco; MINOR adiciona
capacidade compatível; PATCH corrige comportamento ou conteúdo sem novo contrato.
Atualize `agent.yaml` e `CHANGELOG.md`, execute a suíte e registre em cada perfil e
adaptador a versão canônica publicada.

## Lifecycle da skill distribuível

- `source-capture`: preserva a fonte, mas ainda não oferece pacote instalável;
- `candidate`: possui entrada operacional, allowlist, Knowledge e avaliações
  prontas para qualificação;
- `validated`: passou a suíte estrutural, a instalação seletiva e os critérios
  comportamentais definidos para a versão;
- release/publicação: decisão posterior, registrada separadamente.

A versão 0.2.0 foi promovida a `validated` pela decisão registrada em
`reports/validation-2026-09-21.md`, após validação automatizada, avaliação de
agente e verificação de instalação seletiva. Revisão humana pode ser exigida por
risco ou mudança crítica, mas não é o único mecanismo de qualificação. A
execução da suíte, sozinha, não altera silenciosamente o lifecycle e a promoção
não equivale a release, publicação ou entrada em catálogo.
