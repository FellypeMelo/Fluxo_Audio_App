# Threat Modeling (STRIDE)

| Ameaça (STRIDE) | Descrição no Contexto do Fluxo | Mitigação Arquitetural |
|---|---|---|
| **S**poofing | Um app malicioso tentar forjar requisições usando a API Key. | Obfuscação da API Key (`--dart-define`). Restrição de domínio/IP na OpenRouter (se suportado). |
| **T**ampering | Modificação local do arquivo `SharedPreferences.xml` em dispositivos com root. | Tratado como aceitável para v1 (risco do usuário). Mitigação futura: Flutter Secure Storage (Keystore/Keychain). |
| **R**epudiation | Usuário nega ter criado uma tarefa que a IA gerou. | Logs de execução em memória. A UI sempre permite edição manual pós-IA. |
| **I**nformation Disclosure | Exposição de PII nas tarefas enviadas à IA. | Política de Privacidade clara no onboarding informando que textos são processados em nuvem. Não usar PII para fins de IA. |
| **D**enial of Service | Abuso do botão de IA gerando custos (DDoS na chave). | Rate limiting implementado no `Provider` (ex: max 5 requests por minuto via Debounce). |
| **E**levation of Privilege | N/A (App Serverless e Local) | N/A. |

## Conformidade LGPD/GDPR
- O aplicativo age primariamente como um processador local.
- Consentimento explícito necessário no onboarding para o uso do microfone e envio de textos transcritos aos servidores da API.
- Todo o dado de tarefa é efêmero no trânsito, sem retenção cloud.
