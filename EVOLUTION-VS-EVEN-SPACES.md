# Magic-DS — Evolução sobre Even Spaces DS + SFD

> Documento de rastreabilidade: o que o Magic-DS herdou da metodologia Even Spaces / Structure First Design, o que evoluímos sobre essa base, e onde permanecem gaps a importar.
>
> **Fontes canônicas analisadas:**
> - `Riser/modulos/modulo-01/framework-structure-first-design/SFD-Conceito-Modulo1.md`
> - `Riser/modulos/modulo-02/material de apoio/even-spaces-ds-arquitetura.md`
> - `Riser/modulos/modulo-02/material de apoio/even-spaces-ds-worklist.md`
> - `Riser/modulos/modulo-02/material de apoio/even-space-agents/*.md`
> - `Riser/modulos/modulo-02/Projeto Even/design.md` (caso aplicado Even Studio)
>
> **Status:** v1 — 2026-05-14

---

## 1. Origem conceitual

### 1.1 Structure First Design (SFD)
Metodologia que estabelece **estrutura precede design**. Combate G.I.G.O (Garbage In, Garbage Out) com base de conhecimento estruturada que alimenta IA via RAG (Retrieval-Augmented Generation).

**Artefatos SFD que o Magic-DS produz:**
- ✅ Documento de contexto (`audit/04-figma-complete-audit.md`)
- ✅ Diagramas de fluxo (parcial — workflows YAML, sem visual)
- ✅ Inventário de componentes (`audit/04` + `component/*.spec.yaml`)
- ✅ Relatório de validação (`*design-check` produz score A/B/C/D)

### 1.2 Even Spaces DS
Design System fictício do bootcamp, com arquitetura multi-marca (Arquitetura/Paisagismo/Interiores) × multi-mode (Light/Dark) = 6 contextos servidos por componentes unificados.

**Arquitetura de 4 coleções no Figma:**
```
COMPONENTS  ← usa tokens semânticos
MODE        ← aparência (Light / Dark)
THEME       ← marca/identidade (Arquitetura / Paisagismo / Interiores)
FOUNDATIONS ← valores brutos
```

---

## 2. Mapeamento Even Spaces ↔ Magic-DS

### 2.1 Camadas

| Even Spaces | Magic-DS | Equivalência |
|-------------|----------|--------------|
| Foundations | Primitives | ✅ Idêntico (raw values, nunca per-tenant) |
| Theme (3 modos: marcas) | Hubs (7 canônicos: primary/secondary/accent + danger/success/warning/info) | ⚠️ **Renomeado e consolidado** — Hubs nomeia o que Theme implicita |
| Mode (2 modos: Light/Dark) | Cascata CSS `[data-tenant][data-theme]` | ⚠️ **Implementado via scoping** em vez de coleção formal |
| Components | Components (futuro layer no spec.yaml) | ✅ Mesmo conceito |

### 2.2 Cadeia de resolução

| Even Spaces | Magic-DS |
|-------------|----------|
| `Component → Theme → Mode → Foundations` | `Component → Semantic → Hubs → Primitives` |

Mesma profundidade (4 saltos), nomenclatura diferente.

### 2.3 Agentes

| Even Spaces | Magic-DS | Status |
|-------------|----------|--------|
| Orchestrator (JSON routing) | mds-orchestrator | ✅ Aderência total |
| Foundations | mds-foundations | ✅ Idêntico |
| Semantic | (integrado em mds-foundations + mds-governance) | ⚠️ Não temos agente dedicado |
| Components | mds-component | ✅ Idêntico |
| Validator | mds-audit (`*design-check`) | ✅ Equivalente |
| Docs | (ainda não temos — futura "Fase 7") | ❌ Gap |
| Exporter | mds-ops | ✅ Idêntico |
| — | mds-librarian (consulta de estado) | 🆕 **Adição nossa** |
| — | mds-audit (também faz audit Figma) | 🆕 **Expansão do agente** |

### 2.4 Workflow

