---
title: "Generate Ops Code (shadcn wrap + Tailwind/CSS)"
id: generate-ops-code
agent: mds-ops
---

# Objective
Converter a arquitetura purificada (Governance + Foundations + Component) em código-fonte produtivo, distribuível e SEM vazamento da biblioteca primitiva (shadcn/ui).

# Princípio inegociável
shadcn/ui é detalhe de implementação. Vive em `/src/vendor/` e jamais é exportado pelo `src/index.ts`. Toda peça pública é um wrapper CVA em `/src/components/<Name>/` que importa de `@/vendor/<name>` e bind via CSS Variables.

# Steps

1. Consumir as variáveis CSS de fundação (Token Primitives e Semantics) entregues por Foundations + Governance.
2. Gerar JSON de Tokens e output compatível com Style Dictionary (se aplicável).
3. Gerar `figma-variables.json` no padrão Figma/W3C → salvar em `docs/design-system/`.
4. Compilar `DESIGN.md` legível por IA, incluindo a "Regra Inquebrável" (sem emojis na UI) + a regra de abstração shadcn (vendor isolado) → salvar em `docs/design-system/`.
5. Construir `global.css` (Token Primitives + Semantic em `:root`/`[data-tenant]`/`[data-theme]`) e `themes/<tenant>.css` (overrides) em `src/tokens/`. Toda Custom Property que algum wrapper consumir DEVE existir aqui.
6. Estender Tailwind v4 via `@theme` apontando para as CSS Variables — nunca colando valores hex/px direto na config.
7. Para cada componente declarado no spec:
   - **7a.** Instalar o primitivo: `npx shadcn-ui@latest add <primitive>` e MOVER o arquivo gerado para `src/vendor/<primitive>.tsx` (apagar `src/components/ui/` se a CLI criar).
   - **7b.** Gerar `src/components/<Name>/<Name>.tsx`: wrapper `forwardRef` que importa de `@/vendor/<primitive>`, usa `cva()` mapeando 1:1 os eixos `variants` + `sizes` do `component.spec.yaml`, e bind exclusivamente via `var(--token-*)`.
   - **7c.** Gerar `<Name>.types.ts` derivando props do primitivo + `VariantProps<typeof buttonVariants>` + flags booleanas (`isDisabled`, `isLoading`).
   - **7d.** Gerar `<Name>.stories.tsx` cobrindo todas as variants, sizes, estados (default/hover/focus/disabled/loading) e um caso `AllVariants`.
   - **7e.** Copiar o `component.spec.yaml` validado para `<Name>.contract.yaml` (espelho consumível em runtime).
   - **7f.** Gerar `<Name>/index.ts` exportando APENAS o wrapper público (`export { Button } from './Button'`).
8. Atualizar `src/index.ts` raiz adicionando UMA linha por componente novo: `export * from './components/<Name>'`. NUNCA adicionar export de `/vendor/` ou de `@/components/ui/`.
9. Gerar `.html` estático equivalente (versão zero-JS) com classes utilitárias acopladas — útil para fallback SSR/email.
10. Executar `build-local-showcase` → compila `showcase.html` interativo em `docs/design-system/`.
11. Executar `*validate-output` (gate final):
    - `grep -rE "from.*['\"]@?/?vendor" src/ --include="*.tsx" --include="*.ts" | grep -v "src/components/"` → DEVE retornar vazio
    - `grep -rE "from.*['\"]@?/?components/ui|shadcn" src/ --include="*.tsx" --include="*.ts" | grep -v "src/vendor/"` → DEVE retornar vazio
    - `grep -rE "bg-(violet|red|blue|green|yellow|purple|pink|orange|slate|zinc|neutral)-[0-9]|bg-\[#|text-\[#|border-\[#" src/ --include="*.tsx"` → DEVE retornar vazio
    - Qualquer hit aborta o pacote e gera relatório `validation-leaks.md` com `arquivo:linha`.
12. Preparar o pacote para distribuição final apenas se step 11 passou.

# Saída esperada
Pacote com `src/vendor/`, `src/components/<Name>/`, `src/tokens/`, `src/index.ts` enxuto, `docs/design-system/{DESIGN.md, figma-variables.json, showcase.html}` e um `validation-report.md` com os três greps vazios.
