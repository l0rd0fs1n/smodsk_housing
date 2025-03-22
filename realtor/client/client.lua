
local function combineShellData()
     return {
        shell = RealtorShellData,
        smShellTemplate = SMShellTemplates,
     }
end

local function closeMenu()
    SetNuiFocus(false, false)
    SendNuiMessage(json.encode({
        action = "close",
    }))
end

local function isRealtor()
    return PlayerData.job.name == Config.realtorJobName
end

local function getLocations()
    local locations = nil
    RequestDataFromServer(Evt.."GetLocations", {}, function(data)
        locations = data
    end)
    while locations == nil do Wait(1) end
    return locations
end

function OpenPropertyUI()
    PropertyDetails.Reset()
    SetNuiFocus(true, true)
    SendNuiMessage(json.encode({
        action = "open",
        isRealtor = isRealtor(),
        identifier = PlayerData.identifier,
        locations = getLocations(),
        shellData = isRealtor() and combineShellData() or nil
    }))

end

RegisterNUICallback('GetPropertiesByLocation', function(data, cb)
    if data.location == "unlisted" then
        RequestDataFromServer(Evt.."GetUnlistedProperties", data, function(properties)
            cb(properties)
        end)
    elseif data.location == "myProperties" then
        RequestDataFromServer(Evt.."GetMyProperties", data, function(properties)
            cb(properties)
        end)
    else
        RequestDataFromServer(Evt.."GetPropertiesByLocation", data, function(properties)
            cb(properties)
        end)
    end
end)

RegisterNUICallback('GetOffers', function(data, cb)
    RequestDataFromServer(Evt.."GetOffers", {}, function(offers)
        cb(offers)
    end)
end)

RegisterNUICallback('CreateOffer', function(data, cb)
    TriggerServerEvent(Evt.."CreateOffer", data)
end)

RegisterNUICallback('AcceptOffer', function(data, cb)
    RequestDataFromServer(Evt.."AcceptOffer", data, function()
        cb(true)
    end)
end)

RegisterNUICallback('DeclineOffer', function(data, cb)
    RequestDataFromServer(Evt.."DeclineOffer", data, function()
        cb(true)
    end)
end)

RegisterNUICallback('RemoveOffer', function(data, cb)
    RequestDataFromServer(Evt.."RemoveOffer", data, function()
        cb(true)
    end)
end)


RegisterNUICallback("SetWayPointProperty", function(data)
    local property = Properties[data.id]
    if property then
        local coords = property.apartment.door.exteriorDoorCoords
        SetNewWaypoint(coords.x, coords.y)
    end
end)

RegisterNUICallback("SetWayPointApartment", function(data)
    local id = data.id
    for i=1,#BasicApartments do
        if BasicApartments[i].id == id then
            local coords = BasicApartments[i].door
            SetNewWaypoint(coords.x, coords.y)
            break
        end
    end
end)

RegisterNUICallback("BuyApartment", function(data)
    TriggerServerEvent(Evt.."BuyApartment", data)
end)




RegisterNUICallback("close", function()
    closeMenu()
end)

RegisterNUICallback("refresh", function()
    OpenPropertyUI()
end)

CreateThread(function()
    Wait(1000)
    SendNuiMessage(json.encode{
        action = "init",
        localization = Localization,
        basicApartments = BasicApartments,
    })
end)


--- Locales --
RegisterNUICallback("AddMissingLocale", function(data)
    AddMissingLocale(data.locale)
end)