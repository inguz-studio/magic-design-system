# Governance Matrix — O que varia, o que é fixo

**Status:** Atualizado (Round 4)
**Consumido por:** `mds-governance` (gate de PR) + design/eng (decisão diária)
**Data:** 2026-05-14

---

## 0. Como ler esta matriz

Cada item declara onde a decisão pode variar. Colunas:

- **Global**: igual pra todos os tenants/produtos/clientes. Mudar exige RFC.
- **Varia por tenant**: pode diferir entre `[data-tenant=X]` (ex: Shelflix vs Inguz).
- **Varia por produto**: pode diferir entre `[data-product=Y]` dentro do mesmo tenant.
- **Varia por white-label**: pode diferir entre `[data-client=Z]`.
- **Bloqueado**: não pode ser alterado sem mudar a arquitetura.

Status: `✅ Sim` / `⚠️ Limitado` / `❌ Não` / `🔒 Bloqueado`

---

## 1. Matriz principal

| Camada / Categoria | Global | Por tenant | Por produto | Por white-label | Notas |
|---|:---:|:---:|:---:|:---:|---|
| **Primitive — color scales** | ✅ | ❌ | ❌ | ❌ | Biblioteca bruta; mudar exige RFC + migração massiva |
| **Primitive — neutral scale** | ✅ | ❌ | ❌ | ❌ | Base de tons; nunca muda |
| **Primitive — typography scale** | ✅ | ⚠️ | ❌ | ❌ | Tamanhos/weights fixos; tenant pode ter font-family diferente |
| **Primitive — spacing scale** | ✅ | ❌ | ❌ | ❌ | 4-8-12-16-… progressão matemática |
| **Primitive — radius scale** | ✅ | ⚠️ | ❌ | ❌ | Tenant pode ter "personalidade angular vs arredondada" |
| **Primitive — shadow/elevation** | ✅ | ❌ | ❌ | ❌ | Estrutura visual; fixo |
| **Primitive — motion (duration/easing)** | ✅ | ❌ | ❌ | ❌ | Reduce-motion respeitado globalmente |
| **Primitive — breakpoints** | ✅ | ❌ | ❌ | ❌ | Mobile-first fixo |
| **Semantic — action-primary (pacote)** | ❌ | ⚠️ | ✅ | ✅ | `--sf-action-primary-bg/hover/pressed/subtle/text`. Declarado no set `product-<name>` em tokens.json. Antes era "Theme primary". |
| **Semantic — accent** | ❌ | ⚠️ | ✅ | ✅ | `--sf-accent`, `--sf-accent-subtle`. Antes era "Theme accent". |
| **Semantic — link / focus** | ❌ | ❌ | ✅ | ✅ | Derivado de action-primary na maioria dos produtos |
| **Semantic — selection** | ❌ | ❌ | ✅ | ✅ | |
| **Semantic — nav-active** | ❌ | ❌ | ✅ | ✅ | `--sf-nav-active-bg`, `--sf-nav-active-text` |
| **Semantic — chart-emphasis** | ❌ | ⚠️ | ✅ | ⚠️ | Destaque do produto em gráficos |
| **Semantic — illustration-accent** | ❌ | ❌ | ✅ | ✅ | Ilustrações expressivas |
| **Semantic — font-family** | ❌ | ✅ | ❌ | ❌ | Tenant define (ex: Shelflix = Sora, Inguz = outra). Antes era "Brand Core font-family". |
| **Semantic — logo/favicon** | ❌ | ✅ | ⚠️ | ✅ | Produto pode ter variante; cliente white-label fornece o próprio |
| **Semantic — bg-canvas / surface / subtle** | ✅ | ⚠️ | ❌ | ❌ | Estrutura; tenant pode ajustar (raro) |
| **Semantic — text-primary / secondary / disabled** | ✅ | ❌ | ❌ | ❌ | Legibilidade; nunca varia |
| **Semantic — text-on-brand / on-primary** | ❌ | ✅ | ⚠️ | ⚠️ | Depende do primary; cliente fornece junto com primary |
| **Semantic — border-default / subtle / strong** | ✅ | ❌ | ❌ | ❌ | Estrutura visual |
| **Semantic — action-danger** | 🔒 | ❌ | ❌ | ❌ | Linguagem operacional fixa (vermelho/destrutivo) |
| **Semantic — action-secondary** | ✅ | ❌ | ❌ | ❌ | Neutral; estável |
| **Semantic — status-success / warning / danger / info** | 🔒 | ❌ | ❌ | ❌ | **Vocabulário operacional global** — verde/amarelo/vermelho/azul. Linguagem universal de UX. Cliente NÃO pode alterar. |
| **Semantic — domain-status (Shelflix: online/offline/alert/+13)** | ❌ | ✅ | ⚠️ | ❌ | **Vocabulário de domínio por tenant** — Shelflix tem 16 keys (online/offline/pre-offline/manutencao/pareado/nao-pareado/alta-osc/med-osc/erro-exec/stand/sem-energia/sem-internet/expirado/bloqueado/aguardando-ativacao/indisponivel/+alert). Produto pode mapear subset; cliente NÃO pode redefinir (operacional). Ver Tag.spec.yaml §variants.status. |
| **Semantic — score-poor / fair / good / excellent** | 🔒 | ❌ | ❌ | ❌ | Régua analítica fixa |
| **Semantic — chart series** | ⚠️ | ✅ | ⚠️ | ⚠️ | Paleta base global; produto pode ter ênfase própria |
| **Mode (light/dark/high-contrast)** | ✅ | ⚠️ | ⚠️ | ❌ | Mode = override de Semantic; produto pode habilitar/desabilitar mode, cliente não pode definir mode novo |
| **Component — estrutura BEM (.block, .block__elem)** | 🔒 | ❌ | ❌ | ❌ | Nomes de classe são contrato público — não mudam |
| **Component — comportamento (focus, keyboard nav)** | 🔒 | ❌ | ❌ | ❌ | A11y nativa, padrão fixo |
| **Component — generic disponibilidade** | ✅ | ❌ | ❌ | ❌ | Button, Card, etc. existem em todo tenant/produto |
| **Component — domain disponibilidade** | ❌ | ✅ | ✅ | ⚠️ | Tenant declara `adopts_domain`; cliente herda do produto |
| **Acessibilidade — contraste WCAG AA** | 🔒 | ❌ | ❌ | ❌ | Não-negociável; gate em todos os tokens |
| **Acessibilidade — reduce-motion** | 🔒 | ❌ | ❌ | ❌ | Sempre respeitado |
| **Density (compact/comfortable)** | ⚠️ | ❌ | ✅ | ❌ | Produto Admin pode ser denso, Customer comfortable. Touch coarse força control-md ≥ 40px (guard A11y) |
| **Shadow / Elevation** | ✅ | ❌ | ❌ | ❌ | Light/dark com sets distintos (luminância invertida). Override só via mode |
| **Z-index** | 🔒 | ❌ | ❌ | ❌ | Estrutural; categorias canvas/sticky/dropdown/popover/tooltip/drawer/modal/toast/banner fixas |
| **Grid / Container** | ✅ | ❌ | ❌ | ❌ | Container max-widths + 12 cols + 3 gutters globais |
| **Iconography — sizes** | ✅ | ❌ | ❌ | ❌ | 6 sizes (xs..2xl) fixos |
| **Iconography — stroke width** | ⚠️ | ✅ | ❌ | ❌ | Tenant pode redefinir (`--semantic-icon-stroke`); ex.: Inguz pode ser mais bold |
| **Motion durations + easings** | 🔒 | ❌ | ❌ | ❌ | Reduce-motion respeitado globalmente; zera todos os semantic-motion-* |

