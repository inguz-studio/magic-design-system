---
title: "Onboarding Policy"
description: "Estabelece squad-policy.yaml para projetos novos via 7 perguntas estruturadas. Gate obrigatorio antes de qualquer outra acao quando policy ausente."
agent: mds-orchestrator
output: config/squad-policy.yaml
---

# Objetivo

Quando `config/squad-policy.yaml` nao existe no projeto destino, o `mds-orchestrator` deve bloquear todas as outras acoes e rotear pra esse task. Resultado: arquivo `squad-policy.yaml` populado + memory file `project_<name>_policy.md` registrando as decisoes.

# When to invoke

- Boot do squad em projeto novo (sem squad-policy.yaml)
- Comando explicito `*onboarding-policy`
- Recovery quando squad-policy.yaml corrompido

# Pre-condicoes

- Projeto destino tem pasta `config/` (criar se nao existir)
- Template em `config/squad-policy.template.yaml` carregavel

# Questoes estruturadas (7)

## Q1 - Marca principal e prefix de token

**Pergunta:** "Qual o nome da marca principal do projeto?"

**Output deriva:**
- `project: <kebab-case-da-marca>`
- `token_prefix: <2 primeiras letras lowercase, sem acentos>`

**Validacoes:**
- Marca nao vazia
- Prefix nao colide com lista reservada: `tw`, `bs`, `mui`, `ant`, `chakra`, `css`, `var`
- Se colidir, perguntar override manual: "O prefix derivado <X> colide com <Y>. Qual prefix usar?"

**Exemplos:**
- "Shelflix" -> project: shelflix, token_prefix: sf
- "Acme Corp" -> project: acme-corp, token_prefix: ac
- "Boutique" -> project: boutique, token_prefix: bo

## Q2 - Vendor primitives (Radix/shadcn)

**Pergunta:** "Esse projeto permite usar @radix-ui ou shadcn como base de componentes complexos (Dialog, Combobox, DatePicker)?"

**Opcoes:**
- Sim, com whitelist controlada (recomendado pra apps complexos)
- Sim, livre
- Nao, A11y nativa em tudo (default conservador)

**Output:**
- `vendor.allow_radix`, `vendor.allow_shadcn`
- `vendor.vendor_whitelist` (se whitelist)
- `vendor.preferred_a11y_strategy`

## Q3 - Lista de components com vendor permitido (so se Q2 == whitelist)

**Pergunta:** "Quais components podem usar vendor primitives? (lista separada por virgula)"

**Default sugerido:** Dialog, AlertDialog, Combobox, CommandMenu, DatePicker, DropdownMenu, Popover, Tooltip, ScrollArea, RadioGroup, Tabs, Toast

**Output:** `vendor.vendor_whitelist`

## Q4 - CSS strategy

**Pergunta:** "Permite CVA (class-variance-authority) em adapters React?"

**Default:** Nao (CVA gera fricao de manutencao).

**Output:** `css.allow_cva`

**Pergunta adicional:** "Permite Tailwind arbitrary syntax tipo bg-[#hex] direto?"

**Default:** Nao (tokens sempre).

**Output:** `css.allow_tailwind_arbitrary`

## Q5 - Components complexos

**Pergunta:** "Quais components nao-triviais o projeto precisa logo de cara? (Dialog, Toast, DataTable, etc.)"

Output: usado pra pre-popular `tasks/map-components.md` queue.

## Q6 - Compliance/regulamentacao

**Pergunta:** "Algum requisito de compliance que afeta o DS? (WCAG AAA obrigatorio, LGPD/GDPR cookies, etc.)"

**Output:** `compliance: { wcag_level: AA|AAA, ... }`

## Q7 - Stack

**Pergunta:** "Framework + bundler + styling stack?"

**Defaults:**
- framework: react
- bundler: vite
- styling: tailwind-v4

**Output:** `build.framework`, `build.bundler`, `build.styling`

## Q8 - Quality Lenses

**Pergunta:** "Quais lentes de qualidade vamos auditar nesse projeto?"

**Opcoes (multi-select):**
- `visual` — mds-ui (tema, layout, responsive, contraste, motion). Default ON pra DS.
- `ux` — mds-ux (Nielsen, heuristics, anti-patterns, IA). Default ON pra DS.
- `content` — microcopy + tone of voice. ON quando projeto tem dimensao editorial forte.
- `performance` — Core Web Vitals + bundle. ON pra projetos com SLA de perf.
- `brand` — brand consistency. ON pra marketing/landing/portfolio.
- `a11y` — joint UI+UX destacado. ON pra projetos com compliance WCAG AAA.

**Default DS:** `[visual, ux]`. Cobre 90% dos casos.

**Output:** `quality_lenses: [<lista>]`

**Validacoes:**
- Pelo menos 1 lens declarada
- Se squad declara compliance WCAG AAA na Q6, forca incluir `a11y` na Q8
- Lenses raras (content, brand, performance) requerem que o agent correspondente exista no squad — senao warn

**Por que essa pergunta importa:**
- Define quais agents do squad sao acionados em audits (mds-ui se visual; mds-ux se ux; etc.)
- Influencia pre-delivery checks aplicados
- Quando squad expandir pra novos dominios (Marketing, Sales), basta declarar lens nova — squad ja preparado.

**Output:** `build.framework`, `build.bundler`, `build.styling`

# Output

1. **`config/squad-policy.yaml`** completo, derivado das 7 respostas. Usa `squad-policy.template.yaml` como base.

2. **Memory file `project_<name>_policy.md`** com:
   - Resumo das decisoes
   - Justificativas dos defaults usados
   - Pendencias (ex: se compliance WCAG AAA, lembrar de configurar audit checks mais rigorosos)

3. **Confirmacao ao user**: "Policy registrada. Squad pronto pra operar com prefix `--<prefix>-*` e <vendor strategy>."

# Pos-execucao

- `mds-orchestrator` re-carrega policy
- Roteamento futuro respeita decisoes (zero-Radix se allow_radix: false, etc.)
- Todo token gerado a partir daqui usa o prefix declarado
