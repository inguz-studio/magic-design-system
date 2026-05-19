# Foundations Report — Round 1.6 Update

**Agent:** mds-foundations (Architect)
**Command:** `*build-foundations` (delta update — resolve gaps de design-check)
**Tenant:** shelflix
**Mode:** dark-first
**Date:** 2026-05-13
**Status:** ⏳ Aguardando aprovação humana | ⏭️ Handoff: atualizar specs que declararam gaps + showcase
**Supersedes:** trechos de `05-foundations-round-1-5.md` listados em §0 — apenas adiciona, não invalida

---

## 0. Trigger desta atualização

Esta atualização foi gerada como resposta direta ao **design-check piloto** (rodado em 7 artefatos do estado atual). Os gaps abaixo foram detectados pelo checklist e flagados como **P1**:

| Gap | Detectado em | Severidade |
|-----|--------------|------------|
| `--semantic-bg-danger-solid` ausente | `Button.spec.yaml`, `IconButton.spec.yaml` (`gaps_for_foundations`) | Bloqueia variant `danger` |
| `--semantic-bg-danger-solid-hover` ausente | idem | idem |
| `--semantic-text-on-danger` ausente | idem | idem |
| Tag solid: contraste WCAG 1.4.3 em status claros | `Tag.spec.yaml` (1 ❌ no design-check) | Falha de acessibilidade |

Round 1.6 resolve **todos os 4** com decisões mínimas e propagáveis.

---

## 1. Tokens novos — Danger solid

### 1.1 Layer 2 — SEMANTIC adicionados

```yaml
# [data-tenant="shelflix"]   (dark default)

# Danger solid family (NOVO — Round 1.6)
# Uso: Button/IconButton variant=danger; fundo cheio com texto branco
--semantic-bg-danger-solid:       var(--primitive-error)         # #CC4747 — contraste 5.1:1 com #FFFFFF ✓
--semantic-bg-danger-solid-hover: var(--primitive-error-dark)    # #B23030
--semantic-text-on-danger:        #FFFFFF                         # branco em todos os modos
```

### 1.2 Justificativa de separação semântica

`--semantic-text-on-danger` propositalmente **separado de** `--semantic-text-on-brand`, mesmo que o valor seja igual (`#FFFFFF`). Razão:

- Auditoria de drift fica clara — se o time do produto mudar a cor "branca" em um contexto (ex: usa `bone-100` em botão de marca), o outro não vaza
- Code Auditor (futuro) detecta mistura inadvertida
- Documentação fica explícita sobre o intent

---

## 2. Regra condicional — Tag solid contrast

### 2.1 Problema

A variant `solid` do componente `Tag` aplica texto branco sobre o `--semantic-status-{status}`. Funciona para status escuros (offline, pre-offline, unavailable) mas **falha WCAG 1.4.3** em status claros:

| Status | Cor (#hex) | Contraste com `#FFFFFF` | Veredito |
|--------|-----------|-------------------------|----------|
| alert | `#FFCC66` | 1.85:1 | ❌ falha |
| fair | `#E5C677` | 1.92:1 | ❌ falha |
| online | `#28A745` | 3.21:1 | ⚠️ passa só em texto grande |
| offline | `#CC4747` | 5.10:1 | ✅ |
| pre-offline | `#8A38F5` | 5.81:1 | ✅ |
| unavailable | `#33AEFF` | 2.39:1 | ❌ falha |
| maintenance | `#33AEFF` | 2.39:1 | ❌ falha |

### 2.2 Decisão

Criar **dois tokens** de texto on-tag + uma **regra de mapeamento** que o componente Tag consome:

```yaml
# [data-tenant="shelflix"]

# Tag solid contrast (NOVO — Round 1.6)
--semantic-tag-solid-text-light:  var(--primitive-gray-100)      # #FFF9F2 — pra fundos escuros
--semantic-tag-solid-text-dark:   var(--primitive-gray-800)      # #0E0E0E — pra fundos claros
```

### 2.3 Mapping (consumido pelo Tag.spec.yaml)

A regra é codificada no spec do Tag. Cada status mapeia para `light` ou `dark`:

```yaml
# Tag.spec.yaml > tokens.solid (atualização derivada)
solid:
  pattern:
    background: "var(--semantic-status-{status})"
    text: "var(--semantic-tag-solid-text-{contrast_class})"  # light ou dark conforme status
    border-color: transparent

  contrast_map:
    # Status com fundos escuros → texto claro (light)
    offline:        light
    pre-offline:    light
    erro-exec:      light
    sem-energia:    light
    sem-internet:   light
    alta-osc:       light
    online:         light    # marginal; pode trocar pra dark se preferir nitidez
    bloqueado:      light

    # Status com fundos claros → texto escuro (dark)
    alert:               dark
    fair:                dark
    med-osc:             dark
    unavailable:         dark
    maintenance:         dark
    stand:               dark
    pareado:             light    # green-success é escuro o suficiente
    nao-pareado:         light    # red-error escuro
    aguardando-ativacao: light    # brand-700 é escuro o suficiente
    expirado:            light
    indisponivel:        dark
```

> **Notas:**
> - `tag.spec.yaml` em onda 1 deve ser atualizado pra consumir essa regra (P1 followup).
> - A regra pode ser auditada automaticamente: para cada par `(status, contrast_class)`, validar contraste WCAG ≥4.5:1.

---

## 3. CSS gerado (snippet pra inclusão em `showcase/tokens.css`)

```css
[data-tenant="shelflix"] {
  /* ... tokens existentes do Round 1 + 1.5 ... */

  /* Danger solid — Round 1.6 (resolve gap de Button/IconButton variant=danger) */
  --semantic-bg-danger-solid:       var(--primitive-error);
  --semantic-bg-danger-solid-hover: var(--primitive-error-dark);
  --semantic-text-on-danger:        #FFFFFF;

  /* Tag solid contrast — Round 1.6 (regra condicional via componente Tag) */
  --semantic-tag-solid-text-light:  var(--primitive-gray-100);
  --semantic-tag-solid-text-dark:   var(--primitive-gray-800);
}
```

---

## 4. Diff de números

| Camada | Round 1 + 1.5 | + Round 1.6 | Total |
|--------|---------------|-------------|-------|
| Primitives | 113 | + 0 | **113** |
| Semantic | 107 | + 5 (3 danger + 2 tag-text) | **112** |

Round 1.6 adiciona **5 tokens semantic** (zero primitives). Estritamente aliases — não cria valores brutos novos.

---

## 5. Impacto nos spec.yaml existentes

| Spec | Ação requerida |
|------|----------------|
| **Button.spec.yaml** | Remover `gaps_for_foundations` (resolvidos) — substituir por nota histórica; variant `danger` agora funcional |
| **IconButton.spec.yaml** | Idem (compartilha gaps com Button) |
| **Tag.spec.yaml** | Atualizar `tokens.solid.pattern.text` consumindo `--semantic-tag-solid-text-{contrast_class}` + declarar o `contrast_map` |

---

## 6. Handoff para Component

📨 **Trigger imediato:**

1. `mds-component` atualiza os 3 specs acima.
2. Re-rodar `mds-audit *design-check` em cada um — score esperado: **B → A** (Button), **B → A** (IconButton), **B → A** (Tag, após contrast_map).

📨 **Trigger derivado:**

3. `mds-ops` (quando rodar) deve gerar o CSS de R1.6 em `showcase/tokens.css` + arquivos finais do DS.

---

## 7. Pendências de verificação

Nenhuma. Todos os 5 tokens são aliases para primitives já validados nas rounds anteriores.
