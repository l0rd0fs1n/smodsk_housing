function GetClosestPlayers(source, coords, range, onlySource)
    local closestPlayers = {}
    for k, v in pairs(GetPlayers()) do
        local otherSource = v
        if otherSource ~= source then
            local otherPed = GetPlayerPed(otherSource)
            local otherCoords = GetEntityCoords(otherPed)
            local distance = #(coords - otherCoords) -- Corrected variable name
            if distance < (range or 10.0) then
                if not onlySource then
                    table.insert(closestPlayers, GetPlayerData(otherSource))
                else
                    table.insert(closestPlayers, otherSource)
                end
            end
        end
    end
    return closestPlayers
end

RegisterServerEvent(Evt.."GetClosestPlayers", function()
    local source = source
    local mySource = tostring(source)
    local playerPed = GetPlayerPed(source)
    local coords = GetEntityCoords(playerPed)
    SendDataToClient("GetClosestPlayers", source, GetClosestPlayers(source, coords, 5.0))
end)