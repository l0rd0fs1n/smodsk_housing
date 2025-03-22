-- SpawnGrid.lua
SpawnGrid = {
    reserved = {},
    position = Config.shellMlo.position,

    cellSize = 100,
    gridSize = Config.shellMlo.size,
    gridHeight = Config.shellMlo.height,

    cells = {},
    layers = {},
}

-- Function to initialize SpawnGrid (only called once)
function SpawnGrid.Initialize()
    local halfGrid = SpawnGrid.gridSize / 2
    local halfCell = SpawnGrid.cellSize / 2
    local index = 1

    for x = -halfGrid, halfGrid - SpawnGrid.cellSize, SpawnGrid.cellSize do
        for y = -halfGrid, halfGrid - SpawnGrid.cellSize, SpawnGrid.cellSize do
            SpawnGrid.cells[index] = vec3(
                SpawnGrid.position.x + x + halfCell,
                SpawnGrid.position.y + y + halfCell,
                SpawnGrid.position.z - SpawnGrid.gridHeight / 2
            )
            index = index + 1
        end
    end
end

function SpawnGrid.GetTempSpawnPoint()
    local cell = SpawnGrid.cells[1]
    local padding = 2
    if not cell then return nil end

    local x = cell.x + math.random(-SpawnGrid.cellSize / 2 + padding, SpawnGrid.cellSize / 2 - padding)
    local y = cell.y + math.random(-SpawnGrid.cellSize / 2 + padding, SpawnGrid.cellSize / 2 - padding)
    local z = cell.z + math.random(-2, 2)

    return vec3(x, y, z)
end

function SpawnGrid.GetPosition(index)
    return SpawnGrid.cells[index]
end


function SpawnGrid.Get()
    while true do 
        local bucket = 1
        if not SpawnGrid.reserved[bucket] then SpawnGrid.reserved[bucket] = {} end
        for i = 4, #SpawnGrid.cells do
            if not SpawnGrid.reserved[bucket][i] then
                SpawnGrid.reserved[bucket][i] = true
                return i, bucket
            end
        end

        bucket = bucket + 1
    end
end

function SpawnGrid.Release(bucket, index)
    if not SpawnGrid.reserved[bucket] then return end
    SpawnGrid.reserved[bucket][index] = nil
end


SpawnGrid.Initialize()

-- Debugging for client-side only
if not IsDuplicityVersion() then
    function SpawnGrid.Debug()
        CreateThread(function()
            while true do 
                for i = 2, #SpawnGrid.cells do
                    local coords = SpawnGrid.cells[i]
                    DrawMarker(28, coords.x, coords.y, coords.z, 0, 0, 0, 0, 0, 0, 5.0, 5.0, 5.0, 255, 0, 0, 255)
                end
                Wait(1)
            end
        end)
    end
end

return SpawnGrid
