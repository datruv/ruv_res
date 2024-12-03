local Proxy = module("vrp", "lib/Proxy")
local Tunnel = module("vrp", "lib/Tunnel")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP", GetCurrentResourceName())

RegisterServerEvent("datruv:giveItem")
AddEventHandler("datruv:giveItem", function()
    local source = source
    local user_id = vRP.getUserId({source})
    if user_id == nil then return end

    local identifier = GetPlayerIdentifiers(source)[1]
    local discord_id = nil

    for _, id in ipairs(GetPlayerIdentifiers(source)) do
        if string.match(id, "discord:") then
            discord_id = string.gsub(id, "discord:", "")
            break
        end
    end

    if discord_id == nil then
        vRPclient.notify(source, {"디스코드 연동이 필요합니다."})
        return
    end

    exports.oxmysql:fetch('SELECT * FROM datruv_data WHERE discord_id = ?', {discord_id}, function(result)
        if #result > 0 then
            local status = result[1].status

            if status == 1 then
                vRPclient.notify(source, {"이미 아이템을 받았습니다."})
                return
            end

            exports.oxmysql:fetch('SELECT * FROM vrp_user_ids WHERE identifier = ?', {'discord:' .. discord_id}, function(user_result)
                if #user_result > 0 then
                    -- vRP.giveInventoryItem({user_id, "water", 1, true})
                    vRP.giveInventoryItem({user_id, Config.Item, Config.Amount, Config.Alert})
                    vRPclient.notify(source, {"아이템이 지급되었습니다."})

                    exports.oxmysql:execute('UPDATE datruv_data SET status = 1 WHERE discord_id = ?', {discord_id})
                else
                    vRPclient.notify(source, {"사전예약에 참여를 안하셨습니다!"})
                end
            end)
        else
            vRPclient.notify(source, {"사전예약에 참여를 안하셨습니다!"})
        end
    end)
end)
