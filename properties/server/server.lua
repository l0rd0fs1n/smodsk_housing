PropertiesBaseData = {}

Properties = {}
local clients = {}

local function addProperty(propertyData)
    propertyData.shellData = propertyData.shellData and (type(propertyData.shellData) == "string" and json.decode(propertyData.shellData) or propertyData.shellData) or {}
    propertyData.door = propertyData.door and (type(propertyData.door) == "string" and json.decode(propertyData.door) or propertyData.door) or {}
    propertyData.garageDoor = propertyData.garageDoor and (type(propertyData.garageDoor) == "string" and json.decode(propertyData.garageDoor) or propertyData.garageDoor) or {}
    propertyData.exterior = propertyData.exterior and (type(propertyData.exterior) == "string" and json.decode(propertyData.exterior) or propertyData.exterior) or {}
    propertyData.permissions = propertyData.permissions and (type(propertyData.permissions) == "string" and json.decode(propertyData.permissions) or propertyData.permissions) or {}
    Properties[propertyData.id] = Property:new(propertyData)
    PropertiesBaseData[propertyData.id] = propertyData
end

local function updateProperty(propertyData)
    local property = Properties[propertyData.id]
    if property then
        property:Update(propertyData)
        PropertiesBaseData[propertyData.id] = propertyData
        SendDataToClient("UpdateProperty", -1, propertyData)
    end
end


local function loadProperties()
    local data = Database.GetPropertyDatas()
    for i=1,#data do
        addProperty(data[i])
    end
end


local function hasPermission(source, propertyId, permission)
    local property = Properties[propertyId]

    if property then
        local permissionLevel = property:GetPermissionLevel(source)
        if permissionLevel == "owner" then return true end
        local permissions = Config.permissionLevels[permissionLevel]
        if not permissions then return end
        if not permissions.canOpenStorage then return end
        return permissions[permission]
    end

    return false
end


RegisterServerEvent(Evt.."EnterPreExterior", function(data)
    local source = source
    local property = Properties[data.id]
    if property then
        property:EnterPreExterior(source)
    end
end)

RegisterServerEvent(Evt.."ExitPreExterior", function(data)
    local source = source
    local property = Properties[data.id]
    if property then
        property:ExitPreExterior(source) 
    end
end)


RegisterServerEvent(Evt.."EnterExterior", function(data)
    local source = source
    local property = Properties[data.id]
    if property then
        property:EnterExterior(source) 
        clients[source] = {
            id = data.id,
            type = "exterior"
        } 
    end
end)

RegisterServerEvent(Evt.."ExitExterior", function(data)
    local source = source
    local property = Properties[data.id]
    if property then
        property:ExitExterior(source) 
        if clients[source].type == "exterior" then
            clients[source].type = "preExterior"
        end
    end
end)



RegisterServerEvent(Evt.."EnterApartment", function(data)
    local source = source
    local property = Properties[data.id]
    if property and (property.unlocked or hasPermission(source, data.id, "canEnter")) then
        clients[source] = {
            id = data.id,
            type = "interior"
        } 
        property:EnterApartment(source)
    end
end)

-- Break in --
RegisterServerEvent(Evt.."BreakIn", function(data)
    local source = source
    local property = Properties[data.id]
    if property and CanBreakIn(source, property.owner, property.permissions) then
        property:SetLockState(true)
    end
end)


RegisterServerEvent(Evt.."RingDoorbell", function(data)
    local source = source
    local property = Properties[data.id]
    property:RingDoorbell(source)
end)

RegisterServerEvent(Evt.."EnableDoorBellCam", function()
    local source = source
    local data = clients[source]
    if data and data.type == "interior" then
        local property = Properties[data.id]
        property:EnableDoorbellCam(source)
    end
end)

RegisterServerEvent(Evt.."DisableDoorbellCam", function()
    local source = source
    local data = clients[source]
    if data then
        local property = Properties[data.id]
        property:DisableDoorbellCam(source, data.type)
    end
end)

RegisterServerEvent(Evt.."UnlockDoorForSeconds", function(data)
    local source = source
    local clientData = clients[source]
    if data or clientData and clientData.type == "interior" then
        local id = data ~= nil and data.id or clientData.id
        local property = Properties[id]
        if property then
            property:UnlockForSeconds()
        end
    end
end)

RegisterServerEvent(Evt.."UnlockDoor", function(data)
    local source = source
    local clientData = clients[source]
    if data or clientData and clientData.type == "interior" then
        local id = data ~= nil and data.id or clientData.id
        local property = Properties[id]
        if property then
            property:SetLockState(true)
        end
    end
end)

RegisterServerEvent(Evt.."LockDoor", function(data)
    local source = source
    local clientData = clients[source]
    if data or clientData and clientData.type == "interior" then
        local id = data ~= nil and data.id or clientData.id
        local property = Properties[id]
        if property then
            property:SetLockState(false)
        end
    end
end)
----------------------------------------

RegisterServerEvent(Evt.."ExitApartment", function(data)
    local source = source
    local property = Properties[data.id]
    if property then
        property:ExitApartment(source)

        if clients[source].type == "interior" then
            clients[source] = nil
        end
    end
end)


