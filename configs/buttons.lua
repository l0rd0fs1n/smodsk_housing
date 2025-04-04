if not IsDuplicityVersion() then

    Buttons = {
        keys = {
            ["ACCEPT"] = 176,
            ["SET_DOOR"] = 38,
            ["ADD_POINT"] = 38,
            ["MOVE_POINT"] = 157,
            ["ADD_MID_POINT"] = 158,
            ["REMOVE_POINT"] = 160,

            ["DOOR_OFFSET"] = 38,
            ["Z_OFFSET_UP"] = 172,
            ["Z_OFFSET_DOWN"] = 173,
        }
    }


    function Buttons.Disable()
        for k,v in pairs(Buttons.keys) do
            DisableControlAction(0, v, true)
        end
    end


    RegisterCommand("openPropertyMenu", function(source, args)
        Bridge.OpenPropertyMenu()
    end, false)

    RegisterKeyMapping('openPropertyMenu', 'Property Menu', 'keyboard', "n")

end