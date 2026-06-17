# Estrutura de Equipe e Papéis (Project Staffing and RACI)

Este documento especifica a estrutura de papéis e alocação de responsabilidades para o desenvolvimento e manutenção do **Fluxo_Audio_App**. Alinhado com a filosofia de desenvolvimento ágil e eficiente, o projeto é desenhado para ser executado por uma equipe móvel enxuta (*Lean Mobile Team*).

---

## 1. Estrutura da Equipe e Papéis

O ciclo de vida do projeto baseia-se na atuação complementar de dois perfis principais de trabalho:

### A. Engenheiro Mobile Full-Stack (Flutter/Dart Specialist)
* **Responsabilidades:**
  * Desenvolvimento da interface e componentes reutilizáveis baseados no Design System.
  * Integração com pacotes nativos de hardware móvel (microfone, Speech-to-Text).
  * Escrita e manutenção do cliente HTTP de integração com a API do OpenRouter.
  * Desenvolvimento de testes automatizados e configuração das esteiras de CI/CD.
  * Assinatura e publicação de pacotes de release nas consoles das lojas oficiais.

### B. Product Owner (PO) & Product Designer (UX/UI)
* **Responsabilidades:**
  * Definição e priorização de requisitos de negócio (RN) e funcionais (RF).
  * Condução de testes de usabilidade com usuários piloto.
  * Homologação e aceite das jornadas de experiência do usuário (UX Journeys).
  * Design visual e refinamento estético de telas e transições.

---

## 2. Matriz RACI de Responsabilidades

A matriz RACI abaixo define a divisão de atribuições para as decisões e atividades críticas do projeto:

* **R (Responsible):** Quem executa a tarefa.
* **A (Accountable):** Quem responde pela entrega e aprova o resultado.
* **C (Consulted):** Quem é consultado antes ou durante a execução.
* **I (Informed):** Quem é informado sobre a conclusão da tarefa.

| Atividade / Decisão | Engenheiro Mobile | Product Owner / Designer | Usuários Piloto |
| :--- | :---: | :---: | :---: |
| **Definição de Requisitos** | C | A | C |
| **Arquitetura de Código & SDKs** | A | I | - |
| **Desenvolvimento de UI & Widgets** | R | A | C |
| **Integração Speech-to-Text (Voz)** | R | A | - |
| **Validação de Chave OpenRouter** | R | I | - |
| **Execução de Testes de Integração** | R | I | - |
| **Publicação nas Lojas (Release)** | R | A | I |

---

## 3. Plano de Onboarding e Início Rápido

Para novos desenvolvedores que se integrarem ao projeto:
1. **Instalação do SDK:** Instalar a versão estável mais recente do Flutter SDK.
2. **Dependências:** Executar o comando `flutter pub get` na raiz do projeto para instalar os pacotes necessários.
3. **Chave de API:** Gerar uma chave de testes no OpenRouter e configurar no aplicativo local.
4. **Execução:** Executar `flutter run` com emulador Android/iOS conectado.
5. **Verificação de Linter:** Garantir que o linter estático rode limpo executando `flutter analyze`.