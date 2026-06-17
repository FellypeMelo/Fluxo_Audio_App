# Regras de Negócio (Business Rules)

Este documento define as regras de negócio operacionais que governam o comportamento do **Fluxo_Audio_App**. Elas representam políticas organizacionais e lógicas de integridade que devem ser seguidas de forma estrita pelo código-fonte.

---

## RN-01: Estados e Ciclo de Vida de uma Tarefa

* **Descrição:** Toda tarefa criada no sistema deve obedecer a uma máquina de estados simples, contendo apenas dois estados possíveis:
  * `Pendente` (State: active/incomplete)
  * `Concluída` (State: completed)
* **Comportamento de Transição:**
  * Toda tarefa recém-criada é inicializada no estado `Pendente` por padrão.
  * O usuário pode alterar o estado de `Pendente` para `Concluída` e vice-versa a qualquer momento.
  * A data/hora da última alteração de estado deve ser registrada se necessário para relatórios de estatísticas (últimos 7 dias).

## RN-02: Garantia de Entrada e Fallback Antiperda

* **Descrição:** O sistema nunca deve descartar uma entrada de texto livre digitada ou falada pelo usuário, mesmo se houver falha de rede ou erro no processador de Inteligência Artificial (OpenRouter).
* **Comportamento de Fallback:**
  * Se a chamada à API do OpenRouter falhar (timeout, erro HTTP 5xx, chave inválida, etc.) ou se o JSON retornado pela IA for corrompido/ilegível:
    1. O aplicativo criará automaticamente uma tarefa única.
    2. O **Título** da tarefa será o texto bruto exato digitado ou transcrito.
    3. A **Prioridade** será definida como `Média` (Medium).
    4. O **Prazo** será nulo.
    5. A **Descrição** conterá a mensagem de log: `"[Nota: Criada via fallback devido a erro de conexão com a IA]"`.

## RN-03: Resolução de Prazos Relativos (Contexto Temporal)

* **Descrição:** A Inteligência Artificial deve ser capaz de interpretar prazos descritos de forma relativa pelo usuário (ex: *"fazer isso amanhã às 14h"*, *"comprar pão sexta-feira"*).
* **Comportamento do Sistema:**
  * Toda chamada enviada à API do OpenRouter deve incluir, no prompt do sistema ou metadados de contexto, a **data e hora atual do dispositivo** formatada (`DateTime.now()`).
  * O modelo de IA deve usar essa data de referência como ponto de partida (`T`) para calcular os prazos reais e preencher o campo `deadline` no formato ISO 8601 (`YYYY-MM-DDTHH:MM:SSZ`).

## RN-04: Classificação de Prioridades e Escala Estrita

* **Descrição:** Cada tarefa estruturada deve possuir exatamente uma classificação de prioridade, pertencente a uma escala fechada de três níveis:
  * `Alta` (High): Para urgências ou prazos imediatos.
  * `Média` (Medium): Padrão para tarefas sem indicativos explícitos de urgência.
  * `Baixa` (Low): Para tarefas sem pressa ou ideias/lembretes futuros.
* **Comportamento da IA:** A IA deve ser instruída a classificar a tarefa com base na urgência expressa no texto falado. Se não houver palavras de urgência (ex: *"urgente"*, *"rápido"*, *"hoje"*), a prioridade padrão de classificação é `Média`.

## RN-05: Local-First e Privacidade dos Dados de Voz

* **Descrição:** O aplicativo funciona sob a diretriz de privacidade estrita de dados locais e descarte imediato de arquivos de áudio temporários.
* **Políticas:**
  * **Armazenamento de Áudio:** O áudio capturado pelo microfone para Speech-to-Text é processado em tempo de execução na memória ou em arquivos temporários que devem ser limpos imediatamente após a transcrição do texto terminar. O áudio do usuário **nunca** é persistido no banco de dados local ou enviado para servidores de terceiros (o arquivo é descartado, apenas o texto resultante da transcrição é transmitido).
  * **Armazenamento de Dados:** As tarefas geradas permanecem armazenadas localmente no dispositivo. Não há backend remoto proprietário para sincronização externa de dados de tarefas.

## RN-06: Gerenciamento Seguro e Custódia da API Key

* **Descrição:** A chave de API do OpenRouter é de uso pessoal e responsabilidade do usuário, devendo ser protegida contra exposição indevida.
* **Regras de Custódia:**
  * O aplicativo deve aceitar a chave de API fornecida pelo usuário por meio de um campo de configuração na UI.
  * A chave deve ser guardada localmente utilizando armazenamento persistente.
  * A chave nunca deve ser exposta em logs de depuração do console do aplicativo.
  * Deve haver uma validação de formato mínimo (ex: verificar se começa com `"sk-or-"` e possui comprimento de caracteres adequado) no cliente antes de permitir a gravação das configurações.