Furniture = {}
Furniture.__index = Furniture

function Furniture:new(property, parent, limit, positionValidator)
    local obj = {
        furniture = {},
        property = property,
        parent = parent,
        limit = limit,
        positionValidator = positionValidator
    }

    setmetatable(obj, self)
    return obj
end

function Furniture:FindFreeChunkId()
    for k,v in pairs(self.furniture) do
        if #v < Config.dataStorage.furniture.chunkSize  then
            return k, false
        end
    end
    return GenerateUniqueId(), true
end

function Furniture:GetCount()
    local count = 0
    for k,v in pairs(self.furniture) do
        for _, j in pairs(v) do
            count += 1
        end
    end
    return count
end

function Furniture:Add(source, data)

    if self:GetCount() >= self.limit then
        SendDataToClient("Notification", source, GetLocale("PROP_LIMIT"), 6000, false)
        return
    end

    if self.positionValidator and not self.positionValidator(data) then
        SendDataToClient("Notification", source, GetLocale("INVALID_POSITION"), 6000, false)
        return
    end

   local id = GenerateUniqueId()
   local furniture = {
        model = data.model,
        coords = VecToTable(data.coords - (self.parent.spawnPosition or vec3(0, 0, 0))),
        rot = VecToTable(data.rot),
        isStorage = data.isStorage
   }


   local chunkId, isNew = self:FindFreeChunkId()
   if isNew then self.furniture[chunkId] = {} end
   self.furniture[chunkId][id] = furniture

   self.parent:SendToClients("AddFurniture", {
        id = self.property.id,
        type = self.parent.type,
        data = {
            id = id,
            chunkId = chunkId,
            furniture = furniture,
        }
    })

    Database.UpdateFurniture({
        propertyId = self.property.id,
        type = self.parent.type,
        chunkId = chunkId,
        furniture = self.furniture[chunkId]
    })
end

function Furniture:Remove(source, data)

    local oldData = self.furniture[data.chunkId] ~= nil and self.furniture[data.chunkId][data.id] or nil
    if not oldData then return end

    if oldData then
        self.furniture[data.chunkId][data.id] = nil

        if oldData.isStorage then
            Bridge.RemoveStorage(self.property.id.."-"..data.id)
        end

        Database.UpdateFurniture({
            propertyId = self.property.id,
            type = self.parent.type,
            chunkId = data.chunkId,
            furniture = self.furniture[data.chunkId]
        })

        self.parent:SendToClients("RemoveFurniture", 
        {
            id = self.property.id,
            type = self.parent.type,
            data = {
                id = data.id,
            }
        })
    end

    
end

function Furniture:Modify(source, data)

    local oldData = self.furniture[data.chunkId] ~= nil and self.furniture[data.chunkId][data.id] or nil
    if not oldData then return end

    if self.positionValidator and not self.positionValidator(data.furniture) then
        SendDataToClient("ModifyFurniture", source, {
            id = self.property.id,
            type = self.parent.type,
            data = {
                id = data.id,
                chunkId = data.chunkId,
                furniture = oldData,
            }
        })

        SendDataToClient("Notification", source, GetLocale("INVALID_POSITION"), 6000, false)
        return
    end

    -- Lets prevent model changes if this was storage --
    local furniture = {
        model = oldData.isStorage and oldData.model or data.furniture.model,
        coords = VecToTable(data.furniture.coords - (self.parent.spawnPosition or vec3(0, 0, 0))),
        rot = VecToTable(data.furniture.rot),
        isStorage = oldData.isStorage
    }

    if self.furniture[data.chunkId] then
        self.furniture[data.chunkId][data.id] = furniture
        Database.UpdateFurniture({
            propertyId = self.property.id,
            type = self.parent.type,
            chunkId = data.chunkId,
            furniture = self.furniture[data.chunkId]
        })
    end

    self.parent:SendToClients("ModifyFurniture", {
        id = self.property.id,
        type = self.parent.type,
        data = {
            id = data.id,
            chunkId = data.chunkId,
            furniture = furniture,
        }
    })
end

function Furniture:SendToClient(source)
    -- A better way would be to retrieve the information only after the player has teleported into the MLO, but I guess a second of waiting is enough for even the worst machines.
    Wait(1000)

    if not self.loaded then
        self.loaded = true
        self.furniture = Database.GetFurniture(self.property.id, self.parent.type)
    end

    local chunks = {}
    for k,v in pairs(self.furniture) do table.insert(chunks, k) end
    for i=1,#chunks do
        local chunkId = chunks[i]
        local data = self.furniture[chunkId]
        SendDataToClient("AddFurnitureGroup", source, {
            id = self.property.id,
            type = self.parent.type,
            data = {
                chunkId = chunkId,
                furnitures = data,
            } 
        })
        Wait(50)
    end
end

function Furniture:Flush()
    self.loaded = false
    self.furniture = {}
end
