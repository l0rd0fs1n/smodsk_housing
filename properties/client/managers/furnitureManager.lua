-- We need to make sure players don't place storages outside the shells.
FurnitureManager = {}

function FurnitureManager.ValidateStoragePosition(prop)
    local player = PlayerData.PlayerPed()
    local playerCoords = PlayerData.Position()
    local propCoords = GetEntityCoords(prop)

    -- Ensure the prop exists
    if not DoesEntityExist(prop) then
        return false
    end

    local rayHandle = StartShapeTestRay(playerCoords.x, playerCoords.y, playerCoords.z, propCoords.x, propCoords.y, propCoords.z, -1, PlayerPedId(), 0)
    local _, hit1, hitCoords1, surfaceNormal, materialHash, entityHit1 = GetShapeTestResultIncludingMaterial(rayHandle)
    Wait(50)
    local rayHandle = StartShapeTestRay(playerCoords.x, playerCoords.y, playerCoords.z, propCoords.x, propCoords.y, propCoords.z, -1, PlayerPedId(), 0)
    local _, hit2, hitCoords2, surfaceNormal, materialHash, entityHit2 = GetShapeTestResultIncludingMaterial(rayHandle)
    return (hit1 and entityHit1 == prop) and (hit2 and entityHit2 == prop)
end



function FurnitureManager.AddFurniture()
    local prop = exports["prop_selector"]:Open({
        blocked = BlockedModels
    })
    if prop then
        TriggerServerEvent(Evt.."AddFurniture", {
            furniture = {
                model = GetEntityModel(prop),
                coords = GetEntityCoords(prop),
                rot = GetEntityRotation(prop, 2)
            }
        })

        DeleteEntity(prop)
    end
end

-- Removing storage triggers this also
function FurnitureManager.RemoveFurniture(entity)
    local propData = PropPool.Get(entity)
    if propData then
        TriggerServerEvent(Evt.."RemoveFurniture", {
            id = propData.id,
            type = propData.type,
            data = {
                chunkId = propData.data.chunkId,
                id = propData.data.id,
                furniture = {}
            }
        })
    end
end

function FurnitureManager.ModifyFurniture(entity)

    local prop = exports["prop_selector"]:Open({
        prop = entity,
    })

    if not prop then return end

    local propData = PropPool.Get(entity)

    if propData then
        TriggerServerEvent(Evt.."ModifyFurniture", {
            id = propData.id,
            type = propData.type,
            data = {
                chunkId = propData.data.chunkId,
                id = propData.data.id,
                furniture = {
                    model = GetEntityModel(prop),
                    coords = GetEntityCoords(prop),
                    rot = GetEntityRotation(prop, 2),
                }
            }
        })

        if prop ~= entity then
            DeleteEntity(prop)
        end
    end
end


function FurnitureManager.BuyStorage()
    local prop = exports["prop_selector"]:Open({
        categories = Storages.categories,
        furniture = Storages.furniture,
    })

    if prop then
        if FurnitureManager.ValidateStoragePosition(prop) then
            TriggerServerEvent(Evt.."AddFurniture", {
                furniture = {
                    model = GetEntityModel(prop),
                    coords = GetEntityCoords(prop),
                    rot = GetEntityRotation(prop, 2),
                    isStorage = true
                }
            })
        end

        DeleteEntity(prop)
    end
end

function FurnitureManager.MoveStorage(entity)
    local position = GetEntityCoords(entity)
    local rotation = GetEntityRotation(entity, 2)

    local prop = exports["prop_selector"]:Open({
        prop = entity,
        categories = {
            {name = "empty", label = "empty"}
        },
        furniture = {
            ["empty"] = {
                margin = 1.0,
                models = {
                    GetEntityModel(entity)
                }
                
            }
        },
    })

    if not prop then return end

    local propData = PropPool.Get(entity)
    if propData then

        if FurnitureManager.ValidateStoragePosition(prop) then
            TriggerServerEvent(Evt.."ModifyFurniture", {
                id = propData.id,
                type = propData.type,
                data = {
                    chunkId = propData.data.chunkId,
                    id = propData.data.id,
                    furniture = {
                        model = GetEntityModel(prop),
                        coords = GetEntityCoords(prop),
                        rot = GetEntityRotation(prop, 2),
                    }
                }
            })
        else
            SetEntityCoordsNoOffset(entity, position.x, position.y, position.z, false, false, false)
            SetEntityRotation(entity, rotation.x, rotation.y, rotation.z, 2, false)
        end

        if prop ~= entity then
            DeleteEntity(prop)
        end    
    end
end

function FurnitureManager.OpenStorage(entity)
    local propData = PropPool.Get(entity)
    if not propData then print("Missing prop data") return end
    if not propData.data.furniture.isStorage then print("propData.data.furniture.isStorage") return end
    TriggerServerEvent(Evt.."OpenStorage", {
        propertyId = propData.id,
        furnitureId = propData.data.id,
        model = propData.data.furniture.model
    })
end