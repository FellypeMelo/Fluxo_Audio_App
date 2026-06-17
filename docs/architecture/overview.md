# Visão Geral da Arquitetura (Mobile Clean Architecture)

O aplicativo segue uma arquitetura orientada a camadas (Layered Architecture) adaptada para Flutter, dividida em três domínios principais:

1. **Presentation Layer (UI/UX):** Widgets Flutter, `Provider` para reatividade. Consome casos de uso sem acoplar regras de negócio.
2. **Domain Layer:** Entidades (`Task`), abstrações de repositórios (`TaskRepositoryInterface`) e lógicas de negócios (Parsing e validação do JSON da IA).
3. **Data/Infrastructure Layer:** Implementações concretas.
   - `SharedPreferencesTaskRepository`: E/S local.
   - `OpenRouterAIService`: Integração externa. Envio de prompts em formato `few-shot` para garantir saída determinística.

## Fluxo de Dados Unidirecional
`User Input` -> `Provider (ViewModel)` -> `OpenRouterAIService` -> `Provider (ViewModel)` -> `TaskRepository (Save)` -> `UI Rebuild`
