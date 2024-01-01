frameworkObject = false
PlayerJob = ""

Citizen.CreateThread(function()
    frameworkObject, Config.Framework = GetCore()
end)

RegisterCommand('opend', function()
    TriggerServerEvent('real-dispatch:GetPolices')
end)

RegisterNetEvent('real-dispatch:GotPolices')
AddEventHandler('real-dispatch:GotPolices', function(data)
    local processedData = {}

    for k, v in pairs(data) do
        local GetPlayers = GetPlayerFromServerId(v.id)
        local PlayerPeds = GetPlayerPed(GetPlayers)
        local GetCoords = GetEntityCoords(PlayerPeds)
        table.insert(processedData, {
            id = v.id,
            playername = v.playername,
            playerx = GetCoords.x,
            playery = GetCoords.y
        })
    end

    SendNUIMessage({
        action = 'OpenUI',
        data = processedData
    })
    SetNuiFocus(true, true)
end)


-- Citizen.CreateThread(function()
--     while true do
--         local Player = PlayerPedId()
--         local veh = GetVehiclePedIsIn(Player, false)
--         local Coords = GetEntityCoords(Player)
--         local Heading = GetEntityHeading(PlayerPedId())

--         SendNUIMessage({
--             action = 'UpdateLoc',
--             x = Coords.x,
--             y = Coords.y,
--             heading = Heading,
--         })

--         Citizen.Wait(1000)
--     end
-- end)