local function selectPermissionLevelMenu(data, player, remove)
    local options = {
        {
            header = player.name,
            isMenuHeader = true
        }
    }

    if data.level == "owner" then
        table.insert(options, {
            header = GetLocale("SECONDARY_OWNER"),
            icon = 'plus',
            params = {
                event = Evt.."PermissionLevelStuff",
                args = {
                    player = player,
                    level = "secondary_owner",
                    event = "SetPermission"
                }
            }
        })
    end

    if data.level == "owner" or  data.level == "secondary_owner" then
        table.insert(options, {
            header = GetLocale("RESIDENT"),
            icon = 'plus',
            params = {
                event = Evt.."PermissionLevelStuff",
                args = {
                    player = player,
                    level = "resident",
                    event = "SetPermission"
                }
            }
        })
    end

    if remove then
        if data.level == "owner" then
            table.insert(options, {
                header = GetLocale("REMOVE_PERMISSION"),
                icon = 'minus',
                params = {
                    event = Evt.."PermissionLevelStuff",
                    args = {
                        player = player,
                        event = "RemovePermission"
                    }
                }
            })
        end
    end


    exports['qb-menu']:openMenu(options)
end

local function permissionMenuClosestPlayers(data)
    local permissions = data.permissions
    local owner = data.owner

	RequestDataFromServer(Evt.."GetClosestPlayers",{}, function(players)
		local options = {
            {
                header = GetLocale("SELECT_PLAYER"),
                isMenuHeader = true
            }
        }

		for i=1, #players do
			local player = players[i]
			if permissions[player.identifier] == nil and player.identifier ~= owner then
				table.insert(options, {
					header = player.name,
					icon = 'plus',
                    params = {
                        event = Evt.."PermissionMenu",
                        args = {
                            data = data,
                            v = player,
                            bool = false,
                            event = "selectPermissionLevelMenu"
                        }
                    }
				})
			else
            end
		end

		exports['qb-menu']:openMenu(options)
	end)
end

local function permissionMenuManagePlayers(data)
    local options = {
        {
            header = GetLocale("SELECT_PLAYER"),
            isMenuHeader = true
        }
    }

    for k,v in pairs(data.permissions) do
        table.insert(options, {
            header = v.name,
            icon = 'fa-solid fa-video',
            params = {
                event = Evt.."PermissionMenu",
                args = {
                    data = data,
                    v = v,
                    bool = true,
                    event = "selectPermissionLevelMenu"
                }
            }
        })
    end

    exports['qb-menu']:openMenu(options)
end


RegisterNetEvent(Evt.."PermissionLevelStuff", function(data)
    if data.event == "SetPermission" then
        data.player.level = data.level
        TriggerServerEvent(Evt.."SetPermission", data.player)
    elseif data.event == "RemovePermission" then
        TriggerServerEvent(Evt.."RemovePermission", data.player)
    end
end)


RegisterNetEvent(Evt.."PermissionMenu", function(data)
    if data.event == "permissionMenuClosestPlayers" then
        permissionMenuClosestPlayers(data.data)
    elseif data.event == "permissionMenuManagePlayers" then
        permissionMenuManagePlayers(data.data)
    elseif data.event == "selectPermissionLevelMenu" then
        selectPermissionLevelMenu(data.data, data.v, data.bool)
    end
end)

function Bridge.qb.PermissionMenu(data)
    local options = {
        {
            header = GetLocale("PERMISSIONS"),
            isMenuHeader = true
        }
    }

    table.insert(options, {
        header = GetLocale("GIVE_PERMISSIONS"),
        icon = 'fa-solid fa-video',
        params = {
            event = Evt.."PermissionMenu",
            args = {
                data = data,
                event = "permissionMenuClosestPlayers"
            }
        }
    })

    table.insert(options, {
    header = GetLocale("MANAGE_PERMISSIONS"),
        icon = 'fa-solid fa-lock-open',
        params = {
            event = Evt.."PermissionMenu",
            args = {
                data = data,
                event = "permissionMenuManagePlayers"
            }
        }
    })

    exports['qb-menu']:openMenu(options)
end





