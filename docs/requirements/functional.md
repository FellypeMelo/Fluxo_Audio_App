# Requisitos Funcionais (Functional Requirements)

Este documento descreve as funcionalidades que o **Fluxo_Audio_App** deve fornecer aos usuários finais. Cada requisito é codificado unicamente para permitir o rastreamento em fases de desenvolvimento, teste e validação de qualidade.

---

## 1. Configurações e Preferências do Usuário

### RF-01: Gestão de Chave de API do OpenRouter
* **Descrição:** O sistema deve fornecer uma interface para que o usuário insira, salve e edite sua chave de API pessoal do OpenRouter.
* **Critérios de Aceite:**
  * O campo de entrada de texto deve ocultar os caracteres digitados por padrão (estilo password).
  * O sistema deve persistir a chave localmente no armazenamento seguro.
  * O sistema deve realizar uma validação sintática básica da chave de API antes do salvamento.

### RF-02: Alternância de Tema Visual (Claro/Escuro)
* **Descrição:** O sistema deve permitir que o usuário alterne manualmente entre o tema claro e o tema escuro nas configurações do aplicativo.
* **Critérios de Aceite:**
  * A troca de tema deve ser refletida instantaneamente na interface sem necessidade de reiniciar o aplicativo.
  * A escolha do tema deve ser guardada localmente para persistência em sessões futuras.

---

## 2. Captura de Entrada e Transcrição

### RF-03: Gravação de Voz via Microfone
* **Descrição:** O sistema deve permitir que o usuário inicie e termine a gravação de áudio por voz através de um botão flutuante proeminente de microfone na tela principal.
* **Critérios de Aceite:**
  * O sistema deve solicitar permissão de uso do microfone na primeira ativação.
  * O botão deve fornecer feedback visual dinâmico (animação de ondas ou pulsação) enquanto a gravação estiver ativa.

### RF-04: Transcrição de Áudio (Speech-to-Text)
* **Descrição:** O sistema deve transcrever o áudio capturado no microfone para texto puro em tempo real, exibindo uma caixa de pré-visualização contendo a transcrição incremental de palavras à medida que são identificadas.
* **Critérios de Aceite:**
  * A transcrição deve suportar especificamente o idioma Português do Brasil (`pt_BR`).
  * O usuário deve ver o resultado final transcrito em uma caixa de chat antes de prosseguir com o processamento pela IA.

### RF-05: Entrada Manual de Texto Livre
* **Descrição:** O sistema deve fornecer um campo de digitação livre de texto (input de texto convencional de chat) para que o usuário possa digitar instruções de tarefas sem a necessidade de usar o microfone.
* **Critérios de Aceite:**
  * O botão de envio deve ficar visível apenas quando o campo de texto contiver caracteres válidos (não vazios).

---

## 3. Processamento Semântico e IA

### RF-06: Extração de Tarefas com Llama 3.2 3B
* **Descrição:** Ao enviar a transcrição ou texto digitado, o sistema deve despachar uma requisição HTTP para a API do OpenRouter solicitando a interpretação semântica do texto livre para transformá-lo em uma ou mais tarefas formatadas.
* **Critérios de Aceite:**
  * O aplicativo deve instruir o LLM a retornar uma carga útil estritamente em formato JSON estruturado contendo: `titulo`, `descricao`, `prazo` (data e hora calculados) e `prioridade`.
  * O prompt enviado deve conter a data e hora do dispositivo móvel do usuário para resolver prazos relativos.

### RF-07: Resiliência de Fallback de Tarefas
* **Descrição:** Se a chamada à API do OpenRouter ou o parsing do JSON de resposta falhar por qualquer motivo (erros HTTP, timeout, falta de internet, JSON quebrado), o sistema deve criar automaticamente uma única tarefa contendo o texto de entrada original.
* **Critérios de Aceite:**
  * A tarefa criada por fallback terá o texto bruto como título, prioridade Média, sem prazo, e com uma nota descritiva interna registrando o erro.
  * O usuário deve receber um feedback visual (Snackbar ou Toast) discreto notificando que a tarefa foi criada localmente sem estruturação por falha de conectividade.

---

## 4. Gerenciamento e Manipulação de Tarefas

### RF-08: Listagem Dinâmica de Tarefas
* **Descrição:** O sistema deve exibir as tarefas cadastradas em uma lista organizada na tela principal, priorizando a ordem cronológica reversa de inserção (as mais novas aparecem primeiro).
* **Critérios de Aceite:**
  * A interface deve categorizar ou sinalizar visualmente as tarefas com base em suas prioridades (vermelho para Alta, amarelo para Média, azul/cinza para Baixa).
  * A data de vencimento (prazo) deve ser exibida em formato amigável ao usuário (ex: "Amanhã às 14:00" ou "20 de Junho").

### RF-09: Conclusão de Tarefas
* **Descrição:** O sistema deve permitir ao usuário marcar e desmarcar tarefas como concluídas.
* **Critérios de Aceite:**
  * Ao concluir uma tarefa, ela deve receber um efeito visual de riscado (strikethrough) no título e diminuição da opacidade.
  * O estado atual da tarefa deve persistir localmente de imediato.

### RF-10: Ações Rápidas por Swipe (Deslizamento)
* **Descrição:** O usuário deve ser capaz de realizar ações rápidas nas tarefas da lista através de gestos de deslizamento lateral (swipe).
* **Critérios de Aceite:**
  * O deslizar para a direita deve permitir marcar a tarefa como concluída rapidamente.
  * O deslizar para a esquerda deve abrir a opção de exclusão imediata da tarefa da base local.

### RF-11: Edição Manual Fina de Tarefa
* **Descrição:** O sistema deve permitir que o usuário toque em uma tarefa para abrir um modal ou tela de edição detalhada, onde ele poderá alterar manualmente o título, descrição, prioridade e prazo de vencimento.
* **Critérios de Aceite:**
  * O sistema deve salvar as alterações localmente após o usuário confirmar no botão "Salvar".

---

## 5. Visualizações e Estatísticas

### RF-12: Painel de Estatísticas de Produtividade
* **Descrição:** O sistema deve exibir na UI uma seção dedicada com gráficos ou indicadores sobre a produtividade do usuário com base nas tarefas dos últimos 7 dias.
* **Critérios de Aceite:**
  * Deve exibir a contagem total de tarefas concluídas versus criadas dentro da janela móvel de 7 dias passados.
  * Deve calcular e exibir a porcentagem de conclusão de metas semanais.