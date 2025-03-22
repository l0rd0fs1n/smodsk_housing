Properties = {}

RegisterNetEvent(Evt.."RegisterProperties", function(properties)
    for k,v in pairs(properties) do
        Properties[v.id] = Property:new(v)
        if v.apartmentId then
            Apartments.Add(Properties[v.id])
        end
    end
end)

RegisterNetEvent(Evt.."RegisterProperty", function(propertyData)
    Properties[propertyData.id] = Property:new(propertyData)
    if propertyData.apartmentId then
        Apartments.Add(Properties[propertyData.id])
    end
end)

RegisterNetEvent(Evt.."UpdateProperty", function(propertyData)
    local property = Properties[propertyData.id]
    property:Update(propertyData)
end)

RegisterNetEvent(Evt.."SetPermissions", function(data)
    local property = Properties[data.id]
    if property then
       property:SetPermissions(data)
    end
end)

RegisterNetEvent(Evt.."SetLockState", function(data)
    local property = Properties[data.id]
    if property then
       property:SetLockState(data.state)
    end
end)

RegisterNetEvent(Evt.."RemoveProperty", function(id)
    local property = Properties[id]
    if property then
        property:Remove()
        Properties[id] = nil
    end
end)

RegisterNetEvent(Evt.."EnterApartment", function(data)
    local property = Properties[data.id]
    if property then
        property:EnterApartment(data)
    end
end)

RegisterNetEvent(Evt.."EnterGarage", function(data)
    local property = Properties[data.id]
    if property then
        property:EnterGarage(data)
    end
end)

RegisterNetEvent(Evt.."DoorBell", function()
   DoorbellRings()
end)

local function handleFurniture(action, data)
    local property = Properties[data.id]
    if property then
        property[action](property, data)
    end
end

RegisterNetEvent(Evt.."ModifyFurniture", function(data) handleFurniture("ModifyFurniture", data) end)
RegisterNetEvent(Evt.."RemoveFurniture", function(data) handleFurniture("RemoveFurniture", data) end)
RegisterNetEvent(Evt.."AddFurniture", function(data) handleFurniture("AddFurniture", data) end)
RegisterNetEvent(Evt.."AddFurnitureGroup", function(data) handleFurniture("AddFurnitureGroup", data) end)

RegisterNetEvent(Evt.."Notification", function(message, duration, success) Bridge.Notification(message, duration, success) end)



Wait(2000)
Bridge.AddGlobalOption()

function LoadProperties()
    TriggerServerEvent(Evt.."GetProperties")
end



AddEventHandler("onResourceStop", function(resourceName)
    if GetCurrentResourceName() == resourceName then
        for k,v in pairs(Properties) do v:Flush() end
    end
end)


