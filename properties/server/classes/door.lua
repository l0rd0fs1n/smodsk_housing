Door = {}
Door.__index = Door

function Door:new(doorCoords)
    local obj = {
        doorPosition = doorCoords
    }
    setmetatable(obj, self)
    return obj
end

function Door:ChangePosition(coords)
    self.doorPosition = coords
end