frameworkObject = false
boolean = false
dispatchreported = false
tablefalan = {}
reportedPlayers = {}

Citizen.CreateThread(function()
    frameworkObject, Config.Framework = GetCore()
    while not frameworkObject do
        Citizen.Wait(0)
    end
end)

RegisterNetEvent('real-dispatch:Polices', function(data)
    SendNUIMessage({
        action = "UpdateLoc",
        data = data
    })
end)

RegisterCommand('opend', function()
    TriggerServerEvent('real-dispatch:Active', true)
    TriggerServerEvent('real-dispatch:GetDispatchDataFromServer')
end)

function AddDispatch(table, coordsx, coordsy)
    TriggerServerEvent('real-dispatch:AddDispatchToServer', table, coordsx, coordsy)
end

RegisterNetEvent('real-dispatch:SendDispatchToUI', function(data, coordsx, coordsy)
    tablefalan = data
    SendNUIMessage({
        action = 'AddDispatch',
        data = data,
        coordsx = coordsx,
        coordsy = coordsy
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

Citizen.CreateThread(function()
    while true do
        local sleep = 500
        local Player = PlayerPedId()

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
                        gender = 'Female'
                    else
                        gender = 'Male'
                    end
                else
                    if PlayerData.esx == 1 then
                        gender = 'Female'
                    else
                        gender = 'Male'
                    end
                end

                if IsPedInAnyVehicle(Player, 0) then
                    vehiclestatus = vehiclename
                    vehicleplate = GetVehicleNumberPlateText(vehicle)
                    vehiclecolor = GetVehicleColorName(vehicle)
                else
                    vehiclestatus = 'On foot'
                    vehicleplate = 'None'
                    vehiclecolor = 'None'
                end

                if not reportedPlayers[playeridfalanisteamksananeorospu] then
                    table.insert(tablefalan, {
                        player = playeridfalanisteamksananeorospu,
                        crime = 'Shooting!',
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
                                    crime = 'Shooting!',
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
        Citizen.Wait(sleep)
    end
end)

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
        return "Unknown"
    end
end

RegisterNUICallback('CloseUI', function()
    TriggerServerEvent('real-dispatch:Active', false)
    SetNuiFocus(false, false)
end)

function Callback(name, payload)
    if Config.Framework == "newesx" or Config.Framework == "oldesx" then
        local data = nil
        if frameworkObject then
            frameworkObject.TriggerServerCallback(name, function(returndata)
                data = returndata
            end, payload)
            while data == nil do
                Citizen.Wait(0)
            end
        end
        return data
    else
        local data = nil
        if frameworkObject then
            frameworkObject.Functions.TriggerCallback(name, function(returndata)
                data = returndata
            end, payload)
            while data == nil do
                Citizen.Wait(0)
            end
        end
        return data
    end
end