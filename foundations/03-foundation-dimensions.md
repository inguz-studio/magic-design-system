# Foundation Dimensions — Round 3

**Status:** Adotado (2026-05-15)
**Substitui:** trechos de `02-token-architecture-v2.md` § Spacing/Radius/Motion (que agora referenciam este doc).
**Cobertura:** 8 das 13 dimensões Foundation do briefing original. Cores e Typography continuam documentadas em v2.

---

## 0. Mapa rápido

| # | Dimensão | Camadas tocadas | Override permitido | Mode-aware |
|---|---|---|:---:|:---:|
| 1 | Spacing | Primitive + Semantic | Global | ❌ |
| 2 | Border Radius | Primitive + Semantic | ⚠️ Tenant | ❌ |
| 3 | Shadow / Elevation | Primitive + Semantic | Global | ✅ Light/Dark |
| 4 | Motion | Primitive + Semantic | Global | ❌ |
| 5 | Z-index | Primitive + Semantic | Global (🔒) | ❌ |
| 6 | Grid / Container | Primitive + Semantic | Global | ❌ |
| 7 | Density | Semantic override | ⚠️ Produto | ❌ |
| 8 | Iconography | Primitive + Semantic | ⚠️ Tenant (stroke) | ❌ |

Todas as 8 declaradas em `src/styles/tokens.css`. Componente consome via Semantic.

---

## 1. Spacing

**Escala primitiva (base-4 numérica, 17 valores):**
`px (1)`, `0`, `0-5 (2)`, `1 (4)`, `1-5 (6)`, `2 (8)`, `2-5 (10)`, `3 (12)`, `4 (16)`, `5 (20)`, `6 (24)`, `8 (32)`, `10 (40)`, `12 (48)`, `16 (64)`, `20 (80)`, `24 (96)`, `32 (128)`.

**Camada Semantic — tripla Polaris:**
- **inset** (xs/sm/md/lg/xl) — padding interno de containers
- **stack** (xs/sm/md/lg/xl) — espaço vertical entre blocos
- **inline** (xs/sm/md/lg) — espaço horizontal entre elementos inline
- **section** (sm/md/lg) — espaçamento entre seções de página (32/48/64)

**Quando usar qual:**
- Padding do card → `inset-lg`
- Gap entre rows de uma lista → `stack-sm` ou `stack-md`
- Gap entre ícone e texto num botão → `inline-xs`
- Gap entre 2 seções da página → `section-md`

**Override:** ❌ Global (matriz).
**Densidade:** spacing-inset/stack tem override em `[data-density="compact"]` (ver §7).

---

## 2. Border Radius

**Escala primitiva (Fibonacci-ish, 9 valores):**
`none (0)`, `1 (2)`, `2 (4)`, `3 (6)`, `4 (8)`, `5 (12)`, `6 (16)`, `7 (24)`, `full (9999)`.

Justificativa da curva: saltos 2→4→6→8 lineares pra controles pequenos; 8→12→16 para superfícies; 16→24 pra hero — bate com percepção visual.

**Camada Semantic — papéis:**
- `hairline` (2px) — tag micro, badge
- `control-sm` (6px) — controles compactos
- `control` (8px) — button, input, select default
- `surface` (12px) — card, panel
- `surface-lg` (16px) — modal, drawer
- `pill` (9999px) — chip arredondado

**Override por tenant:** ⚠️ permitido — tenant pode redefinir `--semantic-radius-control` mais angular ou mais arredondado. Exemplo:
```css
[data-tenant="inguz"] { --semantic-radius-control: var(--primitive-radius-2); }
```

**Aliases deprecated (1 sprint):** `--primitive-radius-sm/md/lg` continuam apontando pros novos (4/5/6). Remover em Round 3.1.

---

## 3. Shadow / Elevation

**Escala primitiva (dark set padrão):**
`shadow-1` a `shadow-5` (sombras crescentes, blur 2→48px, alpha 0.40→0.60). `shadow-inner-1` pra sunken.

**Set light:** `shadow-light-1..5` com luminância invertida (alpha 0.04→0.16 sobre warm-dark).