RegisterServerEvent(Evt.."EnterGarage", function(data)
    local source = source
    local property = Properties[data.id]
    if property and (property.unlocked or hasPermission(source, data.id, "canEnter")) then
        local success = property:EnterGarage(source)
        if success then
            clients[source] = {
                id = data.id,
                type = "interior"
            } 
        end
    end
end)

RegisterServerEvent(Evt.."ExitGarage", function(data)
    local source = source
    local property = Properties[data.id]
    if property then
        property:ExitGarage(source)
        if clients[source].type == "interior" then
            clients[source] = nil
        end
    end
    SendDataToClient("ExitGarage", source)
end)

RegisterServerEvent(Evt.."GetProperties", function(data)
    SendDataToClient("RegisterProperties", source, PropertiesBaseData)
end)

RegisterServerEvent(Evt.."GetPropertyMenuData", function()
    local source = source
    local clientData = clients[source]

    if clientData and clientData.type ~= "preExterior" and Properties[clientData.id] then
        if hasPermission(source, clientData.id, "canOpenPropertyMenu") then
            local property = Properties[clientData.id]
            local permission = property:GetPermissionLevel(source)
            SendDataToClient("GetPropertyMenuData", source, permission ~= nil and  {
                space = clientData.type,
                level = permission,
                permissions = property.permissions,
                owner = property.owner
            } or false)

            return
        end
    end

    SendDataToClient("GetPropertyMenuData", source, false)
 end)


 --------------------- Furniture ---------------------

local function handleFurniture(action, source, data)
    local property = Properties[data.id]
    if property then
        property[action](property, source, data)
    end
end

RegisterServerEvent(Evt.."ModifyFurniture", function(data) handleFurniture("ModifyFurniture", source, data) end)
RegisterServerEvent(Evt.."RemoveFurniture", function(data) handleFurniture("RemoveFurniture", source, data) end)

RegisterServerEvent(Evt.."AddFurniture", function(data)
    local clientData = clients[source]
    local propertyId = clientData.id
    
    if propertyId then
        if not hasPermission(source, propertyId, "canDecorate") then return end
        data.id = propertyId
        if not data.isStorage then
            handleFurniture("AddFurniture", source, data)
        else
            local storageData = StorageData[data.model]
            if storageData then
                if TryRemoveMoney(source, storageData.price) then
                    handleFurniture("AddFurniture", source, data)
                end
            end
        end
    end
end)

------------------------------------------------------

RegisterServerEvent(Evt.."OpenStorage", function(data)

    local source = source
    local clientData = clients[source]

    if not clientData then return end

    if not data then return end

    local propertyId = data.propertyId
    local furnitureId = data.furnitureId

    if propertyId ~= clientData.id then return end

    if not hasPermission(source, propertyId, "canOpenStorage") then return end

    Bridge.OpenStorage(source, propertyId.."-"..furnitureId, data.model)
end)

------------------------------------------------------
---------------------------------------------------------
---- PERMISSIONS ------
------------------------------------------------------
function SetPropertyOwner(identifier, propertyId)
    local property = Properties[propertyId]
    if property then
        property:SetOwner(identifier)
    end
end

RegisterServerEvent(Evt.."SetPermission", function(data)
    local source = source
    local clientData = clients[source]
    if not clientData then return end
    if not data then return end
    local propertyId = clientData.id

    if not hasPermission(source, propertyId, "canGivePermissions") then return end
    local property = Properties[propertyId]
    if not property then return end
    property:SetPermission(data)
end)


RegisterServerEvent(Evt.."RemovePermission", function(data)
    local source = source
    local clientData = clients[source]
    if not clientData then return end
    if not data then return end
    local propertyId = clientData.id

    if not hasPermission(source, propertyId, "canGivePermissions") then return end
    local property = Properties[propertyId]
    if not property then return end
    property:RemovePermission(data)
end)
---------------------------------------------------------
---------------------------------------------------------

function AddNewProperty(source, data)
    Database.CreateProperty(data,function(data)
        addProperty(data)
        SendDataToClient("RegisterProperty", -1, PropertiesBaseData[data.id])
        SendDataToClient("Notification", source, GetLocale("PROPERTY_CREATED"), 6000, true)
    end)
end

function UpdateProperty(source, data)
    updateProperty(data)
    Database.UpdateProperty(data)
    SendDataToClient("Notification", source, data.street.. " "..GetLocale("PROPERTY_UPDATED"), 6000, true)
end

function AddNewApartment(source, data)
    Database.CreateProperty(data,function(data)
        addProperty(data)
        SendDataToClient("RegisterProperty", -1, PropertiesBaseData[data.id])
        SendDataToClient("Notification", source, GetLocale("APARTMENT_IS_READY"), 6000, true)
    end)
end



function PlayerEnteredVehicle(source, vehicle)
    local clientData = clients[source]
    if clientData and clientData.type == "interior" then
        local propertyId = clientData.id
        if propertyId then
            if Properties[propertyId] then
                Properties[propertyId]:EnteredVehicle(source, vehicle)
            end
        end
    end
end

function PlayerExitedVehicle(source, vehicle)
    local clientData = clients[source]
    if clientData and clientData.type == "interior" then
        local propertyId = clientData.id
        if Properties[propertyId] then
            Properties[propertyId]:ExitedVehicle(source, vehicle)
        end
    end
end

function CanBreakIn(source, owner, permissions)
    return GetJobName(source) == "police"
end

Wait(1000)
loadProperties()