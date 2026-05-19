# Admin & Data-Dense UI Checklist

**Agent owner:** `mds-audit` + `mds-component` — contexto-específico Shelflix
**Status:** v1 — 2026-05-15
**Fonte:** ux-design skill §"Admin Interfaces & Data-Dense UIs" (jvictor1223)

Shelflix Admin é interface de monitoramento — tem requisitos distintos de produtos consumer. Esta checklist captura padrões específicos.

---

## 1. Tabelas (DataTable)

| Item | Regra |
|---|---|
| **Coluna primária** | Left-aligned + visualmente dominante (font-weight semibold OU type-h4) |
| **Sortable columns** | Affordance visual obrigatória (chevron + hover state). Sem affordance = não-sortable |
| **Bulk actions** | Aparecem SÓ quando ≥1 item selecionado (não persistente no topo). Action bar com counter "X selecionados". |
| **Sticky header** | Em tabelas com >20 rows, header gruda no top do viewport |
| **Empty state** | Mostrar mensagem + CTA pra adicionar/importar, NÃO tabela vazia muda |
| **Loading state** | Skeleton rows (não spinner centralizado) — mantém estrutura |
| **Pagination** | Pra >50 rows. Server-side pra >1000 rows |

---

## 2. Filtragem

| Tipo de dataset | Padrão recomendado |
|---|---|
| Wide (muitas categorias) | Faceted filters (sidebar com filter groups) |
| Narrow (poucas categorias) | Sequential filters (FilterBar horizontal no top) |
| Search-driven | SearchBar primário + filtros secundários collapsible |

**Regra crítica:** filter state **persiste** ao navegar e voltar. Limpar só com ação explícita (botão "Limpar" do FilterBar).

---

## 3. Dashboard composition

**2 categorias visuais que NÃO se misturam sem separação:**

| Tipo | Layout logic |
|---|---|
| **Monitoring** (estado atual, real-time) | KPI cards horizontais no topo. Auto-refresh visível. Status pills em destaque. |
| **Reporting** (histórico, tendências) | Charts em grid larger. Dropdowns de período. Comparação temporal. |

Se ambos na mesma página: usar `--semantic-space-section-lg` (64px) entre regiões + heading h2 explícito.

---

## 4. Density

| Caso | Density |
|---|---|
| Admin típico (monitoring, listings) | `data-density="compact"` no shell |
| Customer-facing | `data-density="comfortable"` (default sem atributo) |
| Touch device em compact | Guard automático em tokens.css força ≥40px (WCAG 2.5.5) |

User pode override via setting "Modo denso" — toggle no perfil/preferences.

---

## 5. Status & States

| Status | Cor (semantic) | Quando usar |
|---|---|---|
| `online` | `--semantic-status-success-text` | Conectado, operacional |
| `alert` | `--semantic-status-warning-text` | Atenção mas operacional |
| `offline` | `--semantic-status-danger-text` | Desconectado, requer ação |
| `pre-offline` | `--primitive-purple-500` | Transição pra offline (próximos N minutos) |
| `maintenance` | `--primitive-blue-500` | Em manutenção programada |
| `unavailable` | `--primitive-blue-500` | Indisponível por motivo externo |
| `fair` | `--semantic-score-fair-*` | Score intermediário (NÃO operacional) |

**Regra:** Status (operacional) ≠ Score (analítico). Não misturar `warning` (atenção) com `fair` (score médio).

---

## 6. KPI Cards

| Boa prática | Anti-pattern |
|---|---|
| 1 número dominante + 1 contexto pequeno | 4 números equivalentes sem hierarquia |
| Delta com cor + sinal (▲ ▼) | Delta só com cor |
| Sparkline opcional (tendência) | Chart completo em card pequeno |
| Click → detalhes em rota própria | Click → modal com mais números |

---

## 7. Empty states (dashboard / table)

| Cena | Recomendado |
|---|---|
| Sem dados ainda (fresh account) | Illustration + texto onboarding + CTA "Adicionar primeiro X" |
| Sem dados pra filtro aplicado | Texto + botão "Limpar filtros" |
| Erro de carga | Illustration de erro + retry button + support link |
| Permissão negada | Texto explicativo + ação alternativa (request access) |

Empty state nunca é só "Sem dados" centralizado em página vazia.

---

## 8. Notifications & feedback

| Tipo | Component | Posicionamento |
|---|---|---|
| Action confirmation (1-3s) | Toast | Bottom-right |
| Persistent alert (system-wide) | Banner | Top of page (abaixo do header) |
| Inline error | Form field error message | Embaixo do campo |
| Background process | Snackbar com progress | Bottom |
| Long-running async result | Notification center (sino no header) | Persistente até user dismiss |

Frequência cap: max 3 toasts simultâneos. Mais = agrupar em notification center.

---

## 9. Bulk operations

| Item | Regra |
|---|---|
| Selecionar visualizado vs todos | "Selecionar todos os 27" vs "Selecionar todos os 1.234" — distinguir explicitamente |
| Confirmation pra destrutivo bulk | Mostrar count "Excluir 27 itens?" + lista (collapsible) |
| Progress de operação | Modal com progress bar + cancel; ou notification center pra background |
| Resultado | Toast com "X sucesso, Y erro" + link pra detalhes dos erros |

---

## Como reportar issue admin-specific

```
**Domain:** Admin Data-Dense
**Anti-pattern:** KPI card com 4 números equivalentes
**Where:** "Conformidade" card no dashboard /dashboard
**Problem:** 4 números (total, online, offline, alert) sem hierarquia visual
**Impact:** Scan demorado; user não sabe qual é o "número principal" pra acompanhar
**Fix:** Promover 1 número principal (total online%) em type-h2; demais como caption/micro abaixo
**Severity:** IMPORTANT
```
