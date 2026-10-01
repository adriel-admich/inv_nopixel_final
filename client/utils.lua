function PlayDropAnimation(player)
    local ped = GetPlayerPed(player)
    RequestAnimDict('pickup_object')
    while not HasAnimDictLoaded('pickup_object') do
        Wait(10)
    end
    TaskPlayAnim(ped, 'pickup_object', 'pickup_object', 8.0, -8.0, -1, 0, 0, false, false, false)
    RemoveAnimDict('pickup_object')
end

function PlayUseAnimation(player, item)
    local ped = GetPlayerPed(player)
    RequestAnimDict('mp_common')
    while not HasAnimDictLoaded('mp_common') do
        Wait(10)
    end
    TaskPlayAnim(ped, 'mp_common', 'givetake1_a', 8.0, -8.0, -1, 0, 0, false, false, false)
    RemoveAnimDict('mp_common')
end

function Notify(title, message, type)
    TriggerEvent('chat:addMessage', {
        color = type == 'success' and {0, 255, 0} or type == 'error' and {255, 0, 0} or {0, 150, 255},
        multiline = true,
        args = {title or 'Inventário', message}
    })
end

function DebugLog(message)
    if Config.Debug then
        print('^2[inv_nopixel_final]^7 ' .. message)
    end
end
