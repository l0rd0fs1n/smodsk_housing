Furniture = {}
Furniture.__index = Furniture

function Furniture:new(parent)
    local obj = {
        propData = {},
        parent = parent
    }

    setmetatable(obj, self)
    return obj
end

function Furniture:AddGroup(data)
    for k,v in pairs(data.data.furnitures) do 
        self:Add({
            id = data.id,
            type = data.type,
            data = {
                chunkId = data.data.chunkId,
                id = k,
                furniture = v
            }
        }) 
    end
end

function Furniture:Add(data)
    local model = data.data.furniture.model
    local coords = TableToVec(data.data.furniture.coords) + (self.parent.spawnPosition or vec3(0, 0, 0))
    local rotation = TableToVec(data.data.furniture.rot)
    local prop = CreateProp(model, coords, rotation)
    local propData = {
        prop = prop,
        data = data
    }
    self.propData[data.data.id] = propData
    PropPool.Add(prop, data)
end

function Furniture:Remove(data)
    if not data.data or not data.data.id then return end
    local propData = self.propData[data.data.id]
    if propData then
        PropPool.Remove(propData.prop)
        DeleteEntity(propData.prop)
        self.propData[data.data.id] = nil
    end

   
end

function Furniture:Modify(data)
    if not data.data or not data.data.id then return end
    local propData = self.propData[data.data.id]
    if propData then

        local coords = TableToVec(data.data.furniture.coords) + (self.parent.spawnPosition or vec3(0, 0, 0))
        local rotation = TableToVec(data.data.furniture.rot)

        local oldModel = propData.data.data.furniture.model 
        oldModel = type(oldModel) == "string" and GetHashKey(oldModel) or oldModel

        local model = data.data.furniture.model
        model = type(model) == "string" and GetHashKey(model) or model

        if oldModel ~= model then
            PropPool.Remove(propData.prop)
            local prop = CreateProp(model, coords, rotation)

            local propData = {
                prop = prop,
                data = data
            }

            self.propData[data.data.id] = propData
            PropPool.Add(prop, data)
        else 
            SetEntityCoords(propData.prop, coords.x, coords.y, coords.z, false, false, false, false)
            SetEntityRotation(propData.prop, rotation.x, rotation.y, rotation.z, 2, false)
        end
    end
end

function Furniture:Flush()
    if self.propData then
        for k,v in pairs(self.propData) do
            PropPool.Remove(v.prop)
            DeleteEntity(v.prop)
        end
    end
    self.propData = {}
end