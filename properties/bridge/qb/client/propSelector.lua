function Bridge.qb.AddGlobalOption()
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
        action = function(entity)
            FurnitureManager.ModifyFurniture(entity)
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
        action = function(entity)
            if Bridge.ConfirmDialog(GetLocale("DELETE_FURNITURE")) then
                FurnitureManager.RemoveFurniture(entity)
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
        action = function(entity)
            FurnitureManager.OpenStorage(entity)
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
        action = function(entity)
            FurnitureManager.MoveStorage(entity)
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
        action = function(entity)
            if Bridge.ConfirmDialog(GetLocale("DELETING_STORAGE")) then
                Wait(500)
                if Bridge.ConfirmDialog(GetLocale("DELETING_STORAGE_SECOND")) then
                    FurnitureManager.RemoveFurniture(entity)
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
        action = function(entity)
            OpenWardrobe()
        end
    })

    qb_target:AddGlobalObject({options = options, distance = 5.0})
end


