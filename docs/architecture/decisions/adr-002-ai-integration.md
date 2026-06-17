# ADR 002: Integração LLM via OpenRouter (Llama 3.2 3B)

**Status:** Aprovado  
**Data:** 2026-06-17  

## Contexto
Necessitamos converter linguagem natural caótica em uma lista de tarefas (`List<Task>`). A execução de LLMs on-device ainda sofre com limitações de bateria, memória e temperatura térmica nos aparelhos, apesar do Flutter permitir inferência via TFLite, Modelos LLM pesam muito no tamanho do bundle.

## Decisão
Delegar o processamento NLP para a cloud via **OpenRouter**, usando o modelo **Llama 3.2 3B** formatado em modo JSON.

## Segurança e Privacidade
- O prompt é sanitizado antes do envio.
- A requisição é *stateless*; a OpenRouter não deve usar os dados para treinamento (opt-out compliance).
- **Fallback:** Em caso de falha de rede ou timeout, a string crua enviada pelo usuário será cadastrada como uma única tarefa padrão, garantindo que nenhum dado se perca.
