---
title: "Index DS State"
id: index-state
agent: mds-librarian
---

# Objective
Varrer os artefatos do squad e produzir um índice consolidado (`index.json` + `INDEX.md`), gerando snapshot timestamped para diff futuro.

# Steps
1. Receber `scope` (default: `all`) e `refresh` (default: `false`).
2. Listar diretórios alvo conforme tabela de escopo em `agents/mds-librarian.md` → "Escopo de indexação".
3. Para cada artefato: parsear (YAML/MD), extrair nome, versão, status, paths, last_modified.
4. Detectar duplicatas (mesmo nome em 2+ artefatos) → preencher `conflicts`.
5. Detectar referências órfãs (`see:`, `references.*`, `var(--*)` sem destino) → preencher `broken_references`. Cruzar com `gaps_for_foundations` para distinguir gap esperado de bug real.
6. Escrever `.librarian/index.json` (machine-readable) e `INDEX.md` (humano navegável).
7. Salvar snapshot em `.librarian/snapshots/<YYYY-MM-DD-HHmm>.json`.
8. Retornar JSON no formato declarado em `agents/mds-librarian.md` → "Formato de Saída Obrigatório (`*index`)".

# Error Handling
Vide tabela em `agents/mds-librarian.md` → seção `# Error Handling` (YAML inválido, permissão negada, snapshot anterior ausente, etc.).
