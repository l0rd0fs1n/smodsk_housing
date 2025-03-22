local myType = "garage"
Garage = setmetatable({}, { __index = Base })
Garage.__index = Garage

function Garage:new(data, property)
    local obj = Base:new(myType)
    setmetatable(obj, self)

    obj.type = myType
    obj.door = Door:new(data)
    obj.vehiclesData = {}
    obj.vehicles = {}
    obj.property = property
    obj.furniture = Furniture:new(property, obj, Config.interiorPropLimit)

    return obj
end

function Garage:GetGridIndex()
    if #self.clients == 0 then
        local gridIndex, bucket = SpawnGrid.Get()
        self.spawnPosition = SpawnGrid.GetPosition(gridIndex)
        self.gridIndex = gridIndex
        self.bucket = bucket
    end
    return self.gridIndex
end

function Garage:Load()
    if #self.clients == 0 then
        self.vehiclesData = Database.GetVehicles(self.property.id)
    end
end

function Garage:GetVehicleCount()
    local count = 0
    for k,v in pairs(self.vehiclesData) do count += 1 end
    return count
end

-- This is needed when we have apartment and garage in same shell
function Garage:SetSpawnPosition(spawnPosition)
    self.spawnPosition = spawnPosition
end

function Garage:SetBucket(name)
    if #self.clients == 0 then
        self.shellName = name
        self.spawnPosition = vec3(0, 0, 0)
        self.bucket = MloBucketManager.Get(name)
    end
end


function Garage:EnteredVehicle(source, vehicle)
   FreezeEntityPosition(vehicle, false)
end

function Garage:SaveVehicle(vehicle, remove)
    if vehicle and DoesEntityExist(vehicle) and GetEntityType(vehicle) == 2 then
        local plate = GetVehicleNumberPlateText(vehicle)
        local coords = GetEntityCoords(vehicle) - self.spawnPosition
        local rotation = GetEntityRotation(vehicle, 2)

        if not remove then
            self.vehiclesData[plate] = {
                coords = VecToTable(coords),
                rot = VecToTable(rotation),
                model = GetEntityModel(vehicle)
            }
        else
            self.vehiclesData[plate] = nil
        end

        
        Database.SaveVehicles(self.property.id, self.vehiclesData)
    end
end

function Garage:ExitedVehicle(source, vehicle)
    FreezeEntityPosition(vehicle, vehicle)
   self:SaveVehicle(vehicle)
end


-- TODO set vehicle properties
function Garage:Enter(source, setBucket)
    Base.AddClient(self, source)
    self.furniture:SendToClient(source)

    local playerPed = GetPlayerPed(tostring(source))
    local vehicle = GetVehiclePedIsIn(playerPed, false)

    if setBucket then
        Bridge.SetPlayerBucket(source, self.bucket)
    end

    if vehicle and DoesEntityExist(vehicle) then
        OnVehicleEnterGarage(vehicle)
        Bridge.SetEntityBucket(vehicle, self.bucket)
        -- Ghost --
        self:SendToClients("Ghost", NetworkGetNetworkIdFromEntity(vehicle))
        SendDataToClient("Ghost", source, NetworkGetNetworkIdFromEntity(vehicle))
        ----------
    end

    if #self.clients == 1 then
        SpawnVehicles(source, self.vehiclesData, self.property.id, self.spawnPosition, function(vehicles)
            for i=1,#vehicles do
                self.vehicles[vehicles[i]] = true 
            end

            for i=1,#self.clients do
                VehicleKeys.GiveKeys(self.clients[i], self.vehicles)
            end
        end)
    end

    if vehicle and DoesEntityExist(vehicle) then
        self.vehicles[vehicle] = true
        self:SaveVehicle(vehicle)
    end
    
    if #self.clients ~= 1 then
        VehicleKeys.GiveKeys(source, self.vehicles)
    end
    --------------------------
end


function Garage:Flush(vehicle)

    if vehicle then
        self.vehicles[vehicle] = nil
    end

    if #self.clients == 0 then
        for k,v in pairs(self.vehicles) do
            if DoesEntityExist(k) then
                DeleteEntity(k)
            end
        end

        if self.gridIndex then
            SpawnGrid.Release(self.bucket, self.gridIndex)
        else
            MloBucketManager.Release(self.shellName, self.bucket)
        end

        self.gridIndex = nil
        self.shellName = nil
        self.bucket = nil
        self.vehicles = {}
    end
end

function Garage:Exit(source)
    Base.RemoveClient(self, source, true)

    local playerPed = GetPlayerPed(tostring(source))
    local vehicle = GetVehiclePedIsIn(playerPed, false)

    self:Flush(vehicle)
    Bridge.SetPlayerBucket(source, 0)
    if vehicle ~= 0 and DoesEntityExist(vehicle) then

        OnVehicleExitGarage(vehicle)
        
        self:SaveVehicle(vehicle, true)

        -- Ghost --
        local pos = vec3(self.door.doorPosition.x, self.door.doorPosition.y, self.door.doorPosition.z)
        local players = GetClosestPlayers(source, pos, 10.0, true)
        for i=1,#players do 
            SendDataToClient("Ghost", players[i], NetworkGetNetworkIdFromEntity(vehicle))
        end
        SendDataToClient("Ghost", source, NetworkGetNetworkIdFromEntity(vehicle))
        ----------

        Bridge.SetEntityBucket(vehicle, 0)
    end

    
    VehicleKeys.RemoveKeys(source, self.vehicles)
end

function Garage:SendToClients(event, ...)
    Base.SendToClients(self, event, ...)
end