# Arquitetura "3 Andares" — modelo mental do DS Shelflix

**Status:** ATIVO (canonical desde 2026-05-18)
**Substitui:** nada (é um doc novo que documenta uma decisão que existia só na cabeça do PO)
**Relaciona com:** `07-token-architecture-v3.md` (mecânica) — este doc é a metáfora; o 07 é o como.

---

## Por que existe este doc

A família Shelflix tem **4 produtos parentes, não gêmeos.** Cada produto tem personalidade própria, mas compartilha esqueleto. Um cliente (white-label) entra em só **um** dos produtos. Isso pede uma arquitetura que diga claramente:

- O que **NUNCA varia** (esqueleto)
- O que **varia por produto** (personalidade)
- O que **varia por cliente** (white-label)

A metáfora "3 andares de um prédio" responde isso. Cada andar tem uma regra de portas abertas/fechadas. Quem entender essa metáfora vai saber, ao ver qualquer token, **em que andar ele mora** — e isso determina onde declarar, quem pode sobrescrever, e se pode ser deletado.

---

## O modelo

```
┌───────────────────────────────────────────────────────────────┐
│ 2° ANDAR — A CARA DO CLIENTE (só num produto)                 │
│ ─────────────────────────────                                 │
│ Só 1 dos 4 produtos abre essa porta. Cliente entra e:         │
│ • Troca cor de marca (laranja vira azul-cliente)              │
│ • Resto do sistema BLINDADO (status, neutros, espaços)        │
│ → no tokens.json: sets client-<name> (white-label)            │
├───────────────────────────────────────────────────────────────┤
│ 1° ANDAR — PERSONALIDADE DO PRODUTO                           │
│ ────────────────────────────────                              │
│ Cada produto declara QUEM ele é:                              │
│ • Admin     → glass + denso + dark + laranja-shelflix         │
│ • Mission   → flat + médio + dark + laranja-shelflix          │
│ • Original  → estilo clássico (não detalhado ainda)           │
│ • 4° produto → permite cliente customizar (2° andar)          │
│ Mesma família, jeitos distintos. Coerente, não gêmeo.         │
│ → no tokens.json: sets product-<name>                         │
├───────────────────────────────────────────────────────────────┤
│ TÉRREO — ESQUELETO COMPARTILHADO (igual nos 4 produtos)       │
│ ────────────────────────────────                              │
│ Coisas que NÃO faz sentido variar:                            │
│ • Vermelho de erro = mesmo vermelho em qualquer produto       │
│ • Verde de sucesso, amarelo de aviso, escala de cinzas        │
│ • Tamanhos de espaço (4/8/12/16), fonte, cantos, sombras      │
│ • Motion, grid, ícones, breakpoints                           │
│ Se mudar aqui = muda nos 4 produtos juntos.                   │
│ → no tokens.json: sets primitive + semantic-dark              │
└───────────────────────────────────────────────────────────────┘
```

---

## Por que esse esquema mata fricção

**Térreo igual:** se um produto diz "erro = vermelho A" e outro "erro = vermelho B", o usuário trocando de produto sente que tá em outro lugar. Pequena mudança, grande atrito. Térreo padronizado mata isso.

**1° andar variável:** Admin pode ser glass+denso, Mission flat+médio, sem brigar. Cada um declara o jeito próprio.

**2° andar restrito:** white-label só onde permite. Cliente pinta a marca, não bagunça a estrutura.

---

## Mapeamento prático no código

| Andar | Onde mora no `src/styles/tokens.json` |
|---|---|
| Térreo | sets `primitive` + `semantic-dark` |
| 1° andar | sets `product-<name>` (ex: `product-admin`, `product-mission`) |
| 2° andar | sets `client-<name>` (futuro, quando 4° produto definir) |

CSS gerado a partir disso vai pra `src/styles/tokens-generated.css`.

---

## Como usar este modelo no squad

### Agentes que precisam saber

- **mds-foundations** — ao estruturar tokens novos, decide o andar (e portanto o set) onde o token mora.
- **mds-tokens** — valida que o token está no set certo conforme o andar.
- **mds-governance** — bloqueia migrações que violam o andar (ex: token de cliente tentando sobrescrever neutro do térreo).
- **mds-component** — ao especificar componente, declara quais tokens consome e de qual andar.
- **mds-ops** — gera CSS respeitando a hierarquia de sets.
- **mds-orchestrator** — usa a metáfora pra rotear pedidos (ex: "novo produto Mission" → ativa fluxo de 1° andar).

### Regras de propagação (cascata)

1. **Térreo é o piso.** Todo andar superior parte daqui. Se um produto não declara um valor, herda do térreo.
2. **1° andar pode sobrescrever térreo** apenas em tokens que fazem sentido variar por produto (ex: `--sf-radius-card`, `--sf-density-padding`). NÃO pode sobrescrever status, neutros, espaços base.
3. **2° andar pode sobrescrever 1° andar** apenas em cor de marca (`--sf-brand-*`). NÃO pode tocar em status, neutros, espaços, ou personalidade do produto (glass/flat/density).

### Decisão diária — em que andar mora este token?

Pergunta-chave: **"Se eu mudar esse valor, em quantos produtos/clientes muda?"**

| Resposta | Andar |
|---|---|
| Em todos os 4 produtos | Térreo |
| Em 1 produto específico | 1° andar |
| Em 1 cliente específico (dentro do produto white-label) | 2° andar |

Se a resposta for "em nenhum", o token é órfão e candidato a delete (ver estratégia delete-aggressive em `.omc/round3-ds-refinement/HANDOFF.md`).

---

## Estado atual (2026-05-18)

| Andar | Produto/Cliente | Status |
|---|---|---|
| Térreo | (compartilhado) | Ativo, alvo de simplificação no Round 3 Phase D |
| 1° andar | Admin (glass+denso+dark+laranja) | Ativo, é o foco do Round 3 como referência |
| 1° andar | Mission (flat+médio+dark+laranja) | Declarado, não totalmente implementado |
| 1° andar | Original | Não detalhado |
| 1° andar | 4° produto | Não detalhado (será o que permite 2° andar) |
| 2° andar | (clients) | Futuro — depende do 4° produto |

---

## Referências cruzadas

- `07-token-architecture-v3.md` — mecânica de 3 camadas técnicas (Primitive → Semantic com sets → Component). Este doc fala dos andares (conceito); o 07 fala das camadas (implementação). Não confundir.
- `governance/theme-contract.md` (ou equivalente) — contrato que enforça as regras de cascata acima.
- `themes/*.yaml` — declarações concretas de cada produto/cliente.
