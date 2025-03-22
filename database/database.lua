Database = {}


function Database.GetPropertyDatas()
    return MySQL.query.await('SELECT id, apartmentId, street, location, door, garageDoor, exterior, owner, permissions, shellData FROM properties')
end

function Database.GetFurniture(propertyId, type)
    local rows = MySQL.query.await(
        "SELECT chunkId, furniture FROM property_furniture WHERE propertyId = ? AND type = ?",
        { propertyId, type }
    )

    local furnitureData = {}

    if rows and #rows > 0 then
        for _, row in ipairs(rows) do
            furnitureData[row.chunkId] = json.decode(row.furniture)
        end
    end

    return furnitureData
end


function Database.UpdateFurniture(data)
    MySQL.execute(
        "INSERT INTO property_furniture (propertyId, type, chunkId, furniture) " ..
        "VALUES (:propertyId, :type, :chunkId, :furniture) " ..
        "ON DUPLICATE KEY UPDATE furniture = VALUES(furniture)", 
        {
            ['propertyId'] = data.propertyId,
            ['type'] = data.type,
            ['chunkId'] = data.chunkId,
            ['furniture'] = json.encode(data.furniture),
        },
        function(rowsChanged)
            if rowsChanged then
            end
        end
    )
end

function Database.SavePermissions(propertyId, owner, permissions)
    MySQL.update("UPDATE properties SET permissions = ?, owner = ? WHERE id = ?", {
        json.encode(permissions),
        owner,
        propertyId
    })
end

function Database.SaveVehicles(propertyId, vehicles)
    MySQL.update("UPDATE properties SET vehicles = ? WHERE id = ?", {
        json.encode(vehicles),
        propertyId
    })
end

function Database.GetVehicles(propertyId)
    local result = MySQL.query.await("SELECT vehicles FROM properties WHERE id = ?", { propertyId })

    if result and result[1] then
        return json.decode(result[1].vehicles) -- Decode JSON data if found
    end

    return {} -- Return an empty table if no data is found
end

function Database.CreateProperty(data, callback)
    local columns = {}
    local values = {}
    local parameters = {}

    for key, value in pairs(data) do
        if Database.propertiesCols[key] then
            table.insert(columns, key)
            local paramKey = '@' .. key
            table.insert(values, paramKey)

            local valueType = type(value)
            
            if valueType == "vector3" or valueType == "vector4" then
                parameters[paramKey] = json.encode({
                    x = value.x,
                    y = value.y,
                    z = value.z,
                    w = value.w
                })
            elseif valueType == "table" then
                parameters[paramKey] = json.encode(value)
            else
                parameters[paramKey] = value
            end
        end
    end

    local query = string.format(
        "INSERT INTO properties (%s) VALUES (%s)", 
        table.concat(columns, ", "), 
        table.concat(values, ", ")
    )

    MySQL.execute(query, parameters, function(rowsChanged)
        if rowsChanged and rowsChanged.insertId then
            data.id = rowsChanged.insertId
            callback(data)
        end
    end)
end



function Database.UpdateProperty(data)
    local setClauses = {}
    local parameters = { ['id'] = data.id }
    for key, value in pairs(data) do
        if key ~= 'id' and Database.propertiesCols[key] then
            local paramKey = '@' .. key
            table.insert(setClauses, key .. ' = ' .. paramKey)

            local valueType = type(value)

            if valueType == "vector3" or valueType == "vector4" then
                parameters[paramKey] = json.encode({
                    x = value.x,
                    y = value.y,
                    z = value.z,
                    w = value.w
                })
            elseif valueType == "table" then
                parameters[paramKey] = json.encode(value)
            else
                parameters[paramKey] = value
            end
        end
    end
    local setQuery = table.concat(setClauses, ", ")
    local query = string.format("UPDATE properties SET %s WHERE id = @id", setQuery)
    MySQL.execute(query, parameters)
end


function Database.GetOwnedCount(owner)
    local result = MySQL.query.await(
        "SELECT COUNT(*) AS count FROM properties WHERE owner = ?",
        { owner }
    )

    if result and result[1] then
        return result[1].count
    end
    return 0
end

function Database.GetPropertyByOwner(owner)
    return MySQL.query.await(
        "SELECT id, owner, apartmentId, street, price, images FROM properties WHERE owner = ?",
        { owner }
    )
end

function Database.GetPropertyByApartmentId(apartmentId)
    return MySQL.query.await(
        "SELECT id, owner, apartmentId, street, price, images FROM properties WHERE apartmentId = ?",
        { apartmentId }
    )
end

function Database.GetUnlistedProperties()
    return MySQL.query.await(
        "SELECT id, owner, apartmentId, street, price, images FROM properties WHERE status = ? and owner = ?",
        { 0, Config.realtorJobName }
    )
end

function Database.GetLocations(data)
    return MySQL.query.await(
        "SELECT location FROM properties WHERE status = ?",
        { 1 }
    )
end

