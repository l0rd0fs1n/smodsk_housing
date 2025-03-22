InstructionalBtns = {
    scaleform = nil
}

local function loadScaleform(scaleformName)
    local scaleform = RequestScaleformMovie(scaleformName)
    while not HasScaleformMovieLoaded(scaleform) do
        Wait(0)
    end
    return scaleform
end

function InstructionalBtns.Setup(buttons)
    Wait(5)
    if not InstructionalBtns.scaleform then
        InstructionalBtns.scaleform = loadScaleform("instructional_buttons")
    end

    BeginScaleformMovieMethod(InstructionalBtns.scaleform, "CLEAR_ALL")
    EndScaleformMovieMethod()
    BeginScaleformMovieMethod(InstructionalBtns.scaleform, "SET_CLEAR_SPACE")
    ScaleformMovieMethodAddParamInt(200)
    EndScaleformMovieMethod()

    for i, value in ipairs(buttons) do
        BeginScaleformMovieMethod(InstructionalBtns.scaleform, "SET_DATA_SLOT")
        ScaleformMovieMethodAddParamInt(i - 1)
        PushScaleformMovieMethodParameterButtonName(GetControlInstructionalButton(1, value[1], true))
        BeginTextCommandScaleformString("STRING")
        AddTextComponentScaleform(value[2])
        EndTextCommandScaleformString()
        EndScaleformMovieMethod()
    end

    BeginScaleformMovieMethod(InstructionalBtns.scaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
    EndScaleformMovieMethod()
end

function InstructionalBtns.Remove()
    if InstructionalBtns.scaleform then
        SetScaleformMovieAsNoLongerNeeded(InstructionalBtns.scaleform)
        InstructionalBtns.scaleform = nil 
    end
end

function InstructionalBtns.Draw()
    if InstructionalBtns.scaleform then
        DrawScaleformMovieFullscreen(InstructionalBtns.scaleform, 255, 255, 255, 255, 1)
    end
end

