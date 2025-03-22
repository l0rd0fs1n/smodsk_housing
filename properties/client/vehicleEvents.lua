RegisterNetEvent(Evt.."Ghost", function(netVeh)
    local vehicle = nil
    local ticks = 30
    while (not vehicle or not DoesEntityExist(vehicle)) and ticks > 0 do
        vehicle = NetworkGetEntityFromNetworkId(netVeh)
        ticks -= 1
        Wait(1)
    end
    if not vehicle then return end
    if DoesEntityExist(vehicle) then
        local started = GetGameTimer()
        local t = Config.ghostTime or 6000
        while GetGameTimer() - started < t do
            local vehicles = GetGamePool("CVehicle")
            for i = 1, #vehicles do
                if vehicles[i] ~= vehicle then
                    SetEntityNoCollisionEntity(vehicle, vehicles[i], true)
                    SetEntityNoCollisionEntity(vehicles[i], vehicle, true)
                end
            end
            Wait(1)
        end
    end
end)


RegisterNetEvent(Evt.."SpawnVehicles", function(data, serverEvent)
    local property = Properties[data.id]
    if property then
        -- Wait for the shell to be loaded
        while not property.shellLoaded do 
            Wait(1) 
        end
        
        local vehicles = {}
        for k, v in pairs(data.vehicles) do
            local coords = TableToVec(v.coords) + data.spawnPosition
            local rotation = TableToVec(v.rot)

            RequestModel(v.model)
            while not HasModelLoaded(v.model) do 
                Wait(1) 
            end

            local vehicle = CreateVehicle(v.model, coords.x, coords.y, coords.z, 0, true, true)
            SetVehicleNumberPlateText(vehicle, k)
            SetEntityRotation(vehicle, rotation.x, rotation.y, rotation.z, 2, false)

            local vehCoords = GetEntityCoords(vehicle)

            local startTime = GetGameTimer()
            while math.abs(coords.z - vehCoords.z) > 0.25 and GetGameTimer() - startTime < 9000 do
                SetEntityCoordsNoOffset(vehicle, coords.x, coords.y, coords.z, false, false, true)
                SetEntityRotation(vehicle, rotation.x, rotation.y, rotation.z, 2, false)
                vehCoords = GetEntityCoords(vehicle)
                Wait(1)
            end

            SetModelAsNoLongerNeeded(v.model)
            table.insert(vehicles, ForceToNet(vehicle))
        end
        
        TriggerServerEvent(serverEvent, vehicles)
    end
end)
