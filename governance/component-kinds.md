# Component Kinds — Generic vs Domain

**Status:** Proposta de adoção (Round 2)
**Consumido por:** `mds-component` (schema spec) + `mds-governance` (validação) + `mds-ops` (estrutura output) + showroom (organização visual)
**Data:** 2026-05-14

---

## 0. Definições

**Generic** — componentes UI reutilizáveis em qualquer DS. Resolvem problemas universais: clicar (Button), inserir texto (Input), agrupar (Card), navegar (Tabs).

**Domain** — componentes específicos do domínio de um tenant. Resolvem problemas de negócio: monitorar prateleiras (ShelfMonitor), visualizar KPI categórico (DonutKpi, RangeBarsKpi), estado de batch (BatchStatus). Não fazem sentido fora do contexto Shelflix.

**Background** — categoria especial pra componentes de fundo da aplicação (AppBackground). Variants (solid/gradient/animated/image/pattern) controladas pelo Theme via `background.kind`. Mora em `component/background/`.

**Todos seguem as MESMAS regras técnicas:** BEM, tokens, zero-Radix, design-check, validate-output. Diferença é apenas **organizacional + opt-in**.

---

## 1. Como diferenciar na prática

| Pergunta | Generic | Domain |
|---|---|---|
| Outro DS (Material, Carbon, Chakra) tem algo equivalente? | Sim ou aproximado | Não |
| Faz sentido em um produto de outro setor (fintech, saúde, e-commerce)? | Sim | Não |
| O nome do componente referencia conceito de negócio? | Não | Sim (Shelf, KpiCard, Batch) |
| Pode ser publicado num pacote NPM público sem confidencialidade? | Sim | Talvez não |
| Theme troca a aparência? | Sim, via Semantic + Theme | Sim, mesma cadeia |
| Theme troca a estrutura/comportamento? | Não | Não |

**Heurística rápida:** se o nome inclui sufixo do domínio (Kpi, Shelf, Batch, Inventory, Stock) — é domain. Se é genérico (Button, Modal, Tabs) — é generic.

---

## 2. Schema spec.yaml — campo `kind:`

Todo spec declara explicitamente:

```yaml
# squads/magic-ds/component/generic/Button.spec.yaml
name: Button
kind: generic                    # ← obrigatório
version: 1.0.0
status: stable
bem:
  block: btn
  elements: [icon, label]
  modifiers: [primary, secondary, danger, sm, md, lg]
# ...
```

```yaml
# squads/magic-ds/component/domain/DonutKpi.spec.yaml
name: DonutKpi
kind: domain                     # ← obrigatório
version: 1.0.0
status: stable
domain:
  tenant_origin: shelflix        # quem criou
  business_concept: "KPI categórico visualizado como rosca"
  use_cases:
    - "Conformidade de prateleiras (% conformes vs não-conformes)"
    - "Distribuição de status entre N categorias"
bem:
  block: donut-kpi
  elements: [chart, legend, value, label]
  modifiers: [sm, md, lg]
# ...
```

**Default:** se `kind:` está ausente, governance assume `generic` E warning ("missing-kind-declaration"). Recomendado declarar sempre.

---

## 3. Regras invariantes (idênticas pros dois)

Sem exceção, ambos generic e domain:

1. ✅ Seguem BEM raso (máx 2 níveis).
2. ✅ Consomem tokens via `var(--...)` — nunca cores hardcoded.
3. ✅ Passam por design-check (score ≥ B).
4. ✅ Passam por validate-output (zero leaks).
5. ✅ Têm canonical HTML + canonical CSS.
6. ✅ Têm A11y nativa (zero Radix/shadcn).
7. ✅ Declaram `rhythm:` (vertical rhythm).
8. ✅ Documentados no showroom.

---

## 4. Diferenças operacionais

### 4.1 Estrutura de arquivos

```
squads/magic-ds/component/
├── generic/
│   ├── Button.spec.yaml
│   ├── IconButton.spec.yaml
│   ├── Tag.spec.yaml
│   └── ...
└── domain/
    ├── DonutKpi.spec.yaml
    ├── ListKpi.spec.yaml
    └── ...

squads/magic-ds/output/
├── html/                       # flat — block name é namespace único
│   ├── btn.html
│   ├── donut-kpi.html
│   └── ...
└── css/
    ├── btn.css
    ├── donut-kpi.css
    └── ...

src/components/                 # React adapter — Atomic Design ortogonal
├── atoms/Button/
├── organisms/DonutKpi/         # domain pode estar em qualquer nível atomic
└── ...
```

**Justificativa pra output flat:** BEM block name (`.btn`, `.donut-kpi`) já é único globalmente. Adicionar `output/css/domain/donut-kpi.css` só quebra imports existentes em `canonical.css` sem ganho de clareza.

### 4.2 Theme Contract

Generic é **sempre disponível** — Theme Contract não menciona.

Domain é **opt-in por theme**:

```yaml
# squads/magic-ds/themes/shelflix-admin.yaml
product: shelflix-admin
adopts_domain:
  - DonutKpi
  - ListKpi
  - RangeBarsKpi
  - StackedBarKpi
  - RankedListKpi
```

