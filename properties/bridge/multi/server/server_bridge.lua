function GetPlayerData(source)
	local Player = GetPlayerObject(source)
    if QBCore or QBX then
        return {name = Player.PlayerData.charinfo.firstname.." "..Player.PlayerData.charinfo.lastname, identifier = Player.PlayerData.citizenid}
    elseif ESX then
        return {name = Player.name, identifier = Player.identifier}
    end
end

function GetIdentifier(source)
	local Player = GetPlayerObject(source)
    if QBCore or QBX then
        return Player.PlayerData.citizenid
    elseif ESX then
        return Player.identifier
    end
end

function GetItemCount(source, item)
	if ox_inventory then
		return ox_inventory:GetItemCount(source, item)
	elseif qb_inventory then
		return qb_inventory:GetItemCount(source, item)
	end
end


function RemoveItem(source, item, amount)
	if ox_inventory then
		return ox_inventory:RemoveItem(source, item, amount)
	elseif qb_inventory then
		return qb_inventory:RemoveItem(source, item, amount)
	end
	return false
end

function AddItem(source, item, amount)
	if ox_inventory then
		if ox_inventory:CanCarryItem(source, item, amount) then
			ox_inventory:AddItem(source, item, amount)
			return true
		end
	elseif qb_inventory then
		if qb_inventory:CanAddItem(source, item, amount) then
			qb_inventory:AddItem(source, item, amount)
			return true
		end
	end

	SendDataToClient("Notification", source, GetLocale("NOT_ENOUGH_ROOM"), false)
	return false
end


function CanCarry(source, item, amount)
	local amount = tonumber(amount)
	if ox_inventory then
		if ox_inventory:CanCarryItem(source, item, amount) then
			return true
		end
	elseif qb_inventory then
		if qb_inventory:CanAddItem(source, item, amount) then
			return true
		end
	end

	SendDataToClient("Notification", source, GetLocale("NOT_ENOUGH_ROOM"), false)
	return false
end

function AddMoney(source, amount)
	local amount = tonumber(amount)
	if Config.money == "cash" then
		AddCash(source, amount)
	elseif Config.money == "bank" then
		AddBankMoney(source, amount)
	end

	return true
end

function TryRemoveMoney(source, amount)
	local amount = tonumber(amount)
	if Config.money == "cash" then
		return TryRemoveCash(source, amount)
	elseif Config.money == "bank" then
		return TryRemoveBankMoney(source, amount)
	end

	return true
end


function GetBankMoney(source, callback)
	local player = GetPlayerObject(source)
	if QBCore or QBX then
        callback(player.PlayerData.money.bank)
    elseif ESX then
        callback(player.getAccount('bank').money)
    else 
    	callback(0)
    end
end

function TryRemoveBankMoney(source, amount)
	local player = GetPlayerObject(source)
	local amount = tonumber(amount)
	if QBCore or QBX then
        local money = player.PlayerData.money.bank
        if money >= amount then
        	player.Functions.RemoveMoney('bank', amount, '')
        	return true
        end
    elseif ESX then
        local money = player.getAccount('bank').money
        if money >= amount then
        	player.removeAccountMoney('bank', amount)
        	return true
        end
    end

    return false
end

function AddBankMoney(source, amount)
	local player = GetPlayerObject(source)
	local amount = tonumber(amount)
	if QBCore or QBX then
        player.Functions.AddMoney('bank', amount, '')
    elseif ESX then
		player.addAccountMoney('bank', amount, '')
    end
end

function AddCash(source, amount)
	local player = GetPlayerObject(source)
	local amount = tonumber(amount)
	if QBCore or QBX then
        player.Functions.AddMoney('cash', amount, '')
    elseif ESX then
        player.addAccountMoney('money', amount, '')
    end
end

function GetPlayerObject(source)
    if QBCore then
        return QBCore.Functions.GetPlayer(source)
    elseif QBX then
        return exports.qbx_core:GetPlayer(source)
    elseif ESX then
        return ESX.GetPlayerFromId(source)
    end
end

function TryRemoveCash(source, amount)
	local player = GetPlayerObject(source)
	local amount = tonumber(amount)
	local currentAmount = 0
	if QBCore or QBX then
        currentAmount = player.Functions.GetMoney('cash')
        if currentAmount >= amount then
            player.Functions.RemoveMoney('cash', amount)
            return true
        end
    elseif ESX then
        currentAmount = player.getAccount('money').money
        if currentAmount >= amount then
            player.removeAccountMoney('money', amount)
            return true
        end
    end

    return false
end

function GetJobName(source)
   	local player = GetPlayerObject(source)
   	if QBCore then
    	return player.PlayerData.job.name
    elseif QBX then
    	return player.PlayerData.job.name
    elseif ESX then
    	return player.job.name
    end
    return ""
end


function AddCompanyMoney(company, amount)
	if ESX then
		if GetResourceState("esx_addonaccount") == "started" then
			TriggerEvent('esx_addonaccount:getSharedAccount', company, function(account)
				if account then
					account.addMoney(amount)
				else
					print("Company account not found!")
				end
			end)
		end
	elseif QBCore or QBX then
		if GetResourceState("qb-management") == "started" then
			exports['qb-management']:AddMoney(company, amount)
		end
	end
end

function RemoveCompanyMoney(company, amount)
	if ESX then
		if GetResourceState("esx_addonaccount") == "started" then
			TriggerEvent('esx_addonaccount:getSharedAccount', company, function(account)
				if account then
					account.removeMoney(amount)
				else
					print("Company account not found!")
				end
			end)
		end
	elseif QBCore or QBX then
		if GetResourceState("qb-management") == "started" then
			exports['qb-management']:RemoveMoney(company, amount)
		end
	end
end