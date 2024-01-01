frameworkObject = nil

Citizen.CreateThread(function()
    frameworkObject, Config.Framework = GetCore()
end)

RegisterNetEvent('real-dispatch:GetPolices')
AddEventHandler('real-dispatch:GetPolices', function()
    if Config.Framework == 'newqb' or Config.Framework == 'oldqb' then
        local AllPlayers = frameworkObject.Functions.GetPlayers()
        local PlayersTable = {}
        for k, v in pairs(AllPlayers) do
            frameworkObject.Debug(AllPlayers)
            local Player = frameworkObject.Functions.GetPlayer(v)
            if Player.PlayerData.job.name == 'police' then
                table.insert(PlayersTable, {
                    id = v,
                    playername = Player.PlayerData.charinfo.firstname .. ' ' .. Player.PlayerData.charinfo.lastname
                })
            end
        end
        TriggerClientEvent('real-dispatch:GotPolices', source, PlayersTable)
    else
    end
end)