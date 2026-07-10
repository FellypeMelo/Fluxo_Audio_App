# -*- coding: utf-8 -*-
import os

base_dir = r"G:\Programas\Fluxo_Audio_App\docs"

files = {
    r"requirements\business-rules.md": "# Business Rules\n\nLista de regras de negócio do Fluxo.",
    r"requirements\functional.md": "# Requisitos Funcionais\n\nLista de RFs mapeados por ID.",
    r"requirements\traceability-matrix.md": "# Matriz de Rastreabilidade\n\nMapeamento RF -> UC -> Testes.",
    r"requirements\domain-boundaries.md": "# Limites de Domínio\n\nDefinição de Bounded Contexts.",
    r"requirements\constraints.md": "# Restrições do Sistema\n\nLimitações técnicas e operacionais.",
    r"requirements\assumptions.md": "# Premissas\n\nPremissas de negócio e técnicas assumidas no projeto.",
    r"architecture\patterns.md": "# Padrões Arquiteturais\n\nRepository Pattern, Clean Architecture, Provider para estado.",
    r"architecture\integrations.md": "# Integrações\n\nOpenRouter API.",
    r"architecture\threat-modeling.md": "# Threat Modeling\n\nMovido de /docs/security para manter estrutura.",
    r"architecture\scalability.md": "# Escalabilidade\n\nEscalabilidade horizontal (API) e on-device.",
    r"architecture\resiliency.md": "# Resiliência\n\nFallback mechanism, Retry policies.",
    r"architecture\observability.md": "# Observabilidade\n\nCrashlytics e logs locais.",
    r"architecture\security.md": "# Segurança\n\nKey Management e Data Privacy.",
    r"architecture\tenancy.md": "# Tenancy\n\nSingle-tenant local por dispositivo.",
    r"architecture\data-governance.md": "# Governança de Dados\n\nRetenção e privacidade on-device.",
    r"architecture\cost-analysis.md": "# Análise de Custos\n\nCusto zero de nuvem, exceto AI API (Pay-per-token).",
    r"database\schema.sql": "-- SQLite Schema Draft (Fallback futuro)\nCREATE TABLE tasks (id TEXT PRIMARY KEY, title TEXT, is_completed BOOLEAN);",
    r"database\indexing.md": "# Indexing Strategy\n\nEstratégia de indexação para consultas rápidas locais.",
    r"database\partitioning.md": "# Partitioning\n\nN/A para SharedPreferences v1.",
    r"database\retention-policy.md": "# Retention Policy\n\nDados mantidos até o usuário limpar o app ou desinstalar.",
    r"database\backup-recovery.md": "# Backup & Recovery\n\nSem backup automático nativo.",
    r"api\openapi.yaml": "openapi: 3.0.0\ninfo:\n  title: Fluxo App OpenRouter Wrapper\n  version: 1.0.0",
    r"api\auth.md": "# Autenticação\n\nNão há auth no app (anônimo).",
    r"api\rate-limit.md": "# Rate Limiting\n\nRate limits impostos pela API OpenRouter.",
    r"api\versioning.md": "# Versionamento de API\n\nUso do header na API externa.",
    r"api\error-catalog.md": "# Catálogo de Erros\n\nMapeamento de exceções e HTTP status.",
    r"design\design-system.md": "# Design System\n\nCores, Tipografia (Material 3).",
    r"design\ui-guidelines.md": "# UI Guidelines\n\nPadding padrão, botões, animações.",
    r"design\accessibility.md": "# Acessibilidade\n\nVoiceOver, contraste, tamanhos de fonte dinâmicos.",
    r"design\ux-journeys.md": "# UX Journeys\n\nJornadas do usuário para captura de tarefas.",
    r"design\responsive-strategy.md": "# Estratégia Responsiva\n\nMobile-first, layout restrito a portrait.",
    r"infrastructure\environments.md": "# Ambientes\n\nDev, Staging (Beta), Production.",
    r"infrastructure\kubernetes.md": "# Kubernetes\n\nN/A para o app Mobile Serverless.",
    r"infrastructure\terraform.md": "# Terraform\n\nN/A (IaC não aplicado no mobile).",
    r"infrastructure\secrets-management.md": "# Secrets Management\n\ndotenv (.env) carregado localmente.",
    r"infrastructure\deployment-strategy.md": "# Deployment Strategy\n\nGoogle Play e App Store Connect.",
    r"infrastructure\rollback-strategy.md": "# Rollback Strategy\n\nHotfix patch com rollback de código.",
    r"infrastructure\sre.md": "# SRE\n\nMonitoramento de Error Rate.",
    r"infrastructure\monitoring.md": "# Monitoramento\n\nFirebase Performance Monitoring.",
    r"standards\coding-standards.md": "# Padrões de Codificação\n\nDart Lint (Effective Dart).",
    r"standards\branching-strategy.md": "# Branching Strategy\n\nGitHub Flow (main + feature branches).",
    r"standards\commits.md": "# Padrões de Commits\n\nConventional Commits (feat, fix, chore).",
    r"standards\code-review.md": "# Code Review\n\nProcesso de PRs e aprovações.",
    r"standards\testing.md": "# Padrões de Testes\n\nFlutter Test, Mocktail.",
    r"standards\documentation.md": "# Padrões de Documentação\n\nAtualização constante das ADRs.",
    r"planning\roadmap.md": "# Roadmap\n\nM1: MVP Captura. M2: Sincronização. M3: IA Avançada.",
    r"planning\milestones.md": "# Milestones\n\nMarcos do projeto.",
    r"planning\risk-analysis.md": "# Análise de Riscos\n\nRiscos tecnológicos e mitigação.",
    r"planning\staffing.md": "# Staffing\n\nComposição da equipe.",
    r"planning\estimates.md": "# Estimativas\n\nEsforço e cronograma.",
    r"planning\technical-debt.md": "# Technical Debt\n\nRegistro de débitos técnicos.",
    r"compliance\lgpd.md": "# LGPD Compliance\n\nAdequação à lei brasileira.",
    r"compliance\gdpr.md": "# GDPR Compliance\n\nAdequação europeia.",
    r"compliance\audit.md": "# Auditoria\n\nTrails e logs (se aplicável).",
    r"compliance\pii-classification.md": "# Classificação PII\n\nIdentificação de dados sensíveis.",
    r"compliance\retention-policy.md": "# Política de Retenção\n\nRegras de deleção.",
    r"compliance\incident-response.md": "# Resposta a Incidentes\n\nPlaybook para vazamentos.",
    r"compliance\privacy-by-design.md": "# Privacy by Design\n\nPrivacidade nativa (Local Storage)."
}

for rel_path, content in files.items():
    file_path = os.path.join(base_dir, rel_path)
    os.makedirs(os.path.dirname(file_path), exist_ok=True)
    with open(file_path, "w", encoding="utf-8") as f:
        f.write(content)

print("Scaffold generation complete with UTF-8 encoding.")
