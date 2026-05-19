# Canonical Output Checklist — Magic-DS

> Validação obrigatória do output canônico (`squads/magic-ds/output/`) antes de empacotamento NPM ou handoff de produção. Executada pelo `mds-ops *validate-output` automaticamente; pode ser rodada manualmente como audit.

**Escopo:** apenas a camada canônica (HTML + CSS BEM). Adapter React+Tailwind tem checklist próprio (`a11y-wcag-checklist.md` + grep de não-vazamento do shadcn).

---

## §1 — Independência de framework

A camada canônica DEVE funcionar em qualquer stack — HTML estático, Vue, Svelte, Web Components. Validar que zero framework deps vazaram.

| # | Critério | Como verificar | ✅ Pass / ❌ Fail |
|---|---|---|---|
| 1.1 | Zero React/JSX nos arquivos `output/` | `grep -rE "className\|jsx\|tsx\|React\|import.*react" output/` retorna vazio | |
| 1.2 | Zero Tailwind utility classes (`@apply`, `@tailwind`, `bg-[...]`) | `grep -rE "@apply\|@tailwind\|class=\".*bg-\\[var" output/` retorna vazio | |
| 1.3 | Zero imports de shadcn / `@/vendor/` / `@/components/` | `grep -rE "shadcn\|@/vendor\|@/components" output/` retorna vazio | |
| 1.4 | Zero deps de runtime JS no CSS | Nenhum `expression(...)`, `eval`, ou hack de browser | |
| 1.5 | HTML usa só atributos HTML5 padrão (sem props React tipo `onClick`) | `grep -rE "onClick\|onChange\|onSubmit" output/html/` retorna vazio | |

---

## §2 — Consumo de tokens

Toda propriedade visual DEVE consumir tokens via `var(--…)`. Hardcoded é proibido.

| # | Critério | Como verificar | ✅ / ❌ |
|---|---|---|---|
| 2.1 | Zero cor hex/rgb/hsl direto | `grep -rE "#[0-9a-fA-F]{3,8}\|rgb\\(\|hsl\\(" output/css/` retorna vazio (exceto `var(--`) | |
| 2.2 | Toda cor consome `var(--semantic-*)` ou `var(--hub-*)` | Cores não vêm de `--primitive-*` direto (exceto casos justificados em rhythm.exceptions) | |
| 2.3 | Spacing consome `var(--semantic-space-*)` ou `var(--primitive-space-*)` | Sem px/rem hardcoded em padding/margin/gap (exceto sizing fixo de ícones tipo `1.25rem`) | |
| 2.4 | Radius consome `var(--semantic-radius-*)` | Sem `border-radius: 8px` literal | |
| 2.5 | Typography consome tokens `--primitive-text-*` ou `--semantic-type-*` | Sem `font-size: 14px` literal | |
| 2.6 | Motion (transition) consome `var(--semantic-motion-*)` ou `var(--primitive-duration-*)` | Sem `150ms` literal (exceto fallback documentado: `var(--semantic-motion-interaction, 150ms)`) | |

---

## §3 — Estrutura BEM

CSS canônico DEVE seguir BEM rasa (máximo 2 níveis).

| # | Critério | Como verificar | ✅ / ❌ |
|---|---|---|---|
| 3.1 | Block em kebab-case | `.kpi-card`, `.btn`, `.nav-item` ✅ — não `.kpiCard`, `.Btn` | |
| 3.2 | Elements com `__` único | `.kpi-card__header` ✅ — não `.kpi-card__header__title` (3 níveis = ❌) | |
| 3.3 | Modifiers com `--` único | `.btn--primary`, `.tag--solid` ✅ | |
| 3.4 | Modifier de estado também `--` (não data-attr) | `.btn--disabled` preferido a `[data-disabled]` para simplicidade | |
| 3.5 | Sem seletores aninhados profundos | Máx 2 níveis em `>`/descendant (`.kpi-card__header > .kpi-card__icon` ✅) | |
| 3.6 | Block referenciado consistentemente | Mesmo block name no `.css`, `.html`, e `spec.bem.block` | |

---

## §4 — Semântica HTML

HTML canônico DEVE usar elementos semânticos corretos.

| # | Critério | Como verificar | ✅ / ❌ |
|---|---|---|---|
| 4.1 | Ação clicável é `<button>` (não `<div>` ou `<span>`) | Inspecionar `output/html/btn.html`, `icon-btn.html`, `pagination.html` | |
| 4.2 | Link de navegação é `<a href>` (não `<button>` ou `<div>`) | `nav-item.html` quando layout=link | |
| 4.3 | Container de card é `<article>` ou `<section>` (não `<div>` bare) | `kpi-card.html` | |
| 4.4 | Navegação é `<nav>` | `sidebar.html`, `pagination.html` | |
| 4.5 | Heading hierárquico apropriado | KpiCardShell usa `<h4>` (consistente com nível organism) | |
| 4.6 | Listas usam `<ul>`/`<ol>`/`<li>` | Quando aplicável (Sidebar items) | |

---

## §5 — Acessibilidade (WCAG 2.1 AA aplicável ao output canônico)

| # | Critério | Como verificar | ✅ / ❌ |
|---|---|---|---|
| 5.1 | Botões sem texto têm `aria-label` no template | `icon-btn.html` mostra `aria-label="..."` no slot | |
| 5.2 | Ícones decorativos têm `aria-hidden="true"` | `kpi-card__icon` ✅ | |
| 5.3 | Imagens têm placeholder `alt=""` ou `alt="..."` | Quando aplicável | |
| 5.4 | Focus visível tem `:focus-visible` declarado | `.btn:focus-visible`, `.icon-btn:focus-visible` em CSS | |
| 5.5 | Target size ≥ 24×24 px (WCAG 2.5.5) | Controls não menores que `var(--semantic-size-control-sm)` (32px) | |
| 5.6 | Contraste 4.5:1 garantido pelos tokens consumidos | Garantido por design — `--semantic-text-on-brand: #FFF` sobre `--hub-primary` etc. | |

