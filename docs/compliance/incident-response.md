# Plano de Resposta a Incidentes (Incident Response Plan)

Este documento descreve os procedimentos operacionais a serem executados em caso de incidentes de segurança, privacidade de dados ou indisponibilidades sistêmicas críticas envolvendo o **Fluxo_Audio_App**.

---

## 1. Classificação de Incidentes de Segurança e Privacidade

Dada a natureza arquitetural do aplicativo (local-first, sem backend centralizado), os incidentes de segurança são classificados em três categorias principais:

### Categoria A: Comprometimento e Vazamento de Chaves de API (API Key Leak)
* **Descrição:** A chave de API do OpenRouter do usuário é comprometida devido a:
  * Exposição acidental em capturas de tela, capturas de logs de depuração compartilhadas pelo usuário.
  * Roubo físico do dispositivo desbloqueado ou acesso não autorizado à sandbox do sistema por aplicativos com privilégios de root/jailbreak.
* **Gravidade:** Média/Alta (dependendo do limite de faturamento da chave).

### Categoria B: Vazamento de Dados Pessoais em Logs Remotos (Crash Logging Leak)
* **Descrição:** Ferramentas automáticas de crash reporting (como Firebase Crashlytics, se adicionadas no futuro) capturam acidentalmente dados sensíveis de tarefas no rastreamento de erros de runtime (stack traces).
* **Gravidade:** Média.

### Categoria C: Corrupção Massiva de Dados Locais (Data Corruption)
* **Descrição:** Falha de compilação ou encerramento abrupto do aplicativo durante gravação corrompe a estrutura do JSON armazenado em `shared_preferences`, impedindo a inicialização do app.
* **Gravidade:** Baixa/Média (bloqueia o uso do aplicativo pelo usuário).

---

## 2. Procedimentos de Contenção e Resolução

Para cada classe de incidente identificado, os seguintes protocolos devem ser seguidos pelo usuário ou pela equipe de desenvolvimento:

### Protocolo para Categoria A (API Key Comprometida)
1. **Revogação Imediata:** O usuário ou administrador da chave deve acessar instantaneamente o painel administrativo do **OpenRouter** (`https://openrouter.ai/keys`) e deletar/revogar o token exposto. Isso impede qualquer faturamento futuro indesejado.
2. **Substituição da Chave:** O usuário gera uma nova chave de API no OpenRouter.
3. **Configuração no App:** O usuário substitui o token nas configurações do aplicativo. O sistema sobrescreverá a chave antiga com a nova credencial segura.

### Protocolo para Categoria B (Vazamento em Logs Remotos)
1. **Auditoria de Filtros:** Configurar os coletores de erros remotos para higienizar e filtrar dados de string e payloads de rede antes do envio.
2. **Purgar Histórico de Logs:** Acessar o console administrativo da ferramenta de diagnóstico de bugs (ex: Crashlytics) e purgar/deletar permanentemente os logs e relatórios afetados que trafegaram strings de tarefas.

### Protocolo para Categoria C (Corrupção de Dados Locais)
1. **Mecanismo de Descarte e Recovery:** O código de inicialização do aplicativo em [task_provider.dart](file:///G:/Programas/Fluxo_Audio_App/lib/providers/task_provider.dart) deve encapsular o carregamento do JSON em blocos `try/catch`.
2. **Preservação de Inicialização:** Se o carregamento do banco local falhar devido a JSON malformado:
   * O aplicativo deve ignorar o carregamento do bloco quebrado e inicializar com uma lista de tarefas vazia, impedindo que o app trave em tela preta (Crash Loop).
   * O aplicativo deve notificar o usuário através de um alerta informando que a base de dados local sofreu corrupção e foi restaurada para o estado inicial para permitir o uso.