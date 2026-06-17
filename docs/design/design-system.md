# Sistema de Design (Design System Tokens)

Este documento especifica a linguagem de design visual, os tokens de estilo e a biblioteca de componentes visuais do **Fluxo_Audio_App**. A adoção estrita deste sistema garante uma interface de usuário (UI) premium, consistente e moderna.

---

## 1. Tokens de Cores e Paletas Semânticas

A paleta de cores adota a filosofia do **Material 3** com forte inclinação para tons frios de ardósia (*Slate*) e acentos tecnológicos, otimizando o conforto visual e a clareza.

```text
Modo Escuro (Principal)
├─ Slate 900 (Fundo Principal): #0F172A
├─ Slate 800 (Superfície Cards): #1E293B
└─ Indigo 500 (Acento Primário): #6366F1

Modo Claro (Alternativo)
├─ Slate 50 (Fundo Principal): #F8FAFC
├─ White (Superfície Cards): #FFFFFF
└─ Indigo 600 (Acento Primário): #4F46E5
```

### Paleta Semântica de Prioridades (Status Colors)
* **Prioridade Alta:** Vermelho Coral (#EF4444)
  * Representa urgência, perigo ou ação imediata.
* **Prioridade Média:** Âmbar / Amarelo Mostarda (#F59E0B)
  * Representa atenção intermediária ou tarefas normais.
* **Prioridade Baixa:** Cinza Ardósia (#64748B)
  * Representa ideias gerais, lembretes ou tarefas sem prazo.

---

## 2. Tipografia e Escala de Fontes

O aplicativo utiliza a escala de fontes padrão do Material 3 (`TextTheme`), priorizando fontes limpas e geométricas (como **Inter** ou **Outfit** obtidas de forma adaptada do pacote `google_fonts` ou fontes nativas do sistema):

| Token Flutter | Peso | Tamanho | Uso Recomendado |
| :--- | :--- | :--- | :--- |
| `headlineMedium` | Bold | 28sp | Títulos principais de tela (Estatísticas, Cabeçalhos) |
| `titleLarge` | Semi-Bold | 20sp | Título de tarefas nos modais de edição |
| `bodyLarge` | Regular | 16sp | Título de tarefas nos cards e inputs de texto |
| `bodyMedium` | Regular | 14sp | Descrição de tarefas e prazos |
| `labelSmall` | Medium | 11sp | Rótulos de tags de prioridades e datas |

---

## 3. Primitivos Visuais: Cantos, Bordas e Sombras

* **Bordas Arredondadas (Radius):**
  * Cards de Tarefa: `BorderRadius.all(Radius.circular(16.0))` para suavizar a forma.
  * Modais e BottomSheets: `BorderRadius.vertical(top: Radius.circular(24.0))`.
  * Inputs e Botões: `BorderRadius.all(Radius.circular(12.0))`.
* **Profundidade (Sombras):**
  * O aplicativo utiliza sombras extremamente suaves baseadas em opacidades baixas de cinzas escuros para criar a ilusão de profundidade sem poluir a interface:
    `boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10.0, offset: Offset(0, 4))]`

---

## 4. Animações e Micro-interações

O design do aplicativo ganha dinamismo através de transições fluidas:
* **Entrada de Tarefas (Fade-in):** Ao criar uma tarefa, o card correspondente deve surgir na lista usando um efeito de fade-in combinado com um leve deslocamento vertical ascendente (usando `AnimatedList` ou transições de opacidade de 300ms).
* **Animação de Gravação:** O botão de microfone exibe um contorno pulsante com ondas concêntricas oscilantes em gradiente de opacidade enquanto o áudio estiver sendo capturado.
* **Transição de Conclusão:** Ao marcar a tarefa como concluída, a redução de opacidade (para 60%) e a inserção da linha de riscado (*strikethrough*) no texto ocorrem por meio de uma interpolação visual suave (`AnimatedDefaultTextStyle`).