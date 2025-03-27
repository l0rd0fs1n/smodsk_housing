function Bridge.qb.BuildingMenu(data)
	local options = {
        {
            header = GetLocale("ENTER_APARTMENT"),
            isMenuHeader = true
        }
    }

	for i = 1, #data do
		local property = data[i]
		local label = property.street .. (CanEnter(property.owner, property.permissions) and " (*)" or "")
		table.insert(options, {
			header = label,
			icon = 'fa-solid fa-house',
			params = {
				event = Evt.."BuildingApartmentMenu",
				args = {property = property}
			}
		})
	end

	exports['qb-menu']:openMenu(options)
end

RegisterNetEvent(Evt.."BuildingApartmentMenu", function(data)
    local property = data.property
    Bridge.BuildingApartmentMenu(property)
end)

RegisterNetEvent(Evt.."BuildingApartmentMenuAction", function(data)
    local event = data.event
    local id = data.id
    TriggerServerEvent(Evt..event, {id = id})
end)

RegisterNetEvent(Evt.."BuildingApartmentMenuActionDoor", function(data)
    local event = data.event
    local id = data.id
    DoorLock(function()
        TriggerServerEvent(Evt..event, {id = id})
    end)
end)


function Bridge.qb.BuildingApartmentMenu(property)
    local options = {
        {
            header = property.street,
            isMenuHeader = true
        }
    }
    
    if property.unlocked or CanEnter(property.owner, property.permissions) then
        table.insert(options, {
            header = GetLocale("ENTER_APARTMENT"),
            icon = 'fa-solid fa-house',
            params = {
				event = Evt.."BuildingApartmentMenuAction",
				args = {
                    id = property.id,
                    event = "EnterApartment"
                }
			}
        })
    end

    if not property.unlocked and not CanEnter(property.owner, property.permissions) then
        table.insert(options, {
            header = GetLocale("RING_BELL"),
            icon = 'fa-fas fa-bell',
            params = {
				event = Evt.."BuildingApartmentMenuAction",
				args = {
                    id = property.id,
                    event = "RingDoorbell"
                }
			}
        })
    end 
    
    if not property.unlocked  and (not CanEnter(property.owner, property.permissions) and CanBreakIn(property.owner, property.permissions)) then
        table.insert(options, {
            header = GetLocale("BREAK_IN"),
            icon = 'fa-fas fa-bell',
            params = {
				event = Evt.."BuildingApartmentMenuAction",
				args = {
                    id = property.id,
                    event = "BreakIn"
                }
			}
        })
    end

    if not property.unlocked and CanEnter(property.owner, property.permissions) then
        table.insert(options, {
            header = GetLocale("UNLOCK_DOOR"),
            icon = "fa-solid fa-lock-open",
            params = {
				event = Evt.."BuildingApartmentMenuActionDoor",
				args = {
                    id = property.id,
                    event = "UnlockDoor"
                }
			}
        })
    end

    if not property.unlocked and CanEnter(property.owner, property.permissions) then
        table.insert(options, {
            header = GetLocale("UNLOCK_FOR").." "..Config.doorUnlockedSeconds.." "..GetLocale("SECONDS"),
            icon = "fa-solid fa-lock-open",
            params = {
				event = Evt.."BuildingApartmentMenuActionDoor",
				args = {
                    id = property.id,
                    event = "UnlockDoorForSeconds"
                }
			}
        })
    end

    if property.unlocked  then
        table.insert(options, {
            header = GetLocale("LOCK_DOOR"),
            icon = "fa-solid fa-lock-open",
            params = {
				event = Evt.."BuildingApartmentMenuActionDoor",
				args = {
                    id = property.id,
                    event = "LockDoor"
                }
			}
        })
    end

    exports['qb-menu']:openMenu(options)
end