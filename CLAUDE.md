# Magic-DS — Instruções de Operação para Claude

Este arquivo define como Claude opera dentro do squad `magic-ds`. É diferente do `CLAUDE.md` da raiz do projeto (que instrui como contribuir com o Shelflix Admin em geral). Este aqui é sobre como executar trabalho de Design System com este squad.

---

## Quando você é invocado neste squad

Você é invocado quando:
- O usuário usa `/mds:mds-*` (qualquer agente do squad)
- O usuário pede explicitamente trabalho de DS: tokens, componentes, CSS, showroom, audit visual ou UX
- O contexto indica que o work é sobre o Design System da família Shelflix

Primeiro passo sempre: leia `config/squad-policy.yaml` para saber o vendor policy, CSS strategy e prefix ativos.

---

## Roteamento via mds-orchestrator

O orchestrator é o ponto de entrada obrigatório para qualquer demanda. Ele retorna um JSON de roteamento — nunca responde ao usuário diretamente.

Formato de saída do orchestrator:

```json
{
  "agent": "librarian | ui | ux | foundations | tokens | governance | component | ops | clarify",
  "target": "canonical | adapter | all | null",
  "scope": "tenant | product | client | mode | component-generic | component-domain | global",
  "input_type": "text | url | image_path | figma_node | mixed",
  "payload": "<input original do usuário, preservado>",
  "reasoning": "justificativa breve do roteamento",
  "requires_human_approval": false
}
```

Para audit paralelo (joint dispatch):

```json
{
  "agent": "joint",
  "dispatch": [
    { "agent": "ui", "command": "*audit-ui", "args": "..." },
    { "agent": "ux", "command": "*heuristic-audit", "args": "..." }
  ],
  "merge_strategy": "side-by-side",
  "block_strategy": "any_C_blocks"
}
```

Regras do campo `target`: aplica-se SÓ quando `agent == "ops"`. Para os demais, `target: null`.

---

## Pipeline canônico

```
mds-orchestrator (JSON routing)
    |
    ├── librarian       → consulta/índice, fim
    ├── ui              → audit visual (score A/B/C/D) → se A/B → foundations
    ├── ux              → audit heurístico (score A/B/C/D) → se A/B → foundations
    ├── joint           → ui + ux paralelo, scores independentes
    ├── foundations     → delta tokens.json → tokens → governance → ops
    ├── tokens          → validate-json + build-css → governance
    ├── governance      → enforce-governance → ops (ou component se specs novas)
    ├── component       → map-components → design-check (ux) → ops
    ├── ops             → canonical output → [adapter output se solicitado]
    └── clarify         → devolve para o usuário
```

Gates humanos obrigatórios (o pipeline pausa aqui):
- Após `mds-ux *design-check` — antes de `mds-ops`
- Após `mds-foundations` — antes de `mds-tokens` consumir o delta

Ops score C ou D em UI ou UX: bloqueia. O pipeline não avança para Ops se qualquer score for C/D.

---

## Convenções que você deve respeitar

### Onde vivem os tokens reais

- `src/styles/tokens.json` — fonte de verdade, formato W3C Design Tokens (no projeto, não no squad)
- `src/styles/tokens-generated.css` — artefato gerado por `mds-tokens *build-css`; nunca editado direto
- `squads/magic-ds/output/css/<block>.css` — tokens de componente (component layer)
- **Nunca coloque tokens reais dentro de `squads/magic-ds/`** — o squad é infraestrutura, não produz tokens direto

### Prefix

- O prefix vive em `config/squad-policy.yaml` (campo `token_prefix`)
- Shelflix Admin usa `sf` → `--sf-bg-canvas`, `--sf-action-primary-bg`
- Se `token_prefix` não estiver declarado: rotear para `*onboarding-policy` antes de qualquer ação
- Para referenciar o prefix em código: ler o YAML, não assumir `sf` como padrão universal

### Squad é infraestrutura

- Não edite arquivos de `squads/magic-ds/agents/`, `foundations/`, `governance/` para trabalho de projeto
- Essas pastas definem como o squad opera — não são artefatos do projeto
- Artefatos do projeto vivem em: `src/styles/`, `src/components/`, `squads/magic-ds/output/`, `squads/magic-ds/showcase/`

### Linguagem

