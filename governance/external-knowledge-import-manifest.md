# External Knowledge Import Manifest — ui-ux-pro-max

**Status:** ✅ EXECUTED (2026-05-18)
**Source:** `.agents/skills/ui-ux-pro-max/SKILL.md` (instalado em 2026-05-18)
**Attribution:** https://github.com/nextlevelbuilder/ui-ux-pro-max-skill
**Decisao do conselho:** 4 arquivos consolidados + index por categoria + traducao + skip Python + 2 pre-delivery separados com cross-ref

## Execucao concluida — arquivos gerados

| Arquivo | Items | Owner | Status |
|---|---|---|---|
| `governance/external-knowledge-translation-rules.md` | Pattern reusable | universal | ✅ criado |
| `checklists/ui-pro-max-ui-checks.md` | ~110 checks | mds-ui (futuro) | ✅ criado |
| `checklists/ui-pro-max-ux-checks.md` | ~73 checks | mds-ux (futuro) | ✅ criado |
| `checklists/ui-pro-max-a11y-joint.md` | 20 checks | joint UI+UX | ✅ criado |
| `checklists/ui-pro-max-pre-delivery.md` | 27 items | mds-ops gate | ✅ criado |
| `checklists/ui-pre-delivery-checklist.md` | 3 cherry-picks | mds-ui (companion) | ✅ patch cross-ref aplicado |

**Total absorvido:** ~230 checks + 1 pattern de traducao + 2 cross-references

---

## Manifesto original (preservado abaixo para historia)

---

## 0. O que a skill instalou

```
.agents/skills/ui-ux-pro-max/
├── SKILL.md       (659 linhas — TEM conteudo, vamos absorver)
├── data           (31 bytes — TEXT POINTER pra ../../../src/, NAO veio)
└── scripts        (34 bytes — TEXT POINTER pra ../../../src/, NAO veio)
```

**Conteudo real disponivel:** apenas SKILL.md. Os arquivos `data` (CSV com 161 paletas, 99 guidelines, etc.) e `scripts` (Python search engine) sao pointers vazios — o pacote nao bundlou.

**Implicacao:** absorvemos o que tem no SKILL.md. CSV deep data (161 paletas, 67 estilos, 57 pairings de fonte) ja absorvido parcialmente pelo arquivo `ui-ux-pro-max-guidelines.md` (99 UX guidelines via WebFetch anterior).

---

## 1. O que tem no SKILL.md (auditoria)

### A. 10 Priority Categories com checks granulares (linhas 48-300)

| # | Categoria | Impact | ~Checks | Owner (split UI/UX) |
|---|---|---|---|---|
| 1 | Accessibility | CRITICAL | 14 | **joint** (UI: contrast/focus visual; UX: keyboard/screen reader) |
| 2 | Touch & Interaction | CRITICAL | 17 | **joint** (UI: feedback visual; UX: gesture flow) |
| 3 | Performance | HIGH | 19 | **mds-ui** (fonts, images, layout shift) |
| 4 | Style Selection | HIGH | 13 | **mds-ui** (icon, elevation, primary action) |
| 5 | Layout & Responsive | HIGH | 16 | **mds-ui** (viewport, breakpoints, z-index) |
| 6 | Typography & Color | MEDIUM | 15 | **mds-ui** (tokens, contrast, dark mode) |
| 7 | Animation | MEDIUM | 24 | **mds-ui** (duration, easing, motion meaning) |
| 8 | Forms & Feedback | MEDIUM | 31 | **mds-ux** (labels, errors, autosave) |
| 9 | Navigation Patterns | HIGH | 25 | **mds-ux** (tab/bottom nav, back behavior) |
| 10 | Charts & Data | LOW | 29 | **mds-ui** (chart types, contrast, responsive) |

**Total:** ~203 checks granulares.

### B. Common Rules for Professional UI (linhas 559-617)

| Subsecao | Regras | Owner |
|---|---|---|
| Icons & Visual Elements | 10 (no emoji, vector-only, stroke consistency, etc.) | mds-ui |
| Interaction (App) | 7 (tap feedback, animation timing, etc.) | joint |
| Light/Dark Mode Contrast | 7 (surface, text, border, scrim) | mds-ui |
| Layout & Spacing | 8 (safe area, 8dp rhythm, etc.) | mds-ui |

**Total:** 32 regras consolidadas em tabela.

### C. Pre-Delivery Checklist (linhas 619-659)

| Categoria | Items | Owner |
|---|---|---|
| Visual Quality | 5 | mds-ui |
| Interaction | 6 | joint |
| Light/Dark Mode | 5 | mds-ui |
| Layout | 6 | mds-ui |
| Accessibility | 5 | joint |

**Total:** 27 items consolidados pra validacao pre-entrega.

### D. CLI / Workflow (linhas 302-557)

Conteudo sobre rodar `python3 scripts/search.py`, --design-system flag, --persist, exemplos. **NAO absorver** — esse e o "engine" da skill que a gente nao usa.

---

## 2. Plano de absorcao

### Estrategia: consolidar em 4 arquivos novos no squad

Em vez de criar 10 arquivos (1 por categoria), agrupar por **owner final** (mds-ui / mds-ux / joint) + 1 pre-delivery consolidado.

