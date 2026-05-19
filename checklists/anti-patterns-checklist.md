# Anti-Patterns Checklist

**Agent owner:** `mds-audit` (Observer) — flag proativo durante design-check
**Status:** v1 — 2026-05-15
**Fonte:** ux-design skill (jvictor1223)

9 anti-padrões comuns. Flag mesmo quando user não pediu explicitamente.

---

| # | Anti-pattern | Problema | Quando flag |
|---|---|---|---|
| 1 | **Modal para tarefa não-blocking** | Interrompe flow, força context switch | Modal contém conteúdo que NÃO exige decisão imediata. Usar sheet / drawer / inline panel. |
| 2 | **Infinite scroll sem anchor de posição** | User não consegue retomar posição após sair | Catálogos, search results, feeds longos. Adicionar "Voltar a posição X" ou paginar. |
| 3 | **Botão disabled sem explicação** | Não há recovery path visível | Qualquer elemento disabled sem texto adjacente explicando o porquê. Adicionar tooltip ou helper text inline. |
| 4 | **Hamburger menu no desktop** | Esconde navegação primária | Desktop viewport com <7 nav items. Mostrar nav horizontal/sidebar. |
| 5 | **Generic error messages** | Não-actionable ("Algo deu errado") | Qualquer erro mostrando "Something went wrong" ou equivalente. Especificar a causa + ação. |
| 6 | **Ícone-only actions sem labels** | Exige memorização | Toolbar/action bar com ≥3 ícones sem label. Adicionar tooltip ou texto. |
| 7 | **Dados color-coded sem legenda** | Exige memória de mapeamento | Charts, status indicators, category labels. Adicionar legenda fixa + ícone/padrão complementar. |
| 8 | **Placeholder como label** | Some no focus, quebra a11y | Input onde placeholder é o único identificador. Adicionar `<label>` visível persistente. |
| 9 | **Dialog "Yes/No"** sem descrição da consequência | Não descreve o resultado | Qualquer confirmação destrutiva. Trocar pra "Excluir cliente" / "Cancelar". |

---

## Bonus — Anti-patterns Shelflix-specific (Admin Data-Dense)

| # | Anti-pattern | Quando flag |
|---|---|---|
| A | **Density compact em touch device sem guard** | Targets <40px em touch (já temos guard automático em tokens.css; verificar consumo correto) |
| B | **KPI card com 4+ números sem hierarquia** | Apresentar 4+ números sem 1 dominante = scan demorado |
| C | **DataTable sem filtragem persistente** | Filter state sumir ao navegar e voltar |
| D | **Toast persistent (não-dismissive) com mensagem genérica** | Toast sem botão close + mensagem "Sucesso" sem detalhes |

---

## Como reportar (formato de issue)

```
**Anti-pattern:** Modal para tarefa não-blocking
**Where:** "Editar perfil" abre como modal em /clientes/[id]
**Problem:** Edição de perfil é tarefa longa (10+ campos), modal força foco mas não bloqueia
**Impact:** User perde contexto da tabela; difícil verificar info enquanto edita
**Fix:** Substituir por drawer lateral OU /clientes/[id]/edit como rota própria
**Severity:** IMPORTANT
```
