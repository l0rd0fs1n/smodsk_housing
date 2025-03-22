Garage = {}
Garage.__index = Garage

function Garage:new(property, coords)
    local obj = {
        property = property,
        door = DoorGarage:new(property, coords),
        shell = ShellMlo:new(property)
    }

    obj.furniture = Furniture:new(obj)

    setmetatable(obj, self)
    return obj
end

function Garage:Enter(data)
    if self.shell then
        -- If there is no gridIndex then we know that it's mlo
        self.spawnPosition = data.gridIndex and SpawnGrid.GetPosition(data.gridIndex) or vec3(0, 0, 0)
        local success = self.shell:Create(data, true, true)
        if not success then
            self:Exit()
            return
        end
        PlayerData.EnterApartment(self.door.exteriorDoorCoords)
    end
end

function Garage:Exit()
    RequestDataFromServer(Evt.."ExitGarage", {id = self.property.id}, function()
        local vehicle = GetVehiclePedIsIn(PlayerData.PlayerPed(), false)
        local exteriorDoorCoords = self.door.exteriorDoorCoords

        if vehicle and vehicle ~= 0 then
            Teleport.PlayerAndVehicle(PlayerData.PlayerPed(), vehicle, exteriorDoorCoords)
        else
            Teleport.Player(PlayerData.PlayerPed(), exteriorDoorCoords)
        end

        self.door:Remove()
        PlayerData.ExitApartment()
        self:Flush()
    end)
end

function Garage:Flush()
    if self.furniture then self.furniture:Flush() end
    if self.shell then self.shell:Flush() end
end

function Garage:Remove()
    if self.door then self.door:Remove() end
    self:Flush()
end


