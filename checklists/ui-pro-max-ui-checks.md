# UI Checks — Absorbed from ui-ux-pro-max

**Source:** ui-ux-pro-max-skill (nextlevelbuilder)
**Original:** https://github.com/nextlevelbuilder/ui-ux-pro-max-skill
**Imported:** 2026-05-18 (Round 5)
**Translation rules applied:** `governance/external-knowledge-translation-rules.md`
**Consumido por:** `mds-ui` (futuro)

---

## 0. Index por categoria

| Origem (skill) | Secao neste arquivo | Owner |
|---|---|---|
| Priority 3 — Performance | §1 | mds-ui |
| Priority 4 — Style Selection | §2 | mds-ui |
| Priority 5 — Layout & Responsive | §3 | mds-ui |
| Priority 6 — Typography & Color | §4 | mds-ui |
| Priority 7 — Animation | §5 | mds-ui |
| Priority 10 — Charts & Data | §6 | mds-ui |
| Common Rules: Icons | §7 | mds-ui |
| Common Rules: Light/Dark | §8 | mds-ui |
| Common Rules: Layout & Spacing | §9 | mds-ui |

**Total:** ~110 checks absorvidos com tradução pro nosso DS.

---

## §1. Performance (priority 3)

### UI-PERF-1 — Image optimization
**Severity:** warning. Use WebP/AVIF, responsive `srcset/sizes`, lazy load below-the-fold. Traducao: pode usar `<picture>` ou `next/image` no React; pular se canonical CSS apenas.

### UI-PERF-2 — Image dimension reservada
**Severity:** error. Declarar `width`/`height` ou `aspect-ratio` pra evitar CLS (Core Web Vitals). Traducao: nosso checklist ja exige isso.

### UI-PERF-3 — Font loading (FOIT prevention)
**Severity:** error. `font-display: swap` ou `optional`. Reservar espaco com fallback proximo.
**Cross-ref:** UI-PD-2 em `ui-pre-delivery-checklist.md`

### UI-PERF-4 — Font preload (critico apenas)
**Severity:** info. Preload SO fontes criticas; nao preloadar todas as variantes. Traducao: nosso `index.html` ja faz preconnect, nao precisamos preload no nosso stack.

### UI-PERF-5 — Critical CSS inline
**Severity:** warning. CSS above-the-fold inline ou carregado cedo. Traducao: Vite ja inline o critico em build prod.

### UI-PERF-6 — Lazy loading components
**Severity:** warning. Dynamic import / route-level splitting. Traducao: usar `React.lazy()` em routes do showroom quando aplicavel.

### UI-PERF-7 — Bundle splitting
**Severity:** warning. Split por rota/feature pra reduzir TTI. Traducao: Vite ja faz por padrao com routing.

### UI-PERF-8 — Third-party scripts async/defer
**Severity:** warning. Carregar `<script async>` ou `<script defer>`. Traducao: poucos scripts third-party hoje, mas regra ativa.

### UI-PERF-9 — Reduce reflows
**Severity:** warning. Evitar leituras/escritas DOM frequentes; batch reads then writes.

### UI-PERF-10 — Content jumping (CLS)
**Severity:** error. Reservar espaco pra conteudo assincrono. **Cross-ref:** UI-PERF-2.

### UI-PERF-11 — Lazy load below-the-fold
**Severity:** warning. `loading="lazy"` em images below-fold.

### UI-PERF-12 — Virtualize lists
**Severity:** warning. Listas com 50+ items: usar virtualizacao. Traducao: usar `react-window` ou similar; nosso `DataTable` precisa disso pra produto.

### UI-PERF-13 — Main thread budget
**Severity:** error. < 16ms por frame pra 60fps. Heavy tasks via Web Worker.

### UI-PERF-14 — Progressive loading
**Severity:** warning. Skeleton screens em vez de spinner pra operacoes > 1s.

### UI-PERF-15 — Input latency
**Severity:** error. Resposta visual a tap em < 100ms.

