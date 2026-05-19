# Magic-DS

> Squad especializado em Design System Engineering — arquitetura 3 camadas, tokens W3C, outputs canônicos CSS+HTML e adapters React/Tailwind, multi-product e multi-tenant.

## Instalação rápida

Rode na raiz do projeto onde você quer instalar.

**macOS / Linux / WSL / git-bash:**

```bash
curl -fsSL https://raw.githubusercontent.com/inguz-studio/magic-design-system/main/install.sh | bash
```

**Windows (PowerShell):**

```powershell
iwr -useb https://raw.githubusercontent.com/inguz-studio/magic-design-system/main/install.ps1 | iex
```

O instalador vai:

1. Clonar o squad em `squads/magic-ds/`
2. Perguntar nome do projeto e token prefix (defaults auto-detectados do `package.json`)
3. Gerar `squads/magic-ds/config/squad-policy.yaml` populado
4. Criar `src/styles/tokens.json` vazio (se ainda não existir)

Pré-requisito: `git` instalado.

### Instalação manual (se preferir inspecionar antes)

```bash
git clone https://github.com/inguz-studio/magic-design-system.git squads/magic-ds
bash squads/magic-ds/install.sh        # Linux/Mac/WSL
# ou no Windows:
.\squads\magic-ds\install.ps1
```

