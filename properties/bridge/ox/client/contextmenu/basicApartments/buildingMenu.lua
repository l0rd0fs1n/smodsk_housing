function Bridge.ox.BuildingMenu(data)
    local options = {}

    for i=1,#data do
        local property = data[i]
        table.insert(options, {
            title = data[i].street..(CanEnter(property.owner, property.permissions) and " (*)" or ""),
            icon = 'fa-fas fa-house',
            onSelect = function()
              Bridge.BuildingApartmentMenu(property)
            end}
        )
    end

    lib.registerContext({
        id = 'sm_building_menu',
        title = GetLocale("BUILDING"),
        options = options
    })

    lib.showContext('sm_building_menu')
end


function Bridge.ox.BuildingApartmentMenu(property)
    local options = {}
    
    if property.unlocked or CanEnter(property.owner, property.permissions) then
        table.insert(options, {
            title = GetLocale("ENTER_APARTMENT"),
            icon = 'fa-fas fa-house',
            onSelect = function()
                TriggerServerEvent(Evt.."EnterApartment", {id = property.id})
            end
        })
    end

    if not property.unlocked and not CanEnter(property.owner, property.permissions) then
        table.insert(options, {
            title = GetLocale("RING_BELL"),
            icon = 'fa-fas fa-bell',
            onSelect = function()
                TriggerServerEvent(Evt.."RingDoorbell", {id = property.id})
            end
        })
    end 
    
    if not property.unlocked  and (not CanEnter(property.owner, property.permissions) and CanBreakIn(property.owner, property.permissions)) then
        table.insert(options, {
            title = GetLocale("BREAK_IN"),
            icon = 'fa-fas fa-bell',
            onSelect = function()
                TriggerServerEvent(Evt.."BreakIn", {id = property.id})
            end
        })
    end

    if not property.unlocked and CanEnter(property.owner, property.permissions) then
        table.insert(options, {
            title = GetLocale("UNLOCK_DOOR"),
            icon = "fa-solid fa-lock-open",
            onSelect = function()
                DoorLock(function()
                    TriggerServerEvent(Evt.."UnlockDoor", {id = property.id})
                end)
            end
        })
    end

    if not property.unlocked and CanEnter(property.owner, property.permissions) then
        table.insert(options, {
            title = GetLocale("UNLOCK_FOR").." "..Config.doorUnlockedSeconds.." "..GetLocale("SECONDS"),
            icon = "fa-solid fa-lock-open",
            onSelect = function()
                DoorLock(function()
                    TriggerServerEvent(Evt.."UnlockDoorForSeconds", {id = property.id})
                end)
            end
        })
    end

    if property.unlocked  then
        table.insert(options, {
            title = GetLocale("LOCK_DOOR"),
            icon = "fa-solid fa-lock-open",
            onSelect = function()
                DoorLock(function()
                    TriggerServerEvent(Evt.."LockDoor", {id = property.id})
                end)
            end
        })
    end

    lib.registerContext({
        id = 'sm_building_apartment_menu',
        title = property.street,
        menu = 'sm_building_menu',
        options = options
    })

    lib.showContext('sm_building_apartment_menu')
end