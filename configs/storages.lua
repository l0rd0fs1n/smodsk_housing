-- Make sure blockedModels have loaded before running this
Wait(100)

StorageData = {}
Storages = {
    categories = {
        { name = "Storages", label = GetLocale("STORAGES") },
    },
    furniture = {
        ["Storages"] = {
            -- Menu gap...
            margin = 1.0, -- Dont mind about this.. its always 1.0
            models = {
                -- "Here, you can define storage prop models, set their prices, and determine the number of slots each storage has. --
                { model = "prop_devin_box_closed", price = 500, slots = 5 },
                { model = "prop_mil_crate_01", price = 1000, slots = 10 },
                { model = "prop_mil_crate_02", price = 20, slots = 20 },
                { model = "prop_ld_int_safe_01", price = 20, slots = 20 },
                { model = "prop_toolchest_05", price = 20, slots = 20 },
            }
        } 
    }
}


-- Rebuild data for prop_selector
for i=1,#Storages.furniture["Storages"].models do 
    local data = Storages.furniture["Storages"].models[i]
    Storages.furniture["Storages"].models[i].text = GetLocale("PRICE").." "..data.price..GetLocale("MONEY_SYMBOL").."\n"..GetLocale("SLOTS").." "..data.slots
    StorageData[GetHashKey(data.model)] = { price = data.price, slots = data.slots }
    AddToBlockedModels(data.model)
end