# Requisitos Não Funcionais (RNFs)

| ID | Categoria | Descrição | Critério de Aceite |
|---|---|---|---|
| RNF-01 | Performance | A renderização da UI deve manter 60 FPS consistentes, mesmo com listas longas (1000+ itens). | Uso de `ListView.builder` garantido; zero jank frames no DevTools. |
| RNF-02 | Resiliência (Rede) | O app deve lidar com timeouts da API da OpenRouter graciosamente. | Fallback para inserção manual se API timeout > 5s. Circuit Breaker local ativado. |
| RNF-03 | Segurança | A chave de API da OpenRouter (`OPENROUTER_KEY`) não deve estar hardcoded no repositório. | Uso de `--dart-define` ou `.env` carregado em tempo de compilação. |
| RNF-04 | Privacidade | Dados (tarefas) nunca devem ser transmitidos para telemetria ou cloud storage sem criptografia E2E (se implementado no futuro). | Banco de dados estritamente local (`SharedPreferences`). |
| RNF-05 | Footprint | O tamanho final do APK/AAB não deve exceder 20MB. | Configurações de shrink e obfuscation ativas no R8/ProGuard. |
| RNF-06 | Offline-First | Operações CRUD locais (sem IA) devem operar em < 50ms | Medido via Profiler; leitura O(1) com cache em memória via Provider. |
