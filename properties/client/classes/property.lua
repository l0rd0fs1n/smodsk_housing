Property = {}
Property.__index = Property




function Property:new(data)
    local obj = {
        id = data.id,
        seperateGarage = data.seperateGarage,
        owner = data.owner,
        permissions = data.permissions,
        street = data.street,
        location = data.location,
        apartmentId = data.apartmentId
    }

    -- We need to be able to have conversations between
    obj.garage = (data.garageDoor ~= nil) and Garage:new(obj, data.garageDoor) or nil
    obj.apartment = (data.door ~= nil) and Apartment:new(obj, data.door) or nil
    obj.exterior = (data.exterior ~= nil) and Exterior:new(obj, data.exterior) or nil

    setmetatable(obj, self)

    obj:Blip()

    return obj
end

function Property:GetFrontDoorCoords()
    if self.apartmentId then
        for i=1,#BasicApartments do
            if BasicApartments[i].id == self.apartmentId then
                return BasicApartments[i].door
            end
        end
    else
        return self.apartment.door.exteriorDoorCoords
    end
    return vec4(0, 0, 0, 0)
end

function Property:Blip(remove)
    -- Realtor does not need to see blips --
    if PlayerData.job.name == Config.realtorJobName then
        if self.owner == Config.realtorJobName then
            return
        end
    end

    BlipManager.Remove(self.id)
    if not remove then
        if CanEnter(self.owner, self.permissions) then
            local coords = self:GetFrontDoorCoords()
            BlipManager.Add(self.id, coords, self.street)
        end
    end
end

function Property:Remove()
    if self.garage then self.garage:Remove() end
    if self.apartment then self.apartment:Remove() end
    if self.exterior then self.exterior:Remove() end
    self:Blip(true)
end

function Property:Update(data)
    self.garage.door:Update(data.garageDoor)
    self.apartment.door:Update(data.door)
    self.exterior:Update(data.exterior)
    self.street = data.street
    self:Blip()
end

-- Shell/Mlo --
function Property:EnterApartment(data)
    self.seperateGarage = data.seperateGarage
    if self.apartment then
        data.shellData.apartment.gridIndex = data.gridIndex
        self.apartment:Enter(data.shellData.apartment)
    end
end

function Property:EnterGarage(data)
    self.seperateGarage = data.seperateGarage

    if self.seperateGarage then
        data.shellData.garage.gridIndex = data.gridIndex
        self.garage:Enter(data.shellData.garage)
    else
        data.shellData.apartment.gridIndex = data.gridIndex
        self.apartment:Enter(data.shellData.apartment, true)
    end
end
-----------

-- Permissions --
function Property:SetOwner(identifier)
    self.owner = identifier
    self:Blip()
end

function Property:SetPermissions(data)
    self.owner = data.owner
    self.permissions = data.permissions
    self:Blip()
end

function Property:SetLockState(state)
    self.unlocked = state
    DoorLockStateChanged(self:GetFrontDoorCoords())
end
----------------

-- Furniture --
function Property:HandleFurniture(action, data)
    local target = self[string.lower(data.type)]
    if target and target.furniture and target.furniture[action] then
        target.furniture[action](target.furniture, data.furniture)
    end
end

function Property:AddFurniture(data)
    local target = self[string.lower(data.type)]
    if target then
        target.furniture:Add(data)
    end
 end

function Property:AddFurnitureGroup(data) 
    local target = self[string.lower(data.type)]
    if target then
        target.furniture:AddGroup(data)
    end
end

function Property:RemoveFurniture(data)
    local target = self[string.lower(data.type)]
    if target then
        target.furniture:Remove(data)
    end
end
function Property:ModifyFurniture(data)
    local target = self[string.lower(data.type)]
    if target then
        target.furniture:Modify(data)
    end
end
---------------


function Property:Flush()
    if self == nil then return end
    if self.apartment then self.apartment:Flush() end
    if self.garage then self.garage:Flush() end
    if self.exterior then self.exterior:Flush() end
end