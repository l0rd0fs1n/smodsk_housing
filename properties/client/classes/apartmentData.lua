Apartment = {}
Apartment.__index = Apartment

function Apartment:new(property, coords)
    local obj = {
        property = property,
        door = DoorApartment:new(property, coords),
        shell = ShellMlo:new(property)
    }

    obj.furniture = Furniture:new(obj)

    setmetatable(obj, self)
    return obj
end

function Apartment:Enter(data, useGarageDoor)
    if self.shell then
        -- If there is no gridIndex then we know that it's mlo
        self.spawnPosition = data.gridIndex and SpawnGrid.GetPosition(data.gridIndex) or vec3(0, 0, 0)
        local success = self.shell:Create(data, useGarageDoor, false)
        if not success then
            self:Exit()
            return
        end

        PlayerData.EnterApartment(self.door.exteriorDoorCoords)
    end
end

function Apartment:Exit()
    TriggerServerEvent(Evt.."ExitApartment", {id = self.property.id})
    local playerPed = PlayerData.PlayerPed()
    local exteriorDoorCoords = self.door.exteriorDoorCoords
    SetEntityCoordsNoOffset(playerPed, exteriorDoorCoords.x, exteriorDoorCoords.y, exteriorDoorCoords.z, false, false, false)
    SetEntityHeading(playerPed, exteriorDoorCoords.w - 180)
    self.door:Remove()
    PlayerData.ExitApartment()
    self:Flush()
end

function Apartment:Flush()
    if self.furniture then self.furniture:Flush() end
    if self.shell then self.shell:Flush() end
end

function Apartment:Remove()
    if self.door then self.door:Remove() end
    self:Flush()
end