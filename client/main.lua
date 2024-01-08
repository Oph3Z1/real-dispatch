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
    if boolean then
        SendNUIMessage({
            action = "UpdateLoc",
            data = data
        })
    end
end)

RegisterCommand('opend', function()
    TriggerServerEvent('real-dispatch:Active', true)
    TriggerServerEvent('real-dispatch:GetDispatchDataFromServer')
end)

function AddDispatch(table)
    TriggerServerEvent('real-dispatch:AddDispatchToServer', table)
end

RegisterNetEvent('real-dispatch:SendDispatchToUI', function(data)
    SendNUIMessage({
        action = 'AddDispatch',
        data = data
    })
end)

RegisterNetEvent('real-dispatch:OpenUI', function(table)
    SendNUIMessage({
        action = "OpenUI",
        dispatch = table,
    })
    SetNuiFocus(true, true)
end)

Citizen.CreateThread(function()
    while true do
        local sleep = 500
        local player = PlayerId()
        local Player = GetPlayerPed(-1)
        local checktime = 0
        local sended = false

        if IsPedArmed(Player, 4) then
            sleep = 5
            if IsPedShooting(Player) and checktime == 0 and not sended and not IsWeaponBlackListed(Player) then
                if Config.SuppressorControl and WeaponHasSuppressor(Player) then
                    return
                end

                if not reportedPlayers[player] then
                    local coords = GetEntityCoords(Player)
                    local streethash = GetStreetNameAtCoord(table.unpack(coords))
                    local street = GetStreetNameFromHashKey(streethash)
                    local weaponhash = GetSelectedPedWeapon(Player)
                    local weapon = Weapons[weaponhash].label
                    local vehicle = GetVehiclePedIsIn(Player, 0)
                    local vehiclename = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
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
                        vehiclecolor = GetVehicleColor(vehicle)
                    else
                        vehiclestatus = 'On foot'
                        vehicleplate = 'None'
                        vehiclecolor = 'None'
                    end

                    sended = true
                    checktime = 120000
                    table.insert(tablefalan, {
                        player = player,
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
                        claimed = false
                    })
                    AddDispatch(tablefalan)
                    reportedPlayers[player] = true
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