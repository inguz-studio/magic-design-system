# Squad YAML Schema — magic-ds

Schema do arquivo `squad.yaml` para este squad. Segue o padrão AIOS Core com extensões específicas do magic-ds.

---

## Estrutura geral

O `squad.yaml` é o manifesto do squad. Fica na raiz de `squads/magic-ds/` e declara identidade, componentes, configuração e tags.

---

## Campos obrigatórios

| Campo | Tipo | Descrição | Restrições |
|---|---|---|---|
| `name` | string | Identificador do squad | kebab-case (ex: `magic-ds`) |
| `version` | string | Versão do squad | semver (ex: `2.0.0`) |
| `description` | string | O que este squad faz | String inline com aspas — nunca bloco YAML `\|` ou `>` |
| `aios.minVersion` | string | Versão mínima do AIOS Core | String com aspas (ex: `"2.1.0"`) |
| `aios.type` | string | Tipo de componente AIOS | Sempre `squad` |
| `components` | object | Listas de arquivos por tipo | Contém `agents`, `tasks`, `workflows` |

---

## Campos opcionais

| Campo | Tipo | Descrição |
|---|---|---|
| `author` | string | Autor (nome e/ou email) |
| `license` | string | Licença (ex: `MIT`) |
| `slashPrefix` | string | Prefix dos slash commands (ex: `mds` → `/mds:*`) |
| `components.checklists` | array | Arquivos de checklist |
| `components.templates` | array | Arquivos de template |
| `components.tools` | array | Ferramentas customizadas |
| `components.scripts` | array | Scripts utilitários |
| `config.extends` | enum | Herança de config: `extend` \| `override` \| `none` |
| `config.coding-standards` | string | Caminho para coding-standards.md |
| `config.tech-stack` | string | Caminho para tech-stack.md |
| `config.source-tree` | string | Caminho para source-tree.md |
| `dependencies.node` | array | Dependências npm |
| `dependencies.squads` | array | Dependências de outros squads (semver: `"squad@^1.0.0"`) |
| `tags` | array | Tags de descoberta |

---

## Extensões magic-ds

O magic-ds usa campos adicionais que não fazem parte do schema AIOS Core padrão:

| Campo extra | Descrição |
|---|---|
| `aios.minVersion` + `aios.type` | Bloco `aios:` como sub-objeto (vs campos no nível raiz) |

Comentários inline no YAML são permitidos e encorajados para indicar status de componentes (NOVO, DEPRECATED, etc.).

---

## Template

```yaml
# --- Identidade ---
name: magic-ds
version: 2.0.0
description: "Squad especializado em Design System Engineering com arquitetura 3 camadas."
author: "Nome Sobrenome"
license: MIT
slashPrefix: mds

aios:
  minVersion: "2.1.0"
  type: squad

# --- Componentes ---
components:
  agents:
    - mds-orchestrator.md
    - mds-librarian.md
    # ... demais agentes
  tasks:
    - build-foundations.md
    - validate-tokens-json.md
    # ... demais tasks
  workflows:
    - magic-ds-pipeline.yaml
  checklists:
    - nielsen-heuristics-checklist.md
    - a11y-wcag-checklist.md
  templates:
    - component.spec.template.yaml
  tools: []
  scripts: []

# --- Config ---
config:
  extends: none           # none = standalone, sem herança do AIOS Core
  coding-standards: config/coding-standards.md
  tech-stack: config/tech-stack.md

# --- Dependências ---
dependencies:
  node: []
  squads: []

# --- Tags ---
tags:
  - design-system
  - ui-ux
  - tokens
```

---

## Estado atual do squad.yaml

O `squad.yaml` do magic-ds usa `config.extends: none` porque o squad opera de forma completamente independente do AIOS Core — tem suas próprias convenções de tokens, CSS, e arquitetura que não se encaixam nos defaults genéricos.

O `slashPrefix: mds` habilita `/mds:mds-orchestrator`, `/mds:mds-foundations`, etc. após deploy.

---

## Regras de validação

- `name` em kebab-case (letras minúsculas, números, hífens)
- `version` em semver válido (MAJOR.MINOR.PATCH)
- `description` DEVE ser string inline com aspas — nunca usar `|` ou `>` (AIOS parseia como objeto)
- Todos os arquivos listados em `components` devem existir no diretório do squad
- `config.extends` é um de: `extend`, `override`, `none`
- `slashPrefix` é string curta em kebab-case, sem caracteres especiais
- Agentes DEPRECATED podem ser mantidos na lista com comentário inline explicando o status

---

## Exemplo real (squad.yaml atual — simplificado)

```yaml
name: magic-ds
version: 2.0.0
description: "Squad especializado em Design System Engineering com split UI/UX (Round 5). Arquitetura 3 camadas, tokens.json W3C, prefix configurável, multi-product/multi-tenant, showroom 8-section padronizado."
author: "Antigravity & Vitor Eduardo"
license: MIT
slashPrefix: mds

aios:
  minVersion: "2.1.0"
  type: squad

components:
  agents:
    - mds-orchestrator.md
    - mds-librarian.md
    - mds-ui.md                # NOVO (Round 5)
    - mds-ux.md                # NOVO (Round 5)
    - mds-audit.md             # DEPRECATED (Round 5)
    - mds-foundations.md
    - mds-tokens.md
    - mds-governance.md
    - mds-component.md
    - mds-ops.md
  tasks:
    - build-foundations.md
    - validate-tokens-json.md
    # ... 12 tasks no total
  workflows:
    - magic-ds-pipeline.yaml
  checklists:
    - nielsen-heuristics-checklist.md
    # ... 12 checklists no total

config:
  extends: none
  coding-standards: config/coding-standards.md
  tech-stack: config/tech-stack.md

tags:
  - design-system
  - ui-ux
  - tailwind
  - figma-bridge
  - multi-agent
```

---

*Para referência completa do schema AIOS Core, ver squads/nirvana-squad-creator/references/squad-yaml-schema.md*
*Última atualização: 2026-05-19*
