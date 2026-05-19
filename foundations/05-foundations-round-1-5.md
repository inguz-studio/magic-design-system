# Foundations Report — Round 1.5 Update

> ⚠️ **SUPERSEDED por `07-token-architecture-v3.md` em 2026-05-19.**
> Este doc fica como referência histórica. Para arquitetura atual, ver `07-v3` (mecânica) + `08-arquitetura-3-andares.md` (conceito).

**Agent:** mds-foundations (Architect)
**Command:** `*build-foundations` (delta update)
**Tenant:** shelflix
**Mode:** **dark-first** (revisão de premissa do Round 1)
**Date:** 2026-05-13
**Status:** ⏳ Aguardando aprovação humana | ⏭️ Handoff: mds-governance + mds-component (fan-out P0)
**Supersedes:** trechos de `02-token-architecture.md` listados em §0 abaixo

---

## 0. Escopo desta atualização

Round 1.5 corrige premissa de scoping e adiciona 3 categorias de token novas, baseado em achados de [audit/04-figma-complete-audit.md](../audit/04-figma-complete-audit.md). **Não invalida Round 1** — apenas:

| Item | Round 1 dizia | Round 1.5 corrige para |
|------|---------------|------------------------|
| Tema default | `light` (com `dark` como override) | **`dark` (com `light` como capacidade futura)** |
| Sidebar expanded width | `11rem (176px)` | `14.5rem (232px)` — verificar com Figma |
| Data viz tokens | ausentes | **6 séries + grid + axis + tooltip** |
| `--semantic-status-pre-offline` | implícito (info-alt sem semântica) | **explicitado** |
| `--semantic-status-fair` | inexistente | **criado** (amarelo "Bom" ≠ amarelo "Alerta") |
| `--semantic-type-action` (Button SemiBold) | gap declarado no Button.spec.yaml | **criado** (resolve override) |

---

## 1. Mudança de premissa — dark-first

### 1.1 Decisão
Tenant `shelflix` opera apenas em **dark mode** no curto/médio prazo. Light mode permanece como **capacidade arquitetural** (não foi deletado dos tokens) mas deixa de ser default.

### 1.2 Reescopo da arquitetura CSS

**Antes (Round 1):**
```css
[data-tenant="shelflix"][data-theme="light"] { /* tokens light */ }
[data-tenant="shelflix"][data-theme="dark"]  { /* tokens dark */ }
```

**Agora (Round 1.5):**
```css
/* Tenant shelflix — dark é o default operacional */
[data-tenant="shelflix"] {
  /* tokens semantic em modo dark (default) */
  --semantic-bg-canvas: var(--primitive-gray-800);
  --semantic-text-primary: var(--primitive-gray-100);
  /* ... */
}

/* Capacidade preservada — light como override opcional */
[data-tenant="shelflix"][data-theme="light"] {
  --semantic-bg-canvas: var(--primitive-gray-100);
  --semantic-text-primary: var(--primitive-gray-800);
  /* ... */
}
```

**Por que isso muda código real:**
- Devs não precisam mais setar `data-theme="dark"` em todo lugar — é o default
- Multi-tenant futuro continua funcionando: novo tenant escolhe seu próprio default
- Light continua suportado pra clientes que pedirem (capacidade preservada)

### 1.3 Valores dark do Round 1 promovidos a default

Os valores em §3.2 do `02-token-architecture.md` (Semantic — Dark mode) **viram o default** do tenant shelflix. Os valores light de §3.1 **viram override condicional**. Nenhuma cor muda — só o que está dentro de qual seletor.

---

## 2. Layer 1 — PRIMITIVES adicionadas

### 2.1 Data viz — chart chrome (NOVA categoria)

Apenas chrome estrutural do chart (grid, eixos, tooltips). **Séries coloridas vivem na camada Semantic** (§3.2) com duas paletas separadas — categórica e semântica — pra suportar charts neutros (regiões/marcas) e charts com significado (positivo/negativo).

```yaml
# Chart chrome (eixos, grids, tooltips)
--primitive-chart-grid:           'rgba(255, 255, 255, 0.08)'  # linha de grid sutil em dark
--primitive-chart-axis-label:     var(--primitive-gray-400)    # labels de eixo
--primitive-chart-tooltip-bg:     var(--primitive-gray-700)    # fundo de tooltip
--primitive-chart-tooltip-border: var(--primitive-gray-500)
```

### 2.2 Status fair (token NOVO — confirmado pelo usuário)

