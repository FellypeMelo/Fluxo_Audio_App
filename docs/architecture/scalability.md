# Escalabilidade de Sistemas (Local Architecture Scalability)

Este documento especifica a estratégia de escalabilidade técnica do **Fluxo_Audio_App**. Em conformidade com a filosofia *local-first*, o design arquitetural foca em garantir que o aplicativo continue rápido e estável à medida que o volume de tarefas acumuladas do usuário cresce e o número total de usuários ativos do app escala.

---

## 1. Escalabilidade de Base de Usuários (Custo Zero para o Mantenedor)

Como o aplicativo adota um modelo descentralizado de execução baseada no cliente (Backend-less):
* **Crescimento Linear Sem Gargalos:** O surgimento de milhares ou milhões de novos usuários ativos não gera demandas de escala ou custos complementares de processamento de servidores para o proprietário do aplicativo.
* **Escala Pessoal:** Cada usuário final gerencia seu próprio faturamento com a API do OpenRouter e utiliza o hardware de seu próprio celular para processar as tarefas, distribuindo a carga de processamento na borda da rede de forma perfeita.

---

## 2. Escalabilidade de Desempenho de UI (ListView Lazy Loading)

Renderizar listas longas contendo centenas ou milhares de itens pode gerar lentidões severas na interface gráfica do celular se a renderização for feita de forma estática:
* **Uso de `ListView.builder`:** O aplicativo gerencia a lista ativa utilizando o construtor dinâmico `ListView.builder` do Flutter.
* **Mecânica Lazy Loading:** Este componente aloca e desenha na tela apenas os cards de tarefas que estão visíveis na área útil do visor do celular naquele instante, desalocando cards que rolaram para fora da visualização. Isso garante consumo estável de CPU e memória RAM e mantém a rolagem fluida a 60/120 FPS mesmo com mais de 5.000 tarefas no banco.

---

## 3. Limites de Escala do SharedPreferences e Plano de Transição

* **O Gargalo de I/O:** O `shared_preferences` grava dados em disco serializando a lista de tarefas inteira em uma string JSON contínua. À medida que o arquivo ultrapassa **500 KB** (cerca de 1.000 tarefas com descrições detalhadas), a operação de re-escrever o arquivo a cada alteração sutil de status consome milissegundos adicionais de processamento em background.
* **Plano de Transição de Persistência (Escala Futura):**
  Se as métricas operacionais de auditoria local indicarem que o tempo de gravação assíncrona ultrapassou 150ms em dispositivos de testes intermediários, a base de dados local executará um plano de migração para um banco NoSQL móvel de alto desempenho:
  * **Destino Selecionado:** Biblioteca **Isar** ou **Hive**.
  * **Benefícios:** Isar e Hive gravam dados de forma binária e segmentada (sem desserializar a base inteira para atualizar um único registro), oferecem suporte nativo a indexação estruturada em disco e velocidade de leitura 10 vezes superior ao SharedPreferences.
  * **Processo de Migração:** A classe abstrata do repositório será re-implementada apontando para a nova biblioteca, e um script na inicialização lerá o JSON legado do SharedPreferences, migrará para o Isar/Hive e apagará a chave antiga do SharedPreferences de forma transparente para o usuário.