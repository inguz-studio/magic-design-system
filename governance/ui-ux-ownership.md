# UI / UX Ownership Matrix

**Status:** Adotado (Round 5) — Pre-condicao pra criacao de `mds-ui` + `mds-ux`
**Decidido em:** Conselho mds-orchestrator + squad-orchestrator (2026-05-18)
**Reviewed by:** Both orchestrators converged

---

## 0. Proposito

Define **quem (mds-ui ou mds-ux) e dono de cada zona de overlap**. Sem essa matriz, todo audit gera debate "isso e UI ou UX?". Com a matriz, decisao e mecanica: consulta tabela.

**Regra inquebravel:** todo artefato auditado/criado pelo squad mapeia pra UMA das 3 categorias abaixo:
- **UI exclusivo** — mds-ui dono
- **UX exclusivo** — mds-ux dono
- **Joint** — ambos contribuem, com declaracao explicita de quem faz o que

---

## 1. Vocabulario

| Termo | Definicao |
|---|---|
| **UI (Visual Fidelity)** | Como o artefato RENDERIZA. Pixel, layout, token, tema, responsive, motion. |
| **UX (Experience Quality)** | Como o artefato FUNCIONA pro usuario. Fluxo, IA, microinteractions, copy, error recovery. |
| **Joint** | Casos onde a fronteira nao e clara — declaramos ownership por sub-aspecto. |
| **Orchestrator dispatch** | mds-orchestrator roteia pra UI, UX, ou ambos em paralelo (joint command). |

---

## 2. Matriz de ownership por artefato

### 2.1 Token / Foundation

| Artefato | UI (mds-ui) | UX (mds-ux) |
|---|---|---|
| Cor primitive (--sf-primitive-*) | ✅ visual fidelity, contraste | — |
| Cor semantic (--sf-bg-*, --sf-text-*, etc.) | ✅ contraste WCAG | — |
| Cor support (apoio) | ✅ | — |
| Spacing scale | ✅ rhythm, consistency | — |
| Radius scale | ✅ | — |
| Motion duration/easing | ✅ token + curva | ⚠️ quando/porque animar |
| Shadow/elevation | ✅ | — |
| Typography type roles | ✅ visual hierarchy | ⚠️ heading hierarchy semantica (h1→h2→h3) |
| Iconography (size, stroke) | ✅ | — |
| Z-index roles | ✅ stacking | — |
| Grid/container | ✅ layout | — |
| Breakpoints | ✅ responsive | — |

### 2.2 Componentes — visual

| Aspecto | UI | UX |
|---|---|---|
| Cores aplicadas no componente | ✅ | — |
| Layout / dimensoes | ✅ | — |
| Estados visuais (hover, active, pressed, disabled) | ✅ | — |
| Foco visivel (focus ring) | ✅ pixel | ⚠️ ordem do tab |
| Sombras / elevation | ✅ | — |
| Motion no componente | ✅ duracao/curva | ⚠️ quando dispara |
| Responsive breakpoints | ✅ | — |
| Density adaptation | ✅ | ⚠️ touch target a11y |

### 2.3 Componentes — comportamento

| Aspecto | UI | UX |
|---|---|---|
| Props / variants / API | — | ✅ |
| Estados logicos (loading, success, error, empty) — visual | ✅ render | — |
| Estados logicos — quando entram, transicao, mensagem | — | ✅ |
| Microcopy (label, placeholder, error message) | — | ✅ |
| Tooltip — visual + posicionamento | ✅ | — |
| Tooltip — quando aparece, delay, conteudo | — | ✅ |
| Form validation — visual error | ✅ | — |
| Form validation — quando validar (blur/submit), recovery | — | ✅ |

### 2.4 Layout / Pagina

| Aspecto | UI | UX |
|---|---|---|
| Renderizacao do layout (sem overflow, sem clipping) | ✅ | — |
| Responsive breakpoints (renderiza em 375/768/1024/1440) | ✅ | — |
| Density (compact vs comfortable visual) | ✅ | — |
| Theme adaptation (dark vs light) | ✅ | — |
| Information architecture (estrutura, hierarquia) | — | ✅ |
| Fluxo do usuario (page A -> page B) | — | ✅ |
| Empty state (visual) | ✅ | — |
| Empty state (mensagem + acao) | — | ✅ |
| Error state (visual) | ✅ | — |
| Error state (recovery path) | — | ✅ |
| Loading state (visual: skeleton/spinner) | ✅ | — |
| Loading state (threshold de quando mostrar) | — | ✅ |

### 2.5 Navigation

| Aspecto | UI | UX |
|---|---|---|
| Visual da sidebar/topbar/tabs | ✅ | — |
| Active state visual | ✅ | — |
| IA da navegacao (estrutura, niveis, grouping) | — | ✅ |
| Tab order | — | ✅ |
| Back behavior (preserva scroll, state) | — | ✅ |
| Breadcrumbs (visual) | ✅ | — |
| Breadcrumbs (logica, hierarquia) | — | ✅ |
| Deep linking | — | ✅ |

### 2.6 Forms

| Aspecto | UI | UX |
|---|---|---|
| Visual do input (border, padding, focus state) | ✅ | — |
| Label visual | ✅ | ⚠️ posicao semantica |
| Error message visual | ✅ | — |
| Error message conteudo (mensagem + recovery) | — | ✅ |
| Inline validation timing (blur vs submit) | — | ✅ |
| Autofill behavior | — | ✅ |
| Required indicator visual | ✅ | — |
| Required indicator semantic (aria-required) | — | ✅ |
| Mobile keyboard type (`inputmode`) | — | ✅ |

### 2.7 Feedback

