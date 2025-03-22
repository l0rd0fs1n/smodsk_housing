function Bridge.ox.RegisterTargetBox(data)
    local options = {}
    for k,v in pairs(data.options) do
        table.insert(options, {
            event = v.event,
            icon = v.icon,
            label = v.label,
            onSelect = v.onSelect,
            canInteract = v.canInteract
        })
    end
    return ox_target:addSphereZone({
        name = data.name,
        debug = false,
        coords = data.coords,
        radius = data.radius,
        options = options
    })
end


function Bridge.ox.RemoveTargetBox(id)
    ox_target:removeZone(id)
end

