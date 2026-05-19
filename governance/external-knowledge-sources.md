# External Knowledge Sources — Catalogo

**Status:** Adotado (Round 5)
**Pattern de traducao:** `governance/external-knowledge-translation-rules.md`
**Atualizado:** 2026-05-18

---

## 0. Proposito

Catalogo global das fontes externas absorvidas pelo squad magic-ds. Cada fonte tem:
- Data de absorcao
- Files absorvidos
- Manifest detalhado
- Licenca/atribuicao
- Politica de re-sync

---

## 1. Fontes absorvidas

### 1.1 ui-ux-pro-max-skill (nextlevelbuilder)

| Campo | Valor |
|---|---|
| **Imported** | 2026-05-18 (Round 5) |
| **Origin** | https://github.com/nextlevelbuilder/ui-ux-pro-max-skill |
| **Skill location** | `.agents/skills/ui-ux-pro-max/SKILL.md` |
| **Manifest** | `governance/external-knowledge-import-manifest.md` |
| **License** | A verificar no upstream (TODO) |
| **Re-sync due** | 2027-05-18 (anual) |

**Files absorvidos:**

| Arquivo | Categoria | Items | Owner |
|---|---|---|---|
| `checklists/ui-pre-delivery-checklist.md` | Pre-delivery cherry-pick | 3 rules | mds-ui (companion) |
| `checklists/ui-ux-pro-max-guidelines.md` | UX guidelines bulk | 99 items | mds-ux |
| `checklists/ui-pro-max-ui-checks.md` | UI checks bulk | ~110 checks | mds-ui |
| `checklists/ui-pro-max-ux-checks.md` | UX checks bulk | ~73 checks | mds-ux |
| `checklists/ui-pro-max-a11y-joint.md` | A11y joint | 20 checks | mds-ui + mds-ux |
| `checklists/ui-pro-max-pre-delivery.md` | Pre-delivery bulk | 27 items | mds-ops gate |

**Total:** ~330 items absorvidos da fonte.

**O que foi skipado:**
- Python CLI / `search.py` (engine da skill, nao usamos)
- 161 Color palettes (CSV nao bundlou + temos brand)
- 67 UI Styles (CSV nao bundlou + temos brand)
- 57 Font pairings (CSV nao bundlou + usamos Sora)
- 161 Product types reasoning rules (CSV nao bundlou)
- React Native specific guidelines (nao usamos RN)
- `--design-system` generator workflow (conflita com nossa arquitetura)

**Translation summary:**
- Hex colors -> `var(--sf-*)` semantic tokens
- React Native specifics -> generalizado para React web
- Material Design / Apple HIG -> mantido com atribuicao + adaptado
- `disabled` opacities -> mantido (0.38-0.5) com semantic mapping
- Touch target sizes (44pt) -> ja mapeado para `--sf-primitive-size-control-md`
- Motion durations -> ja mapeado para `--sf-primitive-duration-*`
- Severity `High`/`Medium`/`Low` -> `error`/`warning`/`info`

---

## 2. Politicas

### 2.1 Re-sync

| Tipo | Frequencia | Trigger |
|---|---|---|
| **Routine re-sync** | Anual | Data marcada na entry da fonte |
| **Targeted re-sync** | On-demand | Notamos atualizacao critica upstream |
| **Audit re-sync** | Mensal (manual) | Squad maintainer revisa fontes vivas |

### 2.2 Adicionar nova fonte

1. Criar `governance/<fonte>-import-manifest.md` (Fase 1 — manifest pra aprovacao)
2. User revisa + aprova
3. Aplicar `governance/external-knowledge-translation-rules.md`
4. Criar arquivos na pasta apropriada (`checklists/`, `templates/`, `foundations/`)
5. Atualizar este catalogo (`external-knowledge-sources.md`)
6. Atualizar agents relevantes (`dependencies.checklists`)

### 2.3 Remover fonte deprecated

Se uma fonte for descontinuada/conflitar com decisoes posteriores do squad:

1. Marcar entry como `**Status:** DEPRECATED em YYYY-MM-DD`
2. Listar arquivos a remover OU manter como historico
3. Atualizar agents que referenciam (remover de `dependencies`)
4. Documentar motivo no `external-knowledge-import-manifest.md` da fonte

---

## 3. Disclaimer e atribuicao

Toda regra absorvida cita origem inline. Conteudo derivativo de fontes externas mantem:

- Header de atribuicao em CADA arquivo
- Link pro repo/site oficial
- Data de importacao
- Aplicacao de translation rules documentada

O squad **nao reclama autoria** de regras absorvidas. Reclama autoria apenas da:
- Curadoria (escolha de quais regras absorver)
- Tradução (mapeamento pro nosso vocabulario)
- Integracao (organizacao em checklists do squad)
- Cross-references entre fontes

---

## 4. Templates para futuras absorcoes

Quando absorver nova fonte, copiar este template como entry inicial:

```markdown
### N.N <nome-da-fonte>

| Campo | Valor |
|---|---|
| **Imported** | YYYY-MM-DD |
| **Origin** | <URL> |
| **Skill/source location** | <path> |
| **Manifest** | `governance/<source>-import-manifest.md` |
| **License** | <license> |
| **Re-sync due** | YYYY-MM-DD |

**Files absorvidos:**
| Arquivo | Categoria | Items | Owner |
|---|---|---|---|
| ... | ... | ... | ... |

**O que foi skipado:** [lista]
**Translation summary:** [resumo]
```

---

## 5. Historico

| Data | Acao | Fonte |
|---|---|---|
| 2026-05-18 | Cherry-pick (3 rules) | ui-ux-pro-max |
| 2026-05-18 | Bulk import (99 UX guidelines) | ui-ux-pro-max |
| 2026-05-18 | Bulk import (4 arquivos consolidados + traducao + governance) | ui-ux-pro-max |
| 2026-05-18 | Criacao do catalogo (este arquivo) | — |
