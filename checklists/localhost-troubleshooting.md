# Localhost Troubleshooting Checklist — Shelflix Admin Showroom

> Use quando `http://localhost:5174/` **não renderiza** o showroom apesar do Vite estar rodando.
> Roteiro do mais simples ao mais profundo. Para de descer assim que achar a causa.

---

## 🟢 Camada 1 — Cliente (browser) — 80% dos casos

### 1.1 Hard reload
- [ ] **Ctrl+Shift+R** (Windows/Linux) ou **Cmd+Shift+R** (Mac) na aba aberta.
- [ ] Se não voltar, abrir aba anônima/privada (descarta extensions + cache).

### 1.2 DevTools Console
- [ ] Pressionar **F12** → aba **Console**.
- [ ] Procurar mensagens **em vermelho**. Tirar screenshot e copiar o texto.
- [ ] Erros comuns:
  - `Failed to fetch dynamically imported module` → algum import quebrado, ver path
  - `Uncaught SyntaxError` → erro de sintaxe em algum `.tsx`/`.jsx`
  - **`does not provide an export named '*Variants'`** → ARMADILHA CONHECIDA. Componente migrado de CVA→BEM com vestígio em `index.ts`. Ver §5 abaixo.
  - `MIME type mismatch` → Vite servindo CSS como JS ou vice-versa
  - `CORS policy` → improvável em localhost, mas checar
  - Nenhum erro mas tela branca → ver 1.3

### 1.3 DevTools Network
- [ ] **F12** → aba **Network** → checkbox **Disable cache** + **Preserve log**.
- [ ] Reload da página.
- [ ] Procurar:
  - **Requests com status 4xx/5xx** (vermelho) — esse é o asset quebrado
  - **Pending requests** que ficam 30s+ — pode ser HMR pendurado
  - **`main.jsx`** veio com `Content-Type: application/javascript`? Se vier `text/html`, Vite não está transformando — verificar route
  - **`globals.css`** veio com `Content-Type: text/css`? Se vier `application/javascript`, é HMR injection (normal em dev)

### 1.4 Tab antiga aberta há muito tempo
HMR pode ter dessincronizado após múltiplas mudanças estruturais (criação de `output/`, novos `@import`).
- [ ] **Fechar todas as abas** apontando pra `localhost:5174`.
- [ ] **Abrir uma aba nova** e navegar.

### 1.5 Browser extensions
- [ ] Testar em **aba anônima** (desliga extensions). Se funcionar, é alguma extensão (uBlock, dark reader, AdGuard...).

---

## 🟡 Camada 2 — Conexão localhost — 15% dos casos

### 2.1 URL correta
- [ ] Confirmar URL é **`http://localhost:5174/`** ou **`http://127.0.0.1:5174/`**.
- [ ] **NÃO** `https://` (Vite não tem TLS por padrão).
- [ ] **NÃO** `localhost:5173` ou outra porta antiga.

### 2.2 IPv6 vs IPv4
Algumas configurações Windows resolvem `localhost` pra `::1` (IPv6) enquanto Vite escuta `127.0.0.1` (IPv4). Teste:
```bash
curl -s -o /dev/null -w "IPv4: %{http_code}\n" http://127.0.0.1:5174/
curl -s -o /dev/null -w "IPv6: %{http_code}\n" http://[::1]:5174/
```
- [ ] Se IPv4=200 e IPv6=conn-refused, use **`http://127.0.0.1:5174/`** explicitamente.

### 2.3 Firewall / Antivírus (Windows)
- [ ] **Windows Defender** ou Norton/Avast podem bloquear `node.exe` em portas dev.
- [ ] Testar `ping 127.0.0.1` no terminal. Se OK, ping interno funciona.
- [ ] Desativar antivírus temporariamente pra confirmar (re-ativar depois).

### 2.4 Hyper-V / WSL
- [ ] Se desenvolvendo via **WSL**, o Vite roda dentro da VM Linux. URL é `http://localhost:5174` no Windows mas só funciona se o **WSL forwarding** estiver ativo.
- [ ] Testar `curl http://localhost:5174` no PowerShell **e** no WSL — deve dar 200 nos dois.

---

## 🔴 Camada 3 — Server (Vite) — raros

### 3.1 Vite está rodando?
```bash
# Procura processo Node escutando em 5174
netstat -ano | grep "5174"  # esperado: LISTENING
tasklist | grep node        # esperado: node.exe ativo
```
- [ ] Se nenhum LISTENING em 5174, Vite está down. Subir com `npx vite --port 5174 --host 127.0.0.1`.

### 3.2 Vite responde HTML?
```bash
curl http://127.0.0.1:5174/
```
- [ ] Esperado: `<!doctype html><html lang="pt-BR">...<div id="root"></div>...`
- [ ] Se vier vazio ou erro 500, Vite quebrou — checar terminal onde rodou `vite` pra ver stack trace.

### 3.3 Bundle de App.jsx transpila?
```bash
curl -o /dev/null -w "%{http_code}" http://127.0.0.1:5174/src/showroom/App.jsx
```
- [ ] Esperado: 200. Se 500, há erro de transformação — checar terminal Vite.

