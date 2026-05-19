---
title: "Diff DS State Snapshots"
id: diff-snapshots
agent: mds-librarian
---

# Objective
Comparar o estado atual do índice com um snapshot anterior — reportar `added`, `removed`, `modified` para detectar drift entre execuções do pipeline.

# Steps
1. Receber `against` (default: `previous`). Aceita também path absoluto de snapshot.
2. Carregar snapshot atual (rodar `*index` se ausente).
3. Resolver `against`:
   - `previous` → último snapshot em `.librarian/snapshots/` (ordem cronológica).
   - path explícito → carregar do disco.
4. Se snapshot anterior ausente: reportar `"no previous snapshot"` e tratar atual como baseline (não erro).
5. Para cada artefato indexado:
   - Presente só no atual → `added`.
   - Presente só no anterior → `removed`.
   - Presente em ambos com diferença de versão/status/conteúdo → `modified` (incluir campos alterados).
6. Compilar `summary` em linguagem natural breve (ex: `"3 tokens adicionados, 1 componente modificado"`).
7. Retornar JSON no formato declarado em `agents/mds-librarian.md` → exemplo 3 da seção "Exemplos".

# Quando rodar
- Após cada handoff entre agentes (detectar mudanças silenciosas).
- Antes de Governance validar (garantir estado fresco).
- Em CI/auditoria pós-sessão (rastrear evolução do DS).
