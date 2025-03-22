function Bridge.ox.DoorMenu()
    local options = {}

    table.insert(options, {
    title = GetLocale("CAMERA"),
    icon = 'fa-fas fa-video',
    onSelect = function()
        TriggerServerEvent(Evt.."EnableDoorBellCam")
    end})

    table.insert(options, {
    title = GetLocale("UNLOCK"),
    icon = 'fa-fas fa-lock-open',
    onSelect = function()
        TriggerServerEvent(Evt.."UnlockDoor")
    end})

    table.insert(options, {
        title =  GetLocale("UNLOCK_FOR").." "..Config.doorUnlockedSeconds.." "..GetLocale("SECONDS"),
        icon = 'fa-fas fa-lock-open',
        onSelect = function()
            TriggerServerEvent(Evt.."UnlockDoorForSeconds")
        end})

    table.insert(options, {
    title = GetLocale("LOCK"),
    icon = 'fa-fas fa-lock',
    onSelect = function()
        TriggerServerEvent(Evt.."LockDoor")
    end})

    lib.registerContext({
        id = 'sm_property_menu_doorbell',
        title = GetLocale("DOOR"),
        menu = 'sm_property_menu',
        options = options
    })

    lib.showContext('sm_property_menu_doorbell')
end