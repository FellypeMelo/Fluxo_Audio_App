# Roteiro de Evolução do Produto (Product Roadmap)

Este documento especifica o roadmap estratégico de desenvolvimento do **Fluxo_Audio_App**. Ele projeta a evolução do aplicativo em três horizontes temporais distintos, equilibrando a manutenção da privacidade local com a adição de recursos inovadores de engenharia.

---

## Linha do Tempo Evolutiva

```text
  [ Curto Prazo ]             [ Médio Prazo ]             [ Longo Prazo ]
  🚀 Lançamento v1.0.0        📂 Exportação e Tags        🧠 IA On-Device (100% Offline)
  Estabilização & Testes      Backups Manuais & Filtros    Sincronização Segura E2EE
```

---

## Horizontes de Desenvolvimento

### 1. Curto Prazo: Estabilização de Lançamento (Foco Atual - v1.0.0)
* **Objetivo:** Lançar a primeira versão oficial estável nas lojas, garantindo zero bugs de interface e cobertura confiável de testes lógicos.
* **Principais Entregas:**
  * Polimento estético do Design System com micro-animações de ondas de áudio.
  * Inclusão de testes unitários e de widget cobrindo 80% da lógica.
  * Mapeamento completo dos arquivos de acessibilidade móvel (A11y).
  * Criação da landing page básica com a política de privacidade exigida pelas lojas.

### 2. Médio Prazo: Incrementos de Usabilidade e Controle (Próximos 3 Meses - v1.5.0)
* **Objetivo:** Dar maior autonomia ao usuário sobre seus dados locais e enriquecer a organização de tarefas sem sair do modelo local-first.
* **Principais Entregas:**
  * **Exportação e Importação de Tarefas:** Permitir exportar o histórico de tarefas em arquivo JSON ou CSV estruturado para que o usuário faça seu próprio backup físico manual.
  * **Etiquetas e Filtros Dinâmicos:** Ensinar a IA a identificar marcadores/tags nas frases (ex: "estudar flutter etiqueta estudo") e organizar as visualizações com base nestas tags.
  * **Pesquisa de Texto Completo (Full-Text Search):** Busca rápida na lista local utilizando filtros lógicos em memória no Dart.

### 3. Longo Prazo: IA On-Device e Sincronização Segura (Próximos 6 a 12 Meses - v2.0.0)
* **Objetivo:** Alcançar a independência total da internet e viabilizar a sincronização de tarefas preservando a privacidade por meio de criptografia avançada.
* **Principais Entregas:**
  * **IA 100% On-Device (Inferência Local):** Migrar a estruturação semântica de tarefas para um modelo de LLM ultraleve (ex: *Llama 3.2 1B* ou *Gemma 2 2B*) rodando de forma física local dentro do celular do usuário (usando SDKs móveis como MediaPipe LLM Inference ou Llama.cpp compilado nativamente), eliminando custos e dependência de rede com a API externa do OpenRouter.
  * **Sincronização Multi-Dispositivo com Criptografia Ponta a Ponta (E2EE):** Oferecer sincronização via nuvem, onde os dados das tarefas são criptografados localmente no dispositivo usando uma senha mestra do usuário antes de serem transmitidos para um banco de dados serverless compartilhado, impedindo que o mantenedor do app ou servidores em nuvem acessem o conteúdo das anotações.