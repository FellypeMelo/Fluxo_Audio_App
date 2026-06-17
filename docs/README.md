# Fluxo - Full-Spec Enterprise Architecture

## 1. Visão Executiva
O **Fluxo** representa a vNext de aplicações móveis de produtividade pessoal hiper-focadas, adotando uma arquitetura **Local-First AI-Augmented**. Ao combinar processamento de Linguagem Natural (NLP) via Modelos de Linguagem de Larga Escala (LLMs) com armazenamento 100% on-device, garantimos privacidade por design (Privacy by Design), latência percebida zero para operações de leitura/escrita locais e custo operacional de nuvem quase nulo (Backend-less).

## 2. Princípios Arquiteturais (AI-XP)
- **KISS & YAGNI:** Sem backend customizado. A persistência é on-device (`SharedPreferences`).
- **Privacy by Design:** Dados do usuário não saem do dispositivo, exceto inputs efêmeros enviados para a API de IA.
- **Fail-Safe Degradation:** O aplicativo continua funcionando para captura manual caso a API OpenRouter sofra indisponibilidade.
- **Clean Architecture (Mobile):** Separação de camadas usando `Provider` para state management e injeção de dependências.

## 3. Stack Tecnológica
- **Core:** Flutter 3.0+ / Dart
- **State Management:** Provider
- **Persistência:** SharedPreferences (com abstração Repository)
- **IA Integration:** OpenRouter API (Llama 3.2 3B) via `http`
- **Voice-to-Text:** `speech_to_text` (Nativo/On-device)