Amarelo "Bom" usado em Conectividade Geral — **diferente** do amarelo "Alerta" (`--primitive-warning`). Mais quente, mais desaturado.

```yaml
--primitive-status-fair-light: '#F2D88E'  # interpolado (lighter)
--primitive-status-fair:       '#E5C677'  # base — amarelo desaturado/dourado
--primitive-status-fair-dark:  '#B89A4F'  # interpolado (darker)
```

⚠️ **Valor proposto baseado em inferência do Dashboard.** Precisa ser confirmado contra `get_variable_defs` do Figma (`46:565 Feedback Colors` ou similar) quando reauth do MCP estabilizar. Se vier valor exato diferente, **só este token muda** — propagação automática via aliases.

### 2.3 Updates em primitives existentes

```yaml
# Sidebar width — atualização baseada em Dashboard real
--primitive-size-sidebar-collapsed: '4rem'      # 64px (inalterado)
--primitive-size-sidebar-expanded:  '14.5rem'   # 232px (era 11rem/176px) ⚠️ verificar Figma
```

---

## 3. Layer 2 — SEMANTIC adicionadas

### 3.1 Status semantic — formalização (DARK como default)

Tokens que **não eram nomeados** em Round 1 mas eram usados de fato no Dashboard. Agora ganham nome semântico, com fallback para os primitives já existentes:

```yaml
# [data-tenant="shelflix"]   (default dark)

# Status semânticos (mapeamento status de negócio → cor)
--semantic-status-online:        var(--primitive-success)         # verde
--semantic-status-offline:       var(--primitive-error)           # vermelho
--semantic-status-alert:         var(--primitive-warning)         # amarelo
--semantic-status-fair:          var(--primitive-status-fair)     # 🆕 amarelo dourado (Bom)
--semantic-status-unavailable:   var(--primitive-info)            # azul (Indisponível)
--semantic-status-pre-offline:   var(--primitive-info-alt)        # 🆕 roxo (Pré-offline)
--semantic-status-maintenance:   var(--primitive-info)            # azul (mesma cor de Indisponível) - mesma família, semântica diferente

# Backgrounds derivados (para Tag/Chip com fundo tint)
--semantic-status-online-bg:        'rgba(40, 167, 69, 0.16)'      # success @ 16%
--semantic-status-offline-bg:       'rgba(204, 71, 71, 0.16)'      # error @ 16%
--semantic-status-alert-bg:         'rgba(255, 204, 102, 0.16)'    # warning @ 16%
--semantic-status-fair-bg:          'rgba(229, 198, 119, 0.16)'    # fair @ 16%
--semantic-status-unavailable-bg:   'rgba(51, 174, 255, 0.16)'     # info @ 16%
--semantic-status-pre-offline-bg:   'rgba(138, 56, 245, 0.16)'     # info-alt @ 16%
```

**Por que `status-*` é uma família separada de `bg-success/warning/error`:** o componente `Tag` consome `--semantic-status-*` (cor por estado de negócio). Botões/Toasts consomem `--semantic-bg-success/warning/error/info` (cor por intent UI). Mesma primitive, semântica diferente.

### 3.2 Data viz semantic — duas paletas (categórica + semântica)

**Decisão (Round 2):** charts do Shelflix se dividem em dois tipos. Cada tipo consome uma paleta diferente. Componentes de chart escolhem pela prop `palette`:

```yaml
# [data-tenant="shelflix"]

# ── 3.2.1 PALETA CATEGÓRICA ──────────────────────────────────────────
# Use quando as séries NÃO têm significado intrínseco (regiões, marcas,
# períodos comparados). Ordem otimizada para máximo contraste visual.
--semantic-chart-series-1:  var(--primitive-info)         # azul
--semantic-chart-series-2:  var(--primitive-brand-700)    # laranja (marca Shelflix)
--semantic-chart-series-3:  var(--primitive-success)      # verde
--semantic-chart-series-4:  var(--primitive-info-alt)     # roxo
--semantic-chart-series-5:  var(--primitive-warning)      # amarelo
--semantic-chart-series-6:  var(--primitive-error)        # vermelho

# ── 3.2.2 PALETA SEMÂNTICA ───────────────────────────────────────────
# Use quando as séries TÊM significado (Conformes/Não Conformes/Meta,
# Online/Offline, etc.). A cor reforça a leitura.
--semantic-chart-status-positive: var(--primitive-success)         # verde (Conformes, Online)
--semantic-chart-status-negative: var(--primitive-error)           # vermelho (Não Conformes, Offline)
--semantic-chart-status-neutral:  var(--primitive-warning)         # amarelo (Meta, Alvo)
--semantic-chart-status-info:     var(--primitive-info)            # azul (Indisponível)
--semantic-chart-status-fair:     var(--primitive-status-fair)     # amarelo dourado (Bom)
--semantic-chart-status-pre:      var(--primitive-info-alt)        # roxo (Pré-offline)

# ── 3.2.3 CHROME (compartilhado entre as duas paletas) ───────────────
--semantic-chart-grid:           var(--primitive-chart-grid)
--semantic-chart-axis-label:     var(--primitive-chart-axis-label)
--semantic-chart-tooltip-bg:     var(--primitive-chart-tooltip-bg)
--semantic-chart-tooltip-border: var(--primitive-chart-tooltip-border)
```

