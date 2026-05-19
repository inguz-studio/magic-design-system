# A11y Joint Checks — Absorbed from ui-ux-pro-max

**Source:** ui-ux-pro-max-skill (nextlevelbuilder)
**Original:** https://github.com/nextlevelbuilder/ui-ux-pro-max-skill
**Imported:** 2026-05-18 (Round 5)
**Translation rules applied:** `governance/external-knowledge-translation-rules.md`
**Consumido por:** `mds-ui` E `mds-ux` (joint — depende do tipo de check)

---

## 0. Por que A11y e joint

Acessibilidade tem **dois lados**:

- **UI side (visual):** contrast, focus ring visivel, color-not-only (icon + texto)
- **UX side (semantic):** keyboard nav, screen reader order, aria-labels, escape routes

Items abaixo declaram qual orchestrator (`ui-orch` ou `ux-orch`) e responsavel por cada check. Joint checks (ambos) tem ownership compartilhada.

---

## §1. A11y Joint Checks (15 items absorvidos da Priority 1)

### A11Y-1 — Color contrast 4.5:1
**Owner:** mds-ui (calculo + validacao visual)
**Severity:** error
**Standard:** WCAG AA, Material Design
**Translation:** computado via getComputedStyle + luminance formula. Roda em BOTH modes (dark + light) automaticamente.
**Cross-ref:** UI-DARK-2, UI-DARK-3

### A11Y-2 — Focus states visiveis
**Owner:** joint (mds-ui: visual ring; mds-ux: ordem tabbing)
**Severity:** error
**Standard:** Apple HIG, Material Design
**Translation:** 2-4px focus ring. Usar `var(--sf-shadow-focus-ring)`. Tab order check via DOM walk.
**Cross-ref:** UI-PD-3 (em ui-pre-delivery-checklist.md), UX-COM-3

### A11Y-3 — Alt text descritivo
**Owner:** mds-ux (semantic check)
**Severity:** error
**Standard:** WCAG 1.1.1
**Translation:** images meaningful tem alt descritivo. Decorativas tem `alt=""` explicito.

### A11Y-4 — Aria-labels em icon-only buttons
**Owner:** mds-ux (semantic)
**Severity:** error
**Standard:** Apple HIG, Material Design
**Translation:** `<button>` com so icone (sem texto adjacente) tem `aria-label`. Em native (Apple HIG): `accessibilityLabel`. Cross-ref UI-ICON-8 (touch target).

### A11Y-5 — Keyboard navigation completa
**Owner:** mds-ux (flow)
**Severity:** error
**Standard:** Apple HIG, WCAG 2.1.1
**Translation:** Tab order matches visual order. Sem keyboard trap. Full keyboard support.

### A11Y-6 — Form labels com `for` ou wrap
**Owner:** mds-ux
**Severity:** error
**Standard:** WCAG 1.3.1
**Translation:** `<label for="input-id">` ou `<label>` wrappando input. Cross-ref UX-FORM-1.

### A11Y-7 — Skip links pra keyboard users
**Owner:** mds-ux
**Severity:** warning
**Standard:** WCAG 2.4.1
**Translation:** "Skip to main content" link no inicio do tab order. Especialmente em paginas nav-heavy.

### A11Y-8 — Heading hierarchy sequencial
**Owner:** mds-ux
**Severity:** error (era Medium na fonte, elevado pq quebra screen reader)
**Standard:** WCAG 1.3.1
**Translation:** h1 -> h2 -> h3 (sem pular). Headings sao para estrutura, NUNCA pra estilizacao.

### A11Y-9 — Color not only
**Owner:** joint (mds-ui valida visual, mds-ux valida semantic)
**Severity:** error
**Standard:** WCAG 1.4.1, Apple HIG, Material
**Translation:** Erro/success NUNCA usa SO cor. Sempre icon + text alem da cor.

### A11Y-10 — Dynamic Type / text scaling
**Owner:** mds-ui (layout breaking) + mds-ux (legibilidade)
**Severity:** error
**Standard:** Apple Dynamic Type, Material
**Translation:** Suportar system text scaling. Sem truncation quando text cresce.

### A11Y-11 — Reduced motion respeitado
**Owner:** mds-ui (motion implementation)
**Severity:** error
**Standard:** Apple Reduced Motion API, Material
**Translation:** `@media (prefers-reduced-motion: reduce)` zera todos motion tokens. Nosso `reduce-motion` set ja faz isso.
**Cross-ref:** UI-MOTION-9, UI-CHART-11

### A11Y-12 — VoiceOver / Screen Reader
**Owner:** mds-ux
**Severity:** error
**Standard:** Apple HIG, Material
**Translation:** `accessibilityLabel`/`accessibilityHint` meaningful. Reading order logico.

