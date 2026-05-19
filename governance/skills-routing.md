# Skills Routing — Disambiguation entre auditores e conceptors

**Status:** v1 — 2026-05-15
**Consumido por:** `mds-orchestrator` (decisão de roteamento)
**Fonte:** abstraído das 3 skills jvictor1223/claude-skills

---

## 3 vetores de trabalho UX/UI — cada um com agente diferente

| Skill / Vetor | Trigger | Agente nosso | Output |
|---|---|---|---|
| **ux-audit** (estruturado, quantitativo) | "audit", "check", "validar", "WCAG", "contraste", "consistência DS", screenshot+request | `mds-audit *design-check` | JSON com score A/B/C/D + 14 princípios + severity por issue |
| **design-critique** (qualitativo, peer review) | "o que você acha", "critique", "review", `[DESIGN]` tag em UI artifact | `mds-audit *design-critique` (variante) | Prose markdown: Summary + Positive + Critical/Important/Suggestions |
| **ux-design** (conceitual, estratégico) | "como desenhar", flow, IA strategy, microcopy, handoff, "discutir decisão" | `mds-component *map-component` (conceitual) | Structured Design Response: Problem / Constraints / Recommended / Alternatives / Open Questions |
| **showroom-audit** (conformidade do artefato) | "audit showroom", "revise showroom", "validar showcase", "showroom contra DS" | `mds-audit *audit-showcase` | JSON com 6 categorias (dual vocabulary, white-label policy, density guard, manifest freshness, theme contract, anti-leak) + severity por finding |

---

## Mode-Specific Tags (universais nos 3)

Quando user incluir tag no prompt, modula comportamento:

| Tag | Comportamento |
|---|---|
| `[EXEC]` | Executa tarefa sem critique não solicitado nem alternativas. Direto ao output. |
| `[EXPLORE]` | Mapa do problema completo: second-order consequences, tradeoffs, múltiplas opções com pros/cons. |
| `[DESIGN]` | Defere pra `design-critique` mode (qualitative peer review) — invoca `mds-audit *design-critique`. |
| `[QUICK]` | Resposta em ≤5 sentenças. Single most impactful insight. |
| `[LEARN]` | Ensinar conceito: definição precisa + princípio + exemplo prático + erro comum. |

**Sem tag:** orchestrator infere do contexto:
- Screenshot/mockup compartilhado → roteia pra `audit`
- Pergunta conceitual/arquitetural → `[EXPLORE]` depth + roteia pra `component`
- "Como faço" / task-oriented → resposta direta
- Iteração sobre resposta anterior → match prior depth
- "O que é X" / "explique X" → `[LEARN]` structure

---

## Hierarchy of Design Concerns (princípio fundamental)

Nunca sacrificar tier mais alto pra melhorar tier mais baixo:

1. **Function** — A tarefa do user é completável?
2. **Clarity** — Todo state/action/conteúdo é inambíguo?
3. **Accessibility** — WCAG 2.1 AA mínimo. Color-blind safe. Keyboard navigable.
4. **Feedback** — Sistema comunica state changes, erros, progresso?
5. **Efficiency** — Custo de interação proporcional à importância da ação?
6. **Consistency** — Segue padrões estabelecidos (DS, plataforma)?
7. **Aesthetics** — Refinement visual, só DEPOIS de 1-6 satisfeitos.

Aplicar em qualquer agente de auditoria/decisão. Se trade-off força escolha, sempre a favor do tier superior.

---

## Scope explícito por skill (in/out)

### `ux-audit` (mds-audit *design-check)
**In:** Estrutural — contraste numérico, spacing tokens, WCAG SC compliance, 14 princípios design score.
**Out:** Crítica subjetiva, decisões estratégicas, microcopy, IA conceitual.

### `design-critique` (mds-audit *design-critique)
**In:** Peer review qualitativo, layout, copy, hierarquia, flows, formulários, navegação, feedback, consistência, A11y visível, cognitive load.
**Out:** Tech specifics (framework, DS), brand strategy, backend.

### `ux-design` (mds-component conceitual)
**In:** Conceitual — flows, IA, component specs, microcopy, handoff strategy, research synthesis.
**Out:** Visual audit numérico (defere ao ux-audit).

---

## Anti-overlap rules

- Se user pede contraste numérico → `ux-audit` (não critique)
- Se user pede "what do you think" → `design-critique` (não audit numérico)
- Se user pede flow/IA → `ux-design` (não audit)
- Se user pede tudo junto → orchestrator roteia em sequência (audit → critique → design conceitual quando aplicável)
