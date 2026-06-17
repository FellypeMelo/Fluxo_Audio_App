# Análise de Custos de IA (API Cost and Token Analysis)

Este documento apresenta a análise de custos operacionais e a projeção financeira do consumo de Inteligência Artificial no **Fluxo_Audio_App**. Em conformidade com a arquitetura cliente-servidor descentralizada, o faturamento baseia-se na contagem de tokens de entrada e saída consumidos na API externa do **OpenRouter**.

---

## 1. Modelo de Precificação por Tokens (OpenRouter API)

O OpenRouter utiliza um modelo de cobrança escalável por volume de tokens processados (*Pay-as-you-go*). Para o modelo principal selecionado, **Meta Llama 3.2 3B Instruct** (ou similar leve), as taxas médias estimadas são de:
* **Custo de Entrada (Input Tokens):** ~\$0.03 por 1.000.000 (1 Milhão) de tokens.
* **Custo de Saída (Output Tokens):** ~\$0.06 por 1.000.000 (1 Milhão) de tokens.

---

## 2. Projeção de Consumo por Perfil de Usuário

Abaixo é calculada a projeção financeira para um usuário ativo típico com base em estimativas de uso diário.

### Cenário de Referência (Usuário Padrão):
* **Frequência de Uso:** **10 tarefas criadas por dia** (por voz ou digitação).
* **Tamanho do Payload de Entrada (Input):**
  * System Prompt + Data de Contexto + Instrução de Voz Transcrita = ~**600 tokens** por chamada.
* **Tamanho do Payload de Saída (Output):**
  * Resposta JSON estruturada (título, descrição, prazo, prioridade) = ~**150 tokens** por chamada.

### Cálculo Financeiro por Chamada (Requisição Única):

$$\text{Custo}_{\text{input}} = 600 \text{ tokens} \times \frac{\$0.03}{1.000.000} = \$0.000018$$

$$\text{Custo}_{\text{output}} = 150 \text{ tokens} \times \frac{\$0.06}{1.000.000} = \$0.000009$$

$$\text{Custo}_{\text{total}} = \$0.000018 + \$0.000009 = \$0.000027 \text{ por chamada}$$

### Projeção Acumulada:
* **Custo Diário (10 chamadas):** $10 \times \$0.000027 = \$0.00027$.
* **Custo Mensal (30 dias):** $30 \times \$0.00027 = \mathbf{\$0.0081}$ (menos de 1 centavo de dólar por usuário por mês!).
* **Custo Anual (365 dias):** $365 \times \$0.00027 = \mathbf{\$0.0985}$ (menos de 10 centavos de dólar por usuário por ano!).

---

## 3. Técnicas de Otimização Financeira de Tokens

Para garantir que os custos permaneçam insignificantes e evitar desperdício de créditos, a engenharia de software adota as seguintes táticas:

* **Compactação de System Prompt:** O prompt do sistema no `OpenRouterService` é projetado de forma concisa e eficiente, reduzindo redundâncias textuais para economizar tokens de entrada em cada requisição.
* **Limitação de Entrada Física:** O aplicativo limita a gravação de áudio do microfone a um tempo máximo de 30 segundos por inserção, impedindo o envio de transcrições excessivamente longas que drenem créditos.
* **Validação Sintática no Cliente:** Botões de envio de chat sofrem bloqueios e debounces para impedir cliques duplicados acidentais que disparariam chamadas HTTP idênticas em paralelo.
* **Fallback Local para Mensagens Repetidas:** Se o usuário submeter uma entrada vazia ou repetida, o aplicativo a ignora ou processa localmente sem requisitar a nuvem da IA.