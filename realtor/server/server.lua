local function getApartmentData(id)
    for i=1,#BasicApartments do 
        if BasicApartments[i].id == id then
            return BasicApartments[i]
        end
    end
end

local function createShellData(data, oldData)
    if oldData and data.name == oldData.name then return oldData end
    if data.type == "smShellTemplate" then
        if oldData and oldData.shellType == "smShell" then
            exports["smodsk_shellBuilder"]:DeleteShell(oldData.shell)
        end
        local success, shellId = exports["smodsk_shellBuilder"]:CreateNewShell(nil, data.key, nil)
        return {shellType = "smShell", shell = shellId, name = data.name}
    elseif data.type == "smShell" then
        if oldData and oldData.shellType == "smShell" then
            exports["smodsk_shellBuilder"]:DeleteShell(oldData.shell)
        end
        local success, id = exports["smodsk_shellBuilder"]:DuplicateShell(data.key)
        return {shellType = "smShell", shell = id, name = data.name}
    elseif data.type == "shell" then

        return {shellType = data.shellType, shell = data.key, name = data.name}

    end
    return {}
end

RegisterServerEvent(Evt.."SaveProperty", function(data, oldData)
    local source = source

    if not data.apartmentId then
        data.shellData = {
            apartment = createShellData(data.apartmentData, oldData ~= nil and oldData.apartmentData),
            garage = createShellData(data.garageData, oldData ~= nil and oldData.garageData)
        }
        data.exterior = type(data.exterior) == "table" and data.exterior or {}
    else
        data.shellData = {
            apartment = {
                shellType = oldData.apartmentData.shellType,
                shell = oldData.apartmentData.shell,
                name = oldData.apartmentData.name
            }
        } 
    end

    if not oldData then
        AddNewProperty(source, data)
    else
        UpdateProperty(source, data)
    end
end)

RegisterServerEvent(Evt.."GetLocations", function()
    local source = source
    local locations = Database.GetLocations()
    local usedLocations = {}
    local loc = {}
    for i=1,#locations do
        local location = locations[i].location
        if not usedLocations[location] then
            table.insert(loc, location)
        end
    end
    SendDataToClient("GetLocations", source, loc)
end)


local function buildCardData(properties)
    local data = {}
    for i=1,#properties do
        local propertyData = properties[i]
        local images = json.decode(propertyData.images)
        local property = {
            id = propertyData.id,
            image = images[1],
            street = propertyData.street,
            price = propertyData.price or 0,
            owner = propertyData.owner,
            apartmentId = propertyData.apartmentId
        }
        table.insert(data, property)
    end
    return data
end

RegisterServerEvent(Evt.."GetUnlistedProperties", function()
    local source = source
    local properties = Database.GetUnlistedProperties()
    SendDataToClient("GetUnlistedProperties", source, buildCardData(properties))
end)

RegisterServerEvent(Evt.."GetMyProperties", function()
    local source = source
    local identifier = GetIdentifier(source)
    local properties = Database.GetPropertyByOwner(identifier)
    SendDataToClient("GetMyProperties", source, buildCardData(properties))
end)

RegisterServerEvent(Evt.."GetPropertiesByLocation", function(data)
    local source = source
    local properties = Database.GetPropertiesByLocation(data.location)
    SendDataToClient("GetPropertiesByLocation", source, buildCardData(properties))
end)

RegisterServerEvent(Evt.."GetPropertyData", function(data)
    local source = source

    local property = Database.GetPropertyData(data.id)
    property = property[1]

    local shellData = json.decode(property.shellData)
    SendDataToClient("GetPropertyData", source, {
        id = property.id,
        price = property.price or 0,
        description = property.description,
        exterior = json.decode(property.exterior),
        door = json.decode(property.door),
        garageDoor = json.decode(property.garageDoor),
        images = json.decode(property.images),
        street = property.street,
        location = property.location,
        status = property.status,
        garageData = shellData.garage,
        apartmentData = shellData.apartment,
        owner = property.owner,
        apartmentId = property.apartmentId
    })
end)

