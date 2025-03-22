function CanInteract(ignoreVehicle)
    -- Here we should check if inventory etc...
    local player = PlayerData.PlayerPed()
    if PlayerData.disabled then return false end
    if not ignoreVehicle and IsPedInAnyVehicle(player, true) then return false end
    if IsPedDeadOrDying(player, true) then return false end
    if LocalPlayer.state.invOpen then return false end
    if exports["prop_selector"]:IsOpen() then return false end
    return true
end


function HasPermission(owner, permissions, permission)
    if owner == PlayerData.job.name then return true end
    if owner == PlayerData.identifier then return true end
    local permissionLevel = (permissions[PlayerData.identifier] and permissions[PlayerData.identifier].level) or "guest"
    return Config.permissionLevels[permissionLevel][permission]
end

function CanEnter(owner, permissions)
    if owner == PlayerData.job.name then return true end
    if owner == PlayerData.identifier then return true end
    if permissions[PlayerData.identifier] then return true end
    return false
end


function CanBreakIn(owner, permissions)
    return PlayerData.job.name == "police"
end


