function Bridge.ox.Progressbar(data)
    if lib.progressBar({
        duration = data.duration,
        label = data.label,
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = true,
            move = true
        },
        anim = data.anim,
        prop = data.prop
    }) then
        return true
    else
        return false
    end
end