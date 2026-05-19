# UI Pre-Delivery Checklist

**Status:** Adotado (Round 5)
**Consumido por:** `mds-ui` (futuro, conforme decisao do conselho squad-orchestrator + mds-orchestrator)
**Origem:** Selecao curada de ui-ux-pro-max-skill (nextlevelbuilder)
**Atribuicao:** https://github.com/nextlevelbuilder/ui-ux-pro-max-skill

**⚡ Companion (bulk import):** `ui-pro-max-pre-delivery.md` (27 items absorvidos da skill em 2026-05-18)
Este arquivo (`ui-pre-delivery-checklist.md`) tem **3 cherry-picks iniciais**. O companion tem o **bulk import**. Pipeline roda os DOIS em sequencia. Sem overlap.

---

## 0. Proposito

Checklist focado em **fidelidade visual + a11y de superficie** que complementa as 54 regras nativas do `mds-ui` (ver `agents/mds-ui.md` quando criado). Items abaixo foram cherry-picked da skill ui-ux-pro-max porque cobrem zonas ainda nao explicitas nos nossos checks.

---

## UI-PD-1 — Cursor-pointer em elementos clicaveis

**Categoria:** Interaction / Affordance
**Severity:** warning

### Descricao
Elementos interativos (`<button>`, `<a>`, items com `onClick`, etc.) devem ter `cursor: pointer` declarado. Sem isso, user nao tem feedback visual de que pode clicar.

### Do
```css
.btn,
.nav-item,
[role="button"],
[onclick] {
  cursor: pointer;
}
```

### Don't
```css
/* Elementos clicaveis sem cursor */
.btn { /* sem cursor declarado */ }
```

### Como audit detecta
Walk em `output/css/*.css` e `src/components/**/*.css`:
- Selectores que terminam em `.btn`, `.icon-btn`, `[role="button"]`, classes wrappers de `<a>` ou `<button>`
- Verifica se `cursor: pointer` declarado (direto ou via inherit)
- Flagga warning se ausente

### Excecoes
- `disabled` state usa `cursor: not-allowed` (correto, nao flagga)
- Elementos `cursor: text` (inputs) ou `cursor: default` (display-only) — ok

---

## UI-PD-2 — Fontes carregadas antes do render (FOUT/FOIT prevention)

**Categoria:** Performance / Typography
**Severity:** error

### Descricao
Fontes web (Sora, no nosso caso) podem causar:
- **FOIT** (Flash of Invisible Text): texto invisivel ate fonte carregar
- **FOUT** (Flash of Unstyled Text): texto renderiza com fallback, depois "salta" pra fonte custom

Ambos causam layout shift visivel.

### Do
```css
@font-face {
  font-family: 'Sora';
  font-display: swap;  /* mostra fallback imediato, troca quando custom carregar */
  src: url('...');
}
```

```html
<!-- Preconnect ao Google Fonts (ja temos em index.html) -->
<link rel="preconnect" href="https://fonts.googleapis.com" />
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
```

```css
/* Fallback estipulado proximo do custom (reduz layout shift) */
body {
  font-family: 'Sora', system-ui, -apple-system, 'Segoe UI', sans-serif;
}
```

### Don't
- `font-display: block` (causa FOIT)
- Sem preconnect (font carrega tarde)
- Fallback sem similaridade (Sora -> Comic Sans, salto enorme)

### Como audit detecta
1. **Preconnect check:** `index.html` tem `<link rel="preconnect">` pros dominios de fonte
2. **font-display check:** todo `@font-face` tem `font-display: swap` ou `optional`
3. **Fallback check:** todo `font-family` tem fallback declarado (nao termina em ", sans-serif" sozinho — tem cadeia de fallback)
4. **Token check:** componente consome `var(--sf-primitive-font-sans)` (ja tem cadeia completa), nao font-family hardcoded

### Excecoes
- System fonts (`system-ui`) nao precisam de preconnect

---

## UI-PD-3 — Keyboard focus visible (A11y conjunta UI+UX)

**Categoria:** Accessibility / Interaction
**Severity:** error

### Descricao
Usuarios de teclado precisam de **focus indicator visivel** em todo elemento focavel. Remover `outline` sem substituir e WCAG 2.4.7 failure (Focus Visible, AA).

### Ownership (conjunta UI + UX)
- **UI** dona: implementacao do focus ring (cor, espessura, contraste)
- **UX** dona: garantir que TODO elemento interativo e focavel (ordem do tab, sem keyboard trap)

### Do
```css
:focus-visible {
  outline: 2px solid var(--sf-border-focus);
  outline-offset: 2px;
}

/* ou via shadow-focus-ring token */
.btn:focus-visible {
  outline: none;
  box-shadow: var(--sf-shadow-focus-ring);
}
```

### Don't
```css
:focus { outline: none; }   /* sem substituicao */
*:focus-visible { outline: 0; }  /* mata accessibility */
```

### Como audit detecta
**UI side (mds-ui):**
1. Grep `outline:\s*(none|0)` em CSS sem `box-shadow:\s*.*focus` no mesmo selector
2. Walk focus-visible rules — todo componente interativo tem :focus-visible declarado
3. Contrast check do focus ring contra bg (>= 3:1 WCAG AA)

**UX side (mds-ux):**
4. Tab order test: walk DOM em ordem de keyboard, verifica que ordem visual bate com ordem fisica
5. Keyboard trap test: nenhum elemento prende o foco (modal sem escape, dropdown sem return focus)
6. Skip-to-content link presente em pagina com nav heavy

### Severity matrix

| Falha | Severity |
|---|---|
| Outline removido sem substituicao | **error** (bloqueia ops) |
| Focus ring com contraste < 3:1 | error |
| Keyboard trap | error |
| Tab order quebrado | warning |
| Sem skip-to-content em page com nav | warning |
| Focus ring presente mas baixa visibilidade (ex: cor muito sutil) | info |

---

## Enforcement

### mds-ui invoca este checklist quando:
- `*audit-ui --component=<name>` (todos os 3 checks)
- `*theme-stress --component=<name>` (apenas UI-PD-3 contrast em ambos modos)
- `*audit-ui --target=showroom` (todos os checks em todos os componentes)

### mds-ux invoca UI-PD-3 quando:
- `*heuristic-audit` (Nielsen 7 - Flexibility/efficiency of use)
- `*ia-review` (tab order = navegacao)

### Integracao com checks nativos
Esses 3 checks somam aos **54 checks nativos** do `mds-ui` (vide proposta em sessao 2026-05-18). Total: **57 checks UI**.

---

## Pendentes (proximos cherry-picks)

Da skill ui-ux-pro-max, items que ainda nao incorporamos mas valem considerar:

- **Z-index management** (skill #15) — ja temos via tokens (`--sf-z-*`), mas falta check de stacking context conflicts
- **Layout shift on async content** (skill #19) — image dimensions reservadas, aspect-ratio enforce
- **Touch target spacing 8px+** (skill #23) — temos size guard pra 40px touch, falta gap entre targets
- **Loading state > 300ms** (skill #78) — definir threshold canonico no DS

Revisitar quando `mds-ui` for criado formalmente.
