# Responsive Checklist

**Status:** Adotado (Round 5)
**Consumido por:** `mds-ui *responsive-stress`
**Cobertura:** 4 breakpoints (375 / 768 / 1024 / 1440) + landscape

---

## 0. Quando rodar

`mds-ui *responsive-stress --component=<X>` invoca este checklist quando:
- Componente novo criado
- Layout/breakpoint alterado
- Pre-delivery (companion do `*audit-ui`)

---

## §1. Mobile (375px) — 8 checks

### RESP-M-1 — Renderiza sem overflow horizontal
**Severity:** error. scrollWidth <= clientWidth no viewport 375px.

### RESP-M-2 — Texto body >= 16px (iOS auto-zoom prevention)
**Severity:** error. Body text usa `--sf-primitive-text-base` (16px) ou `--sf-primitive-text-sm` (14px com explicacao).

### RESP-M-3 — Touch targets >= 44pt
**Severity:** error. Botoes/links interativos respeitam min 44px hit area.

### RESP-M-4 — Touch spacing >= 8px gap
**Severity:** warning. Adjacent touch targets tem `gap-2` ou maior.

### RESP-M-5 — Conteudo principal visible above-the-fold
**Severity:** warning. Hero/CTA aparece sem scroll em 375x812 (iPhone 13).

### RESP-M-6 — Nav primary acessivel em mobile (bottom nav ou hamburger)
**Severity:** error. Sidebar full nao cabe em 375 — colapsar.

### RESP-M-7 — Safe area awareness (notch/Dynamic Island)
**Severity:** warning. Top safe area respeitada se aplicavel.

### RESP-M-8 — No `width: <px>` fixo em containers principais
**Severity:** error. Containers usam `max-width` + `width: 100%` ou flex.

---

## §2. Tablet (768px) — 6 checks

### RESP-T-1 — Renderiza sem overflow
**Severity:** error.

### RESP-T-2 — Layout transitiona suave de mobile pra tablet
**Severity:** warning. Sem "salto" abrupto entre breakpoints.

### RESP-T-3 — Container usa `--sf-container-reading` (768px) ou similar
**Severity:** warning. Reading content respeita max-width pra readability.

### RESP-T-4 — 2-column layouts comecam aparecer
**Severity:** info. Cards lado a lado, side panel etc.

### RESP-T-5 — Landscape orientation suportada
**Severity:** error. Landscape mobile (devices grandes) nao quebra.

### RESP-T-6 — Touch targets ainda 44pt+
**Severity:** error. Tablet ainda e touch — manter sizing.

---

## §3. Laptop (1024px) — 5 checks

### RESP-L-1 — Renderiza sem overflow
**Severity:** error.

### RESP-L-2 — Sidebar visivel (se aplicavel)
**Severity:** info. >= 1024px: prefer sidebar over bottom/top mobile nav.

### RESP-L-3 — Container usa `--sf-container-page` (1280px) ou similar
**Severity:** warning. Pagina respeita max-width.

### RESP-L-4 — Multi-column comum (3+ colunas em grid)
**Severity:** info.

### RESP-L-5 — Mouse-only interactions OK (hover states funcionam)
**Severity:** warning. Hover preview, dropdowns on hover, etc.

---

## §4. Desktop (1440px+) — 4 checks

### RESP-D-1 — Renderiza sem overflow
**Severity:** error.

### RESP-D-2 — Content nao "perde-se" em viewport gigante
**Severity:** warning. Max-width evita full-width text em telas largas (line length 65-75 chars).

### RESP-D-3 — Container usa `--sf-container-wide` (1536px) quando faz sentido
**Severity:** info.

### RESP-D-4 — Whitespace harmônico em telas largas
**Severity:** info. Padding lateral aumenta proporcional.

---

## §5. Breakpoint transitions — 4 checks

### RESP-BT-1 — Sem layout shift visivel entre 374 e 376 (limite do breakpoint)
**Severity:** error. Transicao suave.

### RESP-BT-2 — Sem layout shift visivel entre 767 e 769
**Severity:** error.

### RESP-BT-3 — Sem layout shift visivel entre 1023 e 1025
**Severity:** error.

### RESP-BT-4 — Resize handler suave (sem reload, sem flash)
**Severity:** warning. CSS-only responsive prefere JS-based.

---

## §6. Media query usage — 3 checks

### RESP-MQ-1 — Media queries usam breakpoint tokens
**Severity:** warning. `@media (min-width: var(--sf-primitive-breakpoint-tablet))` > pixels arbitrarios.

### RESP-MQ-2 — Mobile-first approach
**Severity:** warning. Default styles = mobile. Breakpoints add complexity, nao subtract.

### RESP-MQ-3 — Sem `max-width` queries quando `min-width` faz mesmo trabalho
**Severity:** info. Mobile-first prefere `min-width: 768px` sobre `max-width: 767px`.

---

## §7. Viewport meta — 2 checks

### RESP-VP-1 — `<meta name="viewport" content="width=device-width, initial-scale=1">`
**Severity:** error. Sem isso, mobile renderiza em 980px virtual viewport.

### RESP-VP-2 — Sem `user-scalable=no`
**Severity:** error. NUNCA desabilitar zoom (a11y).

---

## Severity distribution

| Severity | Count | % |
|---|---|---|
| error | 14 | 44% |
| warning | 12 | 38% |
| info | 6 | 19% |
| **Total** | **32** | **100%** |

---

## Output esperado de `*responsive-stress`

```json
{
  "component": "<name>",
  "command": "*responsive-stress",
  "breakpoints_tested": [375, 768, 1024, 1440],
  "orientation_tested": ["portrait", "landscape"],
  "checks_total": 32,
  "checks_passed": 30,
  "checks_failed": 2,
  "score": "B",
  "issues": [
    {
      "check": "RESP-M-1",
      "severity": "error",
      "viewport": 375,
      "message": "Overflow horizontal detected: container .dashboard-grid scrollWidth=420px"
    },
    {
      "check": "RESP-BT-2",
      "severity": "error",
      "transition": "767->769",
      "message": "Layout shift 8px no sidebar entre tablet e laptop breakpoint"
    }
  ],
  "screenshots": [
    "/tmp/screenshots/<component>-375.png",
    "/tmp/screenshots/<component>-768.png",
    "/tmp/screenshots/<component>-1024.png",
    "/tmp/screenshots/<component>-1440.png"
  ]
}
```
