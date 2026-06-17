# Políticas de Auditoria e Logs (Audit and Compliance Logging)

Este documento estabelece as diretrizes de gravação e processamento de logs do **Fluxo_Audio_App**. Ele garante que o aplicativo capture informações operacionais necessárias para depuração técnica e conformidade de privacidade, sem violar a confidencialidade das informações do usuário.

---

## 1. Princípios de Minimização nos Logs de Auditoria

Dado que o aplicativo processa notas pessoais e de trabalho que podem conter dados altamente confidenciais, o sistema de logs opera sob o **Princípio da Não-Exposição Estrita**:
* **Proibição de Logs de Payload:** É terminantemente proibido registrar no console do dispositivo (`log`, `print` ou arquivos de log locais persistentes) o conteúdo bruto das tarefas do usuário, descrições, transcrições de voz ou dados de áudio.
* **Proibição de Logs de Credenciais:** As chaves de API do OpenRouter nunca devem ser gravadas em logs do console ou arquivos de texto de depuração.

---

## 2. Eventos Críticos Auditados Localmente

Para fins de suporte técnico e segurança física da aplicação, apenas os seguintes eventos operacionais não-sensíveis devem ser auditados e registrados localmente no console de depuração durante o tempo de execução (Runtime):

| Evento | O que é registrado | Finalidade da Auditoria |
| :--- | :--- | :--- |
| **Inicialização do App** | Timestamp, versão do App, versão do schema de banco local | Validação de migrações e auditoria de versão |
| **Status da Conectividade** | Mudança no estado de rede (online/offline) | Auditoria de comportamento do fluxo de fallback |
| **Salvamento de Configurações** | Confirmação de escrita com sucesso (sem expor o valor da API Key) | Auditoria de operações do usuário |
| **Erros de Integração HTTP** | Código HTTP do erro (ex: 401, 429, 500) e endpoint acessado | Rastreamento de falhas do gateway OpenRouter |
| **Ciclo de Vida de Voz (STT)** | Timestamps de início e parada de captura física do microfone | Auditoria de ativação física do hardware |

---

## 3. Rastreamento e Conciliação de Tokens da API

Para que o usuário final e a equipe técnica possam auditar o consumo financeiro da API do OpenRouter, o aplicativo monitora o consumo de processamento semântico:
* **Log de Metadados de Consumo:** A resposta HTTP bem-sucedida da API do OpenRouter contém metadados de uso de tokens (`usage` payload):
  * `prompt_tokens` (Tokens consumidos na entrada/pergunta).
  * `completion_tokens` (Tokens gerados na resposta).
  * `total_tokens` (Soma total).
* **Tratamento dos Metadados:** O sistema de auditoria opcionalmente registra no painel de console esses números brutos associados a cada chamada para fins de monitoramento de custos agregados, ajudando o usuário a entender seu perfil de consumo mensal de tokens sem ler as tarefas em si.