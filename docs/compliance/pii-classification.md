# Classificação de Informações Pessoais Identificáveis (PII Classification)

Este documento classifica todos os tipos de dados tratados no ciclo de execução do **Fluxo_Audio_App** de acordo com sua sensibilidade e estabelece as regras de manuseio e proteção física obrigatórias para cada classe de informação.

---

## 1. Tabela de Classificação de Dados

| Categoria de Dado | Descrição | Classificação de Sensibilidade | Armazenamento | Transmissão de Rede | Diretriz de Proteção |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Áudio do Microfone** | Gravação de voz capturada durante a interação do usuário. | **Sensível / Crítico** | Temporário em memória RAM (descartado imediatamente) | **Não transmitido** (o arquivo de áudio nunca é enviado) | Limpeza imediata da RAM pós-transcrição. |
| **Texto Transcrito** | O texto resultante da transcrição de voz ou digitado manualmente. | **Confidencial** | Persistido localmente no SharedPreferences | Enviado em trânsito via HTTPS para OpenRouter | Criptografia em trânsito obrigatória via TLS. Proibido em logs de console. |
| **Chave de API** | Bearer Token para faturamento e autorização com OpenRouter. | **Restrito / Segredo** | Persistido localmente no SharedPreferences | Trafegado no Header HTTP `Authorization` | Armazenamento em sandbox privada. Proibido em logs de console. |
| **Dados Operacionais** | Status das tarefas (concluído/pendente), prioridade e prazos. | **Confidencial** | Persistido localmente no SharedPreferences | **Não transmitido** diretamente (trafegado no JSON de resposta) | Protegido pelas regras de sandbox do SO. |
| **Estatísticas de Uso** | Agregações de tarefas dos últimos 7 dias. | **Interno / Operacional** | Calculado em tempo de execução na RAM | **Não transmitido** | Sem riscos diretos à privacidade individual. |

---

## 2. Definições de Níveis de Sensibilidade

* **Sensível / Crítico:** Dados cuja divulgação não autorizada ou vazamento causam danos graves à privacidade e integridade civil do usuário (ex: biometria, voz gravada). Devem ser eliminados o mais rápido possível e nunca persistidos sem criptografia profunda.
* **Confidencial:** Dados específicos de propriedade do usuário final (anotações diárias, metas de trabalho, tarefas pessoais). Vazamentos causam exposição de rotinas privadas. A proteção baseia-se no isolamento lógico no dispositivo móvel.
* **Restrito / Segredo:** Credenciais técnicas e tokens de autorização. O vazamento acarreta perdas financeiras (consumo de créditos de API). O armazenamento deve ser isolado do escopo de leitura de outros aplicativos.
* **Interno / Operacional:** Dados analíticos e de fluxo técnico. O vazamento não expõe diretamente a identidade ou privacidade do usuário.

---

## 3. Diretrizes de Proteção Baseadas na Sensibilidade

1. **Proteção Física de Chaves de API (Segredos):** Chaves salvas no dispositivo não devem estar acessíveis a backups em nuvem não criptografados do sistema operacional. O desenvolvedor deve desencorajar a gravação destas chaves em locais de compartilhamento público (como pastas públicas do SD Card no Android).
2. **Proteção em Trânsito (HTTPS):** Toda transmissão de dados com a OpenRouter deve usar criptografia forte TLS 1.2 ou superior.
3. **Higienização de Logs:** Funções de tratamento de erros devem capturar apenas metadados técnicos (ex: `TimeoutException`, `FormatError`) e nunca concatenar a mensagem de erro com a transcrição do áudio do usuário ou chaves de API.