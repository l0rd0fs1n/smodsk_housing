Teleport = {}

function Teleport.Player(playerPed, position)
    FreezeEntityPosition(playerPed, false)
    SetEntityCoords(playerPed, position.x, position.y, position.z, false, false, false, false)
    SetEntityHeading(playerPed, position.w)
end

function Teleport.PlayerAndVehicle(playerPed, vehicle, position)
    FreezeEntityPosition(playerPed, false)
    SetEntityCoords(vehicle, position.x, position.y, position.z, false, false, false, false)

    -- Countered bug where vehicle did not teleport while player did?
    -- This should fix it mby? (Does not if we for some reason loose ownership)...
    local t = GetGameTimer()
    while true do
        SetEntityCoords(vehicle, position.x, position.y, position.z, false, false, false, false)
        local vehicleCoords = GetEntityCoords(vehicle)
        if #(vehicleCoords - vec3(position.x, position.y, position.z)) < 2 then break end
        if GetGameTimer() - t > 3000 then break end
        Wait(100)
    end

    SetEntityHeading(vehicle, position.w)
    TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
end