DoorApartment = {}
DoorApartment.__index = DoorApartment

function DoorApartment:new(property, coords)
    local obj = {
        property = property,
    }
    setmetatable(obj, self)


    if coords and coords.x and not property.apartmentId then
        obj:RegisterExteriorDoor(coords)
    else
        if property.apartmentId then
            for i=1,#BasicApartments do
                if BasicApartments[i].id == property.apartmentId then
                    self.exteriorDoorCoords = BasicApartments[i].door
                    break
                end
            end
        end 
    end

    return obj
end

function DoorApartment:Update(coords)
    self:SetPosition(coords, true)
end


function DoorApartment:RegisterInteriorDoor(coords)
    self.interiorPoint = coords
    if not coords then return end
    self.interiorDoor = RegisterInteriorDoor(self.property, coords)
end

function DoorApartment:RegisterExteriorDoor(coords)
    self.exteriorDoorCoords = coords
    if not coords then return end
    self.exteriorDoor = RegisterExteriorDoor(self.property, coords)
end

function DoorApartment:Remove(isExterior)
    if isExterior and self.exteriorDoor then
        Bridge.RemoveTargetBox(self.exteriorDoor)
        self.exteriorDoor = nil
    elseif not isExterior and self.interiorDoor then
        Bridge.RemoveTargetBox(self.interiorDoor)
        self.interiorDoor = nil
    end
end

function DoorApartment:SetPosition(coords, isExterior)
    if not isExterior then
        if self.interiorDoor then Bridge.RemoveTargetBox(self.interiorDoor) end
        if not coords or not coords.x then return end
        self.interiorPoint = coords
        self.interiorDoor = RegisterInteriorDoor(self.property, coords)
    else
        Bridge.RemoveTargetBox(self.exteriorDoor)
        if not coords or not coords.x then return end
        self.exteriorDoorCoords = coords
        self.exteriorDoor = RegisterExteriorDoor(self.property, coords)
    end
end