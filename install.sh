#!/usr/bin/env bash
# =============================================================================
# magic-ds installer (macOS / Linux / WSL / git-bash)
# Roda na raiz do projeto destino. Clona o squad e cria a policy.
# =============================================================================
set -euo pipefail

REPO="${MAGIC_DS_REPO:-https://github.com/inguz-studio/magic-design-system.git}"
BRANCH="${MAGIC_DS_BRANCH:-main}"
TARGET_DIR="squads/magic-ds"

ok()   { printf "\033[32m✓\033[0m %s\n" "$1"; }
warn() { printf "\033[33m⚠\033[0m %s\n" "$1"; }
err()  { printf "\033[31m✗\033[0m %s\n" "$1"; }
bold() { printf "\033[1m%s\033[0m\n" "$1"; }

bold "magic-ds installer"
echo ""

command -v git >/dev/null 2>&1 || { err "git não encontrado. Instale antes de continuar."; exit 1; }

if [ ! -f "package.json" ]; then
  warn "package.json não encontrado no diretório atual."
  read -r -p "  Continuar mesmo assim? [y/N] " ans
  [[ "$ans" =~ ^[yY]$ ]] || { echo "Abortado."; exit 0; }
fi

if [ -d "$TARGET_DIR" ]; then
  err "$TARGET_DIR já existe. Remova ou rode em outro projeto."
  exit 1
fi

mkdir -p squads
echo "→ Clonando squad em $TARGET_DIR..."
git clone --depth=1 --branch "$BRANCH" "$REPO" "$TARGET_DIR" >/dev/null 2>&1
rm -rf "$TARGET_DIR/.git"
ok "Squad clonado."

DEFAULT_NAME=""
if [ -f "package.json" ]; then
  DEFAULT_NAME=$(grep -m1 '"name"' package.json | sed -E 's/.*"name"[[:space:]]*:[[:space:]]*"([^"]+)".*/\1/' | sed 's|^@[^/]*/||')
fi
[ -z "$DEFAULT_NAME" ] && DEFAULT_NAME=$(basename "$PWD")

read -r -p "Nome do projeto [$DEFAULT_NAME]: " PROJECT_NAME
PROJECT_NAME="${PROJECT_NAME:-$DEFAULT_NAME}"
PROJECT_NAME=$(echo "$PROJECT_NAME" | tr '[:upper:]' '[:lower:]' | tr -c 'a-z0-9' '-' | sed 's/-\+/-/g; s/^-//; s/-$//')

DEFAULT_PREFIX=$(echo "$PROJECT_NAME" | tr -d -c 'a-z' | cut -c1-2)
RESERVED="tw bs mui ant css var"
for r_pref in $RESERVED; do
  if [ "$DEFAULT_PREFIX" = "$r_pref" ]; then
    warn "Prefix '$DEFAULT_PREFIX' é reservado. Escolha outro."
    DEFAULT_PREFIX=""
    break
  fi
done

read -r -p "Token prefix (2-3 letras) [$DEFAULT_PREFIX]: " TOKEN_PREFIX
TOKEN_PREFIX="${TOKEN_PREFIX:-$DEFAULT_PREFIX}"
TOKEN_PREFIX=$(echo "$TOKEN_PREFIX" | tr '[:upper:]' '[:lower:]' | tr -d -c 'a-z')
[ -z "$TOKEN_PREFIX" ] && { err "Prefix não pode ser vazio."; exit 1; }

TEMPLATE="$TARGET_DIR/config/squad-policy.template.yaml"
POLICY="$TARGET_DIR/config/squad-policy.yaml"
TODAY=$(date +%Y-%m-%d)

cp "$TEMPLATE" "$POLICY"
if sed --version >/dev/null 2>&1; then
  sed -i "s|<NOME-DO-PROJETO>|$PROJECT_NAME|g; s|<XX>|$TOKEN_PREFIX|g; s|<YYYY-MM-DD>|$TODAY|g" "$POLICY"
else
  sed -i '' "s|<NOME-DO-PROJETO>|$PROJECT_NAME|g; s|<XX>|$TOKEN_PREFIX|g; s|<YYYY-MM-DD>|$TODAY|g" "$POLICY"
fi
ok "squad-policy.yaml criado em $POLICY"

mkdir -p src/styles
if [ ! -f src/styles/tokens.json ]; then
  echo '{}' > src/styles/tokens.json
  ok "src/styles/tokens.json criado (vazio)."
fi

echo ""
bold "Pronto. magic-ds instalado."
echo ""
echo "  Projeto:      $PROJECT_NAME"
echo "  Token prefix: --$TOKEN_PREFIX-*"
echo ""
echo "Próximos passos:"
echo "  1. Abra o Claude Code na raiz do projeto"
echo "  2. Mande qualquer demanda de DS pro orchestrator:"
echo "     \"Estrutura os tokens iniciais do projeto\""
echo "     \"Audita o contraste do botão primário no tema dark\""
echo ""
echo "Docs: $TARGET_DIR/README.md"
