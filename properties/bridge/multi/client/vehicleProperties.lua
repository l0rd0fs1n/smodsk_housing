function SetVehicleProperties(vehicle, value, callback)
    if lib then
        if lib.setVehicleProperties(vehicle, value) then
            callback(true)
            return
        end
    elseif QBCore then
        if NetworkGetEntityOwner(vehicle) == PlayerId() then
            QBCore.Functions.SetVehicleProperties(vehicle, value)
            callback(true)
            return
        end
    end
    callback(false)
end

AddStateBagChangeHandler("setVehicleProperties", nil, function(bagName, key, value, _unused, replicated)
    local vehicle = GetEntityFromStateBagName(bagName)
    local netId = NetworkGetNetworkIdFromEntity(vehicle)
    local ticks = 30

    while not (netId == nil or netId == 0) and ticks > 0 do
        netId = NetworkGetNetworkIdFromEntity(vehicle)
        ticks = ticks - 1
        Wait(1)
    end

    if value then
        SetVehicleProperties(vehicle, value, function(success)
            Entity(vehicle).state:set('setVehicleProperties', nil, true)
        end)  
    end
end)
