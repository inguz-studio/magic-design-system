# Design Principles Checklist — magic-ds

**Agent owner:** `mds-audit` (Observer)
**Command:** `*design-check` (a ser adicionado em [agents/mds-audit.md](../agents/mds-audit.md))
**Status:** v1 — 2026-05-13
**Fontes consolidadas:**
- 📘 [Figma · Princípios do design gráfico (PT-BR)](https://www.figma.com/pt-br/resource-library/principios-do-design-grafico/) — base canônica
- 📗 [Kittl · Principles of Design](https://www.kittl.com/blogs/principles-of-design-bgt/) — métodos de verificação
- 📙 [Lagerwall · 10 dos and don'ts](https://www.linkedin.com/pulse/10-essential-dos-donts-perfecting-your-article-claire-lagerwall-cbg7e/) — princípios de conteúdo UI

---

## Como este checklist se posiciona

| Camada de validação | Pergunta que responde | Onde vive |
|---------------------|----------------------|-----------|
| **Heurísticas UX** (Nielsen) | "O usuário consegue usar?" | `nielsen-heuristics-checklist.md` |
| **Acessibilidade** (WCAG) | "Todos conseguem usar?" | `a11y-wcag-checklist.md` + bloco `a11y:` no spec.yaml |
| **🆕 Design gráfico** (este doc) | "Está visualmente claro, hierárquico e harmônico?" | `design-principles-checklist.md` |
| **Naming / Taxonomia** | "Os nomes seguem a regra?" | `mds-governance` |

Os 4 são **complementares e ortogonais**. Um componente pode passar nos outros 3 e falhar aqui.

---

## Como usar

1. Aplicar em **componentes individuais** após `mds-component` produzir o spec.yaml e antes do `mds-ops` gerar código (gate FIGMA_PROPOSE).
2. Aplicar em **telas compostas** (Dashboard, Materials, etc.) após Ops gerar HTML.
3. Marcar cada critério: ✅ passa · ⚠️ passa parcial (justificar) · ❌ falha.
4. **Pass mínimo:** todos os critérios ✅. ⚠️ aceitável se houver justificativa documentada no spec.yaml.
5. ❌ bloqueia handoff até resolver.

---

# 14 Princípios

## 1. Hierarquia — *Hierarchy*

> Organização e destaque de elementos conforme sua importância, guiando o olhar do usuário às informações relevantes.

### Critérios objetivos
- [ ] Em uma tela ou componente composto, existe **1 ponto focal claro** (não 2 ou mais competindo).
- [ ] A escala tipográfica entre níveis tem diferença **≥1.25×** (h1 vs h2 vs body — atende escala modular do Round 1).
- [ ] Botões primários (CTA) têm **maior peso visual** (cor, tamanho ou contraste) que secundários/ghost.
- [ ] Em KPI cards: o **valor numérico** tem ≥2× o tamanho do label e ≥1.5× o tamanho da descrição.

### Verificação
- **Squint test** (Kittl): Aperte os olhos / desfoque a tela. O que ainda destaca? Esse é o ponto focal. Se nada destaca, falha.
- **Reading order test**: Anote em que ordem você leu naturalmente os elementos. Confere com a importância de negócio?

### Tokens / regras do DS
- `--semantic-type-h1` (28px, 600) > `--semantic-type-h2` (24px, 600) > `--semantic-type-h3` (20px, 600) > `--semantic-type-body` (16px, 400) > `--semantic-type-caption` (12px, 400) — escala já obedece 1.25×+
- `--semantic-bg-brand` reservado pra CTA primário; secundários consomem `--semantic-text-brand` + border

### Anti-padrão
🚫 Múltiplos botões com `intent=primary` na mesma tela (canibalismo de hierarquia).

### Fontes
Figma · Kittl · Lagerwall (item 2: "subheadings")

---

## 2. Contraste — *Contrast*

> Diferenças visuais claras entre elementos para destacar informações importantes e criar interesse.

### Critérios objetivos
- [ ] Texto sobre fundo atende **WCAG 1.4.3** — contraste ≥4.5:1 (texto normal) ou ≥3:1 (texto grande/UI).
- [ ] Estado `selected` é visualmente distinto de `default` sem depender só de cor (ex: também muda peso, posição ou ícone).
- [ ] Botões e elementos clicáveis têm contraste ≥3:1 com vizinhança (WCAG 1.4.11).
- [ ] Status (online/offline/alerta) **NÃO** depende apenas de cor — sempre com ícone ou texto.

### Verificação
- **Grayscale test** (Kittl): converta a tela pra preto-e-branco. Os elementos ainda se diferenciam? Se sim, contraste estrutural sólido.
- Ferramenta: `chrome://flags/#enable-experimental-web-platform-features` ou extensão WCAG Color Contrast Checker.

### Tokens / regras do DS
- `--semantic-text-primary` (gray-100) sobre `--semantic-bg-canvas` (gray-800) = 15.8:1 ✅
- `--semantic-text-on-brand` (#FFF) sobre `--semantic-bg-brand` (#E57300) = 4.2:1 ⚠️ (passa em texto grande, falha em texto pequeno)
- Status family expõe versão `tint` (background @16%) com texto colorido — boa relação de contraste

### Anti-padrão
🚫 Tag de status `solid` com fundo `--semantic-status-alert` (#FFCC66) + texto branco — falha contraste (Tag.spec.yaml já flagou em `gaps_for_foundations`).

### Fontes
Figma · Kittl · Lagerwall (item 5: "formatting for emphasis")

---

## 3. Equilíbrio — *Balance*

> Distribuição do peso visual dos elementos para criar uma composição coesa (simétrica ou assimétrica).

### Critérios objetivos
- [ ] Em layouts compostos (Dashboard), o peso visual não está concentrado em um quadrante.
- [ ] Sidebar (232px) + main (flex-1) cria equilíbrio L→R apropriado pro contexto.
- [ ] Cards adjacentes têm dimensões compatíveis (mesma altura mínima ou ratio harmonioso).
- [ ] Nenhuma região da tela tem >60% de elementos coloridos saturados.

### Verificação
- **Blur test** (Kittl): "Zoom out ou aplica blur. Se um canto grita mais alto que tudo o resto, está desequilibrado."
- Vire a tela de cabeça pra baixo — a distribuição de massa continua aceitável?

### Tokens / regras do DS
- `--primitive-size-sidebar-expanded` (232px) define o peso fixo esquerdo; main fica responsivo
- Grid de 12 colunas (padrão admin) garante equilíbrio simétrico nos KPI cards

### Anti-padrão
🚫 Toda informação importante encostada no topo-esquerdo, deixando a metade direita vazia ou ornamental.

### Fontes
Figma · Kittl

---

## 4. Alinhamento — *Alignment*

> Organização do texto e dos elementos para criar ordem e conexão visual através de bordas, centros ou linhas de base comuns.

### Critérios objetivos
- [ ] Todos os elementos alinham a uma grade de **4px ou 8px** (padrão do DS).
- [ ] Labels e valores em formulários/tabelas alinham em **colunas claras** (label à esquerda + valor à direita OU label sobre valor — consistente em toda a tela).
- [ ] Em listas/tabelas: números alinhados à **direita**; texto alinhado à **esquerda**.
- [ ] Bordas de containers vizinhos compartilham a mesma linha vertical/horizontal (não 1px de drift).

### Verificação
- Ative o **layout grid no DevTools** (`html { background-image: linear-gradient(...) }`) e verifique se os elementos respeitam.
- Régua sobre a tela: traça linhas horizontais nos topos e verticais nos lados — devem cair em N elementos múltiplos.

### Tokens / regras do DS
- Toda a escala `--primitive-space-*` é múltiplo de 4 (4, 8, 12, 16, 20, 24...).
- Roles `inset` (padding interno) e `inline` (gap entre itens) garantem alinhamento por consumo de token, não por valor mágico.

### Anti-padrão
🚫 Padding inline-start de 14px (off-grid) em vez de 12px ou 16px.

### Fontes
Figma

---

## 5. Proximidade — *Proximity*

> Posicionamento de elementos próximos para indicar relação; espaço maior indica ausência de conexão.

### Critérios objetivos
- [ ] Label e seu input estão a ≤8px de distância (stack-sm).
- [ ] Helper text e seu input estão a ≤4px (stack-xs).
- [ ] Grupos não relacionados estão separados por ≥24px (stack-lg ou stack-xl).
- [ ] Ícone e label de NavItem estão a 12px (inline-md) — mais perto sugere que são uma unidade.

### Verificação
- Pergunta a um colega: "Esses dois elementos estão relacionados?" Se a resposta diverge do que você queria comunicar, o espaçamento está errado.
- Squint test: elementos relacionados devem formar um "bloco" só ao desfocar.

### Tokens / regras do DS
- `stack-xs` (4px) → relação direta (label↔helper)
- `stack-sm` (8px) → relação próxima (label↔input)
- `stack-md` (16px) → relação contextual (form fields no mesmo grupo)
- `stack-lg/xl` (24/32px) → separação entre grupos
- `inline-xs/sm/md` análogo no eixo horizontal

### Anti-padrão
🚫 Label↔input com 24px de gap + dois inputs com 8px entre si — comunica relação invertida.

### Fontes
Figma

---

## 6. Repetição — *Repetition*

> Reutilização de elementos idênticos ou semelhantes para criar coesão, equilíbrio e ritmo visual, consolidando identidade da marca.

### Critérios objetivos
- [ ] Componentes do mesmo tipo (todos KpiCards, todos botões) usam **mesma estrutura**: mesmo radius, mesmo padding, mesmo header pattern.
- [ ] Headers de cards seguem o mesmo padrão (título + ícone help opcional, alinhamento idêntico).
- [ ] Botões de mesma intent têm visual idêntico em todas as telas.
- [ ] Iconografia segue o mesmo grid (16/20/24/32) e estilo (outlined, stroke 1.8).

### Verificação
- Coloque 3 instâncias do mesmo componente em telas diferentes lado-a-lado. **Diferenças não-intencionais** = falha.
- Componentes consomem o **mesmo spec.yaml**? Se não, há fragmentação.

### Tokens / regras do DS
- Princípio "componentes consomem só `--semantic-*`" garante consistência via tokens.
- Templates de componente (`templates/component.spec.template.yaml`) impõem mesma estrutura.
- `mds-governance` valida que naming/regras se repetem corretamente.

### Anti-padrão
🚫 KpiCard "Conformes" com border-radius 12px e KpiCard "Alerta" com 10px — repetição quebrada.

### Fontes
Figma · Kittl

---

## 7. Ritmo — *Rhythm* (vertical + horizontal)

> Movimento, fluidez e interesse visual criados pelo espaçamento e disposição de elementos repetidos. **Princípio padrão do squad — toda entrega deve respeitar a cadência canônica abaixo.**

### 7.A Cadência canônica (escala vertical hierárquica)

Cada nível tem gap ≥1.5× o anterior. Toda escala mapeia para tokens `--semantic-space-stack-*`:

| Nível | Nome | Gap | Token semantic | Onde aplicar |
|------:|------|----:|---------------|--------------|
| **L0** | Item | 4-8px | `stack-xs` / `stack-sm` | Itens em lista (NavItems, swatches em row, tags adjacentes) |
| **L1** | Block-internal | 12-16px | `stack-md` | label↔input, h4↔primeiro texto, ícone↔texto vertical |
| **L2** | Group | 24px | `stack-lg` | Entre grupos de form fields, entre subgrupos de Row |
| **L3** | Block | 32px | `stack-xl` | Entre cards/blocos de mesma seção (Button Block ↔ IconButton Block) |
| **L4** | Subsection | 48-56px | `mt-12` a `mt-14` | Entre subseções h3 dentro de uma seção (1.1 → 1.2 → 1.3) |
| **L5** | Section-internal | 32px após lede | `mb-8` | Lede → primeiro conteúdo. h2 → lede: 16px (`mb-4`) |
| **L6** | Section | 96px | `marginBottom: 96` | Entre seções top-level (h2 ↔ h2) |

### 7.B Regras hard (binárias — pass/fail no design-check)

- [ ] **Escala hierárquica respeitada**: gap em nível N ≥ 1.5× gap em nível N-1. Detecção de exceção exige justificativa documentada.
- [ ] **Heading têm mt > mb**: headings (h1-h4) têm `margin-top` maior que `margin-bottom`. Isso associa visualmente o heading ao **conteúdo abaixo**, não ao anterior.
- [ ] **First-of-sequence sem ghost**: primeiro item de uma lista/grupo aplica `:first-child` modificador (`first:mt-0` ou similar) pra remover margem fantasma no início.
- [ ] **Last-of-sequence sem ghost**: último item aplica `:last-child` modificador (`last:mb-0`) pra evitar gap dobrado antes do próximo elemento.
- [ ] **Padding interno < gap externo**: containers (Block, Card) têm padding interno ≤ gap entre eles. Inverso (padding > gap) cria sensação de containers grudados com itens respirando — invertido.
- [ ] **Same-level uniforme**: todos os "Block" da mesma seção têm gap idêntico; todos os "Row" idêntico. Nunca misturar `mb-4` e `mb-6` em sequência similar sem motivo declarado.
- [ ] **Linhas repetidas com altura idêntica**: tabelas, NavItems, swatches em grid — altura fixa por tipo (ex: NavItem sempre 40px = control-md).
- [ ] **Line-height de body ≥1.5**: parágrafos longos (lede, body) consomem `--primitive-leading-normal` (1.5) ou `1.6/1.65` — leitura confortável.

### 7.C Verificação

- **Marcação visual**: zoom out 50% e marca os gaps com régua mental. Cada gap deve cair em um valor da tabela acima (4, 8, 12, 16, 24, 32, 48, 56, 96) — qualquer valor "perdido" (10px, 14px, 18px, 22px) = anti-padrão.
- **Heading association test**: cubra o heading com a mão. O texto abaixo "perde âncora"? Se sim, mt está OK (heading se associa ao conteúdo). Se o texto continua coerente sem o heading, mt pode estar pequeno.
- **Squint test rítmico**: aperte os olhos. Os blocos devem aparecer como ilhas distintas, não como mar contínuo nem como ilhas brigando por espaço.
- **Cadência ascendente**: vá rolando — cada quebra deve "parecer maior" que a anterior. Section break é o maior; gap entre items é o menor.

### 7.D Tokens / regras do DS

- Família `--semantic-space-stack-*` para gap vertical (xs→xl = 4/8/16/24/32). Para níveis maiores (L4-L6), usar Tailwind utilities (`mb-12`, `mb-14`, `mb-24`).
- Componentes wrapper canônicos no showroom:
  - `<Section>` — encapsula Section break + heading + lede com rhythm correto
  - `<SubH>` — encapsula L4 subsection break com `first:mt-0`
  - `<Block>` — encapsula L3 com `last:mb-0`
  - `<Row>` — encapsula L2 com `first:mt-X`
- **Anti-fragmentação**: nunca aplicar `mb-X` em h2 direto no JSX — sempre usar `<Section>`. Mesma regra pra `<SubH>`, `<Block>`, `<Row>`.

### 7.E Anti-padrões (red flags)

- 🚫 **Heading com mb > mt**: `h3 className="mt-2 mb-6"` — o título "desconecta" do conteúdo abaixo, parece pertencer ao anterior.
- 🚫 **Mix de gaps em mesma sequência**: `<Block mb-4 />` + `<Block mb-6 />` + `<Block mb-8 />` — quebra ritmo.
- 🚫 **First child com mt fantasma**: primeira `<SubH>` de uma Section ainda tem `mt-14`, criando gap dobrado abaixo da lede.
- 🚫 **Last child com mb fantasma**: último `<Block>` mantém `mb-8` antes do footer, criando gap dobrado.
- 🚫 **Padding > Gap**: cards com `p-12` (48px) mas `gap-4` (16px) entre cards — invertido.
- 🚫 **Valor off-grid**: `marginBottom: 18` ou `gap: 10` — fora da escala canônica.
- 🚫 **`<br>` ou `<div className="h-X" />` pra criar gap**: use Tailwind spacing tokens em vez de DOM hack.

### 7.F Onde isso é exemplificado canonicamente

- `src/showroom/App.jsx` (referência viva)
- Componentes wrapper `<Section>`, `<SubH>`, `<Block>`, `<Row>` definidos lá são o **template** para qualquer composição futura

### Fontes
Figma · Kittl · **decisão squad 2026-05-13** (princípio padrão de workflow)

---

## 8. Espaço em Branco — *White Space*

> Área vazia entre e ao redor de elementos que proporciona respiro visual, melhorando legibilidade e equilíbrio.

### Critérios objetivos
- [ ] Cards têm padding interno **≥16px** (inset-lg) — nunca cards "afogados".
- [ ] Texto longo tem `max-width` ≤72ch (linhas longas demais comprometem leitura).
- [ ] Hierarquia de h2 → h3 → body tem espaçamento **vertical generoso** (h2 → conteúdo: 16–24px).
- [ ] Botões agrupados têm gap ≥8px entre si (não colados).
- [ ] Densidade global da tela: relação branco/elemento ≥30% — telas devem respirar.

### Verificação
- **5-foot test:** afaste-se 1.5m da tela. Os blocos ainda se distinguem claramente?
- Sente claustrofobia ao olhar a tela? White space insuficiente.

### Tokens / regras do DS
- `--semantic-space-inset-*` para padding interno.
- `--semantic-space-stack-*` para espaçamento vertical.
- `--semantic-space-inline-*` para gap horizontal.

### Anti-padrão
🚫 KpiCard com `padding: 8px` — sufoca o conteúdo (deveria usar `inset-lg = 16px+`).

### Fontes
Figma · Kittl · Lagerwall (items 1 e 4: "break up large blocks", "add space between steps")

---

## 9. Proporção — *Proportion*

> Relação de tamanho e peso visual dos elementos entre si.

### Critérios objetivos
- [ ] Ícones têm tamanho proporcional ao texto adjacente: 16px (icon-sm) com text-xs, 20px (icon-md) com text-sm/base, 32px (icon-lg) com headings.
- [ ] Containers grandes não ficam vazios (proporção quebrada) — quando ocupados, têm conteúdo de tamanho adequado.
- [ ] Em KpiCard: valor numérico ocupa ~50% da largura visual do card; label/descrição ocupam o resto.
- [ ] Em Sidebar: largura collapsed (64) = item-touch-target (40) + padding (12+12). Sem espaço sobrando.

### Verificação
- Razão áurea (1.618) ou múltiplos simples (1:2, 1:3) tendem a parecer naturais. Não é regra, é ferramenta.
- Coloque um humano genérico de 24×24 no canto — todos os elementos parecem dimensionados em relação a ele?

### Tokens / regras do DS
- Escala primitive de espaço já segue progressão harmônica (4, 8, 12, 16, 20, 24, 32, 40, 48, 64, 80, 96).
- Type scale também: 10, 12, 14, 16, 18, 20, 24, 28 — ratio modular ~1.25.

### Anti-padrão
🚫 Ícone 32px ao lado de texto 12px — desproporção visual.

### Fontes
Figma · Kittl

---

## 10. Movimento — *Movement*

> A forma como o olhar do usuário é guiado ao longo do design — padrões em Z, F ou em camadas.

### Critérios objetivos
- [ ] Em telas com sidebar: leitura segue padrão **F** (esquerda → topo → conteúdo principal).
- [ ] Em formulários: ordem dos campos respeita fluxo natural (do mais importante/genérico ao mais específico).
- [ ] CTA principal está no caminho visual natural (canto inferior-direito de formulários; topo-direito de modais; etc.).
- [ ] Decorações (linhas, setas, gradientes) que parecem guiar o olhar **realmente guiam para algo relevante** — não pra vazio.

### Verificação
- **Heatmap mental**: Onde seu olho cai primeiro? Segundo? Terceiro? Compare com o que você queria comunicar.
- Eye-tracking real (se disponível). Senão, peça a um colega "leia esta tela em voz alta na ordem que você lê" e observe.

### Tokens / regras do DS
- Posição fixa da Sidebar (esquerda) força o padrão F na maioria das telas admin.
- `--semantic-bg-brand` em CTAs cria âncoras de movimento — usar sparingly.

### Anti-padrão
🚫 Botão "Salvar" no canto superior-esquerdo de um formulário longo — quebra o fluxo F.

### Fontes
Figma · Kittl

---

## 11. Ênfase — *Emphasis*

> Destaque do principal ponto focal através de cor, contraste, espaço em branco ou proporção.

### Critérios objetivos
- [ ] Cada tela tem **um único ponto de máxima ênfase** — o que mais importa naquela tela.
- [ ] Ênfase usa **pelo menos 2** das técnicas (cor, tamanho, peso, posicionamento, white space) — nunca só uma.
- [ ] CTA primário (`Button intent=primary`) reservado pra **ação principal** da tela, não usado >1x.
- [ ] Status críticos (offline, erro) recebem ênfase via cor `--semantic-status-offline` **+** ícone **+** texto.

### Verificação
- **Three-second test**: mostre a tela por 3s, esconda, pergunte "qual era a ação/info principal?" — deve haver resposta única.
- Squint test: o que sobrevive ao desfoque?

### Tokens / regras do DS
- `--semantic-bg-brand` (laranja Shelflix) reservado pra ênfase máxima.
- Stacking de técnicas: variant `solid` em Tag + tamanho `md` + posição central = ênfase reforçada.

### Anti-padrão
🚫 5 botões primary na mesma tela competindo. Resultado: nenhum tem ênfase.

### Fontes
Figma · Kittl · Lagerwall (item 5)

---

## 12. Cor — *Color*

> Evoca emoções, transmite mensagens e molda percepção da marca.

### Critérios objetivos
- [ ] Paleta **brand** (`--primitive-brand-*`) usada com moderação — predominância em CTAs, estado selected, ícones-âncora; **não** em fundos amplos.
- [ ] Status semânticos consistentes em todo o produto: verde = positivo, vermelho = negativo, amarelo = atenção, azul = informativo.
- [ ] Cor **nunca é único canal** de informação (combinada com ícone, texto ou posição — vide Acessibilidade 1.4.1).
- [ ] Tom dark-first respeitado: backgrounds em escala gray-700/800 dominam; branco puro reservado pra `--semantic-text-on-brand`.

### Verificação
- **Color blindness simulator** (Stark, ColorOracle): rode a tela com simulação de protanopia/deuteranopia/tritanopia. Informações ainda chegam?
- Conte cores saturadas usadas. Mais de **5** numa tela é geralmente sintoma de problema.

### Tokens / regras do DS
- `--primitive-brand-700` (#E57300) usado só via `--semantic-bg-brand` ou `--semantic-text-brand` — sem hardcode.
- Status family expõe `--semantic-status-*` (cheio) + `--semantic-status-*-bg` (tint 16%) para escolha contextual.

### Anti-padrão
🚫 Sidebar inteira em laranja (`--semantic-bg-brand`) por "destacar marca" — destrói hierarquia e cansa.

### Fontes
Figma

---

## 13. Unidade — *Unity*

> Reúne todos os princípios para garantir que o design seja harmonioso e coeso, formando composição integrada.

### Critérios objetivos
- [ ] Componentes na mesma tela vêm do mesmo DS (não há mistura de bibliotecas).
- [ ] Iconografia tem estilo único (todos outlined OU todos filled — nunca misturado).
- [ ] Cantos arredondados consistentes: `--semantic-radius-control` em controles (botões/inputs), `--semantic-radius-surface` em cards.
- [ ] Tipografia única (Sora) em toda a interface — sem fonts diferentes em headers vs body.

### Verificação
- Olhe a tela inteira de longe. Sensação de "uma coisa só" ou "Frankenstein"?
- Pegue um componente e mova mentalmente pra outra tela — encaixaria sem parecer estranho?

### Tokens / regras do DS
- Toda a Unidade do DS é consequência dos outros 12 princípios sendo respeitados.
- Validação automática via `mds-governance`: nomes/regras consistentes.

### Anti-padrão
🚫 Mix de border-radius 4px em alguns botões e 8px em outros — quebra unidade visual.

### Fontes
Figma · Kittl

---

## 14. Escaneabilidade de Conteúdo — *Scannability* 🆕

> Específico pra interfaces admin/dashboards: o usuário escaneia, não lê linha-a-linha. Conteúdo precisa ser estruturado pra leitura saltada.

### Critérios objetivos
- [ ] Informação crítica está **acima da dobra** (top 720px em desktop).
- [ ] Parágrafos em descrições ≤4 linhas (≤72 caracteres por linha).
- [ ] Empty states têm texto **explicativo** + **CTA claro** + **ícone ilustrativo** (3 elementos, não só texto).
- [ ] Tabelas com >10 linhas têm filtros e/ou paginação visíveis sem scroll.
- [ ] Imagens/ícones que **transmitem informação** têm label/aria-label — nunca decorativos sem contexto quando comunicam dado.

### Verificação
- **5-second test**: mostre a tela por 5s, esconda, peça pra usuário descrever o que viu. As 3 infos principais devem ter sido captadas.
- F-pattern reading test: peça pra colega ler primeiros 5 elementos que o olho pegou. Confere com top-3 importância?

### Tokens / regras do DS
- `--semantic-type-h2` + `--semantic-type-h3` quebram visualmente a leitura.
- Pagination component oferece scan visual da quantidade total ("Mostrando 1-25 de 27").
- Status `Tag` permite escanear via cor + texto curto em listas/tabelas.

### Anti-padrão
🚫 Card sem título no topo, exigindo que o usuário leia conteúdo pra entender o que aquele card mostra.

### Fontes
Lagerwall (items 1, 2, 6, 7, 8, 9) — adaptado de princípios editoriais.

---

# Sumário e Aplicação

## Rubrica de score (por componente / por tela)

| Score | Critério |
|-------|----------|
| **A** (4.5–5.0) | ≥13/14 princípios ✅, sem ❌ |
| **B** (3.5–4.4) | ≥11/14 princípios ✅, ≤1 ❌ com justificativa |
| **C** (2.5–3.4) | 8–10 ✅, até 2 ❌ — entra em backlog de refino antes de stable |
| **D** (<2.5) | <8 ✅ ou ≥3 ❌ — **bloqueia** handoff (volta pra mds-component ou mds-foundations) |

## Quando rodar

| Momento | Escopo | Quem dispara |
|---------|--------|--------------|
| Após `mds-component` produzir spec.yaml | 1 componente | `mds-audit *design-check <Componente>` |
| Após `mds-ops` gerar HTML | 1 componente renderizado | `mds-audit *design-check --rendered <path.html>` |
| Antes de release de versão do DS | Todo o showcase | `mds-audit *design-check --all` |
| Em revisão de PR no produto | Tela inteira em uso | Manual ou via lighthouse-like ferramenta |

## Bloco opcional no spec.yaml

Cada componente pode declarar como atende princípios específicos — útil para componentes complexos:

```yaml
# Em <Componente>.spec.yaml
design_principles:
  hierarchy: "Valor numérico 2.5× maior que label (KpiCard tem ênfase clara no número)"
  emphasis: "intent=primary reservado para CTA principal"
  proximity: "Label↔input usa stack-sm (8px); grupos separados por stack-md (16px)"
  scannability: "Top 3 KpiCards acima da dobra em 720h"
  # Princípios não citados são validados pelo checklist padrão.
```

---

## Próximos passos

1. **Adicionar comando `*design-check`** em [agents/mds-audit.md](../agents/mds-audit.md) referenciando este checklist.
2. **Rodar piloto** no Dashboard real (screenshot enviado em 2026-05-13) — validar se a aplicação funciona antes de virar lei.
3. **Adicionar bloco `design_principles:`** ao template de spec.yaml (opcional).
4. **Integrar com showcase**: cada componente preview pode mostrar seu score A/B/C/D.

---

*Versão 1.0 · Fontes: Figma (PT-BR) + Kittl + Lagerwall · Última atualização: 2026-05-13*

---

## Apêndice — Overdesign Signals (Round 3.2)

Integrado da skill `ux-audit` (jvictor1223/claude-skills). Aplicar no princípio **11 — Ênfase** OU **3 — Equilíbrio**. Default severity = **RECOMMENDED**; escala pra **IMPORTANT** quando o excesso visual cria ambiguidade de hierarquia ou compete diretamente com a ação principal.

| Sinal | O que checar |
|---|---|
| Gradient como hierarquia | Gradient de background usado como signal principal entre seções (em vez de spacing + typographic scale) |
| Accent ubicuo | Cor accent usada em 3+ papéis distintos na mesma tela |
| Bordas decorativas | Border separando blocos onde spacing por si só comunicaria agrupamento |
| Emphases empilhadas | Mais de 1 ênfase visual no mesmo elemento (bold + color + background + border simultaneamente) |
| Sombras superdimensionadas | Shadow mais pesada que o nível de elevation real (`shadow-modal` em card sem dialog) |
| Animação ornamental | Motion/animação em elemento que não mudou de estado (decorativa, não responsiva) |

**Como reportar (formato de issue):**
```
**Problem:** Gradient de fundo usado pra separar seções 2 e 3 do dashboard
**Impact:** Compete visualmente com o KPI primário (Conformidade) — usuário não sabe onde focar
**Fix:** Substituir gradient por --semantic-space-section-md (48px) entre seções; manter bg-canvas uniforme
**Severity:** IMPORTANT (cria ambiguidade hierárquica)
```

---

## Apêndice — Prioritization Matrix (Round 3.2)

Antes de auditar, escolher perfil. Ver `agents/mds-audit.md §"Prioritization Matrix"`.

| Perfil | Ordem dos 14 princípios |
|---|---|
| Screen completa | Usabilidade (princípios 1-8 priorizados) → Hierarquia → Acessibilidade → Padronização → Responsividade |
| Component isolado | Padronização (13) → Acessibilidade → Usabilidade → Hierarquia |
| Flow review (2+ telas) | Usabilidade (task completion) → Clareza progressão → Consistência cross-screen → Acessibilidade |
| Iteration review (pós-feedback) | SÓ os pontos da iteração anterior. Issues novos só se críticos. |