**Como o componente escolhe a paleta:**

```tsx
// Categórica (séries neutras)
<BarChart data={vendasPorRegiao} palette="series" />
// → série N consome --semantic-chart-series-N

// Semântica (séries com significado)
<LineChart
  data={tendenciaConformidade}
  series={[
    { label: 'Conformes',     color: 'status-positive' },
    { label: 'Não Conformes', color: 'status-negative' },
    { label: 'Taxa Alvo',     color: 'status-neutral'  },
  ]}
/>
// → cada série declara explicitamente qual --semantic-chart-status-* usa
```

**Mapeamento aos charts do Dashboard atual** (todos semânticos):
- "Tendência de Conformidade" (LineChart) → `status-positive` / `status-negative` / `status-neutral`
- "Conectividade Geral" (StackedBar) → `status-negative` / `status-negative` (Ruim mais claro) / `status-fair` / `status-positive` — ordinal mapeado em semantic
- "Saúde de transmissão" (RangeBars) → `status-positive` / `status-fair` / `status-neutral` / `status-negative`
- "Horas transmitidas" (Donut) → `status-positive` / `status-negative`
- "Distribuição de alertas" (List) → cada item consome `--semantic-status-*` direto (não chart palette)

### 3.3 Type action (NOVO — resolve gap do Button.spec.yaml)

Round 1 não tinha role tipográfico pra ação de UI. Button.spec.yaml declarou gap. Agora resolvido:

```yaml
--semantic-type-action: var(--primitive-text-sm) / var(--primitive-leading-none) / var(--primitive-weight-semibold)
# 14px / lh=1.0 / 600 — match exato do Figma "Button/Action"
```

**Impacto:** o `Button.spec.yaml` pode remover o `typography_override` e consumir `--semantic-type-action` diretamente.

### 3.4 Sidebar — semantic novo

```yaml
--semantic-sidebar-width-collapsed: var(--primitive-size-sidebar-collapsed)  # 64px
--semantic-sidebar-width-expanded:  var(--primitive-size-sidebar-expanded)   # 232px ⚠️
--semantic-sidebar-bg:              var(--semantic-bg-surface)
--semantic-sidebar-border:          var(--semantic-border-subtle)
--semantic-sidebar-item-bg-selected: var(--semantic-bg-brand)
--semantic-sidebar-item-text-selected: var(--semantic-text-on-brand)
--semantic-sidebar-item-bg-hover:   var(--semantic-bg-subtle)
```

---

## 4. Atualização de scoping CSS (final)

Estrutura completa pós Round 1.5:

```css
/* Layer 1 — Primitives (uma vez, raiz do documento) */
:root {
  /* cores, espaço, tipografia, radius, motion, sizing — Round 1 */
  /* + data viz palette — Round 1.5 */
  /* + status-fair — Round 1.5 */
}

/* Layer 2 — Semantic (tenant scoping, DARK default) */
[data-tenant="shelflix"] {
  /* todos os tokens semantic em valores dark
     - Round 1 §3.2 promovido a default
     - + status semantic (Round 1.5)
     - + chart semantic (Round 1.5)
     - + type action (Round 1.5)
     - + sidebar semantic (Round 1.5)
  */
}

/* Capacidade futura — light override */
[data-tenant="shelflix"][data-theme="light"] {
  /* overrides light de Round 1 §3.1 */
}

/* Multi-tenant futuro */
[data-tenant="<outro>"] { /* defaults do outro tenant */ }

/* Layer 3 — Component (preenchido por mds-component) */
/* Aliases --component-* — gerados a partir dos spec.yaml */
```

---

## 5. Diff resumido em números

