-- These models can never be placed by the player in their apartment.

BlockedModels = {
    -- prop_model,
    -- prop_model,
    -- ...
}

local temp = {}
for i=1,#BlockedModels do
    temp[BlockedModels[i]] = true
end
BlockedModels = temp
temp = nil

function AddToBlockedModels(model)
    BlockedModels[model] = true
end