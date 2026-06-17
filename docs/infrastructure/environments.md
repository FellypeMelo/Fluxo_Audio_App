# Ambientes de Execução (Environment Management)

Este documento especifica como o **Fluxo_Audio_App** gerencia e isola seus diferentes ambientes de execução. Como o aplicativo adota um modelo descentralizado local-first, o gerenciamento de ambientes baseia-se na injeção de parâmetros em tempo de build e compilação condicional no código Dart.

---

## 1. Definição dos Ambientes de Execução

O ciclo de vida do aplicativo apoia-se em três ambientes principais:

| Ambiente | Sigla | Objetivo | Configuração de Persistência | Comportamento de Logs |
| :--- | :--- | :--- | :--- | :--- |
| **Desenvolvimento** | `dev` | Codificação local e testes interativos rápidos | SharedPreferences local do desenvolvedor | Verboso (exibe payloads de rede e eventos do microfone) |
| **Testes** | `test` | Execução de testes unitários e de widgets automatizados | Mocks de memória em tempo de execução (`setMockInitialValues`) | Apenas saídas de teste do framework |
| **Produção** | `prod` | Versão empacotada enviada para as lojas de aplicativos | SharedPreferences protegido por sandbox nativa do SO | Silencioso (zero logs de payloads ou chaves no console) |

---

## 2. Injeção de Variáveis em Tempo de Compilação (Dart Defines)

Para alternar comportamentos operacionais e endpoints sem alterar o código-fonte manualmente, o aplicativo utiliza o mecanismo de **`--dart-define`** do Flutter SDK:

```bash
# Executar aplicativo em ambiente de desenvolvimento
flutter run --dart-define=APP_ENV=dev

# Compilar release para produção
flutter build appbundle --release --dart-define=APP_ENV=prod
```

### Código de Leitura no Dart:
A leitura da variável de ambiente é efetuada no arquivo [main.dart](file:///G:/Programas/Fluxo_Audio_App/lib/main.dart) utilizando constantes estáticas em tempo de compilação:

```dart
class AppConfig {
  static const String environment = String.fromEnvironment(
    'APP_ENV',
    defaultValue: 'prod',
  );

  static bool get isDevelopment => environment == 'dev';
  static bool get isProduction => environment == 'prod';
}
```

---

## 3. Isolamento Físico de Bancos de Dados por Ambiente

* **No Ambiente `dev` / `prod`:** A persistência lê e grava no arquivo físico XML ou UserDefaults persistido do sistema de arquivos do dispositivo. O desenvolvedor local e o usuário final trabalham em seus respectivos bancos de dados sandbox sem qualquer colisão de dados.
* **No Ambiente `test`:** Testes automatizados executam operações em disco simuladas em memória RAM (Mocking). Isso garante que testes executados pelo pipeline de integração contínua (CI) não corrompam os dados do banco local de desenvolvimento ou produção real do desenvolvedor.