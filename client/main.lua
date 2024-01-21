frameworkObject = false
boolean = false
dispatchreported = false
tablefalan = {}
reportedPlayers = {}
cansetgps = false
blipiste = {}
pointx = 0
pointy = 0
tableid = nil
playerindatasiamk = {}
playerinjobu = ""
Bekleamk = {shooting = 0}
loadedqb = false
loadedesx = false

Citizen.CreateThread(function()
    frameworkObject, Config.Framework = GetCore()
    while not frameworkObject do
        Citizen.Wait(0)
    end
    Citizen.Wait(1500)
    SendNUIMessage({
        action = 'setup',
        language = Config.Language,
        dispatchtype = Config.DispatchType
    })
    Citizen.Wait(1500)
    StartDispatchSystem()
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    loadedqb = true
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    loadedqb = false
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer, isNew, skin)
    loadedesx = true
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        if loadedqb then
            playerindatasiamk = frameworkObject.Functions.GetPlayerData()
            playerinjobu = playerindatasiamk.job.name
        elseif loadedesx then
            playerindatasiamk = frameworkObject.GetPlayerData()
            playerinjobu = playerindatasiamk.job.name
        end

        if Config.DispatchType == 'normal' then
            for k, v in pairs(Bekleamk) do
                if Bekleamk[k] > 0 then
                    Bekleamk[k] = Bekleamk[k] - 1
                end
            end
            for a, b in pairs(blipiste) do
                if b[2] > 0 then
                    b[2] = b[2] - 1
                elseif b[2] == 0 then
                    RemoveBlip(b[1])
                    table.remove(blipiste, a)
                end
            end
        end
    end
end)