### 3.4 CSS cascade resolve?
```bash
curl -o /dev/null -w "%{http_code} | %{size_download}\n" http://127.0.0.1:5174/src/globals/globals.css
```
- [ ] Esperado: 200 + tamanho ≥40KB (inclui Tailwind compilado + tokens + canonical). Se <10KB, cascade quebrado.

### 3.5 Restart com `--force`
Limpa cache de pre-bundle, re-resolve dependências, força re-transformação:
```bash
# Mata processo antigo
taskkill /F /IM node.exe   # Windows (cuidado: mata TODOS os Node)
# Ou: ps -ef | grep vite + kill <pid>

# Sobe limpo
npx vite --port 5174 --host 127.0.0.1 --force
```

### 3.6 Limpa `.vite/` cache
```bash
rm -rf node_modules/.vite
npx vite --port 5174 --host 127.0.0.1
```

---

## ⚫ Camada 4 — Diagnóstico nuclear

Se nada acima resolveu:

### 4.1 Diff de arquivos críticos vs estado conhecido bom
```bash
git status                              # mudanças não commitadas
git log --oneline -10                   # últimos commits
git diff HEAD~5 -- src/main.jsx src/globals/globals.css src/showroom/App.jsx
```

### 4.2 Bundle completo do main.jsx
```bash
curl http://127.0.0.1:5174/src/main.jsx > /tmp/main.bundle.js
wc -l /tmp/main.bundle.js
head -20 /tmp/main.bundle.js
```
Sintaxe quebrada no bundle → algum import circular ou export missing.

### 4.3 Build de produção (descarta dev-only issues)
```bash
npx vite build
# Se buildar OK, o problema é só do dev server / HMR
npx vite preview --port 5174
```

### 4.4 Versões instaladas vs lockfile
```bash
npm ls vite @vitejs/plugin-react-swc @tailwindcss/vite
```
- [ ] Versões major mismatch entre instalado e package.json indicam install corrompido. `rm -rf node_modules package-lock.json && npm install`.

---

## ⚠️ §5 — Armadilhas conhecidas (post-mortems documentados)

### 5.1 CVA migration incompleta → tela branca

**Sintoma:** Console mostra `Uncaught SyntaxError: The requested module ... does not provide an export named 'buttonVariants'` (ou variante similar — `iconButtonVariants`, `tagVariants`, `navItemVariants`, `sidebarVariants`).

**Diagnóstico:** Componente foi migrado de `class-variance-authority` (CVA) pra classes BEM no `.tsx` mas **as referências residuais ficaram** em:
- `<Name>/index.ts` linha 1 (`export { Name, nameVariants } from "./Name"`) ← causa o SyntaxError
- `<Name>.types.ts` linhas 1-7 (`import type { VariantProps }`, `import type { nameVariants }`, `VariantProps<typeof nameVariants>`) ← causa trava `tsc`

**Por que enganou os health checks server-side:** Vite returna 200 em todos os endpoints, o bundle JS é textualmente válido, mas o módulo falha no parser do browser ao avaliar o re-export.

**Fix:**
```bash
# 1. Detectar todos os componentes afetados
grep -rE '\b\w+Variants\b' \
  --include='*.ts' --include='*.tsx' \
  src/components/

# 2. Pra cada componente listado, editar 3 arquivos:
#    a) <Name>/index.ts          → remove ", *Variants" do export
#    b) <Name>.types.ts          → remove imports CVA + extends VariantProps,
#                                   substitui por union types explícitos
#    c) <Name>.tsx               → confirmar que cva() já foi removido
```

**Prevenção (codificada no squad):**
- `mds-ops` core_principle inclui "MIGRAÇÃO CVA EXIGE 3 SUPERFÍCIES POR COMPONENTE"
- `canonical-output-checklist.md` §5.5 valida cross-file
- `*validate-output` grep #5 detecta automaticamente

**Caso histórico:** 2026-05-14, migração da onda 1 (Button/IconButton/Tag/NavItem/Sidebar). 5 componentes, 10 arquivos órfãos. Sintoma: tela branca total no showroom após Ctrl+R.

---

## Diagnóstico atual (snapshot 2026-05-14)

Última execução dos checks 3.1–3.5 retornou tudo healthy:
- [x] Vite rodando (PID 10640, LISTENING em 5174)
- [x] HTML serve (953 bytes, root div presente)
- [x] App.jsx bundle: 200 (286KB)
- [x] globals.css: 200 (83KB com classes BEM compiladas presentes)
- [x] canonical.css: 200 (28KB)
- [x] @vite/client e @react-refresh: 200
- [x] Tanto IPv4 quanto localhost retornam 200

**Conclusão:** se você ainda não vê, é Camada 1 (browser-side). Roda 1.1 e 1.2 primeiro.

---

## Onde reportar

Se o checklist não resolveu, abra issue com:
1. Output do **DevTools Console** (screenshot ou texto)
2. Output do **DevTools Network** (filtrado por `localhost:5174`)
3. Output dos comandos da §3 (Vite server health)
4. Versão do navegador + extensões ativas