### UI-PERF-16 — Tap feedback speed
**Severity:** error. Visual feedback em < 100ms apos tap. Traducao: usa `var(--sf-motion-hover)` que ja e 120ms (no limite, ajustar pra fast=80ms se necessario).

### UI-PERF-17 — Debounce/throttle
**Severity:** warning. High-frequency events (scroll, resize, input) usam debounce.

---

## §2. Style Selection (priority 4)

### UI-STYLE-1 — Style match to product type
**Severity:** info. Style coerente com tipo de produto. Traducao: nosso `squad-policy.yaml` declara product types (admin, mission, etc.).

### UI-STYLE-2 — Consistency across pages
**Severity:** error. Mesmo style em todas as paginas. Traducao: enforcement via tokens + canonical CSS.

### UI-STYLE-3 — No emoji as structural icons
**Severity:** error. Usar SVG (Lucide). Traducao: ICONS.md ja firma Lucide-react.

### UI-STYLE-4 — Color palette derived from product
**Severity:** info. Skipado: temos brand mono-laranja.

### UI-STYLE-5 — Effects match style
**Severity:** warning. Shadows, blur, radius alinhados ao style escolhido (glass vs flat). Traducao: tokens `--sf-shadow-*` e `--sf-radius-*` ja escalam por papel.

### UI-STYLE-6 — Platform adaptive
**Severity:** warning. Respeitar iOS HIG vs Material. Traducao: web-only por enquanto, regra dormente.

### UI-STYLE-7 — State clarity
**Severity:** error. Hover/pressed/disabled visualmente distintos. Traducao: usa `--sf-action-primary-bg-hover`, `-pressed`, etc.

### UI-STYLE-8 — Elevation consistent
**Severity:** error. Sombras canonicas (`--sf-shadow-resting/raised/overlay/modal/toast`). Sem valores aleatorios.

### UI-STYLE-9 — Dark mode pairing
**Severity:** error. Light + dark desenhados JUNTOS. Traducao: ja temos `semantic-dark` + `semantic-light` no tokens.json.

### UI-STYLE-10 — Icon style consistent
**Severity:** warning. Um icon set/stroke width. Traducao: Lucide stroke-regular (1.5px) default.

### UI-STYLE-11 — System controls preferred
**Severity:** info. Native controls > custom quando branding nao exige.

### UI-STYLE-12 — Blur with purpose
**Severity:** warning. Blur = dismissal/modal, nao decorativo.

### UI-STYLE-13 — Primary action limit
**Severity:** error. 1 CTA primario por tela. Secundarios visualmente subordinados.

---

## §3. Layout & Responsive (priority 5)

### UI-LAYOUT-1 — Viewport meta correct
**Severity:** error. `<meta name="viewport" content="width=device-width, initial-scale=1">`. NUNCA desabilitar zoom.

### UI-LAYOUT-2 — Mobile first
**Severity:** warning. Mobile styles default, depois enhance com breakpoints.

### UI-LAYOUT-3 — Breakpoint consistency
**Severity:** error. Sistema canonico: 375 / 768 / 1024 / 1440. Traducao: usar `--sf-primitive-breakpoint-mobile/tablet/laptop/desktop`.

### UI-LAYOUT-4 — Readable font size mobile
**Severity:** error. Min 16px body text em mobile (evita iOS auto-zoom).

### UI-LAYOUT-5 — Line length control
**Severity:** warning. Mobile 35-60 chars/line, desktop 60-75. Usar `max-w-prose` ou similar.

### UI-LAYOUT-6 — No horizontal scroll
**Severity:** error. Conteudo nao deve exceder viewport width.

### UI-LAYOUT-7 — Spacing scale 4/8pt
**Severity:** error. Sistema 4pt/8dp. Traducao: nossa `--sf-primitive-space-*` ja segue base-4.

### UI-LAYOUT-8 — Touch density
**Severity:** warning. Spacing entre items confortavel pra touch, sem mis-taps.

