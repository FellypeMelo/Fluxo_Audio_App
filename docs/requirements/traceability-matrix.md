# Matriz de Rastreabilidade (Traceability Matrix)

Este documento apresenta a rastreabilidade bidirecional do **Fluxo_Audio_App**. Ele mapeia a correspondência entre Requisitos de Negócio (RN), Requisitos Funcionais (RF), Requisitos Não Funcionais (RNF - descritos em `non-functional.md`) e os arquivos de código correspondentes na implementação técnica do aplicativo.

---

## 1. Rastreabilidade Vertical: Requisitos vs. Código

A tabela abaixo correlaciona as definições conceituais com os arquivos físicos de implementação na pasta `lib/` do projeto.

| ID Requisito | Tipo | Descrição Sumária | Implementação no Código-Fonte |
| :--- | :--- | :--- | :--- |
| **RN-01** | Negócio | Máquina de Estados da Tarefa | [task_model.dart](file:///G:/Programas/Fluxo_Audio_App/lib/models/task_model.dart) |
| **RN-02** | Negócio | Antiperda com Fallback para Tarefas | [task_provider.dart](file:///G:/Programas/Fluxo_Audio_App/lib/providers/task_provider.dart) / [openrouter_service.dart](file:///G:/Programas/Fluxo_Audio_App/lib/services/openrouter_service.dart) |
| **RN-03** | Negócio | Contexto Temporal (Data Atual na IA) | [openrouter_service.dart](file:///G:/Programas/Fluxo_Audio_App/lib/services/openrouter_service.dart) |
| **RN-04** | Negócio | Escala de Prioridades Estrita | [task_model.dart](file:///G:/Programas/Fluxo_Audio_App/lib/models/task_model.dart) |
| **RN-05** | Negócio | Local-First & Limpeza de Áudio | [capture_screen.dart](file:///G:/Programas/Fluxo_Audio_App/lib/screens/capture_screen.dart) / [task_provider.dart](file:///G:/Programas/Fluxo_Audio_App/lib/providers/task_provider.dart) |
| **RN-06** | Negócio | Custódia Segura de API Key | [task_provider.dart](file:///G:/Programas/Fluxo_Audio_App/lib/providers/task_provider.dart) |
| **RF-01** | Funcional | Configurar Chave de API na UI | [capture_screen.dart](file:///G:/Programas/Fluxo_Audio_App/lib/screens/capture_screen.dart) (Modal de Configurações) |
| **RF-02** | Funcional | Alternância de Tema Claro/Escuro | [main.dart](file:///G:/Programas/Fluxo_Audio_App/lib/main.dart) / [task_provider.dart](file:///G:/Programas/Fluxo_Audio_App/lib/providers/task_provider.dart) |
| **RF-03** | Funcional | Gravação de Voz via Microfone | [capture_screen.dart](file:///G:/Programas/Fluxo_Audio_App/lib/screens/capture_screen.dart) (Speech-to-Text integration) |
| **RF-04** | Funcional | Transcrição em Tempo Real (STT) | [capture_screen.dart](file:///G:/Programas/Fluxo_Audio_App/lib/screens/capture_screen.dart) |
| **RF-05** | Funcional | Digitação Manual de Texto Livre | [capture_screen.dart](file:///G:/Programas/Fluxo_Audio_App/lib/screens/capture_screen.dart) |
| **RF-06** | Funcional | Extração de Tarefas via Llama | [openrouter_service.dart](file:///G:/Programas/Fluxo_Audio_App/lib/services/openrouter_service.dart) |
| **RF-07** | Funcional | Fallback de Conexão com a IA | [task_provider.dart](file:///G:/Programas/Fluxo_Audio_App/lib/providers/task_provider.dart) |
| **RF-08** | Funcional | Listagem de Tarefas na Tela Principal | [capture_screen.dart](file:///G:/Programas/Fluxo_Audio_App/lib/screens/capture_screen.dart) / [task_card.dart](file:///G:/Programas/Fluxo_Audio_App/lib/widgets/task_card.dart) |
| **RF-09** | Funcional | Marcar/Desmarcar como Concluída | [task_card.dart](file:///G:/Programas/Fluxo_Audio_App/lib/widgets/task_card.dart) / [task_provider.dart](file:///G:/Programas/Fluxo_Audio_App/lib/providers/task_provider.dart) |
| **RF-10** | Funcional | Swipe lateral no card de tarefa | [task_card.dart](file:///G:/Programas/Fluxo_Audio_App/lib/widgets/task_card.dart) (Slidable Integration) |
| **RF-11** | Funcional | Edição Manual Detalhada de Tarefa | [task_card.dart](file:///G:/Programas/Fluxo_Audio_App/lib/widgets/task_card.dart) (Formulário de Edição) |
| **RF-12** | Funcional | Painel de Estatísticas de 7 Dias | [capture_screen.dart](file:///G:/Programas/Fluxo_Audio_App/lib/screens/capture_screen.dart) (Widget de Estatísticas) |

---

## 2. Rastreabilidade de Requisitos Não Funcionais (RNFs)

Esta tabela mapeia as restrições e qualidades técnicas (segurança, performance, usabilidade) para suas respectivas validações físicas.

| ID RNF | Categoria | Descrição Sumária | Validação / Componente |
| :--- | :--- | :--- | :--- |
| **RNF-01** | Performance | Latência da IA < 2.5 segundos | Monitoramento HTTP no [openrouter_service.dart](file:///G:/Programas/Fluxo_Audio_App/lib/services/openrouter_service.dart) |
| **RNF-02** | Usabilidade | Interface Responsiva em Telas Móveis | Design LayoutBuilder em [capture_screen.dart](file:///G:/Programas/Fluxo_Audio_App/lib/screens/capture_screen.dart) |
| **RNF-03** | Confiabilidade | Taxa de Erro de Parsing JSON < 1% | Blocos Try/Catch estruturados em [openrouter_service.dart](file:///G:/Programas/Fluxo_Audio_App/lib/services/openrouter_service.dart) |
| **RNF-04** | Portabilidade | Compatibilidade Android e iOS | Testes multi-dispositivo do Flutter Engine |
| **RNF-05** | Segurança | Criptografia local das preferências | Uso de Shared Preferences isoladas na Sandbox do SO |
| **RNF-06** | Manutenibilidade | Arquitetura modular limpa e desacoplada | Organização baseada em Contextos de Domínio |

---

## 3. Matriz de Cobertura de Testes Recomendada

Mapeamento de quais arquivos de testes unitários ou de integração cobrem as funcionalidades-chave.

* **Requisitos Funcionais de UI (RF-03, RF-04, RF-08, RF-10):**
  * Cobertos por: `test/widget_test.dart` (validação de botões, renderização de cards e alternância de temas).
* **Requisitos Funcionais de Lógica & IA (RF-06, RF-07, RN-02, RN-03):**
  * Cobertos por: `test/openrouter_service_test.dart` (uso de Mocks de HTTP Client para simular retornos normais de JSON e respostas de erro 500/timeouts para validar o fallback).
* **Requisitos de Persistência e Regras de Negócio (RF-09, RF-11, RN-01, RN-04):**
  * Cobertos por: `test/task_provider_test.dart` (validação de leitura/escrita simulando `SharedPreferences.setMockInitialValues`).