--- You might want do do changes here --
function Database.AddBankMoney(identifier, amount)

    -- Renewed exports["Renewed-Banking"]:AddAccountMoney(identifier, amount)

    -- ESX --

    --------

    -- QBX --
    local result = MySQL.query.await("SELECT money FROM players WHERE citizenid = ?", { identifier })

    if result and #result > 0 then
        local money = json.decode(result[1].money)
        money.bank = money.bank + amount
        MySQL.update("UPDATE players SET money = ? WHERE citizenid = ?", { json.encode(money), identifier })
    else
        print("No bank account found for identifier: " .. identifier)
    end

    -- QB --
    -- local result = MySQL.query.await("SELECT account_balance FROM bank_accounts WHERE citizenid = ?", { identifier })

    -- if result and #result > 0 then
    --     local newBalance = result[1].account_balance + amount
    --     MySQL.update("UPDATE bank_accounts SET account_balance = ? WHERE citizenid = ?", { newBalance, identifier })
    -- else
    --     print("No bank account found for identifier: " .. identifier)
    -- end
end




function Database.GetVehicleProperties(plate) 
    -- qbx_garages
    local data = MySQL.query.await("SELECT mods FROM player_vehicles WHERE plate = ?", { plate })
    return {
        properties = data[1] ~= nil and json.decode(data[1].mods) or nil 
    }

    -- local data = MySQL.query.await("SELECT vehicle, components FROM owned_vehicles WHERE plate = ?", { plate })
    -- return data ~= nil and data[1]
end 
----------------------------------------