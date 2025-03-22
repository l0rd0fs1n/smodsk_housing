Base = {}
Base.__index = Base

function Base:new(type)
    local obj = {
        type = type,
        clients = {},
    }
    setmetatable(obj, self)
    return obj
end 

function Base:AddClient(source)
    local source = source
    table.insert(self.clients, source)
end

function Base:RemoveClient(source, flush)
    for i=1,#self.clients do
        if self.clients[i] == source then
            table.remove(self.clients, i)
            break
        end
    end
end

function Base:SendToClients(event, ...)
    if not self.clients then return end
    for i=1,#self.clients do
        SendDataToClient(event, self.clients[i], ...)
    end
end