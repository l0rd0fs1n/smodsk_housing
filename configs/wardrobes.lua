function OpenWardrobe()
    -- TODO 
end

-- Wardrobe models – any of these models can open the wardrobe.
Wardrobes = {
    1725227610,
}


local wardrobeLookup = {}
for _, v in ipairs(Wardrobes) do
    local hash = type(v) == "string" and GetHashKey(v) or v
    wardrobeLookup[hash] = true
end

Wardrobes = wardrobeLookup
wardrobeLookup = nil
