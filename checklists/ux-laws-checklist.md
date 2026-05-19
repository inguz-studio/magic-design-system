# UX Laws Checklist

**Agent owner:** `mds-audit` (Observer) — usar como sub-checklist em "Usabilidade"
**Status:** v1 — 2026-05-15
**Fontes:** design-critique skill (jvictor1223) + Laws of UX

8 leis perceptuais/cognitivas com threshold de violação. Aplicar quando auditar screens / flows / componentes.

---

## 1. Hick's Law — Decisão lenta com excesso de opções

**Princípio:** tempo de decisão aumenta logarítmicamente com número de opções.

**Threshold de violação:** ≥7 opções ungrouped numa decisão.

**Como aplicar:** menus, filtros, escolha de plano, lista de comandos.

**Fix patterns:** chunking em grupos, filtragem progressiva, default destacado, busca em listas longas.

---

## 2. Fitts's Law — Tamanho × distância dos alvos

**Princípio:** tempo pra acertar alvo é proporcional à distância e inversamente proporcional ao tamanho.

**Threshold:** touch target <44×44pt OU <24×24px de spacing entre adjacent targets (WCAG 2.5.8).

**Como aplicar:** botões primários, ícones em toolbar, controles em modal.

**Fix:** aumentar área clicável (padding ou pseudo-elemento), separar destrutivo de frequente.

---

## 3. Miller's Law — Chunking (7±2)

**Princípio:** memória de curto prazo cabe ~5-9 itens.

**Threshold:** listas/forms com >9 items sem agrupamento visual.

**Como aplicar:** forms longos, navegação, listas de status.

**Fix:** dividir em seções/passos, progressive disclosure, agrupamento Gestalt.

---

## 4. Jakob's Law — Usar o que é familiar

**Princípio:** usuário espera que seu produto funcione como os outros que ele já usa.

**Threshold:** padrão não-convencional sem razão clara (ex: hamburger no desktop, scroll horizontal em listagem vertical).

**Como aplicar:** navegação, forms, ícones (lupa = busca, lixeira = delete).

**Fix:** alinhar com convenção da plataforma; só divergir com benefit explicit.

---

## 5. Aesthetic-Usability Effect — Polido percebe-se mais usável

**Princípio:** UI visualmente polida é percebida como mais usável, mesmo que técnica seja igual.

**Como aplicar:** primeira impressão, demo, onboarding.

**Cuidado:** não substitui usabilidade real. Polish + bug = frustração maior.

---

## 6. Peak-End Rule — Lembrança da experiência

**Princípio:** users lembram do pico emocional + do final, não da média.

**Como aplicar:** fluxos de onboarding, checkout, sign-up, erros.

**Fix:** primeira impressão forte; fim positivo claro (confirmação, próximo passo claro).

---

## 7. Von Restorff Effect — Destaque do diferente

**Princípio:** elemento diferente dos vizinhos é lembrado mais facilmente.

**Threshold:** se TUDO está em destaque, NADA está. ≥2 elementos competindo visualmente pelo mesmo foco = ambiguidade.

**Como aplicar:** CTA primário, alerta crítico, indicador de página atual.

**Fix:** uma ênfase forte por seção. Demais elementos = support.

---

## 8. Zeigarnik Effect — Tarefas incompletas geram atenção

**Princípio:** users lembram melhor de tarefas inacabadas. Mostrar progresso ajuda a concluir.

**Como aplicar:** forms multi-step, onboarding, checkout, profile completion.

**Fix:** progress indicator (stepper, barra %, "X de Y"), checklist visível.

---

## Como reportar violação (formato de issue)

```
**Law:** Hick's Law
**Where:** Filter dropdown na tela /clientes
**Problem:** 14 opções ungrouped no single dropdown
**Impact:** Tempo de decisão alto; abandono provável em ~30% dos casos
**Fix:** Agrupar em 3 categorias (Status / Período / Região) com headers
**Severity:** IMPORTANT
```
