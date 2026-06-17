# Diretrizes de Interface (UI Guidelines)

Este documento estabelece as regras e convenções de layout, hierarquia visual e estados de interface (UI) a serem seguidos de forma estrita no desenvolvimento do **Fluxo_Audio_App**.

---

## 1. Anatomia do Card de Tarefa (TaskCard)

O card de exibição da tarefa é o componente mais interativo do aplicativo. Sua estrutura física deve seguir a composição abaixo:

```text
┌──────────────────────────────────────────────────────────┐
│ █ │ Estudar Flutter e Dart                   [Alta]      │ < Barra de prioridade lateral esquerda + Tag
│ █ │ Concluir módulos de arquitetura                      │
│ █ │                                                      │
│ █ │ 📅 Prazo: Amanhã às 18:00              [x] Concluir  │ < Prazos + Botão checkbox/concluir
└──────────────────────────────────────────────────────────┘
```

* **Indicador Lateral de Prioridade:** Uma barra de cor sólida com largura física de **6.0 pixels** fixada na borda lateral esquerda do card. A cor é ditada pela escala de prioridades (Vermelho = Alta, Amarelo = Média, Cinza = Baixa).
* **Checkbox / Botão de Conclusão:** Posicionado na extremidade direita para permitir o toque rápido com o polegar.
* **Margens Internas (Padding):** Padding de **16.0 pixels** em todas as direções do conteúdo do card para garantir a legibilidade.

---

## 2. Estados Especiais de Interface

### A. Estado Vazio (Empty State)
* **Caso de Uso:** Quando o usuário abre o aplicativo pela primeira vez ou quando todas as tarefas foram deletadas/concluídas.
* **Diretriz de Design:**
  * O aplicativo não deve mostrar uma tela em branco.
  * Deve renderizar uma ilustração minimalista centralizada.
  * Abaixo da ilustração, um texto descritivo e amigável: *"Sua lista está limpa! Toque no botão de microfone abaixo e fale suas tarefas."*

### B. Estado de Carregamento (Loading State)
* **Caso de Uso:** Enquanto a chamada da API do OpenRouter está processando a extração semântica.
* **Diretriz de Design:**
  * Não use apenas um spinner genérico bloqueando a tela inteira.
  * Implemente o efeito de **Skeleton/Shimmer** na lista de tarefas, mostrando silhuetas translúcidas e pulsantes na forma de cards de tarefas para indicar que novos itens estão sendo carregados e estruturados.

---

## 3. Barra de Captura e Entrada de Dados (Chat Input)

A barra de entrada é o ponto focal de interação inferior:
* **Efeito Visual:** Fundo com leve desfoque de superfície (*BackdropFilter* - efeito vidro) para permitir que a lista de tarefas role por trás dela suavemente.
* **Alinhamento do Microfone:** O botão de microfone redondo deve possuir diâmetro físico de **56x56 pixels lógicos** com cor de acento Indigo.
* **Estilo da Caixa de Texto:** Cantos arredondados com `BorderRadius.circular(24.0)` e texto placeholder *"Fale ou digite uma tarefa..."*.

---

## 4. Feedbacks Visuais Rápidos (Feedback Loops)

* **Exclusão de Tarefas (Snackbar com Undo):**
  Ao deletar uma tarefa (seja via swipe ou editor), o aplicativo deve disparar um **Snackbar** na parte inferior com a mensagem: *"Tarefa excluída"*. O Snackbar deve exibir obrigatoriamente um botão de ação com o rótulo **"Desfazer"**, permitindo que o usuário reverta o apagamento acidental dentro de 4 segundos.
* **Notificação de Fallback (Voz/IA):**
  Se a conexão de rede falhar e o aplicativo aplicar o fallback, exiba um aviso discreto: *"Criado localmente sem internet"*.