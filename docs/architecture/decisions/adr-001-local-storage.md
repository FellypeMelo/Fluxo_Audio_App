# ADR 001: Estratégia de Banco de Dados Local

**Status:** Aprovado  
**Data:** 2026-06-17  

## Contexto
O aplicativo precisa armazenar tarefas e estados localmente. Temos opções como SQLite, Isar, Hive e SharedPreferences. O volume atual projetado por usuário é pequeno (< 500 tarefas ativas).

## Decisão
Utilizaremos **SharedPreferences** para a versão inicial do sistema (v1).

## Consequências e Trade-offs
- **Prós:** Zero configuração nativa extra, altíssima velocidade de leitura/escrita para volumes pequenos, serialização/deserialização simples via JSON.
- **Contras:** Não suporta queries complexas ou paginação eficiente (tudo é carregado na RAM). 
- **Mitigação:** Como a arquitetura implementa o padrão Repository, caso o volume de dados cresça, poderemos substituir a implementação por `Isar` ou `SQLite` sem impacto na camada de Domínio ou UI.
