---
title: "Visual Grooming & Nielsen Evaluation"
id: visual-grooming
agent: mds-audit
---

# Objective
Analisar criticamente imagens de UI (prints, protótipos Figma), extrair todos os elementos dos 8 pilares do DS e aplicar as 10 Heurísticas de Nielsen.

# Steps
1. Receber imagem ou **URL viva** e executar varredura visual/DOM.
2. No caso de URL, realizar scraping do CSS para inferir Tailwind classes nativas ou tokens estruturados.
3. Extrair cores dominantes e semânticas.
4. Avaliar Tipografia (font-family, tamanhos, pesos).
5. Identificar padrões de Espaçamento, Grids e Comportamento Responsivo (Breakpoints fluidos/Stacking).
6. Inspecionar Tom de Voz (UX Writing), Frameworks declarados, Ícones utilizados e parâmetros de Motion.
7. Aplicar 10 Heurísticas de Nielsen e listar quebras.
8. Gerar bloco JSON estruturado com as extrações para as próximas etapas (Code-First).
