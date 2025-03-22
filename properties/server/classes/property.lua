Property = {}
Property.__index = Property

function Property:new(data)
    local id = data.id
    local shellData = data.shellData
    local door = data.door
    local garageDoor = data.garageDoor
    local exterior = data.exterior
    local seperateGarage = shellData.apartment and shellData.garage


    local obj = {
        id = id,
        shellData = shellData,
        seperateGarage = seperateGarage,
        clients = {},
        owner = data.owner,
        permissions = data.permissions,
        atDoor = {},
        routingBucket = 1,
        apartmentId = data.apartmentId
    }

    setmetatable(obj, self)

    obj.garage = (garageDoor ~= nil) and Garage:new(garageDoor, obj) or nil
    obj.apartment = (door ~= nil) and Apartment:new(door, obj) or nil
    obj.exterior = (exterior ~= nil) and Exterior:new(exterior, obj) or nil

    return obj
end

function Property:Update(data)
    self.shellData = data.shellData
    self.exterior:Update(data.exterior)
end

-- Send exterior data for client
function Property:EnterPreExterior(source)
    self.exterior:Enter(source)
end

-- Remove client from 
function Property:ExitPreExterior(source)
    self.exterior:Exit(source)
end

function Property:EnterExterior(source)
   self.clients[source] = "exterior"
end

-- Remove client from 
function Property:ExitExterior(source)
    if self.clients[source] == "exterior" then 
        self.clients[source] = nil 
    end
end

function Property:EnterApartment(source)
    local gridIndex
    if self.shellData.apartment.shellType == "mlo" then
        self.apartment:SetBucket(self.shellData.apartment.shell)
    else
        gridIndex = self.apartment:GetGridIndex()
    end

    SendDataToClient("EnterApartment", source,     
    {
        id = self.id, 
        seperateGarage = self.seperateGarage,
        shellData = self.shellData,
        gridIndex = gridIndex
    })

    self.clients[source] = "apartment"

    if self.seperateGarage then
        self.apartment:Enter(source)
    else
        self.apartment:Enter(source)
        if not self.apartmentId then
            self.garage:Enter(source, false)
        end
    end

    if self.apartmentId then
        for i=1,#BasicApartments do
            if BasicApartments[i].id == self.apartmentId then
                PlayerState.Enter(source, BasicApartments[i].door)
                break
            end
        end
    else
        PlayerState.Enter(source, self.apartment.door.doorPosition)
    end
end

function Property:ExitApartment(source)
    self.clients[source] = nil 
    
    if self.seperateGarage then
        self.apartment:Exit(source)
    else
        self.apartment:Exit(source)
        self.garage:Exit(source)
    end

    PlayerState.Exit(source)
end

function Property:EnterGarage(source)

    self.garage:Load()

    local playerPed = GetPlayerPed(tostring(source))
    local vehicle = GetVehiclePedIsIn(playerPed, false)

    if vehicle ~= 0 and self.garage:GetVehicleCount() >= Config.garage.maxVehicles then
        self.garage:Flush()
        SendDataToClient("Notification", source, GetLocale("GARAGE_FULL"), 6000, false)
        return false
    end

    local gridIndex
    if self.seperateGarage then
        if self.shellData.garage.shellType == "mlo" then
            self.garage:SetBucket(self.shellData.garage.shell)
        else
            gridIndex = self.garage:GetGridIndex()
        end
    else
        if self.shellData.apartment.shellType == "mlo" then
            self.apartment:SetBucket(self.apartment.garage)
            self.garage:SetSpawnPosition(vec3(0, 0, 0))
        else
            gridIndex = self.apartment:GetGridIndex()
            self.garage:SetSpawnPosition(self.apartment.spawnPosition)
        end
    end

    SendDataToClient("EnterGarage", source, 
    {
        id = self.id, 
        seperateGarage = self.seperateGarage, 
        shellData = self.shellData,
        gridIndex = gridIndex
    })

    if self.seperateGarage then
        self.garage:Enter(source, true)
        self.clients[source] = "garage"
    else
        self.clients[source] = "apartment"
        self.apartment:Enter(source)
        self.garage:Enter(source, false)
    end

    PlayerState.Enter(source, self.apartment.door.doorPosition)

    return true
end

function Property:ExitGarage(source)
    self.clients[source] = nil 

    if self.seperateGarage then
        self.garage:Exit(source)
    else
        self.apartment:Exit(source)
        self.garage:Exit(source)
    end

    PlayerState.Exit(source)
end

function Property:EnteredVehicle(source, vehicle)
    self.garage:EnteredVehicle(source, vehicle)
end

function Property:ExitedVehicle(source, vehicle)
    self.garage:ExitedVehicle(source, vehicle)
end

-- Permissions --
function Property:SavePermissions()
    if PropertiesBaseData[self.id] then
        PropertiesBaseData[self.id].owner = self.owner
        PropertiesBaseData[self.id].permissions = self.permissions
   end

   SendDataToClient("SetPermissions", -1, {
       id = self.id,
       permissions = self.permissions,
       owner = self.owner
   })

   Database.SavePermissions(self.id, self.owner, self.permissions)
end

function Property:SetOwner(id)
    self.owner = id
    self:SavePermissions()
end

function Property:SetPermission(data)
    self.permissions[data.identifier] = data
    self:SavePermissions()
end

function Property:RemovePermission(data)
    self.permissions[data.identifier] = nil
    self:SavePermissions()
end

function Property:GetPermissionLevel(source)
    local identifier = GetIdentifier(source)
    if self.owner == GetJobName(source) then return "owner" end
    if identifier == self.owner then return "owner" end
    return (self.permissions[identifier] ~= nil) and self.permissions[identifier].level or "guest"
end

function Property:SetLockState(state)
    self.unlocked = state
    PropertiesBaseData[self.id].unlocked = state
    SendDataToClient("SetLockState", -1, {
        id = self.id,
        state = state
    }) 
end


function Property:UnlockForSeconds()
    self:SetLockState(true)
    SetTimeout(Config.doorUnlockedSeconds * 1000, function()
        self:SetLockState(false)
    end)
end


--------DOOR BELL--------
function Property:RingDoorbell(source)
    for k,v in pairs(self.clients) do
        if v == "apartment" or v == "garage" then
            SendDataToClient("DoorBell", k)
        end
    end
end


function Property:EnableDoorbellCam(source)
    Bridge.SetPlayerBucket(source, 0)


    if self.apartmentId then
        for i=1,#BasicApartments do
            if BasicApartments[i].id == self.apartmentId then
                SendDataToClient("EnableDoorbellCam", source, BasicApartments[i].door)
                return
            end
        end
    end

    SendDataToClient("EnableDoorbellCam", source, self.apartment.door.doorPosition or vec3(0, 0, 0, 0))
end

function Property:DisableDoorbellCam(source)
   if self.clients[source] then
        local bucket = self[self.clients[source]].bucket
        Bridge.SetPlayerBucket(source, bucket)
   else 
        Bridge.SetPlayerBucket(source, 0)
   end
end
--------------------------------

-- Furniture --
function Property:AddFurniture(source, data)
    local target = self.clients[source]
    if target then
        if target then
            self[target].furniture:Add(source, data.furniture)
        end
    end
end

function Property:RemoveFurniture(source, data)
    local target = self[string.lower(data.type)]
    if target then
        target.furniture:Remove(source, data.data)
    end
end
function Property:ModifyFurniture(source, data) 
    local target = self[string.lower(data.type)]
    if target then
        target.furniture:Modify(source, data.data)
    end
end
---------------
