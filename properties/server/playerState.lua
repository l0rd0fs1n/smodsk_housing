PlayerState = {}

function PlayerState.Enter(source, exteriorDoorPos)
    local identifier = GetIdentifier(source)
    SetResourceKvp(identifier, json.encode({exteriorDoorPos.x, exteriorDoorPos.y, exteriorDoorPos.z, exteriorDoorPos.w}))
end

function PlayerState.Exit(source)
    local identifier = GetIdentifier(source)
    DeleteResourceKvp(identifier)
end

function PlayerState.Get(source)
    local identifier = GetIdentifier(source)
    local data = GetResourceKvpString(identifier)
    if data then
        data = json.decode(data)
        PlayerState.Exit(source)
        return vec4(data[1], data[2], data[3], data[4])
    end
    return false
end

RegisterServerEvent(Evt.."GetLastPosition", function()
    local position = PlayerState.Get(source)
    SendDataToClient("GetLastPosition", source, position)
end)