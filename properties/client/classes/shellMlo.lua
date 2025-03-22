ShellMlo = {}
ShellMlo.__index = ShellMlo

function ShellMlo:new(property)
    local obj = {
        property = property,

        create = {
            ["mlo"] = CreateMlo,
            ["shell"] = CreateShell,
            ["smShell"] = CreateSMShell
        },
        flush = {
            ["shell"] = DespawnShell,
            ["smShell"] = DespawnSMShell
        }
    }
    setmetatable(obj, self)
    return obj
end


function ShellMlo:Create(data, useGarageDoor, isGarage)
    DoScreenFadeOut(500)
    Wait(500)
    self.data = data
    local success = self.create[data.shellType](self.property, data, useGarageDoor, isGarage)
    Wait(500)
    DoScreenFadeIn(500)

    return success
end

function ShellMlo:Flush()
    if self.data then
        self.property.shellLoaded = false
        if self.flush[self.data.shellType] then self.flush[self.data.shellType]() end
    end
end


DoScreenFadeIn(500)