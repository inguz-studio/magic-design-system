# Coding Standards (Magic-DS) — Round 2

**Atualizado:** 2026-05-14 (A.1 reset)
**Substitui:** versão Round 1 (3-layers + shadcn integration)

---

## 1. HARD RULES (não-negociáveis)

### 1.1 Zero Radix / Zero shadcn
Stack canônica: **HTML semântico + CSS BEM + Tailwind (adapter) + React (adapter)**. Proibido:
- `@radix-ui/*` em qualquer dependência
- `shadcn-ui` install ou import
- `/src/vendor/` como pasta ativa (artefato Round 1, será removido)

Componentes complexos (Tooltip, Dialog, Combobox, Select, Popover, Tabs, Toast, Menu, DatePicker) são **build nativo** com A11y manual (focus trap, escape, aria-activedescendant, roving tabindex, etc.). Ver `agents/mds-component.md` seção "A11y nativa por padrão complexo".

### 1.2 Output canônico zero-deps
Tudo em `squads/magic-ds/output/` é HTML semântico + CSS BEM puro. Zero React, zero Tailwind utility classes, zero `@apply`, zero imports de framework. Validado por `mds-ops *validate-output` greps.

### 1.3 Cores via cascade tokens
Toda cor visual passa por: `Primitive → Brand Core → Theme → Semantic → Component`. Cor hex/rgb hardcoded **só** permitida em Primitives (camada física). Qualquer outro lugar viola.

---

## 2. Token Architecture (5 camadas)

Ver `foundations/02-token-architecture-v2.md` pra detalhe. Resumo:

| Camada | Prefixo | Onde mora | Escopo CSS |
|---|---|---|---|
| Primitive | `--primitive-*` | `src/styles/tokens.css` | `:root` |
| Brand Core | `--brand-*` | `src/styles/tokens.css` | `[data-tenant=<X>]` |
| Theme | `--theme-*` | `src/styles/tokens.css` + `themes/<product>.css` | `[data-tenant=<X>]` default, `[data-product=<Y>]` ou `[data-client=<Z>]` override |
| Semantic | `--semantic-*` | `src/styles/tokens.css` | `[data-tenant=<X>]` + `[data-tenant=<X>][data-theme=<mode>]` |
| Component | `--<block>-*` (omite `--component-`) | `output/css/<block>.css` (junto do BEM) | dentro de `.<block>` |

---

## 3. Naming Convention

```
--[layer]-[category]-[role]-[state]
```

**Regras inquebráveis:**
1. **kebab-case** em tudo. Sem PascalCase, sem camelCase, sem snake_case.
2. **Primitive = físico**, nunca funcional:
   - ✅ `--primitive-orange-700` `--primitive-red-500` `--primitive-blue-600`
   - ❌ `--primitive-brand-700` `--primitive-error` `--primitive-info-alt`
3. **Brand Core = identidade da marca-mãe**, sem `danger/success/warning/info`:
   - ✅ `--brand-primary` `--brand-accent` `--brand-secondary`
   - ❌ `--brand-danger` (`danger` é Semantic Status, não identidade)
4. **Semantic carrega papel** com sufixo claro: `bg`, `text`, `border`, `icon`:
   - ✅ `--semantic-action-primary-bg` `--semantic-status-danger-text`
   - ❌ `--semantic-action-primary-Color` `--semantic-danger`
5. **Estados** seguem ordem fixa: `default` (omitido) → `hover` → `pressed` → `focus` → `disabled` → `loading`.

---

## 4. BEM (estrutura CSS canônica)

Ver `checklists/canonical-output-checklist.md §3`. Resumo:

- **Block** kebab-case: `.btn` `.kpi-card` `.nav-item`
- **Element** com `__`: `.kpi-card__header` `.kpi-card__title`
- **Modifier** com `--`: `.btn--primary` `.btn--sm`
- **Máximo 2 níveis.** `.block__element__sub` proibido — sub-element vira block próprio.

---

## 5. Critério "criar nova cor" (gate de PR)

Toda nova cor exige 12 respostas no PR description (briefing §13):

1. Resolve função nova?
2. Melhora leitura/hierarquia/estado?
3. Pode ser substituída por token existente?
4. Precisa em todos os produtos?
5. Específica de um produto?
6. Pertence a Brand/Theme/Semantic/Score/Status/Chart?
7. Passa contraste WCAG?
8. Funciona light + dark?
9. Reutilizável?
10. Nome previsível?
11. Documentação?
12. Fallback necessário?

Mínimo: 8 respostas "sim claro" ou "sim com justificativa". Menos = rejeitar PR.

---

## 6. JSON Output (Orchestrator + Audit + Governance)

Saídas estruturadas devem ser **JSON válido RFC 8259** — sem comentários inline, sem trailing commas, sem campos extras fora do schema declarado. Schemas oficiais em cada agente.

---

## 7. Tailwind (adapter only)

- **Default:** Tailwind v4 CSS-first via `@theme` em `src/styles/tailwind-theme.css`. Tokens consumidos via `var(--...)` — Tailwind referencia, não duplica.
- **Adapter React (`/src/components/`):** Tailwind utility classes só pra micro-ajustes de instância (margem, posicionamento). Identidade visual sempre via classes BEM canônicas (`className="btn btn--primary"`).
- **Canonical (`output/`):** zero Tailwind. Pure CSS.

---

## 8. Referências consolidadas

| Documento | Propósito |
|---|---|
| `foundations/02-token-architecture-v2.md` | 5 camadas, cascade, escopos, regras invariantes |
| `governance/theme-contract.md` | Tokens obrigatórios por theme + fallbacks |
| `governance/matrix.md` | O que varia onde (Global/Tenant/Product/Client) |
| `governance/component-kinds.md` | Generic vs Domain + opt-in cross-tenant |
| `checklists/canonical-output-checklist.md` | Gate validação canônica |
| `checklists/a11y-wcag-checklist.md` | A11y nativa requirements |
| `checklists/design-principles-checklist.md` | 14 princípios design-check |
