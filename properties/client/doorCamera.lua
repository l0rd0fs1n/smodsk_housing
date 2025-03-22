--[[
A very simple doorbell cam.
Players should be able to talk to players outside since we teleport the player under the door position.
The server temporarily sets the player's routing bucket to 0 when the camera is activated.
]]

DoorbellCameraActive = false

function CreateDoorbellCamera(door)
    local player = PlayerData.PlayerPed()
    local orginalCoords = PlayerData.Position()

    DoScreenFadeOut(250)
    Wait(250)

    SetEntityCoords(player, 0, 0, 0, false, false, false, false)
    FreezeEntityPosition(player, true)

    local position = vec3(door.x, door.y, door.z)
    local heading = door.w 
    local camera = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    SetCamCoord(camera, position.x, position.y, position.z + 1.0)
    SetCamRot(camera, -20.0, 0.0, heading - 180, 2)
    SetCamActive(camera, true)
    SetFocusPosAndVel(position.x, position.y, position.z, 0.0, 0.0, 0.0)
    RenderScriptCams(true, false, 0, true, true)
    DoorbellCameraActive = true
    PlayerData.disabled = true
    Wait(250)
    DoScreenFadeIn(250)


    while true do
        if IsDisabledControlJustReleased(0, 194) then
            DoScreenFadeOut(250)
            Wait(250)

            SetCamActive(camera, false)
            RenderScriptCams(false, false, 0, false, false)
            DestroyCam(camera)
            ClearFocus()
            SetGameplayCamRelativeHeading(0)
            camera = nil
            DoorbellCameraActive = false
            SetEntityCoordsNoOffset(player, orginalCoords.x, orginalCoords.y, orginalCoords.z, false, false, false)
            TriggerServerEvent(Evt.."DisableDoorbellCam")
            PlayerData.disabled = false
            Wait(250)
            DoScreenFadeIn(250)
            Wait(1000)
            Config.shellMlo.Load()
            FreezeEntityPosition(player, false)
            return
        end
        Wait(1)
    end
end

        

RegisterNetEvent(Evt.."EnableDoorbellCam", function(door)
    CreateDoorbellCamera(door)
end)