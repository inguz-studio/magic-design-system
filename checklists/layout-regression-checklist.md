# Layout Regression Checklist

**Status:** Adotado (Round 5)
**Consumido por:** `mds-ui *layout-regression`
**Cobertura:** overflow, clipping, z-index conflicts, content jumping (CLS), positioning issues

---

## 0. Quando rodar

`mds-ui *layout-regression --target=<X>` invoca este checklist quando:
- Componente novo criado
- Layout/position/z-index alterado
- Async content (images, dynamic data) introduzido
- Pre-delivery (companion do `*audit-ui`)

---

## §1. Overflow detection — 6 checks

### LR-O-1 — Sem overflow horizontal em viewport
**Severity:** error. `document.documentElement.scrollWidth <= clientWidth` em todos breakpoints.

### LR-O-2 — Sem texto cortado sem `line-clamp` explicito
**Severity:** warning. `overflow: hidden` em texto requer `line-clamp` ou `text-overflow: ellipsis` declarados.

### LR-O-3 — Sem element ultrapassando viewport (off-screen)
**Severity:** error. Bounding box dos elements esta dentro do viewport.

### LR-O-4 — Container max-width respeitado
**Severity:** warning. Conteudo nao excede max-width do container parent.

### LR-O-5 — Image overflow tratado (`max-width: 100%`)
**Severity:** error. Images sempre tem `max-width: 100%; height: auto`.

### LR-O-6 — Table responsivo (wrapper scroll-x)
**Severity:** warning. Wide tables tem `overflow-x: auto` wrapper.

---

## §2. Clipping detection — 4 checks

### LR-C-1 — Sem `overflow: hidden` cortando conteudo importante
**Severity:** error. Validar que overflow:hidden e intencional.

### LR-C-2 — Sem text clipping em pixel-precise positioning
**Severity:** warning. Texto nao desaparece em sub-pixel rendering.

### LR-C-3 — Sem corte de ascendents/descendents da fonte
**Severity:** info. `line-height` adequado pra acomodar caracteres altos/baixos.

### LR-C-4 — Sem mascaramento de focus ring em scroll containers
**Severity:** error. `overflow: hidden` pai nao corta focus ring (use `overflow: visible` no item focado).

---

## §3. Z-index management — 5 checks

### LR-Z-1 — Sem `z-index` hardcoded (numerico solto)
**Severity:** error. Tudo via `var(--sf-z-*)` roles.

### LR-Z-2 — Sem `z-index: 9999` ou similares arbitrarios
**Severity:** error. Escala canonica (canvas/content/sticky/dropdown/tooltip/drawer/modal/toast/banner).

### LR-Z-3 — Stacking context consistency
**Severity:** warning. Parent com z-index estabelece stacking context — children nao "vazam" pra cima.

### LR-Z-4 — Overlays nao conflitam (modal acima de dropdown, etc.)
**Severity:** error. Hierarquia: canvas < content < sticky < dropdown < popover < tooltip < drawer < modal < toast < banner.

### LR-Z-5 — Fixed elements respeitam z-index
**Severity:** warning. Fixed nav, fixed CTA tem z-index declarado.

---

## §4. Content jumping / CLS (Core Web Vitals) — 5 checks

### LR-CJ-1 — Images tem width/height declarados (ou aspect-ratio)
**Severity:** error. Previne CLS quando image carrega.

### LR-CJ-2 — Async content tem space reservado (skeleton/placeholder)
**Severity:** error. Skeleton mantem layout antes do conteudo chegar.

### LR-CJ-3 — Fonts tem font-display: swap + fallback similar
**Severity:** warning. Fallback metric-compatible reduz salto de layout.

### LR-CJ-4 — Sem layout shift em hover/focus/active
**Severity:** error. Animacoes usam transform/opacity, NUNCA muda width/height/margin/padding.

### LR-CJ-5 — CLS (Cumulative Layout Shift) < 0.1
**Severity:** info. Medicao via Lighthouse/Web Vitals.

---

## §5. Positioning issues — 5 checks

### LR-P-1 — `position: absolute` tem ancestor `position: relative` (ou container)
**Severity:** warning. Sem isso, escapa pra root + bugs em diferentes contextos.

### LR-P-2 — `position: fixed` respeita safe areas
**Severity:** error. Mobile com notch nao colide com fixed nav.

### LR-P-3 — `position: sticky` tem background opaco
**Severity:** error. Sticky transparente vira ilegivel ao scrolling.

### LR-P-4 — Nested scroll regions evitados (ou intencionais)
**Severity:** warning. Multiplos scrolls confundem usuario.

### LR-P-5 — Viewport units (`vh`/`vw`) testados em mobile
**Severity:** warning. `100vh` em mobile inclui browser chrome — prefere `dvh`.

---

## §6. Empty container handling — 3 checks

### LR-E-1 — Empty container tem altura minima
**Severity:** warning. Empty state nao colapsa sem padding/min-height.

### LR-E-2 — Empty list mostra empty state (not blank space)
**Severity:** error. UX espera mensagem + acao quando sem dados.

### LR-E-3 — Loading skeleton tem mesma altura do conteudo final
**Severity:** error. Previne layout shift ao trocar skeleton → conteudo.

---

## Severity distribution

| Severity | Count | % |
|---|---|---|
| error | 14 | 50% |
| warning | 11 | 39% |
| info | 3 | 11% |
| **Total** | **28** | **100%** |

---

## Output esperado de `*layout-regression`

```json
{
  "component": "<name>",
  "command": "*layout-regression",
  "checks_total": 28,
  "checks_passed": 25,
  "checks_failed": 3,
  "score": "B",
  "issues": [
    {
      "check": "LR-O-1",
      "severity": "error",
      "viewport": 375,
      "message": "Overflow horizontal: .dashboard scrollWidth=420 > clientWidth=375"
    },
    {
      "check": "LR-Z-2",
      "severity": "error",
      "selector": ".tooltip",
      "message": "z-index: 9999 hardcoded — usar var(--sf-z-tooltip)"
    },
    {
      "check": "LR-CJ-4",
      "severity": "error",
      "selector": ".btn:hover",
      "message": "Layout shift on hover: padding muda de 8px pra 10px (use scale/opacity)"
    }
  ]
}
```

---

## Cross-references

- LR-O-1, LR-O-3 ↔ RESP-M-1 (responsive checklist)
- LR-Z-1, LR-Z-2 ↔ UI-LAYOUT-10 (ui-pro-max-ui-checks)
- LR-CJ-1 ↔ UI-PERF-2 (image dimension)
- LR-CJ-3 ↔ UI-PERF-3 (font loading) ↔ UI-PD-2 (ui-pre-delivery)
- LR-CJ-4 ↔ UI-MOTION-2 (transform/opacity only)