| Even Spaces | Magic-DS | Equivalência |
|-------------|----------|--------------|
| `FIGMA_PROPOSE:{...}` antes de gravar | Gates `FIGMA_PROPOSE` + `*design-check` obrigatório | ✅ Mesmo princípio, +1 gate |
| Skills com SKILL.md + frontmatter YAML | Agents com AIOS schema completo | ✅ Mesma filosofia, schema mais rico |
| DS_CTX em system prompt | Docs + checklists carregados via dependencies | ✅ Mesma estratégia |
| Pipeline 4 fases (Audit → Foundations → Governance → Ops) | Mesmo pipeline | ✅ Aderência total |

---

## 3. O que herdamos rigorosamente

1. **Camadas estritas com regra inquebrável** — componente nunca consome direto da camada N-2 ou abaixo.
2. **Pipeline 4 fases canônicas** (Audit → Foundations → Governance → Ops).
3. **Orchestrator pattern** com JSON estruturado para roteamento dinâmico.
4. **Multi-agente especializado** seguindo Single Responsibility Principle.
5. **Human-in-the-loop antes de gravar no source** (Figma ou código).
6. **DS_CTX separado de execução** — contexto vive em docs, código só roteia.
7. **Cores em escala de stops** (50, 100... — Even Spaces vai até 950; nós até 900 atualmente).
8. **Estados canônicos** (default / hover / focus / disabled).
9. **Convenção `on-*`** para texto/ícone sobre fundo colorido.
10. **Componentes Figma documentados em .md** (nosso `contract.yaml` é equivalente machine-readable).

---

## 4. Onde evoluímos sobre a base

### 4.1 Hubs como camada canônica explícita
**Even Spaces:** Theme coleção tem 3 modos mas não nomeia os "hubs" — cada marca define seus próprios action/primary, error, success.

**Magic-DS:** 7 hubs canônicos universais (`--hub-primary/secondary/accent + danger/success/warning/info`). Trocar tenant = remapear apenas esses 7. Multi-tenant explícito como cidadão de primeira classe.

**Justificativa:** nosso caso é N tenants (potencial) com 1 marca cada. Even Spaces é 1 cliente com N marcas. Tecnicamente convergem; Hubs deixa o ponto de troca explícito.

### 4.2 `rhythm:` obrigatório em todo spec.yaml
**Even Spaces:** Ritmo vertical não é formalizado em spec.

**Magic-DS:** Bloco `rhythm:` obrigatório (decisão squad 2026-05-13) com 6 propriedades + escala canônica L0-L6 + 8 regras hard.

**Justificativa:** ritmo vertical impacta diretamente qualidade visual e era ad-hoc em cada componente. Formalizar elimina drift.

### 4.3 `design-check` com 14 princípios consolidados
**Even Spaces:** Validator agente existe mas escopo focado em WCAG/Nielsen.

**Magic-DS:** `*design-check` aplica 14 princípios consolidados de **3 fontes** (Figma PT-BR + Kittl + Lagerwall). Score A/B/C/D bloqueia handoff em D, força refatoração em C.

**Justificativa:** princípios de design gráfico (Hierarquia, Contraste, Equilíbrio, Alinhamento, Proximidade, Repetição, Ritmo, Espaço em Branco, Proporção, Movimento, Ênfase, Cor, Unidade, Escaneabilidade) estavam ausentes da validação. Camada paralela a Nielsen+WCAG.

### 4.4 shadcn isolado em `/src/vendor/`
**Even Spaces:** Não documenta vendor isolation.

**Magic-DS:** Primitivos shadcn em `/src/vendor/` (NUNCA exportados pelo `src/index.ts`). Wrappers públicos em `/src/components/atoms|molecules|organisms/<Name>/` consomem via `@/vendor/{primitive}`.

**Justificativa:** swap futuro de biblioteca primitiva (Radix → Ark → custom) deve impactar APENAS `/src/vendor/`. API pública permanece estável. Princípio "shadcn é detalhe de implementação".

### 4.5 Atomic Design no output (`/src/components/`)
**Even Spaces:** Worklist segue ordem de complexidade (Botões → Formulários → Layout → Feedback → Navegação → Dados) mas não formaliza taxonomia atômica.

**Magic-DS:** Estrutura explícita `atoms/`, `molecules/`, `organisms/`, `templates/` em `/src/components/`. Cada spec.yaml declara `atomic_level:`.

