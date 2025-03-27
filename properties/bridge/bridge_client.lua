function Bridge.Notification(...)
    if lib then
        return Bridge.ox.Notification(...)
    elseif QBCore then
        return Bridge.qb.Notification(...)
    end
end

function Bridge.ConfirmDialog(...)
    if lib then
        return Bridge.ox.ConfirmDialog(...)
    elseif QBCore then
        return Bridge.qb.ConfirmDialog(...)
    end
end

function Bridge.Progressbar(...)
    if lib then
        return Bridge.ox.Progressbar(...)
    elseif QBCore then
        return Bridge.qb.Progressbar(...)
    end
end

function Bridge.AddGlobalOption(...)
    if ox_target then
        return Bridge.ox.AddGlobalOption(...)
    elseif qb_target then
        return Bridge.qb.AddGlobalOption(...)
    end
end

function Bridge.RegisterTargetBox(...)
    if ox_target then
        return Bridge.ox.RegisterTargetBox(...)
    elseif qb_target then
        return Bridge.qb.RegisterTargetBox(...)
    end
end

function Bridge.RemoveTargetBox(...)
    if ox_target then
        return Bridge.ox.RemoveTargetBox(...)
    elseif qb_target then
        return Bridge.qb.RemoveTargetBox(...)
    end
end

function Bridge.BuildingMenu(...)
    if lib then
        return Bridge.ox.BuildingMenu(...)
    elseif QBCore then
        return Bridge.qb.BuildingMenu(...)
    end
end

function Bridge.DoorMenu(...)
    if ox_target then
        return Bridge.ox.DoorMenu(...)
    elseif qb_target then
        return Bridge.qb.DoorMenu(...)
    end
end

function Bridge.BuildingApartmentMenu(...)
    if lib then
        return Bridge.ox.BuildingApartmentMenu(...)
    elseif QBCore then
        return Bridge.qb.BuildingApartmentMenu(...)
    end
end

function Bridge.PermissionMenu(...)
    if lib then
        return Bridge.ox.PermissionMenu(...)
    elseif QBCore then
        return Bridge.qb.PermissionMenu(...)
    end
end

function Bridge.OpenPropertyMenu(...)
    if lib then
        return Bridge.ox.OpenPropertyMenu(...)
    elseif QBCore then
        return Bridge.qb.OpenPropertyMenu(...)
    end
end