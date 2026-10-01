Bridge = {}
local QBCore

CreateThread(function()
    if GetResourceState('qbx_core') == 'started' then
        while not QBCore do
            Wait(100)
            local core = exports.qbx_core
            if core then QBCore = core end
        end
    elseif GetResourceState('qb-core') == 'started' then
        while not QBCore do
            Wait(100)
            QBCore = exports['qb-core']:GetCoreObject()
            if QBCore then break end
        end
    end
end)

local function getQboxInventory(source)
    if GetResourceState('qbx_core') == 'started' then
        local player = exports.qbx_core:GetPlayer(source)
        if player then
            return player.PlayerData.items or {}
        end
    end
    if QBCore then
        local player = QBCore.Functions.GetPlayer(source)
        if player then
            return player.PlayerData.items or {}
        end
    end
    return {}
end

function Bridge.GetInventory(source)
    if GetResourceState('ox_inventory') == 'started' then
        local inventory = exports.ox_inventory:GetInventory(source)
        if inventory and inventory.items then
            return inventory.items
        end
    end
    return getQboxInventory(source)
end

function Bridge.AddItem(source, name, amount, metadata)
    if GetResourceState('ox_inventory') == 'started' then
        return exports.ox_inventory:AddItem(source, name, amount, metadata)
    end
    if QBCore then
        local player = QBCore.Functions.GetPlayer(source)
        if player then
            return player.Functions.AddItem(name, amount, false, metadata)
        end
    end
    return false
end

function Bridge.RemoveItem(source, name, amount, metadata)
    if GetResourceState('ox_inventory') == 'started' then
        return exports.ox_inventory:RemoveItem(source, name, amount, metadata)
    end
    if QBCore then
        local player = QBCore.Functions.GetPlayer(source)
        if player then
            return player.Functions.RemoveItem(name, amount, false, metadata)
        end
    end
    return false
end

function Bridge.HasItem(source, name, amount)
    amount = amount or 1
    if GetResourceState('ox_inventory') == 'started' then
        local count = exports.ox_inventory:Search(source, 'count', name)
        return (count or 0) >= amount
    end
    local inventory = Bridge.GetInventory(source)
    local total = 0
    for _, item in pairs(inventory) do
        if item.name == name then
            total = total + (item.amount or item.count or 0)
        end
    end
    return total >= amount
end
