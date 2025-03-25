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
COLLATE='utf8mb3_general_ci'
ENGINE=InnoDB
AUTO_INCREMENT=2;

CREATE TABLE `property_furniture` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`propertyId` INT(11) NOT NULL DEFAULT '0',
	`type` VARCHAR(50) NOT NULL DEFAULT '0' COLLATE 'utf8mb4_uca1400_ai_ci',
	`chunkId` VARCHAR(50) NOT NULL DEFAULT '0' COLLATE 'utf8mb4_uca1400_ai_ci',
	`furniture` LONGTEXT NOT NULL COLLATE 'utf8mb4_uca1400_ai_ci',
	PRIMARY KEY (`id`) USING BTREE,
	UNIQUE INDEX `unique_furniture` (`propertyId`, `type`, `chunkId`) USING BTREE
)
COLLATE='utf8mb3_general_ci'
ENGINE=InnoDB;

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
COLLATE='utf8mb3_general_ci'
ENGINE=InnoDB;
