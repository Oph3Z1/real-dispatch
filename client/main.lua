frameworkObject = false
boolean = false

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
    SendNUIMessage({
        action = "OpenUI",
    })
    SetNuiFocus(true, true)
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