local tempPed

function DoorCreator(coords)
    local coords = coords or vec4(0, 0, 0, 0)

    local model = GetHashKey("a_m_m_bevhills_02")
    RequestModel(model)
    while not HasModelLoaded(model) do Wait(1) end


    tempPed = CreatePed(1, model, coords.x, coords.y, coords.z, coords.w, false, true)
    SetEntityAsMissionEntity(tempPed, true, true)
    SetEntityAlpha(tempPed, 180, false)
    SetPedFleeAttributes(tempPed, 0, false) 
    SetPedCombatAttributes(tempPed, 46, true)
    SetBlockingOfNonTemporaryEvents(tempPed, true)
    FreezeEntityPosition(tempPed, true)
    SetEntityInvincible(tempPed, true)
    SetPedCanRagdoll(tempPed, false)
    SetModelAsNoLongerNeeded(model)

    SetEntityCoords(tempPed,  coords.x ,coords.y, coords.z, false, false, false, false)
    SetEntityCoordsNoOffset(tempPed, coords.x ,coords.y, coords.z, false, false, false)
    SetEntityHeading(tempPed, coords.w)

    InstructionalBtns.Setup({
        {Buttons.keys["ACCEPT"], GetLocale("ACCEPT")},
        {Buttons.keys["SET_DOOR"], GetLocale("SET_DOOR")},
    })

    while true do
        
        InstructionalBtns.Draw()
        Buttons.Disable()

        if IsDisabledControlJustReleased(0, Buttons.keys["SET_DOOR"]) then
            local pos = PlayerData.Position()
            local heading = GetEntityHeading(PlayerPedId())
            coords = vec4(pos.x, pos.y, pos.z, heading)
            SetEntityCoords(tempPed,  coords.x ,coords.y, coords.z, false, false, false, false)
            SetEntityCoordsNoOffset(tempPed, coords.x ,coords.y, coords.z, false, false, false)
            SetEntityHeading(tempPed, coords.w)
            SetEntityCollision(tempPed, false, true)
        end

        if IsDisabledControlJustReleased(0, Buttons.keys["ACCEPT"]) then
            break
        end

        Wait(1)
    end

    InstructionalBtns.Remove()
    if tempPed then DeleteEntity(tempPed) end
    return coords == vec4(0, 0, 0, 0) and nil or coords
end

AddEventHandler("onResourceStop", function(resourceName)
    if (resourceName == GetCurrentResourceName()) then
        if tempPed then DeleteEntity(tempPed) end
    end
end)