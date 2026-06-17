# Arquitetura de Inquilinato (Tenancy and Data Isolation Design)

Este documento especifica o modelo de inquilinato (*Tenancy Architecture*) adotado no **Fluxo_Audio_App**. Em conformidade com a filosofia *local-first* e *backend-less*, o modelo de inquilinato é descentralizado no cliente.

---

## 1. Single-Tenant por Design (Inquilinato Único)

Diferente de aplicações baseadas em nuvem no modelo **SaaS (Software as a Service)** tradicional, onde múltiplos clientes (empresas ou pessoas) dividem os mesmos recursos físicos de processamento e banco de dados centralizado (Multi-Tenancy lógico com filtragens por `tenant_id`), o **Fluxo_Audio_App** opera sob o modelo de **Inquilinato Único Físico (Single-Tenant by Design)**:

```mermaid
graph TD
    subgraph Dispositivo A (Usuário 1)
        AppA[Instância do App] -->|Isolamento Físico| StorageA[(SharedPreferences XML A)]
    end
    subgraph Dispositivo B (Usuário 2)
        AppB[Instância do App] -->|Isolamento Físico| StorageB[(SharedPreferences XML B)]
    end
```

* **Isolamento Total:** Cada instalação física do aplicativo móvel constitui uma instância de inquilino isolada de todas as outras.
* **Sem Contaminação Cruzada:** Riscos comuns de vazamentos lógicos onde um usuário A acessa as tarefas de um usuário B por erros de query SQL no backend são inteiramente eliminados, uma vez que não há compartilhamento de base de dados física.

---

## 2. Multi-inquilinato no Nível do Sistema Operacional (OS-Level)

Se mais de uma pessoa utilizar o mesmo aparelho celular físico, o multi-inquilinato é gerenciado pelas defesas e separações nativas do sistema operacional:
* **Perfis de Usuário do SO:** Sistemas como o Android oferecem suporte a múltiplos usuários ou perfis de convidado. O sistema operacional móvel cria sandboxes criptográficas completamente separadas na partição `/data/user/<user_id>/` para cada perfil de usuário. As tarefas de um perfil de usuário são inacessíveis para outros perfis no mesmo aparelho.

---

## 3. Planejamento de Workspaces Locais (Perfis de Trabalho)

Para fins de evolução futura, se o usuário final desejar separar suas anotações corporativas de suas metas pessoais no mesmo aplicativo, o sistema implementará **Workspaces Locais**:
* **Lógica de Separação:** O aplicativo permitirá criar tags de Workspace (ex: "Pessoal" e "Trabalho").
* **Isolamento de Chaves:** Internamente, o `TaskProvider` persistirá os dados sob chaves lógicas de preferências distintas (ex: `user_tasks_personal` e `user_tasks_work`), permitindo que o usuário alterne dinamicamente de espaço de trabalho na interface sem misturar os registros diários e mantendo a custódia local de ambas as partições.