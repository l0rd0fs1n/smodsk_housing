local shell = nil

function CreateShell(property, data, useGarageDoor, isGarage)

    local shellData = isGarage == true and ShellData.garage[data.shell] or ShellData.apartment[data.shell]
    local spawnCoords = SpawnGrid.GetPosition(data.gridIndex) + (shellData.offset or vec3(0, 0, 0))
    spawnCoords = vec4(spawnCoords.x, spawnCoords.y, spawnCoords.z, 0.0)
    local mloLoadPoint = SpawnGrid.GetTempSpawnPoint()

    local garagePos = shellData.garageDoor ~= nil and  shellData.garageDoor + spawnCoords or nil
    local doorPos = shellData.door ~= nil and shellData.door + spawnCoords or nil

    local vehicle = GetVehiclePedIsIn(PlayerData.PlayerPed(), false)

    if vehicle and vehicle ~= 0 then
        Teleport.PlayerAndVehicle(PlayerData.PlayerPed(), vehicle, mloLoadPoint)
        FreezeEntityPosition(vehicle, true)
    else
        Teleport.Player(PlayerData.PlayerPed(), mloLoadPoint)
        FreezeEntityPosition(PlayerData.PlayerPed(), true)
    end
    
    Config.shellMlo.Load()
    ----------------------------------------
    
    -- Wait some time so mlo is loaded before creating shell fixes shading problems
    Wait(500)

    shell = CreateProp(data.shell, spawnCoords, vec3(0, 0, 0))

    if shell then
        property.shellLoaded = true
        if garagePos then
            property.garage.door:SetPosition(garagePos, false)
        end
        if doorPos then
            property.apartment.door:SetPosition(doorPos, false)
        end

        if useGarageDoor then
            if not garagePos and vehicle ~= 0 then
                return false
            end
            if garagePos and vehicle ~= 0 then
                Teleport.PlayerAndVehicle(PlayerData.PlayerPed(), vehicle, garagePos)
                FreezeEntityPosition(vehicle, false)
                return true
            elseif garagePos and (not vehicle or vehicle == 0) then
                Teleport.Player(PlayerData.PlayerPed(), garagePos)
                return true
            end
        end

        if doorPos then
            Teleport.Player(PlayerData.PlayerPed(), doorPos)
            return true
        end

       

    end
end

function DespawnShell()
    if shell then 
        DeleteEntity(shell)
    end
end


AddEventHandler("onResourceStop", function(resourceName)
    if GetCurrentResourceName() == resourceName then
       if shell then
            DeleteEntity(shell)
       end
    end
end)