---
title: "Component & UI API Mapping"
id: map-components
agent: mds-component
---

# Objective
Avaliar as definições de componentes complexos, especificando variações e acessibilidade de interface.

# Steps
1. Identificar o primitivo shadcn-fonte (button, input, dialog, popover...) e preencher `vendor.primitive` no spec — sinaliza para Ops qual `npx shadcn-ui@latest add <x>` rodar.
2. Extrair propriedades (Variants, Sizes, States) e declarar como eixos enumerados — esses eixos viram chaves do `cva({ variants })` no wrapper.
3. Auditar estados pseudo-classes (Hover, Focus-Visible, Active, Disabled, Loading) e mapear cada um ao token semântico em `tokens.<variant>.<state>`.
4. Definir regras WCAG por componente (tabIndex, aria-labels obrigatórios, target ≥24×24, focus-visible jamais removido).
5. Escrever contrato da UI (Props API) com props booleanas prefixadas `is*` (isDisabled, isLoading) para diferenciar do atributo HTML nativo do primitivo.
6. Declarar `outputs` esperados (tsx + stories + contract.yaml no mínimo).
7. Encaminhar `component.spec.yaml` validado para Governance (re-check dos `--component-*` tokens) e em seguida Ops.
