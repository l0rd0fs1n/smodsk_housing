local polyZone = nil
local corners = {}

local function setPolyZone()
    if #corners >= 2 then
        local data = {
            points = corners,
            debug = true
        }
        if polyZone == nil then 
            polyZone = PolyZone.RegisterZone(data)
        else
            polyZone = PolyZone.SetZone(polyZone, data)
        end
    end
end


local function findClosestCorner(coords)
    local closestIndex = -1
    local closestDist = math.huge
    for i=1, #corners do
        local dist = #(corners[i] - coords)
        if dist < closestDist then
            closestDist = dist
            closestIndex = i
        end
    end
    return closestIndex
end

local function findClosestSegment(coords)
    local closestSegmentIndex = -1
    local closestDist = math.huge
    local closestPoint = nil

    local totalCorners = #corners

    for i = 1, totalCorners do
        -- Get current and next point (loop back to the first point if at the end)
        local a = corners[i]
        local b = corners[i % totalCorners + 1] -- Loops from last point to first

        local ab = b - a
        local ac = coords - a

        local abLengthSq = ab.x * ab.x + ab.y * ab.y
        local proj = (ac.x * ab.x + ac.y * ab.y) / abLengthSq

        proj = math.max(0, math.min(1, proj))
        local closest = a + (ab * proj)
        local dist = #(closest - coords)


        if dist < closestDist then
            closestDist = dist
            closestSegmentIndex = i % totalCorners + 1
            closestPoint = closest
        end
    end

    return closestSegmentIndex, closestPoint
end




function RaycastFromCamera(ignore)
    local screenWidth, screenHeight = GetActiveScreenResolution()
    local screenCenterX, screenCenterY = screenWidth / 2, screenHeight / 2
    
    local camCoords = GetGameplayCamCoord()
    local forwardVector = GetGameplayCamRot(0)
    forwardVector = vector3(
        -math.sin(math.rad(forwardVector.z)) * math.cos(math.rad(forwardVector.x)),
        math.cos(math.rad(forwardVector.z)) * math.cos(math.rad(forwardVector.x)),
        math.sin(math.rad(forwardVector.x))
    )
    
    local rayLength = 1000.0
    local targetCoords = camCoords + (forwardVector * rayLength)
    
    local rayHandle = StartShapeTestRay(camCoords.x, camCoords.y, camCoords.z, targetCoords.x, targetCoords.y, targetCoords.z, -1, ignore or PlayerPedId(), 0)
    local _, hit, hitCoords, surfaceNormal, materialHash, entityHit = GetShapeTestResultIncludingMaterial(rayHandle)


    return hit, hitCoords
end

function ExteriorCreator(coords)
    polyZone = nil
    corners = coords or {}
    for i=1,#corners do corners[i] = vec3(corners[i].x, corners[i].y, corners[i].z) end
    setPolyZone()

    InstructionalBtns.Setup({
        {Buttons.keys["ACCEPT"], GetLocale("ACCEPT")},
        {Buttons.keys["REMOVE_POINT"], GetLocale("REMOVE_POINT")},
        {Buttons.keys["ADD_MID_POINT"], GetLocale("ADD_MID_POINT")},
        {Buttons.keys["MOVE_POINT"], GetLocale("MOVE_POINT")},
        {Buttons.keys["ADD_POINT"], GetLocale("ADD_POINT")},
    })

    while true do

        InstructionalBtns.Draw()
        Buttons.Disable()

        local hit, coords = RaycastFromCamera()

        if IsDisabledControlJustReleased(0, Buttons.keys["ACCEPT"]) then
            break
        end

        if hit then
            
            DrawMarker(1, coords.x, coords.y, coords.z, 0, 0, 0, 0, 0, 0, 0.1, 0.1, 5.0, 255, 0, 255, 100, false, false, false, false)

            if IsDisabledControlJustReleased(0, Buttons.keys["MOVE_POINT"]) then
                -- Find the closest corner and replace it with new coords
                local closestIndex = findClosestCorner(coords)
                if closestIndex ~= -1 then
                    corners[closestIndex] = coords
                end
                setPolyZone()
            end

            if IsDisabledControlJustReleased(0, Buttons.keys["ADD_MID_POINT"]) then
                local closestIndex = findClosestSegment(coords)
                if closestIndex ~= -1 then
                    table.insert(corners, closestIndex, coords)
                end
                setPolyZone()
            end

            if IsDisabledControlJustReleased(0, Buttons.keys["REMOVE_POINT"]) then
                -- Find the closest corner and remove it
                local closestIndex = findClosestCorner(coords)
                if closestIndex ~= -1 then
                    table.remove(corners, closestIndex)
                end
                setPolyZone()
            end

            if IsDisabledControlJustReleased(0, Buttons.keys["ADD_POINT"]) then
                -- Add the new corner from raycast hit
                table.insert(corners, coords)
                setPolyZone()
            end
        end

        -- Draw the markers for corners if there are less than 2 corners
        if #corners < 2 then
            for i=1, #corners do
                local coords = corners[i]
                DrawMarker(1, coords.x ,coords.y, coords.z, 0, 0, 0, 0 ,0 ,0, 0.1, 0.1, 5.0, 255, 0, 255, 100, false, false, false, false)
            end
        end

        Wait(1)
    end

    InstructionalBtns.Remove()

    if polyZone then
        PolyZone.RemoveZone(polyZone)
    end
    return corners
end






