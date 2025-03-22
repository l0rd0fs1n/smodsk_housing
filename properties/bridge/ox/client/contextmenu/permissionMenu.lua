local function selectPermissionLevelMenu(data, player, remove)
    local options = {}

    if data.level == "owner" then
        table.insert(options, {
            title = GetLocale("SECONDARY_OWNER"),
            icon = 'plus',
            onSelect = function()
                player.level = "secondary_owner"
                TriggerServerEvent(Evt.."SetPermission", player)
            end
        })
    end

    if data.level == "owner" or  data.level == "secondary_owner" then
        table.insert(options, {
            title = GetLocale("RESIDENT"),
            icon = 'plus',
            onSelect = function()
                player.level = "resident"
                TriggerServerEvent(Evt.."SetPermission", player)
            end
        })
    end

    if remove then
        if data.level == "owner" then
            table.insert(options, {
                title = GetLocale("REMOVE_PERMISSION"),
                icon = 'minus',
                onSelect = function()
                    TriggerServerEvent(Evt.."RemovePermission", player)
                end
            })
        end
    end

    lib.registerContext({
        id = 'sm_property_menu_permission_3',
        title = player.name,
        menu = "sm_property_menu_permission_2",
        options = options
    })

    lib.showContext('sm_property_menu_permission_3')
end

local function permissionMenuClosestPlayers(data)
    local permissions = data.permissions
    local owner = data.owner

	RequestDataFromServer(Evt.."GetClosestPlayers",{}, function(players)
		local options = {}
		for i=1, #players do
			local player = players[i]
			if permissions[player.identifier] == nil and player.identifier ~= owner then
				table.insert(options, {
					title = player.name,
					icon = 'plus',
					onSelect = function()
						selectPermissionLevelMenu(data, player)
					end
				})
			else
            end
		end

		lib.registerContext({
			id = 'sm_property_menu_permission_2',
			title = GetLocale("SELECT_PLAYER"),
			menu = "sm_property_menu_permission_1",
			options = options
		})

        lib.showContext('sm_property_menu_permission_2')
	end)
end

local function permissionMenuManagePlayers(data)
    local options = {}

    for k,v in pairs(data.permissions) do
        table.insert(options, {
            title = v.name,
            icon = 'fa-fas fa-video',
            onSelect = function()
                selectPermissionLevelMenu(data, v, true)
            end
        })
    end

    lib.registerContext({
        id = 'sm_property_menu_permission_4',
        title = GetLocale("SELECT_PLAYER"),
        menu = "sm_property_menu_permission_1",
        options = options
    })

    lib.showContext('sm_property_menu_permission_4')
end


function Bridge.ox.PermissionMenu(data)
    local options = {}

    table.insert(options, {
        title = GetLocale("GIVE_PERMISSIONS"),
        icon = 'fa-fas fa-video',
        onSelect = function()
            permissionMenuClosestPlayers(data)
        end
    })

    table.insert(options, {
    title = GetLocale("MANAGE_PERMISSIONS"),
        icon = 'fa-fas fa-lock-open',
        onSelect = function()
            permissionMenuManagePlayers(data)
        end
    })

    lib.registerContext({
        id = 'sm_property_menu_permission_1',
        title = GetLocale("PERMISSIONS"),
        menu = "sm_property_menu",
        options = options
    })

   
    lib.showContext('sm_property_menu_permission_1')
end





