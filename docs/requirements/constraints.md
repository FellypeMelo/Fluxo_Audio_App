# Restrições do Projeto (Constraints)

Este documento identifica e descreve as restrições técnicas, arquiteturais e de negócio que limitam o espaço de design e implementação para o desenvolvimento do **Fluxo_Audio_App**. Todas as decisões técnicas devem respeitar essas fronteiras.

---

## 1. Restrições Arquiteturais e de Infraestrutura

### RE-01: Arquitetura Local-First Estrita
* **Descrição:** O aplicativo deve operar de forma autônoma no dispositivo do usuário final. Ele não pode depender de um banco de dados centralizado em nuvem própria (ex: PostgreSQL remoto, Firestore, DynamoDB) para seu funcionamento diário.
* **Racional:** Redução de custos operacionais a zero para o mantenedor do projeto e garantia de privacidade dos dados do usuário final.
* **Impacto:** Recursos como sincronização em tempo real entre diferentes dispositivos e compartilhamento colaborativo de tarefas estão excluídos do escopo de design básico.

### RE-02: Backend-less Corporativo
* **Descrição:** Não há servidores de aplicação intermediários (APIs REST corporativas, microsserviços ou funções Serverless próprias) desenvolvidos especificamente para este aplicativo.
* **Racional:** Eliminação de complexidade de deploy, manutenção e custos de infraestrutura em nuvem.
* **Impacto:** O aplicativo interage diretamente do cliente (Flutter) com as APIs públicas do Speech-to-Text nativo do sistema operacional e da API do OpenRouter.

## 2. Restrições de Desenvolvimento e Stack Tecnológico

### RE-03: Stack de Desenvolvimento Baseado em Flutter
* **Descrição:** A interface do usuário e a lógica de negócios devem ser implementadas usando o framework **Flutter (SDK Dart)**.
* **Racional:** Reutilização de código multiplataforma (Android e iOS) com uma única base de código.
* **Impacto:** Qualquer funcionalidade nativa que não possua pacote Flutter estável correspondente (como hooks profundos de hardware de áudio) precisará ser desenvolvida via *MethodChannels* em Kotlin/Swift.

### RE-04: Persistência Baseada em Chave-Valor Simples (SharedPreferences)
* **Descrição:** O banco de dados local deve utilizar primitivos de armazenamento chave-valor simples, especificamente a biblioteca `shared_preferences` do Flutter.
* **Racional:** Facilidade de instalação, zero configuração de bancos relacionais complexos no dispositivo (como SQLite/Room) e leitura ultra-rápida na inicialização do aplicativo.
* **Impacto:** O aplicativo deve serializar e desserializar todas as listas de tarefas em formato string JSON antes de gravar. Isso limita a eficiência de consultas complexas ou paginações profundas se o volume de tarefas ultrapassar milhares de registros.

## 3. Restrições de Integração e APIs de Terceiros

### RE-05: Dependência Síncrona da API OpenRouter
* **Descrição:** A extração e enriquecimento de tarefas dependem de requisições HTTP REST síncronas direcionadas ao OpenRouter.
* **Racional:** Uso do modelo de inteligência artificial Llama 3.2 3B de forma remota, viabilizando o processamento em dispositivos de baixo desempenho que não poderiam executar um LLM localmente.
* **Impacto:** Se a API do OpenRouter estiver offline ou sofrer de alta latência, o recurso de extração por voz/texto livre inteligente ficará indisponível, forçando o aplicativo a usar sua regra de negócio de fallback.

### RE-06: Processamento de Voz Baseado nas APIs de Speech-to-Text Nativas
* **Descrição:** A transcrição de áudio em texto baseia-se exclusivamente no pacote `speech_to_text`, o qual expõe os reconhecedores de voz nativos do sistema operacional Android ou iOS.
* **Racional:** Minimizar o tráfego de dados de áudio na rede (evitando o envio de arquivos binários pesados de áudio a um servidor de transcrição externo) e manter a gratuidade de transcrição.
* **Impacto:** A precisão do reconhecimento de voz varia de acordo com o fabricante do dispositivo, a versão do sistema operacional e os serviços de fala instalados pelo usuário (ex: reconhecimento offline versus online do Google Voice).

## 4. Restrições Regulatórias e de Segurança

### RE-07: Privacidade dos Dados Enviados à API
* **Descrição:** Como o aplicativo envia texto contendo anotações livres do usuário para a OpenRouter, o aplicativo não deve enviar nenhuma informação de identificação pessoal (PII) do usuário na carga útil da requisição (payload), como tokens de geolocalização do dispositivo, IDs de hardware únicos (IMEI), nome do usuário ou e-mail.
* **Racional:** Conformidade com leis de privacidade de dados (LGPD no Brasil e GDPR na Europa).
* **Impacto:** O app deve estruturar os payloads focando estritamente na transcrição do áudio gravado e nos parâmetros do modelo.