function StartDispatchSystem()
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
                    if playerinjobu == 'police' then
                        if IsControlJustReleased(0, 38) then
                            TriggerServerEvent('real-dispatch:Active', true)
                            TriggerServerEvent('real-dispatch:GetDispatchDataFromServer')
                        end
                    end
                end
            end
            Citizen.Wait(sleep)
        end
    end)
end

Config.DrawText3D = function (msg, coords)
    AddTextEntry('esxFloatingHelpNotification', msg)
    SetFloatingHelpTextWorldPosition(1, coords)
    SetFloatingHelpTextStyle(1, 1, 2, -1, 3, 0)
    BeginTextCommandDisplayHelp('esxFloatingHelpNotification')
    EndTextCommandDisplayHelp(2, false, false, -1)
end