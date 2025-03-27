function Bridge.qb.RegisterTargetBox(data)
    local targetOptions = {
        options = {}
    }

    -- Create options for the target
    for k, v in pairs(data.options) do
        table.insert(targetOptions.options, {
            num = k,
            type = "client",
            event = v.event,
            icon = v.icon,
            label = v.label,
            targeticon = v.targeticon or "default_icon",
            item = v.item,
            action = v.onSelect,
            canInteract = v.canInteract,
            job = v.job or nil,
            gang = v.gang or nil,
            drawDistance = v.drawDistance or 2.5,
            drawColor = v.drawColor or {255, 255, 255},
            successDrawColor = v.successDrawColor or {0, 255, 0}
        })
    end

    -- Add the circle zone using qb-target's AddCircleZone method
    local zoneId = exports['qb-target']:AddCircleZone(data.name, data.coords, data.radius, {
        name = data.name,
        debugPoly = false  -- Set to true if you want to debug the poly zone
    }, targetOptions)

    return zoneId  -- Return the zoneId to remove the zone later if needed
end


function Bridge.qb.RemoveTargetBox(id)
    exports['qb-target']:RemoveZone(id)
end
