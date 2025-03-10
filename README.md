# Table of Contents
- [Description](#description)
- [TODO](#todo)
- [Depencies & Add-ons](#dependencies-and-optional-add-ons)
- [Known Problems](#known-problems)
    - [Server](#server)
    - [Client](#client)
- [Server-Specific Customizations](#server-specific-customizations)
    - [Adding new Shells/MLOs](#adding-new-shells-mlos)
    - [Creating new Apartment Buildings](#creating-new-apartment-buildings)
    - [Storages](#storages)
    - [Wardrobe](#wardrobe)
    - [PlayerData (IMPORTANT)](#playerdata-important)
    - [Database (IMPORTANT)](#database-important)
    - [Garage (IMPORTANT)](#garage-important)
    - [Vehicle Properties (IMPORTANT)](#vehicle-properties-important)



<br><br>
# Description
- [Preview Youtube]()
- A versatile housing and realtor script designed to support multiple frameworks, with plans for even better compatibility in the future.
- Realtors can create new properties and put them up for sale. Players can then make offers on those properties. If a player owns a property, they can also list it for sale.
- This script is still a work in progress, and your feedback is invaluable. Please report any bugs through my [Discord](https://discord.com/invite/yTGYZ7MGvM) for the best support.



<br><br>
# TODO
- Finish [QBCore](https://github.com/qbcore-framework/qb-core) support
- Polish

<br><br>
# Dependencies and Optional Add-ons

### Dependencies  
- [oxmysql](https://github.com/overextended/oxmysql)  
- [ox_lib](https://github.com/overextended/ox_lib) or [~~QBCore~~](https://github.com/qbcore-framework/qb-core)
- [ox_target](https://github.com/overextended/ox_target) or [~~qb-target~~](https://github.com/qbcore-framework/qb-target)
- [ox_inventory](https://github.com/overextended/ox_inventory) or [~~qb-inventory~~](https://github.com/qbcore-framework/qb-inventory)
- [ESX](https://github.com/esx-framework/esx_core) or [QBOX](https://github.com/Qbox-project) or [~~QBCore~~](https://github.com/qbcore-framework/qb-core)
- [prop_selector]("TODO")


### Optional
- [Shell Builder](https://smodsk.tebex.io/package/6674161)


<br><br>
# Known Problems
- Tested with **Artifact version v1.0.0.10778**

### Server
- `GetVehiclePedIsIn(ped, false)`: **Depending on your server artifact version, this native might not work.**  
    - **IF IT FAILS, IT WILL BREAK EVERYTHING. ENSURE YOU ARE USING AN ARTIFACT VERSION WHERE THIS NATIVE FUNCTIONS CORRECTLY.**

### Client
- For some reason, other clients may not see players in the same bucket. A relog usually resolves this issue.


<br><br>
# Server-Specific Customizations


## Adding new shells and mlos
**File:** `configs/shellData.lua`
- You can use the commands `/shellOffset_start shell` and `/shellOffset_get` to get door/garage door offsets (copy and paste from the console).
```lua
-- Examples --

-- Apartment
["shell_lester"] = {
    name = "Small Apartment",
    shellType = "shell", 
    offset = vec3(0, 0, 2),
    door = vec4(-1.60, -5.36, -0.37, 0)
}

-- Garage
["shell_garagem"] = {
    name = "Medium Garage",
    shellType = "shell",
    offset = vec3(0, 0, 2),
    garageDoor = vec4(2.81, -4.10, -0.75, 0),
},
```

## Creating new Apartment Buildings
- `Players can buy these apartments from the apartments tab.`
- You need to configure the apartment building manually. Each building can have multiple different shells for players to choose from.
- You can use the command `/getApartmentData` to get an example output, as seen below. It creates a unique ID for the building and fills in the location, street, and door position.
- All you need to do is add the shells you've configured previously and select the prices.
```lua
{
    id = "vJmWtD",
    location = "Mirror Park",
    street = "Nikola Pl 16",
    door = vec4(1365.85, -593.46, 74.39, 7.05),
    shells = {
        {
            shell = "",
            price = 0,
        }
    }
    
}
 ```

## Storages
**File:** `configs/storages.lua`
- Configure props that can be used as storages
```lua
-- Example 
{ model = "prop_devin_box_closed", price = 500, slots = 5 },
```

## Wardrobe
**File:** `configs/wardrobe.lua`
- You can configure the models that will display the `Open wardrobe option`. You can also find the method that's triggered when `Open wardrobe option` is selected:
```lua
function OpenWardrobe()
    -- TODO 
end
```


## PlayerData (IMPORTANT)
**File:** `properties/bridge/multi/client/playerData.lua`
- **You might need to add your own events here that's are triggered when player is loadeded**
```lua
RegisterNetEvent('esx:setJob', function(job, lastJob)
   PlayerData.SetJob(job.name, job.grade)
end)

RegisterNetEvent('esx:playerLoaded',function(xPlayer)
    getData(xPlayer)
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    getData()
end)

RegisterNetEvent('QBCore:Player:SetPlayerData', function(val)
    getData()
end)
```

## Database (IMPORTANT)
**File:** `database/database_other.lua`
- Giving money to a player who's offline
    - `Database.AddBankMoney(identifier, amount)`
- Fetching vehicle properties from database for garage
    - `Database.GetVehicleProperties(plate)`

## Garage (IMPORTANT)
**File:** `properties/server/vehicleEvents.lua`  
**File:** `properties/client/vehicleEvents.lua`

### Vehicle Properties (IMPORTANT)
- Vehicle properties are fetched from the database (default is "owned_vehicles") and applied to the vehicle entity.
- The script does not store any vehicle property data. As a result, non-owned vehicles stored in the garage will always spawn with different properties.
- Depending on your system, you might need to remove the comment from `AddStateBagChangeHandler("setVehicleProperties")` to activate it.
```lua
Entity(vehicle).state["setVehicleProperties"]
Entity(vehicle).state["setVehicleComponents"]
```

### Vehicle Position Saving
- Vehicle enter and exit events are tracked using baseevents.
- Positions are saved every time a player exits a vehicle inside the garage.
```lua
RegisterServerEvent("baseevents:enteredVehicle")
RegisterServerEvent("baseevents:leftVehicle")
```

