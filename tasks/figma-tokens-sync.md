---
title: "Figma Tokens Studio Sync"
description: "Protocolo bi-direcional de sincronizacao entre src/styles/tokens.json e plugin Figma Tokens Studio. Permite designer editar tokens em Figma + dev rodar build."
agent: mds-tokens (validate after sync) + mds-audit (initial setup)
input: src/styles/tokens.json (origem) OU export do Tokens Studio (destino)
output: tokens.json atualizado + tokens-generated.css regenerado
---

# Objetivo

Tokens.json em formato W3C Design Tokens e diretamente importavel pelo plugin **Tokens Studio for Figma**. Esse task documenta o protocolo bi-direcional pra evitar drift entre design (Figma) e codigo (JSON).

# Pre-condicoes

- tokens.json existe e e valido (`mds-tokens *validate-json` passa)
- Designer tem plugin Tokens Studio instalado no Figma
- Repositorio acessivel pro designer (via GitHub plugin do Tokens Studio OU download manual)
- `$themes` declarado em tokens.json pra cada combinacao ativa

# Direcao 1: JSON → Figma (designer importa)

## 1. Designer abre Tokens Studio no Figma
Plugin: https://tokens.studio

## 2. Designer escolhe metodo de sync
- **Recomendado:** GitHub direct sync (Settings → Sync → GitHub)
- **Alternativa:** Local file (download tokens.json + import)

## 3. Tokens Studio le tokens.json
- Reconhece estrutura W3C
- Le `$metadata.tokenSetOrder` e cria os sets
- Le `$themes` e cria as combinacoes (Admin Dark, Mission Dark, etc.)
- Refs `{path.to.token}` ja sao sintaxe nativa

## 4. Designer pode visualizar e editar
- Cada set virou uma "Token Set" no plugin
- Cada theme virou um "Theme" no plugin
- Mudancas locais ficam no plugin ate sync de volta

## 5. Aplicar tokens em layers do Figma
Designer pode aplicar tokens em layers (frames, textos, etc.) — visualizacao em tempo real do que cada combinacao gera.

# Direcao 2: Figma → JSON (designer commita mudanca)

## 1. Designer edita tokens no plugin

Exemplo: muda `primitive.color.orange.700` de #E57300 pra #FF6B00.

## 2. Designer roda sync (Push)
- GitHub: cria commit + PR automatico
- Local file: exporta JSON, dev recebe via canal acordado (Slack/email/etc.)

## 3. Dev recebe novo tokens.json

## 4. Validation pos-sync (OBRIGATORIO)

```
mds-tokens *validate-json src/styles/tokens.json
```

Possiveis falhas comuns que Tokens Studio pode causar:
- Refs cross-set quebradas (plugin renomeia set inadvertidamente)
- Sets opcionais removidos
- $type alterado pra valor invalido
- Prefix nao aplicado (plugin nao conhece o prefix policy)

Se validacao falhar, recovery via git revert + dialogo com designer.

## 5. Build

```
mds-tokens *build-css
```

Gera tokens-generated.css. Vite HMR pega. Showroom atualiza.

## 6. Code review

PR review checa:
- Diff so contem tokens (nao corrupcao de estrutura)
- Refs ainda fazem sentido
- Coverage dos sets obrigatorios mantida

# Validation rules pos-sync (alem dos 15 padroes)

Adicionais especificos de Figma sync:

16. **$themes preserved** — combinacoes nao foram corrompidas
17. **Set names match** — Tokens Studio nao renomeou sets
18. **$metadata.sets selectors intactos** — plugin nao alterou selectors CSS
19. **Refs not converted to literals** — plugin nao "resolveu" refs (deve manter `{...}`)

# Recovery

## Plugin corrompeu JSON
```
git diff src/styles/tokens.json
git checkout src/styles/tokens.json  # revert
```
Avisar designer + investigar causa (plugin version, sync mode, etc.).

## Conflict (designer + dev editaram simultaneo)
- Git merge manual
- Re-validar
- Re-build

# Acoes que NAO devem rodar via Figma sync

- Adicionar set novo (deve passar por Foundations primeiro pra definir minimos)
- Trocar prefix (deve passar por governance + migration script)
- Mudar selectors em $metadata.sets (responsabilidade do squad, nao do designer)

Esses casos exigem coordenacao designer + dev fora do plugin.

# Documentacao de onboarding pro designer

Criar `docs/figma-tokens-studio-onboarding.md` no projeto destino com:
- Como instalar plugin
- Como conectar ao repo
- Quais sets pode editar livre vs precisa de coordenacao
- Workflow padrao (push/pull)

# Quando NAO rodar este task

- Primeira instalacao do squad: tokens.json ainda nao existe — rodar `*onboarding-policy` primeiro
- Projeto nao usa Figma: ignorar este task inteiro, dev edita tokens.json direto