---

## 2. Padrões consolidados

### 2.1 "Cliente pode trocar primary, não pode trocar danger"

Cliente white-label tem direito de variar identidade visual (primary, accent, navigation). **Não** pode alterar linguagem operacional (status colors, danger action) porque isso quebra reconhecimento universal e arrisca acessibilidade.

### 2.2 "Produto pode habilitar light mode, cliente não pode definir mode novo"

Produto declara em `theme.yaml` quais modes suporta (`dark`, `light`, `high-contrast`). Cliente herda os modes do produto. Cliente não pode criar `[data-theme="my-mode"]` próprio — modes são vocabulário fechado.

### 2.3 "Tenant pode mudar font-family, produto não pode"

Font-family carrega marca-mãe. Shelflix usa Sora, Inguz pode usar outra. Mas Shelflix-Admin e Shelflix-Customer usam a mesma família (Shelflix), porque são produtos da mesma marca.

### 2.4 "Domain componentes são opt-in, generic são auto"

Generic components (Button, Card, Tag) estão disponíveis em todo tenant/produto sem declaração. Domain components (DonutKpi, ShelfMonitor) exigem `adopts_domain: [...]` no theme.yaml do produto.

---

## 3. Casos especiais

### 3.1 Mode em white-label

Cliente herda modes do produto. Exemplo: produto Admin suporta `light` + `dark`. Cliente AcmeCorp herda ambos automaticamente. Cliente não pode adicionar `high-contrast` se o produto não suporta.

### 3.2 Domain components em white-label

Cliente herda domain components adotados pelo produto. Exemplo: produto Shelflix-Admin adota `DonutKpi`; AcmeCorp (white-label de Admin) automaticamente tem acesso ao DonutKpi com cores do Theme do AcmeCorp aplicadas.

### 3.3 Status colors em high-contrast

`[data-theme="high-contrast"]` é a **única** situação onde status colors podem ser sobrescritas — pra melhorar contraste de quem precisa. Mas só na camada Semantic, mantendo o significado (verde ainda = success, vermelho ainda = danger).

---

## 4. Resolução de conflito

Quando dois eixos discordam, ordem de precedência (mais específico vence):

```
Primitive (:root)
  < Tenant ([data-tenant])
    < Mode ([data-tenant][data-theme])
      < Product ([data-product])
        < Client ([data-client])
```

Exemplo prático: cliente AcmeCorp aplicando white-label no produto Shelflix-Admin em modo light.

1. Browser carrega `tokens-generated.css` → `:root` declara Primitives.
2. `[data-tenant="shelflix"]` declara set `semantic-dark` (base).
3. `[data-tenant="shelflix"][data-theme="light"]` ativa set `semantic-light`.
4. `[data-product="shelflix-admin"]` ativa set `product-shelflix-admin` com action-primary e accent do produto.
5. `[data-client="acmecorp"]` ativa set `client-acmecorp` sobrescrevendo `--sf-action-primary-bg` com a cor do cliente.

Resultado: estrutura/legibilidade do Shelflix, cor primária do AcmeCorp, mode light. Conflito impossível porque cada camada ataca um aspecto diferente.

---

## 5. Quando uma decisão NÃO está coberta

Se aparece demanda que a matriz não responde, a regra é:

1. **Default conservador:** bloquear até decisão explícita (consultar matrix antes de adicionar tokens).
2. **RFC curto:** descrever o caso, qual camada, por que precisa variar, impacto em outros eixos.
3. **Atualizar a matriz** no mesmo PR.

Matrix evolui — não é congelada. Mas evolui por decisão registrada, não por improviso.
