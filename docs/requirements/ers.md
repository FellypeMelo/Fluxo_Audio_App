# Especificação de Requisitos do Sistema (ERS)

## 1. Visão do Produto
Fornecer uma experiência sem atrito para captura e organização de tarefas usando voz e texto livre, delegando a carga cognitiva de estruturação para uma Inteligência Artificial generativa.

## 2. Escopo
**In-Scope:**
- Captura de texto livre e transcrição de voz.
- Envio do texto para a API OpenRouter (Llama 3.2 3B).
- Parsing do retorno (JSON) e persistência local.
- UI com suporte a swipe (Slidable) e modo escuro.
- Estatísticas de conclusão dos últimos 7 dias.

**Out-of-Scope:**
- Sincronização multi-device (Cloud Sync).
- Autenticação de usuários (Login/SSO).
- Compartilhamento de tarefas entre usuários.

## 3. KPIs e OKRs
- **KPI 1 (Latência de IA):** Retorno da estruturação de tarefas < 2.5s (p95).
- **KPI 2 (Taxa de Erro de Parsing):** < 1% das respostas da IA falharem no parser JSON.
- **KPI 3 (Crash-Free Sessions):** > 99.9%.

## 4. Matriz de Rastreabilidade Base
- **RF-01 (Captura de Voz) ->** Integrado via `speech_to_text` -> Teste Unitário: `voice_service_test.dart`
- **RF-02 (IA Parser) ->** Integrado via `OpenRouterService` -> Depende da Internet.
