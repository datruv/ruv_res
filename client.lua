Citizen.CreateThread(function()
    while true do
        local pos = GetEntityCoords(GetPlayerPed(-1))
        local playerPos = GetEntityCoords(GetPlayerPed(-1), true)

        for _, beacon in ipairs(Config.Beacon) do
            local x, y, z = table.unpack(beacon)

            if (IsControlJustPressed(1, 38)) then
                if (GetDistanceBetweenCoords(x, y, z, pos.x, pos.y, pos.z, true) < 2.5) then
                    TriggerServerEvent("datruv:giveItem")
                end
            end

            if (GetDistanceBetweenCoords(x, y, z, pos.x, pos.y, pos.z, true) < 20) then
                DrawMarker(1, x, y, z - 1, 0, 0, 0, 0, 0, 0, 2.5, 2.5, 0.3, 143, 138, 255, 150, 0, 0, 0, 0)
            end

            if (Vdist(playerPos.x, playerPos.y, playerPos.z, x, y, z) < 1.5) then
                DisplayHelpText("~INPUT_CONTEXT~ 키를 눌러 사전예약 보상 받기")
            end
        end

        Citizen.Wait(0)
    end
end)

function DisplayHelpText(text)
    SetTextComponentFormat("STRING")
    AddTextComponentString(text)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end
