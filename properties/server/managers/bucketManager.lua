MloBucketManager = {
    reserved = {}
}

function MloBucketManager.Get(name)
    if not MloBucketManager.reserved[name] then
        MloBucketManager.reserved[name] = {}
    end
    for bucket = 1, 128 do
        if not MloBucketManager.reserved[name][bucket] then
            MloBucketManager.reserved[name][bucket] = true
            return bucket
        end
    end
end

function MloBucketManager.Release(name, bucket)
    if MloBucketManager.reserved[name] then
        MloBucketManager.reserved[name][bucket] = nil
    end
end

