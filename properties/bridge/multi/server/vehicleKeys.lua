VehicleKeys = {}


function VehicleKeys.GiveKeys(source, vehicles)
    if not vehicles then return end
    for vehicle,v in pairs(vehicles) do 
        if DoesEntityExist(vehicle) then
            if GetResourceState("qbx_vehiclekeys") == "started" then
                exports["qbx_vehiclekeys"]:GiveKeys(source, vehicle)
            elseif GetResourceState("qb-vehiclekeys") == "started" then
                exports["qb-vehiclekeys"]:GiveKeys(source, GetVehicleNumberPlateText(vehicle))
            end
        end
    end
end




function VehicleKeys.RemoveKeys(source, vehicles)
    if not vehicles then return end
    for vehicle,v in pairs(vehicles) do 
        if GetResourceState("qbx_vehiclekeys") == "started" then
            exports["qbx_vehiclekeys"]:RemoveKeys(source, vehicle)
        elseif GetResourceState("qb-vehiclekeys") == "started" then
            exports["qb-vehiclekeys"]:RemoveKeys(source, GetVehicleNumberPlateText(vehicle)) 
        end
    end
end