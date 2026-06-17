# Análise de Riscos (Project Risk Analysis)

Este documento especifica a matriz de riscos associada ao desenvolvimento, implantação e ciclo operacional do **Fluxo_Audio_App**. Ele classifica cada ameaça por nível de impacto e probabilidade, definindo os respectivos planos de mitigação preventiva e contingências.

---

## Matriz de Riscos Operacionais

A tabela abaixo prioriza os riscos com base no produto cartesiano da probabilidade de ocorrência versus o impacto gerado na aplicação.

```text
Impacto Alto    [ Risco 1: API Down ]      [ Risco 3: Rejeição Lojas ]
Impacto Médio   [ Risco 2: Falha STT ]     [ Risco 4: Key Leak ]
                Probabilidade Baixa        Probabilidade Alta
```

| ID Risco | Categoria | Descrição da Ameaça | Probabilidade | Impacto | Ação de Mitigação Preventiva |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **R-01** | Técnico | Indisponibilidade de rede ou falha de serviço no provedor da API OpenRouter. | Média | Alto | **Implementação de Fallback (RN-02):** Se a API falhar, o aplicativo cria localmente a tarefa com o texto bruto inserido, garantindo integridade e antiperda dos dados do usuário. |
| **R-02** | Usabilidade | Baixa precisão no reconhecimento de voz (STT) nativo em ambientes com barulho de fundo ou sotaques regionais. | Alta | Médio | **Edição Manual e Digitação:** Oferecer caixa de edição incremental contendo a transcrição antes do envio à IA e manter o campo de chat por teclado ativo como alternativa. |
| **R-03** | Distribuição | Rejeição do aplicativo nas lojas de aplicativos (especialmente Apple App Store) por falta de política de privacidade ou termos de uso. | Média | Alto | **Documentação de Privacidade:** Disponibilizar página web com os termos detalhando a arquitetura local-first (sem coleta centralizada de dados) e o canal HTTPS com o OpenRouter. |
| **R-04** | Segurança | Vazamento ou comprometimento financeiro da chave de API do OpenRouter inserida pelo usuário final. | Média | Médio | **Sandbox e Zero Logs:** Isolar o segredo no armazenamento privado nativo e proibir de forma absoluta a exibição de tokens sensíveis no console do Flutter. |

---

## Planos de Contingência Detalhados

### Contingência para R-01 (API OpenRouter Indisponível)
Caso ocorra uma pane global na OpenRouter:
1. O aplicativo exibe uma notificação visual amigável informando o erro temporário de rede.
2. O sistema ativa silenciosamente a criação de tarefas sem o processamento inteligente, salvando o texto original imediatamente na lista local.
3. Assim que a rede se restabelecer, o aplicativo retorna a processar novas tarefas pela IA sem que seja necessário reiniciar o app.

### Contingência para R-03 (Bloqueio ou Rejeição nas Lojas)
Se a Apple ou o Google rejeitarem a publicação por alegações de coleta indevida de dados de áudio do microfone:
1. Apresentar os arquivos de compliance `privacy-by-design.md`, `retention-policy.md` e `pii-classification.md` aos revisores das lojas como prova documental de que o aplicativo não armazena ou coleta áudios brutos em discos locais ou servidores proprietários.
2. Fornecer fluxos de gravação de tela demonstrando o descarte imediato dos buffers de som após a conversão em string na RAM.