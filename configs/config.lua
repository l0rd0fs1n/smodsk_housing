Evt = "smodsk_housing:"
Config = {}

Config.realtorJobName = "realtor"
Config.realtorSocietyAccountName = "realtor"

-- How many properties can player own
Config.maxPropertiesOwned = 1

Config.blip = {
    text = nil,
    sprite = 40,
    color = 7,
    scale = .7,
}

Config.permissionLevels = {
    ["owner"] = {
        canGivePermissions = true,
        canChangeOwnerShip = true,
        canBuyStorageSpace = true,
        canOpenStorage = true,
        canOpenWardrobe = true,
        canOpenPropertyMenu = true,
        canUnlockDoor = true,
        canDecorate = true,
        canEnter = true,

        -- smodsk_shellBuilder --
        canOpenBuildMenu = true,
        canBuild = true,
        canPaint = true,
    },
    ["secondary_owner"] = {
        canOpenPropertyMenu = true,
        canGivePermissions = true,
        canBuyStorageSpace = true,
        canOpenWardrobe = true,
        canUnlockDoor = true,
        canOpenStorage = true,
        canDecorate = true,
        canEnter = true
    },
    ["resident"] = {
        canOpenStorage = true,
        canUnlockDoor = true,
        canOpenWardrobe = true,
        canEnter = true,
    },
    ["guest"] = {}
}



Config.shellMlo = {
    Load = function()
       local interior = GetInteriorAtCoords(-866.114, 3305.053, -89.001)
       PinInteriorInMemory(interior)
       --RefreshInterior(interior)
       --SetInteriorRoomTimecycle(interior, 1, GetHashKey("metro"))
       --RefreshInterior(interior)
       --Wait(100)
       --ForceRoomForEntity(PlayerData.PlayerPed(), interior, 549289364)
    end,
    -- Mlo size is 300x300 units
    size = 300,
    -- Mlo height is 20 units
    height = 20,
    -- Mlo is at...
    position = vec3(-900, 3400, -80)
}


-- Players have the option to unlock the door for a certain time.  
-- This setting determines how long the door remains unlocked when 'unlock for a certain time' is selected.  
Config.doorUnlockedSeconds = 30 -- seconds


-- How many storages apartment can have
-- Check public/configs/storages.lua, You can set storage models, prices and sizes there.
Config.maxStorages = 2
Config.interiorPropLimit = 300
Config.exteriorPropLimit = 3
Config.exteriorPropMaxHeight = 5

Config.garage = {
    maxVehicles = 4,
}

Config.dataStorage = {
    furniture = {
        maxPropsInterior = 300,
        maxPropsExterior = 10,
        chunkSize = 30,
    }
}