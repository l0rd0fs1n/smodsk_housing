function Bridge.Notification(...)
    if lib then
        return Bridge.ox.Notification(...)
    end
end

function Bridge.ConfirmDialog(...)
    if lib then
        return Bridge.ox.ConfirmDialog(...)
    end
end

function Bridge.Progressbar(...)
    if lib then
        return Bridge.ox.Progressbar(...)
    end
end

function Bridge.AddGlobalOption(...)
    if ox_target then
        return Bridge.ox.AddGlobalOption(...)
    end
end

function Bridge.RegisterTargetBox(...)
    if ox_target then
        return Bridge.ox.RegisterTargetBox(...)
    end
end

function Bridge.RemoveTargetBox(...)
    if ox_target then
        return Bridge.ox.RemoveTargetBox(...)
    end
end

function Bridge.BuildingMenu(...)
    if lib then
        return Bridge.ox.BuildingMenu(...)
    end
end

function Bridge.DoorMenu(...)
    if ox_target then
        return Bridge.ox.DoorMenu(...)
    end
end

function Bridge.BuildingApartmentMenu(...)
    if lib then
        return Bridge.ox.BuildingApartmentMenu(...)
    end
end

function Bridge.PermissionMenu(...)
    if lib then
        return Bridge.ox.PermissionMenu(...)
    end
end

function Bridge.OpenPropertyMenu(...)
    if lib then
        return Bridge.ox.OpenPropertyMenu(...)
    end
end