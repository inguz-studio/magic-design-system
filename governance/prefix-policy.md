# Prefix Policy

**Status:** Adotado (Round 4 — Convergence W3.2)
**Consumido por:** `mds-orchestrator` (gate), `mds-tokens` (validacao), `mds-ops` (geracao)

---

## 0. Proposito

Todo token gerado pelo squad usa prefix declarado em `config/squad-policy.yaml.token_prefix`. Sem isso, os tokens do Shelflix-DS poderiam colidir com tokens de libs externas (Tailwind, Bootstrap, Material, shadcn) no mesmo bundle CSS.

---

## 1. Regra geral

```
--<prefix>-<layer>-<category>-<modifier>
```

**Exemplo (prefix `sf`, Shelflix):**
- `--sf-primitive-orange-700`
- `--sf-bg-canvas`
- `--sf-action-primary-bg`
- `--sf-status-success-text`

**Exemplo (prefix `ac`, Acme):**
- `--ac-primitive-blue-700`
- `--ac-bg-canvas`
- `--ac-action-primary-bg`

---

## 2. Onde o prefix vem

1. Onboarding (`*onboarding-policy` Q1) pergunta: "Qual o nome da marca principal?"
2. Squad deriva: 2 primeiras letras lowercase, sem acentos
3. User pode overridar se colidir com lista reservada
4. Valor persistido em `config/squad-policy.yaml.token_prefix`

---

## 3. Prefixes reservados (proibidos)

| Prefix | Reservado por |
|---|---|
| `tw` | Tailwind |
| `bs` | Bootstrap |
| `mui` | Material UI |
| `ant` | Ant Design |
| `chakra` | Chakra UI |
| `css`, `var` | CSS keywords |

Se a marca derivar pra um desses, onboarding obriga override.

---

## 4. Enforcement

### mds-orchestrator
- Boot: ler `squad-policy.yaml.token_prefix`
- Se ausente → rotear pra `*onboarding-policy`
- Se presente → propagar no payload de todos os agents downstream

### mds-tokens
- `*validate-json`: rejeita qualquer key em tokens.json que gere CSS var sem prefix declarado
- `*build-css`: aplica prefix em todos os `--*` gerados

### mds-ops
- `generate-ops-code`: gera CSS canonical usando `var(--<prefix>-*)` exclusivamente
- Falha se detectar token sem prefix em arquivo `output/css/<block>.css`

### Validators (scripts/)
- `validate-output.sh`: grep por `--[a-z]+-` que nao bate com `--<prefix>-` → erro

---

## 5. Migracao (se prefix mudar)

Se projeto trocar prefix (rebranding, fusao de marcas):

1. Atualizar `token_prefix` em squad-policy.yaml
2. `mds-tokens *build-css` regenera com novo prefix
3. `mds-ops *migrate-prefix --from=<old> --to=<new>` faz sed em `output/css/` e `src/components/`
4. Validators rodam check de integridade

---

## 6. Single-prefix policy

**Um projeto = um prefix.** Nao suportamos multi-prefix no mesmo projeto. Casos especiais:

- **Multi-tenant**: usa `[data-tenant]`, nao prefix diferente
- **White-label**: usa `[data-client]`, nao prefix diferente
- **Multi-product (familia)**: cada produto eh um projeto separado com seu proprio prefix OU compartilham o prefix da familia

---

## 7. Historico

- 2026-05-18: Implementado em Round 4 (W3.2 Convergence to Even-DS). Antes nao havia prefix obrigatorio — tokens do squad poderiam colidir com bibliotecas externas.
