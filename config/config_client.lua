function StartDispatchSystem()
    if Config.DrawText == 'qb-target' then
        for _,v in pairs(Config.DispatchSystemCoords) do
            exports['qb-target']:AddBoxZone("real-dispatch" .. _, vector3(v.Coords.x, v.Coords.y, v.Coords.z), 1.5, 1.5, {
                name = "real-dispatch" .. _,
                debugPoly = false,
                heading = -20,
                minZ = v.Coords.z - 2,
                maxZ = v.Coords.z + 2,
            }, {
                options = {
                    {
                        type = "client",
                        event = "real-dispatch:StartDispatchSystem",
                        icon = "fas fa-hand-point-up",
                        label = "Open Dispatch",
                        
                    },
                },
                distance = 8
            })
        end
    elseif Config.DrawText == 'drawtext' then
        Citizen.CreateThread(function()
            while true do
                local sleep = 2000
                local Player = PlayerPedId()
                local PlayerCoords = GetEntityCoords(Player)
    
                for k, v in pairs(Config.DispatchSystemCoords) do
                    local Distance = #(PlayerCoords - v.Coords)
                    if Distance < 1.5 then
                        sleep = 4
                        Config.DrawText3D("~INPUT_PICKUP~ - Open Dispatch", vector3(v.Coords.x, v.Coords.y, v.Coords.z))
                        if IsControlJustReleased(0, 38) then
                            TriggerServerEvent('real-dispatch:Active', true)
                            TriggerServerEvent('real-dispatch:GetDispatchDataFromServer')
                        end
                    end
                end
                Citizen.Wait(sleep)
            end
        end)
    end
end

Config.DrawText3D = function (msg, coords)
    AddTextEntry('esxFloatingHelpNotification', msg)
    SetFloatingHelpTextWorldPosition(1, coords)
    SetFloatingHelpTextStyle(1, 1, 2, -1, 3, 0)
    BeginTextCommandDisplayHelp('esxFloatingHelpNotification')
    EndTextCommandDisplayHelp(2, false, false, -1)
end