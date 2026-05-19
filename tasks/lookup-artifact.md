---
title: "Lookup DS Artifact"
id: lookup-artifact
agent: mds-librarian
---

# Objective
Responder se um artefato do DS (token, componente, reference) já existe — com path rastreável, versão e contexto. Usado por outros agentes antes de criar para evitar retrabalho e duplicata.

# Steps
1. Receber `query` (obrigatório) e `type` (`token | component | reference | any`, default: `any`).
2. Se índice (`.librarian/index.json`) ausente ou stale (>5 min e refresh solicitado), rodar `*index` primeiro. Senão usar cache.
3. Buscar matches no índice por: nome exato → nome parcial → conteúdo (em ordem de precedência).
4. Filtrar por `type` quando solicitado.
5. Para cada match, montar entrada com `artifact`, `kind`, `path:linha`, `version`, `status`, `last_modified`, `context`.
6. Se 2+ matches do mesmo nome → preencher `conflicts` com todos os paths.
7. Listar em `broken_references` qualquer artefato que **cita** a query mas cujo destino não existe (útil pro Governance).
8. Retornar JSON no formato declarado em `agents/mds-librarian.md` → "Formato de Saída Obrigatório (`*lookup`)".

# Regras
- Nunca inventar artefato — só reporta o que está em disco e parseou sem erro.
- Nunca escolher entre conflitos — devolve todos os paths e força decisão humana.
- Resposta sempre inclui path rastreável (`<arquivo>:<linha>`), nunca apenas "sim, existe".