**Justificativa:** taxonomia escalável; ~50 pastas pré-criadas servem como roadmap visual.

### 4.6 Foundations em rounds incrementais
**Even Spaces:** Arquitetura documentada em 1 doc principal.

**Magic-DS:** `foundations/02-token-architecture.md` (Round 1) + `foundations/05-foundations-round-1-5.md` (Round 1.5) + `foundations/06-foundations-round-1-6.md` (Round 1.6).

**Justificativa:** Foundations evolui quando design-check detecta gaps (ex: `--semantic-bg-danger-solid` foi criado em R1.6 porque Button.spec.yaml declarou `gaps_for_foundations`). Rounds preservam timeline sem refatorar doc base.

### 4.7 Showroom React live consumindo `/src/components/`
**Even Spaces:** Showcase no Figma.

**Magic-DS:** `src/showroom/App.jsx` em Vite + React importa diretamente `@/components/atoms/Button` etc. Single source of truth.

**Justificativa:** quando adicionar componente novo, basta criar a pasta + importar — aparece automaticamente no showroom. Zero divergência preview ↔ produção.

### 4.8 Multi-tenant explícito via scoping ortogonal
**Even Spaces:** Multi-marca (3 marcas Even Spaces) via Theme com 3 modos no Figma.

**Magic-DS:** `[data-tenant="shelflix"][data-theme="dark"]` em CSS — scoping ortogonal. Tenant e theme são dimensões independentes. Novo tenant = novo bloco no scope.

**Justificativa:** caso de uso N clientes (não 1 cliente N marcas). Convergência arquitetural via CSS Variables.

---

## 5. Gaps reais — o que falta importar do Even Spaces

### 5.1 Stop 950 de cor (P1)
**Even Spaces:** Cores em 10 stops (50, 100... 950).
**Magic-DS:** 9 stops (50, 100... 900). Falta o 950.

