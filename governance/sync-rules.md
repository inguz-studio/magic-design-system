# Sync Rules — Propagação Produto → Agentes

**Status:** Regra ativa (2026-05-15)
**Aplica-se a:** Magic-DS squad e qualquer mudança em código gerado por ele

---

## Regra inquebrável

Toda mudança no **produto** (`src/styles/tokens.css`, `squads/magic-ds/output/css/*.css`, `src/components/**`, `squads/magic-ds/showcase/**`) que introduza **convenção nova** ou **padrão arquitetural** DEVE ser propagada de volta pros artefatos do squad na **mesma sessão**, antes de fechar o ciclo.

Tipos de mudança que disparam propagação:

| Tipo de mudança | Artefatos a atualizar |
|---|---|
| Nova camada / dimensão Foundation | `foundations/*.md` + `agents/mds-foundations.md` schema + `governance/matrix.md` |
| Novo type role / spacing role / motion role | `agents/mds-foundations.md` schema + `agents/mds-component.md` "consumo de tokens" |
| Novo A11y pattern (com convenções de implementação) | `agents/mds-component.md` bloco `a11y_native:` |
| Nova convenção de UI (long-press touch, collision detection, density-aware, etc.) | `agents/mds-component.md` + `agents/mds-ops.md` (greps) |
| Novo script de validação | `scripts/README.md` + `agents/mds-ops.md` (`*validate-output`) + `workflows/magic-ds-pipeline.yaml` |
| Refactor de naming de token (rename) | NOTAS DE MIGRAÇÃO em `tokens.css` + `agents/mds-librarian.md` (drift detection) |
| Mudança em Theme Contract / Governance Matrix | `governance/theme-contract.md` ou `governance/matrix.md` + propagação pros agentes que consomem |
| Mudança em filesystem structure (novas pastas/categorias) | `agents/mds-librarian.md` indexação + `governance/component-kinds.md` |

---

## Quem dispara

**Orquestrador (mds-orchestrator)** — quando routear pra Component/Ops/Foundations executar mudança no produto, deve incluir nota `propagate_back: true` no JSON payload se a mudança introduzir convenção.

**Executor (qualquer agente downstream)** — ao terminar mudança, deve listar artefatos que ainda precisam ser atualizados pra refletir convenção. Se essa lista não está vazia, retorna `requires_sync_pass: true` e nomeia os arquivos.

**Humano (você)** — ao revisar, deve cobrar "isso virou regra? Cadê a propagação?" sempre que vê mudança que poderia ser regra.

---

## Checklist de propagação (use ao final de qualquer round)

- [ ] `agents/mds-foundations.md` reflete novas camadas/dimensões? (schema JSON do output + core_principles)
- [ ] `agents/mds-component.md` tem A11y patterns + convenções novas em `a11y_native:` + regra de consumo de tokens type/space?
- [ ] `agents/mds-ops.md` tem grep novo no `*validate-output`? + density opt-in documentado? + typography.css aggregator?
- [ ] `agents/mds-governance.md` tem `rule_violated` novos?
- [ ] `agents/mds-audit.md` checklist 14 princípios cobre cenários novos (mode/density/dogfood)?
- [ ] `agents/mds-librarian.md` indexa categoria/pasta nova? Detecta drift de tokens v1?
- [ ] `workflows/magic-ds-pipeline.yaml` tem steps novos (design-check mecânico, etc.)?
- [ ] `governance/matrix.md` tem linhas pra dimensões/categorias novas?
- [ ] `governance/theme-contract.md` reflete tokens obrigatórios novos?
- [ ] `governance/component-kinds.md` reflete `kind:` novos (background, etc.)?
- [ ] `foundations/*.md` consolida arquitetura final?
- [ ] `templates/component.spec.template.yaml` reflete schema novo?
- [ ] `checklists/*.md` cobrem regras novas?
- [ ] Specs antigas (`component/generic/*.spec.yaml` + `component/domain/*.spec.yaml`) atualizadas pra consumir tokens novos? (sed batch ou caso a caso)

Se algum item da checklist está marcado ❌, a regra de propagação **não foi cumprida** — round NÃO está fechado.

---

## Razão (por que essa regra existe)

O squad foi desenhado pra ser **agente reutilizável**, não one-off. Se a próxima vez que rodarmos `mds-foundations *build-foundations` ele produzir output em formato Round 2 (sem shadow/z-index/grid/density), aprendemos zero entre rounds. Aprendizado vira retrabalho. A propagação fecha o loop.

---

## Anti-padrões a evitar

1. **"Atualizo o produto e a doc depois"** — depois nunca acontece. Sessão de produto fecha, contexto vira, próximo round começa de zero.
2. **"Só fiz uma exceção isolada, não vale virar regra"** — exceção repetida 3+ vezes JÁ É regra. Identifique e propague antes da 3ª.
3. **"O agente já sabe disso, é óbvio"** — agente NÃO sabe nada além do que está escrito no .md dele. Tudo precisa ser explícito.
4. **"Pra que documentar se temos código?"** — código mostra o QUE; agente precisa do POR QUÊ e do COMO PROPAGAR pra contextos futuros.
