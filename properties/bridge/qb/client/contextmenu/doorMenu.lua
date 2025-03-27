RegisterNetEvent(Evt.."DoorMennu", function(data)
    local event = data.event
    TriggerServerEvent(Evt..event)
end)



function Bridge.qb.DoorMenu()
    local options = {
        {
            header = GetLocale("DOOR"),
            isMenuHeader = true
        }
    }

    table.insert(options, {
        header = GetLocale("CAMERA"),
        icon = 'fa-solid fa-video',
        params = {
            event = Evt.."DoorMennu",
            args = {
                event = "EnableDoorBellCam"
            }
        }
    })

    table.insert(options, {
        header = GetLocale("UNLOCK"),
        icon = 'fa-solid fa-lock-open',
        params = {
            event = Evt.."DoorMennu",
            args = {
                event = "UnlockDoor"
            }
        }
    })

    table.insert(options, {
        header =  GetLocale("UNLOCK_FOR").." "..Config.doorUnlockedSeconds.." "..GetLocale("SECONDS"),
        icon = 'fa-solid fa-lock-open',
        params = {
            event = Evt.."DoorMennu",
            args = {
                event = "UnlockDoorForSeconds"
            }
        }
    })

    table.insert(options, {
        header = GetLocale("LOCK"),
        icon = 'fa-solid fa-lock',
        params = {
            event = Evt.."DoorMennu",
            args = {
                event = "LockDoor"
            }
        }
    })

    exports['qb-menu']:openMenu(options)
end