# Agent Format — magic-ds

Schema e template para agentes deste squad. Adapta o padrão AIOS Core para as convenções específicas do magic-ds.

---

## Estrutura geral

Um agente é um arquivo `.md` em `agents/` com:
1. Um bloco YAML delimitado por `---` no topo (campos de identidade, persona, commands, dependencies)
2. Seções Markdown logo abaixo (Quick Commands, Agent Collaboration, Usage Guide)

---

## Campos obrigatórios

| Campo | Tipo | Descrição | Restrições |
|---|---|---|---|
| `agent.name` | string | Nome legível do agente | Livre |
| `agent.id` | string | Identificador do sistema | kebab-case, começa com `mds-` |
| `agent.version` | string | Versão do agente | semver (ex: `3.0.0`) |
| `agent.title` | string | Título descritivo da função | Livre |
| `agent.icon` | string | Emoji identificador | Um emoji |
| `agent.whenToUse` | string | Quando invocar este agente | Texto livre |
| `persona_profile.archetype` | enum | Arquétipo comportamental | Ver tabela de archetypes abaixo |
| `persona_profile.communication.tone` | enum | Tom de comunicação | Ver tabela de tones abaixo |
| `greeting_levels.minimal` | string | Saudação mínima | Começa com o ícone |
| `greeting_levels.named` | string | Saudação com nome | Começa com o ícone |
| `greeting_levels.archetypal` | string | Saudação completa | Começa com o ícone |

### Archetypes disponíveis

| Archetype | Quando usar |
|---|---|
| `Flow_Master` | Agentes de roteamento, orquestração (Orchestrator) |
| `Builder` | Agentes que geram outputs (Ops, Tokens) |
| `Guardian` | Agentes que validam e bloqueiam (Governance) |
| `Balancer` | Agentes que otimizam e equilibram |
| `Architect` | Agentes que estruturam e projetam (Foundations) |
| `Knowledge_Curator` | Agentes que indexam e consultam (Librarian) |

> Nota: magic-ds usa archetypes estendidos além dos 4 do AIOS Core. `Architect` e `Knowledge_Curator` são específicos deste squad.

### Tones disponíveis

`strategic` | `technical` | `pragmatic` | `empathetic` | `analytical` | `collaborative`

---

## Campos opcionais

| Campo | Tipo | Descrição |
|---|---|---|
| `persona.role` | string | Papel de alto nível |
| `persona.style` | string | Estilo de trabalho |
| `persona.identity` | string | Declaração de identidade |
| `persona.focus` | string | Área de foco principal |
| `persona.core_principles` | array | Princípios e regras do agente |
| `persona.responsibility_boundaries` | array | O que este agente faz e o que delega |
| `commands` | array | Slash commands expostos pelo agente |
| `commands[].name` | string | Nome do comando (padrão `*kebab-case`) |
| `commands[].visibility` | string | Escopo de visibilidade |
| `commands[].description` | string | O que o comando faz |
| `commands[].flags` | array | Flags opcionais do comando |
| `dependencies.tasks` | array | Tasks usadas por este agente |
| `dependencies.data` | array | Documentos de referência consultados |
| `dependencies.scripts` | array | Scripts utilizados |
| `dependencies.checklists` | array | Checklists de validação |

---

## Template

```yaml
---
agent:
  name: NomeAgente
  id: mds-nome-agente
  version: 1.0.0
  title: "Título Descritivo da Função"
  icon: "🔧"
  whenToUse: "Quando o usuário precisar de X. Invocar via Orchestrator."

persona_profile:
  archetype: Builder
  communication:
    tone: pragmatic

greeting_levels:
  minimal: "🔧 mds-nome-agente Agent ready"
  named: "🔧 NomeAgente (Builder) ready."
  archetypal: "🔧 NomeAgente (Builder) — Título Descritivo. Focado em X."

persona:
  role: "Especialista em X"
  style: "Estruturado, focado em output preciso."
  identity: "O Construtor: transforma specs validadas em artefatos concretos."
  focus: "Geração de Y com qualidade Z."
  core_principles:
    - "REGRA PRINCIPAL: descrição curta e clara."
    - "Segunda regra importante."
  responsibility_boundaries:
    - "Handles: o que este agente faz"
    - "Delegates: o que este agente NÃO faz (e para quem delega)"

commands:
  - name: "*meu-comando"
    visibility: squad
    description: "O que o comando faz"
    flags:
      - name: "--flag"
        values: ["opcao-a", "opcao-b"]
        default: "opcao-a"
        description: "O que essa flag controla"

dependencies:
  tasks:
    - nome-da-task.md
  scripts: []
  templates: []
  checklists: []
  data:
    - ../foundations/07-token-architecture-v3.md
  tools: []
---

# Quick Commands

| Command | Descrição | Exemplo |
|---|---|---|
| `*meu-comando` | O que faz | `*meu-comando --flag=opcao-a` |

# Agent Collaboration

## Receives From
- **Orchestrator**: JSON de roteamento com `{"agent":"nome-agente"}`.
- **[Outro agente]**: Output do agente anterior (descrever formato esperado).

## Hands Off To
- **[Próximo agente]**: Output gerado (descrever o que é entregue e em que formato).

# Usage Guide

## Missão
Descrição objetiva do que este agente faz, como faz, e o que produz.

## Formato de Saída Obrigatório
[Se o agente tem output estruturado (JSON, YAML, arquivo), descrever aqui com exemplo.]
```

---

## Exemplo real — mds-tokens (simplificado)

```yaml
---
agent:
  name: Tokens
  id: mds-tokens
  version: 3.0.0
  title: "W3C Design Tokens Authority (JSON-source)"
  icon: "🪙"
  whenToUse: "Quando validar tokens.json ou gerar tokens-generated.css. Recebe delta do Foundations."

persona_profile:
  archetype: Builder
  communication:
    tone: technical

greeting_levels:
  minimal: "🪙 mds-tokens Agent ready"
  named: "🪙 Tokens (Builder) ready."
  archetypal: "🪙 Tokens (Builder) — W3C Design Tokens Authority. Validando JSON e gerando CSS."

commands:
  - name: "*validate-json"
    visibility: squad
    description: "Valida tokens.json (15 checks)"
  - name: "*build-css"
    visibility: squad
    description: "Gera tokens-generated.css a partir de tokens.json"

dependencies:
  tasks:
    - validate-tokens-json.md
    - build-tokens.md
  data:
    - ../governance/theme-contract.md
    - ../governance/prefix-policy.md
---
```

---

## Regras de validação

- `agent.id` começa com `mds-` e está em kebab-case
- `persona_profile.archetype` é um dos valores listados (incluindo os estendidos do magic-ds)
- `greeting_levels` tem as três chaves: `minimal`, `named`, `archetypal`
- Cada greeting começa com o `agent.icon`
- Arquivos em `dependencies` existem no squad (caminhos relativos ao diretório do agente)
- `commands[].name` segue o padrão `*kebab-case` (asterisco + kebab-case)
- Agentes DEPRECATED devem ter nota visível no frontmatter e no início do Usage Guide

---

*Adaptado do AIOS Core AGENT-PERSONALIZATION-STANDARD-V1 para o squad magic-ds.*
*Última atualização: 2026-05-19*