RegisterServerEvent(Evt.."GetOffers", function()
    local source = source
    local job = GetJobName(source)
    local data = {}

    local myData = Database.GetOffers("identifier", GetIdentifier(source))
    local offers = Database.GetOffers("owner", job == Config.realtorJobName and Config.realtorJobName or GetIdentifier(source))

    
    if offers then
        for i=1,#offers do
            local propertyId = offers[i].propertyId
            if not data[propertyId] then
                data[propertyId] = {
                    id = offers[i].id,
                    street = offers[i].street,
                    location = offers[i].location,
                    price = offers[i].askingPrice,
                    offers = {}
                }
            end

            data[propertyId].offers[#data[propertyId].offers+1] = offers[i]
        end
    end

    SendDataToClient("GetOffers", source, {
        offers = data, 
        myOffers = myData
    })
end)

local function addMoney(identifier, amount)
    if identifier == Config.realtorJobName then
        AddCompanyMoney(Config.realtorSocietyAccountName, amount)
        return
    end

    local found = false
    local playerId = nil
    for _, _playerId in ipairs(GetPlayers()) do
        playerId = tonumber(_playerId)
        local _identifer = GetIdentifier(playerId)
        found = _identifer == identifier
        if found then break end
    end

    --if found then
        --AddCash(playerId, amount)
    --else
        Database.AddBankMoney(identifier, amount)
    --end
end


RegisterServerEvent(Evt.."AcceptOffer", function(data)
    local source = source
    local id = data.id
    local offers = Database.GetOffers("id", id)
    local offer = offers[1]
    if offer then 
        local offers = Database.GetOffers("propertyId", offer.propertyId)
        for i=1,#offers do
            if offers[i].id ~= offer.id then
                addMoney(offers[i].identifier, offers[i].price)
            end
        end

        Database.UpdateProperty({
            id = offer.propertyId,
            status = 0
        })

        addMoney(offer.owner, offer.price)
        SetPropertyOwner(offer.identifier, offer.propertyId)
        Database.RemoveOffers("propertyId", offer.propertyId)
    end

    SendDataToClient("AcceptOffer", source)
    SendDataToClient("Notification", source, GetLocale("ACCEPTED_OFFER_AND_REMOVED_OTHER_OFFERS"), 6000, true)
end)

RegisterServerEvent(Evt.."DeclineOffer", function(data)
    local source = source
    local id = data.id
    local offers = Database.GetOffers("id", id)
    local offer = offers[1]
    if offer then 
        addMoney(offer.identifier, offer.price)
        Database.RemoveOffers("id", id)
    end
    SendDataToClient("DeclineOffer", source)
    SendDataToClient("Notification", source, GetLocale("REMOVED_OFFER_AND_RETURNED_MONEY"), 6000, true)
end)

RegisterServerEvent(Evt.."RemoveOffer", function(data)
    local source = source
    local id = data.id
    local identifier = GetIdentifier(source)
    local offers = Database.GetOffers("id", id)
    local offer = offers[1]
    if offer and offer.identifier == identifier then 
        addMoney(offer.identifier, offer.price)
        Database.RemoveOffers("id", id)
    end
    SendDataToClient("RemoveOffer", source)
    SendDataToClient("Notification", source, GetLocale("REMOVED_OFFER_AND_RETURNED_MONEY"), 6000, true)
end)

RegisterServerEvent(Evt.."CreateOffer", function(data)
    local source = source
    local playerData = GetPlayerData(source)
    local offers = Database.GetOffers("identifier", playerData.identifier)
    local ownedCount = Database.GetOwnedCount(playerData.identifier)


    if offers[1] then
        SendDataToClient("Notification", source, GetLocale("ONLY_ONE_OFFER_AT_TIME"), 6000, false)
    elseif ownedCount >= Config.maxPropertiesOwned then
        SendDataToClient("Notification", source, GetLocale("YOU_OWN_MAX_PROPERTIES"), 6000, false)
    else 
        local property = Database.GetPropertyData(data.propertyId)

        property = property[1]
        if property then
            if TryRemoveBankMoney(source, data.price) then
                local offerData = {
                    propertyId = property.id,
                    owner = property.owner,
                    location = property.location,
                    street = property.street,
                    identifier = playerData.identifier, 
                    phone = data.phone,
                    name = playerData.name,
                    price = data.price,
                    askingPrice = property.price
                }
                Database.CreateOffer(offerData)
                SendDataToClient("Notification", source, GetLocale("OFFER_CREATED"), 10000, true)
            else
                SendDataToClient("Notification", source, GetLocale("NOT_ENOUGH_MONEY"), 10000, false)
            end
        end
    end
end)



--- Apartment Buying ---



local function getFreeIndex(apartments)

    local usedIndexes = {}
    for i = 1, #apartments do
        local apartment = apartments[i]
        local street = apartment.street
        local index_str = street:match(".*%s(%d+)%-(%d+)$")
        if index_str then
            local index = tonumber(index_str)
            table.insert(usedIndexes, index)
        end
    end
    
    table.sort(usedIndexes)

    local freeIndex = nil
    for i = 1, #usedIndexes - 1 do
        if usedIndexes[i + 1] - usedIndexes[i] > 1 then
            freeIndex = usedIndexes[i] + 1
            break
        end
    end

    if not freeIndex then
        freeIndex = #usedIndexes > 0 and usedIndexes[#usedIndexes] + 1 or 1
    end

    return freeIndex
end

RegisterServerEvent(Evt.."BuyApartment", function(data)
    local source = source
    local apartmentData = getApartmentData(data.id)
    local shellData = apartmentData.shells[data.index]

    if apartmentData then
        local identifier = GetIdentifier(source)
        local offers = Database.GetOffers("identifier", identifier)
        if not offers[1] then
            local ownedCount = Database.GetOwnedCount(identifier)
            if ownedCount < Config.maxPropertiesOwned then
                if TryRemoveBankMoney(source, shellData.price) then
                    local apartments = Database.GetPropertyByApartmentId(data.id)
                    local freeIndex = getFreeIndex(apartments)
                    local street = apartmentData.street.."-"..freeIndex
                    
                    local newApartment = {
                        owner = identifier,
                        apartmentId = apartmentData.id,
                        street = street,
                        location = apartmentData.location,
                        shellData = {
                            apartment = {
                                shellType = shellData.data.shellType,
                                shell = shellData.shell,
                                name = shellData.data.name
                            }
                        },
                        price = shellData.price,
                        status = 0,
                    }

                    AddNewApartment(source, newApartment)
                else
                    SendDataToClient("Notification", source, GetLocale("NOT_ENOUGH_MONEY"), 6000, false)
                end
            else
                SendDataToClient("Notification", source, GetLocale("YOU_OWN_MAX_PROPERTIES"), 6000, false)
            end
        end
    end
end)