| Camada | Round 1 | + Round 1.5 | Total |
|--------|---------|-------------|-------|
| Primitives | 64 cores + 6 type + 17 space + 13 size/radius + 6 motion = **106** | + 4 chart chrome + 3 status-fair = **7** | **113** |
| Semantic | 18 BG + 6 text + 5 border + 12 feedback + 8 type + 15 space + 5 radius/motion = **69** | + 7 status + 7 status-bg + 6 chart-series (categórica) + 6 chart-status (semântica) + 4 chart chrome + 1 type-action + 7 sidebar = **38** | **107** |

Round 1.5 adiciona **45 tokens** (7 primitive + 38 semantic) sem alterar nada existente. A camada Semantic carrega mais peso porque chart-series + chart-status são aliases (pertencem corretamente a semantic, não primitive).

---

## 6. O que isso destrava nos próximos passos

| Componente P0 | Tokens que precisava (e agora tem) |
|---------------|-----------------------------------|
| `Sidebar` + `NavItem` | `--semantic-sidebar-*` ✅ |
| `KpiCardShell` (wrapper) | `--semantic-bg-surface`, `--semantic-border-subtle` (já tinha) ✅ |
| `StatKpiCard` | `--semantic-status-*` (para progress bar com cor por status) ✅ |
| `DonutKpiCard` / `LineChart` / `StackedBarChart` | `--semantic-chart-series-*`, `--semantic-chart-grid`, `--semantic-chart-axis-label`, `--semantic-chart-tooltip-bg` ✅ |
| `DataTable` + `TableCell` + `Pagination` | nada novo — usa semantic do Round 1 ✅ |
| `Tag` (16 status) | `--semantic-status-*` + `--semantic-status-*-bg` ✅ |
| `Button` (atualização do piloto) | `--semantic-type-action` resolve override ✅ |

**Bloqueios remanescentes para componentes P0:** zero. Foundations Round 1.5 entrega tudo que P0 precisa.

---

## 7. Pendências de verificação

⚠️ **Itens marcados nesta atualização que precisam confirmação contra Figma quando MCP estabilizar:**

1. **`--primitive-status-fair: #E5C677`** — valor inferido visualmente. `get_variable_defs` no node de Feedback Colors deve confirmar.
2. **`--primitive-size-sidebar-expanded: 232px`** — Round 1 inferiu 176px do Figma `w-44`. Dashboard real mostra ~232px. Confirmar qual valor está no node `43:1008` (Menu) hoje.
3. **`--primitive-chart-tooltip-bg: gray-700`** — não vi tooltip aberto no Dashboard. Decisão técnica, pode ajustar quando aparecer.

Nenhum desses bloqueia P0 — todos têm valor default razoável.

---

## 8. Handoff para Governance + Component

📨 **Próximo agente principal:** `mds-component` (fan-out P0)

**Inputs disponíveis:**
- Todos os tokens semantic necessários ✅
- Audit doc com mapeamento Figma → componente canônico (§5.2 de `audit/04-*.md`)
- `templates/component.spec.template.yaml` como schema
- `Button.spec.yaml` como exemplo de instância

**Ordem sugerida (fan-out paralelo possível em 3 ondas):**

```
Onda 1 (independentes):
  ├── Sidebar.spec.yaml
  ├── NavItem.spec.yaml
  ├── Tag.spec.yaml             (16 status)
  ├── Pagination.spec.yaml
  └── IconButton.spec.yaml      (consolidação de Small Button + Botão Tabela + Question)

Onda 2 (dependem de Onda 1 ou compartilham wrapper):
  ├── KpiCardShell.spec.yaml    (wrapper compartilhado)
  ├── TableHeader.spec.yaml
  ├── TableCell.spec.yaml
  ├── Select.spec.yaml
  └── FilterBar.spec.yaml       (usa Select internamente)

Onda 3 (compõem dos anteriores):
  ├── StatKpiCard.spec.yaml     (extends KpiCardShell)
  ├── DonutKpiCard.spec.yaml    (extends KpiCardShell)
  ├── LineKpiCard.spec.yaml     (extends KpiCardShell)
  ├── StackedBarKpiCard.spec.yaml
  ├── RangeBarsKpiCard.spec.yaml
  ├── RankedListKpiCard.spec.yaml
  └── DataTable.spec.yaml       (compõe TableCell + TableHeader + Pagination)

Atualização paralela:
  └── Button.spec.yaml          (consome --semantic-type-action; remove typography_override)
```

📨 **Trigger paralelo opcional:** `mds-governance` pode rodar `*enforce-rules` agora sobre o Round 1.5 antes de Component iniciar — pega drift de naming antes de propagar.
