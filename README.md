# Fluxo — Do Pensamento Caótico à Tarefa Clara

**Fluxo** é um aplicativo móvel de produtividade pessoal desenvolvido para a disciplina de Desenvolvimento Mobile. Ele utiliza Inteligência Artificial Generativa para transformar descrições livres de tarefas (via texto ou voz) em listas organizadas e priorizadas, tudo armazenado localmente no dispositivo (sem servidor/backend).

## 🚀 Funcionalidades

- **Captura Inteligente:** Digite ou fale livremente o que você precisa fazer.
- **Organização por IA:** Integração com a API OpenRouter (Llama 3.2 3B) para extrair tarefas estruturadas em JSON.
- **Voz para Texto:** Reconhecimento de voz nativo (`speech_to_text`) para captura de tarefas.
- **Armazenamento Local:** Dados salvos localmente via `SharedPreferences`.
- **Modo Escuro:** Interface adaptativa respeitando a preferência do sistema.
- **Histórico e Estatísticas:** Acompanhe suas tarefas concluídas dos últimos 7 dias.

## 🛠️ Tecnologias Utilizadas

- **Framework:** Flutter (Dart)
- **Gerenciamento de Estado:** Provider
- **Persistência:** SharedPreferences
- **IA:** OpenRouter API (`http` package)
- **Voz:** speech_to_text
- **UI:** Flutter Slidable (swipe gestures)

## 📦 Como Rodar o Projeto

### Pré-requisitos
- Flutter SDK (versão 3.0+)
- Android Studio ou Xcode (para emuladores/dispositivos)

### Configuração

1. Instale as dependências:
   ```bash
   flutter pub get
   ```
2. Para usar a IA, você precisará configurar uma variável de ambiente para a sua chave da OpenRouter:
   ```bash
   # No arquivo lib/services/openrouter_service.dart,
   # substitua a String.fromEnvironment('OPENROUTER_KEY')
   # pela sua chave real se não estiver usando o comando abaixo.
   ```
   *Ou execute rodando:*
   ```bash
   flutter run --dart-define=OPENROUTER_KEY=sua_chave_aqui
   ```

### Execução

```bash
flutter run
```

## 📋 Diferenciais Técnicos

- **Arquitetura Minimalista:** O app opera 100% no dispositivo do usuário, garantindo privacidade e custo operacional zero.
- **Prompt Engineering:** O prompt do sistema foi estruturado para garantir que a IA responda apenas com o JSON esperado, facilitando o parsing pelo app.
- **Experiência do Usuário (UX):** Swipe gestures, feedback háptico e feedback visual de conclusão de tarefas para aumentar o engajamento.

---
*Projeto desenvolvido para a disciplina de Desenvolvimento Mobile.*
