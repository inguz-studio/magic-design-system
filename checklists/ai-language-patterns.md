# AI-Language Patterns — Checklist de Language-Review

**Status:** v1 — Round 6
**Consumido por:** `mds-librarian` (antes de escrever `INDEX.md`) e `mds-ux` (antes de emitir prose de `*design-critique` / relatório heurístico).
**Origem:** abstraído do método do `linkedin-voice-guardian` (Validador Pragmático), adaptado para **prosa técnica de Design System** (relatórios, índices, critiques) — não copy de marketing.

> **Regra de ouro:** este passe **não altera conteúdo técnico** (scores, paths, tokens, findings). Remove só os *tells* de escrita-IA na prosa em volta. Se a reescrita mudaria um número, um path ou um veredito — não reescreva.

---

## Quando rodar

Sempre **antes** de emitir um artefato markdown legível por humano:
- `INDEX.md` (Librarian)
- prose de `*design-critique` e o resumo de `*heuristic-audit` (UX)
- qualquer relatório que o usuário lê direto (não JSON machine-readable)

JSON de saída (`index.json`, scores de audit) **não** passa por aqui — é dado estruturado.

---

## As 6 categorias (varredura)

| # | Categoria | Bloqueadora? | Sinal | Exemplo a matar | Correção |
|---|---|---|---|---|---|
| 1 | **Abridores gastos** | **SIM** | Primeira frase do bloco | "No cenário atual do design system…", "Vamos mergulhar em…" | Entre no fato: "O token `--sf-bg-canvas` não resolve em light." |
| 2 | **Verbos/adjetivos vazios** | **SIM** | -izar/-alizar e elogios sem dado | "potencializar a consistência", "uma solução robusta e poderosa" | Diga o efeito concreto: "cobre 4 produtos sem reescrever CSS." |
| 3 | **Transições automáticas** | Não | Ponte de IA pra "virada" | "E sabe o que descobri?", "Vale ressaltar que…" | Incorpore a informação sem anunciá-la. |
| 4 | **Estrutura de template** | Não | 3+ frases curtas dramáticas em sequência | "Simples.\nLimpo.\nEscalável." | Varie o comprimento; uma frase técnica completa. |
| 5 | **Autoridade vaga** | Não | "boas práticas dizem", "é sabido que" | "estudos de UX mostram que…" sem fonte | Cite a heurística pelo nome: "Nielsen #1 (visibilidade de status)." |
| 6 | **Jargão de bastidor / hype** | Não | Meta-fala de processo | "entregar valor", "experiência transformadora" | Diga o que o componente faz: "o foco volta ao gatilho ao fechar o modal." |

---

## Regra de aprovação

- 0 categorias ativas → **Limpo** (emite direto)
- 1-2 não-bloqueadoras → **Médio** — limpar os trechos antes de emitir
- 1 bloqueadora OU 3+ quaisquer → **Alto** — reescrever a prosa antes de emitir
- 2 bloqueadoras OU categoria 1/2 com 3+ ocorrências → **Rejeitar** a prosa — reescrever do zero (sem tocar nos dados técnicos)

## Saída do passe (anexada ao handoff, não ao artefato)

```yaml
language_review:
  artifact: "INDEX.md | design-critique | heuristic-summary"
  categories_active: [<lista>]
  verdict: limpo | medio | alto | rejeitar
  rewrites_applied: <int>   # quantos trechos de prosa foram limpos
  technical_content_touched: false   # invariante — sempre false
```

> Invariante auditável: `technical_content_touched` é SEMPRE `false`. Se um rewrite exigiria mudar dado técnico, ele não acontece — o trecho fica como está e vira nota, não edição.
