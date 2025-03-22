math.randomseed(os.time())

function SendDataToClient(event, source, ...)
    TriggerClientEvent(Evt..event, source, ...)
end

function VecToTable(vec)
    return {
        x = string.format("%.3f", vec.x),
        y = string.format("%.3f", vec.y),
        z = string.format("%.3f", vec.z),
        w = (vec.w ~= nil) and string.format("%.3f", vec.w) or nil
    }
end

function TableToVec(tbl)
    if tbl.w then
        return vec4(tonumber(tbl.x), tonumber(tbl.y), tonumber(tbl.z), tonumber(tbl.w))
    end
    return vec3(tonumber(tbl.x), tonumber(tbl.y), tonumber(tbl.z))
end

function GenerateUniqueId()
    local chars = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
    local id = ""
    
    for i = 1, 6 do
        local randIndex = math.random(1, #chars)
        id = id .. chars:sub(randIndex, randIndex)
    end
    
    return id
end

function WaitUntillNet(netId)
	local entity = NetworkGetEntityFromNetworkId(netId)
	local count = 1000
	while entity == 0 and count > 0  do
		entity = NetworkGetEntityFromNetworkId(netId)
		count = count - 1
		Wait(1)
	end
	return entity
end


function RequestDataFromClient(event, source, data, callback)
    local requestId = math.random(1, 999999)
    local serverEvent = event .. requestId
    local eventHandler
    data = data or {}
    
    local callBackTriggered = false

    eventHandler = RegisterServerEvent(serverEvent, function(receivedData)
        if not callBackTriggered then
            callBackTriggered = true
            if callback then
                callback(receivedData)
            end
            RemoveEventHandler(eventHandler)
        end
    end)
    
    TriggerClientEvent(event, source, data, serverEvent)

    SetTimeout(timeout or 15000, function()
        if not callBackTriggered then
            callBackTriggered = true
            RemoveEventHandler(eventHandler)
            if callback then
                callback(nil)
            end
        end
    end)
end