if Config.DispatchType == 'advanced' then
    RegisterNetEvent('real-dispatch:StartDispatchSystem', function()
        TriggerServerEvent('real-dispatch:Active', true)
        TriggerServerEvent('real-dispatch:GetDispatchDataFromServer')
    end)

    RegisterNetEvent('real-dispatch:Polices', function(data)
        SendNUIMessage({
            action = "UpdateLoc",
            data = data
        })
    end)
    
    function AddDispatch(table, coordsx, coordsy)
        TriggerServerEvent('real-dispatch:AddDispatchToServer', table, coordsx, coordsy)
    end
    
    RegisterNetEvent('real-dispatch:SendDispatchToUI', function(data, coordsx, coordsy, type)
        SendNUIMessage({
            action = 'AddDispatch',
            data = data,
            coordsx = coordsx,
            coordsy = coordsy,
            type = type
        })
    end)
    
    RegisterNetEvent('real-dispatch:OpenUI', function(table)
        SendNUIMessage({
            action = "OpenUI",
            dispatch = table,
        })
        SetNuiFocus(true, true)
    end)
    
    RegisterNetEvent('real-dispatch:ClearPlayersDispatch', function(id)
        reportedPlayers[id] = false
    end)
    
    RegisterNetEvent('real-dispatch:ChangeTable', function(data)
        tablefalan = data
    end)
    
    RegisterNetEvent('real-disapatch:Client:SendDispatchToTargetPlayer', function(data)
        SendNUIMessage({
            action = "SendDispatch",
            data = data
        })
        cansetgps = true
        pointx = data.coords.x
        pointy = data.coords.y
    end)
    
    Citizen.CreateThread(function()
        while true do
            local sleep = 500
            local Player = PlayerPedId()
    
            if playerinjobu ~= 'police' then
                if IsPedArmed(Player, 4) then
                    sleep = 5
                    if IsPedShooting(Player) and not IsWeaponBlackListed(Player) then
                        if Config.SuppressorControl and WeaponHasSuppressor(Player) then
                            return
                        end
        
                        local coords = GetEntityCoords(Player)
                        local streethash = GetStreetNameAtCoord(table.unpack(coords))
                        local street = GetStreetNameFromHashKey(streethash)
                        local weaponhash = GetSelectedPedWeapon(Player)
                        local weapon = Weapons[weaponhash].label
                        local vehicle = GetVehiclePedIsIn(Player, 0)
                        local vehiclename = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
                        local playeridfalanisteamksananeorospu = GetPlayerServerId(PlayerId())
                        local vehiclecolor
                        local vehiclestatus
                        local vehicleplate
                        local gender
        
                        if Config.Framework == 'newqb' or Config.Framework == 'oldqb' then
                            local Player = frameworkObject.Functions.GetPlayerData()
                            if Player.charinfo.gender == 1 then
                                gender = Config.Language['female']
                            else
                                gender = Config.Language['male']
                            end
                        else
                            if PlayerData.esx == 1 then
                                gender = Config.Language['female']
                            else
                                gender = Config.Language['male']
                            end
                        end
        
                        if IsPedInAnyVehicle(Player, 0) then
                            vehiclestatus = vehiclename
                            vehicleplate = GetVehicleNumberPlateText(vehicle)
                            vehiclecolor = GetVehicleColorName(vehicle)
                        else
                            vehiclestatus = Config.Language['onfoot']
                            vehicleplate = Config.Language['none']
                            vehiclecolor = Config.Language['none']
                        end
        
                        if not reportedPlayers[playeridfalanisteamksananeorospu] then
                            table.insert(tablefalan, {
                                player = playeridfalanisteamksananeorospu,
                                crime = Config.Language['shooting'],
                                time = '',
                                info = {
                                    location = street,
                                    gender = gender,
                                    weapon = weapon,
                                    vehiclestatus = vehiclestatus,
                                    plate = vehicleplate,
                                    vehiclecolor = vehiclecolor,
                                },
                                claimed = false,
                                expireTime = 0,
                                coords = coords
                            })
                            AddDispatch(tablefalan, coords.x, coords.y)
                            reportedPlayers[playeridfalanisteamksananeorospu] = true
                        else
                            for k, v in pairs(tablefalan) do
                                if v.player == playeridfalanisteamksananeorospu then
                                    if v.info.location ~= street or v.info.weapon ~= weapon or v.info.vehiclestatus ~= vehiclestatus or v.info.plate ~= vehicleplate or v.info.vehiclecolor ~= vehiclecolor then
                                        table.remove(tablefalan, k)
                                        table.insert(tablefalan, {
                                            player = playeridfalanisteamksananeorospu,
                                            crime = Config.Language['shooting'],
                                            time = '',
                                            info = {
                                                location = street,
                                                gender = gender,
                                                weapon = weapon,
                                                vehiclestatus = vehiclestatus,
                                                plate = vehicleplate,
                                                vehiclecolor = vehiclecolor,
                                            },
                                            claimed = false,
                                            expireTime = 0,
                                            coords = coords
                                        })
                                        break
                                    end
                                end
                            end
                            AddDispatch(tablefalan, coords.x, coords.y)
                            reportedPlayers[playeridfalanisteamksananeorospu] = true
                        end
                    end
                end
            end
            Citizen.Wait(sleep)
        end
    end)
    
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
            if cansetgps then
                if IsControlJustReleased(0, Config.SetGPSKey) then
                    SetWaypointOff() 
                    SetNewWaypoint(pointx, pointy)
                    SendNUIMessage({
                        action = 'RemoveDispatch'
                    })
                    cansetgps = false
                end
            end
        end
    end)
    
    RegisterNUICallback('SendDispatchToTargetPlayer', function(data, cb)
        TriggerServerEvent('real-dispatch:Server:SendDispatchToTargetPlayer', data)
    end)
    
    RegisterNUICallback('CloseUI', function()
        TriggerServerEvent('real-dispatch:Active', false)
        SetNuiFocus(false, false)
    end)

    exports('AddDispatch', function(crime, street, gender, weapon, vehiclestatus, vehicleplate, vehiclecolor, coords)
        local playeridfalanisteamksananeorospu = GetPlayerServerId(PlayerId())
        if not reportedPlayers[playeridfalanisteamksananeorospu] then
            table.insert(tablefalan, {
                player = playeridfalanisteamksananeorospu,
                crime = crime,
                time = '',
                info = {
                    location = street,
                    gender = gender,
                    weapon = weapon,
                    vehiclestatus = vehiclestatus,
                    plate = vehicleplate,
                    vehiclecolor = vehiclecolor,
                },
                claimed = false,
                expireTime = 0,
                coords = coords
            })
            AddDispatch(tablefalan, coords.x, coords.y)
            reportedPlayers[playeridfalanisteamksananeorospu] = true
        else
            for k, v in pairs(tablefalan) do
                if v.player == playeridfalanisteamksananeorospu then
                    if v.info.location ~= street or v.info.weapon ~= weapon or v.info.vehiclestatus ~= vehiclestatus or v.info.plate ~= vehicleplate or v.info.vehiclecolor ~= vehiclecolor then
                        table.remove(tablefalan, k)
                        table.insert(tablefalan, {
                            player = playeridfalanisteamksananeorospu,
                            crime = crime,
                            time = '',
                            info = {
                                location = street,
                                gender = gender,
                                weapon = weapon,
                                vehiclestatus = vehiclestatus,
                                plate = vehicleplate,
                                vehiclecolor = vehiclecolor,
                            },
                            claimed = false,
                            expireTime = 0,
                            coords = coords
                        })
                        break
                    end
                end
            end
            AddDispatch(tablefalan, coords.x, coords.y)
            reportedPlayers[playeridfalanisteamksananeorospu] = true
        end
    end)
