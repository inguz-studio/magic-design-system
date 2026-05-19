# UX Checks — Absorbed from ui-ux-pro-max

**Source:** ui-ux-pro-max-skill (nextlevelbuilder)
**Original:** https://github.com/nextlevelbuilder/ui-ux-pro-max-skill
**Imported:** 2026-05-18 (Round 5)
**Translation rules applied:** `governance/external-knowledge-translation-rules.md`
**Consumido por:** `mds-ux` (futuro)

---

## 0. Index por categoria

| Origem (skill) | Secao neste arquivo |
|---|---|
| Priority 2 — Touch & Interaction (parte UX) | §1 |
| Priority 8 — Forms & Feedback | §2 |
| Priority 9 — Navigation Patterns | §3 |
| Common Rules: Interaction (App) | §4 |

**Total:** ~73 checks UX absorvidos.

---

## §1. Touch & Interaction (UX side da priority 2)

A parte VISUAL desta categoria (cursor-pointer, hover state visual) esta em `ui-pro-max-ui-checks.md`. Aqui ficam os checks de FLUXO/EXPECTATIVA.

### UX-INT-1 — Touch target reasoning
**Severity:** error. Min 44x44pt/48x48dp e EXPECTATIVA de usuario, nao so a11y. Targets menores frustram em qualquer contexto.

### UX-INT-2 — Touch spacing reasoning
**Severity:** warning. 8px+ gap evita mis-taps. Quando user mistapa, perde confianca.

### UX-INT-3 — Hover-only fail
**Severity:** error. Acoes primarias NAO podem depender so de hover. Mobile users perdem a acao.

### UX-INT-4 — Loading button feedback
**Severity:** error. Disable + spinner durante async. Sem isso, double-submit destroi confianca.

### UX-INT-5 — Error feedback proximidade
**Severity:** error. Erros sempre PERTO do problema. Generic top-of-form viola Nielsen #9 (help recognize/diagnose).

### UX-INT-6 — Gesture conflicts
**Severity:** warning. Avoid horizontal swipe em conteudo principal (conflita com nav back-swipe).

### UX-INT-7 — Standard gestures preservados
**Severity:** error. Nao redefinir swipe-back, pinch-zoom (Apple HIG).

### UX-INT-8 — System gestures nao bloqueados
**Severity:** error. Nao bloquear Control Center, back swipe, etc.

### UX-INT-9 — Press feedback < 100ms
**Severity:** error. Visual feedback em < 100ms. Atraso quebra sensacao de responsividade.

### UX-INT-10 — Haptic confirma acoes importantes
**Severity:** info. Vibration pra confirmacao. Sem overuse (mata bateria + dessensibiliza).

### UX-INT-11 — Gesture sempre tem alternativa visivel
**Severity:** error. Nao depender SO de gesture pra acao critica. Sempre botao visivel tambem.

### UX-INT-12 — Safe-area awareness
**Severity:** error. Touch targets longe de notch/Dynamic Island/gesture bar.

### UX-INT-13 — No precision required
**Severity:** warning. Sem requerer tap pixel-perfect em icones pequenos ou thin edges.

### UX-INT-14 — Swipe clarity affordance
**Severity:** error. Swipe actions mostram affordance (chevron, label, tutorial). Sem isso = descoberta zero.

### UX-INT-15 — Drag threshold
**Severity:** warning. Movement threshold antes de iniciar drag pra evitar drags acidentais.

---

## §2. Forms & Feedback (priority 8)

### UX-FORM-1 — Input labels visiveis
**Severity:** error. Label SEMPRE acima/ao lado do input. Placeholder-only = invisivel quando user comeca digitar.

### UX-FORM-2 — Error placement near field
**Severity:** error. Erro embaixo do campo problemático. Sem error summary top-of-form como UNICO mecanismo.

### UX-FORM-3 — Submit feedback (loading/success/error)
**Severity:** error. Mostrar loading state, depois success ou error. Silent submit = quebrado.

### UX-FORM-4 — Required indicators clear
**Severity:** error. Asterisco ou "(required)" text. Sem ambiguidade.

### UX-FORM-5 — Empty states helpful
**Severity:** error. Sem conteudo: mensagem + acao ("No items yet. Create one!"). NUNCA blank screen.

### UX-FORM-6 — Toast auto-dismiss 3-5s
**Severity:** warning. Toasts somem em 3-5s. Persistentes viram ruido.

### UX-FORM-7 — Confirmation dialog destrutivo
**Severity:** error. Delete/irreversivel: dialog antes. Sem clique direto pra acao destrutiva.

### UX-FORM-8 — Input helper text persistente
**Severity:** warning. Helper text embaixo do input pra inputs complexos. Nao confundir com placeholder.

### UX-FORM-9 — Disabled states clarity
**Severity:** error. Opacity 0.38-0.5 + cursor change + atributo semantico `disabled`.

