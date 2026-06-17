# Diretrizes de Code Review (Code Review Guidelines)

Este documento estabelece as diretrizes e o padrão de qualidade a serem aplicados durante o processo de revisão de código (*Code Review*) em Pull Requests (PRs) do **Fluxo_Audio_App**.

---

## 1. Objetivos do Code Review

O principal propósito do Code Review não é apenas encontrar erros de digitação, mas sim:
* **Garantir a Consistência:** Manter a base de código alinhada com as convenções de arquitetura e design estabelecidas.
* **Compartilhar Conhecimento:** Disseminar soluções técnicas inovadoras e boas práticas entre todos os membros do time.
* **Prevenir Bugs e Vazamentos de Memória:** Detectar precocemente lacunas de segurança, loops infinitos, acoplamentos desnecessários e falhas de gerenciamento de recursos.

---

## 2. Checklist Técnico de Revisão (Dart/Flutter)

Ao revisar um Pull Request, utilize a lista abaixo como critério de aceitação técnica:

### A. Performance e Ciclo de Vida de Widgets
* [ ] **Uso de Construtores `const`:** Os construtores `const` estão declarados em todos os widgets cujas propriedades são imutáveis em tempo de compilação? Isso evita re-renderizações redundantes no Flutter.
* [ ] **Gerenciamento e Liberação de Recursos (`dispose`):** Todos os controllers alocados (ex: `TextEditingController`, `AnimationController`, `StreamController`, `ScrollController`) estão sendo descartados no método `dispose()` de seus respectivos `StatefulWidgets` para evitar vazamentos de memória?
* [ ] **Filtro de Lógica em Builders:** Os métodos `build()` de widgets estão livres de operações pesadas (leitura de disco, requisições HTTP, conversões intensivas de texto)? Lógicas complexas devem residir exclusivamente nos Providers.

### B. Arquitetura e Injeção de Dependências
* [ ] **Separação de Camadas (MVVM):** A interface do usuário (widgets) interage com o modelo e serviços exclusivamente por meio do `Provider`/`ChangeNotifier`? Nenhum widget deve chamar requisições HTTP ou ler diretamente chaves do `SharedPreferences` sem intermédio da camada de Provider.
* [ ] **Tratamento de Estado Assíncrono:** Telas que aguardam dados da rede tratam corretamente os estados de carregamento (ex: indicadores visuais de progresso - spinners), sucesso e erro amigável.

### C. Segurança, Resiliência e Fallbacks
* [ ] **Timeout nas Requisições:** Todas as chamadas de rede no `OpenRouterService` possuem parâmetros de timeout definidos (mínimo de 10s, máximo de 30s) para evitar que a aplicação trave infinitamente?
* [ ] **Mecanismo de Fallback Ativo:** Mudanças que impactam o parser de IA asseguram a integridade do fallback antiperda descrito na regra `RN-02`?
* [ ] **Exposição de Segredos:** Nenhuma chave de API (OpenRouter ou similar) ou token de teste está hardcoded no código ou foi commitado acidentalmente.

### D. Padrões de Código e Linter
* [ ] **Zero Linter Warnings:** O código atende de forma estrita a todas as regras especificadas no arquivo `analysis_options.yaml`? Avisos e warnings estáticos devem ser corrigidos antes do merge.

---

## 3. Guia de Conduta e Comunicação

A revisão de código é um processo colaborativo e de aprendizado mútuo. Siga estas diretrizes de comunicação:

### Recomendações para o Revisor:
* **Seja Construtivo e Gentil:** Faça críticas ao código, nunca à pessoa que o escreveu. Diga *"Este bloco de código pode ser simplificado usando..."* em vez de *"Você escreveu um código ineficiente"*.
* **Explique o Racional:** Sempre explique o porquê de uma sugestão técnica. Forneça links de referências ou exemplos práticos de refatoração.
* **Classifique os Comentários:** Identifique o nível de severidade de seus comentários:
  * `[Bloqueante]` - Correção necessária para a estabilidade ou arquitetura. O PR não deve ser mergeado sem correção.
  * `[Melhoria]` - Sugestão de refatoração para legibilidade futura ou otimização secundária. Opcional para merge imediato.
  * `[Dúvida/Pergunta]` - Questionamento para entender a intenção do desenvolvedor.

### Recomendações para o Autor:
* **Evite Postura Defensiva:** Veja os comentários como uma oportunidade de melhorar a qualidade do produto e crescer tecnicamente.
* **Justifique Decisões:** Caso opte por rejeitar uma recomendação não bloqueante, explique detalhadamente o contexto técnico de sua decisão.