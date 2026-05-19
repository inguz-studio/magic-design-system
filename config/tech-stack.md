# Tech Stack (Magic-DS)

Este documento define as tecnologias que os agentes do squad estão autorizados a utilizar e gerar durante o pipeline do Design System.

## Output Layers & Target Folders
Para manter a arquitetura do repositório destino limpa, o `mds-ops` enviará os arquivos físicos para:
1. **Design Tokens & Integração Figma**: `figma-variables.json` (Salvo em `docs/design-system/`).
2. **Contexto AI-First**: O arquivo Mestre **`DESIGN.md`** (Salvo em `docs/design-system/`).
3. **Local Showcase**: O arquivo `showcase.html` (Salvo em `docs/design-system/`).
4. **Fundação Visual Estrita**: Variáveis `--var` de Breakpoints, Primitives e Themes via `@theme` do Tailwind v4+ (Salvo em `src/styles/` ou equivalente).
5. **Component Templates**: Arquivos React (.tsx) e HTML com tipagem CVA/TV (Salvos em `src/components/ui/`).
6. **Tipagem**: TypeScript (`.ts`, `.tsx`).

## Iconografia (Abordagem Híbrida e Extração MCP)
- **Regra Inquebrável (Zero Emojis):** É EXPRESSAMENTE PROIBIDO o uso de Emojis como ícones ou elementos visuais de interface em qualquer componente gerado ou especificado no `DESIGN.md`.
- **Prioridade 1 (Extração Figma via MCP):** Sempre que houver contexto de um Figma MCP Server ativo, a IA deve priorizar a extração e abstração dos ícones vetoriais diretamente do board.
- **Prioridade 2 (Ícones Locais):** Consumo de SVGs locais isolados (ex: uma pasta `src/components/icons/`) caso não haja extração MCP.
- **Prioridade 3 (Biblioteca de Fallback):** `lucide-react` é a biblioteca padrão aprovada para preenchimento de ícones caso as opções anteriores falhem.

## Interações Externas
- **Figma API**: Integração assumida via output do arquivo **`figma-variables.json`** formatado pelo padrão W3C/Figma, para importação manual via plugin na ferramenta de design. O modelo antigo de `FIGMA_PROPOSE` foi descontinuado.
- **LLM Engine**: Modelos Multimodais (Vision) **fortemente recomendados** para `mds-audit *grooming` (análise de imagens). Fallback: se vision indisponível, Audit aceita apenas `*extract-url` (DOM/CSS scraping de URL viva).
