---
title: "WCAG A11y UI Checklist"
description: "Checklist de Acessibilidade para o mds-component."
---

# Acessibilidade (WCAG 2.1 AA)

## Contraste e Cor
- [ ] A cor do texto principal sobre o fundo tem ratio mínimo de 4.5:1 (Normal) ou 3.0:1 (Large text).
- [ ] Componentes de UI (bordas de input, ícones) têm ratio mínimo de 3.0:1 contra o fundo.
- [ ] A cor não é o único meio visual de passar informação (estado de erro precisa de ícone ou texto auxiliar, não só vermelho).

## Navegação por Teclado e Foco
- [ ] Todos os elementos interativos recebem `:focus-visible`.
- [ ] A ordem de tabulação (`tabIndex`) segue o fluxo lógico e visual da página.
- [ ] É possível operar o componente apenas pelo teclado (Space/Enter para buttons).
- [ ] O estado de foco tem alto contraste (não remover outline sem prover alternativa).

## Semântica e Leitores de Tela
- [ ] Elementos gráficos informativos possuem `alt` ou `aria-label`.
- [ ] Ícones decorativos possuem `aria-hidden="true"`.
- [ ] Componentes customizados (modais, tabs) usam as propriedades ARIA corretas (`role="dialog"`, `aria-expanded`, etc).

---

## WCAG 2.1/2.2 — Success Criteria explícitos (Round 3.2)

Integrado da skill `ux-audit`. Cite o SC ID ao reportar violação.

| SC | Nível | Critério | Threshold |
|---|---|---|---|
| 1.4.3 | AA | Texto contrast | 4.5:1 normal · 3:1 large (≥18pt regular ou ≥14pt bold) |
| 1.4.5 | AA | Texto em imagens | Evitar texto como imagem (exceto logos) |
| 1.4.11 | AA | UI component contrast | 3:1 mínimo pra borders/icons/focus rings |
| 2.1.1 | A | Teclado | Toda interação via teclado |
| 2.3.3 | AAA | Animation from interaction | Respeitar `prefers-reduced-motion` |
| 2.4.7 | AA | Focus indicator | Visível, ≥3:1 contraste com adjacente |
| 2.5.5 | AAA | Target size primary | 44×44px recomendado pra primary actions |
| 2.5.8 | AA (WCAG 2.2) | Target spacing | 24×24px mínimo entre adjacent targets |

### Como reportar contraste (formato integrado)

```
PROBLEM: Text #767676 sobre #FFFFFF → estimated 4.48:1 (abaixo de 4.5:1 AA — SC 1.4.3)
FIX:     Trocar pra #747474 → 4.60:1 ✓
```

### Refs externas (tools)

- WCAG 2.1/2.2 Quick Reference: https://www.w3.org/WAI/WCAG21/quickref/
- APCA (Accessible Perceptual Contrast Algorithm — alternativa moderna): https://www.myndex.com/APCA/
- WebAIM Contrast Checker (mais usado): https://webaim.org/resources/contrastchecker/
- NN/g a11y patterns: https://www.nngroup.com/articles/accessibility/