### UX-FORM-10 — Progressive disclosure
**Severity:** error. Revelar opcoes progressivamente. Nao bombardear user upfront.

### UX-FORM-11 — Inline validation on blur
**Severity:** warning. Validar on blur (nao on keystroke). Erro apos user terminar input.

### UX-FORM-12 — Input type keyboard match
**Severity:** error. `type="email"`, `type="tel"`, `type="number"`. Trigger correto do mobile keyboard.

### UX-FORM-13 — Password show/hide toggle
**Severity:** warning. Toggle visibility. Reduz erros de digitacao.

### UX-FORM-14 — Autofill / autocomplete support
**Severity:** error. `autocomplete="..."` ou `textContentType` pra system autofill.

### UX-FORM-15 — Undo support em destrutivo
**Severity:** error. "Undo delete" toast. User precisa de safety net.

### UX-FORM-16 — Success feedback explicito
**Severity:** error. Checkmark/toast/color flash confirmando acao completed.

### UX-FORM-17 — Error recovery path
**Severity:** error. Error msg INCLUI proxima acao (retry, edit, help link). Sem isso = dead end.

### UX-FORM-18 — Multi-step progress indicator
**Severity:** error. Step indicator ou progress bar em multi-step flows. Back navigation permitida.

### UX-FORM-19 — Form autosave drafts
**Severity:** warning. Forms longos: auto-save pra prevenir data loss.

### UX-FORM-20 — Sheet dismiss confirm unsaved
**Severity:** error. Confirm antes de dismissar sheet/modal com unsaved changes.

### UX-FORM-21 — Error clarity (cause + fix)
**Severity:** error. Error msg explica CAUSA + COMO RESOLVER. Nao apenas "Invalid input".

### UX-FORM-22 — Field grouping logico
**Severity:** warning. Fieldset/legend ou agrupamento visual pra fields relacionados.

### UX-FORM-23 — Read-only != disabled
**Severity:** error. Read-only state visualmente E semanticamente diferente de disabled.

### UX-FORM-24 — Focus after submit error
**Severity:** error. Auto-focus no primeiro invalid field. WCAG compliance.

### UX-FORM-25 — Error summary com anchors
**Severity:** warning. Multiplos erros: summary top com anchor links pra cada field.

### UX-FORM-26 — Touch-friendly input height
**Severity:** error. Mobile input height >= 44px.

### UX-FORM-27 — Destructive emphasis semantica
**Severity:** error. Destructive actions com semantic danger color (red) + visualmente separadas das primary.

### UX-FORM-28 — Toast accessibility
**Severity:** error. Toasts NAO roubam focus. Use `aria-live="polite"` pra screen reader.

### UX-FORM-29 — Aria-live errors
**Severity:** error. Form errors usam `aria-live` region ou `role="alert"`.

### UX-FORM-30 — Contrast feedback colors
**Severity:** error. Error/success colors >= 4.5:1 contrast.

### UX-FORM-31 — Timeout feedback retry
**Severity:** error. Request timeout: feedback claro + retry option.

---

## §3. Navigation Patterns (priority 9)

### UX-NAV-1 — Bottom nav limit 5 items
**Severity:** error. Bottom nav max 5. Labels + icons. Material Design.

### UX-NAV-2 — Drawer pra secondary nav
**Severity:** warning. Drawer/sidebar pra navegacao secundaria, nao acoes primarias.

### UX-NAV-3 — Back behavior preditive
**Severity:** error. Back navigation consistente. Preserva scroll/state.

### UX-NAV-4 — Deep linking todos screens
**Severity:** error. Key screens reachable via deep link/URL. Pra share + notifications.

### UX-NAV-5 — Tab bar iOS para top-level
**Severity:** info. iOS: bottom Tab Bar pra top-level nav.

### UX-NAV-6 — Top App Bar Android primary
**Severity:** info. Android: Top App Bar com navigation icon pra primary structure.

### UX-NAV-7 — Nav label + icon
**Severity:** error. Items com icon + text label. Icon-only nav prejudica descoberta.

### UX-NAV-8 — Nav state active visivel
**Severity:** error. Current location highlighted (color, weight, indicator).

### UX-NAV-9 — Nav hierarchy clara
**Severity:** error. Primary nav (tabs/bottom) vs secondary (drawer/settings) claramente separados.

### UX-NAV-10 — Modal escape route
**Severity:** error. Modais/sheets com close/dismiss claro. Swipe-down em mobile.

### UX-NAV-11 — Search accessible
**Severity:** warning. Search no top bar ou tab. Recent/suggested queries.

### UX-NAV-12 — Breadcrumbs em 3+ niveis (web)
**Severity:** warning. Web: breadcrumbs em hierarquias 3+ niveis.

