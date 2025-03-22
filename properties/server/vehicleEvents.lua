function OnVehicleEnterGarage(vehicle)
    
end

function OnVehicleExitGarage(vehicle)
    
end


function SpawnVehicles(source, vehiclesData, propertyId, spawnPosition, callback)
    local spawnedVehicles = {}
    RequestDataFromClient(Evt.."SpawnVehicles", source, {
        vehicles = vehiclesData, 
        id = propertyId,
        spawnPosition = spawnPosition
    }, function(vehicles)
        if vehicles then
            for i=1,#vehicles do
                local vehicle = WaitUntillNet(vehicles[i])
                if vehicle and DoesEntityExist(vehicle) then

                    local plate = GetVehicleNumberPlateText(vehicle)
                    local vehicleData = Database.GetVehicleProperties(plate)

                    if vehicleData then
                        Entity(vehicle).state["setVehicleProperties"] = vehicleData.properties ~= nil and vehicleData.properties or nil
    
                    end

                    FreezeEntityPosition(vehicle, true)
                    table.insert(spawnedVehicles, vehicle)
                end
            end
        end

        callback(spawnedVehicles)
    end)
end



RegisterServerEvent("baseevents:enteredVehicle", function(vehicle, currentSeat, vehicleDisplayName, vehicleNetId)
    local source = source
    if currentSeat == -1 then
        local veh = WaitUntillNet(vehicleNetId)
        PlayerEnteredVehicle(source, veh)
    end
end)

RegisterServerEvent("baseevents:leftVehicle", function(vehicle, currentSeat, vehicleDisplayName, vehicleNetId)
    local source = source
    if currentSeat == -1 then
        local veh = WaitUntillNet(vehicleNetId)
        PlayerExitedVehicle(source, veh)
    end
end)

