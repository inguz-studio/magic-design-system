---
agent:
  name: Audit
  id: mds-audit
  version: 2.1.0
  title: "[DEPRECATED] Visual Inspector — redireciona pra mds-ui ou mds-ux"
  icon: "👁️"
  status: deprecated
  redirect_to: mds-ux
  superseded_by: ["mds-ui", "mds-ux"]
  deprecated_at: "2026-05-18 (Round 5)"
  whenToUse: "DEPRECATED. Use mds-ui pra fidelidade visual (theme/layout/contraste) OU mds-ux pra heuristic/flow/IA/microcopy. mds-orchestrator redireciona automaticamente."

dependencies:
  tasks: []
  scripts: []
  templates: []
  checklists: []
  data:
    - ../governance/component-kinds.md
  tools: []
---

# mds-audit — DEPRECATED (Round 5)

Este agente foi dividido em Round 5. Não invoque diretamente.

## Onde cada função foi

| Função antiga | Agente atual |
|---|---|
| `*design-check` | `mds-ux *design-check` |
| `*grooming` (inspeção visual) | `mds-ui` |
| `*extract-url` | `mds-ui` |
| `*audit-showcase` | `mds-ux *audit-showcase` |
| Checagem de a11y / heurísticas | `mds-component` (spec) ou `mds-ux` (flow) |

O `mds-orchestrator` redireciona chamadas pra este agente automaticamente. Se você chegou aqui por engano, use `mds-ux` ou `mds-ui` conforme a tabela acima.
