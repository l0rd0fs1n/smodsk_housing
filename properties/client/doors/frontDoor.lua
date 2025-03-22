function RegisterExteriorDoor(property, coords)
        return Bridge.RegisterTargetBox(
        { 
            name = "_doorExterior"..property.id,
            coords = vec3(coords.x, coords.y, coords.z),
            radius = 1.0,
            options = {
                {
                    
                    label = property.street,
                    icon = "fa-solid fa-house",
                    onSelect = function()
                    end,
                    canInteract = function()
                       return true
                    end
                },
                {
                    
                    label = GetLocale("ENTER_APARTMENT"),
                    icon = "fa-solid fa-house",
                    onSelect = function()
                        TriggerServerEvent(Evt.."EnterApartment", {id = property.id})
                    end,
                    canInteract = function(data)
                        if not CanInteract() then return false end
                        return property.unlocked or CanEnter(property.owner, property.permissions)
                    end
                },
                {
                    
                    label = GetLocale("RING_BELL"),
                    icon = "fa-solid fa-bell",
                    onSelect = function()
                        RingDoorbell(function(success)
                            if not success then return end
                            TriggerServerEvent(Evt.."RingDoorbell", {id = property.id})
                        end)
                    end,
                    canInteract = function()
                        if not CanInteract() then return false end
                        return not property.unlocked and not CanEnter(property.owner, property.permissions)
                    end
                },
                {
                    label = GetLocale("BREAK_IN"),
                    icon = "fa-solid fa-wrench",
                    onSelect = function()
                        -- Let em try break in and then check permissions on server --
                        TryBreakIn(function(success)
                            if not success then return end
                            TriggerServerEvent(Evt.."BreakIn", {id = property.id})
                        end)  
                    end,
                    canInteract = function()
                        if not CanInteract() then return false end
                        return not property.unlocked  and (not CanEnter(property.owner, property.permissions) and CanBreakIn(property.owner, property.permissions))
                    end
                },
                {
                    label = GetLocale("UNLOCK_DOOR"),
                    icon = "fa-solid fa-lock-open",
                    onSelect = function()
                        DoorLock(function(success)
                            if not success then return end
                            TriggerServerEvent(Evt.."UnlockDoor", {id = property.id})
                        end)
                    end,
                    canInteract = function()
                        if not CanInteract() then return false end
                        return not property.unlocked and CanEnter(property.owner, property.permissions)
                    end
                },
                {
                    label = GetLocale("UNLOCK_FOR").." "..Config.doorUnlockedSeconds.." "..GetLocale("SECONDS"),
                    icon = "fa-solid fa-lock-open",
                    onSelect = function()
                        DoorLock(function(success)
                            if not success then return end
                            TriggerServerEvent(Evt.."UnlockDoorForSeconds", {id = property.id})
                        end)
                    end,
                    canInteract = function()
                        if not CanInteract() then return false end
                        return not property.unlocked and CanEnter(property.owner, property.permissions)
                    end
                },
                {
                    label = GetLocale("LOCK_DOOR"),
                    icon = "fa-solid fa-lock",
                    onSelect = function()
                        DoorLock(function(success)
                            if not success then return end
                            TriggerServerEvent(Evt.."LockDoor", {id = property.id})
                        end)
                    end,
                    canInteract = function()
                        if not CanInteract() then return false end
                        return property.unlocked 
                    end
                },
            }
        })
end


function RegisterInteriorDoor(property, coords)
    return Bridge.RegisterTargetBox(
    { 
            name = "_doorInterior"..property.id,
            coords = vec3(coords.x, coords.y, coords.z),
            radius = 3.0,
            options = {
                {
                    
                    label = GetLocale("EXIT_APARTMENT"),
                    icon = "fa-solid fa-right-from-bracket",
                    onSelect = function()
                        property.apartment:Exit()
                    end,
                    canInteract = function()
                        if not CanInteract() then return false end
                        return true
                    end
                },
                {
                    label = GetLocale("ENTER_GARAGE"),
                    icon = "fa-solid fa-right-from-bracket",
                    onSelect = function()
                        property.apartment:Exit()
                        TriggerServerEvent(Evt.."EnterGarage", {id = property.id})
                    end,
                    canInteract = function()
                        if not CanInteract() then return false end
                        return property.seperateGarage
                    end
                },
            }
        })
end