### UI-LAYOUT-9 — Container width consistent
**Severity:** warning. Max-width consistente em desktop (`max-w-6xl/7xl`). Traducao: `--sf-container-page` (1280px).

### UI-LAYOUT-10 — Z-index management
**Severity:** error. Escala canonica (0/10/20/40/100/1000). Traducao: usar `--sf-z-*` roles.

### UI-LAYOUT-11 — Fixed element offset
**Severity:** warning. Fixed navbar/bottom bar com padding pra conteudo nao colidir.

### UI-LAYOUT-12 — Scroll behavior
**Severity:** warning. Evitar nested scroll regions que interferem com main scroll.

### UI-LAYOUT-13 — Viewport units mobile
**Severity:** warning. `min-h-dvh` > `100vh` em mobile (browser chrome).

### UI-LAYOUT-14 — Orientation support
**Severity:** warning. Layout legivel em landscape mobile.

### UI-LAYOUT-15 — Content priority mobile
**Severity:** warning. Core content primeiro em mobile; secundario foldado.

### UI-LAYOUT-16 — Visual hierarchy via size/spacing/contrast
**Severity:** error. Hierarquia via SIZE+SPACING+CONTRAST, NUNCA so color.

---

## §4. Typography & Color (priority 6)

### UI-TYPE-1 — Line height adequado
**Severity:** warning. 1.5-1.75 pra body. Traducao: `--sf-primitive-leading-normal` = 1.5.

### UI-TYPE-2 — Line length 65-75 chars
**Severity:** warning. Limit pra readability.

### UI-TYPE-3 — Font pairing coerente
**Severity:** info. Heading/body com personalidades complementares. Traducao: Sora pra ambos (decisao do squad).

### UI-TYPE-4 — Font scale modular
**Severity:** error. Escala consistente (12/14/16/18/24/32). Traducao: usar `--sf-primitive-text-*` (2xs/xs/sm/base/md/lg/xl/2xl).

### UI-TYPE-5 — Contrast readability
**Severity:** error. Texto escuro em fundo claro / vice-versa. Slate-900 on white = ok.

### UI-TYPE-6 — Type system platform
**Severity:** info. iOS Dynamic Type / MD type roles. Traducao: usar nossos 9 type roles (`--sf-type-h1` ate `--sf-type-action`).

### UI-TYPE-7 — Weight hierarchy
**Severity:** error. Bold headings (600-700), Regular body (400), Medium labels (500). Traducao: ja embutido nos nossos type roles.

### UI-TYPE-8 — Color semantic tokens
**Severity:** error. SEM raw hex em componente. Tokens semantic primary/secondary/error/surface/on-surface. Traducao: enforcement total via grep no canonical CSS.

### UI-TYPE-9 — Dark mode color desaturated
**Severity:** error. Dark mode usa variantes dessaturadas/lighter, NAO invertidas. Testar contraste separado.

### UI-TYPE-10 — Accessible color pairs
**Severity:** error. FG/BG >= 4.5:1 (AA) ou 7:1 (AAA).

### UI-TYPE-11 — Color not decorative only
**Severity:** error. Erro/success precisam de icone+texto, nao so cor.

### UI-TYPE-12 — Truncation strategy
**Severity:** warning. Preferir wrapping; truncar com ellipsis + tooltip/expand.

### UI-TYPE-13 — Letter spacing default
**Severity:** info. Tracking padrao por platform; nao apertar body. Traducao: tracking embutido nos type roles.

### UI-TYPE-14 — Tabular numbers em data
**Severity:** warning. Numeros monospaced em tables/prices/timers (previne layout shift).

### UI-TYPE-15 — Whitespace balance
**Severity:** warning. Whitespace agrupando related items, separando secoes.

---

## §5. Animation (priority 7)

### UI-MOTION-1 — Duration 150-300ms micro
**Severity:** error. Micro-interactions 150-300ms; complexas ≤400ms; evitar >500ms. Traducao: `--sf-primitive-duration-fast/normal/medium` = 120/200/320ms.

