frameworkObject = false
PlayerJob = ""
policetable = {}

Citizen.CreateThread(function()
    frameworkObject, Config.Framework = GetCore()
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    local Player = frameworkObject.Functions.GetPlayerData()
    local name = Player.charinfo.firstname .. ' ' .. Player.charinfo.lastname
    local coords = GetEntityCoords(PlayerPedId())
    local job = Player.job.name

    TriggerServerEvent('real-dispatch:GetPolices', job, name, coords)
    print("OK")
end)

RegisterNetEvent('real-dispatch:GetPoliceTable', function(table)
    policetable = table
    print(json.encode(policetable))
end)

RegisterCommand('addMarker', function()
    print(json.encode(policetable))
    SendNUIMessage({
        action = "OpenUI",
        data = policetable
    })
    SetNuiFocus(true, true)
end)