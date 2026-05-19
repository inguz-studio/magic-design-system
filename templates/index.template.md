---
title: "INDEX.md Template"
id: index-template
agent: mds-librarian
purpose: "Esqueleto humano-navegável do estado do DS. Preenchido pelo Librarian após cada *index. Contraparte do `.librarian/index.json` (machine-readable)."
---

# INDEX.md — Magic-DS State

**Última atualização:** `<YYYY-MM-DD HH:mm>`
**Snapshot ativo:** `.librarian/snapshots/<timestamp>.json`
**Escopo indexado:** `<all | tokens | components | audit | references>`

---

## Resumo

| Métrica | Valor |
|---|---|
| Tokens declarados | `<int>` |
| Componentes mapeados | `<int>` |
| References cruzadas | `<int>` |
| Duplicatas detectadas | `<int>` |
| Referências quebradas | `<int>` |

---

## Tokens

### Primitives
| Nome | Path | Status | Última modificação |
|---|---|---|---|
| `<--primitive-blue-500>` | `foundations/02-token-architecture-v2.md:<linha>` | `stable | draft | deprecated` | `<YYYY-MM-DD>` |

### Semantic
| Nome | Resolve para | Path | Status |
|---|---|---|---|
| `<--semantic-bg-brand>` | `var(--primitive-color-blue-500)` | `<path>:<linha>` | `<status>` |

### Components
| Nome | Resolve para | Path | Status |
|---|---|---|---|
| `<--component-button-primary-bg>` | `var(--semantic-bg-brand)` | `<path>:<linha>` | `<status>` |

---

## Componentes

| Nome | Versão | Status | Tenants | Variants | Path |
|---|---|---|---|---|---|
| `<Button>` | `<0.1.0>` | `draft` | `[shelflix]` | `[primary, secondary, ghost, danger]` | `component/Button.spec.yaml:10` |

---

## Conflitos

> Lista de artefatos com mesmo nome declarados em 2+ paths. **Requerem decisão humana.**

- _(vazio se nenhum conflito)_

---

## Referências quebradas

> Artefatos que citam um destino inexistente. Cruzar com `gaps_for_foundations` antes de tratar como bug.

| Origem | Destino faltante | Categoria |
|---|---|---|
| `<component/Button.spec.yaml:138>` | `--semantic-bg-danger-solid` | `expected_gap | bug` |

---

## Histórico de snapshots

| Timestamp | Diff resumido |
|---|---|
| `<YYYY-MM-DD-HHmm>` | `<X added, Y removed, Z modified>` |

---

_Gerado por `mds-librarian *index`. Não editar manualmente — re-rodar `*index` para atualizar._
