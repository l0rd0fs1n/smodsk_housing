if not IsDuplicityVersion() then
    -- 👤 Client side
    RegisterCommand("properties", function()
        OpenPropertyUI()
    end, false)

    RegisterNetEvent(Evt.."getApartmentData", function()
        GetApartmentData()
    end)

    RegisterNetEvent(Evt.."missingLocales", function()
        PrintMissingLocales()
    end)

    RegisterNetEvent(Evt.."shellOffset", function(shellName)
        ShellOffsetCreator.Create(shellName)
    end)
else
    local function isAuthorized(source)
        if QBCore then
            return QBCore.Functions.HasPermission(source, "god") or IsPlayerAceAllowed(source, 'command')
        elseif ESX then
            local xPlayer = ESX.GetPlayerFromId(source)
            return (xPlayer and (xPlayer.getGroup() == "admin" or xPlayer.getGroup() == "superadmin")) or IsPlayerAceAllowed(source, 'command')
        end
        return false
    end
    

    RegisterCommand("getApartmentData", function(source, args)
        if isAuthorized(source) then
            TriggerClientEvent(Evt.."getApartmentData", source)
        else
            TriggerClientEvent("chat:addMessage", source, {
                args = {"System", "You do not have permission to use this command."}
            })
        end
    end, true)

    RegisterCommand("missingLocales", function(source, args)
        if isAuthorized(source) then
            TriggerClientEvent(Evt.."missingLocales", source)
        else
            TriggerClientEvent("chat:addMessage", source, {
                args = {"System", "You do not have permission to use this command."}
            })
        end
    end, true)

    RegisterCommand("shellOffset", function(source, args)
        if not args[1] then return end
        if isAuthorized(source) then
            TriggerClientEvent(Evt.."shellOffset", source, args[1])
        else
            TriggerClientEvent("chat:addMessage", source, {
                args = {"System", "You do not have permission to use this command."}
            })
        end
    end, true)
end