function Database.GetPropertiesByLocation(location)
    return MySQL.query.await(
        "SELECT id, owner, apartmentId, street, price, images  FROM properties WHERE status = ? AND location = ?",
        { 1, location }
    )
end

function Database.GetPropertyData(id)
    return MySQL.query.await(
        "SELECT * FROM properties WHERE id = ?",
        { id }
    )
end

function Database.GetOffers(key, value)
    return MySQL.query.await(
        "SELECT * FROM property_offers WHERE "..key.."= ?", {value}
    )
end

function Database.RemoveOffers(key, value)
    MySQL.query.await(
        "DELETE FROM property_offers WHERE "..key.."= ?", {value}
    )
end


function Database.CreateOffer(offerData)
    MySQL.query.await(
        "INSERT INTO property_offers (propertyId, owner, location, street, identifier, phone, name, price, askingPrice) " ..
        "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)", 
        {
            offerData.propertyId, 
            offerData.owner, 
            offerData.location, 
            offerData.street, 
            offerData.identifier, 
            offerData.phone, 
            offerData.name, 
            offerData.price, 
            offerData.askingPrice
        }
    )
end


----- Init -----
local propertyCols = {"id", "owner", "apartmentId", "street", "location", "permissions", "status", "shellData", "door", "garageDoor", "exterior", "vehicles", "price", "description", "images"}
Database.propertiesCols = {}
for i=1,#propertyCols do
    Database.propertiesCols[propertyCols[i]] = true
end



-- Function to fetch property data from the database
function Database.GetPropertyDatas()
    return MySQL.query.await('SELECT id, apartmentId, street, location, door, garageDoor, exterior, owner, permissions, shellData FROM properties')
end

