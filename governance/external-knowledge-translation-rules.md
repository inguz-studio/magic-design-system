# External Knowledge — Translation Rules

**Status:** Adotado (Round 5)
**Consumido por:** todas as absorcoes de fontes externas (skills, libraries, design systems)
**Primeira aplicacao:** ui-ux-pro-max-skill (2026-05-18)

---

## 0. Proposito

Sempre que o squad absorver conhecimento de **fonte externa** (skill, lib, repo, doc), as regras abaixo se aplicam pra TRADUZIR a fonte pro vocabulario do nosso squad **sem perder atribuicao**.

Reusable pattern: cada nova absorcao segue essa mesma traducao.

---

## 1. Quando aplicar

- Importacao de checklists/guidelines de outra ferramenta
- Cherry-pick de regras de outro DS
- Absorcao de patterns/recipes de skills externas
- Documentacao de bibliotecas que viram referencia

---

## 2. Regras de traducao (canonical)

### 2.1 Cores / tokens hardcoded

| Origem (fonte externa) | Tradução (nosso squad) |
|---|---|
| `#FF6B00`, `rgba(229, 115, 0, 0.12)` | `var(--<prefix>-action-primary-bg)` ou equivalente semantico |
| `--btn-bg: #FF6B00` | `--btn-bg: var(--<prefix>-action-primary-bg)` |
| `color: blue-500` (Tailwind) | `color: var(--<prefix>-primitive-blue-500)` se primitive; ou semantic se faz sentido |
| `bg-primary-500` (Tailwind utility) | BEM canonical OU `bg-[var(--<prefix>-action-primary-bg)]` arbitrary |
| `--btn-radius: 8px` | `--btn-radius: var(--<prefix>-radius-control)` |
| `padding: 16px` | `padding: var(--<prefix>-space-inset-lg)` |
| `transition: 0.2s ease` | `transition: var(--<prefix>-motion-hover)` |

**Regra geral:** nenhum valor literal (hex, px, ms, rem) sobrevive a importacao. Tudo vira `var(--<prefix>-*)`.

### 2.2 Stack-specific references

| Origem | Tradução |
|---|---|
| React Native specifics | Generalizar pra React Web ou marcar como "futuro/mobile" |
| SwiftUI / iOS HIG | Manter atribuicao + adaptar pro spec equivalente Web |
| Flutter widgets | Generalizar para componente generico |
| Vue / Svelte specifics | Generalizar para componente generico |
| Tailwind utility classes | BEM canonical OU CSS arbitrary syntax |
| CVA (class-variance-authority) | Banido por policy — traduzir pra CSS variants em BEM |

### 2.3 Vendor primitives

| Origem | Tradução |
|---|---|
| Radix UI references | Se `vendor.allow_radix: true` e component esta na whitelist, manter. Caso contrario, traduzir pra A11y nativa. |
| shadcn/ui references | Mesma regra do Radix. |
| react-aria | Traduzir pra A11y nativa, citar como inspiracao |
| HeadlessUI | Mesma logica |

### 2.4 Arquitetura

| Origem | Tradução |
|---|---|
| 1-camada (flat tokens) | Distribuir nas nossas 3 camadas conforme natureza (fisico=primitive, papel=semantic, local=component) |
| Camadas diferentes (5+, hub-based, etc.) | Mapear pra nossas 3 camadas |
| `design-system` generators externos | Skip — temos `mds-foundations + mds-tokens + mds-ops` |
| Workflow CLI proprio | Skip — opera via squad agents, nao CLI externa |

### 2.5 Naming

| Origem | Tradução |
|---|---|
| camelCase em CSS var | kebab-case (`--sf-bg-canvas`, nao `--sfBgCanvas`) |
| BEM diferente | Manter nosso BEM (block__element--modifier) |
| Sem prefix | Adicionar `<prefix>` declarado em `squad-policy.yaml.token_prefix` |

### 2.6 Severity

| Origem | Tradução |
|---|---|
| `High` / `Critical` | **error** (bloqueia ops) |
| `Medium` / `Important` | **warning** (reporta, nao bloqueia) |
| `Low` / `Suggested` | **info** (stats) |
| `Anti-pattern` | **error** (deve falhar audit) |
| `Best practice` | **warning** ou **info** dependendo do gate |

### 2.7 Atribuicao

**Toda absorcao mantem header:**
```markdown
**Source:** <nome da fonte>
**Original:** <URL ou referencia>
**Imported:** YYYY-MM-DD
**Translation rules applied:** governance/external-knowledge-translation-rules.md
**License:** <verificar e citar>
```

**Toda regra absorvida cita origem inline:**
```markdown
### Regra X — Touch target minimum
**Source:** Apple HIG + ui-ux-pro-max #22
**Severity:** error (era High na fonte)
**Translation:** 44pt -> `var(--sf-primitive-size-control-md)` no nosso DS

Mantem 44px minimo pra elementos interativos.
```

---

## 3. O que NAO traduzir (manter literal)

- **Tradução conceitual de padrões de usabilidade** (Nielsen Heuristics, UX Laws) — manter texto original com atribuição
- **Microcopy templates** ("Try again", "No results yet") — traducao por contexto, manter intencao
- **Numeros normativos** (4.5:1 WCAG AA, 44pt touch target) — manter como constraint, nao virar token
- **Trade-offs documentados** (porque X e melhor que Y) — manter argumentacao original

---

## 4. Workflow de absorcao (3 fases)

### Fase 1 — Manifest
Criar `governance/<external-source>-import-manifest.md`:
- O que tem na fonte
- O que vamos absorver
- O que vamos skipar (com motivo)
- Plano de tradução aplicado
- **Gate humano:** user aprova antes da Fase 2

### Fase 2 — Extracao + traducao
Pra cada item aprovado:
- Aplicar regras de traducao desta doc
- Criar arquivo em `checklists/`, `templates/`, ou `foundations/` conforme natureza
- Header de atribuicao
- Citar regra-fonte inline em cada item

### Fase 3 — Integracao
- Atualizar manifest com status "executed"
- Atualizar `external-knowledge-sources.md` (catalogo global)
- Apontar agents relevantes pra novos checklists em `dependencies.checklists`

---

## 5. Manutencao

### Re-sync upstream
Recomendado **1x/ano** OU on-demand quando notamos atualizacao significativa na fonte.

Workflow:
1. Comparar manifest atual com versao atual da fonte
2. Listar deltas (regras novas, removidas, alteradas)
3. Re-rodar Fase 1 (manifest + gate humano)
4. Aplicar tradução apenas nos deltas

### Quebra de tradução
Se uma regra absorvida virar invalida (ex: token deprecated, padrão obsoleto):
1. Marcar com `**Status:** SUPERSEDED em YYYY-MM-DD`
2. Apontar pra regra substituta (interna OU nova absorcao)
3. NAO deletar — manter pra historia

---

## 6. Catalogo de fontes externas absorvidas

Cada fonte tem entry em `governance/external-knowledge-sources.md`:

```markdown
## ui-ux-pro-max (nextlevelbuilder)
- **Imported:** 2026-05-18
- **Files:** 4 checklists + 2 cherry-picks anteriores
- **Manifest:** governance/external-knowledge-import-manifest.md
- **License:** verificar
- **Re-sync due:** 2027-05-18
```

(Esse catalogo sera criado/atualizado na Fase 3 da absorcao em curso.)

---

## 7. Aplicacoes ate hoje

| Fonte | Data | Files absorvidos | Status |
|---|---|---|---|
| ui-ux-pro-max-skill | 2026-05-18 | 2 (cherry-pick) + 4 (bulk em curso) | Bulk em execucao |
