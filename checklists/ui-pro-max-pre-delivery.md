# Pre-Delivery Checklist — Absorbed from ui-ux-pro-max

**Source:** ui-ux-pro-max-skill (nextlevelbuilder)
**Original:** https://github.com/nextlevelbuilder/ui-ux-pro-max-skill
**Imported:** 2026-05-18 (Round 5)
**Translation rules applied:** `governance/external-knowledge-translation-rules.md`
**Consumido por:** validacao final antes de Ops gerar codigo (gate operacional)
**Companion:** `ui-pre-delivery-checklist.md` (3 cherry-picks anteriores) — manter separado por procedencia

---

## 0. Quando rodar

Este e o **checklist final** antes de o `mds-ops` gerar o canonical CSS ou adapter React. Roda APOS:
- `mds-foundations` definiu tokens
- `mds-tokens` validou + buildou JSON -> CSS
- `mds-component` produziu spec.yaml
- `mds-audit *design-check` passou (score >= B)

Se algum item aqui falhar com severity `error`, BLOQUEIA mds-ops.

---

## 0.1 Index dos 27 items

| Categoria | Items | Cross-ref source |
|---|---|---|
| §1 Visual Quality | 5 | SKILL.md L626-630 |
| §2 Interaction | 6 | SKILL.md L632-637 |
| §3 Light/Dark Mode | 5 | SKILL.md L640-644 |
| §4 Layout | 6 | SKILL.md L647-652 |
| §5 Accessibility | 5 | SKILL.md L655-659 |

---

## §1. Visual Quality (5 items)

### PD-V-1 — No emojis as icons
- [ ] **Item:** Sem emojis usados como icones (use SVG)
- **Severity:** error
- **How to check:** grep `[\u{1F300}-\u{1FAFF}]` ou emoji unicode em components ou icon attributes
- **Translation:** Lucide-react via squads/magic-ds/ICONS.md
- **Cross-ref:** UI-ICON-1, UI-STYLE-3

### PD-V-2 — Consistent icon family + style
- [ ] **Item:** Todos os icones de uma familia/estilo unica
- **Severity:** error
- **How to check:** verify all icons import from same library; stroke width consistent
- **Translation:** Lucide-react stroke-regular (1.5px) default no nosso DS
- **Cross-ref:** UI-ICON-5, UI-ICON-6

### PD-V-3 — Brand assets corretos
- [ ] **Item:** Brand assets oficiais com proporcoes corretas e clear space
- **Severity:** warning
- **How to check:** validar contra brand guidelines Shelflix
- **Cross-ref:** UI-ICON-4

### PD-V-4 — Press states sem layout shift
- [ ] **Item:** Visuais de pressed nao deslocam bounds nem causam jitter
- **Severity:** error
- **How to check:** validar que active states usam transform/opacity/elevation, NUNCA width/height
- **Translation:** consume `--sf-motion-hover` + transform; nao animar dimensoes
- **Cross-ref:** UI-ICON-3, UI-MOTION-2

### PD-V-5 — Semantic tokens consistentes
- [ ] **Item:** Sem hardcoded colors ad-hoc por screen — sempre tokens semantic
- **Severity:** error (CRITICAL)
- **How to check:** grep `#[0-9a-f]{3,8}` em componentes; grep `rgba?\(` em componentes
- **Translation:** todo componente consome `var(--sf-*)` semantic. Validacao automatica via Ops anti-leak grep.
- **Cross-ref:** UI-TYPE-8

---

## §2. Interaction (6 items)

### PD-I-1 — Pressed feedback visivel
- [ ] **Item:** Todos elementos tappable com feedback claro (ripple/opacity/elevation)
- **Severity:** error
- **Translation:** usar `:active` state com tokens motion + opacity ou elevation
- **Cross-ref:** UX-COM-1, UX-INT-9

### PD-I-2 — Touch target size minimum
- [ ] **Item:** Touch targets >= 44x44pt iOS / >= 48x48dp Android
- **Severity:** error
- **Translation:** `--sf-primitive-size-control-md` = 40px (no limite, usar md+ em touch contexts). Coarse-pointer guard auto-promove pra 40px+.
- **Cross-ref:** UX-INT-1, UI-ICON-8

