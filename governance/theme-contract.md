# Token Set Contract — Coberturas minimas por set

**Status:** Adotado (Round 4 — substitui Theme Contract v2)
**Substitui:** Theme Contract v2 (5-camadas, --theme-* exclusivo)
**Consumido por:** `mds-governance` (gate) + `mds-tokens` (validacao) + `mds-ops` (build)
**Data:** 2026-05-18

---

## 0. Proposito

Define o **conjunto minimo de tokens** que cada **token set** em tokens.json deve fornecer pra ser valido. Sets sao a unidade de override na arquitetura v3 (3 camadas).

Razao: trocar background canvas de um produto exige tambem trocar text-primary, border-default, etc. Override parcial gera UI inconsistente. Token Set Contract garante que ninguem entregue set incompleto.

---

## 1. Set canonico `semantic-dark` (default, obrigatorio)

Todo projeto declarando o squad deve ter `semantic-dark` populado. E o set base que outros sets sobrescrevem.

### 1.1 Tokens obrigatorios (28)

| Grupo | Tokens |
|---|---|
| **bg** (4) | canvas, surface, subtle, muted |
| **text** (5) | primary, secondary, tertiary, disabled, brand |
| **border** (3) | default, subtle, strong |
| **actionPrimary** (5) | bg, bgHover, bgPressed, bgSubtle, text |
| **status** (3 × 3) | success/warning/danger × bg/text/border |

### 1.2 Tokens recomendados (nao bloqueia, mas warning)

- `text.onBrand`, `text.inverse`, `text.onElevated`
- `border.brand`, `border.focus`
- `accent.default`, `accent.subtle`, `onAccent`
- `nav.activeBg`, `nav.activeText`
- `bg.inverse`, `bg.elevated`, `bg.overlay`
- `actionDanger.{bg,bgHover,text}`
- `status.info.{bg,text,border}`

---

## 2. Set `semantic-light` (opcional — necessario se squad-policy declara light mode)

Quando declarado, deve sobrescrever pelo menos estes 14 tokens:

| Grupo | Tokens minimos |
|---|---|
| **bg** | canvas, surface, subtle, muted |
| **text** | primary, secondary, tertiary, disabled |
| **border** | default, subtle, strong |
| **status** | success.text, warning.text, danger.text |

Razao: trocar bg sem trocar text quebra contraste WCAG.

---

## 3. Set `product-<name>` (opcional, por produto)

Quando declarado pra `<name>`, deve sobrescrever pelo menos a "identidade" do produto:

### 3.1 Minimo pra produto que muda cor de marca

| Grupo | Tokens |
|---|---|
| **actionPrimary** | bg, bgHover, bgPressed, bgSubtle, text |
| **nav** | activeBg, activeText (se nav usa cor de marca) |

### 3.2 Minimo pra produto que muda visual completo (Mission flat/dark)

| Grupo | Tokens |
|---|---|
| **bg** | canvas, surface, subtle |
| **text** | primary, secondary |
| **border** | default, subtle |
| **status** | success.{bg,text,border}, danger.{bg,text,border} |

---

## 4. Set `density-<level>` (opcional)

Sobrescreve apenas size + space tokens. Minimo:

| Grupo | Tokens |
|---|---|
| **size.control** | sm, md, lg |
| **space.inset** | md, lg |
| **space.stack** | md, lg |

---

## 5. Set `reduce-motion` (opcional — recomendado pra A11y AA+)

Sobrescreve **todos** os tokens em `motion.*` pra `0ms linear`. Validator garante que todos os 9 motion roles estao presentes.

---

## 6. Refs cross-set sao permitidas

Set pode referenciar tokens de outros sets:

```json
{
  "product-mission": {
    "actionPrimary": {
      "bg": { "$value": "{primitive.color.orange.500}" }
    }
  }
}
```

Esse `{primitive.*}` resolve cross-set. Build script garante que `--<prefix>-action-primary-bg` no scope `[data-product="mission"]` aponta pra `var(--<prefix>-primitive-orange-500)`.

---

## 7. $themes (combinacoes ativas)

Ao declarar set, tambem declarar `$themes` listando combinacoes ativas pra Tokens Studio:

```json
"$themes": [
  {
    "id": "admin-dark",
    "name": "Admin Dark",
    "selectedTokenSets": { "primitive": "source", "semantic-dark": "enabled" }
  },
  {
    "id": "mission-dark",
    "name": "Mission Dark",
    "selectedTokenSets": {
      "primitive": "source",
      "semantic-dark": "enabled",
      "product-mission": "enabled"
    }
  }
]
```

---

## 8. Enforcement

### mds-tokens `*validate-json` checa:
1. `semantic-dark` existe e tem os 28 tokens minimos
2. Se `semantic-light` declarado, tem os 14 minimos
3. Se `product-<name>` declarado, tem o minimo do tipo (3.1 ou 3.2)
4. Se `reduce-motion` declarado, cobre todos os 9 motion roles
5. Todo set declarado em `$metadata.tokenSetOrder` aparece como key no JSON
6. Todo `$theme` referencia sets que existem
7. Todas as refs `{...}` resolvem

### mds-governance bloqueia ops quando:
- Algum required falta em set obrigatorio
- Set inconsistente entre dark e light (ex: light declara `bg.canvas` mas nao `text.primary`)

---

## 9. Diferenca vs v2

| v2 (5 camadas) | v3 (3 camadas) |
|---|---|
| Theme Contract focado em `--theme-*` | Set Contract cobre cada token set nomeado |
| 10 `--theme-*` required + 6 opcional | 28 tokens minimos em `semantic-dark`, outros sets tem seu proprio minimo |
| Fallback automatico pra Brand Core | Fallback via cascade CSS (set anterior na ordem) |
| Validacao em CSS bruto | Validacao em JSON (estruturada, refs verificaveis) |
