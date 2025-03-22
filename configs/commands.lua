
if not IsDuplicityVersion() then
    RegisterCommand("properties", function()
        OpenPropertyUI()
    end, false)

    
    --- TOOLS --
    RegisterCommand("getApartmentData", function(source, args)
        GetApartmentData()
    end, false)

    RegisterCommand("missingLocales", function()
        PrintMissingLocales()
    end, false)

    RegisterCommand("shellOffset_start", function(source, args)
        ShellOffsetCreator.Create(args)
    end, false)

    RegisterCommand("shellOffset_get", function(source, args)
        ShellOffsetCreator.Offset()
    end, false)
end