### PD-I-3 — Micro-interaction timing 150-300ms
- [ ] **Item:** Timing em 150-300ms com easing native
- **Severity:** error
- **Translation:** `--sf-motion-hover` (120ms) ou `--sf-motion-interaction` (120ms) ou `--sf-motion-transition` (200ms)
- **Cross-ref:** UI-MOTION-1

### PD-I-4 — Disabled states claros
- [ ] **Item:** Disabled visualmente claro + non-interactive
- **Severity:** error
- **Translation:** opacity 0.38-0.5 + cursor not-allowed + atributo `disabled` HTML
- **Cross-ref:** UX-FORM-9

### PD-I-5 — Screen reader focus order matches visual
- [ ] **Item:** Ordem do focus de SR = ordem visual. Labels descritivos.
- **Severity:** error
- **Translation:** sem tabindex arbitrario; DOM order = visual order
- **Cross-ref:** A11Y-2, A11Y-5, UX-COM-3

### PD-I-6 — Gesture regions sem conflito
- [ ] **Item:** Sem nested/conflicting gestures (tap/drag/back-swipe)
- **Severity:** warning
- **Cross-ref:** UX-INT-6, UX-COM-6

---

## §3. Light/Dark Mode (5 items)

### PD-D-1 — Primary text contrast 4.5:1 em AMBOS modos
- [ ] **Item:** Primary text >= 4.5:1 em light AND dark mode
- **Severity:** error (CRITICAL WCAG)
- **How to check:** computa contrast via luminance pra cada par bg/text em ambos modos
- **Translation:** validar tanto `[data-theme="dark"]` quanto `[data-theme="light"]` resolve
- **Cross-ref:** UI-DARK-2, UI-DARK-3, A11Y-1

### PD-D-2 — Secondary text contrast 3:1 em AMBOS modos
- [ ] **Item:** Secondary text >= 3:1 em light AND dark mode
- **Severity:** error
- **Cross-ref:** UI-DARK-3

### PD-D-3 — Dividers/borders visiveis em AMBOS modos
- [ ] **Item:** Separadores e estados de interacao distinguiveis em light E dark
- **Severity:** error
- **Translation:** validar `--sf-border-default` e `--sf-border-subtle` tem luminance suficiente vs canvas em ambos modos
- **Cross-ref:** UI-DARK-4

### PD-D-4 — Modal scrim 40-60% opacity
- [ ] **Item:** Scrim opacity strong enough pra isolar foreground (40-60% black)
- **Severity:** error
- **Translation:** `--sf-bg-overlay` = rgba(0,0,0,0.55) em dark, 0.40 em light. Cobre bem.
- **Cross-ref:** UI-DARK-7

### PD-D-5 — Ambos modos testados (nao inferido)
- [ ] **Item:** Light + dark testados explicitamente. Sem inferir um do outro.
- **Severity:** error
- **How to check:** screenshot diff dark vs light pra cada componente do showroom
- **Translation:** part of `*theme-stress` command do mds-ui
- **Cross-ref:** UI-DARK-1, UI-STYLE-9

---

## §4. Layout (6 items)

### PD-L-1 — Safe areas respeitadas
- [ ] **Item:** Top/bottom safe areas pra headers, tab bars, bottom CTAs
- **Severity:** error
- **Translation:** mobile-aware (futuro); web nao aplica ainda
- **Cross-ref:** UI-SPACE-1, UX-INT-12

### PD-L-2 — Scroll content nao escondido atras de fixed
- [ ] **Item:** Padding inferior/superior pra listas nao colidir com fixed bars
- **Severity:** error
- **Translation:** sticky/fixed elements tem `padding-top`/`padding-bottom` em scroll containers
- **Cross-ref:** UI-LAYOUT-11, UI-SPACE-8

### PD-L-3 — Verified em phone + tablet (portrait + landscape)
- [ ] **Item:** Verified em small phone, large phone, tablet, em portrait E landscape
- **Severity:** error
- **How to check:** screenshots em 375 / 414 / 768 / 1024 / 1440px
- **Translation:** part of `*responsive-stress` do mds-ui
- **Cross-ref:** UI-LAYOUT-3, UI-LAYOUT-14