```yaml
# squads/magic-ds/themes/inguz-X.yaml (hipotético, futuro)
product: inguz-X
adopts_domain:
  - DonutKpi                # Inguz quer DonutKpi do Shelflix
  # outros não adotados — não carrega CSS, não polui bundle
```

**Compilação:** `mds-ops` gera `output/themes/<product>.css` só com os domain components adotados — bundle do produto Inguz-X não carrega `range-bars-kpi.css`.

### 4.3 Showroom (organização visual)

```
showroom/
├── /tokens                    # Foundation
├── /generic                   # aba: Button, Card, Tag, NavItem, …
├── /domain                    # aba: DonutKpi, ListKpi, … (visível só pra tenants que adotam)
├── /patterns                  # composições
├── /themes                    # switcher entre produtos
└── /audit                     # DS Inspector
```

Cada aba lista componentes da sua categoria. Domain mostra badge "Shelflix-only" se o usuário está navegando em outro tenant context.

### 4.4 Versioning

Domain pode evoluir mais rápido que Generic. Justificativa: domain reflete negócio que muda; generic reflete UI que é estável.

- Generic: minor bumps semestrais, major raros.
- Domain: minor bumps mensais, major quando há mudança de conceito de negócio.

---

## 5. Adoption model (cross-tenant)

Domain components moram num **catálogo compartilhado**. Tenants escolhem quais adotar.

### 5.1 Compatibilidade

Domain criado num tenant funciona em outro **se** o outro tenant declara os tokens necessários:

- DonutKpi consome `--semantic-score-good-*`, `--semantic-score-fair-*`, etc.
- Tenant Inguz precisa declarar esses tokens (ou herdar do Shelflix) pra adotar DonutKpi.
- Theme Contract de Inguz garante: `adopts_domain: [DonutKpi]` exige que os tokens referenciados pelo DonutKpi existam no escopo Inguz.

### 5.2 Validação cross-tenant

Governance verifica ao compilar:

```json
{
  "tenant": "inguz",
  "product": "inguz-X",
  "adopts_domain": ["DonutKpi"],
  "missing_tokens_for_domain": [
    "--semantic-score-good-bg (used by DonutKpi, not declared in Inguz semantic layer)"
  ],
  "ready_for_ops": false
}
```

Solução: tenant declara tokens faltantes OU desadota domain component.

---

## 6. Promoção generic ↔ domain

Componentes mudam de categoria quando:

### 6.1 Domain → Generic

Quando um domain é adotado por **3+ tenants** e não tem dependência específica de negócio:

- Renomear se necessário (`ShelflixKpi` → `Kpi`).
- Remover referências a domínio específico no spec.
- Mover de `component/domain/` → `component/generic/`.
- Atualizar Theme Contract pra tornar disponível por default.

### 6.2 Generic → Domain

Raro mas possível. Acontece quando um generic acumula lógica específica que não cabe em outros usos:

- Ex: `Button` ganha variante `Button--shelflix-cta-monitoring` muito específica → quebrar em `MonitoringCtaButton` (domain).
- Componente generic original mantém — não quebrar API existente.

---

## 7. Exemplos com componentes do repo atual

### 7.1 Inventário Round 1 classificado

| Componente | Kind sugerido | Razão |
|---|---|---|
| Button | generic | universal |
| IconButton | generic | universal |
| Tag | generic | universal (chips/labels) |
| NavItem | generic | navegação universal |
| Sidebar | generic | layout universal |
| Pagination | generic | universal |
| Select | generic | universal |
| FilterBar | generic | (limítrofe — depende de uso, default generic) |
| TableCell | generic | universal |
| TableHeader | generic | universal |
| KpiCardShell | generic | shell universal — slot recebe domain |
| StatKpiCard | **domain** | KPI estatístico Shelflix-specific |
| DonutKpi | **domain** | KPI categórico Shelflix |
| ListKpi | **domain** | KPI lista Shelflix |
| StackedBarKpi | **domain** | KPI Shelflix |
| RangeBarsKpi | **domain** | KPI Shelflix |
| RankedListKpi | **domain** | KPI Shelflix |

**Achado importante:** `KpiCardShell` é generic (shell genérico que recebe slot), os 5 variants são domain (preenchem o shell com lógica de negócio). Isso é composição correta — generic provê estrutura, domain provê conteúdo.

### 7.2 Componentes faltando

Generic faltando (sem spec):
- ChartSeriesLegend, Skeleton, Tooltip, Toast, Dialog, Popover

Domain Shelflix conhecidos faltando:
- ShelfMonitor (provavelmente), BatchStatusTag, InventoryHealthBar, etc.

Mapear esses na Etapa 2 (extrair componentes restantes — seu objetivo macro).

---

## 8. Próximos passos

1. Adicionar campo `kind:` em todos os 12 specs existentes.
2. Criar 5 specs faltantes pros KPI variants órfãos de spec (`DonutKpi`, `ListKpi`, `RangeBarsKpi`, `StackedBarKpi`, `RankedListKpi`) — marcados como `kind: domain`.
3. Mover specs pra subpastas `generic/` e `domain/` (atualizar Librarian indexação).
4. Atualizar Theme Contract de shelflix-admin com `adopts_domain: [...]` apontando pros 5 + StatKpiCard.
5. Atualizar `mds-component`, `mds-governance`, `mds-ops` pra reconhecer o campo `kind:` (parte do A.2).
