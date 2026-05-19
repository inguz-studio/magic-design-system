# Token Architecture v2 — 5 Camadas (Round 2 + atualizações Round 3)

> ⚠️ **SUPERSEDED por `07-token-architecture-v3.md` em 2026-05-19.**
> Este doc fica como referência histórica. Para arquitetura atual, ver `07-v3` (mecânica) + `08-arquitetura-3-andares.md` (conceito).

> 📎 **Leitura complementar obrigatória:** [`03-foundation-dimensions.md`](./03-foundation-dimensions.md) — cobre as 8 dimensões Foundation completas (Spacing, Radius, Shadow, Motion, Z-index, Grid, Density, Iconography) consolidadas em Round 3. Também consultar [`05-foundations-round-1-5.md`](./05-foundations-round-1-5.md) e [`06-foundations-round-1-6.md`](./06-foundations-round-1-6.md) pra histórico.


**Status:** Proposta de adoção (Round 2)
**Substitui:** `02-token-architecture.md` (v1, manter como histórico)
**Data:** 2026-05-14
**Aprovação pendente:** humana (gate antes de Ops aplicar)

---

## 0. Contexto

Esta versão consolida o briefing "Design System Unificado Multi-Produto" + a HARD RULE `zero-Radix` + a separação `generic` vs `domain` em componentes. **Mudanças vs v1:**

1. Hub renomeado pra **Brand Core** (`--hub-*` → `--brand-*`).
2. Theme Layer **adicionada** entre Brand Core e Semantic (não existia em v1).
3. Score como camada semântica formal, separada de Status.
4. Component tokens saem de `tokens.css` e vivem junto do BEM em `output/css/<block>.css`.
5. Naming de Primitives migra de funcional (`--primitive-brand-700`) pra físico (`--primitive-orange-700`).
6. White-label formal via `[data-client=...]` com fallback pra Theme.

---

## 1. As 5 camadas

| # | Camada | Prefixo | Escopo CSS | Responsabilidade |
|---|---|---|---|---|
| 1 | **Primitive** | `--primitive-*` | `:root` | Cores físicas + escalas matemáticas. Nunca função. |
| 2 | **Brand Core** | `--brand-*` | `[data-tenant=<tenant>]` | Identidade da marca-mãe. Quem é a marca. |
| 3 | **Theme** | `--theme-*` | `[data-product=<product>]` ou `[data-client=<client>]` | Variação ativa por produto/cliente. Ponto de override. |
| 4 | **Semantic** | `--semantic-*` | `[data-tenant=<tenant>]` + `[data-theme=<mode>]` | Função/papel na UI (bg, text, action, status, score). |
| 5 | **Component** | `--component-*` ou `--<block>-*` | dentro de `output/css/<block>.css` | Aplicação específica no componente. |

### 1.1 Primitive — "Qual é a cor física?"

Nome reflete **valor físico**, nunca papel. Escala matemática.

```css
:root {
  /* Neutral scale */
  --primitive-neutral-0:   #FFFFFF;
  --primitive-neutral-50:  #FAFAFA;
  /* ... */
  --primitive-neutral-950: #000000;

  /* Color scales — uma por matiz */
  --primitive-orange-50:   #FFF4EA;
  --primitive-orange-700:  #E57300;  /* laranja Shelflix */
  --primitive-orange-950:  #8C2600;

  --primitive-red-500:     #CC4747;  /* ex-error */
  --primitive-green-500:   #28A745;  /* ex-success */
  --primitive-yellow-500:  #FFCC66;  /* ex-warning */
  --primitive-blue-500:    #33AEFF;  /* ex-info */
  --primitive-purple-500:  #8A38F5;  /* ex-info-alt */

  /* Type, space, radius, motion, breakpoint — todas escalas físicas */
  --primitive-space-1: 0.25rem;
  --primitive-radius-md: 0.625rem;
  /* ... */
}
```

**Regra:** Component **NUNCA** consome Primitive direto. Brand/Theme/Semantic **podem**.

### 1.2 Brand Core — "Qual é a identidade da marca-mãe?"

