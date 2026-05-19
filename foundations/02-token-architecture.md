# Foundations Report — 3-Layer Token Architecture

> ⚠️ **SUPERSEDED por `07-token-architecture-v3.md` em 2026-05-19.**
> Este doc fica como referência histórica. Para arquitetura atual, ver `07-v3` (mecânica) + `08-arquitetura-3-andares.md` (conceito).

**Agent:** mds-foundations (Architect)
**Command:** `*build-foundations`
**Tenant:** shelflix
**Modes:** light, dark
**Date:** 2026-05-12
**Status:** ✅ Structured | ⏭️ Handoff: mds-governance

---

## 1. Decisões arquiteturais aplicadas (pós-aprovação humana)

| Decisão | Status |
|--------|--------|
| Multi-tenant com tenant inaugural `shelflix` | ✅ |
| Themes: `light` (default) + `dark` | ✅ |
| Auto-completar gaps (Gray 50/300/900, Spacing 5+, Info-light) | ✅ |
| Promover H3/H4 para SemiBold (consistência hierárquica) | ✅ |
| Corrigir typos do Figma (`Sucess` → `success`) | ✅ |
| Resolver 3 duplicatas em Primary | ✅ |
| Kebab-case obrigatório em toda taxonomia | ✅ |

---

## 2. Layer 1 — PRIMITIVES (`:root`)

> ❌ **REGRA:** componentes NUNCA referenciam esta camada diretamente. Acesso só via Semantic.

### 2.1 Cores brutas

```yaml
# Brand orange scale (interpolada a partir do Figma)
--primitive-brand-50:  '#FFF4EA'  # interpolado (lighter than 100)
--primitive-brand-100: '#FFE8D5'  # interpolado
--primitive-brand-200: '#FFDCC0'  # interpolado
--primitive-brand-300: '#E5C3A1'  # ← Figma Primary/Light
--primitive-brand-400: '#E5B27E'  # interpolado
--primitive-brand-500: '#E5A15C'  # ← Figma Primary/Medium
--primitive-brand-600: '#E58A2E'  # interpolado
--primitive-brand-700: '#E57300'  # ← Figma Primary/Dark (MARCA)
--primitive-brand-800: '#FF450C'  # ← Figma Primary/Dark 2
--primitive-brand-900: '#CC3700'  # interpolado (darker than 800)

# Warm gray scale (com viés quente, baseado no Figma)
--primitive-gray-50:   '#FFFDFA'  # interpolado
--primitive-gray-100:  '#FFF9F2'  # ← Figma Gray/100
--primitive-gray-200:  '#F2E6DA'  # ← Figma Gray/200
--primitive-gray-300:  '#D9C5B5'  # interpolado (NOVO - era gap)
--primitive-gray-400:  '#B2A598'  # ← Figma Gray/400
--primitive-gray-500:  '#736A61'  # ← Figma Gray/500
--primitive-gray-600:  '#332F2B'  # ← Figma Gray/600
--primitive-gray-700:  '#191919'  # ← Figma Gray/700
--primitive-gray-800:  '#0E0E0E'  # ← Figma Gray/800
--primitive-gray-900:  '#000000'  # interpolado (NOVO - era gap)

# Feedback colors (typos corrigidos + Info-light interpolado)
--primitive-success-light: '#85CC85'
--primitive-success:       '#28A745'  # ← Figma Success Dark 10 (10%-friendly)
--primitive-success-dark:  '#12B212'

--primitive-warning-light: '#FFD47F'  # era Alert
--primitive-warning:       '#FFCC66'
--primitive-warning-dark:  '#E5A323'  # interpolado

--primitive-error-light:   '#FF6666'
--primitive-error:         '#CC4747'  # ← Figma Error Dark
--primitive-error-dark:    '#B23030'  # interpolado

--primitive-info-light:    '#7EC6FF'  # NOVO (era gap) - interpolado do Info Dark
--primitive-info:          '#33AEFF'  # ← Figma Info Dark
--primitive-info-dark:     '#0080CC'  # interpolado

--primitive-info-alt-light: '#BC89FF'  # ← Figma Info 2
--primitive-info-alt:       '#8A38F5'  # ← Figma Info 2 Dark
--primitive-info-alt-dark:  '#6B1FCC'  # interpolado
```

### 2.2 Tipografia primitivas

