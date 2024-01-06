frameworkObject = nil
local Polices = {}
boolean = false

Citizen.CreateThread(function()
    frameworkObject, Config.Framework = GetCore()
end)

local function GetPolicePlayers()
    local swedenbby = {}
    local Players = GetPlayers()

    for i = 1, #Players do
        Players[i] = tonumber(Players[i])
        local player = frameworkObject.Functions.GetPlayer(Players[i])
        if player.PlayerData.job.name == 'police' then
            local coords = GetEntityCoords(GetPlayerPed(Players[i]))
            local playername = player.PlayerData.charinfo.firstname .. ' ' .. player.PlayerData.charinfo.lastname
            table.insert(swedenbby, {
                id = Players[i],
                name = playername,
                coordsx = coords.x,
                coordsy = coords.y,
            })
        end
    end
    return swedenbby
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5000)
        if boolean then
            local polices = GetPolicePlayers()
            for k, v in pairs(polices) do
                TriggerClientEvent('real-dispatch:Polices', v.id, polices)
            end
        end
    end
end)

RegisterNetEvent('real-dispatch:Active', function(data)
    boolean = data
end)

function RegisterCallback(name, cbFunc, data)
    while not frameworkObject do
        Citizen.Wait(0)
    end
    if Config.Framework == "newesx" or Config.Framework == "oldesx" then
        frameworkObject.RegisterServerCallback(
            name,
            function(source, cb, data)
                cbFunc(source, cb)
            end
        )
    else
        frameworkObject.Functions.CreateCallback(
            name,
            function(source, cb, data)
                cbFunc(source, cb)
            end
        )
    end
end