```
squads/magic-ds/checklists/
├── ui-pro-max-ui-checks.md           NOVO  ~110 checks pra mds-ui (categorias 3,4,5,6,7,10 + Common UI rules)
├── ui-pro-max-ux-checks.md           NOVO  ~73 checks pra mds-ux (categorias 8,9 + Common Interaction rules)
├── ui-pro-max-a11y-joint.md          NOVO  ~20 checks A11y conjunta UI+UX (categoria 1 + interaction a11y)
└── ui-pro-max-pre-delivery.md        NOVO  27 items consolidados pre-entrega (validacao final)
```

### Por que 4 e nao 10
- **mds-ui** recebe 1 arquivo unico de referencia (mais facil consultar)
- **mds-ux** mesmo
- **A11y** e crosscutting, merece arquivo proprio (joint)
- **Pre-delivery** e operacional (validacao final), separa por uso

### Regras de traducao aplicadas em CADA item

| Termo na skill | Tradução pro nosso squad |
|---|---|
| `--btn-bg: #FF6B00` | `--btn-bg: var(--sf-action-primary-bg)` |
| Tailwind utility (`bg-primary-500`) | BEM canonical OU `var(--sf-*)` arbitrary |
| `react-native` references | Generalizar pra React (nosso stack) ou pular |
| Material Design (`MD`) references | Manter atribuicao + adaptar pro nosso DS |
| Apple HIG references | Manter atribuicao + adaptar pro mobile spec |
| `--design-system` flag references | Pular (workflow da skill) |
| Hardcoded sizes (44pt, 8dp) | Manter, mas anotar como reflete nos nossos tokens (`--sf-primitive-size-control-md`, `--sf-primitive-space-2`) |

### Atribuicao em cada arquivo
Header de cada checklist absorvido:
```
**Source:** ui-ux-pro-max-skill (nextlevelbuilder)
**Original:** github.com/nextlevelbuilder/ui-ux-pro-max-skill
**Imported:** 2026-05-18
**Translation rules applied:** ver governance/external-knowledge-import-manifest.md
```

---

## 3. O que SKIP (e por que)

| Conteudo da skill | Skip motivo |
|---|---|
| Python CLI / `search.py` | Nao usamos — squad opera via agents, nao via skill direta |
| `--design-system` generator | Conflita com nossa arquitetura ja firmada |
| 161 Color palettes | Nao bundladas + temos nossa paleta |
| 67 UI Styles | Nao bundladas + temos brand |
| 57 Font pairings | Nao bundladas + usamos Sora |
| 161 Product types reasoning | Nao bundladas (so referencia no SKILL.md, sem deep data) |
| React Native specific rules | Nao usamos RN (so React web) |
| `--persist` master/overrides workflow | Nossa fonte ja e tokens.json |
| Stack search por `react-native` | Nao aplica |

---

## 4. O que ja foi importado (cherry-pick anterior)

Pre-existe em `squads/magic-ds/checklists/`:

- `ui-pre-delivery-checklist.md` — 3 rules iniciais (cursor-pointer, FOUT, keyboard focus)
- `ui-ux-pro-max-guidelines.md` — 99 UX guidelines via WebFetch

Esses **continuam validos**. Os 4 novos arquivos da Fase 3 SOMAM, nao substituem.

**Possivel cleanup:** depois da Fase 3, posso consolidar:
- Fundir `ui-pre-delivery-checklist.md` (3 rules) com novo `ui-pro-max-pre-delivery.md` (27 items)
- Resultado: 1 arquivo pre-delivery unico

---

## 5. Volume estimado

| Etapa | Output |
|---|---|
| 4 arquivos novos | ~400 KB total markdown |
| 2 patches (governance/external-knowledge-sources.md + os 2 ja existentes) | ~5 KB |
| Tempo estimado de Fase 3 | 1 session de trabalho (~30-60 min) |

---

## 6. Integracao com mds-ui + mds-ux quando criados

Quando os agentes nascerem (Q2 do plano anterior, post-matriz de ownership), eles ja apontam pros checklists absorvidos:

```yaml
# agents/mds-ui.md (futuro)
dependencies:
  checklists:
    - multi-theme-checklist.md
    - responsive-checklist.md
    - ui-pre-delivery-checklist.md          # cherry-picks iniciais
    - ui-pro-max-ui-checks.md               # absorvido nesta fase
    - ui-pro-max-pre-delivery.md            # validacao pre-entrega
    - ui-pro-max-a11y-joint.md              # cross-reference

# agents/mds-ux.md (futuro)
dependencies:
  checklists:
    - nielsen-heuristics-checklist.md
    - ux-laws-checklist.md
    - anti-patterns-checklist.md
    - microinteractions-checklist.md
    - ui-ux-pro-max-guidelines.md           # 99 UX (ja absorvido)
    - ui-pro-max-ux-checks.md               # absorvido nesta fase
    - ui-pro-max-a11y-joint.md              # cross-reference
```

---

## 7. Pra voce aprovar

Confirma os 4 pontos:

**1.** OK absorver SKILL.md em **4 arquivos consolidados** (UI / UX / A11y joint / Pre-delivery)? Ou prefere 10 arquivos (1 por categoria)?

**2.** OK aplicar regras de traducao (tokens hardcoded -> `var(--sf-*)`, RN-specific generalizado pra React)? Ou quer ver caso por caso?

**3.** OK skipar workflow da skill (Python CLI, design-system generator, --persist)? Ou ha algo desses que voce queira manter?

**4.** Depois da Fase 3 (extracao), consolidar `ui-pre-delivery-checklist.md` antigo dentro do novo `ui-pro-max-pre-delivery.md`? Ou manter os 2 separados?

Responde 1/2/3/4 que eu sigo pra Fase 3 (extracao).