**Camada Semantic — papéis:**
- `resting` (none) — cards no canvas, default
- `raised` — hover sutil
- `overlay` — popover, dropdown
- `toast`
- `modal` — dialog
- `focus-ring` — `0 0 0 3px var(--theme-primary-subtle)` (primary)
- `focus-ring-danger` — `0 0 0 3px rgba(204,71,71,0.24)` (danger)
- `inset` — input afundado

**Mode override:** em `[data-theme="light"]`, todos os Semantic shadows passam a apontar pros `--primitive-shadow-light-*`.

**Convenção de composição:** focus-ring **sempre primeira** na lista de `box-shadow`, separada por vírgula:
```css
.btn:focus-visible {
  box-shadow:
    var(--semantic-shadow-focus-ring),
    var(--semantic-shadow-raised);
}
```

**Componentes em uso:** `select.css` (focus-ring + focus-ring-danger). Reservados pra Modal/Drawer/Toast/Popover/Tooltip (backlog).

---

## 4. Motion

**Durations primitivas (5 + instant):**
`instant (0)`, `fast (120)`, `normal (200)`, `medium (320)`, `slow (480)`, `deliberate (700)`.

**Easings primitivas (6):**
- `linear` — animações que mantêm velocidade
- `out` — entradas (decelera no final) — `cubic-bezier(0.16, 1, 0.30, 1)`
- `in` — saídas (acelera no final) — `cubic-bezier(0.70, 0, 0.84, 0)`
- `in-out` — standard equilibrado — `cubic-bezier(0.65, 0, 0.35, 1)`
- `spring` — overshoot suave — `cubic-bezier(0.34, 1.56, 0.64, 1)`
- `emphasize` — Material expressive — `cubic-bezier(0.20, 0, 0.00, 1)`

**Compostos semânticos (9):**
- `instant` — 0ms, sem animação
- `hover` — feedback de hover (fast + out)
- `interaction` — micro-feedback (fast + out)
- `transition` — transitions padrão (normal + in-out)
- `overlay-in` — abertura de overlay (medium + out)
- `overlay-out` — fechamento (normal + in)
- `overlay` (deprecated R3 — prefira in/out) — slow + out
- `page` — page transitions (slow + emphasize)
- `celebrate` — animações expressivas (medium + spring)

**Reduce-motion:** declarado no final de `tokens.css` via `@media (prefers-reduced-motion: reduce)`. Zera **todos** os `--semantic-motion-*` pra `0ms linear`. Componentes consomem só semantic — não declaram `@media` próprio.

---

## 5. Z-index

**Escala primitiva (categórica, 10 níveis + max):**
`deep (-100)`, `base (0)`, `1 (10)`, `2 (100)`, `3 (200)`, `4 (300)`, `5 (400)`, `6 (500)`, `7 (600)`, `8 (700)`, `max (9999)`.

**Camada Semantic — papéis:**
- `canvas` (0) — fluxo normal
- `content` (10) — cards elevados in-flow
- `sticky` / `sidebar` (100)
- `dropdown` / `popover` (200)
- `tooltip` (300)
- `drawer` (400)
- `modal` (500)
- `toast` (600)
- `banner` (700) — notification global

**Override:** 🔒 bloqueado (matriz).

**Componentes em uso:** `app-background.css` consome `--semantic-z-canvas`. Reservados pra Modal/Drawer/Toast/Popover/Tooltip.

---

## 6. Grid / Container

**Containers primitivos:**
`sm (640)`, `md (768)`, `lg (1024)`, `xl (1280)`, `2xl (1536)`, `fluid (100%)`.

**Grid primitivos:**
- `--primitive-grid-columns: 12`
- `gutter-sm/md/lg` = `space-4/6/8` (16/24/32)

**Camada Semantic — papéis:**
- `container-narrow` (640) — forms, single-column
- `container-reading` (768) — texto longo, artigos
- `container-page` (1280) — default app layout
- `container-wide` (1536) — dashboards data-heavy
- `grid-gutter-tight / / -wide` — variações de gap entre colunas

