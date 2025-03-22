-- Yep, I use my own server callback function so I can create easier scripts that work with multiple frameworks.
function RequestDataFromServer(event, data, callback)
    local eventHandler

    data = data or {}  
    eventHandler = RegisterNetEvent(event, function(receivedData)
        if callback then
            callback(receivedData)
        end
        RemoveEventHandler(eventHandler)
    end)
    
    TriggerServerEvent(event, data)
end

function TableToVec(tbl)
    if tbl.w then
        return vec4(tonumber(tbl.x), tonumber(tbl.y), tonumber(tbl.z), tonumber(tbl.w))
    end
    return vec3(tonumber(tbl.x), tonumber(tbl.y), tonumber(tbl.z))
end

function ForceToNet(veh)
    local ticks = 500
    while not NetworkGetEntityIsNetworked(veh) and ticks > 0 do
        ticks = ticks - 1
        Wait(1)
    end
    return VehToNet(veh)
end


function LoadModel(model)
    local propHash = type(model) == "string" and GetHashKey(model) or model
    if propHash == nil then return false, false end
    RequestModel(propHash)
    local ticks = 30
    while not HasModelLoaded(propHash) and ticks > 0 do
        ticks = ticks - 1
        Wait(5)
    end

    return HasModelLoaded(propHash), propHash
end

function CreateProp(propName, position, rotation)
    if propName == nil then return end
    local loaded, propHash = LoadModel(propName)
    if loaded then
        local prop = CreateObject(propHash, position.x, position.y, position.z, false, false, false)
        SetEntityAsMissionEntity(prop, true, true)
        SetEntityCoords(prop, position.x, position.y, position.z)
        SetEntityRotation(prop, rotation.x, rotation.y, rotation.z, 2)
        FreezeEntityPosition(prop, true, true)
        SetModelAsNoLongerNeeded(propHash)

        return prop
    else
        print("UNABLE TO LOAD MODEL ", propName)
    end
    return nil
end

function GenerateUniqueId()
    math.randomseed(GetGameTimer())
    local chars = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
    local id = ""
    
    for i = 1, 6 do
        local randIndex = math.random(1, #chars)
        id = id .. chars:sub(randIndex, randIndex)
    end
    
    return id
end

function DeepCopy(orig, copies)
    copies = copies or {}
    if type(orig) ~= "table" then
        return orig
    elseif copies[orig] then
        return copies[orig]
    end

    local copy = {}
    copies[orig] = copy

    for orig_key, orig_value in pairs(orig) do
        copy[orig_key] = DeepCopy(orig_value, copies)
    end

    return copy
end