elseif Config.DispatchType == 'normal' then
    Citizen.CreateThread(function()
        while true do
            local sleep = 500
            local Player = PlayerPedId()

            if playerinjobu ~= 'police' then
                if IsPedArmed(Player, 4) then
                    sleep = 5
                    if IsPedShooting(Player) and Bekleamk.shooting == 0 and not IsWeaponBlackListed(Player) then
                        if Config.SuppressorControl and WeaponHasSuppressor(Player) then
                            return
                        end
        
                        local coords = GetEntityCoords(Player)
                        local streethash = GetStreetNameAtCoord(table.unpack(coords))
                        local street = GetStreetNameFromHashKey(streethash)
                        local weaponhash = GetSelectedPedWeapon(Player)
                        local weapon = Weapons[weaponhash].label
                        local vehicle = GetVehiclePedIsIn(Player, 0)
                        local vehiclename = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
                        local playeridfalanisteamksananeorospu = GetPlayerServerId(PlayerId())
                        local vehiclecolor
                        local vehiclestatus
                        local vehicleplate
                        local gender

                        if Config.Framework == 'newqb' or Config.Framework == 'oldqb' then
                            local Player = frameworkObject.Functions.GetPlayerData()
                            if Player.charinfo.gender == 1 then
                                gender = Config.Language['female']
                            else
                                gender = Config.Language['male']
                            end
                        else
                            if PlayerData.esx == 1 then
                                gender = Config.Language['female']
                            else
                                gender = Config.Language['male']
                            end
                        end
        
                        if IsPedInAnyVehicle(Player, 0) then
                            vehiclestatus = vehiclename
                            vehicleplate = GetVehicleNumberPlateText(vehicle)
                            vehiclecolor = GetVehicleColorName(vehicle)
                        else
                            vehiclestatus = Config.Language['onfoot']
                            vehicleplate = Config.Language['none']
                            vehiclecolor = Config.Language['none']
                        end

                        table.insert(tablefalan, {
                            player = playeridfalanisteamksananeorospu,
                            crime = Config.Language['shooting'],
                            time = '',
                            info = {
                                location = street,
                                gender = gender,
                                weapon = weapon,
                                vehiclestatus = vehiclestatus,
                                plate = vehicleplate,
                                vehiclecolor = vehiclecolor,
                            },
                            coords = coords
                        })

                        AddNormalDispatch(tablefalan, coords, {'police'})
                        Bekleamk.shooting = Config.Cooldown.Shooting
                    end
                end
            end
            Citizen.Wait(sleep)
        end
    end)

    function AddNormalDispatch(table, coords, job)
        TriggerServerEvent('real-dispatch:SendNormalDispatch', table, coords, job)
    end

    RegisterNetEvent('real-dispatch:SendNormalDispatchToClient', function(table, coords)
        SendNUIMessage({
            action = "SendNormalDispatch",
            data = table
        })
        cansetgps = true
        pointx = coords.x
        pointy = coords.y
    end)

    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
            if cansetgps then
                if IsControlJustReleased(0, Config.SetGPSKey) then
                    SetWaypointOff() 
                    SetNewWaypoint(pointx, pointy)
                    cansetgps = false
                end
            end
        end
    end)

    RegisterNUICallback('RmoveTableNormalDispatch', function()
        TriggerServerEvent('real-dispatch:RemoveNormalDispatchTable')
    end)

    RegisterNetEvent('real-dispatch:Client:RmoveNormalDispatchTable', function()
        tablefalan = {}
    end)

    function CreateBlip(x, y, z, sprite, color, text, size)
        local size = size or 1.0
        local blip = AddBlipForCoord(x, y, z)
        SetBlipSprite(blip, sprite)
        SetBlipDisplay(blip, 6)
        SetBlipScale(blip, size)
        SetBlipColour(blip, color)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(text)
        EndTextCommandSetBlipName(blip)

        return blip
    end

    RegisterNetEvent('real-dispatch:AddBlipToMap', function(coords)
        table.insert(blipiste, {
            CreateBlip(coords.x, coords.y, coords.z, Config.BlipSettings.Sprite, Config.BlipSettings.Color, Config.BlipSettings.Name, Config.BlipSettings.Size),
            Config.BlipRemoveTime
        })
    end)

    exports('AddNormalDispatch', function(player, crime, street, gender, weapon, vehiclestatus, vehicleplate, vehiclecolor, coords, job)
        if Bekleamk.shooting == 0 then
            table.insert(tablefalan, {
                player = player,
                crime = crime,
                time = '',
                info = {
                    location = street,
                    gender = gender,
                    weapon = weapon,
                    vehiclestatus = vehiclestatus,
                    plate = vehicleplate,
                    vehiclecolor = vehiclecolor,
                },
                coords = coords
            })
            if not job then
                job = {'police'}
            end
            AddNormalDispatch(tablefalan, coords, job)
            Bekleamk.shooting = Config.Cooldown.Shooting
        end
    end)
end

function IsWeaponBlackListed(Player)
    for k, v in pairs(Config.BlackListedWeapons) do
        local weapon = GetHashKey(Config.BlackListedWeapons[k])
        if GetSelectedPedWeapon(Player) == weapon then
            return true
        end
    end
    Citizen.Wait(10)
    return false
end

function WeaponHasSuppressor(Player)
    for k, v in pairs(Config.SupressorModels) do
        if HasPedGotWeaponComponent(Player, GetSelectedPedWeapon(Player, v)) then
            return true
        end
    end
    Citizen.Wait(10)
    return false
end

function GetVehicleColorName(vehicle)
    local vehicleColor1, vehicleColor2 = GetVehicleColor(vehicle)
    local color1 = Config.Colors[tostring(vehicleColor1)]
    local color2 = Config.Colors[tostring(vehicleColor2)]

    if color1 then
        return color1
    elseif color2 then
        return color2
    else
        return Config.Language['unknown']
    end
end