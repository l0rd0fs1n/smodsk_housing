PlayerData = {
    identifier = "",
    propertyId = -1,
}

function PlayerData.GetLastPosition()
    local position
    RequestDataFromServer(Evt.."GetLastPosition", {}, function(pos)
        position = pos
    end)

    repeat Wait(1) until position ~= nil
    return position
end

function PlayerData.SetPlayer(identifier)
    PlayerData.identifier = identifier
    local position = PlayerData.GetLastPosition()
    if position then
        SetEntityCoords(PlayerData.PlayerPed(), position.x, position.y, position.z, false, false, false, false)
        SetEntityHeading(PlayerData.PlayerPed(), position.w - 180.0)
    end
    
end

function PlayerData.SetJob(job, grade)
    PlayerData.job = {
        name = job,
        grade = grade
    }
end

function PlayerData.PlayerPed()
    return PlayerPedId()
end

function PlayerData.Position()
    return GetEntityCoords(PlayerData.PlayerPed())
end


function PlayerData.EnterApartment(doorPosition)
    if PlayerData.inInside then return end
    PlayerData.inInside = true
    CreateThread(function()
        while PlayerData.inInside do
            SetFakePausemapPlayerPositionThisFrame(doorPosition.x, doorPosition.y)
            Wait(1)
        end
    end)
end


function PlayerData.ExitApartment()
    PlayerData.inInside = false
end


-- Loading playerData --
local function getData(player)
    if ESX then
        if not player then
            if not ESX.PlayerData or not ESX.PlayerData.job then return end
            PlayerData.SetPlayer(ESX.PlayerData.identifier)
            PlayerData.SetJob(ESX.PlayerData.job.name, ESX.PlayerData.job.grade)
        else
            PlayerData.SetPlayer(player.identifier)
            PlayerData.SetJob(player.job.name, player.job.grade)
        end
    elseif QBCore or QBX then
        local Player = QBCore.Functions.GetPlayerData()
        if not Player or not Player.job then return end 
        PlayerData.SetPlayer(Player.citizenid)
        PlayerData.SetJob(Player.job.name, 1)
    end

    LoadProperties()
end




RegisterNetEvent('esx:setJob', function(job, lastJob)
   PlayerData.SetJob(job.name, job.grade)
end)

RegisterNetEvent('esx:playerLoaded',function(xPlayer)
    getData(xPlayer)
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    getData()
end)



Wait(2000)
getData()
