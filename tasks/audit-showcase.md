# Task — Audit Showroom

**Owner:** mds-audit
**Comando:** `*audit-showcase`
**Trigger:** "audit showroom", "revise showroom", "validar showcase", PR que toca `showcase/` / `tokens.css` / `canonical.css` / `component/**.spec.yaml`.

---

## Propósito

Validar que o `squads/magic-ds/showcase/` está em conformidade com **policy, governance, theme contract, matrix e specs reais** — NÃO os 14 princípios de design visual (isso é `*design-check`).

Showroom é prova viva do DS. Quando ele demonstra cenário que viola regra do próprio DS, vira contraprova — quebra confiança no artefato.

---

## Pre-requisitos

- `squads/magic-ds/showcase/` existe
- `scripts/build-showcase.mjs` existe (Node, zero-deps)
- `governance/{theme-contract,matrix,squad-policy,skills-routing}.md` existem
- `config/squad-policy.yaml` existe
- `themes/<product>.yaml` declara `allows_clients`, `adopts_domain`, etc.

---

## 6 categorias auditadas

### 1. Dual status vocabulary (governance/matrix.md §1)

**Regra:** Tag tem dois vocabulários:
- `success`/`warning`/`danger`/`info` — operational global (🔒)
- `online`/`offline`/`alert` + 14 — domain Shelflix

Showroom deve usar `<span class="tag tag--tint tag--md" data-status="X">` — `tag.css` resolve via `[data-status]` attribute selector. **Inline-style triplo** (`style="background: ...; color: ...; border-color: ..."`) é proibido.

**Checks:**
- Grep `routes/**/*.html` por `style="background: var(--semantic-status-`
- Verificar que `data-status` aparece em todo `.tag` no showroom

### 2. White-label policy compliance

**Regra:** se `themes/<product>.yaml` declara `allows_clients: false`, showroom NÃO pode demonstrar `[data-client="X"]` override pra esse produto.

**Checks:**
- Ler `allows_clients` do produto ativo no showroom (`data-product` no `<html>`)
- Verificar que `index.html` não tem `<style id="sc-runtime-overrides">` com regra `[data-client=`
- Verificar que sidebar não tem `<select id="sc-client-select">`

### 3. Density A11y guard (governance/matrix.md §1)

**Regra:** `[data-density="compact"]` reduz alturas mas `@media (pointer:coarse)` força volta pra ≥40px no control-md (WCAG 2.5.5).

**Checks:**
- Cada canonical CSS com `--md` size deve ter:
  - `[data-density="compact"] .X--md` rule
  - `@media (pointer:coarse) { [data-density="compact"] .X--md }` rule
- Showroom tem 3-card density demo medindo altura real via `getBoundingClientRect`

### 4. Manifest freshness (specs-manifest.json)

**Regra:** `showcase/specs-manifest.json` reflete o filesystem atual.

**Checks:**
- Roda `node scripts/build-showcase.mjs` (se `--regenerate-manifest`, default true)
- Compara output com `specs-manifest.json` checked-in — devem ser idênticos
- Se diff, reporta drift e atualiza

### 5. Theme Contract gate (governance/theme-contract.md §1)

**Regra:** produto ativo declara os 10 tokens required.

**Checks:**
- Lê `manifest.theme_contract_required` (extraído da §1 do theme-contract.md)
- Pra cada token, valida que computed style do `<html data-product="X">` resolve pra valor não-vazio
- Showroom mostra X/10 em `/themes`

### 6. Anti-leak coverage (governance/squad-policy.md)

**Regra:** isolamento de camadas:
- `canonical.css`: zero hex literal, zero `@apply`/`@tailwind`, zero `rgb()|hsl()` literal
- `/src/components/**/*.tsx` (não-vendor): zero `@radix-ui`, zero `@apply`
- `tokens.css`: hex SÓ na seção Primitive (antes de `--brand-*`)

**Checks:**
- Fetch e grep nos paths listados
- Cada hit `strict: true` é blocker; `strict: false` é warn

---

## Severity matrix

| Categoria | Pass | Warn | Fail |
|---|---|---|---|
| Dual vocabulary | 0 inline-style triplo | — | ≥1 inline-style triplo |
| White-label policy | Conformidade total | — | Demonstra cenário proibido |
| Density guard | Todos canonical com `--md` têm guard | Alguns têm | Nenhum tem |
| Manifest freshness | Sem diff | Diff em metadata (_generated_at) | Diff estrutural |
| Theme Contract | 10/10 | 9/10 | <9/10 |
| Anti-leak | Tudo clean | Hex em tokens.css fora Primitive | Hex/`@apply`/`@radix-ui` em strict path |

`--strict` promove warns a fails.

---

## Output

Schema completo em `agents/mds-audit.md` §`*audit-showcase`.

```json
{
  "command": "audit-showcase",
  "totals": { "blocker": 0, "high": 0, "medium": 0, "low": 0 },
  "ready_for_release": true
}
```

---

## Quando rodar

- Pre-merge de PR tocando: `showcase/`, `tokens.css`, `canonical.css`, `component/**.spec.yaml`, `themes/**.yaml`
- Pós `mds-ops` regerar canonical CSS
- Pré-release do DS (combinado com `*design-check --scope all`)

---

## Referências

- `agents/mds-audit.md` §`*audit-showcase`
- `governance/skills-routing.md` linha "showroom-audit"
- `agents/mds-orchestrator.md` Exemplo 3
- `scripts/build-showcase.mjs`
- `showcase/specs-manifest.json`
- Memory: `project_shelflix_ds_showroom_audit.md`
