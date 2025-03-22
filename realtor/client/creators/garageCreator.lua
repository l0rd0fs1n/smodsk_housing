local tempVehicle

function GarageCreator(coords)
    local coords = coords or vec4(0, 0, 0, 0)

    local model = GetHashKey("burrito3")
    RequestModel(model)
    while not HasModelLoaded(model) do Wait(1) end
    tempVehicle = CreateVehicle(model, coords.x, coords.y, coords.z, coords.w, false, false)
    SetEntityAsMissionEntity(tempVehicle, true, true)
    SetEntityCompletelyDisableCollision(tempVehicle, false, false)
    SetEntityAlpha(tempVehicle, 180, false)
    FreezeEntityPosition(tempVehicle, true)
    
    InstructionalBtns.Setup({
        {Buttons.keys["ACCEPT"], GetLocale("ACCEPT")},
        {Buttons.keys["SET_DOOR"], GetLocale("SET_GARAGE")},
    })

    while true do
        
        Buttons.Disable()
        InstructionalBtns.Draw()

        if IsDisabledControlJustReleased(0, Buttons.keys["SET_DOOR"]) then
            local pos = PlayerData.Position()
            local heading = GetEntityHeading(PlayerPedId())
            coords = vec4(pos.x, pos.y, pos.z, heading)
            SetEntityCoordsNoOffset(tempVehicle, coords.x ,coords.y, coords.z, false, false, false)
            SetEntityHeading(tempVehicle, coords.w)
        end


        if IsDisabledControlJustReleased(0, Buttons.keys["ACCEPT"]) then
            break
        end

        
        Wait(1)
    end

    InstructionalBtns.Remove()
    if tempVehicle then DeleteEntity(tempVehicle) end
    return coords == vec4(0, 0, 0, 0) and nil or coords
end

AddEventHandler("onResourceStop", function(resourceName)
    if (resourceName == GetCurrentResourceName()) then
        if tempVehicle then DeleteEntity(tempVehicle) end
    end
end)