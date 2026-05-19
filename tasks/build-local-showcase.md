---
title: "Construção do Local Showcase"
description: "Montagem de showroom navegavel (Topbar + Sidebar 8 secoes) para visualização em tempo real do Design System gerado."
---

# Objetivo
Como o Magic-DS atua em regime 100% Code-First e não dependemos de visualizações no Figma, o pipeline precisa gerar uma vitrine (Showroom) navegável para auditoria humana final.

# Arquitetura padrão do Showroom (Round 5 — IA 8-section)

**Default obrigatorio pra TODO squad de DS derivado.** Estrutura canonica:

```
TOPBAR GLOBAL
├── Logo + tag DS
├── Search global (filtra nav-items + tokens + components)
├── Tenant tabs (Default / Tenant A / B / C — placeholders ate squad declarar)
├── Toggle Light/Dark (icone sun/moon)
└── Links rapidos (Figma + Repo)

SIDEBAR — 8 SECOES
├── 1. Home (overview + status + links)
├── 2. Foundations
│   ├── Colors
│   ├── Typography
│   ├── Spacing
│   ├── Radius
│   ├── Shadows
│   ├── Iconography
│   ├── Motion
│   └── Grid
├── 3. Tokens
│   ├── Overview
│   ├── Primitive
│   ├── Semantic
│   ├── Theme
│   ├── Component
│   ├── Token Chain
│   └── Deprecated
├── 4. Themes
│   ├── Overview
│   ├── Light Mode
│   ├── Dark Mode
│   ├── Theme Tokens
│   └── Theme Preview
├── 5. Atomic Design
│   ├── Atoms
│   ├── Molecules
│   ├── Organisms
│   ├── Templates
│   └── Pages
├── 6. Components (categorizados por comportamento)
│   ├── Overview
│   ├── Actions
│   ├── Forms
│   ├── Navigation
│   ├── Data Display
│   ├── Feedback
│   ├── Overlays
│   ├── Layout
│   └── Utilities
├── 7. Examples
│   ├── Dashboard
│   ├── Table Page
│   ├── Form Page
│   ├── Login
│   ├── Settings
│   ├── Empty State
│   └── Error State
└── 8. Resources
    ├── Figma Library
    ├── Code / Repo
    ├── Icons
    ├── Templates
    └── Brand Assets

FOOTER da sidebar
├── Product selector (Admin / Mission / Original / etc.)
└── Density selector (Comfortable / Compact)
```

## Por que esse padrão

- **Bridge cognitivo:** novo dev em qualquer squad reconhece a IA. Onboarding rapido.
- **Multi-product friendly:** topbar tabs + sidebar product selector cobrem tenant + product overrides.
- **Quality Pillar ready:** quando squad adicionar lens nova (content/brand/performance), adiciona secao 9+ ou subsecao em Resources.
- **Decisao do conselho:** mds-orchestrator + squad-orchestrator (2026-05-18) — registrado em governance/ui-ux-ownership.md §6.

## Overrides permitidos

Projeto pode override seções via `squad-policy.yaml.showroom_overrides`:

```yaml
showroom_overrides:
  hide_sections: []           # ex: [examples] se projeto e DS-only sem app
  rename_sections:            # ex: { atomic: "Components Library" }
    atomic: <custom-name>
  add_sections: []            # ex: [analytics, branding] pra futuras lenses
```

Default: nenhum override. Estrutura 8-section completa.

# Steps
1. Consolidar os tokens JSON gerados nas etapas anteriores.
2. Ler a arquitetura de múltiplos temas (Tenants/Light/Dark) mapeada.
3. Gerar um arquivo `showcase.html` na raiz da extração (ou na subpasta de documentação do projeto).
4. O `showcase.html` deve usar Tailwind v4 CDN ou estar atrelado ao bundle gerado localmente, injetando as variáveis nativas (`--var`) na tag `<style>` global ou via diretiva `@theme`.
5. Estruturar a UI do Showcase da seguinte forma:
   - Header com seletor de Tenant (Dropdown ou Botões simulando mudança de `[data-tenant]`) e Toggle Light/Dark.
   - Bloco 1: **Cores** (Rampas Primitives e Semantics renderizadas em grids quadrados).
   - Bloco 2: **Tipografia** (Títulos de H1 a H6 e parágrafos de corpo exibindo font-family e pesos aplicados).
   - Bloco 3: **Componentes Físicos** (Botões e Inputs renderizados ao vivo consumindo os estilos finais gerados).
6. Garantir que o código HTML seja autossuficiente e possa ser aberto num clique duplo pelo navegador, provendo feedback imediato do Design System sem necessidade de `npm run dev`.

# Persistence Contract (Round 4 — W3.2)

Showroom DEVE persistir as escolhas do user entre sessoes via `localStorage`.

## Keys padronizadas

Cada key prefixada com `<prefix>` (de `squad-policy.yaml.token_prefix`):

| Key | Valores | Default |
|---|---|---|
| `<prefix>-ds-mode` | "dark" \| "light" | "dark" |
| `<prefix>-ds-product` | nome do produto (ex: "shelflix-admin") | primeiro listado |
| `<prefix>-ds-density` | "" \| "compact" | "" (comfortable) |

**Exemplo (prefix sf):**
- `sf-ds-mode = "light"` → showroom abre em light mode
- `sf-ds-product = "shelflix-mission"` → showroom abre com produto Mission

## Restore order

Ao abrir o showroom:
1. Le localStorage
2. Se chave existe → aplica via `document.documentElement.dataset.theme/product/density`
3. Se ausente → usa default
4. **NAO** usa URL hash pra persistir (hash e usado por router pra rota ativa)

## Save order

Quando user troca selector:
1. Atualiza `document.documentElement.dataset.*` (renderiza tokens)
2. Salva em `localStorage.setItem(<prefix>-ds-<key>, value)`
3. Nao reload — Vite HMR ja pega via cascade CSS

## Reset

Botao "Reset DS state" no rodapé do menu (opcional) — limpa as 3 keys + reload.

## Code reference

Implementacao canonica em `src/showroom/showcase.js` no projeto destino:

```js
const LS_KEY_MODE = `${PREFIX}-ds-mode`;
const LS_KEY_PRODUCT = `${PREFIX}-ds-product`;
const LS_KEY_DENSITY = `${PREFIX}-ds-density`;

function wireSwitchers() {
  const savedMode = localStorage.getItem(LS_KEY_MODE) || "dark";
  document.documentElement.dataset.theme = savedMode;
  // ... etc
}
```

Ops gera esse contrato automaticamente em `*build-local-showcase`.

## Validation

Audit do showroom (`mds-audit *audit-showcase`) inclui check de persistencia:
- LS keys batem com prefix declarado
- Restore funciona (refresh mantem state)
- Reset funciona (clear LS → defaults voltam)
