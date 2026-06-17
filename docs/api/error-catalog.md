# Catálogo de Erros (Error Catalog)

Este documento cataloga todos os erros previsíveis que podem ocorrer na execução do **Fluxo_Audio_App**. Cada erro é identificado por um código alfanumérico exclusivo, descrevendo sua causa raiz, o impacto no sistema e as ações corretivas recomendadas.

---

## 1. Erros de Conexão e Rede (Rede/Internet)

### ERR-NET-001: Timeout de Requisição
* **Causa:** O dispositivo móvel não obteve resposta do gateway do OpenRouter dentro da janela limite configurada (padrão: 15 segundos).
* **Impacto:** A estruturação semântica falha.
* **Ação Corretiva do App:** Ativa o mecanismo de fallback antiperda (cria a tarefa com o texto bruto e registra a falha). Exibe um Snackbar notificando: *"Erro de conexão. A tarefa foi salva sem enriquecimento."*

### ERR-NET-002: Sem Conectividade Física
* **Causa:** O sistema operacional detecta que a interface de rede (Wi-Fi e Dados Celulares) está desativada ou desconectada.
* **Impacto:** Bloqueia a tentativa de chamada HTTP síncrona.
* **Ação Corretiva do App:** Ignora a chamada HTTP para economizar bateria e aciona imediatamente o fallback local (criação automática da tarefa com texto bruto).

---

## 2. Erros de Integração com a API do OpenRouter (HTTP / Gateway)

### ERR-API-401: Chave de API Inválida ou Expirada
* **Causa:** O cabeçalho `Authorization` trafegou um token inválido, incorreto ou deletado do painel do OpenRouter. O servidor respondeu com `HTTP 401 Unauthorized`.
* **Impacto:** A requisição é rejeitada pela IA.
* **Ação Corretiva do App:** Cria a tarefa local via fallback. Exibe um alerta de configuração de sistema sugerindo ao usuário validar a chave de API nas configurações.

### ERR-API-402: Créditos Insuficientes (Quota Excedida)
* **Causa:** A conta do OpenRouter associada à chave de API não possui saldo financeiro para pagar pelos tokens gerados na chamada. O servidor responde com `HTTP 402 Payment Required`.
* **Impacto:** A requisição é rejeitada pela IA.
* **Ação Corretiva do App:** Cria a tarefa local via fallback. Exibe uma mensagem na tela principal: *"Créditos insuficientes no OpenRouter. Por favor, recarregue sua conta."*

### ERR-API-429: Limite de Requisições Excedido (Rate Limit)
* **Causa:** O usuário enviou muitas requisições em uma janela de tempo muito curta. O servidor responde com `HTTP 429 Too Many Requests`.
* **Impacto:** A requisição é rejeitada temporariamente.
* **Ação Corretiva do App:** Cria a tarefa local via fallback. Para integrações automatizadas futuras, recomenda-se a lógica de retentativa com recuo exponencial (*Exponential Backoff*).

### ERR-API-500: Falha Interna do Gateway ou Modelo Indisponível
* **Causa:** O servidor da OpenRouter ou os servidores provedores do modelo (como Meta) sofreram uma pane interna. O servidor responde com `HTTP 500 Internal Server Error` ou `503 Service Unavailable`.
* **Impacto:** A requisição falha no lado do servidor.
* **Ação Corretiva do App:** Cria a tarefa local via fallback. Registra o erro no console de desenvolvimento.

---

## 3. Erros de Lógica e Hardware Local (Sistema)

### ERR-SYS-001: Falha de Parsing de JSON
* **Causa:** O modelo de IA respondeu com sucesso (HTTP 200), mas a string retornada não é um JSON válido ou não segue a estrutura esperada pelo contrato (campos ausentes ou tipos incompatíveis).
* **Impacto:** O parser Dart falha ao serializar a resposta na entidade `Task`.
* **Ação Corretiva do App:** Ativa o fallback antiperda criando a tarefa com o texto bruto para que os dados inseridos pelo usuário permaneçam salvos.

### ERR-SYS-002: Permissão de Microfone Negada
* **Causa:** O usuário rejeitou o diálogo de consentimento de acesso ao hardware de áudio do sistema operacional.
* **Impacto:** O botão de gravação fica inativo e o Speech-to-Text nativo falha ao iniciar.
* **Ação Corretiva do App:** Desativa o botão de microfone ou exibe um diálogo explicativo instruindo o usuário a habilitar a permissão nas configurações do sistema móvel.