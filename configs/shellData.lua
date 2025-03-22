RealtorShellData = {apartment={}, garage={}}
ShellData = {
    apartment = {
        ["shell_lester"] = {
            name = "Small Apartment",
            shellType = "shell", 
            offset = vec3(0, 0, 2),
            door = vec4(-1.60, -5.36, -0.37, 0)
        },
        ["aparment_1"] = {
            name = "Luxury Apartment",
            shellType = "mlo", 
            door = vec4(-781.747, 318.378, 217.673, 354.336)
        },
    },
    
    garage = {
        ["shell_garagem"] = {
            name = "Medium garage",
            shellType = "shell",
            offset = vec3(0, 0, 2),
            garageDoor = vec4(2.81, -4.10, -0.75, 0),
        },
        ["big_garage"] = {
            name = "Luxury Garage",
            shellType = "mlo", 
            garageDoor = vec4(231.530, -1003.248, -99.000, 351.333),
        }
    }
}


-- init --
for k,v in pairs(ShellData.apartment) do table.insert(RealtorShellData.apartment, {key = k, name = v.name, shellType = v.shellType}) end
for k,v in pairs(ShellData.garage) do table.insert(RealtorShellData.garage, {key = k, name = v.name, shellType = v.shellType}) end