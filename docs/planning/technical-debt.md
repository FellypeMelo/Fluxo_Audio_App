# Catálogo de Débitos Técnicos (Technical Debt Backlog)

Este documento cataloga os débitos técnicos e atalhos arquiteturais identificados durante o ciclo de desenvolvimento do **Fluxo_Audio_App**. A documentação de débitos técnicos é essencial para planejar refatorações contínuas nas sprints futuras, impedindo a degradação da base de código (*code rot*).

---

## Registro de Débitos Técnicos Priorizados

Os débitos são classificados por gravidade de impacto na manutenibilidade e segurança, contendo prazos sugeridos de resolução.

| ID Débito | Descrição do Débito | Impacto / Risco | Esforço de Resolução | Resolução Planejada / Ação Corretiva |
| :--- | :--- | :--- | :--- | :--- |
| **TD-01** | **Chave de API em Texto Claro:** A chave do OpenRouter é armazenada como String direta no SharedPreferences. | **Médio** (Risco de leitura em dispositivos rooteados/jailbroken). | Baixo (1 dia) | Migrar a leitura e escrita da chave para o pacote `flutter_secure_storage` que utiliza criptografia por Keychain/Keystore do SO. |
| **TD-02** | **Ausência de Internacionalização (i18n):** Textos da UI e mensagens estão declarados de forma estática (*hardcoded*) nos widgets. | **Baixo** (Dificulta expansão internacional futura). | Médio (2-3 dias) | Adicionar o pacote `flutter_localizations` e migrar todos os textos para arquivos arb de dicionário traduzíveis. |
| **TD-03** | **Leitura Total da Lista de Tarefas:** Todas as tarefas salvas no SharedPreferences são carregadas para a RAM no boot do app. | **Baixo/Médio** (Pode degradar performance após milhares de tarefas). | Médio (3 dias) | Implementar a estratégia de particionamento lógicos (arquivar tarefas concluídas com mais de 30 dias para outra partição de storage). |
| **TD-04** | **Testes de Stress de Rede Ausentes:** A resiliência sob redes muito lentas (2G/3G) baseia-se apenas no timer estático do HttpClient. | **Baixo** (Possibilidade de comportamentos instáveis em trânsito). | Baixo (1 dia) | Implementar testes automatizados com simulação de latência de rede dinâmica no mock HTTP do OpenRouter. |

---

## Estratégia de Pagamento de Débitos Técnicos

Para garantir que a base de código permaneça saudável sem paralisar a esteira de novas funcionalidades de produto, a equipe de engenharia adota as seguintes políticas:
* **Taxa de Sprint Fixa:** Reservar **10% a 15% da capacidade de esforço (Story Points)** de cada sprint para resolução de débitos técnicos catalogados.
* **Refatoração no Caminho (Boy Scout Rule):** Ao modificar uma classe para adicionar uma feature, o desenvolvedor deve obrigatoriamente corrigir pequenos débitos técnicos adjacentes contidos naquela mesma classe (ex: adicionar trailing commas faltantes, construtores const ou documentar métodos stubs com Dartdoc).
* **Revisão de Débitos:** A cada marco de versão principal (Milestones), o catálogo de débitos técnicos deve ser revisado em retrospectiva de equipe para re-classificar a severidade das pendências.