local shell = nil
ShellOffsetCreator = {}

function ShellOffsetCreator.Create(args)
    if not args[1] then
        if shell then DeleteEntity(shell) end
        print("Usage: /shellOffsetCreator shellModel")
        return
    end

   if shell then
        DeleteEntity(shell)
   end
    
    local shellModel = GetHashKey(args[1])
    local playerPed = PlayerData.PlayerPed()
    local spawnCoords = vector3(0.0, 0.0, 300.0)
    

    RequestModel(shellModel)
    while not HasModelLoaded(shellModel) do
        Wait(500)
    end
    

    shell = CreateObjectNoOffset(shellModel, spawnCoords.x, spawnCoords.y, spawnCoords.z, true, false, false)
    SetEntityHeading(shell, 0.0)
    SetEntityAsMissionEntity(shell, true, true)
    SetEntityCoords(playerPed, spawnCoords.x, spawnCoords.y, spawnCoords.z + 1.0, false, false, false, true)
    FreezeEntityPosition(shell, true)
end

function ShellOffsetCreator.Offset()
    local playerPed = PlayerData.PlayerPed()
    if shell == nil then return end

    if not DoesEntityExist(shell) then
        return
    end
    
    local shellCoords = GetEntityCoords(shell)
    local playerCoords = PlayerData.Position()
    local heading = GetEntityHeading(playerPed)
    local offset = playerCoords - shellCoords
    print(string.format("Vec4(%f, %f, %f, %f)", offset.x, offset.y, offset.z, heading))
end

AddEventHandler("onResourceStop", function(resourceName)
    if GetCurrentResourceName() == resourceName then
       if shell then
            DeleteEntity(shell)
       end
    end
end)