| Aspecto | UI | UX |
|---|---|---|
| Toast visual (cor, posicao, animacao) | ✅ | — |
| Toast timing (auto-dismiss 3-5s) | — | ✅ |
| Alert visual | ✅ | — |
| Alert recovery path | — | ✅ |
| Skeleton/spinner visual | ✅ | — |
| Loading threshold (quando mostrar) | — | ✅ |
| Confirmation dialog visual | ✅ | — |
| Confirmation dialog (quando mostrar, copy) | — | ✅ |

### 2.8 Accessibility (joint)

| Aspecto | UI | UX | Joint |
|---|---|---|---|
| Color contrast WCAG | ✅ calcula + valida | — | — |
| Focus ring visivel | ✅ pixel | — | — |
| Focus order | — | ✅ DOM order | — |
| Keyboard navigation full | — | ✅ | — |
| Screen reader semantics | — | ✅ | — |
| Aria labels | — | ✅ | — |
| Alt text | — | ✅ | — |
| Skip links | — | ✅ | — |
| Reduce motion (implementacao) | ✅ | — | — |
| Reduce motion (decisao do que reduzir) | — | ✅ | — |
| Heading hierarchy | — | ✅ | — |
| Color not only (icon + cor + texto) | — | — | ✅ — UI valida visual, UX valida semantic |
| Tooltips keyboard-reachable | — | — | ✅ — UI mostra, UX wire keyboard |

### 2.9 Charts / Data viz

| Aspecto | UI | UX |
|---|---|---|
| Chart visual (cores, lines, bars) | ✅ | — |
| Chart type (line/bar/pie/etc.) selection | — | ✅ — match data type |
| Responsive chart (reflow mobile) | ✅ | — |
| Legend visual | ✅ | — |
| Legend interactive (toggle series) | — | ✅ |
| Tooltip visual | ✅ | — |
| Tooltip content/timing | — | ✅ |
| Empty/error/loading chart state visual | ✅ | — |
| Empty/error chart copy | — | ✅ |

### 2.10 Showroom

| Aspecto | UI | UX |
|---|---|---|
| Renderizacao do showroom (cards, swatches) | ✅ | — |
| IA do showroom (8 secoes) | — | ✅ |
| Routing logico | — | ✅ |
| Toggle dark/light visual | ✅ | — |
| Persistencia LS | — | ✅ |
| Visual dos checklists/reports | ✅ | — |
| Estrutura dos checklists | — | ✅ |

---

## 3. Joint Commands — protocolo

Quando user pede algo que cai em **joint**, mds-orchestrator dispatcha em paralelo pra UI + UX. Cada um gera output independente. **Sem merge numerico de scores.**

### Exemplo 1 — "audita esse componente"

```json
{
  "user_input": "audita o componente Button",
  "routing": {
    "primary": null,
    "dispatch": ["mds-ui *audit-ui Button", "mds-ux *heuristic-audit Button"],
    "merge_strategy": "side-by-side",
    "block_strategy": "if UI:error OR UX:error -> bloqueia ops"
  }
}
```

### Exemplo 2 — "audita a11y desse Form"

```json
{
  "user_input": "audita a11y do form de login",
  "routing": {
    "primary": null,
    "dispatch": [
      "mds-ui *contrast-audit form-login",
      "mds-ux *screen-reader-audit form-login"
    ],
    "merge_strategy": "side-by-side"
  }
}
```

### Exemplo 3 — "esse empty state ta bom?"

```json
{
  "user_input": "esse empty state ta bom?",
  "routing": {
    "primary": null,
    "dispatch": [
      "mds-ui *audit-ui empty-state (visual: layout, fonts, contrast)",
      "mds-ux *heuristic-audit empty-state (semantic: mensagem, acao, recovery)"
    ],
    "merge_strategy": "side-by-side"
  }
}
```

---

## 4. Fronteiras nao previstas — protocolo

Se aparecer artefato/check NAO listado nesta matriz:

1. **Default:** `mds-orchestrator` roteia pra **clarify** com o user
2. **Heuristica fallback:** se o aspecto e **renderizavel/mensuravel visualmente** -> UI. Se e **fluxo/intencao/conteudo** -> UX.
3. **Atualizar matriz:** maintainer adiciona linha nesta tabela no proximo update do squad.

---

## 5. Anti-padroes a evitar

❌ **Joint merge numerico de score** — UI:A + UX:C nao vira "B medio". Mantem 2 scores. User ve os dois.
❌ **UI auditando flow** — se mds-ui detectar problema de fluxo, escala pra mds-ux, nao tenta resolver.
❌ **UX auditando pixel** — se mds-ux quiser validar contraste, dispatcha pra mds-ui.
❌ **Componente pode ter erro em ambos** — pode. Cada um bloqueia ops independente.

---

## 6. Decisao do conselho (registrada)

| Orchestrator | Voto |
|---|---|
| 🧭 mds-orchestrator | Aprovado |
| 🎯 squad-orchestrator | Aprovado (pre-condicao satisfeita) |
| Quality lenses na squad-policy | Pendente (Q1) |
| Showroom 8-section como default | Pendente (Q4) |

**Sem essa matriz, criacao de mds-ui + mds-ux estava BLOQUEADA.** Com ela, Q2 pode prosseguir.

---

## 7. Manutencao

Re-revisar matriz:
- Quando squad rodar em novo projeto (validacao cross-domain)
- Quando aparecer artefato novo nao mapeado
- Quando absorver fonte externa (ex: ui-ux-pro-max-skill) com checks de fronteira ambigua

Update protocol: criar PR com proposta + ambos orchestrators concedem antes de merge.