- Português nas respostas e documentação
- Sem jargão: "fonte da verdade" em vez de "source of truth canonical"; "regra inquebrável" em vez de "invariante"; "camada" em vez de "layer abstraction"
- Nomes de variáveis, IDs e campos YAML: inglês (camelCase ou kebab-case conforme o contexto)

### Output canônico primeiro

- CSS+HTML puro é sempre o primeiro output de `mds-ops`
- React+Tailwind é gerado depois, apenas se `target == "adapter"` ou `target == "all"`
- Canonical = `squads/magic-ds/output/html/<block>.html` + `squads/magic-ds/output/css/<block>.css`
- Adapter = `src/components/<Level>/<Name>/`

### Showroom dinâmico

- Qualquer código de showcase (`src/showroom/`, `squads/magic-ds/showcase/`) deve derivar listas de `tokens.json`
- Proibido: array literal com nomes de steps, roles ou sizes hardcoded em JS/MJS de showcase
- Método correto: `loadTokens()` ou manifest gerado por `build-showcase.mjs`
- Ver `governance/showroom-dynamic-policy.md` para detalhes e edge cases

### A11y policy-driven

- Ler `config/squad-policy.yaml.vendor` antes de qualquer decisão de componente
- `allow_radix: true` (Shelflix Admin) + `vendor_whitelist` define quais componentes PODEM usar Radix/shadcn
- Componentes fora da whitelist: a11y nativa obrigatória (focus trap, escape, aria-modal, roving tabindex)
- Shadcn vive em `/src/vendor/` — nunca importado direto em `/src/components/`

---

## Governance obrigatória

Policies que os agentes devem ler/aplicar:

| Policy | Quando se aplica |
|---|---|
| `governance/prefix-policy.md` | Sempre — todo token gerado |
| `governance/showroom-dynamic-policy.md` | Qualquer toque em showcase/showroom |
| `governance/theme-contract.md` | Sempre que `mds-foundations` declara `semantic-dark` |
| `governance/matrix.md` | `mds-governance` ao validar camadas |
| `governance/component-kinds.md` | `mds-component` ao classificar `kind:` |
| `governance/ui-ux-ownership.md` | `mds-orchestrator` ao decidir UI vs UX routing |
| `governance/skills-routing.md` | `mds-orchestrator` ao interpretar verb do usuário |
| `config/squad-policy.yaml` | Boot de todos os agentes |

---

## Anti-patterns — o que NÃO fazer

- **Hardcode no showroom:** nunca escrever `["1","2","4","8","12","16"]` em showcase JS. Derivar de tokens.json.
- **Importar Radix direto em componentes:** Radix vai para `/src/vendor/`; wrappers em `/src/components/` importam de `@/vendor/`.
- **Editar tokens-generated.css:** arquivo gerado — rodar `mds-tokens *build-css` regenera.
- **Tokens em tokens.json com prefix errado:** `--sf-*` para Shelflix, não `--color-*` ou `--ds-*` genérico.
- **Componente referenciando Primitive direto:** componente → Semantic → Primitive. Nunca pula a Semantic.
- **Criar token sem consultar Librarian:** `mds-librarian *lookup` antes de declarar token novo evita duplicata.
- **Gerar adapter sem canonical:** canonical é obrigatório; adapter é opcional. Ops nunca gera só adapter.
- **Avançar pra Ops com score C/D:** UI:C, UX:C, ou blocking design-check → bloqueia, não avança.
- **Editar arquivos de agents/ ou governance/ para demanda de projeto:** squad é infraestrutura.
- **Assumir prefix sem ler squad-policy.yaml:** prefix é por projeto, não global.

---

## Documentos canônicos para consultar

Antes de trabalhar em qualquer área, leia o documento relevante:

| Área | Documento |
|---|---|
| Arquitetura de tokens | `foundations/07-token-architecture-v3.md` |
| Modelo 3 andares (Shelflix) | `foundations/08-arquitetura-3-andares.md` |
| 8 dimensões do design | `foundations/03-foundation-dimensions.md` |
| Pipeline completo com branches | `workflows/magic-ds-pipeline.yaml` |
| Política do projeto (vendor, CSS) | `config/squad-policy.yaml` |
| Prefix e enforcement | `governance/prefix-policy.md` |
| Theme Contract (28 mínimos) | `governance/theme-contract.md` |
| UI vs UX routing | `governance/ui-ux-ownership.md` |
| Routing por verb | `governance/skills-routing.md` |
| Showroom dinâmico | `governance/showroom-dynamic-policy.md` |
