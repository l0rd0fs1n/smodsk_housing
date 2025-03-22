--TODO We need to register all added "properties here" that have apartmentId
Apartments = {
    data = {}
}

function Apartments.Get(id)
    return Apartments.data[id] or {}
end

function Apartments.Remove(data)
    local apartments = Apartments.data[data.apartmentId]
    if apartments then
        for i=1, #apartments do
            if apartments[i].id == data.id then
                table.remove(apartments[i], i)
                break
            end
        end
    end
end

function Apartments.Add(data)
    if not Apartments.data[data.apartmentId] then 
        Apartments.data[data.apartmentId] = {} 
    end

    table.insert(Apartments.data[data.apartmentId], data)
    table.sort(Apartments.data[data.apartmentId], function(a, b)
        local indexA = tonumber(a.street:match("(%d+)$")) or math.huge
        local indexB = tonumber(b.street:match("(%d+)$")) or math.huge
        return indexA < indexB
    end)
end


CreateThread(function()
    Wait(1000)
    for i=1,#BasicApartments do
        local ap = BasicApartments[i]
        local coords = ap.door
        Bridge.RegisterTargetBox(
            { 
                name = "_doorExterior"..ap.id,
                coords = vec3(coords.x, coords.y, coords.z),
                radius = 1.1,
                options = {
                    {
                        label = GetLocale("OPEN_APARTMENTS_MENU"),
                        icon = "fa-solid fa-house",
                        onSelect = function()
                            Bridge.BuildingMenu(Apartments.Get(ap.id))
                        end,
                        canInteract = function()
                            if not CanInteract() then return false end
                            return true
                        end
                    }
                }
            })
    end
end)