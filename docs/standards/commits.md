# Padrões de Commits (Commit Message Standards)

Este documento define o padrão de escrita de mensagens de commit adotado para o controle de versão do **Fluxo_Audio_App**. Seguir estas regras é essencial para garantir a legibilidade do histórico do Git e possibilitar a automação de geração de Changelogs.

---

## 1. Convenção Base: Conventional Commits

O projeto adota a especificação **Conventional Commits v1.0.0**, que impõe uma estrutura simples de mensagens com significado semântico sobre as alterações introduzidas no repositório.

A mensagem de commit deve seguir a seguinte estrutura sintática:

```text
<tipo>(<escopo-opcional>): <descrição-curta-em-minúsculo>

[corpo-detalhado-opcional-com-racional]

[rodapé-opcional-referenciando-issues]
```

---

## 2. Tipos de Commits Permitidos

O tipo (*type*) inserido no início da mensagem classifica a natureza da alteração. Use exclusivamente os tipos listados abaixo:

| Tipo | Finalidade Prática | Exemplo |
| :--- | :--- | :--- |
| `feat` | Introdução de uma nova funcionalidade ou recurso no aplicativo | `feat(voice): adiciona gravador de voz e visualização de ondas` |
| `fix` | Resolução de um bug ou comportamento incorreto em produção/teste | `fix(parser): corrige tratamento de null no parseador de prazo` |
| `docs` | Alterações exclusivas em arquivos de documentação (.md) | `docs(standards): descreve padronização de commits` |
| `style` | Mudanças estéticas ou de formatação que não afetam a lógica | `style(widgets): aplica trailing commas nos cards de tarefas` |
| `refactor` | Mudança na estrutura de código que não altera comportamento | `refactor(provider): unifica métodos de persistência local` |
| `test` | Inclusão de novos testes ou correções de testes existentes | `test(service): cria testes de mock HTTP do openrouter` |
| `chore` | Tarefas administrativas, build configs, depósitos de pacotes | `chore(deps): atualiza pacote path_provider para versão 2.1.0` |

---

## 3. Escopo e Descrição Curta

* **Escopo (Scope):** É opcional, mas recomendável para contextualizar qual componente foi alterado. Exemplos: `(voice)`, `(ui)`, `(task-card)`, `(provider)`, `(deps)`.
* **Descrição Curta:**
  * Deve ser direta e descritiva.
  * Deve iniciar com letra minúscula.
  * Não deve terminar com ponto final (`.`).
  * Deve utilizar o verbo no presente/imperativo (ex: *"adiciona"* em vez de *"adicionei"* ou *"adicionado"*).

---

## 4. Exemplos de Mensagens de Commit

### Exemplos Corretos (Aprovados):
* `feat(ui): adiciona suporte ao modo escuro em todo o layout`
* `fix(voice): impede gravação de áudio se permissão de microfone for negada`
* `docs: atualiza arquitetura C4 no readme principal`
* `refactor(storage): migra desserialização de tarefas para helper isolado`

### Exemplos Incorretos (Rejeitados):
* `Ajustes na tela` (Não indica tipo, não possui escopo, não segue o padrão).
* `feat: RESOLVE BUG DE TEMA.` (Letras maiúsculas, com ponto final, tipo inadequado para correção).
* `Consertando erro de conexao` (Falta de tipo de commit e descrição mal formatada).

---

## 5. Boas Práticas de Commit

* **Commits Atômicos:** Faça commits pequenos e focados. Evite empacotar múltiplos tópicos em um único commit (ex: fazer refatoração no banco e criar uma tela no mesmo commit). Isso facilita o rollback caso um erro apareça.
* **Mensagens com Breaking Changes:** Se a mudança quebrar compatibilidade retroativa (como mudanças estruturais no banco JSON), adicione um ponto de exclamação `!` logo após o tipo e inclua `BREAKING CHANGE:` na primeira linha do corpo do commit:
  ```text
  refactor(storage)!: altera schema JSON de salvamento de tarefas

  BREAKING CHANGE: O formato das chaves salvas no SharedPreferences mudou.
  Registros antigos serão redefinidos automaticamente na próxima inicialização.
  ```
* **Não Commitar Lixo:** Assegure-se de que arquivos gerados localmente (como builds locais `.apk`, configurações de IDE `.idea`, `.vscode` ou caches locais de dependências `.dart_tool`) não façam parte do commit, mantendo o arquivo `.gitignore` sempre ativo e atualizado.