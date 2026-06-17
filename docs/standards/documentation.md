# Padrões de Documentação (Documentation Standards)

Este documento estabelece as diretrizes de documentação técnica para o **Fluxo_Audio_App**. A adoção de boas práticas de documentação garante a manutenibilidade do software a longo prazo e facilita o onboarding de novos engenheiros na equipe.

---

## 1. Filosofia: Documentation as Code

Toda a documentação técnica do sistema é tratada com o mesmo rigor científico do código-fonte:
* **Escrita em Markdown:** Mantida em formato legível, utilizando arquivos de marcação Markdown (`.md`) armazenados na pasta raiz `/docs` do repositório.
* **Versionamento de Documentos:** Modificações de documentação técnica devem passar por aprovação em pull requests antes de serem mescladas na branch `master`.
* **Sincronismo Obrigatório:** PRs contendo novas funcionalidades ou refatorações arquiteturais devem atualizar de forma obrigatória as seções correspondentes da documentação técnica e os catálogos associados.

---

## 2. Documentação Interna no Código-Fonte (Dartdoc)

O código Dart deve ser documentado internamente utilizando os geradores de documentação padrão da linguagem (`dartdoc`).

### Regras de Documentação de Código:
* **Comentários de Documentação (`///`):** Use barras triplas para documentar classes, métodos, membros e construtores de uso público ou estratégico de domínio. Comentários de barra dupla (`//`) servem apenas para notas internas de implementação temporárias.
* **Descrição da Intenção e Racional:** O comentário deve explicar *por que* aquela classe ou método existe e o que ele faz conceitualmente, evitando simplesmente parafrasear a assinatura do código.
* **Formatação de Variáveis e Links:**
  * Utilize colchetes `[NomeDaClasse]` para gerar links automáticos de referências a outras entidades do código.
  * Utilize crases para variáveis ou valores literais (ex: \`null\`).

### Exemplo Prático de Documentação Dartdoc:
```dart
/// Representa o serviço de processamento e estruturação de linguagem natural.
///
/// Este serviço conecta-se à API externa do [OpenRouter] para interpretar
/// textos transcritos e retorná-los em formato JSON tipado de tarefa.
class OpenRouterService {
  /// Envia a entrada de texto do usuário para processamento semântico.
  ///
  /// Requer o [rawText] do usuário e o [currentDate] do dispositivo móvel para
  /// calcular datas e prazos relativos. Retorna uma string em formato JSON.
  /// 
  /// Lança uma [HttpException] se o servidor responder com erro 5xx.
  Future<String> requestTaskExtraction({
    required String rawText,
    required DateTime currentDate,
  }) async {
    // ... implementação
  }
}
```

---

## 3. Registros de Decisões de Arquitetura (ADRs)

Alterações significativas de infraestrutura, bancos de dados ou padrões de design devem ser precedidas ou acompanhadas da criação de um **Architecture Decision Record (ADR)** na pasta `/docs/architecture/decisions`.

Cada ADR deve seguir a estrutura padrão com:
1. **Título:** Descritivo e numerado (ex: `adr-003-uso-de-segurança-local.md`).
2. **Status:** `Proposto`, `Aceito`, `Rejeitado` ou `Supercedido`.
3. **Contexto:** Descrição do problema de engenharia e as forças em jogo.
4. **Decisão:** A solução adotada e os motivos de sua escolha sobre as alternativas.
5. **Consequências:** O impacto da decisão (positivo e negativo) na base de código.

---

## 4. Estrutura Padrão de Arquivos do Projeto

A organização de pastas sob a raiz de `/docs` deve obedecer ao seguinte catálogo:
* `/api`: Especificações de autenticação, catálogo de erros HTTP, limites de requisições e versionamento.
* `/architecture`: Visão geral do sistema, diagramas C4 (contexto, containers), resiliência e ADRs.
* `/compliance`: Análises legais de dados e privacidade em conformidade com LGPD e GDPR.
* `/database`: Políticas de cópias de segurança (backup), indexação física e retenção de dados locais.
* `/design`: Diretrizes de acessibilidade visual, jornada UX e padrões de design UI.
* `/requirements`: Requisitos funcionais, não funcionais e matrizes de rastreabilidade do projeto.
* `/standards`: Padrões de desenvolvimento (commits, coding styles, branchs, testes, code review).