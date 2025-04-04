ShellOffsetCreator = {
    shell = nil,
    doorOffset = vec4(0, 0, 0, 0),
    offset = vec3(0, 0, .2)
}

function ShellOffsetCreator.Create(shellModel)

    ShellOffsetCreator.doorOffset = vec4(0, 0, 0, 0)
    ShellOffsetCreator.offset = vec3(0, 0, 2)

    if ShellOffsetCreator.shell then
        DeleteEntity(ShellOffsetCreator.shell)
    end
    
    local playerPed = PlayerData.PlayerPed()
    local spawnCoords = SpawnGrid.GetPosition(1)
    local realCoords = spawnCoords + ShellOffsetCreator.offset

    ShellOffsetCreator.shell = CreateProp(shellModel, realCoords, vec3(0, 0, 0))
    if ShellOffsetCreator.shell then 

        SetEntityCoordsNoOffset(ShellOffsetCreator.shell, realCoords.x, realCoords.y, realCoords.z, false, false, false)
        SetEntityHeading(ShellOffsetCreator.shell, 0.0)
        SetEntityAsMissionEntity(ShellOffsetCreator.shell, true, true)
        SetEntityCoords(playerPed, realCoords.x, realCoords.y, realCoords.z + 1.0, false, false, false, true)
        FreezeEntityPosition(ShellOffsetCreator.shell, true)

        InstructionalBtns.Setup({
            {Buttons.keys["ACCEPT"], GetLocale("ACCEPT")},
            {Buttons.keys["DOOR_OFFSET"], GetLocale("DOOR_OFFSET")},
            {Buttons.keys["Z_OFFSET_UP"], GetLocale("Z_OFFSET_UP")},
            {Buttons.keys["Z_OFFSET_DOWN"], GetLocale("Z_OFFSET_DOWN")},
        })
    


        while true do

            Buttons.Disable()
            InstructionalBtns.Draw()


            if IsDisabledControlJustReleased(0, Buttons.keys["DOOR_OFFSET"]) then
                ShellOffsetCreator.Offset()
                ShellOffsetCreator.PrintOffsets()
            end

            if IsDisabledControlJustReleased(0, Buttons.keys["Z_OFFSET_UP"]) then
                ShellOffsetCreator.offset = vec3(0, 0, ShellOffsetCreator.offset.z + .05)
                realCoords = spawnCoords + ShellOffsetCreator.offset
                SetEntityCoordsNoOffset(ShellOffsetCreator.shell, realCoords.x, realCoords.y, realCoords.z, false, false, false)
                ShellOffsetCreator.PrintOffsets()
            end

            if IsDisabledControlJustReleased(0, Buttons.keys["Z_OFFSET_DOWN"]) then
                ShellOffsetCreator.offset = vec3(0, 0, ShellOffsetCreator.offset.z - .05)
                realCoords = spawnCoords + ShellOffsetCreator.offset
                SetEntityCoordsNoOffset(ShellOffsetCreator.shell, realCoords.x, realCoords.y, realCoords.z, false, false, false)
                ShellOffsetCreator.PrintOffsets()
            end

            if IsDisabledControlJustReleased(0, Buttons.keys["ACCEPT"]) then
                ShellOffsetCreator.PrintOffsets()
                break
            end

            Wait(1)
        end
        
        if ShellOffsetCreator.shell then
            DeleteEntity(ShellOffsetCreator.shell)
        end
        InstructionalBtns.Remove()
    end
end

function ShellOffsetCreator.PrintOffsets()
    local doorOffset = ShellOffsetCreator.doorOffset
    local offset = ShellOffsetCreator.offset
    local message = string.format(
        "offset = Vec3(%.2f, %.2f, %.2f), \ndoor = Vec4(%.2f, %.2f, %.2f, %.2f),", 
        offset.x, offset.y, offset.z, 
        doorOffset.x, doorOffset.y, doorOffset.z, doorOffset.w
    )
    
    -- Print to console
    print("----------------------")
    print(message)
    
    -- Print to chat (FiveM example)
    TriggerEvent('chat:addMessage', {
        args = { "ShellOffsetCreator", message }
    })
end


function ShellOffsetCreator.Offset()
    local playerPed = PlayerData.PlayerPed()
    if ShellOffsetCreator.shell == nil then return end
    if not DoesEntityExist(ShellOffsetCreator.shell) then
        return
    end
    
    local shellCoords = GetEntityCoords(ShellOffsetCreator.shell)
    local playerCoords = PlayerData.Position()
    local heading = GetEntityHeading(playerPed)
    local offset = playerCoords - shellCoords
    ShellOffsetCreator.doorOffset = vec4(offset.x, offset.y, offset.z, heading)
end

AddEventHandler("onResourceStop", function(resourceName)
    if GetCurrentResourceName() == resourceName then
       if ShellOffsetCreator.shell then
            DeleteEntity(ShellOffsetCreator.shell)
       end
    end
end)

