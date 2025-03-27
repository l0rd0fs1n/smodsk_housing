local ready = false
local accepted = false

RegisterNetEvent('qb-menu:client:menuClosed', function()
    ready = true
    accepted = false
end)

RegisterNetEvent(Evt.."qb-confirm", function(data)
    ready = true
    accepted = data.confirm
end)

function Bridge.qb.ConfirmDialog(text)
    ready = false
    accepted = false

    exports['qb-menu']:openMenu({
        {
            header = text,
            isMenuHeader = true,
        },
        {
            header = GetLocale("ACCEPT"),
            params = {
                event = Evt.."qb-confirm",
                args = { confirm = true }
            }
        },  
        {
            header = GetLocale("CANCEL"),
            params = {
                event = Evt.."qb-confirm",
                args = { confirm = false }
            }
        },
    })

    while not ready do
        Wait(5)
    end

    return accepted
end