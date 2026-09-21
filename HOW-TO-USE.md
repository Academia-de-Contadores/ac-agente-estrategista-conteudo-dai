# Como usar a skill Conteúdo D.A.I.

## Começo rápido

Escreva `Use $ac-estrategista-conteudo-dai` e diga o formato, o público, a cena
ou dor e o CTA. Se não souber tudo, peça o rascunho mesmo assim: a skill pode
usar uma hipótese editorial marcada e entregar algo revisável.

```text
Use $ac-estrategista-conteudo-dai com /carrossel. Faça 8 slides para donas de escritório sobre onboarding no improviso. CTA para o Desafio Contadora CEO com IA. Não invente números.
```

Não envie dados de cliente, senha, token, certificado ou material sem
autorização de uso.

## Escolher a saída

- `/carrossel`: slides completos, legenda e QA;
- `/reels`: roteiro com timing, fala, texto na tela, cena, legenda e QA;
- `/angulos`: cinco alternativas por padrão, cada uma com evidência/lacuna,
  CTA e claim evitado;
- `/qa-claims`: tabela de risco, reescrita e peça completa revisada;
- `/sequencia`: textos completos por canal, com papel e estado de execução;
- `/adaptar`: converte uma peça para outro canal sem aumentar a certeza;
- handoff técnico: preserva o conteúdo útil e prepara a pergunta ao especialista.

Os contratos completos estão em `references/content-outputs.md`.

## Entender evidência e revisão

O Knowledge oferece cenas e modelos, não prova resultados nem regra vigente.
Quando faltar suporte, a resposta usa `[LACUNA DE EVIDÊNCIA]`,
`[REVISÃO TÉCNICA]` ou `[HIPÓTESE EDITORIAL]`. Isso bloqueia somente o claim
sem suporte; o restante do rascunho continua sendo entregue.

Claims como “elimina erros”, “economia garantida”, “cliente garantido”, “dobra
a carteira em 90 dias” ou “substitui o contador” são bloqueados e reescritos.

## Entender publicação

Criar conteúdo é preparação. Publicar, programar, impulsionar ou enviar exige
aprovação humana imediatamente antes de cada ação exata, com peça, versão,
canal/conta, público e horário definidos. Sem isso, o estado permanece
`NÃO PUBLICADO / NÃO ENVIADO`.

## Instalação seletiva da candidata

O checkout inteiro não é uma pasta de skill. A lista normativa está em
`agent.yaml`, em `skill_runtime.package`. Instale somente esses 25 caminhos em
uma pasta nova chamada `ac-estrategista-conteudo-dai` no diretório de skills do
runtime. Preserve a estrutura relativa e copie arquivos regulares; não copie
`.git`, `.github`, históricos de `knowledge/`, manifesto, avaliações,
governança, relatórios, scripts, testes ou `.gitkeep`.

Antes de instalar, valide a candidata na raiz do repositório:

```bash
bash tests/validate-agent-repo.test.sh
bash tests/validate-content-skill.test.sh
bash scripts/validate-agent-repo.sh
ruby scripts/validate-content-skill.rb
/Users/levy/.pyenv/versions/3.10.13/bin/python3 /Users/levy/.codex/skills/.system/skill-creator/scripts/quick_validate.py .
git diff --check
```

Para conferir uma instalação seletiva, compare a lista de arquivos com
`skill_runtime.package`: devem existir 25 arquivos, 11 em
`knowledge/active-2026-09-21/`, zero symlinks e zero `.gitkeep`.

## Avaliar antes de promover

Execute P1–P6 em `evaluations/parity/`. Cada caso vale 12 pontos e exige mínimo
10/12, nenhuma dimensão com zero e seis gates em PASS. Uma avaliação
automatizada/agente pode qualificar a candidata; revisão humana pode acrescentar
controle, mas não é o único mecanismo de qualificação. Promoção de lifecycle e
release continuam decisões separadas e não são afirmadas por este pacote.
