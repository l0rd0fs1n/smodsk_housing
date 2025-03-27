function Bridge.qb.Progressbar(data)
    local ready = false
    local success = false
    QBCore.Functions.Progressbar(Evt.."progressbar", data.label,  data.duration, false, false, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = true,
        disableCombat = true,
    }, 
    {
        animDict = data.anim.dict,
        anim = data.anim.clip,
        flags = data.anim.flag
    },
    {}, {},
    function(a)
        ready = true
        success = true
    end, 
    function(b)
        ready = true
        success = false
    end)

    while not ready do Wait(100) end
    return success
end