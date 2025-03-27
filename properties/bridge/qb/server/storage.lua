-- ox_inventory does not provide a direct option to remove a stash, and since data can still be saved after storage removal, 
-- we cannot simply delete the stash from the database when a player removes storage.
--
-- Plan:
-- 1. Store the storage IDs in Kvp.
-- 2. On server startup, check the stored IDs and remove the corresponding storages.
-- This may still leave data in the database if the script is restarted.


local surfix = "-property"

Bridge.qb.Storage = {
    registeredStorages = {},
    removedStorages = {},
}

function Bridge.qb.Storage.Remove(id)
    local storageId = id..surfix
    Bridge.ox.Storage.removedStorages[storageId] = true
    SetResourceKvp("storageIds", json.encode(Bridge.ox.Storage.removedStorages))
end

function Bridge.qb.Storage.Open(source, id, model)
    local storageId = id..surfix
    if Bridge.ox.Storage.removedStorages[storageId] then return end

    local storageData = StorageData[model]
    if not storageData then return end

    local name = storageData.name or GetLocale("STORAGE")
    local slots = storageData.slots or 20
    local weight = storageData.weight or 10000000

    local data = { label = name, maxweight = weight, slots = slots }
    exports['qb-inventory']:OpenInventory(source, storageId, data)
end

Wait(1000)

if qb_inventory then
    local storageString = GetResourceKvpString("storageIds")
    if storageString then
        local storageIds = json.decode(storageString)
        if type(storageIds) == "table" then
            for storageId, value in pairs(storageIds) do
                MySQL.Async.execute("DELETE FROM inventories WHERE identifier = ?", {storageId})
            end
        end
        SetResourceKvp("storageIds", json.encode({}))
    end
end