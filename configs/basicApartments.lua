-- Basic apartments data --
-- Unlimited amount of apartments --

BasicApartments = {
    {
        id = "asd123",
        location = "Pillbox Hill",
        street = "Elgin Ave 16",
        door = vec4(156.34, -1065.92, 30.05, 342.64),
        shells = {
            {
                shell = "shell_lester",
                price = 5000,
                image = "",
            },
            {
                shell = "aparment_1",
                price = 8000,
                image = "",
            },
        }
    },
    {
        id = "a123asd123",
        location = "Pillbox Hill",
        street = "Vespucci Blvd 16",
        door = vec4(30.35, -900.03, 29.98, 163.36),
        shells = {
            {
                shell = "shell_lester",
                price = 5000,
                image = "",
            },
            {
                shell = "aparment_1",
                price = 8000,
                image = "",
            },
        }
    },
}






-- Init --
Wait(1)
table.sort(BasicApartments, function(a, b)
    return a.location < b.location
end)

if BasicApartments then
    for i=1,#BasicApartments do
        for j=1,#BasicApartments[i].shells do
            BasicApartments[i].shells[j].data = ShellData.apartment[BasicApartments[i].shells[j].shell]
        end
    end
end

--- Command ---
function GetApartmentData()
    local position = GetEntityCoords(PlayerPedId())
    local heading = GetEntityHeading(PlayerPedId())
    local streetHash = GetStreetNameAtCoord(position.x, position.y, position.z)
    local street = GetStreetNameFromHashKey(streetHash)
    local regionHash = GetNameOfZone(position.x, position.y, position.z)
    local location = GetLabelText(regionHash)

    print(string.format([[
        {
            id = "%s",
            location = "%s",
            street = "%s %s",
            door = vec4(%.2f, %.2f, %.2f, %.2f),
            shells = {
                {
                    shell = "",
                    price = 0,
                }
            }
            
        }
    ]], GenerateUniqueId(), location, street, math.random(1,30), position.x, position.y, position.z, heading))
end
