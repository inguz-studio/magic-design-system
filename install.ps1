# =============================================================================
# magic-ds installer (Windows PowerShell 5.1+)
# Roda na raiz do projeto destino. Clona o squad e cria a policy.
# =============================================================================
#Requires -Version 5.1
$ErrorActionPreference = 'Stop'

$Repo = if ($env:MAGIC_DS_REPO) { $env:MAGIC_DS_REPO } else { 'https://github.com/inguz-studio/magic-design-system.git' }
$Branch = if ($env:MAGIC_DS_BRANCH) { $env:MAGIC_DS_BRANCH } else { 'main' }
$TargetDir = 'squads\magic-ds'

function Write-Ok($m)   { Write-Host "[OK] $m" -ForegroundColor Green }
function Write-Warn($m) { Write-Host "[!]  $m" -ForegroundColor Yellow }
function Write-Err($m)  { Write-Host "[X]  $m" -ForegroundColor Red }

Write-Host "magic-ds installer" -ForegroundColor Cyan
Write-Host ""

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
  Write-Err "git não encontrado. Instale antes de continuar."
  exit 1
}

if (-not (Test-Path 'package.json')) {
  Write-Warn "package.json não encontrado no diretório atual."
  $ans = Read-Host "  Continuar mesmo assim? [y/N]"
  if ($ans -notmatch '^[yY]$') { Write-Host "Abortado."; exit 0 }
}

if (Test-Path $TargetDir) {
  Write-Err "$TargetDir já existe. Remova ou rode em outro projeto."
  exit 1
}

if (-not (Test-Path 'squads')) { New-Item -ItemType Directory -Path 'squads' -Force | Out-Null }

Write-Host "-> Clonando squad em $TargetDir..."
git clone --depth=1 --branch $Branch $Repo $TargetDir 2>$null | Out-Null
if ($LASTEXITCODE -ne 0) { Write-Err "Falha ao clonar $Repo"; exit 1 }
if (Test-Path "$TargetDir\.git") { Remove-Item -Recurse -Force "$TargetDir\.git" }
Write-Ok "Squad clonado."

$DefaultName = ''
if (Test-Path 'package.json') {
  try {
    $pkg = Get-Content 'package.json' -Raw | ConvertFrom-Json
    if ($pkg.name) { $DefaultName = $pkg.name -replace '^@[^/]+/', '' }
  } catch { }
}
if (-not $DefaultName) { $DefaultName = Split-Path -Leaf (Get-Location) }

$ProjectName = Read-Host "Nome do projeto [$DefaultName]"
if (-not $ProjectName) { $ProjectName = $DefaultName }
$ProjectName = ($ProjectName.ToLower() -replace '[^a-z0-9]+', '-').Trim('-')

$onlyLetters = $ProjectName -replace '[^a-z]', ''
$DefaultPrefix = if ($onlyLetters.Length -ge 2) { $onlyLetters.Substring(0, 2) } else { $onlyLetters }
$Reserved = @('tw','bs','mui','ant','css','var')
if ($Reserved -contains $DefaultPrefix) {
  Write-Warn "Prefix '$DefaultPrefix' é reservado. Escolha outro."
  $DefaultPrefix = ''
}

$TokenPrefix = Read-Host "Token prefix (2-3 letras) [$DefaultPrefix]"
if (-not $TokenPrefix) { $TokenPrefix = $DefaultPrefix }
$TokenPrefix = ($TokenPrefix.ToLower() -replace '[^a-z]', '')
if (-not $TokenPrefix) { Write-Err "Prefix não pode ser vazio."; exit 1 }

$Template = Join-Path $TargetDir 'config\squad-policy.template.yaml'
$Policy = Join-Path $TargetDir 'config\squad-policy.yaml'
$Today = Get-Date -Format 'yyyy-MM-dd'

Copy-Item $Template $Policy
$content = Get-Content $Policy -Raw
$content = $content -replace '<NOME-DO-PROJETO>', $ProjectName
$content = $content -replace '<XX>', $TokenPrefix
$content = $content -replace '<YYYY-MM-DD>', $Today
Set-Content -Path $Policy -Value $content -Encoding UTF8
Write-Ok "squad-policy.yaml criado em $Policy"

if (-not (Test-Path 'src\styles')) { New-Item -ItemType Directory -Path 'src\styles' -Force | Out-Null }
if (-not (Test-Path 'src\styles\tokens.json')) {
  Set-Content -Path 'src\styles\tokens.json' -Value '{}' -Encoding UTF8
  Write-Ok "src\styles\tokens.json criado (vazio)."
}

Write-Host ""
Write-Host "Pronto. magic-ds instalado." -ForegroundColor Cyan
Write-Host ""
Write-Host "  Projeto:      $ProjectName"
Write-Host "  Token prefix: --$TokenPrefix-*"
Write-Host ""
Write-Host "Próximos passos:"
Write-Host "  1. Abra o Claude Code na raiz do projeto"
Write-Host "  2. Mande qualquer demanda de DS pro orchestrator:"
Write-Host "     `"Estrutura os tokens iniciais do projeto`""
Write-Host "     `"Audita o contraste do botão primário no tema dark`""
Write-Host ""
Write-Host "Docs: $TargetDir\README.md"
