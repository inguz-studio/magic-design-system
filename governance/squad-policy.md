# Squad Policy — Schema & Onboarding

**Status:** Round 3.3 — 2026-05-15
**Consumido por:** TODOS os agentes (boot-time) + validators (scripts)
**Substitui:** policy hardcoded "zero-Radix" anterior

---

## Princípio

O squad `magic-ds` é **reusável entre projetos** com stacks diferentes. A política não pode ser hardcoded — vira parâmetro do **projeto consumer**.

`config/squad-policy.yaml` declara, por projeto:
- Quais vendor primitives são permitidas (Radix, shadcn, Reach, HeadlessUI)
- Qual A11y strategy (native, radix, mixed)
- Quais components podem usar vendor (whitelist)
- Stack de build + CSS (Tailwind v3/v4, vanilla CSS, etc.)
- Comportamento dos validators

Squad **lê esse arquivo no boot** e modula comportamento de Component, Ops, Governance, Audit, validators.

---

## Onde mora

| Arquivo | Função |
|---|---|
| `config/squad-policy.yaml` | Policy ATIVA do projeto. Carregada no boot. |
| `config/squad-policy.template.yaml` | Template default pra projetos novos. Copiar e ajustar. |
| `workflows/onboarding-policy.yaml` | Workflow de onboarding (6 perguntas → gera squad-policy.yaml automaticamente) |

---

## Comportamento por policy

### Quando `allow_radix: true`

- `mds-component` pode declarar `vendor.primitive: <name>` no spec.yaml se o component está na `vendor_whitelist`
- `mds-ops` aceita comando `*add-vendor --primitive=<name>` (instala em `/src/vendor/`)
- `validate-output.sh` valida apenas **isolamento** (`@radix-ui` SÓ em `/src/vendor/`, wrappers em `/src/components/` importam de `@/vendor/`)
- A11y patterns continuam declarados em `a11y_native:` como **fallback documentado** (caso queira migrar pra native depois)

### Quando `allow_radix: false`

- `mds-component` força `vendor.primitive: null` em todos os specs
- `mds-ops` rejeita `*add-vendor`
- `validate-output.sh` bloqueia `@radix-ui` em TODO lugar (incluindo package.json)
- Components complexos OBRIGATORIAMENTE declaram `a11y_native:` com receita manual

### Quando `preferred_a11y_strategy: mixed`

- Components na `vendor_whitelist` podem usar Radix/shadcn
- Components fora do whitelist devem ser native

---

## Onboarding flow (projetos novos)

Quando squad é invocado em projeto SEM `config/squad-policy.yaml`:

```
mds-orchestrator detecta ausência → roteia automaticamente
mds-orchestrator *onboarding-policy
```

### 6 perguntas

1. **Stack base:** React + Tailwind + Vite? Outro?
2. **A11y strategy preferida:** native (zero deps), radix (shadcn), mixed?
3. **Se mixed:** quais components podem usar vendor? (lista — Dialog/Combobox/DatePicker/Toast/Popover/etc.)
4. **CVA OK ou banido?** (default: banido — manutenção difícil, vide memory feedback_cva)
5. **Componentes complexos esperados no roadmap?** (pré-define whitelist se mixed)
6. **Restrições legais/compliance** (zero deps de 3rd party pra security audit)?

### Output

- `config/squad-policy.yaml` populado
- Memory institucional: `project_<name>_policy.md` declarando decisões
- Branch inicial dos validators configurada

---

## Migration path: zero-Radix → shadcn em projeto existente

Como Shelflix-Admin acabou de fazer:

1. Atualizar `config/squad-policy.yaml`: `allow_radix: true` + whitelist
2. Components existentes (entregues como native) ficam como **v1 native**:
   - Spec marca `existing_native_implementations` na policy
   - Não há refactor automático — mantém implementação atual
   - Podem migrar individualmente quando fizer sentido (variant `vendor.primitive` no spec, manter v1 como fallback)
3. Components NOVOS criados após mudança da policy podem usar shadcn diretamente
4. Validators lêem nova policy e param de bloquear `@radix-ui`
5. Memory atualizada: `feedback_no_radix.md` → `feedback_policy_driven_a11y.md`

---

## Anti-padrões

| Anti-padrão | Por quê |
|---|---|
| Hardcodar "zero Radix" no agente | Quebra reuso do squad em projetos com policy diferente |
| Inverso: hardcodar "use shadcn" | Mesmo problema; outros projetos podem não querer |
| Misturar policy do projeto com regra de squad | Squad é estrutural, policy é de stack — separar |
| Onboarding sem perguntas → assume defaults | Pode levar a projeto inteiro implementado errado por 6 meses até alguém perceber |
| Mudar policy sem registrar memory | Próxima sessão de Claude vai assumir policy antiga |

---

## Referências cruzadas

- `config/squad-policy.yaml` — policy ativa do Shelflix-Admin
- `config/squad-policy.template.yaml` — template pra projetos novos
- `governance/skills-routing.md` — roteamento depende da policy (component complexo → A11y native ou shadcn?)
- `governance/component-kinds.md` — kind generic/domain/background independe da policy
- `governance/sync-rules.md` — mudanças de policy disparam propagação pros agentes
