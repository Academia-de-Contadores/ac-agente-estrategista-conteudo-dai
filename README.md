# Estrategista de Conteúdo D.A.I. Oficial

| Campo | Valor |
| --- | --- |
| ID | `ac.estrategista-conteudo-dai` |
| Versão | `0.1.0` |
| Lifecycle | `source-capture` |

## Propósito

Cria e revisa conteúdo para o Desafio Contadora CEO com IA, incluindo revisão
de claims e validação humana.

Este repositório é a fonte de verdade do agente existente. Profiles e adapters
apenas recortam ou traduzem seu núcleo canônico; não redefinem o comportamento.

## Usar e manter este agente

1. Leia `objectives/`, `identity/` e `instructions/` antes de operar ou alterar o
   agente; esses diretórios definem missão, papel, comportamento e limites.
2. Para reconstruir ou adaptar esta versão, siga `HOW-TO-USE.md` e use
   `agent.yaml` como índice dos componentes canônicos.
3. Registre novas capacidades em `skills/`, fontes curadas em `knowledge/` e
   contratos externos em `connectors/`; nunca registre credenciais.
4. Adicione avaliações para cada mudança comportamental e execute:

   ```bash
   bash tests/validate-agent-repo.test.sh
   bash scripts/validate-agent-repo.sh
   ```

5. Siga o processo de contribuição antes de abrir um pull request.

## Guias do repositório

- [Como usar e reconstruir o agente](HOW-TO-USE.md)
- [Estrutura e destino de cada arquivo](docs/REPOSITORY-STRUCTURE.md)
- [Como contribuir](governance/CONTRIBUTING.md)
- [Política de dados e segredos](governance/DATA-AND-SECRETS.md)
- [Política de mudanças](governance/CHANGE-POLICY.md)

## Proteções versionadas e verificáveis

O `.gitignore` reduz o risco de adicionar artefatos locais conhecidos, e
`scripts/validate-agent-repo.sh` rejeita arquivos proibidos, artefatos RAG locais
e arquivos maiores que 5 MB. O workflow `validate` executa esse validador em
pull requests e pushes para `main`. O `CODEOWNERS` solicita revisão para áreas
sensíveis. Workflow e `CODEOWNERS`, isoladamente, não provam bloqueio de merge;
branch protection, rulesets, visibilidade e demais controles devem ser
confirmados na configuração remota. Consulte `reports/task-3-report.md` para a
evidência local e seus limites.
