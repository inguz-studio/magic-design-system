---
title: "Build Tokens CSS"
description: "Le src/styles/tokens.json (W3C Design Tokens) e gera src/styles/tokens-generated.css. Idempotente, validado, com prefix configuravel."
agent: mds-tokens
input: src/styles/tokens.json
output: src/styles/tokens-generated.css
script: scripts/build-tokens.mjs
---

# Objetivo

Transformar o tokens.json (fonte da verdade, W3C format) em CSS consumido pelo app. Sem este task, tokens.json fica orfao — definicao sem materializacao.

# Pre-condicoes

- `src/styles/tokens.json` existe no projeto destino
- `scripts/build-tokens.mjs` instalado no projeto destino
- `config/squad-policy.yaml.token_prefix` declarado
- `mds-tokens *validate-json` passou (gate obrigatorio)

# Steps

## 1. Validacao previa (sem isso, nao roda)

Executa `mds-tokens *validate-json src/styles/tokens.json`. Se falhar, aborta com erro especifico (ref unresolved, prefix mismatch, coverage gap, etc.).

## 2. Walk recursivo do JSON

Pra cada set declarado em `$metadata.tokenSetOrder`:
- Le `$metadata.sets[<set>].selector` (default `:root` se ausente)
- Le `$metadata.sets[<set>].media` (opcional — wrappa em @media)
- Itera o set, coleta folhas com `$value`

## 3. Mapeamento path-no-JSON → nome-do-CSS-var

Aplica regra documentada em `foundations/07-token-architecture-v3.md §2`:

**Primitive (set canonico):**
- `primitive.color.orange.700` → `--<prefix>-primitive-orange-700`
- `primitive.spacing.4` → `--<prefix>-primitive-space-4`
- `primitive.typography.fontSize.sm` → `--<prefix>-primitive-text-sm`
- `primitive.motion.duration.fast` → `--<prefix>-primitive-duration-fast`
- `primitive.zIndex.deep` → `--<prefix>-primitive-z-deep`
- (regras especiais documentadas em scripts/build-tokens.mjs)

**Non-primitive sets:**
- camelCase → kebab-case
- Drop "default" segments
- Prefix `--<prefix>-`
- Exemplo: `actionPrimary.bgHover` → `--<prefix>-action-primary-bg-hover`

## 4. Resolucao de refs

Pra cada `$value` string com pattern `{path.to.token}`:
- Se primeiro segmento bate com nome de set conhecido → resolve cross-set
- Caso contrario → assume same-set
- Substitui pra `var(<css-name>)`

Exemplo: `"0 0 0 3px {actionPrimary.bgSubtle}"` → `0 0 0 3px var(--<prefix>-action-primary-bg-subtle)`.

## 5. Emissao do CSS

Pra cada set, emite bloco:

```css
/* -- <set-name> -- */
<selector> {
  --<prefix>-token1: value1;
  --<prefix>-token2: value2;
}
```

Se set tem `media`, wrappa:

```css
@media (...) {
  <selector> {
    ...
  }
}
```

## 6. Output

Grava em `src/styles/tokens-generated.css` com header `/* GENERATED — Source: tokens.json */`.

## 7. Log

Reporta:
- Total de tokens gerados
- Total de sets processados
- Tokens com refs (e contagem)
- Warnings (se houver, ex: set declarado mas vazio)

# Post-condicoes

- `src/styles/tokens-generated.css` existe e e parseavel por Vite/PostCSS
- Vite HMR (se ativo) atualiza automaticamente
- Showroom renderiza sem erro
- App em rodagem nao quebra (todas as refs CSS resolvem)

# Erros comuns

| Erro | Causa | Fix |
|---|---|---|
| `Token has no $value` | Folha em tokens.json sem $value | Adicionar $value ou remover folha |
| `Unknown $type` | $type fora do W3C spec | Trocar pra um valido (color, dimension, fontFamily, fontWeight, number, duration, cubicBezier, shadow, typography, other) |
| `Reference unresolved` | Ref `{...}` aponta pra token inexistente | Re-adicionar token target ou ajustar ref |
| `Prefix mismatch` | Token em JSON sem alinhar com squad-policy | Rodar `*add-token` ao inves de editar direto |
| `Set declarado mas vazio` | `$metadata.tokenSetOrder` lista set que nao tem keys no JSON | Popular set ou remover da lista |

# Tempo estimado

< 100ms pra 500 tokens. Idempotente — pode rodar em watch mode sem custo.

# Quando rodar

- Manualmente apos editar tokens.json
- Automaticamente em pre-commit hook (recomendado)
- Automaticamente em CI antes de build do projeto
- Apos Figma Tokens Studio sync
