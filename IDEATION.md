# Racional da Composição: Magic-DS Squad

**Data:** 12/05/2026 (revisado 2026-05-19 — squad expandido para 10 agentes; mds-audit deprecated em Round 5; mds-ui + mds-ux + mds-tokens adicionados)
**Domínio:** Design System Engineering & Visual Grooming
**Metodologia:** Even Spaces DS (Human-in-the-loop)

## 1. Por que a nova arquitetura?

Ao alinhar a visão do Magic-DS com as diretrizes de governança avançada (Even Spaces), notou-se a necessidade de suportar fluxos inversos (Figma → Código) e forte aplicação de Heurísticas de Nielsen (UX). Os 10 agentes operam com papéis estritos que garantem separação de responsabilidades:

1. **Orchestrator (Flow_Master):** Roteador JSON silencioso. Escuta o input e direciona o fluxo. Não avalia código, não refatora — só roteia.
2. **Librarian (Knowledge_Curator):** Memória do squad. Indexa o estado atual dos artefatos (tokens, specs, references) e responde "o que já existe?" antes de qualquer ação. Nunca cria nem modifica — só consulta, reporta paths e detecta drift.
3. **Audit (Observer) — DEPRECATED:** Agente visual legado, dividido em Round 5. Redireciona para mds-ui (inspeção visual) ou mds-ux (heurísticas). Ver `agents/mds-audit.md`.
4. **Foundations (Architect):** Cria a estrutura de tokens (Primitive → Semantic → Component). Lida com a organização das 3 camadas. Consome JSON de Audit; entrega JSON de 3 camadas para Governance.
5. **Tokens (W3C Authority):** Guarda o `tokens.json` como fonte primária. Valida formato W3C, resolve cross-set references, gera `tokens-generated.css`. CSS é artefato derivado — nunca editado direto.
6. **Governance (Guardian):** Validador de contratos (naming, prefixo `--sf-`, regras semânticas). Bloqueia tokens fora do padrão. Output em JSON com `status: pass/fail`.
7. **Component (Scribe):** Mapeia propriedades do componente isolado e garante regras de acessibilidade. Passa por Governance antes de Ops quando introduz tokens novos.
8. **Ops (Builder):** Traduz specs validadas em código final (CSS canônico, HTML, React+Tailwind, JSON). Gera output canonical e adapter sincronizados. Code gen do showroom: SEMPRE dinâmico (lê tokens.json), nunca hardcoded. Ver `governance/showroom-dynamic-policy.md`.
9. **UI (Visual Inspector):** Inspeciona fidelidade visual — theme, layout, contraste, density. Usa visão multimodal em prints e HTML renderizado.
10. **UX (UX Evaluator):** Avalia heurísticas de Nielsen, fluxo, arquitetura de informação e microcopy. Inclui `*design-check` (14 princípios) e `*audit-showcase`.

## 2. Archetypes

- **Flow_Master (Orchestrator):** Roteamento puro.
- **Knowledge_Curator (Librarian):** Indexação e consulta de estado.
- **Observer (Audit):** DEPRECATED — dividido em UI + UX.
- **Architect (Foundations):** Estruturador lógico de tokens.
- **W3C Authority (Tokens):** Guardião do JSON e geração de CSS.
- **Guardian (Governance):** Guardião de qualidade e naming.
- **Scribe (Component):** Documentador de API e mapeador de acessibilidade.
- **Builder (Ops):** Construtor de output técnico puro.
- **Visual Inspector (UI):** Inspetor visual e de contraste.
- **UX Evaluator (UX):** Avaliador de heurísticas e fluxo.

## 3. Workflow de Nomes (Component Registry)

Os nomes seguem o padrão `mds-<função>` para referenciar imediatamente o "Magic-DS", isolando este squad no ambiente multissquad AIOX.

## 4. Human-in-the-loop (HITL)

O HITL ocorre em dois pontos do pipeline:

- **Pós-Foundations:** Orchestrator marca `requires_human_approval: true`. O workflow pausa e o usuário aprova o JSON antes do agente seguinte consumir.
- **Pós-Governance (modo block):** Quando há violações que exigem decisão (não correção automática), Governance devolve `ready_for_ops: false` com `violations[]` e `suggested_fix[]`.

A integração com Figma é feita por export do `figma-variables.json` (gerado pelo Ops, formato W3C/Figma Variables), importado manualmente no Figma via plugin.

## 5. Pipeline canônico

```
Audit (DEPRECATED)
     ↓
Foundations → Tokens → Governance → Component → Ops
                                         ↓
                                   UI ↗     ↘ UX
```

Pipeline atual (Round 5):

```
[input visual]  →  mds-ui  →  mds-foundations
[input JSON]    →  mds-tokens
[spec nova]     →  mds-component  →  mds-governance  →  mds-ops
[check visual]  →  mds-ux *design-check
[roteamento]    →  mds-orchestrator  (sempre primeiro)
[consulta]      →  mds-librarian     (antes de criar)
```

## 6. Contratos de handoff entre agentes

Cada handoff tem schema JSON explícito declarado no prompt do agente emissor:

- **Foundations → Governance:** `layers.{primitives,semantic,components}`, `aliases_resolved`, `modes`
- **Governance → Ops:** `status`, `violations[]`, `corrected_tokens`, `ready_for_ops`
- **Librarian → qualquer agente:** `*lookup` e `*index` com paths e drift warnings
- **UI → Foundations:** tokens visuais extraídos com `role_hint` e `confidence`
