frameworkObject = nil
local Polices = {}

Citizen.CreateThread(function()
    frameworkObject, Config.Framework = GetCore()
end)

RegisterNetEvent('real-dispatch:GetPolices')
AddEventHandler('real-dispatch:GetPolices', function(job, name, coords)
    local source = source

    if Config.Framework == 'newqb' or Config.Framework == 'oldqb' then
        local Player = frameworkObject.Functions.GetPlayer(source)
        if Player.PlayerData.job.name == job then
            table.insert(Polices, {
                id = source,
                name = name,
                coords = coords
            })
            print(json.encode(Polices))
            TriggerClientEvent('real-dispatch:GetPoliceTable', -1, Polices)
        end
    else
    end
end)