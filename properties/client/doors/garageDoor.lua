function RegisterInteriorDoorGarage(property, coords, exteriorDoorCoords)
    return Bridge.RegisterTargetBox(
    { 
            name = "_garageDoorInterior"..property.id,
            coords = vec3(coords.x, coords.y, coords.z),
            radius = 3.0,
            options = {
                {
                    label = GetLocale("EXIT_GARAGE"),
                    icon = "fa-solid fa-right-from-bracket",
                    onSelect = function()
                        property.garage:Exit()
                    end,
                    canInteract = function()
                        if not CanInteract(true) then return false end
                        return true
                    end
                },
                {
                    label = GetLocale("ENTER_APARTMENT"),
                    icon = "fa-solid fa-house",
                    onSelect = function()
                        property.garage:Exit()
                        TriggerServerEvent(Evt.."EnterApartment", {id = property.id})
                    end,
                    canInteract = function()
                        if not CanInteract() then return false end
                        return property.seperateGarage
                    end
                }
            }
        })
end

function RegisterExteriorDoorGarage(property, coords)
    return Bridge.RegisterTargetBox(
    { 
        name = "_garageDoorExterior"..property.id,
        coords = vec3(coords.x, coords.y, coords.z),
        radius = 1.75,
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
                
                label = GetLocale("ENTER_GARAGE"),
                icon = "fa-solid fa-warehouse",
                onSelect = function()
                    TriggerServerEvent(Evt.."EnterGarage", {id = property.id})
                end,
                canInteract = function()
                    if not CanInteract(true) then return false end
                    return property.unlocked  or CanEnter(property.owner, property.permissions)
                end
            },
        }
    })
end