# Source Tree — magic-ds

Mapa de pastas do squad. Atualizado em 2026-05-19 (Round 5).

---

## Estrutura

```
squads/magic-ds/
│
├── README.md                  # entry point público (o que é, pipeline, como usar)
├── CLAUDE.md                  # instruções de operação para Claude neste squad
├── IDEATION.md                # design original e racional de composição dos agentes
├── squad.yaml                 # manifesto AIOS: identidade, components[], config, tags
│
├── agents/                    # 10 agentes especializados — hand-crafted
│   ├── mds-orchestrator.md    # roteador JSON silencioso (Flow_Master)
│   ├── mds-librarian.md       # memória e índice do DS (Knowledge_Curator)
│   ├── mds-ui.md              # inspetor visual (Visual Inspector) — Round 5
│   ├── mds-ux.md              # avaliador UX + design-check (UX Evaluator) — Round 5
│   ├── mds-audit.md           # DEPRECATED Round 5 — redireciona pra ui/ux
│   ├── mds-foundations.md     # arquiteto de tokens 3 camadas (Architect)
│   ├── mds-tokens.md          # guardião de tokens.json + build CSS (W3C Authority)
│   ├── mds-governance.md      # guardião de contratos e naming (Guardian)
│   ├── mds-component.md       # mapeador de componente + a11y (Scribe)
│   └── mds-ops.md             # gerador de código canonical + adapter (Builder)
│
├── tasks/                     # 14 tasks atômicas — hand-crafted
│   ├── onboarding-policy.md   # 8 perguntas estruturadas pra novos projetos
│   ├── visual-grooming.md     # extração de tokens de imagem/URL
│   ├── build-foundations.md   # estrutura 3 camadas, gera delta JSON
│   ├── validate-tokens-json.md # 15 checks W3C + prefix + coverage
│   ├── build-tokens.md        # roda build-tokens.mjs, gera tokens-generated.css
│   ├── figma-tokens-sync.md   # sync bidirecional com Figma Variables
│   ├── enforce-governance.md  # valida naming, Theme Contract, Matrix
│   ├── map-components.md      # mapeia API, BEM, a11y de componente
│   ├── generate-ops-code.md   # gera canonical HTML+CSS e adapter React+TW
│   ├── build-local-showcase.md # constrói showroom local (DS Inspector)
│   ├── audit-showcase.md      # 6 categorias de auditoria do showroom
│   ├── index-state.md         # indexa estado atual dos artefatos
│   ├── lookup-artifact.md     # busca artefato específico no índice
│   └── diff-snapshots.md      # diff entre dois snapshots do DS
│
├── workflows/                 # pipelines — hand-crafted
│   └── magic-ds-pipeline.yaml # pipeline completo com branches, gates, HITL
│
├── templates/                 # schemas para novos specs — hand-crafted
│   ├── index.template.md      # template de índice de estado
│   └── component.spec.template.yaml # schema de spec de componente
│
├── checklists/                # quality gates — hand-crafted
│   ├── nielsen-heuristics-checklist.md
│   ├── a11y-wcag-checklist.md
│   ├── design-principles-checklist.md
│   ├── multi-theme-checklist.md       # Round 5
│   ├── responsive-checklist.md        # Round 5
│   ├── layout-regression-checklist.md # Round 5
│   ├── ui-pre-delivery-checklist.md
│   ├── ui-pro-max-pre-delivery.md
│   ├── ui-ux-pro-max-guidelines.md    # 99 guidelines UX
│   ├── ui-pro-max-ui-checks.md        # ~110 UI checks
│   ├── ui-pro-max-ux-checks.md        # ~73 UX checks
│   └── ui-pro-max-a11y-joint.md       # 20 a11y checks
│
├── config/                    # configuração do squad e do projeto — hand-crafted
│   ├── squad-policy.yaml      # política ativa (vendor, CSS, validators, prefix)
│   ├── squad-policy.template.yaml # template para novos projetos
│   ├── coding-standards.md    # naming, formato, linguagem
│   ├── tech-stack.md          # runtime, frameworks, dependências
│   └── source-tree.md         # este arquivo
│
├── foundations/               # documentação arquitetural — hand-crafted, não editar sem motivo
│   ├── 07-token-architecture-v3.md    # arquitetura 3 camadas (Primitive→Semantic→Component)
│   ├── 08-arquitetura-3-andares.md    # modelo 3 andares Shelflix
│   ├── 03-foundation-dimensions.md    # 8 dimensões do design
│   ├── 05-foundations-round-1-5.md    # histórico round 1.5
│   ├── 06-foundations-round-1-6.md    # histórico round 1.6
│   ├── 02-token-architecture.md       # versão 1 (histórico)
│   └── 02-token-architecture-v2.md    # versão 2 (histórico)
│
├── governance/                # 13 policies lidas pelos agentes no boot — hand-crafted
│   ├── prefix-policy.md               # regra de prefix --<prefix>-*, enforcement
│   ├── showroom-dynamic-policy.md     # showroom DEVE derivar de tokens.json
│   ├── theme-contract.md              # 28 tokens mínimos em semantic-dark
│   ├── matrix.md                      # matriz de responsabilidade entre camadas
│   ├── component-kinds.md             # tipos: generic vs domain
│   ├── ui-ux-ownership.md             # qual agente audita o quê (Round 5)
│   ├── skills-routing.md              # routing por verb do usuário
│   ├── squad-policy.md                # documentação da squad-policy
│   ├── sync-rules.md                  # regras de sincronização de artefatos
│   ├── 03-governance-validation.md    # protocolo de validação
│   ├── external-knowledge-import-manifest.md
│   ├── external-knowledge-sources.md
│   └── external-knowledge-translation-rules.md
│
├── component/                 # specs YAML de componentes — gerado/hand-crafted misto
│   # estrutura interna: generic/, domain/, background/ (ver component-kinds.md)
│
├── output/                    # GERADO — não editar manualmente
│   ├── css/                   # CSS canonical por bloco BEM (<block>.css)
│   └── html/                  # HTML canonical por bloco BEM (<block>.html)
│
├── showcase/                  # GERADO — DS Inspector / showroom dinâmico
│   # derivado de tokens.json; nunca hardcoded (ver showroom-dynamic-policy.md)
│
├── references/                # specs de formato AIOS adaptados para este squad — hand-crafted
│   ├── agent-format.md        # schema de agente magic-ds (frontmatter + seções)
│   ├── task-format.md         # schema de task magic-ds (contratos Entrada/Saída)
│   ├── workflow-format.md     # schema de workflow magic-ds
│   └── squad-yaml-schema.md   # schema do squad.yaml
│
├── themes/                    # configurações de tema por projeto consumidor — hand-crafted
│
├── audit/                     # resultados de auditorias pontuais — gerado
│
└── handoffs/                  # docs de transição entre rounds — hand-crafted
```

---

## Notas de naming

- Agentes: `mds-<função>.md` (kebab-case, prefixo `mds-`)
- Tasks: `<ação-nome>.md` (kebab-case, derivado do camelCase identifier da task)
- Workflows: `<nome-do-squad>-<propósito>.yaml` (kebab-case, extensão .yaml)
- Componentes: `<Name>.spec.yaml` em `component/<kind>/`
- Output CSS: `<block>.css` onde `<block>` é o nome BEM do componente
- Output HTML: `<block>.html`

## Legenda

- **hand-crafted** — mantido manualmente; edições fazem parte do fluxo normal de trabalho do squad
- **GERADO** — artefato produzido pelos agentes; não editar diretamente
- **DEPRECATED** — mantido por compatibilidade; não usar em fluxos novos
