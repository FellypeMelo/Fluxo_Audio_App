# Governança de Dados (Data Governance and Residence Policy)

Este documento especifica a política de governança de dados do **Fluxo_Audio_App**. Ele estabelece as regras de custódia, processamento, residência e controle de acesso para garantir a conformidade legal e a integridade de todas as informações manipuladas pelo aplicativo.

---

## 1. Residência e Localização Física dos Dados

A arquitetura *local-first* descentralizada dita a residência física das informações:

* **Dados em Repouso (Tarefas e Configurações):**
  * Residência: Armazenamento físico interno do dispositivo móvel do usuário final.
  * Caminho Lógico: `/data/data/<package_name>/shared_prefs/` no Android e diretórios protegidos do Keychain/NSUserDefaults no iOS.
  * Segurança: Protegido por criptografia baseada no hardware de segurança do sistema operacional (se habilitado o bloqueio de tela do dispositivo).
* **Dados em Trânsito (Processamento Semântico):**
  * Residência: Os dados trafegam temporariamente pela internet sob proteção HTTPS TLS 1.2 ou superior direcionados aos servidores do gateway **OpenRouter**.
  * Retenção: Conforme políticas da OpenRouter, dados enviados via chamadas de API pagas são processados em trânsito e não são armazenados de forma persistente ou utilizados para o treinamento de modelos de linguagem de terceiros.

---

## 2. Fluxo do Ciclo de Vida do Dado (Data Life Cycle)

O ciclo de vida de uma anotação de voz obedece ao fluxo estrito ilustrado abaixo:

```text
 [ Coleta ] ──────────► [ Transcrição ] ───────► [ Processamento ]
 Microfone              Memória RAM (Dart)       HTTPS OpenRouter (TLS)
                                                        │
 [ Descarte ] ◄──────── [ Persistência ] ◄──────────────┘
 Swipe / Reset          SharedPreferences
```

1. **Coleta:** O áudio é capturado temporariamente na memória RAM.
2. **Transcrição:** O motor Speech-to-Text nativo do SO traduz o sinal de áudio em string de texto na RAM. O buffer de áudio original é destruído fisicamente logo em seguida.
3. **Processamento:** O texto transcrito é enviado para a API do OpenRouter e os servidores de processamento da IA para estruturação semântica.
4. **Persistência:** O JSON de resposta da IA é mapeado e salvo no armazenamento local persistente.
5. **Descarte:** A exclusão pelo usuário aciona a sobrescrita física da chave correspondente, apagando a informação definitivamente.

---

## 3. Soberania e Propriedade de Dados

* **Soberania do Usuário:** O usuário final possui propriedade exclusiva e inalienável sobre suas tarefas e anotações. Não existem painéis corporativos de moderação, administradores de banco de dados ou auditorias centrais capazes de visualizar ou exportar os registros dos usuários.
* **Sem Sincronização Não-Consensual:** O aplicativo não realiza uploads automáticos de tarefas em background para servidores de terceiros ou serviços de nuvem pública que não sejam expressamente contratados e configurados pelo usuário.
* **Exclusão Simplificada:** O processo de exclusão de dados é projetado para ser intuitivo e direto, garantindo o direito à exclusão definitiva sem exigência de suporte técnico.