local myType = "exterior"

Exterior = setmetatable({}, { __index = Base })
Exterior.__index = Exterior

local function calculateCornersAndZ(coords)
    local avgZ = 0.0
    local corners = {}
    for i=1,#coords do 
        corners[i] = vec3(coords[i].x, coords[i].y, coords[i].z)
        avgZ+= coords[i].z
    end

    return corners, avgZ / #coords
end

function Exterior:new(data, property)
    local obj = Base:new(myType)
    local corners, avgZ = calculateCornersAndZ(data)
    obj.avgZ = avgZ
    obj.type = myType
    obj.corners = corners
    obj.property = property
    obj.furniture = Furniture:new(property, obj, Config.exteriorPropLimit, function(...) return obj:PositionValidator(...) end)
    setmetatable(obj, self)
    return obj
end

function Exterior:Update(data)
    local corners, avgZ = calculateCornersAndZ(data)
    self.corners = corners
    self.avgZ = avgZ
end

function Exterior:PositionValidator(data)
    local distanceZ = math.abs(self.avgZ - data.coords.z)
    if distanceZ > Config.exteriorPropMaxHeight then return false end
    return PolyZone.IsPointInPolygon(data.coords, self.corners)
end

function Exterior:Enter(source)
    Base.AddClient(self, source)
    self.furniture:SendToClient(source)
end

function Exterior:Exit(source)
    Base.RemoveClient(self, source, true)
end

function Exterior:SendToClients(event, ...)
    Base.SendToClients(self, event, ...)
end