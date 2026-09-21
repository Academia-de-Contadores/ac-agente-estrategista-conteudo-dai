# Changelog

Todas as mudanças relevantes deste agente serão registradas aqui.

## 0.2.0 — 2026-09-21

- Prepara a candidata `$ac-estrategista-conteudo-dai` com entrada operacional,
  interface, contratos de saída, política de evidência e gate de publicação.
- Materializa o snapshot misto de 11 anexos em
  `knowledge/active-2026-09-21/`, preservando os históricos.
- Adiciona allowlist explícita de 25 arquivos e acionadores de runtime.
- Adiciona casos P1–P6 com 12 critérios por caso, rubrica de 12 pontos e seis
  gates obrigatórios.
- Adiciona validação de lifecycle, pacote, payload online, Knowledge, cenários e
  instalação seletiva sem symlink ou `.gitkeep`.
- Torna `instructions/system.md` o payload online bruto exato e move os
  metadados de captura para a ficha de avaliação, sem normalização no hash.
- Adiciona `skill-runtime.yaml` autocontido, remove `agent.yaml` da instalação e
  valida referências operacionais pendentes no pacote.
- Explicita o tratamento de segredo, PII e dados de cliente fornecidos
  diretamente e adiciona regressão ligada ao cenário S3.
- Registra a baseline do editor: instruções byte-exatas, 11 anexos, rótulos de
  modelo, recursos, ausência de Action e seis ensaios online observados.
- Registra em `reports/online-parity-2026-09-21.md` a execução autenticada
  P1–P6, com fingerprints completos, 72/72 pontos, 36/36 gates e retenção
  explícita sem outputs brutos.
- Mantém o lifecycle `candidate`: a paridade online qualifica a baseline, mas
  não declara validação ou instalação local, publicação ou release da skill.

## 0.1.0

- Estrutura inicial do template canônico e captura da fonte.
