# Estratégia de Branching (Branching Strategy)

Este documento define a estratégia de ramificação do Git adotada no ciclo de desenvolvimento do **Fluxo_Audio_App**. A aderência a estas diretrizes é mandatória para manter a estabilidade do código, garantir a integração contínua (CI) e simplificar a liberação de releases para produção.

---

## 1. Modelo Principal: Trunk-Based Development (TBD)

O projeto adota o modelo de **Trunk-Based Development** com branches de ciclo de vida curto. Nesse modelo, a branch principal `master` (ou `main`) representa o tronco estável da aplicação, e os desenvolvedores integram suas alterações frequentemente.

```mermaid
gitGraph
    commit id: "Inicial"
    branch feature/capture-voice
    checkout feature/capture-voice
    commit id: "feat: adiciona stt"
    commit id: "test: testes do stt"
    checkout master
    merge feature/capture-voice id: "Merge PR #1"
    branch hotfix/fix-parser
    checkout hotfix/fix-parser
    commit id: "fix: resolve quebra de JSON"
    checkout master
    merge hotfix/fix-parser id: "Merge PR #2"
```

### Regras do Modelo TBD:
* **Integração Frequente:** Ramificações secundárias (*Feature Branches*) devem durar no máximo **2 a 3 dias** antes de serem mergeadas no tronco principal.
* **Tronco Sempre Compilável:** A branch `master` deve permanecer em estado "pronto para produção" (deployable) a todo momento. Commits que quebram a compilação ou falham nos testes unitários são terminantemente proibidos na branch principal.

---

## 2. Nomenclatura Padronizada de Branches

Todas as branches criadas no repositório local e remoto devem seguir a convenção de nomenclatura definida abaixo:

| Prefixo | Caso de Uso | Exemplo Prático |
| :--- | :--- | :--- |
| `feature/` | Desenvolvimento de nova funcionalidade ou melhoria de UI | `feature/voice-recorder-ui` |
| `bugfix/` | Correção de defeito/bug identificado no ciclo normal | `bugfix/api-timeout-handling` |
| `hotfix/` | Correção urgente de falha crítica em produção | `hotfix/crash-on-ios-startup` |
| `refactor/` | Melhorias de arquitetura de código sem alteração funcional | `refactor/clean-task-provider` |
| `docs/` | Criação ou atualização exclusiva de documentações | `docs/update-architecture-adr` |
| `test/` | Inclusão ou refatoração exclusivamente de testes automatizados | `test/add-unit-tests-services` |

---

## 3. Fluxo de Trabalho (Workflow) Passo a Passo

O fluxo padrão para qualquer alteração no repositório segue estas etapas:

1. **Atualizar o Repositório Local:**
   ```bash
   git checkout master
   git pull origin master
   ```
2. **Criar a Branch de Trabalho:**
   ```bash
   git checkout -b feature/minha-nova-funcionalidade
   ```
3. **Desenvolver e Commitar localmente** (seguindo o padrão de commits estabelecido em `commits.md`).
4. **Sincronizar com o Trunk (Rebase):**
   Antes de enviar, atualize sua branch com as alterações mais recentes da `master` para resolver conflitos localmente:
   ```bash
   git fetch origin
   git rebase origin/master
   ```
5. **Publicar e Abrir Pull Request (PR):**
   ```bash
   git push origin feature/minha-nova-funcionalidade
   ```
   * Abra o PR direcionado à branch `master`.
   * Preencha a descrição do PR detalhando as alterações realizadas e os testes executados.

---

## 4. Políticas de Merge e Aprovação

Nenhum código entra na branch `master` sem passar pelos seguintes critérios de aceitação:
* **Revisão por Pares (Peer Review):** O PR deve receber a aprovação de pelo menos 1 revisor (conforme política descrita em `code-review.md`).
* **Check de Integração Contínua (CI):** Os pipelines automatizados do GitHub Actions devem compilar a aplicação com sucesso (`flutter build apk` ou equivalente) e passar por todos os testes sem falhas (`flutter test`).
* **Clean History:** O merge deve ser feito preferencialmente usando a opção **Squash and Merge** no GitHub, condensando commits pequenos e mantendo o histórico da branch `master` limpo e legível.