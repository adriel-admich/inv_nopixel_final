local open = false
local debugMode = Config.Debug or false

local function setVisible(state, data)
    open = state
    SetNuiFocus(state, state)
    SendNUIMessage({
        action = state and 'open' or 'close',
        data = data
    })
end

RegisterCommand(Config.Command, function()
    if open then
        setVisible(false)
        return
    end
    TriggerServerEvent('inv_nopixel_final:requestOpen')
end, false)

RegisterKeyMapping(Config.Command, 'Abrir inventário', 'keyboard', Config.OpenKey)

RegisterNetEvent('inv_nopixel_final:open', function(data)
    setVisible(true, data)
end)

RegisterNetEvent('inv_nopixel_final:close', function()
    setVisible(false)
end)

RegisterNetEvent('inv_nopixel_final:itemUsed', function(name, metadata)
    if debugMode then
        TriggerEvent('chat:addMessage', {
            color = {0, 255, 0},
            multiline = true,
            args = {'Inventário', 'Item usado: ' .. name}
        })
    end
end)

RegisterNUICallback('close', function(data, cb)
    setVisible(false)
    cb({ ok = true })
end)

RegisterNUICallback('use', function(data, cb)
    if data and data.name then
        TriggerServerEvent('inv_nopixel_final:useItem', data.name)
    end
    cb({ ok = true })
end)

RegisterNUICallback('drop', function(data, cb)
    if data and data.name then
        TriggerServerEvent('inv_nopixel_final:dropItem', data.name, data.amount or 1, data.metadata)
    end
    cb({ ok = true })
end)

RegisterNUICallback('give', function(data, cb)
    if data and data.name then
        TriggerServerEvent('inv_nopixel_final:giveItem', data.name, data.amount or 1)
    end
    cb({ ok = true })
end)

RegisterNUICallback('reorder', function(data, cb)
    if data then
        TriggerServerEvent('inv_nopixel_final:reorderItems', data.inventory, data.fromSlot, data.toSlot)
    end
    cb({ ok = true })
end)

RegisterNUICallback('transfer', function(data, cb)
    if data then
        TriggerServerEvent('inv_nopixel_final:transferItem', data.fromInventory, data.toInventory, data.itemName, data.amount, data.metadata)
    end
    cb({ ok = true })
end)

exports('openInventory', function()
    TriggerServerEvent('inv_nopixel_final:requestOpen')
end)

exports('closeInventory', function()
    if open then
        setVisible(false)
    end
end)

if debugMode then
    print('^2[inv_nopixel_final]^7 Client loaded successfully')
end