### UI-MOTION-2 — Transform + opacity only
**Severity:** error. Animar so `transform` e `opacity`. NUNCA width/height/top/left (causam reflow).

### UI-MOTION-3 — Loading state > 300ms
**Severity:** warning. Skeleton ou progress quando loading > 300ms.

### UI-MOTION-4 — Excessive motion limit
**Severity:** warning. 1-2 elementos animados por view max.

### UI-MOTION-5 — Easing curve
**Severity:** warning. Ease-out entering, ease-in exiting. NUNCA linear. Traducao: `--sf-primitive-ease-out/in/in-out`.

### UI-MOTION-6 — Motion conveys meaning
**Severity:** error. Toda animacao expressa causa-efeito, nao decorativa.

### UI-MOTION-7 — State transition smooth
**Severity:** warning. Hover/active/expanded animam, nao "snap".

### UI-MOTION-8 — Spatial continuity
**Severity:** warning. Page transitions mantem continuidade (shared element, slide direcional).

### UI-MOTION-9 — Parallax subtle + reduced-motion
**Severity:** error. Parallax respeita prefers-reduced-motion. NUNCA disorientacao.

### UI-MOTION-10 — Spring physics preferida
**Severity:** info. Spring/physics curves > cubic-bezier puros. Traducao: `--sf-primitive-ease-spring`.

### UI-MOTION-11 — Exit faster than enter
**Severity:** warning. Exit ~60-70% da duracao do enter.

### UI-MOTION-12 — Stagger sequence em lista
**Severity:** info. Listas/grids: stagger 30-50ms por item. Evitar all-at-once.

### UI-MOTION-13 — Shared element transitions
**Severity:** info. Hero transitions entre screens.

### UI-MOTION-14 — Animation interruptible
**Severity:** error. User tap/gesture CANCELA animacao em curso.

### UI-MOTION-15 — No blocking animation
**Severity:** error. UI sempre interativa durante animacao.

### UI-MOTION-16 — Crossfade content replace
**Severity:** info. Crossfade quando conteudo substitui dentro do mesmo container.

### UI-MOTION-17 — Scale feedback on press
**Severity:** info. Scale 0.95-1.05 em press de tappable; restaura on release.

### UI-MOTION-18 — Gesture feedback realtime
**Severity:** warning. Drag/swipe/pinch com resposta visual seguindo dedo.

### UI-MOTION-19 — Hierarchy via motion direction
**Severity:** info. Translate/scale direction expressa hierarquia: enter from below = deeper, exit upward = back.

### UI-MOTION-20 — Motion consistency
**Severity:** error. Durations + easings globais. Mesma rhythm em todas animacoes. Traducao: tokens forcam isso.

### UI-MOTION-21 — Opacity threshold
**Severity:** info. Fading nao linger abaixo opacity 0.2.

### UI-MOTION-22 — Modal motion from trigger
**Severity:** warning. Modais animam do trigger source (scale+fade ou slide-in).

### UI-MOTION-23 — Navigation direction logic
**Severity:** warning. Forward = left/up; backward = right/down.

### UI-MOTION-24 — Layout shift avoid
**Severity:** error. Animacoes nao causam reflow/CLS. Use transform.

---

## §6. Charts & Data (priority 10)

### UI-CHART-1 — Chart type match data type
**Severity:** error. Trend → line, comparison → bar, proportion → pie/donut.

### UI-CHART-2 — Color guidance acessivel
**Severity:** error. Paletas acessiveis. Evitar red/green only (colorblind).

### UI-CHART-3 — Data table alternative
**Severity:** error. Tabela alternativa pra a11y (charts nao sao screen-reader friendly).

### UI-CHART-4 — Pattern + texture supplement
**Severity:** error. Cor + padroes/texturas/shapes pra distincao sem cor.

### UI-CHART-5 — Legend visible
**Severity:** error. Legenda sempre visivel, proxima ao chart.