---

## §5.5 — Migração CVA→BEM (cross-file consistency)

Aplica-se a componentes que foram migrados de `class-variance-authority` pra classes BEM canônicas. A migração precisa propagar pra 3 arquivos por componente; faltar qualquer um quebra runtime ou tsc.

| # | Critério | Como verificar | ✅ / ❌ |
|---|---|---|---|
| 5.5.1 | `.tsx` removeu `cva()` e função `*Variants` | `grep -E "cva\\(|const \\w+Variants\\b" <Name>.tsx` retorna vazio | |
| 5.5.2 | `.tsx` não importa `class-variance-authority` | `grep -E "from \"class-variance-authority\"" <Name>.tsx` retorna vazio | |
| 5.5.3 | `index.ts` não re-exporta `*Variants` | `grep -E ", \\w+Variants" <Name>/index.ts` retorna vazio | |
| 5.5.4 | `.types.ts` não importa `VariantProps` | `grep -E "import type \\{ VariantProps" <Name>.types.ts` retorna vazio | |
| 5.5.5 | `.types.ts` não importa `*Variants` do componente | `grep -E "import type \\{ \\w+Variants" <Name>.types.ts` retorna vazio | |
| 5.5.6 | `.types.ts` não estende `VariantProps<typeof ...>` | `grep -E "VariantProps<typeof" <Name>.types.ts` retorna vazio | |
| 5.5.7 | Props removidos via CVA agora declarados explicitamente | `<Name>.types.ts` tem `variant?: "primary" \| ...` ou union types equivalentes pra cada eixo do spec.variants | |

### Sintoma se §5.5 falhar

- 5.5.3 violado → **SyntaxError em runtime, tela branca no browser**. Curl/Vite 200 enganam — só DevTools Console mostra o erro.
- 5.5.4/5/6 violado → trava `tsc --noEmit` (CI/build de produção falha).

### Grep one-liner consolidado

```bash
grep -rE 'class-variance-authority|VariantProps|\b\w+Variants\b' \
  --include='*.ts' --include='*.tsx' \
  src/components/<level>/<Name>/
# Esperado: 0 matches. Qualquer hit indica migração incompleta.
```

---

## §6 — Sincronia spec.yaml ↔ output

Output canônico DEVE refletir EXATAMENTE o declarado no `spec.yaml`.

| # | Critério | Como verificar | ✅ / ❌ |
|---|---|---|---|
| 6.1 | Block declarado em `spec.bem.block` aparece em `.css` e `.html` | Comparação textual | |
| 6.2 | Todos os elements de `spec.bem.elements` têm classe no CSS | Sem elemento órfão (declarado mas não usado) | |
| 6.3 | Todos os modifiers de `spec.bem.modifiers.{intent,size,state}` têm classe `--<value>` | | |
| 6.4 | `html_structure:` do spec é parseável como HTML válido (sem tag não fechada) | Lint HTML | |
| 6.5 | Tokens listados em `spec.tokens:` aparecem no CSS (não inventou novos) | Cross-ref | |
| 6.6 | Rhythm declarado em `spec.rhythm:` corresponde a gap/padding no CSS | `internal_item_gap: stack-md` → `gap: var(--semantic-space-stack-md)` | |

---

## §7 — Multi-product readiness

Output canônico DEVE servir todos os produtos da família Shelflix via theming.

| # | Critério | Como verificar | ✅ / ❌ |
|---|---|---|---|
| 7.1 | Zero seletor `[data-product="..."]` hardcoded no CSS canônico | Tema vive em `themes/`, não no CSS do componente | |
| 7.2 | Componente herda tokens via cascade — não embute valor de produto | Tudo `var(--…)`; produto override em `themes/<product>.css` | |
| 7.3 | Spec declara `products: [...]` listando consumidores | `spec.products` não vazio | |
| 7.4 | `theme_overrides:` lista tokens que produtos podem precisar override | Quando aplicável (default: vazio = herda tudo) | |

---

## §8 — Documentação

| # | Critério | Como verificar | ✅ / ❌ |
|---|---|---|---|
| 8.1 | `output/html/<block>.html` tem header comentado identificando spec + versão | Primeiras linhas mostram `Generated from squads/magic-ds/component/<Name>.spec.yaml v<X>` | |
| 8.2 | HTML tem slots `{name}` claramente marcados como placeholders | Comentários explicando o que cada slot recebe | |
| 8.3 | HTML tem exemplo renderizado em comentário no final | Permite copy/paste de instância real | |
| 8.4 | CSS tem header comentado identificando spec + versão | | |
| 8.5 | CSS agrupa regras por modifier/element com seções comentadas | Legibilidade | |

---

## Modo de execução

### Manual (audit)
Rodar passo a passo cada §; preencher ✅/❌. Score `<componente> <data>`.

### Automatizado (mds-ops `*validate-output`)
Greps de §1.1–§2.1 retornam exit code 1 em qualquer hit. §3.6 e §6.x exigem parser YAML/HTML. §4 e §5 exigem revisão humana (não automatizáveis textualmente).

## Score interpretation

- **A (todos ✅)** — pacote pronto pra `*package --target=all`
- **B (1–3 ❌ não críticos)** — pode publicar com nota; abrir issues
- **C (≥1 ❌ em §1, §2 ou §3)** — bloqueia handoff. Devolve pro `mds-ops` corrigir.
- **D (≥1 ❌ em §5)** — bloqueia produção. Devolve pro `mds-component` revisar spec.