Marca-mãe do tenant. Muda raramente. Não conhece produto.

```css
[data-tenant="shelflix"] {
  --brand-primary:        var(--primitive-orange-700);  /* #E57300 */
  --brand-primary-hover:  var(--primitive-orange-600);
  --brand-primary-pressed:var(--primitive-orange-800);
  --brand-primary-subtle: var(--primitive-orange-100);
  --brand-on-primary:     var(--primitive-neutral-0);

  --brand-secondary:      var(--primitive-neutral-300);
  --brand-accent:         var(--primitive-purple-500);
  --brand-accent-subtle:  rgba(138, 56, 245, 0.16);
}
```

**Regra:** Brand Core NÃO contém `danger/success/warning/info` (esses são Semantic Status, não identidade de marca). Brand carrega `primary`, `secondary`, `accent` e variantes de estado **dessas três** (hover, pressed, subtle).

### 1.3 Theme — "Qual é a variação ativa?"

Ponto de override por produto ou cliente. Default herda Brand Core; produto/cliente pode redeclarar.

```css
/* Default (sem override): Theme = Brand Core */
[data-tenant="shelflix"] {
  --theme-primary:        var(--brand-primary);
  --theme-primary-hover:  var(--brand-primary-hover);
  --theme-primary-pressed:var(--brand-primary-pressed);
  --theme-primary-subtle: var(--brand-primary-subtle);
  --theme-on-primary:     var(--brand-on-primary);
  --theme-accent:         var(--brand-accent);
  /* ... ver Theme Contract pra lista mínima obrigatória */
}

/* Produto X override (ex: Shelflix-Analytics usa azul) */
[data-product="shelflix-analytics"] {
  --theme-primary:        var(--primitive-blue-700);
  --theme-primary-hover:  var(--primitive-blue-600);
  --theme-primary-pressed:var(--primitive-blue-800);
  --theme-primary-subtle: var(--primitive-blue-100);
}

/* Cliente white-label override (ex: AcmeCorp usa verde) */
[data-client="acmecorp"] {
  --theme-primary:        var(--client-primary, var(--brand-primary));
  /* via Theme Contract: client declara --client-* tokens primeiro */
}
```

**Regra:** Semantic consome `--theme-*` (não `--brand-*` direto). Isso garante que produtos overridem `theme-*` sem mexer em Brand Core.

### 1.4 Semantic — "Qual é a função na UI?"

Traduz cor em papel. Não conhece componente nem produto.

```css
[data-tenant="shelflix"] {
  /* Background */
  --semantic-bg-canvas:           var(--primitive-neutral-800);  /* dark default */
  --semantic-bg-surface:          var(--primitive-neutral-700);
  --semantic-bg-subtle:           var(--primitive-neutral-600);

  /* Text */
  --semantic-text-primary:        var(--primitive-neutral-100);
  --semantic-text-secondary:      var(--primitive-neutral-300);
  --semantic-text-on-brand:       var(--primitive-neutral-0);

  /* Action — consome Theme */
  --semantic-action-primary-bg:        var(--theme-primary);
  --semantic-action-primary-bg-hover:  var(--theme-primary-hover);
  --semantic-action-primary-bg-pressed:var(--theme-primary-pressed);
  --semantic-action-primary-text:      var(--theme-on-primary);

  --semantic-action-danger-bg:         var(--primitive-red-500);
  --semantic-action-danger-bg-hover:   var(--primitive-red-600);
  --semantic-action-danger-text:       var(--primitive-neutral-0);

  /* Status — operacional */
  --semantic-status-success-bg:   rgba(40,167,69,0.16);
  --semantic-status-success-text: var(--primitive-green-300);
  --semantic-status-danger-bg:    rgba(204,71,71,0.16);
  --semantic-status-danger-text:  var(--primitive-red-300);
  --semantic-status-warning-bg:   rgba(255,204,102,0.16);
  --semantic-status-warning-text: var(--primitive-yellow-300);
  --semantic-status-info-bg:      rgba(51,174,255,0.16);
  --semantic-status-info-text:    var(--primitive-blue-300);

  /* Score — classificação analítica (NÃO confundir com Status) */
  --semantic-score-poor-bg:       /* tons baixos de vermelho */;
  --semantic-score-fair-bg:       /* tons baixos de amarelo */;
  --semantic-score-good-bg:       /* tons baixos de verde */;
  --semantic-score-excellent-bg:  /* tons baixos de verde-azulado */;
}

/* Mode override: light sobrescreve SÓ Semantic */
[data-tenant="shelflix"][data-theme="light"] {
  --semantic-bg-canvas:  var(--primitive-neutral-100);
  --semantic-bg-surface: var(--primitive-neutral-0);
  --semantic-text-primary: var(--primitive-neutral-800);
  /* ... — NÃO redeclara --theme-* nem --brand-* */
}
```

