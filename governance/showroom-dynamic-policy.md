# Showroom Dynamic Policy

**Status:** ATIVO desde 2026-05-19
**Owner:** mds-ops + mds-component (review gate)

## Regra

O showroom (DS Inspector) **deve sempre** derivar suas listas de dados (steps, roles, sizes, variants) de `src/styles/tokens.json` em runtime ou build-time. Step lists hardcoded são PROIBIDAS.

## Motivação

Showroom é espelho do estado real do DS. Hardcode petrifica o que deveria ser dinâmico — mudanças no DS (delete-aggressive, escala revista) não aparecem, gerando false negatives na validação visual.

Incidente que motivou: 2026-05-19, `spacingDemoHtml` e `radiusDemoHtml` em `src/showroom/showcase.js` tinham step lists legadas. Revisão de escala spacing+radius não apareceu no showroom até fix manual.

## Aplicação

### Pra todo agente que toca showroom:
- `mds-ops` (gera código): jamais hardcode step/role/size lists em `*.js` ou `*.mjs` de showcase. Sempre derivar de tokens.json.
- `mds-component` (valida specs): review gate — se um componente novo tiver showcase com step list hardcoded, bloqueia.
- `mds-ui` (auditoria visual): inclui check de "lista é derivada?" no design-check.

### Como derivar:
**Preferência 1:** fetch de `/src/styles/tokens.json` em runtime via `loadTokens()` (já implementado em `src/showroom/showcase.js`)
**Alternativa:** manifest gerado por `build-showcase.mjs` consumido por `showcase.js`

### Edge cases:
- Hints/descrições em PT-BR podem ficar hardcoded (UI, não dados)
- Sort numérico estável: `(a, b) => Number(a) - Number(b)`
- Especiais (ex: "full" em radius) vão pro fim
- Filtrar por `$type === "dimension"` pra excluir tokens não-dimensionais

## Enforcement

Grep automático no CI (futuro): bloqueia PR que adicione array literal com nomes de steps/roles em `src/showroom/**/*.js`.

Manual hoje: review gate via design-check.