```yaml
--primitive-font-sans: '"Sora", system-ui, -apple-system, "Segoe UI", sans-serif'

# Type scale (modular, baseado em 16px = 1rem)
--primitive-text-2xs:  '0.625rem'  # 10px - Caption/Labels
--primitive-text-xs:   '0.75rem'   # 12px - Caption/Regular
--primitive-text-sm:   '0.875rem'  # 14px - Label
--primitive-text-base: '1rem'      # 16px - Body
--primitive-text-md:   '1.125rem'  # 18px - H4
--primitive-text-lg:   '1.25rem'   # 20px - H3
--primitive-text-xl:   '1.5rem'    # 24px - H2
--primitive-text-2xl:  '1.75rem'   # 28px - H1

--primitive-weight-regular:  400
--primitive-weight-semibold: 600

--primitive-leading-tight:  1.2
--primitive-leading-normal: 1.5
--primitive-leading-none:   1.0
```

### 2.3 Spacing (Tailwind-compatible 4px grid, gaps preenchidos)

```yaml
--primitive-space-0:    '0'
--primitive-space-1:    '0.25rem'  # 4px
--primitive-space-1-5:  '0.375rem' # 6px
--primitive-space-2:    '0.5rem'   # 8px
--primitive-space-2-5:  '0.625rem' # 10px
--primitive-space-3:    '0.75rem'  # 12px
--primitive-space-4:    '1rem'     # 16px
--primitive-space-5:    '1.25rem'  # 20px  (NOVO)
--primitive-space-6:    '1.5rem'   # 24px  (NOVO)
--primitive-space-8:    '2rem'     # 32px  (NOVO)
--primitive-space-10:   '2.5rem'   # 40px  (NOVO)
--primitive-space-12:   '3rem'     # 48px  (NOVO)
--primitive-space-16:   '4rem'     # 64px  (NOVO)
--primitive-space-20:   '5rem'     # 80px  (NOVO)
--primitive-space-24:   '6rem'     # 96px  (NOVO)
```

### 2.4 Sizing / Radius / Border

```yaml
--primitive-radius-none: '0'
--primitive-radius-sm:   '0.5rem'   # 8px (= --radius - 2px)
--primitive-radius-md:   '0.625rem' # 10px (base inferida)
--primitive-radius-lg:   '0.875rem' # 14px
--primitive-radius-full: '9999px'

--primitive-border-1:    '1px'
--primitive-border-icon: '1.5px'    # arredondado de 1.33 do Figma para valor "limpo"
--primitive-border-2:    '2px'

--primitive-size-icon-sm: '1rem'    # 16px (= w-4)
--primitive-size-icon-md: '1.25rem' # 20px
--primitive-size-icon-lg: '2rem'    # 32px (= w-8)

--primitive-size-control-sm: '2rem'   # 32px (= h-8)
--primitive-size-control-md: '2.5rem' # 40px
--primitive-size-control-lg: '3rem'   # 48px

--primitive-size-sidebar-collapsed: '4rem'    # 64px
--primitive-size-sidebar-expanded:  '11rem'   # 176px (= w-44 do Figma)
```

### 2.5 Motion (defaults sãos — refinar com URL viva quando destravar)

```yaml
--primitive-duration-fast:    '150ms'
--primitive-duration-normal:  '250ms'
--primitive-duration-slow:    '400ms'

--primitive-ease-linear: 'linear'
--primitive-ease-out:    'cubic-bezier(0.16, 1, 0.3, 1)'
--primitive-ease-in-out: 'cubic-bezier(0.4, 0, 0.2, 1)'
```

---

## 3. Layer 2 — SEMANTIC (`[data-tenant="shelflix"][data-theme="light|dark"]`)

> 🎯 **Esta é a camada que componentes consomem.** Trocar tenant ou theme = re-mapear apenas estes aliases.

### 3.1 Semantic — Light mode (default)