**Regra:** Mode (`[data-theme=light|dark|high-contrast]`) **só** sobrescreve Semantic. Nunca Theme, Brand ou Primitive.

### 1.5 Component — "Como o componente aplica a função?"

Tokens específicos de componente, escopados ao bloco BEM. Moram no próprio arquivo CSS do componente — não em `tokens.css`.

```css
/* output/css/btn.css */
.btn {
  --btn-bg:           var(--semantic-action-primary-bg);
  --btn-bg-hover:     var(--semantic-action-primary-bg-hover);
  --btn-text:         var(--semantic-action-primary-text);
  --btn-radius:       var(--primitive-radius-md);
  --btn-padding-y:    var(--primitive-space-2);
  --btn-padding-x:    var(--primitive-space-4);

  background: var(--btn-bg);
  color: var(--btn-text);
  border-radius: var(--btn-radius);
  padding: var(--btn-padding-y) var(--btn-padding-x);
}

.btn:hover { background: var(--btn-bg-hover); }

.btn--danger {
  --btn-bg:       var(--semantic-action-danger-bg);
  --btn-bg-hover: var(--semantic-action-danger-bg-hover);
  --btn-text:     var(--semantic-action-danger-text);
}
```

**Regra:** Component tokens **podem** consumir Semantic e Primitive (pra spacing/radius/size). **Nunca** consomem Theme ou Brand direto — sempre via Semantic.

---

## 2. Cascade canônica (end-to-end)

Exemplo: `Button primary` background.

```
Primitive:    --primitive-orange-700  = #E57300                              (cor física)
Brand Core:   --brand-primary         = var(--primitive-orange-700)          (identidade)
Theme:        --theme-primary         = var(--brand-primary)                 (variação ativa)
Semantic:     --semantic-action-primary-bg = var(--theme-primary)            (função: ação principal)
Component:    --btn-bg                = var(--semantic-action-primary-bg)    (aplicação no botão)
Uso:          .btn { background: var(--btn-bg); }
```

Cada salto justifica a existência da camada: troca de cor física, troca de marca, troca de produto, troca de papel, troca de componente — cada um é um ponto de override sem afetar o resto.

---

## 3. Naming convention

```
--[layer]-[category]-[role]-[state]
```

Exemplos:

```
--primitive-orange-700                  layer=primitive, category=orange, role=700
--brand-primary-hover                   layer=brand, category=primary, state=hover
--theme-primary-subtle                  layer=theme, category=primary, state=subtle
--semantic-action-primary-bg            layer=semantic, category=action, role=primary, suffix=bg
--semantic-status-danger-text           layer=semantic, category=status, role=danger, suffix=text
--btn-bg                                component=btn (omite prefix --component-), role=bg
--btn-bg-hover                          component=btn, role=bg, state=hover
```

**Regras:**
- kebab-case sempre. Sem PascalCase, sem camelCase.
- Componente pode omitir `--component-` (usa só `--<block>-*`) — fica mais curto e mora junto do CSS do bloco.
- Sufixos de papel sempre presentes em Semantic: `bg`, `text`, `border`, `icon`.
- Estados: `default` (omitido), `hover`, `pressed`, `focus`, `disabled`, `loading`.

---

## 4. Cross-layer rules (invariantes)