Depois de instalado, abra o Claude Code na raiz do projeto e mande qualquer demanda de DS — o `mds-orchestrator` é a porta de entrada. Veja exemplos em [Como invocar](#como-invocar).

## O que esse squad faz

- Estrutura tokens de design em 3 camadas: Primitive (escala física) → Semantic (papel na UI, com sets por produto/modo) → Component (aplicação BEM)
- Gera output canônico CSS+HTML puro (zero dependências externas) e adapter React+Tailwind opcional
- Audita fidelidade visual (layout, contraste, theme, density) e heurísticas UX (Nielsen, IA, microcopy) em dois pipelines independentes
- Gerencia múltiplos produtos e tenants via CSS Custom Properties com prefix declarado
- Mantém showroom dinâmico derivado de `tokens.json` — nunca hardcoded

## Quando usar

| Situação | Agente de entrada |
|---|---|
| Qualquer input — o squad sempre começa aqui | `mds-orchestrator` |
| Criar ou refatorar tokens (primitivos, semânticos, por produto) | `mds-foundations` |
| Validar `src/styles/tokens.json` e gerar CSS derivado | `mds-tokens` |
| Auditar fidelidade visual, contraste, layout, theme | `mds-ui` |
| Auditar usabilidade, heurísticas Nielsen, fluxo, microcopy | `mds-ux` |
| Consultar o que já existe no DS hoje | `mds-librarian` |
| Validar nomenclatura, Theme Contract, Governance Matrix | `mds-governance` |
| Mapear props, BEM vocab, a11y de um componente novo | `mds-component` |
| Gerar código canonical ou adapter React | `mds-ops` |

## Estrutura do squad

```
squads/magic-ds/
├── README.md              # este arquivo — entry point público
├── CLAUDE.md              # instruções de operação para Claude
├── IDEATION.md            # design original e racional de composição
├── squad.yaml             # manifesto AIOS (agentes, tasks, workflows, config)
├── agents/                # 10 agentes especializados (.md por agente)
├── tasks/                 # 14 tasks atômicas reutilizáveis
├── workflows/             # pipeline principal (magic-ds-pipeline.yaml)
├── templates/             # schemas para novos specs de componente
├── checklists/            # quality gates (Nielsen, WCAG, design-check, UI/UX)
├── config/                # squad-policy.yaml, source-tree.md, tech-stack.md, coding-standards.md
├── foundations/           # docs arquiteturais (token architecture v3, modelo 3 andares, etc.)
├── governance/            # 13 policies e contratos (prefix, showroom, theme-contract, etc.)
├── component/             # specs YAML de componentes (generic/, domain/, background/)
├── output/                # CSS + HTML canônicos gerados (artefato — não editar manualmente)
├── showcase/              # DS Inspector / showroom (artefato gerado dinamicamente)
├── references/            # specs de formato: agent-format, task-format, workflow-format, squad-yaml-schema
├── themes/                # configurações de tema por projeto consumidor
├── audit/                 # resultados de auditorias pontuais
└── handoffs/              # docs de transição entre rounds de desenvolvimento
```

- **agents/** — cada agente tem frontmatter YAML (identidade, persona, commands) + seções Markdown (Quick Commands, Agent Collaboration, Usage Guide)
- **tasks/** — contratos explícitos Entrada/Saída + checklist de validação
- **workflows/** — sequência de agentes com transitions e success indicators
- **config/** — política do projeto (`squad-policy.yaml`), stack, padrões de código e mapa de pastas
- **foundations/** — documentação arquitetural canônica (não editar sem motivo real)
- **governance/** — policies lidas no boot pelos agentes; definem regras de comportamento
- **output/** e **showcase/** — artefatos gerados; nunca editar manualmente
- **references/** — specs dos formatos AIOS adaptados para este squad

## Os agentes

| Agente | Papel | Comando principal |
|---|---|---|
| `mds-orchestrator` | Roteador JSON silencioso — recebe qualquer input e decide quem age | `*route` |
| `mds-librarian` | Memória do squad — indexa estado atual e detecta drift | `*lookup`, `*index`, `*diff` |
| `mds-ui` | Inspetor visual — theme, layout, contraste WCAG, density, motion | `*audit-ui` |
| `mds-ux` | Avaliador UX — heurísticas Nielsen, fluxo, IA, microcopy, design-check | `*heuristic-audit`, `*design-check` |
| `mds-audit` | DEPRECATED desde Round 5 — redireciona pra `mds-ui` ou `mds-ux` | — |
| `mds-foundations` | Arquiteto de tokens — 3 camadas, escalas, token sets, delta JSON | `*build-foundations` |
| `mds-tokens` | Guardião do `tokens.json` — validação W3C, build CSS, coverage | `*validate-json`, `*build-css` |
| `mds-governance` | Guardião de contratos — naming, prefix, Theme Contract, Matrix | `*enforce-governance` |
| `mds-component` | Mapeador de componente — props, BEM vocab, a11y nativa | `*map-component` |
| `mds-ops` | Gerador de código — canonical HTML+CSS e adapter React+TW | `*generate-ops-code` |

## Pipeline canônico

```
Input do usuário
      |
  mds-orchestrator  (JSON routing — sempre primeiro)
      |
      |── visual/URL input ──► mds-ui ──► mds-foundations
      |── heuristic/fluxo  ──► mds-ux ──► mds-foundations
      |── audit sem qualificador ──► mds-ui + mds-ux (paralelo, scores independentes)
      |── consulta ("o que existe?") ──► mds-librarian
      |── novo componente ──► mds-component ──► mds-governance ──► [mds-ux *design-check] ──► mds-ops
      |── tokens/escalas ──► mds-foundations ──► mds-tokens ──► mds-governance ──► mds-ops
      |── só gerar código ──► mds-ops (canonical primeiro; adapter se solicitado)
      |── nomenclatura/policy ──► mds-governance
      └── intenção ambígua ──► clarify (devolve pro usuário)

mds-ops saída:
  ├── canonical: squads/magic-ds/output/ (HTML+CSS BEM, zero deps)
  └── adapter:   src/components/ (React+Tailwind, se target=adapter ou all)
```

Human-in-the-loop obrigatório após `mds-ux *design-check` e após `mds-foundations` — o pipeline pausa para aprovação antes de avançar.

## Como invocar

Via slash command (após deploy no projeto AIOS):

```
/mds:mds-orchestrator     — entrada padrão para qualquer demanda
/mds:mds-foundations      — estruturar tokens diretamente
/mds:mds-component        — mapear componente novo
/mds:mds-ops              — gerar código canonical ou adapter
/mds:mds-librarian        — consultar estado atual do DS
/mds:mds-governance       — validar nomenclatura e contratos
```

Via texto natural (sempre passa pelo orchestrator):

```
"Cria a escala de spacing pra o produto Admin"
"Audita o contraste do botão primário no tema dark"
"O que já tem de componentes no DS?"
"Gera o adapter React do Button"
```

## Convenções importantes

**3 andares (modelo mental Shelflix):**
- Térreo: esqueleto compartilhado pelos 4 produtos (status, neutros, espaços, fonte)
- 1° andar: personalidade de cada produto (Admin glass+denso, Mission flat+médio)
- 2° andar: cor do cliente (white-label, só num produto)
- Regra: "se mudar esse valor, em quantos produtos/clientes muda?" determina em qual andar o token mora

**CSS-first:**
- Output canônico é CSS+HTML puro — fonte real do DS
- React+Tailwind é transformação derivada opcional, nunca a fonte
- Tokens vivem em `src/styles/tokens.json` (W3C Design Tokens format)
- CSS gerado é `src/styles/tokens-generated.css` — artefato, nunca editado direto

**Prefix:**
- Todo token usa `--<prefix>-*` onde prefix vem de `config/squad-policy.yaml`
- Prefix padrão Shelflix: `sf` → `--sf-bg-canvas`, `--sf-action-primary-bg`
- Sem prefix declarado: onboarding obrigatório antes de qualquer ação

**A11y policy-driven:**
- `config/squad-policy.yaml` define se Radix/shadcn é permitido e quais componentes
- Shelflix Admin: `allow_radix: true` + whitelist de 12 componentes overlay
- Componentes fora da whitelist: a11y nativa obrigatória

**Showroom dinâmico:**
- Showcase deriva listas (steps, roles, sizes) de `tokens.json` em runtime
- Hardcode proibido — ver `governance/showroom-dynamic-policy.md`

## Governance

Policies lidas pelos agentes no boot. Estão em `governance/`:

| Arquivo | O que define |
|---|---|
| `prefix-policy.md` | Regra de prefix `--<prefix>-*`, prefixes reservados, enforcement |
| `showroom-dynamic-policy.md` | Showroom DEVE derivar de tokens.json — nunca hardcoded |
| `theme-contract.md` | 28 tokens mínimos obrigatórios em `semantic-dark` |
| `matrix.md` | Matriz de responsabilidade entre camadas e agentes |
| `component-kinds.md` | Tipos de componente: generic vs domain |
| `ui-ux-ownership.md` | Qual agente audita o quê (UI vs UX split, Round 5) |
| `skills-routing.md` | Routing por verb: audit/check/validar vs critique/review |
| `squad-policy.md` | Regras de A11y vendor por projeto |
| `prefix-policy.md` | Token prefix e enforcement |
| `sync-rules.md` | Regras de sincronização de artefatos |
| `03-governance-validation.md` | Protocolo de validação de governance |
| `external-knowledge-*.md` | Manifesto e regras de importação de conhecimento externo |

## Documentação relacionada

- `foundations/07-token-architecture-v3.md` — arquitetura 3 camadas completa (Primitive → Semantic sets → Component)
- `foundations/08-arquitetura-3-andares.md` — modelo mental 3 andares (Shelflix específico)
- `foundations/03-foundation-dimensions.md` — 8 dimensões do design (Spacing, Typography, Shadow, Motion, etc.)
- `config/squad-policy.yaml` — política ativa do projeto (vendor, CSS strategy, validators)
- `workflows/magic-ds-pipeline.yaml` — pipeline completo com branches e gates