```yaml
# [data-tenant="shelflix"][data-theme="light"]

# Background
--semantic-bg-canvas:        var(--primitive-gray-100)  # #FFF9F2
--semantic-bg-surface:       '#FFFFFF'
--semantic-bg-subtle:        var(--primitive-gray-200)  # #F2E6DA
--semantic-bg-muted:         var(--primitive-gray-300)
--semantic-bg-inverse:       var(--primitive-gray-800)

# Brand
--semantic-bg-brand:         var(--primitive-brand-700) # #E57300
--semantic-bg-brand-hover:   var(--primitive-brand-800) # #FF450C
--semantic-bg-brand-subtle:  var(--primitive-brand-100)
--semantic-text-brand:       var(--primitive-brand-700)

# Text
--semantic-text-primary:     var(--primitive-gray-800)  # #0E0E0E
--semantic-text-secondary:   var(--primitive-gray-600)  # #332F2B
--semantic-text-tertiary:    var(--primitive-gray-500)  # #736A61
--semantic-text-disabled:    var(--primitive-gray-400)  # #B2A598
--semantic-text-inverse:     var(--primitive-gray-100)
--semantic-text-on-brand:    '#FFFFFF'

# Border
--semantic-border-default:   var(--primitive-gray-300)
--semantic-border-subtle:    var(--primitive-gray-200)
--semantic-border-strong:    var(--primitive-gray-500)
--semantic-border-brand:     var(--primitive-brand-700)
--semantic-border-focus:     var(--primitive-brand-700)

# Feedback
--semantic-bg-success:       var(--primitive-success-light)
--semantic-text-success:     var(--primitive-success-dark)
--semantic-border-success:   var(--primitive-success)

--semantic-bg-warning:       var(--primitive-warning-light)
--semantic-text-warning:     var(--primitive-warning-dark)
--semantic-border-warning:   var(--primitive-warning)

--semantic-bg-error:         var(--primitive-error-light)
--semantic-text-error:       var(--primitive-error-dark)
--semantic-border-error:     var(--primitive-error)

--semantic-bg-info:          var(--primitive-info-light)
--semantic-text-info:        var(--primitive-info-dark)
--semantic-border-info:      var(--primitive-info)
```

### 3.2 Semantic — Dark mode

```yaml
# [data-tenant="shelflix"][data-theme="dark"]

--semantic-bg-canvas:        var(--primitive-gray-800)  # #0E0E0E
--semantic-bg-surface:       var(--primitive-gray-700)  # #191919
--semantic-bg-subtle:        var(--primitive-gray-600)
--semantic-bg-muted:         var(--primitive-gray-500)
--semantic-bg-inverse:       var(--primitive-gray-100)

--semantic-bg-brand:         var(--primitive-brand-700)  # mantém marca
--semantic-bg-brand-hover:   var(--primitive-brand-600)
--semantic-bg-brand-subtle:  'rgba(229, 115, 0, 0.12)'   # brand-700 @ 12%
--semantic-text-brand:       var(--primitive-brand-500)  # mais legível no escuro

--semantic-text-primary:     var(--primitive-gray-100)
--semantic-text-secondary:   var(--primitive-gray-300)
--semantic-text-tertiary:    var(--primitive-gray-400)
--semantic-text-disabled:    var(--primitive-gray-500)
--semantic-text-inverse:     var(--primitive-gray-800)
--semantic-text-on-brand:    '#FFFFFF'

--semantic-border-default:   var(--primitive-gray-600)
--semantic-border-subtle:    var(--primitive-gray-700)
--semantic-border-strong:    var(--primitive-gray-400)
--semantic-border-brand:     var(--primitive-brand-700)
--semantic-border-focus:     var(--primitive-brand-500)

# Feedback dark (cores ajustadas para contraste em fundo escuro)
--semantic-bg-success:       'rgba(133, 204, 133, 0.16)'
--semantic-text-success:     var(--primitive-success-light)
--semantic-border-success:   var(--primitive-success)

--semantic-bg-warning:       'rgba(255, 212, 127, 0.16)'
--semantic-text-warning:     var(--primitive-warning-light)
--semantic-border-warning:   var(--primitive-warning)

--semantic-bg-error:         'rgba(255, 102, 102, 0.16)'
--semantic-text-error:       var(--primitive-error-light)
--semantic-border-error:     var(--primitive-error)

--semantic-bg-info:          'rgba(51, 174, 255, 0.16)'
--semantic-text-info:        var(--primitive-info-light)
--semantic-border-info:      var(--primitive-info)
```

### 3.3 Semantic Typography (compartilhado entre themes)

```yaml
--semantic-font-display: var(--primitive-font-sans)
--semantic-font-body:    var(--primitive-font-sans)

# Type roles
--semantic-type-h1:      var(--primitive-text-2xl) / var(--primitive-leading-tight) / var(--primitive-weight-semibold)
--semantic-type-h2:      var(--primitive-text-xl)  / var(--primitive-leading-tight) / var(--primitive-weight-semibold)
--semantic-type-h3:      var(--primitive-text-lg)  / var(--primitive-leading-tight) / var(--primitive-weight-semibold)  # PROMOVIDO (era 400)
--semantic-type-h4:      var(--primitive-text-md)  / var(--primitive-leading-tight) / var(--primitive-weight-semibold)  # PROMOVIDO
--semantic-type-body:    var(--primitive-text-base)/ var(--primitive-leading-normal)/ var(--primitive-weight-regular)
--semantic-type-label:   var(--primitive-text-sm)  / var(--primitive-leading-tight) / var(--primitive-weight-regular)
--semantic-type-caption: var(--primitive-text-xs)  / var(--primitive-leading-normal)/ var(--primitive-weight-regular)
--semantic-type-micro:   var(--primitive-text-2xs) / var(--primitive-leading-none)  / var(--primitive-weight-regular)
```

