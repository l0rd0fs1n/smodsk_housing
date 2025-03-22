DoorGarage = {}
DoorGarage.__index = DoorGarage

function DoorGarage:new(property, coords)
    local obj = {
        property = property,
    }

    setmetatable(obj, self)

    if coords and coords.x then
        obj:RegisterExteriorDoor(coords)
    end

    return obj
end

function DoorGarage:Update(coords)
    self:SetPosition(coords, true)
end

function DoorGarage:RegisterInteriorDoor(coords)
    self.interiorPoint = coords
    if not coords then return end
    self.interiorDoor = RegisterInteriorDoorGarage(self.property, coords, self.exteriorDoorCoords)
end

function DoorGarage:RegisterExteriorDoor(coords)
    self.exteriorDoorCoords = coords
    if not coords then return end
    self.exteriorDoor = RegisterExteriorDoorGarage(self.property, coords)
end

function DoorGarage:Remove(isExterior)
    if isExterior and self.exteriorDoor then
        Bridge.RemoveTargetBox(self.exteriorDoor)
        self.exteriorDoor = nil
    elseif not isExterior and self.interiorDoor then
        Bridge.RemoveTargetBox(self.interiorDoor)
        self.interiorDoor = nil
    end
end


function DoorGarage:SetPosition(coords, isExterior)
    if not isExterior then
        if self.interiorDoor then Bridge.RemoveTargetBox(self.interiorDoor) end
        if not coords or not coords.x then return end
        self.interiorPoint = coords
        self.interiorDoor = RegisterInteriorDoorGarage(self.property, coords)
    else
        Bridge.RemoveTargetBox(self.exteriorDoor)
        if not coords or not coords.x then return end
        self.exteriorDoorCoords = coords
        self.exteriorDoor = RegisterExteriorDoorGarage(self.property, coords)
    end
end