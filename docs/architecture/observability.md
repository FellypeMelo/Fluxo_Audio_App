# Observabilidade e Diagnósticos (Observability and Diagnostics Architecture)

Este documento especifica a arquitetura de observabilidade, captura de logs de diagnóstico e tratamento de erros do **Fluxo_Audio_App**. Em conformidade com o design local-first, a observabilidade foca no fornecimento de ferramentas de diagnóstico eficientes no lado do cliente para apoiar o desenvolvimento e suporte técnico sem comprometer a privacidade dos dados.

---

## 1. Níveis e Estruturação de Logs Locais (Diagnostic Logging)

Para permitir a depuração eficiente durante as fases de desenvolvimento e homologação móvel, o aplicativo adota um modelo de **Logs Estruturados por Contexto**:

```text
[Timestamp] [SEVERIDADE] [CONTEXTO] Mensagem técnica de depuração
```

### Contextos de Diagnóstico Mapeados:
* **`[VOICE]`:** Eventos do ciclo de vida de Speech-to-Text nativo (inicialização, início de escuta física do microfone, parada de captação).
* **`[NETWORK]`:** Status de requisições enviadas à API do OpenRouter (URL, cabeçalhos de autenticação não-secretos, latência em ms, códigos HTTP de retorno).
* **`[STORAGE]`:** Leitura e escrita no SharedPreferences (versão do esquema carregada, status de persistência das tarefas).
* **`[SECURITY]`:** Operações de leitura/escrita da chave de API e validações básicas.

### Níveis de Severidade Utilizados:
1. **`INFO` (Informação):** Eventos operacionais normais do fluxo.
2. **`WARNING` (Aviso):** Comportamentos inesperados não fatais que podem afetar o usuário (ex: timeout de rede ativando o fallback local).
3. **`ERROR` (Erro):** Falhas críticas de execução que bloqueiam a operação de um módulo (ex: permissão de microfone negada, falha de conversão JSON da IA).

---

## 2. Instrumentação e Métricas Locais de Latência

Para fins de otimização de performance, o aplicativo instrumenta operações críticas utilizando contadores de tempo (*Stopwatches*):
* **Rastreamento de I/O Local:** Mede o tempo gasto para carregar e desserializar a lista inteira de tarefas do SharedPreferences na RAM. logs são emitidos se a leitura demorar mais que 100ms.
* **Rastreamento de Conexão com IA:** Mede a duração da requisição HTTP do OpenRouter:
  ```dart
  final stopwatch = Stopwatch()..start();
  final response = await httpClient.post(...);
  stopwatch.stop();
  log('Latência da IA: ${stopwatch.elapsedMilliseconds}ms', name: 'NETWORK');
  ```

---

## 3. Higienização de Erros e Stack Traces

Para garantir que stack traces capturados localmente não trafeguem informações confidenciais do usuário (como o título de tarefas pessoais contendo dados confidenciais):
* **Filtros de Erro:** O aplicativo intercepta exceções sanitizando strings de erro antes do log. As mensagens de erro expostas são genéricas, e detalhes do input do usuário são descartados da mensagem de exceção.
* **Logs Silenciados em Produção:** Logs verbose (como mensagens de depuração `INFO`) são desativados em compilações em modo release, restando ativos no console do desenvolvedor apenas erros fatais (`ERROR`) não-sensíveis.