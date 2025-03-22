function Bridge.ox.OpenPropertyMenu()
    if not CanInteract() then return end
    RequestDataFromServer(Evt.."GetPropertyMenuData", {}, function(data)
        if not data then return end

        local options = {}
        local permissions = Config.permissionLevels[data.level]


        if data.level == "owner" or permissions.canOpenPropertyMenu then
            if permissions.canDecorate then
                table.insert(options, {
                title = GetLocale("DECORATE"),
                icon = 'fa-fas fa-couch',
                onSelect = function()
                    FurnitureManager.AddFurniture()
                end})
            end

            if data.level == "owner" or permissions.canGivePermissions then
                table.insert(options, {
                    title = GetLocale("PERMISSIONS"),
                    icon = 'fa-fas fa-couch',
                    onSelect = function()
                        Bridge.PermissionMenu(data)
                    end})
            end

    
            if data.space == "interior" then
                if data.level == "owner" or permissions.canBuyStorageSpace then
                    table.insert(options, {
                    title = GetLocale("BUY_STORAGE"),
                    icon = 'fa-fas fa-box',
                    onSelect = function()
                        FurnitureManager.BuyStorage()
                    end})
                end
            end

            if data.space == "interior" then
                if data.level == "owner" or permissions.canLetPeopleIn then
                    table.insert(options, {
                        title = GetLocale("DOOR"),
                        icon = 'fa-fas fa-door-closed',
                        onSelect = function()
                            Bridge.DoorMenu()
                        end})
                end
            end
        end

        lib.registerContext({
            id = 'sm_property_menu',
            title = GetLocale("PROPERTY_MENU"),
            onExit = function()
                
            end,
            options = options
        })

        lib.showContext('sm_property_menu')
    end)
end



