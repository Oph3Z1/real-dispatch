frameworkObject = nil
Polices = {}
boolean = false
tablefalanserver = {}
openedplayerid = {}

Citizen.CreateThread(function()
    frameworkObject, Config.Framework = GetCore()
end)

if Config.Framework == 'newqb' or Config.Framework == 'oldqb' then
    RegisterNetEvent('QBCore:Server:OnPlayerLoaded')
    AddEventHandler('QBCore:Server:OnPlayerLoaded', function()
        local src = source
        local Player = frameworkObject.Functions.GetPlayer(src)
        local isAlreadyInTable = false
        
        for k, v in ipairs(Polices) do
            if v.id == src then
                isAlreadyInTable = true
                break
            end
        end

        if Player.PlayerData.job.name == 'police' and not isAlreadyInTable then
            local playername = Player.PlayerData.charinfo.firstname .. ' ' .. Player.PlayerData.charinfo.lastname
            local coords = GetEntityCoords(GetPlayerPed(src))
            table.insert(Polices, {
                id = src,
                name = playername,
                coordsx = coords.x, 
                coordsy = coords.y
            })
        end
    end)

    RegisterNetEvent('QBCore:Server:OnPlayerUnload')
    AddEventHandler('QBCore:Server:OnPlayerUnload', function()
        local src = source

        for k, v in ipairs(Polices) do
            if v.id == src then
                table.remove(Polices, k)
                break
            end
        end
    end)

    RegisterNetEvent('QBCore:Server:OnJobUpdate')
    AddEventHandler('QBCore:Server:OnJobUpdate', function(source, job)
        local src = source
        local Player = frameworkObject.Functions.GetPlayer(src)
        
        if Player then
            local job = Player.PlayerData.job
            if job.name == 'police' then
                for k, v in pairs(Polices) do
                    if v.id ~= src then
                        local playername = Player.PlayerData.charinfo.firstname .. ' ' .. Player.PlayerData.charinfo.lastname
                        local coords = GetEntityCoords(GetPlayerPed(src))
                        table.insert(Polices, {
                            id = src,
                            name = playername,
                            coordsx = coords.x, 
                            coordsy = coords.y
                        })
                        break
                    end
                end
            else
                for k, v in ipairs(Polices) do
                    if v.id == src then
                        table.remove(Polices, k)
                        break
                    end
                end
            end
        end
    end)
else
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        local Players = frameworkObject.Functions.GetPlayers()
        
        for k, v in pairs(Players) do
            local player = frameworkObject.Functions.GetPlayer(v)
            local isAlreadyInTable = false 

            for a, b in ipairs(Polices) do
                if b.id == v then
                    isAlreadyInTable = true
                    break
                end
            end

            if player.PlayerData.job.name == 'police' and not isAlreadyInTable then
                local playername = player.PlayerData.charinfo.firstname .. ' ' .. player.PlayerData.charinfo.lastname
                local coords = GetEntityCoords(GetPlayerPed(v))
                table.insert(Polices, {
                    id = v,
                    name = playername,
                    coordsx = coords.x,
                    coordsy = coords.y
                })
            end
        end
    end
end)

RegisterNetEvent('real-dispatch:AddDispatchToServer', function(table, coordsx, coordsy)
    local src = source
    for k,v in pairs(table) do
        v.player = src
        v.time = os.date("%I:%M %p")
        v.expireTime = os.time() + 60 * 0.5
    end
    TriggerClientEvent('real-dispatch:SendDispatchToUI', -1, table, coordsx, coordsy, 'normal')
    tablefalanserver = table
end)

RegisterNetEvent('real-dispatch:GetDispatchDataFromServer', function()
    local src = source
    TriggerClientEvent('real-dispatch:OpenUI', src, tablefalanserver)
end)

RegisterNetEvent('real-dispatch:Server:SendDispatchToTargetPlayer', function(data)
    local jsondata = json.encode(data)
    TriggerClientEvent('real-disapatch:Client:SendDispatchToTargetPlayer', data.player, data)

    for a, b in pairs(openedplayerid) do
        for k, v in pairs(tablefalanserver) do
            if k > 0 then
                if k == data.tableid then
                    table.remove(tablefalanserver, k)
                    TriggerClientEvent('real-dispatch:ClearPlayersDispatch', -1, data.player)
                    if b.id ~= nil or b.id ~= 0 and b.id then
                        TriggerClientEvent('real-dispatch:SendDispatchToUI', b.id, tablefalanserver, nil, nil, 'remove')
                    end
                    break
                end
            end
        end
    end
end)

RegisterNetEvent('real-dispatch:Active', function(data)
    local src = source
    boolean = data
    local isAlreadyInTable = false
        
    for k, v in ipairs(openedplayerid) do
        if v.id == src then
            isAlreadyInTable = true
            break
        end
    end
    
    if not isAlreadyInTable then
        table.insert(openedplayerid, {
            id = src
        })
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(Config.UpdateLocationTime * 1000)
        if boolean then
            for k, v in pairs(Polices) do
                if v.id then
                    local player = frameworkObject.Functions.GetPlayer(v.id)
                    if player then
                        local coords = GetEntityCoords(GetPlayerPed(v.id))
                        v.coordsx = coords.x
                        v.coordsy = coords.y
                    end
                end
            end
            for a, b in pairs(openedplayerid) do 
                TriggerClientEvent('real-dispatch:Polices', b.id, Polices)
            end 
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5000)
        for a, b in pairs(openedplayerid) do 
            if b.id ~= nil or b.id ~= 0 and b.id then
                local currentTime = os.time()
                local playerid = 0
                for k, v in pairs(tablefalanserver) do
                    if k > 0 then
                        if v.expireTime and currentTime > v.expireTime then
                            playerid = v.player
                            table.remove(tablefalanserver, k)
                            TriggerClientEvent('real-dispatch:ClearPlayersDispatch', -1, playerid)
                            TriggerClientEvent('real-dispatch:SendDispatchToUI', b.id, tablefalanserver, nil, nil, 'remove')
                            break
                        end
                    end
                end
            end
        end 
    end
end)