### UI-CHART-6 — Tooltip on interact
**Severity:** error. Tooltips em hover (web) ou tap (mobile) com valores exatos.

### UI-CHART-7 — Axis labels com unidades
**Severity:** warning. Eixos com unidades + escala legivel. Evitar labels truncados.

### UI-CHART-8 — Responsive chart
**Severity:** error. Reflow ou simplificacao em mobile (horizontal bar > vertical, fewer ticks).

### UI-CHART-9 — Empty data state
**Severity:** error. Empty state ("No data yet" + guidance), NUNCA blank chart.

### UI-CHART-10 — Loading chart skeleton
**Severity:** warning. Skeleton durante load, nao axis frame vazio.

### UI-CHART-11 — Animation respects reduced-motion
**Severity:** error. Chart entrance respeita prefers-reduced-motion.

### UI-CHART-12 — Large dataset aggregate
**Severity:** error. 1000+ data points: agregar/sample; drill-down pra detalhe.

### UI-CHART-13 — Locale number formatting
**Severity:** warning. Locale-aware (numeros, datas, moedas).

### UI-CHART-14 — Touch target chart
**Severity:** error. Interactive points >= 44pt tap area ou expand on touch.

### UI-CHART-15 — No pie overuse
**Severity:** warning. Pie/donut > 5 categorias: trocar pra bar.

### UI-CHART-16 — Contrast data lines
**Severity:** error. Lines/bars vs bg >= 3:1. Labels text >= 4.5:1.

### UI-CHART-17 — Legend interactive
**Severity:** info. Legendas clicaveis pra toggle series.

### UI-CHART-18 — Direct labeling small datasets
**Severity:** info. Pequenos datasets: labels diretos no chart (reduz eye travel).

### UI-CHART-19 — Tooltip keyboard reachable
**Severity:** error. Tooltip nao depende so de hover.

### UI-CHART-20 — Sortable table aria-sort
**Severity:** error. Tabelas sortable com `aria-sort`.

### UI-CHART-21 — Axis readability
**Severity:** warning. Ticks com spacing readable; auto-skip em mobile.

### UI-CHART-22 — Data density limit
**Severity:** warning. Limitar informacao por chart. Split se necessario.

### UI-CHART-23 — Trend emphasis over decoration
**Severity:** warning. Enfase nos dados, nao em gradientes/shadows.

### UI-CHART-24 — Gridline subtle
**Severity:** info. Grid lines low-contrast (gray-200 ou equivalente).

### UI-CHART-25 — Focusable elements
**Severity:** error. Interactive chart elements keyboard-navigable.

### UI-CHART-26 — Screen reader summary
**Severity:** error. Text summary ou aria-label do insight principal.

### UI-CHART-27 — Error state chart
**Severity:** error. Data load failure: error msg + retry. NUNCA broken/empty chart.

### UI-CHART-28 — Export option
**Severity:** info. CSV/image export pra produtos data-heavy.

### UI-CHART-29 — Drill-down breadcrumb
**Severity:** warning. Drill-down com back-path + breadcrumb.

### UI-CHART-30 — Time scale clarity
**Severity:** warning. Time series labela granularidade (day/week/month) + permite switching.

---

## §7. Icons & Visual Elements

### UI-ICON-1 — No emoji as structural icons
**Severity:** error. Vector icons (Lucide), nao emoji.

### UI-ICON-2 — Vector-only assets
**Severity:** error. SVG ou platform vector. Nao raster PNG.

### UI-ICON-3 — Stable interaction states
**Severity:** error. Press states usa color/opacity/elevation, NUNCA muda bounds (sem layout shift).

### UI-ICON-4 — Correct brand logos
**Severity:** warning. Brand assets oficiais, sem recolorir.

### UI-ICON-5 — Consistent icon sizing
**Severity:** error. Sizes via tokens (`--sf-icon-control/navigation/display`). Sem 20pt/24pt/28pt random.

### UI-ICON-6 — Stroke consistency
**Severity:** warning. 1.5px ou 2px consistente por layer. Traducao: `--sf-primitive-icon-stroke-regular` = 1.5px.