**Override:** ❌ Global.

**Componentes consumidores:** preparado pra `.page-container`, `.dashboard-grid` (backlog).

---

## 7. Density

**Estratégia:** override de Semantic via atributo `[data-density="compact"]` no `<html>`. Default = comfortable (sem atributo).

**Tokens afetados em compact:**
- `--semantic-size-control-sm`: 32 → 28
- `--semantic-size-control-md`: 40 → 34
- `--semantic-size-control-lg`: 48 → 40
- `--semantic-space-inset-md`: 12 → 8
- `--semantic-space-inset-lg`: 16 → 12
- `--semantic-space-stack-md`: 16 → 12
- `--semantic-space-stack-lg`: 24 → 16

**Override permitido:** ⚠️ por produto (matriz). Admin = compact por escolha (opt-in no shell); Customer = comfortable padrão.

**Guard A11y:** `@media (pointer: coarse)` força `control-md` ≥ 40px e `control-sm` ≥ 32px mesmo em compact. Garante touch target mínimo WCAG 2.5.5.

**Como ativar:** o shell do produto declara `data-density="compact"` no `<html>` ou body. Pode ser togglado runtime (showroom faz isso pra demo).

---

## 8. Iconography rules

**Sizes primitivos (6, base SVG):**
`xs (12)`, `sm (16)`, `md (20)`, `lg (24)`, `xl (32)`, `2xl (40)`.

**Stroke widths primitivos (4, Lucide-aware):**
`thin (1)`, `regular (1.5)`, `medium (2)`, `bold (2.5)`.

**Camada Semantic — papéis:**
- `icon-control` (16) — dentro de button/input
- `icon-navigation` (20) — sidebar, menu
- `icon-display` (32) — empty state, hero
- `icon-stroke` (1.5) — default Lucide
- `icon-stroke-emphasis` (2) — destaque
- `icon-alignment` (`-0.125em`) — baseline shift pra alinhar visualmente com texto

**Override por tenant:** ⚠️ stroke pode variar (matriz). Inguz pode ter `--semantic-icon-stroke: var(--primitive-icon-stroke-medium)` se quiser visual mais bold.

**Convenção SVG:**
```html
<svg width="100%" height="100%" viewBox="0 0 24 24" fill="none"
     stroke="currentColor"
     stroke-width="var(--semantic-icon-stroke)"
     stroke-linecap="round" stroke-linejoin="round"
     style="width: var(--semantic-icon-control); height: var(--semantic-icon-control);"
     aria-hidden="true">
  <!-- path Lucide -->
</svg>
```

**Iconografia oficial:** Lucide-react no adapter; SVG inline (paths Lucide) no canonical HTML. Zero emoji em UI (regra Governance).

---

## 9. Referências cruzadas

- **Cores + Typography:** `02-token-architecture-v2.md` §1.1–1.5
- **Matriz governance:** `governance/matrix.md` (linhas Spacing/Radius/Motion/Shadow/Z-index/Grid/Density/Iconography)
- **Theme Contract:** `governance/theme-contract.md` (incluindo bloco `background:`)
- **Component Kinds:** `governance/component-kinds.md`
- **Tokens.css declaração:** `src/styles/tokens.css` (Round 3)
- **Showroom demos:** `squads/magic-ds/showcase/routes/tokens.html` (rota `/tokens`) — auto-render via `showcase.js renderFoundationDemos()`

---

## 10. Próximos passos (Round 3.1 e além)

- Remover aliases `--primitive-radius-sm/md/lg` deprecated.
- Adicionar tokens de **Iconography stroke override** em pelo menos 1 tenant alternativo (proof of concept).
- Implementar **Modal/Drawer/Toast** consumindo `--semantic-shadow-modal/toast/overlay` + `--semantic-z-modal/toast` + `--semantic-motion-overlay-in/out` (do backlog Tier 1).
- Decidir se **5 dimensões Foundation restantes** do briefing original entram em Round 4 (color modes high-contrast, contrast-tokens explícitos, density "spacious", motion macro/page, theming pra dark sub-variants).
