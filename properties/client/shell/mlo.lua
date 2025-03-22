function CreateMlo(property, data, useGarageDoor, isGarage)
    local shellData = isGarage == true and ShellData.garage[data.shell] or ShellData.apartment[data.shell]
    local garagePos = shellData.garageDoor
    local doorPos = shellData.door
    local vehicle = GetVehiclePedIsIn(PlayerData.PlayerPed(), false)

    Wait(500)

    ----------------------------------------

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

