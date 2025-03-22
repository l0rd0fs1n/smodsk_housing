local propertyDetails_template = {
    id = false,
    location = GetLocale("SET_DOOR"),
    street = GetLocale("SET_DOOR"),
    status = false,
    price = 0,
    apartmentData = false,
    garageData = false,
    images  = {},
    description = "",
    door = false,
    garageDoor = false,
    exterior = false,
    owner = Config.realtorJobName
}

local oldPropertyData = nil
PropertyDetails = {}

function PropertyDetails.Reset(popUp)
    oldPropertyData = nil
    PropertyDetails.data = DeepCopy(propertyDetails_template)
    SendNuiMessage(json.encode({
        action = "setPropertyDetails",
        data = PropertyDetails.data,
        popUp = popUp
    }))
end

function PropertyDetails.GetData(id, callback)
    PropertyDetails.Reset()
    RequestDataFromServer(Evt.."GetPropertyData", {id = id}, function(data)
        oldPropertyData = DeepCopy(data)
        PropertyDetails.data = data
        callback(data)
    end)
end

function PropertyDetails.Set(key, value, post)
    PropertyDetails.data[key] = value
    if post then
        SetNuiFocus(true, true)
        SendNuiMessage(json.encode({
            action = "setPropertyDetailsValue",
            key = key,
            value = value
        }))
    end
end

function PropertyDetails.Get(key)
    return PropertyDetails.data[key]
end

RegisterNUICallback('SetPropertyDetailsValue', function(data, cb)
    PropertyDetails.Set(data.key, data.value, false)
end)


RegisterNUICallback('SetExterior', function(data, cb)
    SetNuiFocus(false, false)
    PropertyDetails.Set(
        "exterior", 
        ExteriorCreator(PropertyDetails.Get("exterior")),
        true
    )
end)

RegisterNUICallback('SetGarage', function(data, cb)
    SetNuiFocus(false, false)
    PropertyDetails.Set(
        "garageDoor", 
        GarageCreator(PropertyDetails.Get("garageDoor")),
        true
    )
end)


RegisterNUICallback('SetDoor', function(data, cb)
    SetNuiFocus(false, false)
    local position = DoorCreator(PropertyDetails.Get("door"))
    local streetHash = GetStreetNameAtCoord(position.x, position.y, position.z)
	local street = GetStreetNameFromHashKey(streetHash)
	local regionHash = GetNameOfZone(position.x, position.y, position.z)
	local location = GetLabelText(regionHash)
    local houseNumber = GetApartmentId(position, 10)

    PropertyDetails.Set("door", position, true)
    PropertyDetails.Set("street", street.." "..houseNumber, true)
    PropertyDetails.Set("location", location, true)
end)

RegisterNUICallback('GetPropertyData', function(data, cb)
    PropertyDetails.GetData(data.id, function(data)
        cb(data)
    end)
end)

RegisterNUICallback('NewProperty', function(data, cb)
    PropertyDetails.Reset(true)
end)


local lastSave = GetGameTimer()
RegisterNUICallback('SaveData', function(data, cb)
    if GetGameTimer() - lastSave < 3000 then Notification(GetLocale("CANT_SAVE_NOW"), 6000, false) return end
    lastSave = GetGameTimer()
    if not PropertyDetails.data.apartmentData then Notification(GetLocale("SELECT_APARTMENT_SHELL"), 6000, false) return end
    if not PropertyDetails.data.apartmentId then
        if not PropertyDetails.data.garageData then Notification(GetLocale("SELECT_GARAGE_SHELL"), 6000, false) return end
    end
    if not PropertyDetails.data.door then Notification(GetLocale("SET_DOOR"), 6000, false) return end
    if not PropertyDetails.data.garageDoor then Notification(GetLocale("SET_GARAGE"), 6000, false) return end
    TriggerServerEvent(Evt.."SaveProperty", PropertyDetails.data, oldPropertyData)
end)