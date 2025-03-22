function Bridge.OpenStorage(...)
    if ox_inventory then
        return Bridge.ox.Storage.Open(...)
    end
end

function Bridge.RemoveStorage(...)
    if ox_inventory then
        return Bridge.ox.Storage.Remove(...)
    end
end

function Bridge.SetPlayerBucket(source, bucket)
    SetPlayerRoutingBucket(source, bucket)
end

function Bridge.SetEntityBucket(entity, bucket)
    SetEntityRoutingBucket(entity, bucket)
end