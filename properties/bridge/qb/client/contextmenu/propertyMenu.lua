RegisterNetEvent(Evt.."PropertyMenu", function(data)
    if data.event == "AddFurniture" then
        FurnitureManager.AddFurniture()
    elseif data.event == "PermissionMenu" then
        Bridge.PermissionMenu(data.data)
    elseif data.event == "BuyStorage" then
        FurnitureManager.BuyStorage()
    elseif data.event == "DoorMenu" then
        Bridge.DoorMenu()
    elseif data.event == "" then

    end
end)


function Bridge.qb.OpenPropertyMenu()
    if not CanInteract() then return end
    RequestDataFromServer(Evt.."GetPropertyMenuData", {}, function(data)
        if not data then return end

        local options = {
            {
                header = GetLocale("PROPERTY_MENU"),
                isMenuHeader = true
            }
        }


        local permissions = Config.permissionLevels[data.level]


        if data.level == "owner" or permissions.canOpenPropertyMenu then
            if permissions.canDecorate then
                table.insert(options, {
                    header = GetLocale("DECORATE"),
                    icon = 'fa-solid fa-couch',
                    params = {
                        event = Evt.."PropertyMenu",
                        args = {
                            event = "AddFurniture"
                        }
                    }
                })
            end

            if data.level == "owner" or permissions.canGivePermissions then
                table.insert(options, {
                    header = GetLocale("PERMISSIONS"),
                    icon = 'fa-solid fa-couch',
                    params = {
                        event = Evt.."PropertyMenu",
                        args = {
                            event = "PermissionMenu",
                            data = data
                        }
                    }
                })
            end

    
            if data.space == "interior" then
                if data.level == "owner" or permissions.canBuyStorageSpace then
                    table.insert(options, {
                        header = GetLocale("BUY_STORAGE"),
                        icon = 'fa-solid fa-box',
                        params = {
                            event = Evt.."PropertyMenu",
                            args = {
                                event = "BuyStorage"
                            }
                        }
                    })
                end
            end

            if data.space == "interior" then
                if data.level == "owner" or permissions.canLetPeopleIn then
                    table.insert(options, {
                        header = GetLocale("DOOR"),
                        icon = 'fa-solid fa-door-closed',
                        params = {
                            event = Evt.."PropertyMenu",
                            args = {
                                event = "DoorMenu"
                            }
                        }

                    })
                end
            end
        end

        exports['qb-menu']:openMenu(options)
    end)
end



