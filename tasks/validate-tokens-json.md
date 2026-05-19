---
title: "Validate tokens.json"
description: "Verifica integridade de src/styles/tokens.json antes do build. 15 checks, falha rapido em qualquer um."
agent: mds-tokens
input: src/styles/tokens.json
output: relatorio JSON (pass/fail + issues)
---

# Objetivo

Validar tokens.json antes que `*build-css` rode. Sem isso, build pode emitir CSS com refs quebradas, prefix errado, ou coverage gap — quebrando o app silenciosamente.

# Quando invocar

- Pre-build (gate obrigatorio)
- Apos Figma Tokens Studio sync (detectar corruption)
- Em CI/PR check
- Manualmente apos editar tokens.json a mao

# Checks (15 regras)

## Grupo A — Estrutura

### #1 JSON parseavel
Falha se `JSON.parse(content)` lanca exception.

### #2 `$metadata` existe
Falha se nao tem `$metadata` no topo do JSON.

### #3 `$metadata.tokenSetOrder` existe e e array
Falha se ausente ou nao-array.

### #4 `$metadata.sets[<name>].selector` declarado pra cada set
Pra cada nome em `tokenSetOrder`, deve haver entry em `sets` com `selector`.

### #5 Sets em `tokenSetOrder` aparecem como keys no JSON
Falha se `tokenSetOrder` lista "semantic-dark" mas `tokens["semantic-dark"]` nao existe.

## Grupo B — W3C compliance

### #6 Toda folha tem `$value` e `$type`
Walk recursivo. Falha se alguma folha tem `$value` sem `$type` ou vice-versa.

### #7 `$type` validos
Lista permitida: `color`, `dimension`, `fontFamily`, `fontWeight`, `number`, `duration`, `cubicBezier`, `shadow`, `typography`, `other`.

### #8 `$value` consistente com `$type`
- `color`: regex hex/rgb/rgba/hsl
- `dimension`: termina em rem/px/em/% ou e "0"
- `fontWeight`: numero 100-900 ou keyword (normal, bold)
- `number`: typeof number
- `duration`: termina em ms ou s

## Grupo C — Referencias

### #9 Todas as refs `{...}` resolvem
Pra cada `$value` que contenha `{path.to.token}`, walk a arvore e confirma que o path existe.

### #10 Sem ciclos em refs
Se A referencia B que referencia A, falha.

### #11 Refs cross-set sao validas
Quando primeiro segmento da ref bate com nome de set, deve ser um set declarado em `tokenSetOrder`.

## Grupo D — Prefix policy

### #12 Prefix declarado em squad-policy
Le `config/squad-policy.yaml.token_prefix`. Falha se vazio.

### #13 Tokens nao tem prefix duplicado
Walk: nenhum path em JSON deve conter literal "sf-primitive" (so dentro do build script).

## Grupo E — Coverage (ver theme-contract.md)

### #14 `semantic-dark` cobre 28 minimos
Lista de tokens minimos em `governance/theme-contract.md §1.1`. Falha se algum ausente.

### #15 Sets opcionais cobertos quando declarados
- Se `semantic-light` declarado, cobre 14 minimos
- Se `product-<name>` declarado, cobre minimo conforme tipo (3.1 ou 3.2)
- Se `density-<level>` declarado, cobre size.control + space.{inset,stack}
- Se `reduce-motion` declarado, cobre todos os 9 motion roles

# Output

JSON estruturado:

```json
{
  "pass": false,
  "checks_run": 15,
  "checks_passed": 13,
  "checks_failed": 2,
  "issues": [
    {
      "check": 9,
      "severity": "error",
      "set": "semantic-dark",
      "path": "border.brand",
      "value": "{primitive.color.purple.700}",
      "message": "Reference unresolved: primitive.color.purple.700 nao existe (purple so tem 500 e 600)."
    },
    {
      "check": 14,
      "severity": "error",
      "set": "semantic-dark",
      "missing": ["bg.canvas"],
      "message": "Required token ausente."
    }
  ],
  "warnings": []
}
```

# Severity

- **error**: bloqueia build
- **warning**: nao bloqueia, mas reporta (ex: set opcional incompleto, token nao consumido por nenhum set)
- **info**: stats (ex: total de tokens, contagem por set)

# Exit codes

- `0` = pass (todos os checks passaram)
- `1` = fail com errors (bloqueia build)
- `2` = pass com warnings (build prossegue)

# Tempo

< 50ms pra tokens.json com 500 tokens.
