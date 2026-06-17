# Diretrizes de Acessibilidade (Accessibility Guidelines - A11y)

Este documento especifica os padrões de acessibilidade implementados na interface do **Fluxo_Audio_App**. A acessibilidade garante que o aplicativo seja utilizável pelo maior espectro possível de pessoas, incluindo usuários com deficiências visuais, motoras, auditivas ou cognitivas, em conformidade com as diretrizes do **WCAG 2.1 (Web Content Accessibility Guidelines)** adaptadas para mobile.

---

## 1. Suporte a Leitores de Tela (Semantics)

Os sistemas operacionais móveis utilizam motores de leitura de tela (*TalkBack* no Android e *VoiceOver* no iOS) para navegar na interface de forma auditiva. O aplicativo implementa as seguintes regras:
* **Uso do Widget `Semantics`:** Todos os botões interativos de ícone único (sem texto descritivo adjacente) devem ser explicitamente envelopados no widget `Semantics` do Flutter fornecendo rótulos claros em português:
  * O botão de microfone flutuante deve ser anunciado como: *"Gravar comando de voz. Toque duas vezes para iniciar a gravação"*.
  * O checkbox de conclusão de tarefas deve anunciar o estado atual: *"Marcar como concluída"* ou *"Tarefa concluída"*.
* **Ocultação de Decoradores:** Ícones puramente ilustrativos ou decorativos devem ter a propriedade `excludeSemantics: true` ou ser envelopados em `ExcludeSemantics` para evitar poluição sonora e acelerar a navegação do leitor.

---

## 2. Contraste de Cores e Modos Visuais (WCAG AA)

A paleta de cores do aplicativo foi desenhada para garantir leitura confortável em ambientes com alta ou baixa luminosidade:
* **Contraste Mínimo:** Todos os textos principais mantêm uma taxa de contraste de pelo menos **4.5:1** em relação ao fundo, atendendo ao nível AA do WCAG 2.1.
* **Sinalização Dupla de Prioridade:** Para não depender exclusivamente da visão de cores (o que excluiria usuários com daltonismo), a prioridade de uma tarefa é sinalizada de forma dupla:
  * Pela **cor** do indicador lateral (vermelho, amarelo, azul/cinza).
  * Por um **rótulo textual explícito** em formato legível ("Alta", "Média", "Baixa") renderizado no card de edição ou detalhes.

---

## 3. Escalonamento Dinâmico de Texto (Text Scaling)

* **Adaptabilidade ao Sistema:** O aplicativo não bloqueia nem fixa o tamanho das fontes em pixels lógicos brutos. As fontes utilizam escala de densidade dinâmica, respeitando o tamanho configurado pelo usuário nas preferências globais do Android ou iOS.
* **Layout Flexível (Flex e Wrap):** Componentes de card de tarefa utilizam layouts flexíveis (`Wrap`, `Flexible`, `Expanded`) para garantir que se o usuário configurar a fonte no modo "Extra Grande", o texto da tarefa quebre a linha de forma harmoniosa sem cortar caracteres ou gerar estouros de renderização (*Layout Overflow*).

---

## 4. Áreas de Toque Mínimas (Hit Target Sizes)

Para facilitar a interação de usuários com tremores motores ou dificuldades de precisão fina:
* **Hit Target 48x48:** Todos os elementos clicáveis (botões de menu, checkboxes, botões de ação rápida de swipe, caixa de configurações) possuem uma área de toque física mínima de **48x48 pixels lógicos**, conforme recomendado pelas diretrizes do Material Design e Apple Human Interface Guidelines.
* **Espaçamento entre Cards:** Os cards de tarefas na lista mantêm margens de distanciamento adequadas para prevenir cliques acidentais em itens vizinhos.

---

## 5. Feedback Haptico (Haptic Feedback)

Como canal complementar de interação sensorial, o aplicativo faz uso do motor de vibração física do dispositivo móvel:
* **Confirmação de Ação:** O aplicativo aciona o feedback tátil nativo (`HapticFeedback.lightImpact()`) nas seguintes interações:
  1. Ao iniciar a gravação por voz (para notificar o usuário de que ele já pode falar).
  2. Ao encerrar a gravação com sucesso.
  3. Ao deletar uma tarefa via swipe lateral.