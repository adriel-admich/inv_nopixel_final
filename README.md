# inv_nopixel_final

Sistema de Inventário inspirado em NoPixel com compatibilidade total com Qbox/ox_inventory.

## 📋 Características

- ✅ Layout Split-Screen (Mochila esquerda, Chão/Baú direita, Hotbar embaixo)
- ✅ Gradiente de transparência nas laterais
- ✅ Drag-and-drop entre slots e inventários
- ✅ Context Menu (Use, Give, Drop) com botão direito
- ✅ Hotbar com 4 slots (Atalhos 1, 2, 3, 4)
- ✅ Sistema de peso e slots
- ✅ Painel dinâmico para Chão, Cofre, Porta-malas, Porta-luvas
- ✅ Camera travada e cursor visível ao abrir
- ✅ Animações suaves
- ✅ Compatível com ox_inventory nativo da base

## 🚀 Instalação

### 1. Copiar arquivo
```bash
# Extrair o .zip em:
resources/[inventory]/inv_nopixel_final
```

### 2. Configurar server.cfg
```cfg
ensure ox_lib
ensure qbx_core
ensure ox_inventory
ensure inv_nopixel_final
```

### 3. Reiniciar servidor
```text
refresh
restart inv_nopixel_final
```

## 📖 Como Usar

### Abrir Inventário
```lua
-- Comando padrão
/inventory

-- Ou via TAB (padrão)
TAB

-- Via export
exports.inv_nopixel_final:openInventory()
```

### Fechar Inventário
```lua
-- ESC
ESC

-- Via export
exports.inv_nopixel_final:closeInventory()
```

### Usar Hotkeys
```lua
1 - Usar item do slot 1 da hotbar
2 - Usar item do slot 2 da hotbar
3 - Usar item do slot 3 da hotbar
4 - Usar item do slot 4 da hotbar
```

### Adicionar Itens (Server)
```lua
exports.inv_nopixel_final:AddItem(source, 'water', 1, {})
```

### Remover Itens (Server)
```lua
exports.inv_nopixel_final:RemoveItem(source, 'water', 1)
```

### Verificar Item (Server)
```lua
if exports.inv_nopixel_final:HasItem(source, 'water', 1) then
    print('Player tem água')
end
```

### Abrir Inventário Dinâmico (Cofre, Baú, etc)
```lua
exports.inv_nopixel_final:OpenInventory(source, 'cofre', {
    name = 'COFRE',
    items = {},
    weight = 0,
    maxWeight = 50000
})
```

## ⚙️ Configuração

Edite `shared/config.lua`:

```lua
Config.Debug = false              -- Debug mode
Config.Command = 'inventory'      -- Comando para abrir
Config.MaxSlots = 40              -- Máximo de slots
Config.MaxWeight = 30000          -- Peso máximo em gramas
Config.OpenKey = 'TAB'            -- Tecla para abrir
```

## 📦 Adicionar Itens

Edite `shared/items.lua`:

```lua
Items = {
    water = {
        label = 'Água',
        weight = 500,
        stack = true,
        close = true,
        usable = true,
        description = 'Uma garrafa de água.'
    }
}
```

## 🎨 Customizar Interface

Edite `web/style.css` para mudar cores, layouts e animações.

## 🔗 Compatibilidade

- ✅ Qbox (qbx_core)
- ✅ QB-Core (qb-core)
- ✅ ox_inventory nativo
- ✅ FiveM ESX (com adaptação)

## 📝 Licença

MIT - Use livremente

## 💬 Suporte

Para dúvidas ou bugs, reporte em:
https://github.com/adriel-admich/inv_nopixel_final/issues
