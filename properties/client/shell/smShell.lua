local positionOffset = vec3(0, 0, -2)

function CreateSMShell(property, data, useGarageDoor, isGarage)

    local exteriorDoorCoords = SpawnGrid.GetPosition(data.gridIndex)

    --- Load mlo before spawning shell fixes graphic bugs--
    local mloLoadPoint = SpawnGrid.GetTempSpawnPoint()
    local spawnCoords = vec3(exteriorDoorCoords.x, exteriorDoorCoords.y, exteriorDoorCoords.z) + positionOffset
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

    local success, doorPos, garagePos = exports["smodsk_shellBuilder"]:SpawnShell(
    {
        id = data.shell,
        position = spawnCoords,
        doorPositionChanged = function(door, position)
          if door == "garage" then
            property.garage.door:SetPosition(position, false)
          elseif door == "door" then
            property.apartment.door:SetPosition(position, false)
          end
        end,
        -- By default false if not used
        canOpenMenu = function()
            return HasPermission(property.owner, property.permissions, "canOpenBuildMenu")
        end,
        -- By default false if not used
        canTogglePublic = function()
            return false
        end,
        -- By default false if not used
        canBuild = function()
            return HasPermission(property.owner, property.permissions, "canBuild")
        end,
        -- By default false if not used
        canPaint = function()
            return HasPermission(property.owner, property.permissions, "canPaint")
        end,
        -- By default true if not used
        canAddGarage = function()
            return isGarage
        end,
        -- By default true if not used
        canAddFrontDoor = function()
            return not isGarage
        end,
    })


    if success then
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


    return false
end

function DespawnSMShell() 
    exports["smodsk_shellBuilder"]:DespawnShell()
end

AddEventHandler("onResourceStop", function(resourceName)
    if GetCurrentResourceName() == resourceName then
        if GetResourceState("smodsk_shellBuilder") == "started" then
            exports["smodsk_shellBuilder"]:DespawnShell()
        end
    end
end)