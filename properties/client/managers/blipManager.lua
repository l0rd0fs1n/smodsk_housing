BlipManager = {}
BlipManager.Blips = {}

function BlipManager.Add(id, coords, street)
    local settings = Config.blip or {}
    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip, settings.sprite or 1)
    SetBlipColour(blip, settings.color or 1)
    SetBlipScale(blip, settings.scale or 1.0)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(settings.text or street)
    EndTextCommandSetBlipName(blip)
    BlipManager.Blips[id] = blip
    return blip
end

function BlipManager.Remove(id)
    if BlipManager.Blips[id] then
        RemoveBlip(BlipManager.Blips[id])
        BlipManager.Blips[id] = nil
    end
end
