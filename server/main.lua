local cooldowns = {}

local function validAmount(amount)
    amount = tonumber(amount)
    return amount and amount > 0 and amount <= Config.Security.maxAmount and math.floor(amount) == amount
end

local function getInventoryData(source)
    local playerInventory = Bridge.GetInventory(source) or {}
    local playerWeight = 0
    local playerItems = {}

    for _, item in pairs(playerInventory) do
        if item then
            playerWeight = playerWeight + ((item.weight or 0) * (item.amount or item.count or 1))
            table.insert(playerItems, item)
        end
    end

    return {
        playerItems = playerItems,
        playerWeight = playerWeight,
        playerMaxWeight = Config.MaxWeight,
        groundItems = {},
        groundWeight = 0,
        currentInventory = nil,
        currentItems = {},
        currentWeight = 0,
        currentMaxWeight = 0
    }
end

local function allowed(source)
    local now = GetGameTimer()
    if cooldowns[source] and now - cooldowns[source] < Config.Security.actionCooldown then
        return false
    end
    cooldowns[source] = now
    return true
end

RegisterNetEvent('inv_nopixel_final:requestOpen', function()
    local source = source
    if source then
        local data = getInventoryData(source)
        TriggerClientEvent('inv_nopixel_final:open', source, data)
    end
end)

RegisterNUICallback('use', function(data, cb)
    local source = source
    if not source or not allowed(source) or not data then
        return cb({ ok = false })
    end

    local inventory = Bridge.GetInventory(source) or {}
    local item = nil

    for _, invItem in pairs(inventory) do
        if invItem and invItem.name == data.name then
            item = invItem
            break
        end
    end

    if not item or not Items[item.name] or not Items[item.name].usable then
        return cb({ ok = false })
    end

    if Config.Debug then
        print(('^2[inv_nopixel_final]^7 Player %d used item: %s'):format(source, item.name))
    end

    TriggerClientEvent('inv_nopixel_final:itemUsed', source, item.name, item.metadata or item.info or {})
    TriggerClientEvent('inv_nopixel_final:open', source, getInventoryData(source))

    cb({ ok = true })
end)

RegisterNUICallback('drop', function(data, cb)
    local source = source
    if not source or not validAmount(data.amount or 1) or type(data.name) ~= 'string' then
        return cb({ ok = false })
    end
    if not allowed(source) then return cb({ ok = false }) end

    local success = Bridge.RemoveItem(source, data.name, data.amount or 1, data.metadata)

    if success then
        if Config.Debug then
            print(('^2[inv_nopixel_final]^7 Player %d dropped: %dx %s'):format(source, data.amount or 1, data.name))
        end
        TriggerClientEvent('inv_nopixel_final:open', source, getInventoryData(source))
    end

    cb({ ok = success })
end)

RegisterNUICallback('give', function(data, cb)
    local source = source
    if not source or not validAmount(data.amount or 1) or type(data.name) ~= 'string' then
        return cb({ ok = false })
    end
    if not allowed(source) then return cb({ ok = false }) end

    cb({ ok = true })
end)

RegisterNUICallback('reorder', function(data, cb)
    local source = source
    if not source or not data or not data.inventory then
        return cb({ ok = false })
    end
    if not allowed(source) then return cb({ ok = false }) end

    if Config.Debug then
        print(('^2[inv_nopixel_final]^7 Player %d reordered items in: %s'):format(source, data.inventory))
    end

    cb({ ok = true })
end)

RegisterNUICallback('transfer', function(data, cb)
    local source = source
    if not source or not data or not validAmount(data.amount or 1) then
        return cb({ ok = false })
    end
    if not allowed(source) then return cb({ ok = false }) end

    local success = Bridge.AddItem(source, data.itemName, data.amount or 1, data.metadata)

    if success then
        if Config.Debug then
            print(('^2[inv_nopixel_final]^7 Player %d transferred: %dx %s'):format(
                source, data.amount or 1, data.itemName))
        end
        TriggerClientEvent('inv_nopixel_final:open', source, getInventoryData(source))
    end

    cb({ ok = success })
end)

RegisterNUICallback('close', function(data, cb)
    cb({ ok = true })
end)

exports('GetInventory', function(source)
    return Bridge.GetInventory(source)
end)

exports('AddItem', function(source, name, amount, metadata)
    return Bridge.AddItem(source, name, amount, metadata)
end)

exports('RemoveItem', function(source, name, amount, metadata)
    return Bridge.RemoveItem(source, name, amount, metadata)
end)

exports('HasItem', function(source, name, amount)
    return Bridge.HasItem(source, name, amount)
end)

exports('OpenInventory', function(source, inventoryType, inventoryData)
    if inventoryType and inventoryData then
        local data = getInventoryData(source)
        data.currentInventory = inventoryType
        data.currentInventoryName = inventoryData.name or 'INVENTÁRIO'
        data.currentItems = inventoryData.items or {}
        data.currentWeight = inventoryData.weight or 0
        data.currentMaxWeight = inventoryData.maxWeight or 30000
        TriggerClientEvent('inv_nopixel_final:open', source, data)
    else
        TriggerClientEvent('inv_nopixel_final:open', source, getInventoryData(source))
    end
end)

exports('CloseInventory', function(source)
    TriggerClientEvent('inv_nopixel_final:close', source)
end)

if Config.Debug then
    print('^2[inv_nopixel_final]^7 Server loaded successfully')
end
