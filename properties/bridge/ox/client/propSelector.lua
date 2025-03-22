function Bridge.ox.AddGlobalOption()
    local options = {}
    table.insert(options, { 
        name = "prop_selector_mf",
        icon = "fa-solid fa-gear",
        label = GetLocale("MODIFY_FURNITURE"),
        canInteract = function(entity)

            if not CanInteract() then return false end
            local propData = PropPool.Get(entity)
            if not propData then return false end
            local property = Properties[propData.id]
            if not property then return end 
            if propData.data.furniture.isStorage then return false end

            return HasPermission(property.owner, property.permissions, "canDecorate")
        end,
        onSelect = function(data)
            FurnitureManager.ModifyFurniture(data.entity)
        end
    })

    table.insert(options, { 
        name = "prop_selector_mr",
        icon = "fa-solid fa-gear",
        label = GetLocale("REMOVE_FURNITURE"),
        canInteract = function(entity)

            if not CanInteract() then return false end
            local propData = PropPool.Get(entity)
            if not propData then return false end
            local property = Properties[propData.id]
            if not property then return end 
            if propData.data.furniture.isStorage then return false end
            return HasPermission(property.owner, property.permissions, "canDecorate")
        end,
        onSelect = function(data)
            if Bridge.ConfirmDialog(GetLocale("DELETE_FURNITURE")) then
                FurnitureManager.RemoveFurniture(data.entity)
            end
        end
    })
    
    table.insert(options, { 
        name = "prop_selector_sm",
        icon = "fa-solid fa-gear",
        label = GetLocale("OPEN_STORAGE"),
        canInteract = function(entity)
            
            if not CanInteract() then return false end
            local propData = PropPool.Get(entity)
            if not propData then return false end
            local property = Properties[propData.id]
            if not property then return end 
            if not propData.data.furniture.isStorage then return false end
            return HasPermission(property.owner, property.permissions, "canOpenStorage")
        end,
        onSelect = function(data)
            FurnitureManager.OpenStorage(data.entity)
        end
    })

    table.insert(options, { 
        name = "prop_selector_sm",
        icon = "fa-solid fa-gear",
        label = GetLocale("MOVE_STORAGE"),
        canInteract = function(entity)

            if not CanInteract() then return false end
            local propData = PropPool.Get(entity)
            if not propData then return false end
            local property = Properties[propData.id]
            if not property then return end 
            if not propData.data.furniture.isStorage then return false end

            return HasPermission(property.owner, property.permissions, "canBuyStorageSpace")
        end,
        onSelect = function(data)
            FurnitureManager.MoveStorage(data.entity)
        end
    })

    table.insert(options, { 
        name = "prop_selector_sr",
        icon = "fa-solid fa-gear",
        label = GetLocale("REMOVE_STORAGE"),
        canInteract = function(entity)
            if not CanInteract() then return false end
            local propData = PropPool.Get(entity)
            if not propData then return false end
            local property = Properties[propData.id]
            if not property then return end 
            if not propData.data.furniture.isStorage then return false end
            return HasPermission(property.owner, property.permissions, "canBuyStorageSpace")
        end,
        onSelect = function(data)
            if Bridge.ConfirmDialog(GetLocale("DELETING_STORAGE")) then
                Wait(500)
                if Bridge.ConfirmDialog(GetLocale("DELETING_STORAGE_SECOND")) then
                    FurnitureManager.RemoveFurniture(data.entity)
                end
            end
        end
    })

    table.insert(options, {
        name = "prop_selector_cl", 
        icon = "fa-solid fa-person-half-dress",
        label = GetLocale("WARDROBE"),
        canInteract = function(entity)
            if not CanInteract() then return false end
            local propData = PropPool.Get(entity)
            if not propData then return false end
            local property = Properties[propData.id]
            if not property then return end 
            local model = GetEntityModel(entity)
            if not Wardrobes[model] then return end
            return HasPermission(property.owner, property.permissions, "canOpenWardrobe")
        end,
        onSelect = function(data)
            OpenWardrobe()
        end
    })

    ox_target:addGlobalOption(options)
end


