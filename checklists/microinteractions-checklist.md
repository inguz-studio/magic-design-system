# Microinteractions Checklist

**Agent owner:** `mds-component` (durante mapeamento de estados) + `mds-audit` (verificação)
**Status:** v1 — 2026-05-15
**Fonte:** design-critique skill (jvictor1223)

Toda interação tem 4 fases: **trigger → feedback → state → loop**. Falhar em qualquer fase = microinteraction quebrada.

---

## 1. Trigger Clarity

**Pergunta-teste:** user sabe o que vai acontecer ANTES de clicar?

| ✓ Bom | ✗ Ruim |
|---|---|
| Botão "Excluir cliente" | Botão "OK" em dialog destrutivo |
| Toggle "Notificações: Ativadas" | Toggle sem label state |
| Link "Abrir em nova aba ↗" | Link sem indicação de external |

---

## 2. Feedback Immediacy

**Threshold:** resposta visível em <100ms (perceived instant).

| Caso | Feedback esperado |
|---|---|
| Click button | State change (active/pressed) instant |
| Hover interactive | Cursor pointer + visual change em <50ms |
| Form submit assíncrono | Loading state em <200ms |
| Input typing | Validation real-time OU on blur (não silencioso) |

**Anti-pattern:** silent click — botão sem state visual durante processamento → user clica de novo.

---

## 3. State Communication

Todo elemento interativo precisa cobrir 6 states mínimos:

- `default`
- `hover`
- `focus-visible`
- `active` (pressed)
- `disabled`
- `loading` (quando async)

Estados extras conforme aplicável:
- `error` (form fields)
- `success` (confirmations)
- `selected` (toggle/checkbox)
- `expanded/collapsed` (disclosure)

**Como verificar:** mds-component spec.yaml deve declarar `states:` cobrindo TODOS aplicáveis.

---

## 4. Loop Completion

**Pergunta-teste:** ao final de uma interação recorrente, o loop fecha claramente?

| Interação | Loop completo |
|---|---|
| Toggle ativar/desativar | Visual state final claro + opcional aria-live ("Notificações ativadas") |
| Like / favoritar | Ícone preenchido + counter +1 + animação curta |
| Add to cart | Counter cart +1 + flash visual + opcional toast confirmação |
| Save draft | Indicador "Salvo às HH:MM" persistente |

**Anti-pattern:** loop ambíguo — user não sabe se ação foi registrada.

---

## 5. Error Feedback

Erro deve ser **específico** e **acionável**:

| ✗ Ruim | ✓ Bom |
|---|---|
| "Erro" | "Não conseguimos salvar — verifique sua conexão e tente novamente" |
| Shake genérico | Mensagem inline embaixo do campo: "Email já cadastrado. Esqueceu sua senha?" |
| Toast vermelho sem texto | Toast com erro + link de ajuda + ID de support (se aplicável) |

---

## Common gaps to flag (durante design-check)

- [ ] Button sem loading state durante ação async
- [ ] Form field sem inline validation feedback
- [ ] Toggle sem label visível de state (só cor)
- [ ] Ação destrutiva sem confirmação OU undo
- [ ] Save/copy sem confirmação de sucesso
- [ ] Hover-only feedback em interface também touch (sem alternativa)
- [ ] Microinteraction com animação > 500ms (lento demais pra feedback)
- [ ] Animation rodando sem state change ("decoração ruidosa")

---

## Como reportar (formato de issue)

```
**Phase:** Feedback Immediacy
**Where:** Botão "Salvar" em /clientes/[id]/edit
**Problem:** Sem loading state durante PUT (~800ms). User clica novamente, dobra submit.
**Impact:** Duplicate request + confusão sobre se salvou
**Fix:** Adicionar `aria-busy` + spinner em .btn--loading durante request
**Severity:** IMPORTANT
```