### PD-L-4 — Horizontal insets adaptam por tamanho
- [ ] **Item:** Gutters/insets horizontais adaptam por device size + orientation
- **Severity:** warning
- **Cross-ref:** UI-SPACE-7

### PD-L-5 — 4/8dp spacing rhythm consistente
- [ ] **Item:** Sistema 4/8dp consistente em padding/gaps/section
- **Severity:** error
- **Translation:** ja garantido por consumo de `--sf-primitive-space-*` (base-4)
- **Cross-ref:** UI-LAYOUT-7, UI-SPACE-4

### PD-L-6 — Long text readable em tablets
- [ ] **Item:** Long-form text readable em larger devices, sem edge-to-edge
- **Severity:** warning
- **Translation:** `max-w-prose` ou `--sf-container-reading` (768px)
- **Cross-ref:** UI-LAYOUT-5, UI-SPACE-5

---

## §5. Accessibility (5 items)

### PD-A-1 — A11y labels em images/icons
- [ ] **Item:** Todos meaningful images/icons tem accessibility labels
- **Severity:** error (CRITICAL WCAG)
- **Cross-ref:** A11Y-3, A11Y-4

### PD-A-2 — Form fields com labels, hints, errors
- [ ] **Item:** Inputs com labels, hint text, error messages claros
- **Severity:** error
- **Cross-ref:** A11Y-6, UX-FORM-1, UX-FORM-8

### PD-A-3 — Cor nao e o unico indicador
- [ ] **Item:** Color nao usado como UNICO indicator
- **Severity:** error
- **Translation:** errors com icon+text+color (nao so color)
- **Cross-ref:** A11Y-9, UI-TYPE-11

### PD-A-4 — Reduced motion + dynamic text suportados
- [ ] **Item:** Layout sobrevive a reduced-motion + Dynamic Type max
- **Severity:** error
- **Translation:** `reduce-motion` token set ja cobre; Dynamic Type via type roles
- **Cross-ref:** A11Y-10, A11Y-11

### PD-A-5 — A11y traits/roles announced
- [ ] **Item:** Accessibility traits/roles/states (selected, disabled, expanded) corretos
- **Severity:** error
- **Translation:** semantic HTML + aria-* attributes quando necessario
- **Cross-ref:** UX-COM-7, A11Y-15

---

## Severity Distribution

| Severity | Count | % |
|---|---|---|
| error | 24 | 89% |
| warning | 3 | 11% |
| info | 0 | 0% |
| **Total** | **27** | **100%** |

Pre-delivery e quase totalmente **error** porque e o gate final — items aqui sao bloqueantes.

---

## Como `mds-ops` usa este checklist

Antes de gerar canonical CSS ou adapter React, Ops invoca:

```
*pre-delivery-check --component=<name>
```

Que roda:
1. Todos os 27 items neste arquivo (severity error bloqueia)
2. UI-PD-1, UI-PD-2, UI-PD-3 do cherry-pick anterior (`ui-pre-delivery-checklist.md`)
3. Cross-validation contra outros checklists relevantes

**Output:** JSON com status pass/fail + lista de issues. Se algum error: aborta geracao + retorna pra `mds-component` (ou `mds-ui`/`mds-ux`) refinar.

---

## Companion: ui-pre-delivery-checklist.md

Cherry-picks anteriores (3 items: UI-PD-1, UI-PD-2, UI-PD-3) ficam em `ui-pre-delivery-checklist.md` separados, por procedencia.

Este arquivo (`ui-pro-max-pre-delivery.md`) e o **bulk import** (27 items).

Pipeline roda OS DOIS arquivos em sequencia. Sem overlap (cherry-picks cobrem zonas diferentes do bulk).

---

## Re-sync notes

Re-sync com upstream da skill (1x/ano):
- Verificar se "Pre-Delivery Checklist" mudou items
- Atualizar items deprecated/novos
- Manter atribuicao linha por linha