### A11Y-13 — Escape routes em modals/flows
**Owner:** mds-ux (flow)
**Severity:** error
**Standard:** Apple HIG, WCAG 3.3.4
**Translation:** Modais + multi-step com cancel/back claros. Sem dead-end.
**Cross-ref:** UX-NAV-10

### A11Y-14 — Keyboard shortcuts preserved
**Owner:** mds-ux
**Severity:** warning
**Standard:** Apple HIG
**Translation:** System + a11y shortcuts preservados. Drag-and-drop tem keyboard alternative.

### A11Y-15 — Screen reader live regions errors
**Owner:** mds-ux (semantic)
**Severity:** error
**Standard:** WCAG 4.1.3
**Translation:** `aria-live="polite"` ou `role="alert"` em error messages. Sem visual-only error.
**Cross-ref:** UX-FORM-28, UX-FORM-29

---

## §2. A11y checks adicionais cross-cutting

### A11Y-16 — Sortable tables aria-sort
**Owner:** mds-ux (semantic on tables)
**Severity:** error
**Standard:** WCAG
**Translation:** `<th aria-sort="ascending|descending|none">`. Cross-ref UI-CHART-20.

### A11Y-17 — Chart screen reader summary
**Owner:** mds-ux
**Severity:** error
**Standard:** WCAG
**Translation:** Charts tem text summary ou `aria-label` descrevendo insight. Cross-ref UI-CHART-26.

### A11Y-18 — Focusable chart elements
**Owner:** joint (mds-ui: visual focus; mds-ux: keyboard nav order)
**Severity:** error
**Translation:** Interactive chart elements keyboard-navigable. Cross-ref UI-CHART-25.

### A11Y-19 — Tooltips nao depend so de hover
**Owner:** joint
**Severity:** error
**Translation:** Tooltip content reachable via keyboard. Cross-ref UI-CHART-19.

### A11Y-20 — Focus on route change
**Owner:** mds-ux
**Severity:** error
**Standard:** WCAG, MD
**Translation:** Apos transition de rota, foco move pra main content. Screen reader users navegam suavemente.
**Cross-ref:** UX-NAV-23

---

## Severity Distribution

| Severity | Count | % |
|---|---|---|
| error | 18 | 90% |
| warning | 2 | 10% |
| info | 0 | 0% |
| **Total** | **20** | **100%** |

A11y items sao dominante **error** — violacao impacta usuario direto e violacao de standards (WCAG, ADA, ABNT).

---

## Ownership matrix (resumo)

| Owner | Items | Caracteristica |
|---|---|---|
| **mds-ui exclusivo** | A11Y-1, A11Y-11 | Calculo visual / motion implementation |
| **mds-ux exclusivo** | A11Y-3, A11Y-4, A11Y-5, A11Y-6, A11Y-7, A11Y-8, A11Y-12, A11Y-13, A11Y-14, A11Y-15, A11Y-16, A11Y-17, A11Y-20 | Semantic markup, flow, screen reader |
| **Joint (ambos)** | A11Y-2, A11Y-9, A11Y-10, A11Y-18, A11Y-19 | Visual + semantic cooperacao |

---

## Como agents usam

```yaml
agents/mds-ui.md:
  dependencies:
    checklists:
      - ui-pro-max-a11y-joint.md           # filter por owner mds-ui ou joint

agents/mds-ux.md:
  dependencies:
    checklists:
      - ui-pro-max-a11y-joint.md           # filter por owner mds-ux ou joint
```

Comando dispatchado pelo orchestrator:
- `*a11y-audit` (joint command): roda no mds-ui (subset visual) E mds-ux (subset semantic) em paralelo, com scores independentes.
- `*contrast-audit` (mds-ui only): apenas A11Y-1 + A11Y-2 visual + A11Y-9 visual side
- `*screen-reader-audit` (mds-ux only): A11Y-3, A11Y-4, A11Y-5, A11Y-12, A11Y-15, A11Y-17

---

## Padrao de routing pro orchestrator

```json
{
  "user_input": "audita a11y desse Button",
  "routing": {
    "agent_primary": "ui",
    "secondary_dispatch": "ux",
    "commands": [
      "ui-orch *contrast-audit Button",
      "ux-orch *screen-reader-audit Button"
    ],
    "merge": "joint score, sem fusao numerica"
  }
}
```

---

## Re-sync notes

Quando re-syncar com upstream da skill (1x/ano):
- Verificar se Priority 1 mudou itens
- Adicionar novos A11y standards (ex: WCAG 2.2 quando aplicavel)
- Manter ownership matrix atualizada
