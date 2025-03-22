PolyZone = {
    id = 0,
    zones = {},
    color = {
        r = 255,
        g = 0,
        b = 255,
        a = 100
    }
}

function PolyZone.IsPointInPolygon(point, polygon)
    local x, y = point.x, point.y
    local inside = false
    local n = #polygon
    local j = n
    for i = 1, n do
        local xi, yi = polygon[i].x, polygon[i].y
        local xj, yj = polygon[j].x, polygon[j].y
        local intersect = ((yi > y) ~= (yj > y)) and (x < (xj - xi) * (y - yi) / (yj - yi) + xi)
        if intersect then
            inside = not inside
        end
        j = i
    end
    return inside
end

if not IsDuplicityVersion() then

    function PolyZone.SetZone(id, data)
        local centroid = PolyZone.CalculateCentroid(data.points)
        local maxDistance = PolyZone.CalculateMaxDistance(centroid, data.points)
        PolyZone.zones[PolyZone.id] = {
            points = data.points,
            debug = data.debug,
            onEnter = data.onEnter,
            onExit = data.onExit,
            onPreEnter = data.onPreEnter,
            onPreExit = data.onPreExit,
            isIn = false,
            centroid = centroid,
            maxPreDistance = maxDistance + (data.maxPreDistance or 10.0),
            maxDistance = maxDistance
        }
        return id
    end


    function PolyZone.GetDistance(point1, point2)
        return math.sqrt((point2.x - point1.x)^2 + (point2.y - point1.y)^2)
    end

    function PolyZone.CalculateCentroid(polygon)
        local xSum, ySum = 0, 0
        local n = #polygon
        for _, point in pairs(polygon) do
            xSum = xSum + point.x
            ySum = ySum + point.y
        end
        return vec3(xSum / n, ySum / n, polygon[1].z)
    end

    function PolyZone.CalculateMaxDistance(centroid, points)
        local maxDistance = 0
        for _, point in pairs(points) do
            local dist = PolyZone.GetDistance(centroid, point)
            if dist > maxDistance then
                maxDistance = dist
            end
        end
        return maxDistance
    end



    function PolyZone.RegisterZone(data)
        PolyZone.id = PolyZone.id + 1
        return PolyZone.SetZone(PolyZone.id, data)
    end

    function PolyZone.RemoveZone(id)
        PolyZone.zones[id] = nil
    end

    CreateThread(function()
        while true do
            local debugs = false
            local wallHeight = 2

            for _, zone in pairs(PolyZone.zones) do
                if zone.debug then
                    debugs = true
                    for i = 1, #zone.points do
                        local p1 = zone.points[i]
                        local p2 = zone.points[i % #zone.points + 1]
                        local r, g, b, a = PolyZone.color.r, PolyZone.color.g, PolyZone.color.b, PolyZone.color.a

                        DrawLine(p1.x, p1.y, p1.z, p1.x, p1.y, p1.z + wallHeight, r, g, b, a)
                        DrawLine(p1.x, p1.y, p1.z + wallHeight, p2.x, p2.y, p2.z + wallHeight, r, g, b, a) 
                        DrawLine(p1.x, p1.y, p1.z, p2.x, p2.y, p2.z, r, g, b, a) 

                        DrawPoly(p2.x, p2.y, p2.z, p1.x, p1.y, p1.z + wallHeight, p1.x, p1.y, p1.z, r, g, b, a)
                        DrawPoly(p1.x, p1.y, p1.z, p1.x, p1.y, p1.z + wallHeight, p2.x, p2.y, p2.z, r, g, b, a)
                        DrawPoly(p2.x, p2.y, p2.z, p2.x, p2.y, p2.z + wallHeight, p1.x, p1.y, p1.z + wallHeight, r, g, b, a)
                        DrawPoly(p1.x, p1.y, p1.z + wallHeight, p2.x, p2.y, p2.z + wallHeight, p2.x, p2.y, p2.z, r, g, b, a) 
                    end
                end
            end

            if debugs then
                Wait(1)
            else
                Wait(1000)
            end
        end
    end)

    CreateThread(function()
        while true do
            local coords = PlayerData.Position()
            for _, zone in pairs(PolyZone.zones) do

                local distance = PolyZone.GetDistance(coords, zone.centroid)
                local isPreInside = distance <= zone.maxPreDistance
                if not zone.isPreIn and isPreInside then
                    zone.isPreIn = true
                    if zone.onPreEnter then zone.onPreEnter() end
                elseif zone.isPreIn and not isPreInside then
                    zone.isPreIn = false
                    if zone.onPreExit then zone.onPreExit() end
                end

                if distance <= zone.maxDistance then
                    local isInside = PolyZone.IsPointInPolygon(coords, zone.points)
                    if isInside and not zone.isIn then
                        zone.isIn = true
                        if zone.onEnter then zone.onEnter() end
                    elseif not isInside and zone.isIn then
                        zone.isIn = false
                        if zone.onExit then zone.onExit() end
                    end
                else
                    if zone.isIn then
                        zone.isIn = false
                        if zone.onExit then zone.onExit() end
                    end
                end
            end

            Wait(500)
        end
    end)

end