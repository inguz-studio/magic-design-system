# Iconography — Magic-DS Shelflix Admin

## Lib oficial
- **`lucide-react`** (versão pinada: `0.460.0`)
- Figma plugin oficial: **Lucide Icons** (gratuito, mesma nomenclatura)

## Regras
- Tree-shake só com named imports: `import { Signal } from "lucide-react"`
- Size default: 20px. Pra outros, prop `size`: `<Signal size={24} />`
- Cor: default herda via `currentColor`. Pra cor explícita:
  `<Signal className="text-[var(--semantic-status-online)]" />`
- ❌ Sem SVG inline novo · sem outras libs de ícone · sem wrapper Icon
- ❌ Nunca importar Lucide em `/src/vendor/` (vendor = shadcn-only)
- ❌ Nunca `import * as Icons from "lucide-react"` (quebra tree-shake)

## Mapping canônico Figma → Lucide (12 ícones do Dashboard atual)

| Figma name | Lucide component | Uso típico |
|------------|------------------|------------|
| Signal | `Signal` | Conformes / Online status |
| Alert / Warning | `AlertTriangle` | Estado de alerta |
| No Internet / OFFLINE | `WifiOff` | Devices offline |
| Clock / CLOCK ZZ | `Clock` | Tempo / Indisponíveis |
| Eye | `Eye` | Visualizar (ação em tabela) |
| Edit | `Edit2` ou `Pencil` | Editar |
| Plus | `Plus` | Adicionar |
| Filter | `Filter` | Filtrar |
| Search | `Search` | Buscar |
| Trash | `Trash2` | Excluir |
| Question | `HelpCircle` | Help icon (KpiCard) |
| Logo Shelflix | (manter custom — não é ícone genérico) | Logo do tenant |

## Decisão de 2026-05-14
- Lucide-react direto, **sem wrapper Icon atom** (descartado)
- Sem registry custom (descartado)
- Sem extração de ícones do Figma (descartado)
- Reconsiderar wrapper apenas se governance ficar crítica no futuro
