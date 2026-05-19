# Multi-Theme Checklist

**Status:** Adotado (Round 5)
**Consumido por:** `mds-ui *theme-stress`
**Cobertura:** dark mode + light mode + product overrides (admin/mission/original) + density (comfortable/compact)

---

## 0. Quando rodar

`mds-ui *theme-stress --component=<X>` invoca este checklist quando:
- Componente novo criado
- Token semantic alterado (dark ou light)
- Product override modificado
- Pre-delivery (companion do `*audit-ui`)

---

## §1. Dark mode validation (10 checks)

### MT-D-1 — Renderiza sem erro com `data-theme="dark"`
**Severity:** error. Componente nao quebra (erro JS, CSS unresolved).

### MT-D-2 — Texto primary tem contraste >= 4.5:1 em dark
**Severity:** error. WCAG AA. Calcula via getComputedStyle de `--sf-text-primary` vs `--sf-bg-canvas`.

### MT-D-3 — Texto secondary tem contraste >= 3:1 em dark
**Severity:** error. WCAG AA texto large.

### MT-D-4 — Border default visivel em dark
**Severity:** warning. `--sf-border-default` (neutral-600) sobre `--sf-bg-canvas` (neutral-800) tem luminance delta suficiente.

### MT-D-5 — Status colors (success/warning/danger/info) contrastam em dark
**Severity:** error. Cada par bg/text de status tem >= 4.5:1.

### MT-D-6 — Action primary contrasta em dark
**Severity:** error. `--sf-action-primary-bg` (orange-700) vs `--sf-action-primary-text` (white) >= 4.5:1.

### MT-D-7 — Shadow visivel em dark
**Severity:** warning. Shadow roles (resting/raised/overlay) sao dark-aware. Validar que sombras nao "desaparecem" em fundo escuro.

### MT-D-8 — Focus ring visivel em dark
**Severity:** error. `--sf-shadow-focus-ring` (3px outline `--sf-action-primary-bg-subtle`) deve aparecer sobre todos os surfaces.

### MT-D-9 — Hover state distinto em dark
**Severity:** warning. `--sf-action-primary-bg-hover` visualmente diferente de `--sf-action-primary-bg`. Delta luminance >= 0.05.

### MT-D-10 — Disabled state distinto em dark
**Severity:** warning. Opacity 0.38-0.5 + visualmente "morto".

---

## §2. Light mode validation (10 checks)

### MT-L-1 — Renderiza sem erro com `data-theme="light"`
**Severity:** error.

### MT-L-2 — Texto primary tem contraste >= 4.5:1 em light
**Severity:** error. `--sf-text-primary` (neutral-800) vs `--sf-bg-canvas` (neutral-100).

### MT-L-3 — Texto secondary tem contraste >= 3:1 em light
**Severity:** error.

### MT-L-4 — Border default visivel em light
**Severity:** warning. `--sf-border-default` (neutral-300) sobre `--sf-bg-canvas` (neutral-100). Delta luminance suficiente.

### MT-L-5 — Status colors contrastam em light
**Severity:** error. Texto de status (status-success-text = green-600 em light) contrasta com bg-subtle.

### MT-L-6 — Action primary contrasta em light
**Severity:** error. Orange-700 sobre white = boa contraste.

### MT-L-7 — Shadow visivel em light
**Severity:** warning. Shadow-light-* sao mais sutis (alpha menor) — validar que ainda dao elevation.

### MT-L-8 — Focus ring visivel em light
**Severity:** error. Mesmo selector, mas precisa testar visualmente em fundo claro.

### MT-L-9 — Hover state distinto em light
**Severity:** warning.

### MT-L-10 — Disabled state distinto em light
**Severity:** warning.

---

## §3. Side-by-side validation (5 checks)

### MT-SBS-1 — Layout NAO muda entre dark e light
**Severity:** error. Toggle dark/light NAO causa layout shift. Mesmo bounding box dos elements.

### MT-SBS-2 — Spacing rhythm preservado em ambos
**Severity:** error. Padding/margin nao mudam por modo.

### MT-SBS-3 — Typography hierarchy preservada em ambos
**Severity:** error. h1 ainda parece h1 em light. Body ainda parece body.

### MT-SBS-4 — Icon visibility em ambos
**Severity:** warning. Icons nao "desaparecem" em light (cor muito clara) ou dark (cor muito escura).

### MT-SBS-5 — State transitions iguais
**Severity:** warning. Hover/active/disabled tem mesma logica visual em ambos modos.

---

## §4. Product override validation (4 checks)

### MT-P-1 — Componente renderiza em `data-product="shelflix-admin"`
**Severity:** error. Default. Sempre testa.

### MT-P-2 — Componente renderiza em `data-product="shelflix-mission"` (flat/dark)
**Severity:** error. Mission tem overrides especificos (bg-canvas #050505, accent orange-500). Componente respeita.

### MT-P-3 — Componente renderiza em `data-product="shelflix-original"`
**Severity:** warning. Placeholder hoje, mas ja validar que data-attr nao quebra.

### MT-P-4 — Product override aplica subset, nao componente inteiro
**Severity:** info. Validar que componente herda semantic-dark + product-mission overrides corretamente.

---

## §5. Density adaptation (3 checks)

### MT-DEN-1 — Componente funciona em comfortable (default)
**Severity:** error.

### MT-DEN-2 — Componente funciona em `data-density="compact"`
**Severity:** error. Sizes/spacings escalam. Layout nao quebra.

### MT-DEN-3 — Touch coarse pointer guard em compact
**Severity:** error. `@media (pointer: coarse)` forca control-md >= 40px mesmo em compact.

---

## Severity distribution

| Severity | Count | % |
|---|---|---|
| error | 19 | 59% |
| warning | 11 | 34% |
| info | 1 | 3% |
| **Total** | **32** | **100%** |

---

## Output esperado de `*theme-stress`

```json
{
  "component": "<name>",
  "command": "*theme-stress",
  "modes_tested": ["dark", "light"],
  "products_tested": ["shelflix-admin", "shelflix-mission"],
  "densities_tested": ["comfortable", "compact"],
  "checks_total": 32,
  "checks_passed": 30,
  "checks_failed": 2,
  "score": "B",
  "issues": [
    {
      "check": "MT-L-4",
      "severity": "warning",
      "message": "Border default em light tem luminance delta 0.04 (recomendado >= 0.08)"
    },
    {
      "check": "MT-SBS-1",
      "severity": "error",
      "message": "Layout muda entre dark e light: padding right diferente em badge"
    }
  ]
}
```
