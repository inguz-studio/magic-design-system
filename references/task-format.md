# Task Format — magic-ds

Schema e template para tasks deste squad. O magic-ds usa um formato pragmático que prioriza legibilidade e clareza de objetivo sobre contratos AIOS formais completos.

---

## Dois formatos coexistem

As tasks do magic-ds usam dois formatos dependendo da complexidade:

| Formato | Quando usar | Exemplo |
|---|---|---|
| **Pragmático** (predominante) | Tasks operacionais diretas com objetivo claro | `validate-tokens-json.md`, `build-foundations.md` |
| **AIOS formal** (opcional) | Tasks com contratos de dados complexos e múltiplos inputs/outputs | Quando a task é consumida por outro agent via pipeline explícito |

O formato pragmático é o padrão deste squad. O AIOS formal completo está documentado em `references/` do Nirvana Squad Creator se precisar do schema completo.

---

## Formato pragmático (padrão do magic-ds)

### Frontmatter YAML obrigatório

```yaml
---
title: "Título legível da task"
id: nome-da-task          # kebab-case, deve bater com o nome do arquivo
agent: mds-nome-agente    # agente responsável
input: descrição do input esperado
output: descrição do output produzido
---
```

| Campo | Tipo | Descrição |
|---|---|---|
| `title` | string | Título legível para humanos |
| `id` | string | Identificador kebab-case (igual ao nome do arquivo sem .md) |
| `agent` | string | Agente responsável (`mds-<nome>`) |
| `input` | string | O que esta task recebe |
| `output` | string | O que esta task produz |

### Seções Markdown obrigatórias

1. **# Objetivo** — uma linha do que a task faz e por que existe
2. **# Quando invocar** — lista de situações que ativam esta task
3. **# [Seção principal]** — corpo da task (steps, checks, regras, etc.)
4. **# Output** — formato e exemplo do output produzido

### Seções opcionais

- **# Severity** — se a task tem graus de criticidade (error/warning/info)
- **# Exit codes** — se a task retorna códigos de saída
- **# Tempo** — estimativa de duração

---

## Template

```markdown
---
title: "Nome Legível da Task"
id: nome-da-task
agent: mds-nome-agente
input: descrição do input (ex: src/styles/tokens.json)
output: descrição do output (ex: relatório JSON pass/fail)
---

# Objetivo

Uma frase: o que esta task faz e por que é necessária.

# Quando invocar

- Situação A que dispara esta task
- Situação B que dispara esta task
- Situação C (gate obrigatório, CI, etc.)

# [Nome da Seção Principal]

Descreva as etapas, regras ou checks que compõem o trabalho desta task.

## Sub-seção A

Detalhes específicos.

## Sub-seção B

Mais detalhes.

# Output

Formato do output e exemplo:

\`\`\`json
{
  "pass": true,
  "exemplo": "valor"
}
\`\`\`
```

---

## Exemplo real — validate-tokens-json.md (resumido)

```markdown
---
title: "Validate tokens.json"
description: "Verifica integridade de src/styles/tokens.json antes do build. 15 checks, falha rápido."
agent: mds-tokens
input: src/styles/tokens.json
output: relatório JSON (pass/fail + issues)
---

# Objetivo

Validar tokens.json antes de *build-css rodar. Sem isso, build pode emitir CSS com refs quebradas.

# Quando invocar

- Pre-build (gate obrigatório)
- Após Figma Tokens Studio sync
- Em CI/PR check

# Checks (15 regras)

## Grupo A — Estrutura
### #1 JSON parseável
### #2 `$metadata` existe
...

# Output

JSON estruturado com `pass`, `checks_run`, `checks_passed`, `issues[]`.

# Severity

- **error**: bloqueia build
- **warning**: não bloqueia, mas reporta

# Exit codes

- `0` = pass
- `1` = fail com errors
- `2` = pass com warnings
```

---

## Formato AIOS formal (quando necessário)

Se a task precisar de contratos explícitos de dados (Entrada/Saída) — por exemplo, quando ela é consumida automaticamente por outro agente via pipeline — usar o formato AIOS completo:

```yaml
task: nomeTask()          # camelCase com ()
responsavel: "NomeAgente"
responsavel_type: Agente  # Agente | Worker | Humano | Clone
atomic_layer: Molecule    # Atom | Molecule | Organism | Template | Page

Entrada:
  - campo: nomeDoInput
    tipo: string          # string | object | array | boolean | file
    origen: "de onde vem (agente, arquivo, usuário)"
    obrigatorio: true

Saida:
  - campo: nomeDoOutput
    tipo: object
    destino: "para onde vai (próxima task, arquivo)"
    persistido: true      # true se salvo em disco

Checklist:
  pre-conditions:
    - "[ ] Condição que deve ser verdadeira antes de executar"
  post-conditions:
    - "[ ] Condição que deve ser verdadeira após executar"
```

Para referência completa do formato AIOS, ver `squads/nirvana-squad-creator/references/task-format.md`.

---

## Regras de naming

- ID da task em kebab-case (ex: `validate-tokens-json`, `build-foundations`)
- Nome do arquivo = ID + `.md` (ex: `validate-tokens-json.md`)
- Quando a task tem identificador camelCase() para o pipeline AIOS: `validateTokensJson()`
- O campo `agent` referencia um agente existente em `agents/`

---

*Adaptado para o magic-ds em 2026-05-19.*
*Para o schema AIOS completo, ver squads/nirvana-squad-creator/references/task-format.md*