| Camada consumidora | Pode consumir | NÃO pode consumir |
|---|---|---|
| Brand Core | Primitive | Theme, Semantic, Component |
| Theme | Brand Core, Primitive (raro) | Semantic, Component |
| Semantic | Theme, Brand Core (excepcional), Primitive (radius/spacing/motion) | Component |
| Component | Semantic, Primitive (size/radius/spacing/motion) | Theme, Brand direto |
| Mode override (`[data-theme=...]`) | Theme, Brand, Primitive | Sobrescreve apenas Semantic |
| Client override (`[data-client=...]`) | Primitive, `--client-*` próprios | Sobrescreve apenas Theme (via Theme Contract) |

**Regra de ouro:** se você está prestes a fazer `var(--primitive-X)` num Component, **pare**. Suba até Semantic. Se não há Semantic adequado, **crie um** (que então Component consome).

---

## 5. Escopos CSS (3 eixos ortogonais)

```
:root                                          → Primitives
[data-tenant=<tenant>]                         → Brand Core + Semantic + Theme default
[data-tenant=<X>][data-theme=<mode>]           → Mode override (light/dark/hc)
[data-product=<product>]                       → Theme override por produto
[data-client=<client>]                         → Theme override por cliente (white-label)
```

Composição em HTML:

```html
<html data-tenant="shelflix" data-theme="dark">
  <body data-product="shelflix-admin">
    <!-- Theme = brand (default), Mode = dark, Product = admin -->
  </body>
</html>

<html data-tenant="shelflix" data-theme="light">
  <body data-product="shelflix-admin" data-client="acmecorp">
    <!-- Theme = client override, Mode = light, Product = admin -->
  </body>
</html>
```

---

## 6. Decision tree — "Em qual camada esse token vai?"

1. **É uma cor física crua sem papel?** → Primitive.
2. **É a identidade visual da marca-mãe (primary/secondary/accent)?** → Brand Core.
3. **É um token que precisa variar entre produtos ou clientes?** → Theme.
4. **É um papel na UI (bg, text, action, status, score)?** → Semantic.
5. **É específico de UM componente?** → Component (mora junto do BEM CSS).

Se um token cabe em 2 camadas, escolha a **mais alta** (mais próxima de Primitive). Granularidade adiciona complexidade — só justifica com necessidade real.

---

## 7. Critério "criar nova cor" (gate de governance)

Antes de adicionar QUALQUER cor nova, responder em PR description (briefing §13):

1. Essa cor resolve uma função nova?
2. Melhora leitura/hierarquia/estado?
3. Pode ser substituída por token existente?
4. Precisa existir em todos os produtos?
5. É específica de um produto?
6. Pertence a Brand/Theme/Semantic/Score/Status/Chart?
7. Passa contraste WCAG nos usos previstos?
8. Funciona em light + dark mode?
9. Será reutilizável?
10. Tem nome previsível?
11. Terá documentação?
12. Precisa de fallback?

Pelo menos 8 respostas precisam ser "sim claro" ou "sim com justificativa".

---

## 8. Why component tokens NÃO ficam em tokens.css

Discussão arquitetural pra futura referência:

**Opção A (descartada):** todos os component tokens em `tokens.css` (`--component-button-bg`, `--component-card-radius`, etc.).
- ❌ Vira arquivo gigante (centenas de tokens) difícil de auditar.
- ❌ Acopla `tokens.css` ao catálogo de componentes — adicionar componente novo exige editar o arquivo de foundation.
- ❌ Quem lê `btn.css` precisa abrir `tokens.css` pra entender o que o token significa.

**Opção B (adotada):** component tokens vivem em `output/css/<block>.css` no topo do arquivo do componente.
- ✅ Componente é unidade auto-contida — toda info do button está em `btn.css`.
- ✅ Adicionar componente novo não toca `tokens.css`.
- ✅ Drift detection fica trivial — `Librarian` cruza spec ↔ tokens declarados no próprio CSS.
- ⚠️ Trade-off: tokens.css não é "fonte única de verdade" pra TUDO, só pra Primitive/Brand/Theme/Semantic. Component é distribuído.
