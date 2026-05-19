# Workflow Format — magic-ds

Schema para workflows deste squad. O magic-ds usa um formato estendido do padrão AIOS Core, com suporte a branches condicionais, gates humanos, parallel dispatch e steps encadeados.

---

## Estrutura geral

Um workflow é um arquivo `.yaml` em `workflows/` que descreve:
- Triggers (o que dispara o workflow)
- Steps ordenados (agente + ação por step)
- Branches condicionais (goto baseado em resultado)
- Gates humanos (requires_human_approval)
- Parallel dispatch (múltiplos agentes simultâneos)

---

## Campos do arquivo de workflow

### Nível raiz (obrigatórios)

| Campo | Tipo | Descrição | Restrições |
|---|---|---|---|
| `name` | string | Nome legível do workflow | Texto livre com aspas |
| `id` | string | Identificador único | kebab-case |
| `version` | string | Versão do workflow | semver |
| `description` | string | Resumo do propósito | String inline com aspas — nunca bloco YAML `\|` ou `>` |

### Triggers (obrigatório)

```yaml
triggers:
  - on_command: "*nome-do-comando"
  - on_event: "nome_do_evento"
```

### Steps (obrigatório)

Cada step descreve um agente, uma ação, e o que acontece depois.

| Campo | Tipo | Descrição |
|---|---|---|
| `id` | string | Identificador do step (snake_case) |
| `agent` | string | ID do agente que executa este step (ex: `mds-orchestrator`) |
| `task` | string | (opcional) Nome do arquivo de task que este agente executa |
| `action` | string | Descrição do que será feito |
| `output_format` | string | (opcional) Formato do output (`json`, `yaml`, `markdown`) |
| `requires_human_approval` | boolean | (opcional) Se true, pipeline pausa antes do próximo step |
| `branches` | array | (opcional) Saídas condicionais baseadas no resultado |
| `next` | string | (opcional) ID do próximo step (quando sem branches) |
| `end` | boolean | (opcional) true se este step finaliza o workflow |
| `parallel_dispatch` | array | (opcional) Comandos a executar em paralelo |

### Estrutura de branch

```yaml
branches:
  - condition: "variavel == 'valor'"
    goto: id_do_step_destino
default:
  goto: id_do_step_fallback
```

---

## Template

```yaml
name: "Nome Legível do Workflow"
id: nome-do-workflow
version: 1.0.0
description: "Descrição inline em uma linha do que este workflow faz."

triggers:
  - on_command: "*comando-que-dispara"
  - on_event: "evento_que_dispara"

steps:
  - id: step_entrada
    agent: mds-orchestrator
    action: "Ação que este agente executa neste step."
    output_format: json
    branches:
      - condition: "agent == 'foundations'"
        goto: step_foundations
      - condition: "agent == 'ops'"
        goto: step_ops
    default:
      goto: step_clarify

  - id: step_clarify
    agent: mds-orchestrator
    action: "Intenção ambígua. Solicitar reformulação."
    end: true

  - id: step_foundations
    agent: mds-foundations
    task: build-foundations.md
    action: "Estruturar tokens em 3 camadas. Entregar delta JSON."
    requires_human_approval: true
    next: step_ops

  - id: step_ops
    agent: mds-ops
    task: generate-ops-code.md
    action: "Gerar output canonical HTML+CSS."
    end: true
```

---

## Exemplo real — magic-ds-pipeline.yaml (trecho)

```yaml
name: "Magic-DS Core Pipeline (Dual-Layer Output)"
id: magic-ds-pipeline
version: 2.0.0
description: "Fluxo completo de roteamento JSON e Human-in-the-loop."

triggers:
  - on_command: "*route"
  - on_event: "ui_image_received"

steps:
  - id: step_orchestrate
    agent: mds-orchestrator
    action: "Analisar input e determinar agente via roteamento JSON."
    output_format: json
    branches:
      - condition: "agent == 'foundations'"
        goto: step_foundations
      - condition: "agent == 'joint'"
        goto: step_joint_audit
    default:
      goto: step_clarify_user

  - id: step_joint_audit
    agent: mds-orchestrator
    action: "Dispatch paralelo: mds-ui + mds-ux. Scores independentes."
    parallel_dispatch:
      - "mds-ui *audit-ui"
      - "mds-ux *heuristic-audit"
    branches:
      - condition: "ui_score in ['C','D'] || ux_score in ['C','D']"
        goto: step_clarify_user
    next: step_foundations

  - id: step_foundations
    agent: mds-foundations
    task: build-foundations.md
    action: "Estruturar token sets. Output: delta tokens.json."
    requires_human_approval: true
    next: step_tokens_validate
```

---

## Padrão de IDs

- Workflow ID: kebab-case (ex: `magic-ds-pipeline`, `audit-flow`)
- Step ID: snake_case prefixado com `step_` (ex: `step_orchestrate`, `step_foundations`)
- Arquivo: `<workflow-id>.yaml`

## Convenções magic-ds

- Steps de gate humano sempre têm `requires_human_approval: true`
- Steps finais sempre têm `end: true`
- Branches incluem um `default` como fallback
- Parallel dispatch retorna scores independentes — nunca mergeado numericamente
- Branches de score: `score in ['C','D']` bloqueia; `score in ['A','B']` avança
- Steps deprecated preservam o comportamento legado com comentário explicativo

---

*Para referência completa do padrão AIOS Core, ver squads/nirvana-squad-creator/references/workflow-format.md*
*Última atualização: 2026-05-19*
