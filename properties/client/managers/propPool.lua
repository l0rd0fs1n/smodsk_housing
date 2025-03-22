PropPool = {
    pool = {}
}

function PropPool.Add(prop, data)
    if not prop then return end
    PropPool.pool[prop] = data
end

function PropPool.Remove(prop)
    if not prop then return end
    PropPool.pool[prop] = nil
end

function PropPool.Get(prop)
    if not prop then return end
    return PropPool.pool[prop]
end



