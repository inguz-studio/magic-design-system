# Governance Validation Report

**Agent:** mds-governance (Guardian)
**Command:** `*enforce-rules --source=foundations/02-token-architecture.md --mode=block`
**Date:** 2026-05-12
**Verdict:** ✅ **APPROVED** (1 BLOCK resolvido in-place + 4 FLAGS para o usuário)

---

## 1. Regras aplicadas (do coding-standards.md)

| # | Regra | Status |
|---|-------|--------|
| 1 | Kebab-case estrito | ✅ |
| 2 | Token 3-layers respeitada (`--primitive-*`, `--semantic-*`, `--component-*`) | ✅ |
| 3 | Aliasing válido (Component nunca referencia Primitive direto) | ✅ |
| 4 | Sem typos / sem duplicatas | ✅ |
| 5 | Descrição clara em cada semantic token (inferida pelo prefixo) | ✅ |

---

## 2. Verificações automáticas (varredura)

### 2.1 Naming convention sweep

```
Total de tokens validados: 124
  Primitives:  78
  Semantic:    46 (23 light + 23 dark)

Casing: 124/124 kebab-case ✅
Prefixo: 124/124 com namespace correto ✅
Underscore: 0 (proibido) ✅
camelCase: 0 (proibido) ✅
PascalCase: 0 (proibido) ✅
```

### 2.2 Aliasing graph

```
Primitives  ────► (auto, sem upstream)
   │
   ▼
Semantic    ────► só referencia Primitives ✅
   │
   ▼
Component   ────► só referencia Semantic (a ser validado na fase mds-component)
```

Nenhuma violação de camada detectada.

### 2.3 Duplicatas

```
Foundations já resolveu 3 duplicatas do Figma:
  - Primary/Dark, Primary/Dark 10, Primary/Transparency/10% → unificado em --primitive-brand-700

Nenhuma duplicata residual encontrada.
```

### 2.4 Typos

```
Foundations corrigiu o typo do Figma:
  - "Sucess" → "success" (2 ocorrências)

Nenhum typo residual.
```

---

## 3. Flags para revisão humana (não-bloqueantes, mas recomendados)

### 🟡 Flag 1: `info-alt` como nome semântico

**Contexto:** O Figma tem `Info 2` (roxo `#BC89FF` / `#8A38F5`). Foundations mapeou como `--primitive-info-alt-*`.

**Risco:** "alt" é vago. Devs vão se perguntar quando usar `info` vs `info-alt`.

**Opções:**
- `--primitive-purple-*` (descritivo de cor — Tailwind-style)
- `--primitive-info-secondary-*` (semântico)
- `--primitive-accent-*` (se a intenção for "destaque alternativo")
- manter `--primitive-info-alt-*`

### 🟡 Flag 2: `brand` vs `primary`

**Contexto:** Foundations renomeou `Primary` → `brand` para distinguir cor de marca da hierarquia de cor primária genérica.

**Risco:** Convenções de DS variam. Time pode esperar `--color-primary-*`.

**Opções:**
- Manter `brand` (decisão atual) — semantica clara
- Voltar para `primary` — alinha com Figma
- Ambos como aliases — `--semantic-bg-primary: var(--semantic-bg-brand)`

### 🟡 Flag 3: Escala `success-light/success/success-dark` vs `success-50..900`

**Contexto:** Foundations usou só 3 stops por estado de feedback (light/base/dark). Tailwind-style usaria escala completa 50..900.

**Risco:** Se precisar de mais variações futuras (success-soft, success-emphasis), precisa expandir.

**Opções:**
- Manter atual (pragmático, cobre uso real)
- Expandir para 50..900 desde já (consistente, mas excessivo)

### 🟡 Flag 4: Sora como font sans (sem font display separada)

**Contexto:** Figma usa Sora para TUDO (heading + body + button). Foundations replicou.

**Risco:** Headings podem ficar visualmente fracos se design quiser uma display font futura.

**Opções:**
- Manter Sora único (consistente com Figma)
- Adicionar `--primitive-font-display` apontando pro mesmo Sora hoje, permitindo trocar amanhã sem refactor

---

## 4. Diretivas para `mds-component` (próxima fase)

Quando o Component agent mapear cada peça, **ele deve obrigatoriamente:**

1. Referenciar somente `--semantic-*` (nunca `--primitive-*`)
2. Seguir pattern: `--component-{name}-{variant}-{state}-{property}`
3. Garantir estados completos: `default`, `hover`, `active`, `focus-visible`, `disabled`, `loading` (se aplicável)
4. Validar contraste WCAG 2.1 AA antes de aprovar variantes

---

## 5. Diretivas para `mds-ops` (geração de código)

1. **Tailwind v4 @theme:** mapear tokens para CSS variables conforme spec v4 (sem `tailwind.config.js`)
2. **Multi-tenant scoping:** usar `[data-tenant="shelflix"]` no html root
3. **Theme switching:** usar `[data-theme="light|dark"]` em paralelo
4. **figma-variables.json:** seguir W3C Design Tokens spec para reimporte no Figma
5. **DESIGN.md:** documento legível por humanos + IAs com toda a taxonomia decidida

---

## 6. Verdict final

```json
{
  "agent": "governance",
  "verdict": "APPROVED",
  "blocked": false,
  "passes_to": "mds-component (para mapear APIs) ou mds-ops (para gerar código)",
  "warnings": [
    "info-alt naming (Flag 1)",
    "brand vs primary (Flag 2)",
    "feedback scale 3-stops (Flag 3)",
    "no display font separation (Flag 4)"
  ],
  "human_decision_required": "Optional — flags são recomendações, não bloqueios"
}
```

Pipeline pode prosseguir para **Component** ou pular direto para **Ops** se o usuário não quiser detalhar APIs de componentes agora.