### UX-NAV-13 — State preservation no back
**Severity:** error. Voltar restaura scroll + filter state + input.

### UX-NAV-14 — System gesture navigation support
**Severity:** error. Suporta iOS swipe-back, Android predictive back sem conflito.

### UX-NAV-15 — Tab badges sparingly
**Severity:** warning. Badges pra unread/pending. Clear apos visita.

### UX-NAV-16 — Overflow menu pra acoes em excesso
**Severity:** warning. Quando actions excedem espaco: overflow/more menu, nao cramming.

### UX-NAV-17 — Bottom nav nao tem sub-nav
**Severity:** error. Bottom nav SO top-level screens. Sub-navigation nunca dentro.

### UX-NAV-18 — Adaptive navigation por tamanho
**Severity:** warning. Large screens (≥1024px) prefer sidebar. Small screens: bottom/top nav.

### UX-NAV-19 — Back stack integrity
**Severity:** error. NUNCA reset silencioso ou jump pra home inesperado.

### UX-NAV-20 — Navigation consistency cross-page
**Severity:** error. Placement de nav igual em todas as paginas. Sem mudar por page type.

### UX-NAV-21 — Avoid mixed patterns
**Severity:** error. NAO mix Tab + Sidebar + Bottom Nav no MESMO nivel de hierarquia.

### UX-NAV-22 — Modal vs navigation
**Severity:** error. Modais NAO sao usados como primary navigation flows. Quebram path do user.

### UX-NAV-23 — Focus on route change
**Severity:** error. Apos transition, foco vai pra main content region (screen reader users).

### UX-NAV-24 — Persistent nav em deep pages
**Severity:** error. Core navigation reachable de deep pages. Sem esconder totalmente em sub-flows.

### UX-NAV-25 — Destructive nav separation
**Severity:** error. Acoes perigosas (delete account, logout) visualmente E espacialmente separadas de nav normal.

### UX-NAV-26 — Empty nav state explicacao
**Severity:** warning. Destination indisponivel: explicar por que (nao esconder silenciosamente).

---

## §4. Common Rules: Interaction (App)

### UX-COM-1 — Tap feedback 80-150ms
**Severity:** error. Pressed feedback (ripple/opacity/elevation) em 80-150ms.

### UX-COM-2 — Animation timing native
**Severity:** error. Micro-interactions 150-300ms com easing platform-native. Cross-ref UI-MOTION-1.

### UX-COM-3 — Accessibility focus order
**Severity:** error. Screen reader focus order = visual order. Labels descritivos.

### UX-COM-4 — Disabled state clarity
**Severity:** error. Semantic disabled props + reduced emphasis + no tap action.

### UX-COM-5 — Touch target min cross-ref
**Severity:** error. Cross-ref UX-INT-1 (44x44pt). Expand hit area se icon menor.

### UX-COM-6 — Gesture conflict prevention
**Severity:** warning. 1 primary gesture per region. Sem overlapping.

### UX-COM-7 — Semantic native controls
**Severity:** error. `<button>`, `Pressable`, native primitives com a11y roles. Sem div soup.

---

## Severity Distribution

| Severity | Count | % |
|---|---|---|
| error | ~50 | 68% |
| warning | ~17 | 23% |
| info | ~6 | 8% |
| **Total** | **~73** | **100%** |

UX checks tem severity media MAIOR que UI (mais errors). Razao: violacoes UX afetam fluxo do usuario diretamente.

---

## Como `mds-ux` usa

Quando criado, agente referencia esse arquivo em `dependencies.checklists`:

```yaml
agents/mds-ux.md:
  dependencies:
    checklists:
      - ui-pro-max-ux-checks.md          # este arquivo
      - ui-ux-pro-max-guidelines.md      # 99 UX guidelines (cherry-pick anterior)
      - nielsen-heuristics-checklist.md
      - ux-laws-checklist.md
      - anti-patterns-checklist.md
      - microinteractions-checklist.md
```

Comandos do `mds-ux` filtram subset:
- `*heuristic-audit` — combina §1 (interaction expectations) + Nielsen 10
- `*form-audit` — apenas §2 (Forms & Feedback)
- `*navigation-audit` — apenas §3 (Navigation Patterns)
- `*flow-audit` — combina §1 + §3 (interaction + navigation flow)

---

## Cross-references com mds-ui

Items que tem componente VISUAL alem do UX:
- UX-INT-9 (press feedback) ↔ UI-MOTION-1 (duration timing)
- UX-INT-1 (touch target) ↔ UI-ICON-8 (icon hit area)
- UX-FORM-30 (contrast feedback colors) ↔ UI-DARK-2/UI-DARK-3 (text contrast)
- UX-NAV-8 (nav state active) ↔ UI-STYLE-7 (state clarity)
- UX-COM-3 (focus order a11y) ↔ ui-pro-max-a11y-joint.md