**Impacto:** dark mode high-contrast precisa de extremo. Stop 900 é gray-puro-preto (#000000) na nossa escala — não há onde "ir mais escuro" pra estados sem perder identidade.

**Ação proposta:** adicionar `--primitive-brand-950`, `--primitive-gray-950`, e os 950 dos feedback colors. Esforço baixo (~10 tokens).

### 5.2 Breakpoints tokenizados como coleção própria (P1)
**Even Spaces:** 5ª coleção com 4 modos (Desktop 1440 / Laptop 1024 / Tablet 768 / Mobile 375). Escala tipográfica responsiva por breakpoint.

**Magic-DS:** Sem breakpoints tokenizados. Componentes hardcoded com `@media` ad-hoc.

**Impacto:** Responsivo sem disciplina vira mágico/duplicado. Type scale não responde a viewport.

**Ação proposta:** criar `src/styles/breakpoints.css` (ou bloco no `tokens.css`) com `--breakpoint-{desktop|laptop|tablet|mobile}` + `--responsive-type-{role}-{viewport}`. Esforço médio.

### 5.3 Convenção `subtle/muted/strong` para intensidade (P2)
**Even Spaces:** Tokens semantic usam `subtle/muted/strong` (intensidade) + `on-subtle/on-muted/on-strong` (texto sobre).

**Magic-DS:** Primitives usam `light/base/dark` (escala de stop); Semantic não tem dimensão de intensidade explícita.

**Impacto:** mapeamento intensidade ↔ stop não é semântico. Convenção Even Spaces é mais flexível (intensidade independente do stop específico).

**Ação proposta:** adicionar camada de tokens semantic-by-intensity. Ex: `--semantic-bg-brand-subtle/muted/strong`. Esforço médio. Coexiste com hubs atuais.

### 5.4 Worklist explícito por fases (P3)
**Even Spaces:** 7 fases numeradas com lista exaustiva de componentes + tokens + Doc.

**Magic-DS:** "Ondas" mencionadas (Onda 1 entregue, Onda 2 planejada) mas sem worklist formal.

**Ação proposta:** criar `squads/magic-ds/WORKLIST.md` com fases 1-7 alinhadas ao Even Spaces, marcando componentes Magic-DS equivalentes. Esforço baixo.

### 5.5 Agente Docs (Fase 7 do Even Spaces) (P3)
**Even Spaces:** Após componente estável, agente CMP gera documentação .md humana (Visão geral · Props · Tokens · Estados · A11y · Exemplos).

**Magic-DS:** Temos `contract.yaml` machine-readable mas não doc humana renderizada.

**Ação proposta:** adicionar `mds-docs` agente que consome `contract.yaml` + gera `<Componente>.mdx` (Storybook autodocs já cobre parcialmente).

---

## 6. Adições Magic-DS sem precedente no Even Spaces

1. **Hubs nomeados como camada explícita** (Primary/Secondary/Accent + Danger/Success/Warning/Info como vocabulário canônico universal).
2. **`rhythm:` block obrigatório em spec.yaml** + 8 regras hard binárias.
3. **`design-check` com 14 princípios** consolidados (Figma+Kittl+Lagerwall).
4. **shadcn isolation em `/src/vendor/`** com greps de validação no `*validate-output`.
5. **Atomic Design taxonomy** em `/src/components/atoms|molecules|organisms|templates/`.
6. **Foundations rounds incrementais** (R1 → R1.5 → R1.6 com decisões timestamped).
7. **`gaps_for_foundations` em spec.yaml** — loop-back formal Component → Foundations.
8. **`*design-check` como gate obrigatório** entre Component e Ops (score mínimo B).
9. **mds-librarian agente de consulta de estado** ("isso já existe?").
10. **5 formatos de fluxo** documentados no Orchestrator (cascata / parcial / single / fan-out / loop-back).

---

## 7. Resumo executivo

| Dimensão | Even Spaces | Magic-DS | Score |
|----------|:-----------:|:--------:|:-----:|
| Camadas de tokens | 4 (com Mode) | 4 (com Hubs) | ✅ Equivalente |
| Multi-identidade | Multi-marca | Multi-tenant | ✅ Equivalente |
| Pipeline de agentes | 4 fases | 4 fases + design-check | ✅ Magic-DS expande |
| Orchestrator | JSON routing | JSON routing rico | ✅ Magic-DS expande |
| HITL | FIGMA_PROPOSE | FIGMA_PROPOSE + design-check gates | ✅ Magic-DS expande |
| Stops de cor | 10 (50-950) | 9 (50-900) | ❌ **Magic-DS gap** |
| Breakpoints tokenizados | Sim (5ª coleção) | Não | ❌ **Magic-DS gap** |
| Convenção subtle/muted/strong | Sim | Não (usa light/base/dark) | ⚠️ **Magic-DS gap menor** |
| Ritmo vertical formalizado | Não | Obrigatório em spec | 🆕 Magic-DS adição |
| Design-check 14 princípios | Não (só WCAG/Nielsen) | Sim | 🆕 Magic-DS adição |
| shadcn isolation | Não documenta | Formalizado | 🆕 Magic-DS adição |
| Atomic Design taxonomy | Não explícito | Formalizado | 🆕 Magic-DS adição |
| Showroom live React | Não (Figma) | Sim (Vite) | 🆕 Magic-DS adição |

**Score final:** Magic-DS é uma **evolução fiel** de Even Spaces + SFD com **8 adições** próprias e **3 gaps a importar** (P1: stop 950, breakpoints / P2: subtle-muted-strong / P3: worklist formal, agente Docs).

---

## 8. Roadmap de alinhamento (sugerido)

| Ação | Prioridade | Esforço | Quando |
|------|:----------:|:-------:|--------|
| Adicionar stop 950 em todas as escalas (brand, gray, feedback) | P1 | Baixo | Onda 2 |
| Tokenizar breakpoints como `--breakpoint-*` + type scale responsiva | P1 | Médio | Onda 2 |
| Adicionar convenção `subtle/muted/strong` em camada semantic | P2 | Médio | Onda 3 |
| Criar `WORKLIST.md` alinhado às 7 fases Even Spaces | P3 | Baixo | A qualquer momento |
| Adicionar `mds-docs` agente (Fase 7 — gera .mdx por componente) | P3 | Médio | Após Onda 2 estável |

---

*Magic-DS · Evolution Document · 2026-05-14 · v1*
