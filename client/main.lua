frameworkObject = false
boolean = false
tablefalan = {}

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
    boolean = true
    TriggerServerEvent('real-dispatch:Active', boolean)
    print(tablefalan)
    print(json.encode(tablefalan))
    SendNUIMessage({
        action = "OpenUI",
        dispatch = tablefalan
    })
    SetNuiFocus(true, true)
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

Citizen.CreateThread(function()
    while true do
        local sleep = 1000
        local Player = PlayerPedId()
        local checktime = 0
        local sended = false
        
        if IsPedArmed(Player, 4) then
            sleep = 5
            if IsPedShooting(Player) and checktime == 0 and not sended and not IsWeaponBlackListed(Player) then
                if Config.SuppressorControl and WeaponHasSuppressor(Player) then
                    return
                end
                
                local coords = GetEntityCoords(Player)
                local street = GetStreetNameAtCoord(table.unpack(coords))
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
                    vehiclestatus = 'On foot'
                    vehicleplate = 'None'
                    vehiclecolor = 'None'
                else
                    vehiclestatus = vehiclename
                    vehicleplate = GetVehicleNumberPlateText(vehicle)
                    vehiclecolor = GetVehicleColor(vehicle)
                end
                
                -- local Currenttimefunction = GetCurrentTime()
                -- local currenttime = Currenttimefunction.hours .. ":" .. Currenttimefunction.minutes
                
                sended = true
                checktime = 120000
                table.insert(tablefalan, {
                    crime = 'Shooting!',
                    time = '13:22',
                    info = {
                        location = street,
                        gender = gender,
                        weapon = weapon,
                        vehiclestatus = vehiclestatus,
                        palte = vehicleplate,
                        vehiclecolor = vehiclecolor,
                    },
                    claimed = false
                })
                print("ee geldi amk")
                AddDispatch(tablefalan)
            end
        end
        Citizen.Wait(sleep)
    end
end)

function GetCurrentTime()
    local currentTimeInSeconds = os.time()
    local hours = math.floor(currentTimeInSeconds / 3600) % 24
    local minutes = math.floor(currentTimeInSeconds / 60) % 60
    return {hours = hours, minutes = minutes}
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

RegisterNUICallback('CloseUI', function()
    boolean = false
    TriggerServerEvent('real-dispatch:Active', boolean)
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