-- Function to initialize the database (check and create tables if necessary)
function InitializePropertyTables()
    local expectedColumns = {
        properties = {
            id = "INT(11) NOT NULL AUTO_INCREMENT",
            owner = "VARCHAR(46) NULL DEFAULT NULL COLLATE 'utf8mb4_uca1400_ai_ci'",
            apartmentId = "VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8mb4_uca1400_ai_ci'",
            street = "VARCHAR(200) NOT NULL DEFAULT '0' COLLATE 'utf8mb4_uca1400_ai_ci'",
            location = "VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8mb4_uca1400_ai_ci'",
            permissions = "LONGTEXT NULL DEFAULT '[]' COLLATE 'utf8mb4_uca1400_ai_ci'",
            status = "INT(11) NULL DEFAULT '0'",
            shellData = "VARCHAR(200) NULL DEFAULT '[]' COLLATE 'utf8mb4_uca1400_ai_ci'",
            door = "VARCHAR(200) NOT NULL DEFAULT '[]' COLLATE 'utf8mb4_uca1400_ai_ci'",
            garageDoor = "VARCHAR(200) NOT NULL DEFAULT '[]' COLLATE 'utf8mb4_uca1400_ai_ci'",
            exterior = "LONGTEXT NOT NULL DEFAULT '[]' COLLATE 'utf8mb4_uca1400_ai_ci'",
            vehicles = "LONGTEXT NOT NULL DEFAULT '[]' COLLATE 'utf8mb4_uca1400_ai_ci'",
            price = "INT(11) NULL DEFAULT NULL",
            description = "VARCHAR(300) NULL DEFAULT NULL COLLATE 'utf8mb4_uca1400_ai_ci'",
            images = "LONGTEXT NULL DEFAULT '[]' COLLATE 'utf8mb4_uca1400_ai_ci'"
        },
        property_furniture = {
            id = "INT(11) NOT NULL AUTO_INCREMENT",
            propertyId = "INT(11) NOT NULL DEFAULT '0'",
            type = "VARCHAR(50) NOT NULL DEFAULT '0' COLLATE 'utf8mb4_uca1400_ai_ci'",
            chunkId = "VARCHAR(50) NOT NULL DEFAULT '0' COLLATE 'utf8mb4_uca1400_ai_ci'",
            furniture = "LONGTEXT NOT NULL COLLATE 'utf8mb4_uca1400_ai_ci'"
        },
        property_offers = {
            id = "INT(11) NOT NULL AUTO_INCREMENT",
            propertyId = "INT(11) NULL DEFAULT NULL",
            owner = "VARCHAR(46) NULL DEFAULT NULL COLLATE 'utf8mb4_uca1400_ai_ci'",
            location = "VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8mb4_uca1400_ai_ci'",
            street = "VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8mb4_uca1400_ai_ci'",
            identifier = "VARCHAR(46) NULL DEFAULT NULL COLLATE 'utf8mb4_uca1400_ai_ci'",
            phone = "VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8mb4_uca1400_ai_ci'",
            name = "VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8mb4_uca1400_ai_ci'",
            price = "INT(11) NULL DEFAULT NULL",
            askingPrice = "INT(11) NULL DEFAULT NULL"
        }
    }

    -- Ensuring tables exist and checking for missing columns
    local function checkAndAddColumns(tableName, expectedCols)
        MySQL.query("SHOW COLUMNS FROM `" .. tableName .. "`", {}, function(results)
            if results then
                local existingCols = {}
                for _, col in ipairs(results) do
                    existingCols[col.Field] = true
                end

                for colName, colDefinition in pairs(expectedCols) do
                    if not existingCols[colName] then
                        MySQL.query("ALTER TABLE `" .. tableName .. "` ADD COLUMN `" .. colName .. "` " .. colDefinition, {}, function()
                            print("Column `" .. colName .. "` added to table `" .. tableName .. "`.")
                        end)
                    end
                end
            end
        end)
    end

    -- Function to check if a table exists and create if not
    local function ensureTableExists(tableName, createSQL, expectedCols)
        MySQL.query("SHOW TABLES LIKE '" .. tableName .. "'", {}, function(result)
            if #result == 0 then
                MySQL.query(createSQL, {}, function()
                    print("Table '" .. tableName .. "' created.")
                end)
            else
                print("Table '" .. tableName .. "' already exists. Checking for missing columns...")
                checkAndAddColumns(tableName, expectedCols)
            end
        end)
    end

    -- Ensure all tables exist and have the correct columns
    ensureTableExists("properties", [[
        CREATE TABLE `properties` (
            `id` INT(11) NOT NULL AUTO_INCREMENT,
            `owner` VARCHAR(46) NULL DEFAULT NULL COLLATE 'utf8mb4_uca1400_ai_ci',
            `apartmentId` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8mb4_uca1400_ai_ci',
            `street` VARCHAR(200) NOT NULL DEFAULT '0' COLLATE 'utf8mb4_uca1400_ai_ci',
            `location` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8mb4_uca1400_ai_ci',
            `permissions` LONGTEXT NULL DEFAULT '[]' COLLATE 'utf8mb4_uca1400_ai_ci',
            `status` INT(11) NULL DEFAULT '0',
            `shellData` VARCHAR(200) NULL DEFAULT '[]' COLLATE 'utf8mb4_uca1400_ai_ci',
            `door` VARCHAR(200) NOT NULL DEFAULT '[]' COLLATE 'utf8mb4_uca1400_ai_ci',
            `garageDoor` VARCHAR(200) NOT NULL DEFAULT '[]' COLLATE 'utf8mb4_uca1400_ai_ci',
            `exterior` LONGTEXT NOT NULL DEFAULT '[]' COLLATE 'utf8mb4_uca1400_ai_ci',
            `vehicles` LONGTEXT NOT NULL DEFAULT '[]' COLLATE 'utf8mb4_uca1400_ai_ci',
            `price` INT(11) NULL DEFAULT NULL,
            `description` VARCHAR(300) NULL DEFAULT NULL COLLATE 'utf8mb4_uca1400_ai_ci',
            `images` LONGTEXT NULL DEFAULT '[]' COLLATE 'utf8mb4_uca1400_ai_ci',
            PRIMARY KEY (`id`) USING BTREE
        )
        ENGINE=InnoDB
        AUTO_INCREMENT=1;
    ]], expectedColumns.properties)

    ensureTableExists("property_furniture", [[
        CREATE TABLE `property_furniture` (
            `id` INT(11) NOT NULL AUTO_INCREMENT,
            `propertyId` INT(11) NOT NULL DEFAULT '0',
            `type` VARCHAR(50) NOT NULL DEFAULT '0' COLLATE 'utf8mb4_uca1400_ai_ci',
            `chunkId` VARCHAR(50) NOT NULL DEFAULT '0' COLLATE 'utf8mb4_uca1400_ai_ci',
            `furniture` LONGTEXT NOT NULL COLLATE 'utf8mb4_uca1400_ai_ci',
            PRIMARY KEY (`id`) USING BTREE,
            UNIQUE KEY `unique_furniture` (`propertyId`, `type`, `chunkId`) USING BTREE
        )
        ENGINE=InnoDB
        AUTO_INCREMENT=1;
    ]], expectedColumns.property_furniture)

    ensureTableExists("property_offers", [[
        CREATE TABLE `property_offers` (
            `id` INT(11) NOT NULL AUTO_INCREMENT,
            `propertyId` INT(11) NULL DEFAULT NULL,
            `owner` VARCHAR(46) NULL DEFAULT NULL COLLATE 'utf8mb4_uca1400_ai_ci',
            `location` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8mb4_uca1400_ai_ci',
            `street` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8mb4_uca1400_ai_ci',
            `identifier` VARCHAR(46) NULL DEFAULT NULL COLLATE 'utf8mb4_uca1400_ai_ci',
            `phone` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8mb4_uca1400_ai_ci',
            `name` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8mb4_uca1400_ai_ci',
            `price` INT(11) NULL DEFAULT NULL,
            `askingPrice` INT(11) NULL DEFAULT NULL,
            PRIMARY KEY (`id`) USING BTREE
        )
        ENGINE=InnoDB
        AUTO_INCREMENT=1;
    ]], expectedColumns.property_offers)
end

InitializePropertyTables()