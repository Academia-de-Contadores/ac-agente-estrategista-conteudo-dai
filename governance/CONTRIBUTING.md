# Contribuindo

## Pré-requisitos

- acesso ao repositório privado, Git configurado e uma cópia atual de `main`;
- leitura de `README.md`, `HOW-TO-USE.md` e das políticas em `governance/`;
- nenhuma credencial, dado de cliente, conversa, log, corpus ou índice RAG no
  diretório de trabalho versionado.

## Escolha a pasta antes de editar

Use `docs/REPOSITORY-STRUCTURE.md` como mapa de destino. Em especial, regras
permanentes ficam em `instructions/`, procedimentos acionáveis em `skills/`,
conteúdo fornecido ao modelo em `knowledge/`, documentação humana em `docs/` e
contratos externos em `connectors/`. Não use profile ou adapter para redefinir o
núcleo canônico.

## Classifique a mudança

| Classe | Exemplos | Exigências |
| --- | --- | --- |
| Editorial | clareza de documentação sem alterar comportamento | revisão e validação estrutural |
| Funcional | skill, workflow, conhecimento comportamental ou contrato de conector | revisão, avaliações direcionadas e regressão aplicável |
| Crítica | autoridade, escopo, soul, guardrail, classe de dados ou escrita externa | ADR, owner, revisão de segurança e suíte completa |

Consulte `CHANGE-POLICY.md` quando houver dúvida; uma mudança comportamental
sempre atualiza a versão e as avaliações correspondentes.

## Matriz de mudança → arquivos mínimos

| Mudança | Arquivos mínimos |
| --- | --- |
| Objetivo, identidade ou comportamento permanente | componente canônico afetado, `agent.yaml`, avaliação e `CHANGELOG.md` |
| Skill ou workflow | `SKILL.md`, `skill-runtime.yaml`, referências, avaliação e `skill_runtime` em `agent.yaml` |
| Knowledge | arquivo curado, manifesto com fonte/data/licença/hash e avaliação se alterar resposta ou risco |
| Connector ou Action | contrato, exemplo sem segredo, fallback, avaliação e `agent.yaml` |
| Profile ou adapter | manifesto com `canonical_agent_version`, documentação de limitação e regressão aplicável |
| Decisão crítica | ADR em `decisions/`, alteração canônica, avaliação, segurança, versão e changelog |
| Documentação humana | guia afetado, `CHANGELOG.md` quando relevante e validação estrutural |

## Fluxo de contribuição

1. Crie uma branch a partir de `main`; não faça push direto em `main`.
2. Faça commits pequenos, imperativos e com escopo claro. Não misture refatoração
   não relacionada com uma mudança funcional ou crítica.
3. Atualize as avaliações antes da implementação quando a alteração muda
   comportamento, limites, dados ou integração.
4. Execute `bash tests/validate-agent-repo.test.sh`,
   `bash tests/validate-content-skill.test.sh` e
   `bash scripts/validate-agent-repo.sh`; inclua validações específicas do
   componente modificado.
5. Aplique versionamento semântico conforme `RELEASE-POLICY.md`, atualize
   `agent.yaml`, `CHANGELOG.md` e os manifests de profiles/adapters quando a
   mudança exigir nova versão canônica.
6. Abra um pull request com classe, objetivo, arquivos afetados, riscos,
   avaliações e comandos executados. Use squash merge.
7. Solicite revisão humana. Áreas críticas exigem a aprovação do owner definido
   em `CODEOWNERS`; revisão de segurança não é dispensada por automação.

## Segurança antes de publicar

Credenciais existem somente no runtime, normalmente como variáveis de ambiente.
Use exemplos sintéticos e descreva apenas nomes de variáveis e contratos. Se um
segredo ou dado sensível aparecer, pare, remova-o do histórico de trabalho,
revogue/rotacione a credencial e registre o incidente conforme
`DATA-AND-SECRETS.md`.
