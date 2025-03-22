local myType = "apartment"
Apartment = setmetatable({}, { __index = Base })
Apartment.__index = Apartment

function Apartment:new(data, property)
    local obj = Base:new(myType)
    setmetatable(obj, self)
    
    obj.type = myType
    obj.door = Door:new(data)
    obj.property = property
    obj.furniture = Furniture:new(property, obj, Config.interiorPropLimit)

    return obj
end

function Apartment:Enter(source)
    Base.AddClient(self, source)
    self.furniture:SendToClient(source)
    Bridge.SetPlayerBucket(source, self.bucket)
end


function Apartment:GetGridIndex(t)
    if #self.clients == 0 then
        local gridIndex, bucket = SpawnGrid.Get()
        self.spawnPosition = SpawnGrid.GetPosition(gridIndex)
        self.gridIndex = gridIndex
        self.bucket = bucket
    end

    return self.gridIndex
end

function Apartment:SetBucket(name)
    if #self.clients == 0 then
        self.spawnPosition = vec3(0, 0, 0)
        self.shellName = name
        self.bucket = MloBucketManager.Get(name)
    end
end


function Apartment:Exit(source)
    Base.RemoveClient(self, source, true)
    if #self.clients == 0 then
        self.furniture:Flush()

        if self.gridIndex then
            SpawnGrid.Release(self.bucket, self.gridIndex)
        else
            MloBucketManager.Release(self.shellName, self.bucket)
        end

        self.gridIndex = nil
        self.shellName = nil
        self.bucket = nil
    end
    
    Bridge.SetPlayerBucket(source, 0)
end

function Apartment:SendToClients(event, ...)
    Base.SendToClients(self, event, ...)
end