### UI-ICON-7 — Filled vs outline discipline
**Severity:** warning. 1 estilo por nivel de hierarquia. Sem mix filled/outline no mesmo nivel.

### UI-ICON-8 — Touch target min
**Severity:** error. 44x44pt interactive area (use `hitSlop` se icon menor).

### UI-ICON-9 — Icon alignment baseline
**Severity:** warning. Aligned to text baseline. Padding consistente.

### UI-ICON-10 — Icon contrast WCAG
**Severity:** error. 4.5:1 pra small; 3:1 pra larger UI glyphs.

---

## §8. Light/Dark Mode Contrast

### UI-DARK-1 — Surface readability light
**Severity:** error. Cards/surfaces separados do bg com opacity/elevation suficiente.

### UI-DARK-2 — Text contrast light
**Severity:** error. Body text >= 4.5:1 em light. Sem gray-on-gray.

### UI-DARK-3 — Text contrast dark
**Severity:** error. Primary text >= 4.5:1; secondary >= 3:1 em dark surfaces.

### UI-DARK-4 — Border visibility both themes
**Severity:** error. Separadores visiveis em LIGHT E DARK.

### UI-DARK-5 — State contrast parity
**Severity:** error. Pressed/focused/disabled distinguiveis em ambos temas.

### UI-DARK-6 — Token-driven theming
**Severity:** error. Semantic tokens mapped per theme. NUNCA hex hardcoded.

### UI-DARK-7 — Scrim modal legibility
**Severity:** error. Modal scrim 40-60% black pra isolar foreground.

---

## §9. Layout & Spacing (App)

### UI-SPACE-1 — Safe-area compliance
**Severity:** error. Respeitar top/bottom safe areas (notch, gesture bar).

### UI-SPACE-2 — System bar clearance
**Severity:** warning. Spacing pra status/nav bars + gesture home indicator.

### UI-SPACE-3 — Consistent content width per device
**Severity:** warning. Largura previsivel por classe (phone/tablet). Sem widths arbitrarios.

### UI-SPACE-4 — 8dp spacing rhythm
**Severity:** error. Sistema 4/8dp consistente em padding/gaps/section spacing. Traducao: `--sf-primitive-space-*` base-4.

### UI-SPACE-5 — Readable text measure large devices
**Severity:** warning. Long-form readable em tablets. Sem edge-to-edge paragraphs.

### UI-SPACE-6 — Section spacing hierarchy
**Severity:** error. Tiers verticais (16/24/32/48) por hierarquia. Traducao: `--sf-space-section-sm/md/lg`.

### UI-SPACE-7 — Adaptive gutters breakpoint
**Severity:** warning. Insets horizontais maiores em larger widths/landscape.

### UI-SPACE-8 — Scroll vs fixed coexistence
**Severity:** error. Padding inferior/superior pra listas nao ficarem atras de fixed bars.

---

## Severity Distribution

| Severity | Count | % |
|---|---|---|
| error | ~50 | 45% |
| warning | ~40 | 36% |
| info | ~20 | 18% |
| **Total** | **~110** | **100%** |

---

## Como `mds-ui` usa

Quando criado, agente referencia esse arquivo em `dependencies.checklists`:

```yaml
agents/mds-ui.md:
  dependencies:
    checklists:
      - ui-pro-max-ui-checks.md          # este arquivo
      - ui-pre-delivery-checklist.md     # cherry-picks anteriores
      - multi-theme-checklist.md          # novo (criar quando agente nascer)
      - responsive-checklist.md           # novo
```

Comandos do `mds-ui` filtram subset:
- `*audit-ui` — roda TODOS os checks (§1-§9)
- `*theme-stress` — apenas §8 (Light/Dark)
- `*responsive-stress` — apenas §3 (Layout)
- `*motion-audit` — apenas §5 (Animation)
- `*contrast-check` — subset de §4 + §8 (contrast pairs)
