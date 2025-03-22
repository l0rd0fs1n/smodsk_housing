Exterior = {}
Exterior.__index = Exterior

function Exterior:new(property, cornerPoints)

    local corners = {}
    for i=1,#cornerPoints do corners[i] = vec3(cornerPoints[i].x, cornerPoints[i].y, cornerPoints[i].z) end

    local obj = {
        property = property,
        corners = corners,
    }

    obj.furniture = Furniture:new(obj)
    setmetatable(obj, self)
    obj:RegisterZone()
    return obj
end

function Exterior:Update(cornerPoints)
    self.corners = {}
    for i=1,#cornerPoints do 
        self.corners[i] = vec3(cornerPoints[i].x, cornerPoints[i].y, cornerPoints[i].z)
    end

    self:Remove()
    self:RegisterZone()
end

function Exterior:RegisterZone()
    if self.corners and #self.corners >= 3 then
        self.zoneId = PolyZone.RegisterZone({
            points = self.corners,
            maxPreDistance = 50,
            onEnter = function()
                TriggerServerEvent(Evt.."EnterExterior", {id = self.property.id})
            end,
            onExit = function()
                TriggerServerEvent(Evt.."ExitExterior", {id = self.property.id})
            end,
            onPreEnter = function()
                TriggerServerEvent(Evt.."EnterPreExterior", {id = self.property.id})
            end,
            onPreExit = function()
                TriggerServerEvent(Evt.."ExitPreExterior", {id = self.property.id})
                self.furniture:Flush()
            end
        })
    end
end

function Exterior:Remove()
    if self.furniture then self.furniture:Flush() end
    if self.zoneId then
        PolyZone.RemoveZone(self.zoneId)
    end
end

function Exterior:Flush()
   self:Remove()
end