# Token Architecture v3 — 3 Camadas (Round 4 — Convergence to Even-DS)

**Status:** Adotado (substitui v2)
**Substitui:** `02-token-architecture-v2.md` (5 camadas)
**Data:** 2026-05-18
**Aprovacao humana:** registrada em sessao de convergence W1-W3.2

> 📎 **Pre-requisito:** `governance/prefix-policy.md` — define prefix obrigatorio por projeto.
> 📎 **Leitura complementar:** `03-foundation-dimensions.md` (8 dimensoes Foundation).

---

## 0. Contexto

V3 colapsa Brand Core + Theme em Semantic-com-modes. Razao: Brand+Theme adicionavam complexidade sem ganho — Semantic ja suporta variacao via selectors. Convergencia com padrao Even-DS (3 camadas) + W3C Design Tokens format.

**Mudancas vs v2:**

1. **Brand Core eliminado.** Tokens `--brand-*` viraram `--<prefix>-action-primary-*` / `--<prefix>-accent-*` em Semantic.
2. **Theme eliminado como camada.** Variacao por produto vira **token set** nomeado em tokens.json.
3. **tokens.json (W3C)** vira fonte da verdade. CSS e artefato gerado.
4. **Prefix obrigatorio.** Declarado em squad-policy.yaml.token_prefix.
5. **Token sets** sao a unidade de override (semantic-dark, semantic-light, product-<name>, density-<level>, reduce-motion).
6. **Reference syntax** `{set.path.to.token}` cross-set documentada.

---

## 1. As 3 camadas

| # | Camada | Prefixo | Escopo CSS | Responsabilidade | Editavel direto? |
|---|---|---|---|---|---|
| 1 | **Primitive** | `--<prefix>-primitive-*` | `:root` | Escalas fisicas matematicas. Motor interno. | Nao (so via JSON) |
| 2 | **Semantic** | `--<prefix>-*` (sem "semantic-" no nome) | varia por set | Funcao/papel na UI. Sets nomeados sao a unidade de override. | Nao (so via JSON) |
| 3 | **Component** | `--<block>-*` | dentro de `output/css/<block>.css` | Aplicacao especifica no componente. | Sim (via mds-ops) |

### 1.1 Primitive — "Qual e a cor fisica?"

Nome reflete **valor fisico**, nunca papel.

```json
{
  "primitive": {
    "color": {
      "orange": {
        "700": { "$type": "color", "$value": "#E57300" }
      }
    }
  }
}
```

Gera no CSS:
```css
:root {
  --sf-primitive-orange-700: #E57300;
}
```

**Regra inquebravel:** componente NUNCA consome primitive direto. Primitive vai pra showroom interno (mantenedor), nao publico.

### 1.2 Semantic — "Qual o papel desse token?"

Composto por multiplos **token sets**. Cada set tem selector proprio e e ativado por data attributes ou media queries.

Sets canonicos:

| Set | Selector | Quando ativa |
|---|---|---|
| `semantic-dark` | `[data-tenant="<tenant>"]` | Default (dark) |
| `semantic-light` | `+[data-theme="light"]` | User troca mode |
| `product-<name>` | `[data-product="<name>"]` | User troca produto |
| `density-<level>` | `+[data-density="<level>"]` | Compact toggle |
| `density-<level>-touch` | `+@media (pointer: coarse)` | Touch em compact |
| `reduce-motion` | `+@media (prefers-reduced-motion)` | A11y preference |

**Exemplo:**
```json
{
  "semantic-dark": {
    "bg": {
      "canvas": { "$type": "color", "$value": "{primitive.color.neutral.800}" }
    },
    "actionPrimary": {
      "bg": { "$type": "color", "$value": "{primitive.color.orange.700}" }
    }
  }
}
```

Gera:
```css
[data-tenant="shelflix"] {
  --sf-bg-canvas: var(--sf-primitive-neutral-800);
  --sf-action-primary-bg: var(--sf-primitive-orange-700);
}
```

### 1.3 Component — "Como esse componente especifico usa?"

Vive em `squads/magic-ds/output/css/<block>.css`. Consome **somente Semantic**. Geracao via `mds-ops generate-ops-code`.

```css
/* output/css/btn.css */
.btn--primary {
  background: var(--sf-action-primary-bg);
  color: var(--sf-action-primary-text);
}
```

---

## 2. Reference syntax (4 padroes)

### 2.1 Same-set reference (dentro do mesmo set)
```json
"text": {
  "brand": { "$type": "color", "$value": "{primitive.color.orange.500}" },
  "linkOnElevated": { "$type": "color", "$value": "{text.brand}" }
}
```
Resolve pra: `var(--sf-text-brand)`.

### 2.2 Cross-set reference
```json
"semantic-dark": {
  "border": {
    "brand": { "$value": "{primitive.color.orange.700}" }
  }
}
```
Build script reconhece `primitive.*` como referencia cross-set.

### 2.3 Composite value (string com refs)
```json
"motion": {
  "hover": { "$value": "{primitive.motion.duration.fast} {primitive.motion.easing.out}" }
}
```
Resolve pra: `var(--sf-primitive-duration-fast) var(--sf-primitive-ease-out)`.

### 2.4 Arbitrary string com refs
```json
"shadow": {
  "focusRing": { "$value": "0 0 0 3px {actionPrimary.bgSubtle}" }
}
```
Resolve pra: `0 0 0 3px var(--sf-action-primary-bg-subtle)`.

---

## 3. Build pipeline

```
tokens.json (W3C, fonte da verdade)
       ↓
mds-tokens *validate-json (checa refs, $type, prefix, coverage)
       ↓
mds-tokens *build-css (roda scripts/build-tokens.mjs)
       ↓
tokens-generated.css (artefato, importado pelo app)
```

Mudou um token? Edita tokens.json + `npm run tokens:build`. CSS regenera. Vite HMR pega.

---

## 4. Migration v2 → v3

| Token v2 | Token v3 |
|---|---|
| `--brand-primary` | `--<prefix>-action-primary-bg` |
| `--brand-primary-hover` | `--<prefix>-action-primary-bg-hover` |
| `--brand-on-primary` | `--<prefix>-action-primary-text` |
| `--brand-accent` | `--<prefix>-accent` |
| `--theme-primary` | `--<prefix>-action-primary-bg` (mesmo target) |
| `--theme-navigation-active-bg` | `--<prefix>-nav-active-bg` |
| `--theme-navigation-active-text` | `--<prefix>-nav-active-text` |
| `--theme-link` | `--<prefix>-action-primary-bg` |
| `--semantic-*` | `--<prefix>-*` (drop "semantic-" prefix) |
| `--primitive-*` | `--<prefix>-primitive-*` (prepend prefix) |

Migracao automatica via `mds-ops *migrate-prefix` ou sed em massa.

---

## 5. Tokens Studio compatibility

tokens.json segue formato W3C Design Tokens com extensions de Tokens Studio:
- `$metadata` declarando sets + selectors + media queries
- `$themes` listando combinacoes (Admin Dark, Admin Light, Mission Dark)
- Cada token tem `$value` + `$type`
- Refs via `{path.to.token}` (W3C standard)

Designer importa direto no plugin Tokens Studio (Figma) sem conversor.

---

## 6. Historico

- **v1** (2026-05-12): 3 camadas iniciais (Primitive → Hubs → Semantic). Substituida por v2.
- **v2** (2026-05-14): 5 camadas (Primitive → Brand Core → Theme → Semantic → Component). Substituida por v3.
- **v3** (2026-05-18): 3 camadas + JSON source + prefix + token sets. **Atual.**
