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

## Instalação seletiva da versão validada

O checkout inteiro não é uma pasta de skill. `agent.yaml` continua sendo a
fonte da instalação; sua allowlist `skill_runtime.package` deve coincidir com o
manifesto autocontido `skill-runtime.yaml` que entra no pacote. Instale somente
esses 25 caminhos em uma pasta nova chamada `ac-estrategista-conteudo-dai` no
diretório de skills do runtime. Preserve a estrutura relativa e copie arquivos
regulares; não copie `agent.yaml`, `.git`, `.github`, históricos de `knowledge/`,
manifesto de captura, avaliações, governança, relatórios, scripts, testes ou
`.gitkeep`.

Antes de instalar ou reinstalar, valide a skill na raiz do repositório:

```bash
bash tests/validate-agent-repo.test.sh
bash tests/validate-content-skill.test.sh
bash scripts/validate-agent-repo.sh
ruby scripts/validate-content-skill.rb
python_bin="${PYTHON:-$(command -v python3)}"
quick_validator="$(find "${CODEX_HOME:-$HOME/.codex}/skills" "$HOME/.agents/skills" -path '*/skill-creator/scripts/quick_validate.py' -print -quit 2>/dev/null)"
test -n "$python_bin" && test -n "$quick_validator"
"$python_bin" -c 'import yaml' || { echo 'Defina PYTHON para um python3 com PyYAML.' >&2; exit 1; }
"$python_bin" "$quick_validator" .
git diff --check
```

Se o `python3` padrão não tiver PyYAML, defina `PYTHON` para outro interpretador
compatível antes de executar o bloco. O comando descobre o validador nas raízes
padrão sem presumir nome de usuário ou caminho absoluto da máquina.

Para conferir uma instalação seletiva, compare a lista de arquivos com
`skill-runtime.yaml`: devem existir 25 arquivos, 11 em
`knowledge/active-2026-09-21/`, zero symlinks e zero `.gitkeep`.

## Revalidar o comportamento

Execute P1–P6 em `evaluations/parity/`. Cada caso vale 12 pontos e exige mínimo
10/12, nenhuma dimensão com zero e seis gates em PASS. Uma avaliação
automatizada/agente pode qualificar a skill; revisão humana pode acrescentar
controle, mas não é o único mecanismo de qualificação. A versão 0.2.0 já foi
promovida a `validated`; release e publicação continuam decisões separadas e
não são afirmadas por este pacote. Como a promoção alterou arquivos do pacote,
a instalação seletiva anterior precisa ser refeita para receber os metadados e
as métricas validadas.