### 3.4 Semantic Spacing (roles, não tamanhos)

```yaml
--semantic-space-inset-xs:    var(--primitive-space-1)   # 4px
--semantic-space-inset-sm:    var(--primitive-space-2)   # 8px
--semantic-space-inset-md:    var(--primitive-space-3)   # 12px
--semantic-space-inset-lg:    var(--primitive-space-4)   # 16px
--semantic-space-inset-xl:    var(--primitive-space-6)   # 24px

--semantic-space-stack-xs:    var(--primitive-space-1)
--semantic-space-stack-sm:    var(--primitive-space-2)
--semantic-space-stack-md:    var(--primitive-space-4)
--semantic-space-stack-lg:    var(--primitive-space-6)
--semantic-space-stack-xl:    var(--primitive-space-8)

--semantic-space-inline-xs:   var(--primitive-space-1)
--semantic-space-inline-sm:   var(--primitive-space-2)
--semantic-space-inline-md:   var(--primitive-space-3)
--semantic-space-inline-lg:   var(--primitive-space-4)
```

### 3.5 Semantic Radius / Motion

```yaml
--semantic-radius-control:    var(--primitive-radius-sm)   # 8px - inputs/buttons
--semantic-radius-surface:    var(--primitive-radius-md)   # 10px - cards/modals
--semantic-radius-pill:       var(--primitive-radius-full)

--semantic-motion-interaction: var(--primitive-duration-fast) var(--primitive-ease-out)
--semantic-motion-transition:  var(--primitive-duration-normal) var(--primitive-ease-in-out)
--semantic-motion-overlay:     var(--primitive-duration-slow) var(--primitive-ease-out)
```

---

## 4. Layer 3 — COMPONENT (gerado por mds-component em fase posterior)

> 📌 Esta camada **será preenchida** quando o `mds-component` mapear cada peça (Button, Input, Card, Modal, etc.).
>
> Pattern: `--component-{name}-{variant}-{state}-{property}`
>
> Exemplo do que virá:
> ```yaml
> --component-button-primary-bg-default: var(--semantic-bg-brand)
> --component-button-primary-bg-hover:   var(--semantic-bg-brand-hover)
> --component-button-primary-text:       var(--semantic-text-on-brand)
> ```

---

## 5. Arquitetura de scoping CSS

```css
/* Layer 1 — Primitives (uma vez, no document root) */
:root {
  --primitive-brand-700: #E57300;
  /* ... todas as primitives ... */
}

/* Layer 2 — Semantic (multi-tenant × multi-theme, scoping ortogonal) */
[data-tenant="shelflix"] {
  /* defaults se theme não estiver setado */
}

[data-tenant="shelflix"][data-theme="light"] {
  --semantic-bg-canvas: var(--primitive-gray-100);
  /* ... */
}

[data-tenant="shelflix"][data-theme="dark"] {
  --semantic-bg-canvas: var(--primitive-gray-800);
  /* ... */
}

/* Futuro: outro tenant, mesma arquitetura */
[data-tenant="empresa-b"][data-theme="light"] { /* ... */ }
```

---

## 6. Coleções para Figma Variables

Quando exportar para o Figma (`figma-variables.json`), o output terá **3 coleções**:

1. **`Primitives`** — modo único `Default`
2. **`Semantic — Shelflix`** — modos `Light` + `Dark`
3. **`Components`** — modo único `Default` (preenchido pelo Component agent)

Cada coleção contém apenas aliases para a anterior (nunca valores hardcoded acima de Primitives).

---

## 7. Handoff para Governance

📨 **Próximo agente:** `mds-governance` deve rodar `*enforce-rules --mode=block` sobre este documento.

Verificações esperadas:
- ✅ kebab-case em 100% dos nomes
- ✅ Prefixos `--primitive-`, `--semantic-`, `--component-`
- ✅ Nenhuma referência Primitive→Component direta
- ✅ Nenhuma duplicata (já resolvido em Foundations)
- ✅ Typos corrigidos
- ⚠️ Validar se `info-alt` é um nome aceitável ou deve virar `purple`/`secondary`
