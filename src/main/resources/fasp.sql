-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema fasp
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `fasp` ;

-- -----------------------------------------------------
-- Schema fasp
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `fasp` DEFAULT CHARACTER SET utf8 COLLATE utf8_bin ;
USE `fasp` ;

-- -----------------------------------------------------
-- Table `fasp`.`ap_language`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `fasp`.`ap_language` ;

CREATE TABLE IF NOT EXISTS `fasp`.`ap_language` (
  `LANGUAGE_ID` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Unique Id for each Language that we support, this includes Db languages and UI languages',
  `LANGUAGE_NAME` VARCHAR(100) NOT NULL COMMENT 'Language name, no need for a Label here since the Language name will be in the required language',
  `ACTIVE` TINYINT(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'If True indicates this Language is Active. False indicates this Language has been De-activated',
  `CREATED_BY` INT(10) UNSIGNED NOT NULL COMMENT 'Created by',
  `CREATED_DATE` DATETIME NOT NULL COMMENT 'Created date',
  `LAST_MODIFIED_BY` INT(10) UNSIGNED NOT NULL COMMENT 'Last Modified By',
  `LAST_MODIFIED_DATE` DATETIME NOT NULL COMMENT 'Last Modified date',
  PRIMARY KEY (`LANGUAGE_ID`),
  CONSTRAINT `fk_language_createdBy`
    FOREIGN KEY (`CREATED_BY`)
    REFERENCES `fasp`.`us_user` (`USER_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_language_lastModifiedBy`
    FOREIGN KEY (`LAST_MODIFIED_BY`)
    REFERENCES `fasp`.`us_user` (`USER_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Table used to store the different Languages availale in the Application\nNote: A Language cannot be created or administered it is at the Application level';

CREATE INDEX `fk_language_createdBy_idx` ON `fasp`.`ap_language` (`CREATED_BY` ASC);

CREATE INDEX `fk_language_lastModifiedBy_idx` ON `fasp`.`ap_language` (`LAST_MODIFIED_BY` ASC);

CREATE UNIQUE INDEX `unqLanguageName` ON `fasp`.`ap_language` (`LANGUAGE_NAME` ASC)  COMMENT 'Language name should be unique';


-- -----------------------------------------------------
-- Table `fasp`.`ap_label`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `fasp`.`ap_label` ;

CREATE TABLE IF NOT EXISTS `fasp`.`ap_label` (
  `LABEL_ID` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Unique Id for each Label',
  `LABEL_EN` VARCHAR(255) NOT NULL COMMENT 'Label in English, cannot be Null since it is language the system will default to',
  `LABEL_FR` VARCHAR(255) NULL COMMENT 'Label in French',
  `LABEL_SP` VARCHAR(255) NULL COMMENT 'Label in Spanish',
  `LABEL_PR` VARCHAR(255) NULL COMMENT 'Label in Pourtegese',
  `CREATED_BY` INT(10) UNSIGNED NOT NULL COMMENT 'Created by',
  `CREATED_DATE` DATETIME NOT NULL COMMENT 'Created date',
  `LAST_MODIFIED_BY` INT(10) UNSIGNED NOT NULL COMMENT 'Last Modified By',
  `LAST_MODIFIED_DATE` DATETIME NOT NULL COMMENT 'Last Modified Date\n',
  PRIMARY KEY (`LABEL_ID`),
  CONSTRAINT `fk_label_createdBy`
    FOREIGN KEY (`CREATED_BY`)
    REFERENCES `fasp`.`us_user` (`USER_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_label_lastModifiedBy`
    FOREIGN KEY (`LAST_MODIFIED_BY`)
    REFERENCES `fasp`.`us_user` (`USER_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Table used to store the different Languages availale in the Application\nNote: A Language cannot be created it is one of a Fixed Master';

CREATE INDEX `fk_label_createdBy_idx` ON `fasp`.`ap_label` (`CREATED_BY` ASC);

CREATE INDEX `fk_label_lastModifiedBy_idx` ON `fasp`.`ap_label` (`LAST_MODIFIED_BY` ASC);


-- -----------------------------------------------------
-- Table `fasp`.`rm_realm`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `fasp`.`rm_realm` ;

CREATE TABLE IF NOT EXISTS `fasp`.`rm_realm` (
  `REALM_ID` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Unique Id for each Realm',
  `REALM_CODE` VARCHAR(6) NOT NULL COMMENT 'Unique Code for each Realm, will be given at the time of creation and cannot be edited',
  `LABEL_ID` INT(10) UNSIGNED NOT NULL COMMENT 'Label Id that points to the label table so that we can get the text in different languages',
  `MONTHS_IN_PAST_FOR_AMC` INT(10) UNSIGNED NOT NULL COMMENT 'No of months that we should go back in the past to calculate AMC. Default to be used when we create a Program',
  `MONTHS_IN_FUTURE_FOR_AMC` INT(10) UNSIGNED NOT NULL COMMENT 'No of months that we should go into the future to calculate AMC. Default to be used when we create a Program',
  `ORDER_FREQUENCY` INT(10) UNSIGNED NOT NULL COMMENT 'In how many months do you want to place orders. Default to be used when we create a Program',
  `DEFAULT_REALM` TINYINT(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'If True indicates this Realm is the Default Realm for the Application',
  `ACTIVE` TINYINT(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'If True indicates this Realm is Active. False indicates this Realm has been De-activated',
  `CREATED_BY` INT(10) UNSIGNED NOT NULL COMMENT 'Created by',
  `CREATED_DATE` DATETIME NOT NULL,
  `LAST_MODIFIED_BY` INT(10) UNSIGNED NOT NULL COMMENT 'Last modified by',
  `LAST_MODIFIED_DATE` DATETIME NOT NULL COMMENT '\n\n',
  PRIMARY KEY (`REALM_ID`),
  CONSTRAINT `fk_realm_labelId`
    FOREIGN KEY (`LABEL_ID`)
    REFERENCES `fasp`.`ap_label` (`LABEL_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_realm_createdBy`
    FOREIGN KEY (`CREATED_BY`)
    REFERENCES `fasp`.`us_user` (`USER_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_realm_lastModifiedBy`
    FOREIGN KEY (`LAST_MODIFIED_BY`)
    REFERENCES `fasp`.`us_user` (`USER_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Table used to store the different Realms using the application\nNote: A Realm cannot be created in the App but must be created on the Online portal only, Can be created only by Application Admins, but be administered by Realm Admin';

CREATE INDEX `fk_realm_labelId_idx` ON `fasp`.`rm_realm` (`LABEL_ID` ASC);

CREATE INDEX `fk_realm_createdBy_idx` ON `fasp`.`rm_realm` (`CREATED_BY` ASC);

CREATE INDEX `fk_realm_lastModifiedBy_idx` ON `fasp`.`rm_realm` (`LAST_MODIFIED_BY` ASC);

CREATE UNIQUE INDEX `REALM_CODE_UNIQUE` ON `fasp`.`rm_realm` (`REALM_CODE` ASC);


-- -----------------------------------------------------
-- Table `fasp`.`us_user`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `fasp`.`us_user` ;

CREATE TABLE IF NOT EXISTS `fasp`.`us_user` (
  `USER_ID` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Unique User Id for each User',
  `REALM_ID` INT(10) UNSIGNED NOT NULL COMMENT 'Realm Id that the User belongs to',
  `USERNAME` VARCHAR(25) NOT NULL COMMENT 'Username used to login',
  `PASSWORD` TINYBLOB NOT NULL COMMENT 'Encrypted password for the User\nOffline notes: Password cannot be updated when a User is offline',
  `EMAIL_ID` VARCHAR(50) NULL,
  `PHONE` VARCHAR(15) NULL,
  `LANGUAGE_ID` INT(10) UNSIGNED NOT NULL,
  `ACTIVE` TINYINT(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'True indicates the User is actvie and False indicates the User has been De-activated\nOffline notes: Even if a User has been De-activated Online, he will still be able to use the Offline version until he reaches his Last Sync by date',
  `FAILED_ATTEMPTS` TINYINT(3) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Number of failed attempts that have been made to login to the application from this User Id\nOffline notes: Number will be incremented in the Offline mode as well and the only way to unlock it in Offline mode after it hits 3 attempts is to go online and then sync it with the Live Db where a Realm level Admin will be able to reset the password for you\n',
  `EXPIRES_ON` DATETIME NOT NULL COMMENT 'Date the Password for the User expires on. User will be forced to enter a new Password',
  `SYNC_EXPIRES_ON` DATETIME NOT NULL COMMENT 'Date after which the User will have to run a Sync to continue using the Offline version',
  `LAST_LOGIN_DATE` DATETIME NULL COMMENT 'Date the user last logged into the application. Null if no login has been done as yet.',
  `CREATED_BY` INT(10) UNSIGNED NOT NULL COMMENT 'Created by',
  `CREATED_DATE` DATETIME NOT NULL COMMENT 'Created date',
  `LAST_MODIFIED_BY` INT(10) UNSIGNED NOT NULL COMMENT 'Last modified by',
  `LAST_MODIFIED_DATE` DATETIME NOT NULL COMMENT 'Last modified date',
  PRIMARY KEY (`USER_ID`),
  CONSTRAINT `fk_user_createdBy`
    FOREIGN KEY (`CREATED_BY`)
    REFERENCES `fasp`.`us_user` (`USER_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_user_lastModifiedBy`
    FOREIGN KEY (`LAST_MODIFIED_BY`)
    REFERENCES `fasp`.`us_user` (`USER_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_user_languageId`
    FOREIGN KEY (`LANGUAGE_ID`)
    REFERENCES `fasp`.`ap_language` (`LANGUAGE_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_user_realmId`
    FOREIGN KEY (`REALM_ID`)
    REFERENCES `fasp`.`rm_realm` (`REALM_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
COMMENT = 'Table used for lisiting all the Users that are going to access the system';

CREATE UNIQUE INDEX `USERNAME_UNIQUE` ON `fasp`.`us_user` (`USERNAME` ASC);

CREATE INDEX `fk_user_createdBy_idx` ON `fasp`.`us_user` (`CREATED_BY` ASC);

CREATE INDEX `fk_user_lastModifiedBy_idx` ON `fasp`.`us_user` (`LAST_MODIFIED_BY` ASC);

CREATE INDEX `fk_user_languageId_idx` ON `fasp`.`us_user` (`LANGUAGE_ID` ASC);

CREATE INDEX `fk_user_realmId_idx` ON `fasp`.`us_user` (`REALM_ID` ASC);


-- -----------------------------------------------------
-- Table `fasp`.`ap_currency`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `fasp`.`ap_currency` ;

CREATE TABLE IF NOT EXISTS `fasp`.`ap_currency` (
  `CURRENCY_ID` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Unique Id for each Currency',
  `CURRENCY_CODE` VARCHAR(4) NOT NULL COMMENT 'Unique Code for each Currency',
  `CURRENCY_SYMBOL` VARCHAR(3) NULL COMMENT 'Currency symbol',
  `LABEL_ID` INT(10) UNSIGNED NOT NULL COMMENT 'Label Id that points to the label table so that we can get the text in different languages',
  `CONVERSION_RATE_TO_USD` DECIMAL(14,4) UNSIGNED NOT NULL COMMENT 'Latest conversion rate to USD',
  `CREATED_BY` INT(10) UNSIGNED NOT NULL COMMENT 'Created by',
  `CREATED_DATE` DATETIME NOT NULL COMMENT 'Created date',
  `LAST_MODIFIED_BY` INT(10) UNSIGNED NOT NULL COMMENT 'Last Modified by',
  `LAST_MODIFIED_DATE` DATETIME NOT NULL COMMENT 'Last Modified date',
  PRIMARY KEY (`CURRENCY_ID`),
  CONSTRAINT `fk_currency_labelId`
    FOREIGN KEY (`LABEL_ID`)
    REFERENCES `fasp`.`ap_label` (`LABEL_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_currency_createdBy`
    FOREIGN KEY (`CREATED_BY`)
    REFERENCES `fasp`.`us_user` (`USER_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_currency_lastModifiedBy`
    FOREIGN KEY (`LAST_MODIFIED_BY`)
    REFERENCES `fasp`.`us_user` (`USER_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Table used to store the different Currencies in the application\nNote: A Currency cannot be created it is one of a Fixed Master';

CREATE UNIQUE INDEX `CURRENCY_CODE_UNIQUE` ON `fasp`.`ap_currency` (`CURRENCY_CODE` ASC);

CREATE INDEX `fk_currency_labelId_idx` ON `fasp`.`ap_currency` (`LABEL_ID` ASC);

CREATE INDEX `fk_currency_createdBy_idx` ON `fasp`.`ap_currency` (`CREATED_BY` ASC);

CREATE INDEX `fk_currency_lastModifiedBy_idx` ON `fasp`.`ap_currency` (`LAST_MODIFIED_BY` ASC);

CREATE UNIQUE INDEX `unq_currencyCode` ON `fasp`.`ap_currency` (`CURRENCY_CODE` ASC)  COMMENT 'Currency Code musy be unique';


-- -----------------------------------------------------
-- Table `fasp`.`ap_country`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `fasp`.`ap_country` ;

CREATE TABLE IF NOT EXISTS `fasp`.`ap_country` (
  `COUNTRY_ID` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Unique Id for each Country',
  `LABEL_ID` INT(10) UNSIGNED NOT NULL COMMENT 'Label Id that points to the label table so that we can get the text in different languages',
  `COUNTRY_CODE` VARCHAR(3) NOT NULL COMMENT 'Code for each country. Will take the data from the ISO Country list',
  `CURRENCY_ID` INT(10) UNSIGNED NOT NULL COMMENT 'Local Currency used by this country',
  `LANGUAGE_ID` INT(10) UNSIGNED NOT NULL COMMENT 'Default Language used by this Country',
  `ACTIVE` TINYINT(1) UNSIGNED NOT NULL COMMENT 'If True indicates this Country is Active. False indicates this Country has been De-activated',
  `CREATED_BY` INT(10) UNSIGNED NOT NULL COMMENT 'Created by',
  `CREATED_DATE` DATETIME NOT NULL COMMENT 'Created date',
  `LAST_MODIFIED_BY` INT(10) UNSIGNED NOT NULL COMMENT 'Last modified by',
  `LAST_MODIFIED_DATE` DATETIME NOT NULL COMMENT 'Last modified date',
  PRIMARY KEY (`COUNTRY_ID`),
  CONSTRAINT `fk_country_labelId`
    FOREIGN KEY (`LABEL_ID`)
    REFERENCES `fasp`.`ap_label` (`LABEL_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_country_currencyId`
    FOREIGN KEY (`CURRENCY_ID`)
    REFERENCES `fasp`.`ap_currency` (`CURRENCY_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_country_languageId`
    FOREIGN KEY (`LANGUAGE_ID`)
    REFERENCES `fasp`.`ap_language` (`LANGUAGE_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_country_createdBy`
    FOREIGN KEY (`CREATED_BY`)
    REFERENCES `fasp`.`us_user` (`USER_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_country_lastModifiedBy`
    FOREIGN KEY (`LAST_MODIFIED_BY`)
    REFERENCES `fasp`.`us_user` (`USER_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Table used to store the different Countries inside a Realm\nNote: This is a master list of Countries stored at the Application level, cannot be created and edited by Realm admins';

CREATE INDEX `fk_country_labelId_idx` ON `fasp`.`ap_country` (`LABEL_ID` ASC);

CREATE INDEX `fk_country_currencyId_idx` ON `fasp`.`ap_country` (`CURRENCY_ID` ASC);

CREATE INDEX `fk_country_languageId_idx` ON `fasp`.`ap_country` (`LANGUAGE_ID` ASC);

CREATE INDEX `fk_country_createdBy_idx` ON `fasp`.`ap_country` (`CREATED_BY` ASC);

CREATE INDEX `fk_country_lastModifiedBy_idx` ON `fasp`.`ap_country` (`LAST_MODIFIED_BY` ASC);

CREATE UNIQUE INDEX `unq_countryCode` ON `fasp`.`ap_country` (`COUNTRY_CODE` ASC)  COMMENT 'Unique Country Code ';


-- -----------------------------------------------------
-- Table `fasp`.`ap_currency_history`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `fasp`.`ap_currency_history` ;

CREATE TABLE IF NOT EXISTS `fasp`.`ap_currency_history` (
  `CURRENCY_HISTORY_ID` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Unique Id for each Currency Transaction that we have pulled',
  `CURRENCY_ID` INT(10) UNSIGNED NOT NULL COMMENT 'The Currency id that this data is for',
  `CONVERSION_RATE_TO_USD` DECIMAL(14,4) NOT NULL COMMENT 'Conversion rate to USD\n',
  `LAST_MODIFIED_DATE` DATETIME NOT NULL COMMENT 'Last Modified date',
  PRIMARY KEY (`CURRENCY_HISTORY_ID`),
  CONSTRAINT `fk_currency_history_currencyId`
    FOREIGN KEY (`CURRENCY_ID`)
    REFERENCES `fasp`.`ap_currency` (`CURRENCY_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Table used to store the historical values of Exchange rate for each currency\nNote: Updated automatically by the application';

CREATE INDEX `fk_currency_history_currencyId_idx` ON `fasp`.`ap_currency_history` (`CURRENCY_ID` ASC);


-- -----------------------------------------------------
-- Table `fasp`.`rm_realm_country`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `fasp`.`rm_realm_country` ;

CREATE TABLE IF NOT EXISTS `fasp`.`rm_realm_country` (
  `REALM_COUNTRY_ID` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Unique Id for each Realm - Country mapping',
  `REALM_ID` INT(10) UNSIGNED NOT NULL COMMENT 'Foreign key that determines the Realm this Mapping belongs to',
  `COUNTRY_ID` INT(10) UNSIGNED NOT NULL COMMENT 'Foreign key that determines the Country this Mapping belongs to',
  `DEFAULT_CURRENCY_ID` INT UNSIGNED NOT NULL COMMENT 'Currency Id that this Country should Default to',
  `PALLET_UNIT_ID` INT(10) UNSIGNED NOT NULL COMMENT 'Default Pallet size that the country uses',
  `AIR_FREIGHT_PERC` DECIMAL(12,2) UNSIGNED NULL COMMENT 'Percentage of Order Qty when Mode = Air',
  `SEA_FREIGHT_PERC` DECIMAL(12,2) UNSIGNED NULL COMMENT 'Percentage of Order Qty when Mode = Sea',
  `SHIPPED_TO_ARRIVED_AIR_LEAD_TIME` INT(10) UNSIGNED NULL COMMENT 'No of days for an Order to move from Shipped to Arrived status where mode = Air',
  `SHIPPED_TO_ARRIVED_SEA_LEAD_TIME` INT(10) UNSIGNED NULL COMMENT 'No of days for an Order to move from Shipped to Arrived status where mode = Sea',
  `ARRIVED_TO_DELIVERED_LEAD_TIME` INT(10) UNSIGNED NULL COMMENT 'No of days for an Order to move from Arrived to Delivered status',
  `ACTIVE` TINYINT(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'If True indicates this Mapping is Active. False indicates this Mapping has been De-activated',
  `CREATED_BY` INT(10) UNSIGNED NOT NULL COMMENT 'Created by',
  `CREATED_DATE` DATETIME NOT NULL COMMENT 'Created date',
  `LAST_MODIFIED_BY` INT(10) UNSIGNED NOT NULL COMMENT 'Last modified by',
  `LAST_MODIFIED_DATE` DATETIME NOT NULL COMMENT 'Last modified date',
  PRIMARY KEY (`REALM_COUNTRY_ID`),
  CONSTRAINT `fk_realm_country_realmId`
    FOREIGN KEY (`REALM_ID`)
    REFERENCES `fasp`.`rm_realm` (`REALM_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_realm_country_countryId`
    FOREIGN KEY (`COUNTRY_ID`)
    REFERENCES `fasp`.`ap_country` (`COUNTRY_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_realm_country_currencyId`
    FOREIGN KEY (`DEFAULT_CURRENCY_ID`)
    REFERENCES `fasp`.`ap_currency` (`CURRENCY_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_realm_country_createdBy`
    FOREIGN KEY (`CREATED_BY`)
    REFERENCES `fasp`.`us_user` (`USER_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_realm_country_lastModifiedBy`
    FOREIGN KEY (`LAST_MODIFIED_BY`)
    REFERENCES `fasp`.`us_user` (`USER_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Table used to map which Countries are used by the Realm\nNote: Show the list of all Countries and let the Realm Admin select which Country he wants to include in the Realm';

CREATE INDEX `fk_realm_country_realmId_idx` ON `fasp`.`rm_realm_country` (`REALM_ID` ASC);

CREATE INDEX `fk_realm_country_countryId_idx` ON `fasp`.`rm_realm_country` (`COUNTRY_ID` ASC);

CREATE INDEX `fk_realm_country_currencyId_idx` ON `fasp`.`rm_realm_country` (`DEFAULT_CURRENCY_ID` ASC);

CREATE INDEX `fk_realm_country_createdBy_idx` ON `fasp`.`rm_realm_country` (`CREATED_BY` ASC);

CREATE INDEX `fk_realm_country_lastModifiedBy_idx` ON `fasp`.`rm_realm_country` (`LAST_MODIFIED_BY` ASC);

CREATE UNIQUE INDEX `unqRealmIdCountryId` ON `fasp`.`rm_realm_country` (`REALM_ID` ASC, `COUNTRY_ID` ASC)  COMMENT 'Unique key for a Country in a Realm';


-- -----------------------------------------------------
-- Table `fasp`.`rm_health_area`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `fasp`.`rm_health_area` ;

CREATE TABLE IF NOT EXISTS `fasp`.`rm_health_area` (
  `HEALTH_AREA_ID` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Unique Id for each Health Area',
  `REALM_ID` INT(10) UNSIGNED NOT NULL COMMENT 'Foreign key to indicate which Realm and Country this Health Area belongs to',
  `LABEL_ID` INT(10) UNSIGNED NOT NULL COMMENT 'Label Id that points to the label table so that we can get the text in different languages',
  `ACTIVE` TINYINT(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'If True indicates this Organisation is Active. False indicates this Organisation has been De-activated',
  `CREATED_BY` INT(10) UNSIGNED NOT NULL COMMENT 'Created by',
  `CREATED_DATE` DATETIME NOT NULL COMMENT 'Created date',
  `LAST_MODIFIED_BY` INT(10) UNSIGNED NOT NULL COMMENT 'Last modified by',
  `LAST_MODIFIED_DATE` DATETIME NOT NULL COMMENT 'Last modified date',
  PRIMARY KEY (`HEALTH_AREA_ID`),
  CONSTRAINT `fk_health_area_labelId`
    FOREIGN KEY (`LABEL_ID`)
    REFERENCES `fasp`.`ap_label` (`LABEL_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_health_area_createdBy`
    FOREIGN KEY (`CREATED_BY`)
    REFERENCES `fasp`.`us_user` (`USER_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_health_area_user1`
    FOREIGN KEY (`LAST_MODIFIED_BY`)
    REFERENCES `fasp`.`us_user` (`USER_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_rm_health_area_rm_realmId`
    FOREIGN KEY (`REALM_ID`)
    REFERENCES `fasp`.`rm_realm` (`REALM_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Table used to define the health_areas for each Realm\nNote: A Health Area can only be created and administered by a Realm Admin';

CREATE INDEX `fk_health_area_labelId_idx` ON `fasp`.`rm_health_area` (`LABEL_ID` ASC);

CREATE INDEX `fk_health_area_createdBy_idx` ON `fasp`.`rm_health_area` (`CREATED_BY` ASC);

CREATE INDEX `fk_health_area_lastModifiedBy_idx` ON `fasp`.`rm_health_area` (`LAST_MODIFIED_BY` ASC);

CREATE INDEX `fk_rm_health_area_rm_realm1_idx` ON `fasp`.`rm_health_area` (`REALM_ID` ASC);


-- -----------------------------------------------------
-- Table `fasp`.`rm_product_category`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `fasp`.`rm_product_category` ;

CREATE TABLE IF NOT EXISTS `fasp`.`rm_product_category` (
  `PRODUCT_CATEGORY_ID` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Unique Id for each Product Category',
  `LABEL_ID` INT(10) UNSIGNED NOT NULL COMMENT 'Label Id that points to the label table so that we can get the text in different languages',
  `ACTIVE` TINYINT(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'If True indicates this Product Category is Active. False indicates this Product Category has been De-activated',
  `CREATED_BY` INT(10) UNSIGNED NOT NULL COMMENT 'Created by',
  `CREATED_DATE` DATETIME NOT NULL COMMENT 'Created date',
  `LAST_MODIFIED_BY` INT(10) UNSIGNED NOT NULL COMMENT 'Last modified by\n',
  `LAST_MODIFIED_DATE` DATETIME NOT NULL COMMENT 'Last modified date',
  PRIMARY KEY (`PRODUCT_CATEGORY_ID`),
  CONSTRAINT `fk_program_category_labelId`
    FOREIGN KEY (`LABEL_ID`)
    REFERENCES `fasp`.`ap_label` (`LABEL_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_program_category_createdBy`
    FOREIGN KEY (`CREATED_BY`)
    REFERENCES `fasp`.`us_user` (`USER_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_program_category_lastModifiedBy`
    FOREIGN KEY (`LAST_MODIFIED_BY`)
    REFERENCES `fasp`.`us_user` (`USER_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Table used to define the product_categories for each health_area\nNote: A Product category can only be created and administered by a Realm Admin';

CREATE INDEX `fk_product_category_labelId_idx` ON `fasp`.`rm_product_category` (`LABEL_ID` ASC);

CREATE INDEX `fk_product_category_createdBy_idx` ON `fasp`.`rm_product_category` (`CREATED_BY` ASC);

CREATE INDEX `fk_product_category_lastModifiedBy_idx` ON `fasp`.`rm_product_category` (`LAST_MODIFIED_BY` ASC);


-- -----------------------------------------------------
-- Table `fasp`.`rm_organisation`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `fasp`.`rm_organisation` ;

CREATE TABLE IF NOT EXISTS `fasp`.`rm_organisation` (
  `ORGANISATION_ID` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Unique Id for each Organisation',
  `REALM_ID` INT(10) UNSIGNED NOT NULL COMMENT 'Foreign key to indicate which Realm this Organisation belongs to',
  `LABEL_ID` INT(10) UNSIGNED NOT NULL COMMENT 'Label Id that points to the label table so that we can get the text in different languages',
  `ORGANISATION_CODE` VARCHAR(4) NOT NULL COMMENT '4 character Unique Code for each Organisation',
  `ACTIVE` TINYINT(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'If True indicates this Organisation is Active. False indicates this Organisation has been Deactivated',
  `CREATED_BY` INT(10) UNSIGNED NOT NULL COMMENT 'Created by',
  `CREATED_DATE` DATETIME NOT NULL COMMENT 'Created date',
  `LAST_MODIFIED_BY` INT(10) UNSIGNED NOT NULL COMMENT 'Last modified by',
  `LAST_MODIFIED_DATE` DATETIME NOT NULL COMMENT '3 ',
  PRIMARY KEY (`ORGANISATION_ID`),
  CONSTRAINT `fk_organisation_realmId`
    FOREIGN KEY (`REALM_ID`)
    REFERENCES `fasp`.`rm_realm` (`REALM_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_organisation_labelId`
    FOREIGN KEY (`LABEL_ID`)
    REFERENCES `fasp`.`ap_label` (`LABEL_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_organisation_createdBy`
    FOREIGN KEY (`CREATED_BY`)
    REFERENCES `fasp`.`us_user` (`USER_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_organisation_lastModifiedBy`
    FOREIGN KEY (`LAST_MODIFIED_BY`)
    REFERENCES `fasp`.`us_user` (`USER_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Table used to define the organizations for each Realm\nNote: An Organisation can only be created and administered by a Realm Admin';

CREATE INDEX `fk_organisation_realmId_idx` ON `fasp`.`rm_organisation` (`REALM_ID` ASC);

CREATE INDEX `fk_organisation_labelId_idx` ON `fasp`.`rm_organisation` (`LABEL_ID` ASC);

CREATE INDEX `fk_organisation_createdBy_idx` ON `fasp`.`rm_organisation` (`CREATED_BY` ASC);

CREATE INDEX `fk_organisation_lastModifiedBy_idx` ON `fasp`.`rm_organisation` (`LAST_MODIFIED_BY` ASC);

CREATE UNIQUE INDEX `unq_organisationCode` ON `fasp`.`rm_organisation` (`ORGANISATION_CODE` ASC, `REALM_ID` ASC)  COMMENT 'Unique Organisation Code across the Realm';


-- -----------------------------------------------------
-- Table `fasp`.`rm_program`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `fasp`.`rm_program` ;

CREATE TABLE IF NOT EXISTS `fasp`.`rm_program` (
  `PROGRAM_ID` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Unique Id for each Program',
  `REALM_COUNTRY_ID` INT(10) UNSIGNED NOT NULL COMMENT 'Foreign key to indicate which Realm-Country this Program belongs to',
  `ORGANISATION_ID` INT(10) UNSIGNED NOT NULL COMMENT 'Foreign key to indicate which Organisation this Program belongs to',
  `HEALTH_AREA_ID` INT(10) UNSIGNED NOT NULL COMMENT 'Foreign key to indicate which Health Area this Program belongs to',
  `LABEL_ID` INT(10) UNSIGNED NOT NULL COMMENT 'Label Id that points to the label table so that we can get the text in different languages',
  `PROGRAM_MANAGER_USER_ID` INT(10) UNSIGNED NOT NULL COMMENT 'Captures the person that is responsible for this Program',
  `PROGRAM_NOTES` TEXT NULL COMMENT 'Program notes',
  `AIR_FREIGHT_PERC` DECIMAL(12,2) NULL COMMENT 'Percentage of Order Qty when Mode = Air',
  `SEA_FREIGHT_PERC` DECIMAL(12,2) NOT NULL COMMENT 'Percentage of Order Qty when Mode = Sea',
  `PLANNED_TO_DRAFT_LEAD_TIME` INT(10) NOT NULL COMMENT 'No of days for an Order to move from Planed to Draft status',
  `DRAFT_TO_SUBMITTED_LEAD_TIME` INT(10) NOT NULL COMMENT 'No of days for an Order to move from Draft to Submitted status',
  `SUBMITTED_TO_APPROVED_LEAD_TIME` INT(10) NOT NULL COMMENT 'No of days for an Order to move from Submitted to Approved status, this will be used only in the case the Procurement Agent is TBD',
  `APPROVED_TO_SHIPPED_LEAD_TIME` INT(10) NOT NULL,
  `DELIVERED_TO_RECEIVED_LEAD_TIME` INT(10) NOT NULL COMMENT 'No of days for an Order to move from Delivered to Received status',
  `MONTHS_IN_PAST_FOR_AMC` INT(10) NOT NULL COMMENT 'No of months that we should go back in the past to calculate AMC',
  `MONTHS_IN_FUTURE_FOR_AMC` INT(10) NOT NULL COMMENT 'No of months that we should go into the future to calculate AMC',
  `ACTIVE` TINYINT(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'If True indicates this Program is Active. False indicates this Program is De-activated',
  `CREATED_BY` INT(10) UNSIGNED NOT NULL COMMENT 'Create  by',
  `CREATED_DATE` DATETIME NOT NULL COMMENT 'Created date',
  `LAST_MODIFIED_BY` INT(10) UNSIGNED NOT NULL COMMENT 'Last modified by',
  `LAST_MODIFIED_DATE` DATETIME NOT NULL COMMENT 'No of days for an Order to move from Approved to Shipped, this will be used only in the case the Procurement Agent is TBD',
  PRIMARY KEY (`PROGRAM_ID`),
  CONSTRAINT `fk_program_labelId`
    FOREIGN KEY (`LABEL_ID`)
    REFERENCES `fasp`.`ap_label` (`LABEL_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_program_createdBy`
    FOREIGN KEY (`CREATED_BY`)
    REFERENCES `fasp`.`us_user` (`USER_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_program_lastModifiedBy`
    FOREIGN KEY (`LAST_MODIFIED_BY`)
    REFERENCES `fasp`.`us_user` (`USER_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_program_realmCountryId`
    FOREIGN KEY (`REALM_COUNTRY_ID`)
    REFERENCES `fasp`.`rm_realm_country` (`REALM_COUNTRY_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_program_organisationId`
    FOREIGN KEY (`ORGANISATION_ID`)
    REFERENCES `fasp`.`rm_organisation` (`ORGANISATION_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_program_healthAreaId`
    FOREIGN KEY (`HEALTH_AREA_ID`)
    REFERENCES `fasp`.`rm_health_area` (`HEALTH_AREA_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Table used to define the program for each product category\nNote: A Program can only be created and administered by a Realm Admin';

CREATE INDEX `fk_program_labelId_idx` ON `fasp`.`rm_program` (`LABEL_ID` ASC);

CREATE INDEX `fk_program_createdBy_idx` ON `fasp`.`rm_program` (`CREATED_BY` ASC);

CREATE INDEX `fk_program_lastModifiedBy_idx` ON `fasp`.`rm_program` (`LAST_MODIFIED_BY` ASC);

CREATE INDEX `fk_program_organisationId_idx` ON `fasp`.`rm_program` (`ORGANISATION_ID` ASC);

CREATE INDEX `fk_program_healthAreaId_idx` ON `fasp`.`rm_program` (`HEALTH_AREA_ID` ASC);


-- -----------------------------------------------------
-- Table `fasp`.`rm_region`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `fasp`.`rm_region` ;

CREATE TABLE IF NOT EXISTS `fasp`.`rm_region` (
  `REGION_ID` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Unique Id for each Level',
  `REALM_COUNTRY_ID` INT(10) UNSIGNED NOT NULL COMMENT 'Foreign key to indicate which Realm and Country this Level belongs to',
  `LABEL_ID` INT(10) UNSIGNED NOT NULL COMMENT 'Label Id that points to the label table so that we can get the text in different languages',
  `CAPACITY_CBM` DECIMAL(14,4) NULL COMMENT 'Cuibic meters of Warehouse capacity, not a compulsory field',
  `ACTIVE` TINYINT(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'If True indicates this Level is Active. False indicates this Level has been De-activated',
  `CREATED_BY` INT(10) UNSIGNED NOT NULL COMMENT 'Created by',
  `CREATED_DATE` DATETIME NULL COMMENT 'Created date',
  `LAST_MODIFIED_BY` INT(10) UNSIGNED NOT NULL COMMENT 'Last modified by',
  `LAST_MODIFIED_DATE` DATETIME NOT NULL COMMENT 'Last modified date',
  PRIMARY KEY (`REGION_ID`),
  CONSTRAINT `fk_level_realmCountryId`
    FOREIGN KEY (`REALM_COUNTRY_ID`)
    REFERENCES `fasp`.`rm_realm_country` (`REALM_COUNTRY_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_level_labelId`
    FOREIGN KEY (`LABEL_ID`)
    REFERENCES `fasp`.`ap_label` (`LABEL_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_level_createdBy`
    FOREIGN KEY (`CREATED_BY`)
    REFERENCES `fasp`.`us_user` (`USER_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_level_lastModifiedBy`
    FOREIGN KEY (`LAST_MODIFIED_BY`)
    REFERENCES `fasp`.`us_user` (`USER_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Table used to define the region for a Country for that Realm\nNote: Regions are Country - Realm specific and can only be created or administered by a Real admin';

CREATE INDEX `fk_level_realmCountryId_idx` ON `fasp`.`rm_region` (`REALM_COUNTRY_ID` ASC);

CREATE INDEX `fk_level_labelId_idx` ON `fasp`.`rm_region` (`LABEL_ID` ASC);

CREATE INDEX `fk_level_createdBy_idx` ON `fasp`.`rm_region` (`CREATED_BY` ASC);

CREATE INDEX `fk_level_lastModifiedBy_idx` ON `fasp`.`rm_region` (`LAST_MODIFIED_BY` ASC);


-- -----------------------------------------------------
-- Table `fasp`.`us_role`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `fasp`.`us_role` ;

CREATE TABLE IF NOT EXISTS `fasp`.`us_role` (
  `ROLE_ID` VARCHAR(30) NOT NULL COMMENT 'Unique Role Id for every Role in the application',
  `LABEL_ID` INT(10) UNSIGNED NOT NULL COMMENT 'Label Id that points to the label table so that we can get the text in different languages',
  `CREATED_BY` INT(10) UNSIGNED NOT NULL COMMENT 'Created by',
  `CREATED_DATE` DATETIME NOT NULL COMMENT 'Created date',
  `LAST_MODIFIED_BY` INT(10) UNSIGNED NOT NULL COMMENT 'Last modified by',
  `LAST_MODIFIED_DATE` DATETIME NOT NULL COMMENT 'Last modified date',
  PRIMARY KEY (`ROLE_ID`),
  CONSTRAINT `fk_role_lastModifiedBy`
    FOREIGN KEY (`LAST_MODIFIED_BY`)
    REFERENCES `fasp`.`us_user` (`USER_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_role_labelId`
    FOREIGN KEY (`LABEL_ID`)
    REFERENCES `fasp`.`ap_label` (`LABEL_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_role_createdBy`
    FOREIGN KEY (`CREATED_BY`)
    REFERENCES `fasp`.`us_user` (`USER_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Table used for lisiting all the Roles that users can use in the application';

CREATE INDEX `fk_role_lastModifiedBy_idx` ON `fasp`.`us_role` (`LAST_MODIFIED_BY` ASC);

CREATE INDEX `fk_role_labelId_idx` ON `fasp`.`us_role` (`LABEL_ID` ASC);

CREATE INDEX `fk_role_createdBy_idx` ON `fasp`.`us_role` (`CREATED_BY` ASC);


-- -----------------------------------------------------
-- Table `fasp`.`us_business_function`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `fasp`.`us_business_function` ;

CREATE TABLE IF NOT EXISTS `fasp`.`us_business_function` (
  `BUSINESS_FUNCTION_ID` VARCHAR(50) NOT NULL COMMENT 'Unique Business function Id for every Business functoin in the application',
  `LABEL_ID` INT(10) UNSIGNED NOT NULL COMMENT 'Label Id that points to the label table so that we can get the text in different languages',
  `CREATED_BY` INT(10) UNSIGNED NOT NULL COMMENT 'Created by',
  `CREATED_DATE` DATETIME NOT NULL COMMENT 'Created date',
  `LAST_MODIFIED_BY` INT(10) UNSIGNED NOT NULL COMMENT 'Last modified by',
  `LAST_MODIFIED_DATE` DATETIME NOT NULL COMMENT 'Last modified date',
  PRIMARY KEY (`BUSINESS_FUNCTION_ID`),
  CONSTRAINT `fk_business_function_labelId`
    FOREIGN KEY (`LABEL_ID`)
    REFERENCES `fasp`.`ap_label` (`LABEL_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_business_function_createdBy`
    FOREIGN KEY (`CREATED_BY`)
    REFERENCES `fasp`.`us_user` (`USER_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_business_function_lastModifiedBy`
    FOREIGN KEY (`LAST_MODIFIED_BY`)
    REFERENCES `fasp`.`us_user` (`USER_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Table used for lisiting all the Business Functions that are available in the application';

CREATE INDEX `fk_business_function_labelId_idx` ON `fasp`.`us_business_function` (`LABEL_ID` ASC);

CREATE INDEX `fk_business_function_createdBy_idx` ON `fasp`.`us_business_function` (`CREATED_BY` ASC);

CREATE INDEX `fk_business_function_lastModifiedBy_idx` ON `fasp`.`us_business_function` (`LAST_MODIFIED_BY` ASC);


-- -----------------------------------------------------
-- Table `fasp`.`us_user_role`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `fasp`.`us_user_role` ;

CREATE TABLE IF NOT EXISTS `fasp`.`us_user_role` (
  `USER_ROLE_ID` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Unique User-Role mapping id',
  `USER_ID` INT(10) UNSIGNED NOT NULL COMMENT 'Foriegn key for the User Id',
  `ROLE_ID` VARCHAR(30) NOT NULL COMMENT 'Foriegn key for the Role Id',
  `CREATED_BY` INT(10) UNSIGNED NOT NULL COMMENT 'Created by',
  `CREATED_DATE` DATETIME NOT NULL COMMENT 'Created date',
  `LAST_MODIFIED_BY` INT(10) UNSIGNED NOT NULL COMMENT 'Last modified by',
  `LAST_MODIFIED_DATE` DATETIME NOT NULL COMMENT 'Last modified date',
  PRIMARY KEY (`USER_ROLE_ID`),
  CONSTRAINT `fk_user_role_userId`
    FOREIGN KEY (`USER_ID`)
    REFERENCES `fasp`.`us_user` (`USER_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_user_role_roleId`
    FOREIGN KEY (`ROLE_ID`)
    REFERENCES `fasp`.`us_role` (`ROLE_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_user_role_createdBy`
    FOREIGN KEY (`CREATED_BY`)
    REFERENCES `fasp`.`us_user` (`USER_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_user_role_lastModifeidBy`
    FOREIGN KEY (`LAST_MODIFIED_BY`)
    REFERENCES `fasp`.`us_user` (`USER_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'User Role mapping table\nNote: Mapping table for User and Roles. While we expect one User will have only one Role it is possible that the User can have multiple Roles.';

CREATE INDEX `fk_user_role_userId_idx` ON `fasp`.`us_user_role` (`USER_ID` ASC);

CREATE INDEX `fk_user_role_roleId_idx` ON `fasp`.`us_user_role` (`ROLE_ID` ASC);

CREATE INDEX `fk_user_role_createdBy_idx` ON `fasp`.`us_user_role` (`CREATED_BY` ASC);

CREATE INDEX `fk_user_role_lastModifiedBy_idx` ON `fasp`.`us_user_role` (`LAST_MODIFIED_BY` ASC);


-- -----------------------------------------------------
-- Table `fasp`.`us_role_business_function`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `fasp`.`us_role_business_function` ;

CREATE TABLE IF NOT EXISTS `fasp`.`us_role_business_function` (
  `ROLE_BUSINESS_FUNCTION_ID` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `ROLE_ID` VARCHAR(30) NOT NULL,
  `BUSINESS_FUNCTION_ID` VARCHAR(50) NOT NULL,
  `CREATED_BY` INT(10) UNSIGNED NOT NULL,
  `CREATED_DATE` DATETIME NOT NULL,
  `LAST_MODIFIED_BY` INT(10) UNSIGNED NOT NULL,
  `LAST_MODIFIED_DATE` DATETIME NOT NULL,
  PRIMARY KEY (`ROLE_BUSINESS_FUNCTION_ID`),
  CONSTRAINT `fk_role_business_function_roleId`
    FOREIGN KEY (`ROLE_ID`)
    REFERENCES `fasp`.`us_role` (`ROLE_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_role_business_function_businessFunctionId`
    FOREIGN KEY (`BUSINESS_FUNCTION_ID`)
    REFERENCES `fasp`.`us_business_function` (`BUSINESS_FUNCTION_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_role_business_function_createdBy`
    FOREIGN KEY (`CREATED_BY`)
    REFERENCES `fasp`.`us_user` (`USER_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_role_business_function_lastModifiedBy`
    FOREIGN KEY (`LAST_MODIFIED_BY`)
    REFERENCES `fasp`.`us_user` (`USER_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Role and Business function map\nNote: Mapping table for Role and Business function';

CREATE INDEX `fk_role_business_function_roleId_idx` ON `fasp`.`us_role_business_function` (`ROLE_ID` ASC);

CREATE INDEX `fk_role_business_function_businessFunctionId_idx` ON `fasp`.`us_role_business_function` (`BUSINESS_FUNCTION_ID` ASC);

CREATE INDEX `fk_role_business_function_createdBy_idx` ON `fasp`.`us_role_business_function` (`CREATED_BY` ASC);

CREATE INDEX `fk_role_business_function_lastModifiedBy_idx` ON `fasp`.`us_role_business_function` (`LAST_MODIFIED_BY` ASC);

CREATE UNIQUE INDEX `uqRoleIdBusinessFunctionId` ON `fasp`.`us_role_business_function` (`ROLE_ID` ASC, `BUSINESS_FUNCTION_ID` ASC)  COMMENT 'Unique key for Role Id and Business Function Id combination';


-- -----------------------------------------------------
-- Table `fasp`.`us_user_acl`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `fasp`.`us_user_acl` ;

CREATE TABLE IF NOT EXISTS `fasp`.`us_user_acl` (
  `USER_ACL_ID` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Unique User Access Control List Id',
  `USER_ID` INT(10) UNSIGNED NOT NULL COMMENT 'Foriegn key for the User Id',
  `REALM_COUNTRY_ID` INT(10) UNSIGNED NULL COMMENT 'Foriegn key for the Country. If this is null it indicates the user has access to all the Countries',
  `HEALTH_AREA_ID` INT(10) UNSIGNED NULL COMMENT 'Foreign key for the Health Area. If this is null it indicates the user has access to all the Health Areas',
  `ORGANISATION_ID` INT(10) UNSIGNED NULL COMMENT 'Foreign key for the Organisation. If this is null it indicates the user has access to all the Organisations.',
  `PROGRAM_ID` INT(10) UNSIGNED NULL COMMENT 'Foreign key for the Programs. If this is null it indicates the user has access to all the Programs.',
  `CREATED_BY` INT(10) UNSIGNED NOT NULL COMMENT 'Created by',
  `CREATED_DATE` DATETIME NOT NULL COMMENT 'Foreign key for the Programs. If this is null it indicates the user has access to all the Programs.',
  `LAST_MODIFIED_BY` INT(10) UNSIGNED NOT NULL COMMENT 'Last modified by',
  `LAST_MODIFIED_DATE` DATETIME NOT NULL COMMENT 'Last modified date',
  PRIMARY KEY (`USER_ACL_ID`),
  CONSTRAINT `fk_user_acl_userId`
    FOREIGN KEY (`USER_ID`)
    REFERENCES `fasp`.`us_user` (`USER_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_user_acl_createdBy`
    FOREIGN KEY (`CREATED_BY`)
    REFERENCES `fasp`.`us_user` (`USER_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_user_acl_lastModifiedBy`
    FOREIGN KEY (`LAST_MODIFIED_BY`)
    REFERENCES `fasp`.`us_user` (`USER_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_user_acl_realmCountryId`
    FOREIGN KEY (`REALM_COUNTRY_ID`)
    REFERENCES `fasp`.`rm_realm_country` (`REALM_COUNTRY_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_user_acl_healthAreaId`
    FOREIGN KEY (`HEALTH_AREA_ID`)
    REFERENCES `fasp`.`rm_health_area` (`HEALTH_AREA_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_user_acl_organisationId`
    FOREIGN KEY (`ORGANISATION_ID`)
    REFERENCES `fasp`.`rm_organisation` (`ORGANISATION_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Table used to store the Access control lists for the application\nNote: Multiple rows for each user. Each row indicates what he has access to.';

CREATE INDEX `fk_user_acl_userId_idx` ON `fasp`.`us_user_acl` (`USER_ID` ASC);

CREATE INDEX `fk_user_acl_createdBy_idx` ON `fasp`.`us_user_acl` (`CREATED_BY` ASC);

CREATE INDEX `fk_user_acl_lastModifiedBy_idx` ON `fasp`.`us_user_acl` (`LAST_MODIFIED_BY` ASC);

CREATE INDEX `fk_user_acl_realmCountryId_idx` ON `fasp`.`us_user_acl` (`REALM_COUNTRY_ID` ASC);

CREATE INDEX `fk_user_acl_healthAreaId_idx` ON `fasp`.`us_user_acl` (`HEALTH_AREA_ID` ASC);

CREATE INDEX `fk_user_acl_organisationId_idx` ON `fasp`.`us_user_acl` (`ORGANISATION_ID` ASC);


-- -----------------------------------------------------
-- Table `fasp`.`ap_data_source_type`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `fasp`.`ap_data_source_type` ;

CREATE TABLE IF NOT EXISTS `fasp`.`ap_data_source_type` (
  `DATA_SOURCE_TYPE_ID` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Unique Id for Data Source Type',
  `LABEL_ID` INT(10) UNSIGNED NOT NULL COMMENT 'Label Id that points to the label table so that we can get the text in different languages',
  `ACTIVE` TINYINT(1) UNSIGNED NOT NULL COMMENT 'If True indicates this Funding Source is Active. False indicates this Funding Source has been De-activated',
  `CREATED_BY` INT(10) UNSIGNED NOT NULL COMMENT 'Created by	',
  `CREATED_DATE` DATETIME NOT NULL COMMENT 'Created date',
  `LAST_MODIFIED_BY` INT(10) UNSIGNED NOT NULL COMMENT 'Last modified by',
  `LAST_MODIFIED_DATE` DATETIME NOT NULL COMMENT 'Last modified date',
  PRIMARY KEY (`DATA_SOURCE_TYPE_ID`),
  CONSTRAINT `fk_data_source_type_createdBy`
    FOREIGN KEY (`CREATED_BY`)
    REFERENCES `fasp`.`us_user` (`USER_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_data_source_type_lastModifiedBy`
    FOREIGN KEY (`LAST_MODIFIED_BY`)
    REFERENCES `fasp`.`us_user` (`USER_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Super Classification of data_source\nNote: There are 3 DataSourceTypes Inventory, Shipment and Consumption';

CREATE INDEX `fk_data_source_type_createdBy_idx` ON `fasp`.`ap_data_source_type` (`CREATED_BY` ASC);

CREATE INDEX `fk_data_source_type_lastModifiedBy_idx` ON `fasp`.`ap_data_source_type` (`LAST_MODIFIED_BY` ASC);


-- -----------------------------------------------------
-- Table `fasp`.`ap_data_source`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `fasp`.`ap_data_source` ;

CREATE TABLE IF NOT EXISTS `fasp`.`ap_data_source` (
  `DATA_SOURCE_ID` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Unique Id for each Data source ',
  `DATA_SOURCE_TYPE_ID` INT(10) UNSIGNED NOT NULL COMMENT 'Foreign key for Data Source Type Id',
  `LABEL_ID` INT(10) UNSIGNED NOT NULL COMMENT 'Label Id that points to the label table so that we can get the text in different languages',
  `ACTIVE` VARCHAR(50) NOT NULL COMMENT 'If True indicates this Funding Source is Active. False indicates this Funding Source has been De-activated',
  `CREATED_BY` INT(10) UNSIGNED NOT NULL COMMENT 'Created by',
  `CREATED_DATE` DATETIME NOT NULL COMMENT 'Created date',
  `LAST_MODIFIED_BY` INT(10) UNSIGNED NOT NULL COMMENT 'Last modified by',
  `LAST_MODIFIED_DATE` DATETIME NOT NULL COMMENT 'Last modified date',
  PRIMARY KEY (`DATA_SOURCE_ID`),
  CONSTRAINT `fk_data_source_dataSourceTypeId`
    FOREIGN KEY (`DATA_SOURCE_TYPE_ID`)
    REFERENCES `fasp`.`ap_data_source_type` (`DATA_SOURCE_TYPE_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_data_source_createdBy`
    FOREIGN KEY (`CREATED_BY`)
    REFERENCES `fasp`.`us_user` (`USER_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_data_source_lastModifiedBy`
    FOREIGN KEY (`LAST_MODIFIED_BY`)
    REFERENCES `fasp`.`us_user` (`USER_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_data_source_labelId`
    FOREIGN KEY (`LABEL_ID`)
    REFERENCES `fasp`.`ap_label` (`LABEL_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Table to capture the Data Source\nNote: To be used in Shipments, Inventory and Consumption tables to identify where the data came from. Application level field so can only be administered by Application Admin';

CREATE INDEX `fk_data_source_dataSourceTypeId_idx` ON `fasp`.`ap_data_source` (`DATA_SOURCE_TYPE_ID` ASC);

CREATE INDEX `fk_data_source_createdBy_idx` ON `fasp`.`ap_data_source` (`CREATED_BY` ASC);

CREATE INDEX `fk_data_source_lastModifiedBy_idx` ON `fasp`.`ap_data_source` (`LAST_MODIFIED_BY` ASC);

CREATE INDEX `fk_data_source_labelId_idx` ON `fasp`.`ap_data_source` (`LABEL_ID` ASC);


-- -----------------------------------------------------
-- Table `fasp`.`ap_shipment_status`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `fasp`.`ap_shipment_status` ;

CREATE TABLE IF NOT EXISTS `fasp`.`ap_shipment_status` (
  `SHIPMENT_STATUS_ID` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Unique Id for each Shipment Status',
  `LABEL_ID` INT(10) UNSIGNED NOT NULL COMMENT 'Label Id that points to the label table so that we can get the text in different languages',
  `ACTIVE` TINYINT(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'If True indicates this Funding Source is Active. False indicates this Funding Source has been De-activated',
  `CREATED_BY` INT(10) UNSIGNED NOT NULL COMMENT 'Created by',
  `CREATED_DATE` DATETIME NOT NULL COMMENT 'Created date',
  `LAST_MODIFIED_BY` INT(10) UNSIGNED NOT NULL COMMENT 'Last modified by',
  `LAST_MODIFIED_DATE` DATETIME NOT NULL COMMENT 'Last modified date',
  PRIMARY KEY (`SHIPMENT_STATUS_ID`),
  CONSTRAINT `fk_shipment_status_createdBy`
    FOREIGN KEY (`CREATED_BY`)
    REFERENCES `fasp`.`us_user` (`USER_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_shipment_status_lastModifiedBy`
    FOREIGN KEY (`LAST_MODIFIED_BY`)
    REFERENCES `fasp`.`us_user` (`USER_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_shipment_status_labelId`
    FOREIGN KEY (`LABEL_ID`)
    REFERENCES `fasp`.`ap_label` (`LABEL_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Table used to store which Shipping status is logically allowed';

CREATE INDEX `fk_shipment_status_createdBy_idx` ON `fasp`.`ap_shipment_status` (`CREATED_BY` ASC);

CREATE INDEX `fk_shipment_status_lastModifiedBy_idx` ON `fasp`.`ap_shipment_status` (`LAST_MODIFIED_BY` ASC);

CREATE INDEX `fk_shipment_status_labelId_idx` ON `fasp`.`ap_shipment_status` (`LABEL_ID` ASC);


-- -----------------------------------------------------
-- Table `fasp`.`ap_shipment_status_allowed`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `fasp`.`ap_shipment_status_allowed` ;

CREATE TABLE IF NOT EXISTS `fasp`.`ap_shipment_status_allowed` (
  `SHIPMENT_STATUS_ALLOWED_ID` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Unique Id for each Level - Program mapping',
  `SHIPMENT_STATUS_ID` INT(10) UNSIGNED NOT NULL COMMENT 'Ship status Id',
  `NEXT_SHIPMENT_STATUS_ID` INT(10) UNSIGNED NOT NULL COMMENT 'Next allowed Shipment Status Id',
  `CREATED_BY` INT(10) UNSIGNED NOT NULL COMMENT 'Created by',
  `CREATED_DATE` DATETIME NOT NULL COMMENT 'Created date',
  `LAST_MODIFIED_BY` INT(10) UNSIGNED NOT NULL COMMENT 'Last modified by',
  `LAST_MODIFIED_DATE` DATETIME NOT NULL COMMENT 'Last modified date',
  PRIMARY KEY (`SHIPMENT_STATUS_ALLOWED_ID`),
  CONSTRAINT `fk_shipment_status_allowed_shipmentStatusId`
    FOREIGN KEY (`SHIPMENT_STATUS_ID`)
    REFERENCES `fasp`.`ap_shipment_status` (`SHIPMENT_STATUS_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_shipment_status_allowed_nextShipmentStatusId`
    FOREIGN KEY (`NEXT_SHIPMENT_STATUS_ID`)
    REFERENCES `fasp`.`ap_shipment_status` (`SHIPMENT_STATUS_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_shipment_status_allowed_createdBy`
    FOREIGN KEY (`CREATED_BY`)
    REFERENCES `fasp`.`us_user` (`USER_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_shipment_status_allowed_lastModifiedBy`
    FOREIGN KEY (`LAST_MODIFIED_BY`)
    REFERENCES `fasp`.`us_user` (`USER_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_shipment_status_allowed_shipmentStatusId_idx` ON `fasp`.`ap_shipment_status_allowed` (`SHIPMENT_STATUS_ID` ASC);

CREATE INDEX `fk_shipment_status_allowed_nextShipmentStatusId_idx` ON `fasp`.`ap_shipment_status_allowed` (`NEXT_SHIPMENT_STATUS_ID` ASC);

CREATE INDEX `fk_shipment_status_allowed_createdBy_idx` ON `fasp`.`ap_shipment_status_allowed` (`CREATED_BY` ASC);

CREATE INDEX `fk_shipment_status_allowed_lastModifiedBy_idx` ON `fasp`.`ap_shipment_status_allowed` (`LAST_MODIFIED_BY` ASC);


-- -----------------------------------------------------
-- Table `fasp`.`rm_manufacturer`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `fasp`.`rm_manufacturer` ;

CREATE TABLE IF NOT EXISTS `fasp`.`rm_manufacturer` (
  `MANUFACTURER_ID` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Unique Id for each Manufacturer',
  `REALM_ID` INT(10) UNSIGNED NOT NULL COMMENT 'Foreign key to indicate which Realm this Manufacturer belongs to',
  `LABEL_ID` INT(10) UNSIGNED NOT NULL COMMENT 'Label Id that points to the label table so that we can get the text in different languages',
  `ACTIVE` TINYINT(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'If True indicates this Organisation is Active. False indicates this Organisation has been Deactivated',
  `CREATED_BY` INT(10) UNSIGNED NOT NULL COMMENT 'Created by',
  `CREATED_DATE` DATETIME NOT NULL COMMENT 'Created date',
  `LAST_MODIFIED_BY` INT(10) UNSIGNED NOT NULL COMMENT 'Last modified by',
  `LAST_MODIFIED_DATE` DATETIME NOT NULL COMMENT 'Last modified date',
  PRIMARY KEY (`MANUFACTURER_ID`),
  CONSTRAINT `fk_manufacturer_realmId`
    FOREIGN KEY (`REALM_ID`)
    REFERENCES `fasp`.`rm_realm` (`REALM_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_manufacturer_labelId`
    FOREIGN KEY (`LABEL_ID`)
    REFERENCES `fasp`.`ap_label` (`LABEL_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_manufacturer_createdBy`
    FOREIGN KEY (`CREATED_BY`)
    REFERENCES `fasp`.`us_user` (`USER_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_manufacturer_lastModifiedBy`
    FOREIGN KEY (`LAST_MODIFIED_BY`)
    REFERENCES `fasp`.`us_user` (`USER_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Table used to define the manufacturers for each Realm\nNote: A Manufacturer can only be created and administered by a Realm Admin';

CREATE INDEX `fk_manufacturer_realmId_idx` ON `fasp`.`rm_manufacturer` (`REALM_ID` ASC);

CREATE INDEX `fk_manufacturer_labelId_idx` ON `fasp`.`rm_manufacturer` (`LABEL_ID` ASC);

CREATE INDEX `fk_manufacturer_createdBy_idx` ON `fasp`.`rm_manufacturer` (`CREATED_BY` ASC);

CREATE INDEX `fk_manufacturer_lastModifiedBy_idx` ON `fasp`.`rm_manufacturer` (`LAST_MODIFIED_BY` ASC);


-- -----------------------------------------------------
-- Table `fasp`.`rm_organisation_country`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `fasp`.`rm_organisation_country` ;

CREATE TABLE IF NOT EXISTS `fasp`.`rm_organisation_country` (
  `ORGANISATION_COUNTRY_ID` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Unique Id for each Organisation - Realm country mapping',
  `ORGANISATION_ID` INT(10) UNSIGNED NOT NULL COMMENT 'Foreign key to indicate which Organisation this mapping belongs to',
  `REALM_COUNTRY_ID` INT(10) UNSIGNED NOT NULL COMMENT 'Foreign key to indicate which Realm-Country this mapping belongs to',
  `ACTIVE` TINYINT(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'If True indicates this Organisation is Active. False indicates this Organisation has been Deactivated',
  `CREATED_BY` INT(10) UNSIGNED NOT NULL COMMENT 'Created by',
  `CREATED_DATE` DATETIME NOT NULL COMMENT 'Created date',
  `LAST_MODIFIED_BY` INT(10) UNSIGNED NOT NULL COMMENT 'Last modified by',
  `LAST_MODIFIED_DATE` DATETIME NOT NULL COMMENT 'Last modified date',
  PRIMARY KEY (`ORGANISATION_COUNTRY_ID`),
  CONSTRAINT `fk_organisation_country_organisationId`
    FOREIGN KEY (`ORGANISATION_ID`)
    REFERENCES `fasp`.`rm_organisation` (`ORGANISATION_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_organisation_country_realmCountryId`
    FOREIGN KEY (`REALM_COUNTRY_ID`)
    REFERENCES `fasp`.`rm_realm_country` (`REALM_COUNTRY_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_organisation_country_createdBy`
    FOREIGN KEY (`CREATED_BY`)
    REFERENCES `fasp`.`us_user` (`USER_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_organisation_country_lastModifiedBy`
    FOREIGN KEY (`LAST_MODIFIED_BY`)
    REFERENCES `fasp`.`us_user` (`USER_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Table used to map which organisations are available for which country\nNote: This is to be administered at the Realm level only by a Realm Admin';

CREATE INDEX `fk_organisation_country_organisationId_idx` ON `fasp`.`rm_organisation_country` (`ORGANISATION_ID` ASC);

CREATE INDEX `fk_organisation_country_realmCountryId_idx` ON `fasp`.`rm_organisation_country` (`REALM_COUNTRY_ID` ASC);

CREATE INDEX `fk_organisation_country_createdBy_idx` ON `fasp`.`rm_organisation_country` (`CREATED_BY` ASC);

CREATE INDEX `fk_organisation_country_lastModifiedBy_idx` ON `fasp`.`rm_organisation_country` (`LAST_MODIFIED_BY` ASC);

CREATE UNIQUE INDEX `unqOrganisationIdCountryId` ON `fasp`.`rm_organisation_country` (`ORGANISATION_ID` ASC, `REALM_COUNTRY_ID` ASC)  COMMENT 'Uniqe key for an Organisation - Country mapping';


-- -----------------------------------------------------
-- Table `fasp`.`rm_health_area_country`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `fasp`.`rm_health_area_country` ;

CREATE TABLE IF NOT EXISTS `fasp`.`rm_health_area_country` (
  `HEALTH_AREA_COUNTRY_ID` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Unique Id for each Health Area - Country mapping',
  `HEALTH_AREA_ID` INT(10) UNSIGNED NOT NULL COMMENT 'Foreign key to indicate which Health Area this mapping belongs to',
  `REALM_COUNTRY_ID` INT(10) UNSIGNED NOT NULL COMMENT 'Foreign key to indicate which Realm-Country this mapping belongs to',
  `ACTIVE` TINYINT(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'If True indicates this mapping is Active. False indicates this Health-Area Country has been Deactivated',
  `CREATED_BY` INT(10) UNSIGNED NOT NULL COMMENT 'Created by',
  `CREATED_DATE` DATETIME NOT NULL COMMENT 'Created date',
  `LAST_MODIFIED_BY` INT(10) UNSIGNED NOT NULL COMMENT 'Last modified by',
  `LAST_MODIFIED_DATE` DATETIME NOT NULL COMMENT 'Last modified date',
  PRIMARY KEY (`HEALTH_AREA_COUNTRY_ID`),
  CONSTRAINT `fk_health_area_country_healthAreaId`
    FOREIGN KEY (`HEALTH_AREA_ID`)
    REFERENCES `fasp`.`rm_health_area` (`HEALTH_AREA_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_health_area_country_realmCountryId`
    FOREIGN KEY (`REALM_COUNTRY_ID`)
    REFERENCES `fasp`.`rm_realm_country` (`REALM_COUNTRY_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_health_area_country_createdBy`
    FOREIGN KEY (`CREATED_BY`)
    REFERENCES `fasp`.`us_user` (`USER_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_health_area_country_lastModifiedBy`
    FOREIGN KEY (`LAST_MODIFIED_BY`)
    REFERENCES `fasp`.`us_user` (`USER_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Table used to map which health_areas are available for which country\nNote: This is to be administered at the Realm level only by a Realm Admin';

CREATE INDEX `fk_health_area_country_healthAreaId_idx` ON `fasp`.`rm_health_area_country` (`HEALTH_AREA_ID` ASC);

CREATE INDEX `fk_health_area_country_realmCountryId_idx` ON `fasp`.`rm_health_area_country` (`REALM_COUNTRY_ID` ASC);

CREATE INDEX `fk_health_area_country_createdBy_idx` ON `fasp`.`rm_health_area_country` (`CREATED_BY` ASC);

CREATE INDEX `fk_health_area_country_lastModifiedBy_idx` ON `fasp`.`rm_health_area_country` (`LAST_MODIFIED_BY` ASC);

CREATE UNIQUE INDEX `unqHealthAreaIdCountryId` ON `fasp`.`rm_health_area_country` (`HEALTH_AREA_ID` ASC, `REALM_COUNTRY_ID` ASC)  COMMENT 'Unique key to map Health area and Country mapping';


-- -----------------------------------------------------
-- Table `fasp`.`rm_program_region`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `fasp`.`rm_program_region` ;

CREATE TABLE IF NOT EXISTS `fasp`.`rm_program_region` (
  `PROGRAM_REGION_ID` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Unique Id for each Region - Program mapping',
  `PROGRAM_ID` INT(10) UNSIGNED NOT NULL COMMENT 'Foreign key that determines the Program this Mapping belongs to',
  `REGION_ID` INT(10) UNSIGNED NOT NULL COMMENT 'Foreign key that determines the Region this Mapping belongs to',
  `ACTIVE` TINYINT(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'If True indicates this Mapping is Active. False indicates this Mapping has been Deactivated',
  `CREATED_BY` INT(10) UNSIGNED NOT NULL COMMENT 'Created by',
  `CREATED_DATE` DATETIME NOT NULL COMMENT 'Created date',
  `LAST_MODIFIED_BY` INT(10) UNSIGNED NOT NULL COMMENT 'Last modified by',
  `LAST_MODIFIED_DATE` DATETIME NOT NULL COMMENT 'Last modified date',
  PRIMARY KEY (`PROGRAM_REGION_ID`),
  CONSTRAINT `fk_program_region_programId`
    FOREIGN KEY (`PROGRAM_ID`)
    REFERENCES `fasp`.`rm_program` (`PROGRAM_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_program_region_regionId`
    FOREIGN KEY (`REGION_ID`)
    REFERENCES `fasp`.`rm_region` (`REGION_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_program_region_createdBy`
    FOREIGN KEY (`CREATED_BY`)
    REFERENCES `fasp`.`us_user` (`USER_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_program_region_lastModifiedBy`
    FOREIGN KEY (`LAST_MODIFIED_BY`)
    REFERENCES `fasp`.`us_user` (`USER_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Table used to map which Regions are used by a Program\nNote: Show the list of all Regions for that Country and let the Realm Admin select which Regions he wants to include in the Program. One Region for a Program is compulsory';

CREATE INDEX `fk_program_region_programId_idx` ON `fasp`.`rm_program_region` (`PROGRAM_ID` ASC);

CREATE INDEX `fk_program_region_regionId_idx` ON `fasp`.`rm_program_region` (`REGION_ID` ASC);

CREATE INDEX `fk_program_region_createdBy_idx` ON `fasp`.`rm_program_region` (`CREATED_BY` ASC);

CREATE INDEX `fk_program_region_lastModifiedBy_idx` ON `fasp`.`rm_program_region` (`LAST_MODIFIED_BY` ASC);

CREATE UNIQUE INDEX `unqProgramIdRegionId` ON `fasp`.`rm_program_region` (`PROGRAM_ID` ASC, `REGION_ID` ASC)  COMMENT 'Unique mapping for Program and Region mapping';


-- -----------------------------------------------------
-- Table `fasp`.`rm_funding_source`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `fasp`.`rm_funding_source` ;

CREATE TABLE IF NOT EXISTS `fasp`.`rm_funding_source` (
  `FUNDING_SOURCE_ID` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Unique Id for each Funding source',
  `REALM_ID` INT(10) UNSIGNED NOT NULL COMMENT 'Foreign key that determines the Realm this Funding Source belongs to',
  `LABEL_ID` INT(10) UNSIGNED NOT NULL COMMENT 'Label Id that points to the label table so that we can get the text in different languages',
  `ACTIVE` TINYINT(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'If True indicates this Funding Source is Active. False indicates this Funding Source has been Deactivated',
  `CREATED_BY` INT(10) UNSIGNED NOT NULL COMMENT 'Created by',
  `CREATED_DATE` DATETIME NOT NULL COMMENT 'Created date',
  `LAST_MODIFIED_BY` INT(10) UNSIGNED NOT NULL COMMENT 'Last modified by',
  `LAST_MODIFIED_DATE` DATETIME NOT NULL COMMENT 'Last modified date',
  PRIMARY KEY (`FUNDING_SOURCE_ID`),
  CONSTRAINT `fk_funding_source_realmId`
    FOREIGN KEY (`REALM_ID`)
    REFERENCES `fasp`.`rm_realm` (`REALM_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_funding_source_labelId`
    FOREIGN KEY (`LABEL_ID`)
    REFERENCES `fasp`.`ap_label` (`LABEL_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_funding_source_createdBy`
    FOREIGN KEY (`CREATED_BY`)
    REFERENCES `fasp`.`us_user` (`USER_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_funding_source_lastModifiedBy`
    FOREIGN KEY (`LAST_MODIFIED_BY`)
    REFERENCES `fasp`.`us_user` (`USER_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_funding_source_realmId_idx` ON `fasp`.`rm_funding_source` (`REALM_ID` ASC);

CREATE INDEX `fk_funding_source_labelId_idx` ON `fasp`.`rm_funding_source` (`LABEL_ID` ASC);

CREATE INDEX `fk_funding_source_createdBy_idx` ON `fasp`.`rm_funding_source` (`CREATED_BY` ASC);

CREATE INDEX `fk_funding_source_lastModifiedBy_idx` ON `fasp`.`rm_funding_source` (`LAST_MODIFIED_BY` ASC);


-- -----------------------------------------------------
-- Table `fasp`.`rm_sub_funding_source`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `fasp`.`rm_sub_funding_source` ;

CREATE TABLE IF NOT EXISTS `fasp`.`rm_sub_funding_source` (
  `SUB_FUNDING_SOURCE_ID` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Unique Id for each Sub-funding source mapping',
  `FUNDING_SOURCE_ID` INT(10) UNSIGNED NOT NULL COMMENT 'Foreign key that determines the Funding Source this Sub Funding Source belongs to',
  `LABEL_ID` INT(10) UNSIGNED NOT NULL COMMENT 'Label Id that points to the label table so that we can get the text in different languages',
  `ACTIVE` TINYINT(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'If True indicates this Sub Funding Source is Active. False indicates this Sub Funding Source has been Deactivated',
  `CREATED_BY` INT(10) UNSIGNED NOT NULL COMMENT 'Created by',
  `CREATED_DATE` DATETIME NOT NULL COMMENT 'Created date',
  `LAST_MODIFIED_BY` INT(10) UNSIGNED NOT NULL COMMENT 'Last modified by',
  `LAST_MODIFIED_DATE` DATETIME NOT NULL COMMENT 'Last modified date',
  PRIMARY KEY (`SUB_FUNDING_SOURCE_ID`),
  CONSTRAINT `fk_sub_funding_source_fundingSourceId`
    FOREIGN KEY (`FUNDING_SOURCE_ID`)
    REFERENCES `fasp`.`rm_funding_source` (`FUNDING_SOURCE_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_sub_funding_source_labelId`
    FOREIGN KEY (`LABEL_ID`)
    REFERENCES `fasp`.`ap_label` (`LABEL_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_sub_funding_source_createdBy`
    FOREIGN KEY (`CREATED_BY`)
    REFERENCES `fasp`.`us_user` (`USER_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_sub_funding_source_lastModifiedBy`
    FOREIGN KEY (`LAST_MODIFIED_BY`)
    REFERENCES `fasp`.`us_user` (`USER_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Table used to list the sub_funding_sources for a Realm					\nNote: Are based on a Realm and can be created by a Realm level admin through a Ticket request';

CREATE INDEX `fk_sub_funding_source_fundingSourceId_idx` ON `fasp`.`rm_sub_funding_source` (`FUNDING_SOURCE_ID` ASC);

CREATE INDEX `fk_sub_funding_source_labelId_idx` ON `fasp`.`rm_sub_funding_source` (`LABEL_ID` ASC);

CREATE INDEX `fk_sub_funding_source_createdBy_idx` ON `fasp`.`rm_sub_funding_source` (`CREATED_BY` ASC);

CREATE INDEX `fk_sub_funding_source_lastModifiedBy_idx` ON `fasp`.`rm_sub_funding_source` (`LAST_MODIFIED_BY` ASC);


-- -----------------------------------------------------
-- Table `fasp`.`rm_budget`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `fasp`.`rm_budget` ;

CREATE TABLE IF NOT EXISTS `fasp`.`rm_budget` (
  `BUDGET_ID` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Unique Id for each Budget',
  `PROGRAM_ID` INT(10) UNSIGNED NOT NULL COMMENT 'Foreign key that determines the Program that this budget is for',
  `SUB_FUNDING_SOURCE_ID` INT(10) UNSIGNED NOT NULL COMMENT 'Foreign key that determines the Sub Funding Source this Budget belongs to',
  `LABEL_ID` INT(10) UNSIGNED NOT NULL COMMENT 'Label Id that points to the label table so that we can get the text in different languages',
  `BUDGET_AMT` DECIMAL(14,4) UNSIGNED NOT NULL COMMENT 'The total Budget amt approved for this Budget',
  `START_DATE` DATE NOT NULL COMMENT 'Start date for the Budget',
  `STOP_DATE` DATE NOT NULL COMMENT 'Stop date for the Budget',
  `ACTIVE` TINYINT(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'If True indicates this Budget is Active. False indicates this Budget has been Deactivated',
  `CREATED_BY` INT(10) UNSIGNED NOT NULL COMMENT 'Created by',
  `CREATED_DATE` DATETIME NOT NULL COMMENT 'Created date',
  `LAST_MODIFIED_BY` INT(10) UNSIGNED NOT NULL COMMENT 'Last modified by',
  `LAST_MODIFIED_DATE` DATETIME NOT NULL COMMENT 'Last modified date',
  PRIMARY KEY (`BUDGET_ID`),
  CONSTRAINT `fk_budget_subFundingSourceId`
    FOREIGN KEY (`SUB_FUNDING_SOURCE_ID`)
    REFERENCES `fasp`.`rm_sub_funding_source` (`SUB_FUNDING_SOURCE_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_budget_programId`
    FOREIGN KEY (`PROGRAM_ID`)
    REFERENCES `fasp`.`rm_program` (`PROGRAM_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_budget_labelId`
    FOREIGN KEY (`LABEL_ID`)
    REFERENCES `fasp`.`ap_label` (`LABEL_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_budget_createdBy`
    FOREIGN KEY (`CREATED_BY`)
    REFERENCES `fasp`.`us_user` (`USER_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_budget_lastModifiedBy`
    FOREIGN KEY (`LAST_MODIFIED_BY`)
    REFERENCES `fasp`.`us_user` (`USER_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Table used to list the budgets for a Sub-Funding Source\nNote: Are based on a Realm and can be created by a Realm level admin through a Ticket request';

CREATE INDEX `fk_budget_sub_funding_sourceId1_idx` ON `fasp`.`rm_budget` (`SUB_FUNDING_SOURCE_ID` ASC);

CREATE INDEX `fk_budget_programId1_idx` ON `fasp`.`rm_budget` (`PROGRAM_ID` ASC);

CREATE INDEX `fk_budget_labelId1_idx` ON `fasp`.`rm_budget` (`LABEL_ID` ASC);

CREATE INDEX `fk_budget_userId1_idx` ON `fasp`.`rm_budget` (`CREATED_BY` ASC);

CREATE INDEX `fk_budget_userId2_idx` ON `fasp`.`rm_budget` (`LAST_MODIFIED_BY` ASC);


-- -----------------------------------------------------
-- Table `fasp`.`rm_procurement_agent`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `fasp`.`rm_procurement_agent` ;

CREATE TABLE IF NOT EXISTS `fasp`.`rm_procurement_agent` (
  `PROCUREMENT_AGENT_ID` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Unique Id for each Procurement agent',
  `REALM_ID` INT(10) UNSIGNED NOT NULL COMMENT 'Foreign key that determines the Realm this Procurement Agent belongs to',
  `PROGRAM_ID` INT(10) UNSIGNED NULL COMMENT 'Foreign key that determines the Program this Procurement Agent belongs to. If it is null then the record is a Realm level Procurement Agent. If it is not null then it is a Program level Procurement Agent.',
  `LABEL_ID` INT(10) UNSIGNED NOT NULL COMMENT 'Label Id that points to the label table so that we can get the text in different languages',
  `SUBMITTED_TO_APPROVED_LEAD_TIME` INT(10) UNSIGNED NOT NULL COMMENT 'No of days for an Order to move from Submitted to Approved status, this will be used only in the case the Procurement Agent is TBD',
  `ACTIVE` TINYINT(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'If True indicates this Procurement Agent is Active. False indicates this Procurement Agent has been Deactivated',
  `CREATED_BY` INT(10) UNSIGNED NOT NULL COMMENT 'Created by',
  `CREATED_DATE` DATETIME NOT NULL COMMENT 'Created date',
  `LAST_MODIFIED_BY` INT(10) UNSIGNED NOT NULL COMMENT 'Last modified by',
  `LAST_MODIFIED_DATE` DATETIME NOT NULL COMMENT 'No of days for an Order to move from Approved to Shipped, this will be used only in the case the Procurement Agent is TBD',
  PRIMARY KEY (`PROCUREMENT_AGENT_ID`),
  CONSTRAINT `fk_procurement_agent_realmId`
    FOREIGN KEY (`REALM_ID`)
    REFERENCES `fasp`.`rm_realm` (`REALM_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_procurement_agent_programId`
    FOREIGN KEY (`PROGRAM_ID`)
    REFERENCES `fasp`.`rm_program` (`PROGRAM_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_procurement_agent_labelId`
    FOREIGN KEY (`LABEL_ID`)
    REFERENCES `fasp`.`ap_label` (`LABEL_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_procurement_agent_createdBy`
    FOREIGN KEY (`CREATED_BY`)
    REFERENCES `fasp`.`us_user` (`USER_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_procurement_agent_lastModifiedBy`
    FOREIGN KEY (`LAST_MODIFIED_BY`)
    REFERENCES `fasp`.`us_user` (`USER_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Table used to list the procurement_agents for a Realm\nNote: Are based on a Realm and can be created by a Realm level admin through a Ticket request, you can also have Program level procurement agent which are also created and administered by the Program Admin via a Ticket request';

CREATE INDEX `fk_procurement_agent_realmId_idx` ON `fasp`.`rm_procurement_agent` (`REALM_ID` ASC);

CREATE INDEX `fk_procurement_agent_programId_idx` ON `fasp`.`rm_procurement_agent` (`PROGRAM_ID` ASC);

CREATE INDEX `fk_procurement_agent_labelId_idx` ON `fasp`.`rm_procurement_agent` (`LABEL_ID` ASC);

CREATE INDEX `fk_procurement_agent_createdBy_idx` ON `fasp`.`rm_procurement_agent` (`CREATED_BY` ASC);

CREATE INDEX `fk_procurement_agent_lastModifiedBy_idx` ON `fasp`.`rm_procurement_agent` (`LAST_MODIFIED_BY` ASC);


-- -----------------------------------------------------
-- Table `fasp`.`ap_unit_type`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `fasp`.`ap_unit_type` ;

CREATE TABLE IF NOT EXISTS `fasp`.`ap_unit_type` (
  `UNIT_TYPE_ID` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `LABEL_ID` INT(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`UNIT_TYPE_ID`),
  CONSTRAINT `fk_unit_type_labelId`
    FOREIGN KEY (`LABEL_ID`)
    REFERENCES `fasp`.`ap_label` (`LABEL_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Table used to store the different Types of Units of measure used across the Application\nNote: Are based on the Application and can only be administered by an Applicaton level Admin. For e.g. Length, Weight, Volume, Area, Items etc';

CREATE INDEX `fk_unit_type_labelId_idx` ON `fasp`.`ap_unit_type` (`LABEL_ID` ASC);


-- -----------------------------------------------------
-- Table `fasp`.`ap_unit`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `fasp`.`ap_unit` ;

CREATE TABLE IF NOT EXISTS `fasp`.`ap_unit` (
  `UNIT_ID` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Unique Id for each Unit of measure',
  `UNIT_TYPE_ID` INT(10) UNSIGNED NOT NULL COMMENT 'Foreign key that points to what type of Unit of measure this is ',
  `LABEL_ID` INT(10) UNSIGNED NOT NULL COMMENT 'Label Id that points to the label table so that we can get the text in different languages',
  `UNIT_CODE` VARCHAR(20) NOT NULL COMMENT 'Notification for this Unit of measure',
  `ACTIVE` TINYINT(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'If True indicates this Funding Source is Active. False indicates this Funding Source has been Deactivated',
  `CREATED_BY` INT(10) UNSIGNED NOT NULL COMMENT 'Created by',
  `CREATED_DATE` DATETIME NOT NULL COMMENT 'Created date',
  `LAST_MODIFIED_BY` INT(10) UNSIGNED NOT NULL COMMENT 'Last modified by',
  `LAST_MODIFIED_DATE` DATETIME NOT NULL COMMENT 'Last modified date',
  PRIMARY KEY (`UNIT_ID`),
  CONSTRAINT `fk_unit_unit_typeId`
    FOREIGN KEY (`UNIT_TYPE_ID`)
    REFERENCES `fasp`.`ap_unit_type` (`UNIT_TYPE_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_unit_createdBy`
    FOREIGN KEY (`CREATED_BY`)
    REFERENCES `fasp`.`us_user` (`USER_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_unit_lastModifiedBy`
    FOREIGN KEY (`LAST_MODIFIED_BY`)
    REFERENCES `fasp`.`us_user` (`USER_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Table used to store the different Units of measure used across the Application\nNote: Are based on the Application and can only be administered by an Applicaton level Admin';

CREATE INDEX `fk_unit_unit_typeId_idx` ON `fasp`.`ap_unit` (`UNIT_TYPE_ID` ASC);

CREATE INDEX `fk_unit_createdBy_idx` ON `fasp`.`ap_unit` (`CREATED_BY` ASC);

CREATE INDEX `fk_unit_lastModifiedBy_idx` ON `fasp`.`ap_unit` (`LAST_MODIFIED_BY` ASC);


-- -----------------------------------------------------
-- Table `fasp`.`rm_product`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `fasp`.`rm_product` ;

CREATE TABLE IF NOT EXISTS `fasp`.`rm_product` (
  `PRODUCT_ID` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Unique Id for each Product',
  `REALM_ID` INT(10) UNSIGNED NOT NULL COMMENT 'Foreign key that determines the Realm this Product belongs to',
  `PRODUCT_CATEGORY_ID` INT(10) UNSIGNED NOT NULL COMMENT 'Foreign key that determines the Product Category for this product',
  `GENERIC_LABEL_ID` INT(10) UNSIGNED NOT NULL COMMENT 'Generic name for the Product, also called the INN',
  `LABEL_ID` INT(10) UNSIGNED NOT NULL COMMENT 'Label Id that points to the label table so that we can get the text in different languages',
  `FORECASTING_UNIT_ID` INT(10) UNSIGNED NOT NULL COMMENT 'Foreign key that gives the Unit in which we need to make forecasts in',
  `ACTIVE` TINYINT(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'If True indicates this Product is Active. False indicates this Product has been Deactivated',
  `CREATED_BY` INT(10) UNSIGNED NOT NULL COMMENT 'Created date',
  `CREATED_DATE` DATETIME NOT NULL COMMENT 'Created date',
  `LAST_MODIFIED_BY` INT(10) UNSIGNED NOT NULL COMMENT 'Last modified by',
  `LAST_MODIFIED_DATE` DATETIME NOT NULL COMMENT 'Last modified date',
  PRIMARY KEY (`PRODUCT_ID`),
  CONSTRAINT `fk_product_genericLabelId`
    FOREIGN KEY (`GENERIC_LABEL_ID`)
    REFERENCES `fasp`.`ap_label` (`LABEL_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_product_labelId`
    FOREIGN KEY (`LABEL_ID`)
    REFERENCES `fasp`.`ap_label` (`LABEL_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_product_createdBy`
    FOREIGN KEY (`CREATED_BY`)
    REFERENCES `fasp`.`us_user` (`USER_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_product_lastModifiedBy`
    FOREIGN KEY (`LAST_MODIFIED_BY`)
    REFERENCES `fasp`.`us_user` (`USER_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_product_forecastingUnitId`
    FOREIGN KEY (`FORECASTING_UNIT_ID`)
    REFERENCES `fasp`.`ap_unit` (`UNIT_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_product_product_productCategoryId`
    FOREIGN KEY (`PRODUCT_CATEGORY_ID`)
    REFERENCES `fasp`.`rm_product_category` (`PRODUCT_CATEGORY_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Table used to list the Products\nNote: Are based on a Realm and can be created or administered by a Realm Admin';

CREATE INDEX `fk_product_genericLabelId_idx` ON `fasp`.`rm_product` (`GENERIC_LABEL_ID` ASC);

CREATE INDEX `fk_product_labelId_idx` ON `fasp`.`rm_product` (`LABEL_ID` ASC);

CREATE INDEX `fk_product_createdBy_idx` ON `fasp`.`rm_product` (`CREATED_BY` ASC);

CREATE INDEX `fk_product_lastModifedBy_idx` ON `fasp`.`rm_product` (`LAST_MODIFIED_BY` ASC);

CREATE INDEX `fk_product_forecastingUnitId_idx` ON `fasp`.`rm_product` (`FORECASTING_UNIT_ID` ASC);

CREATE INDEX `fk_product_productIdProductCategoryId_idx` ON `fasp`.`rm_product` (`PRODUCT_CATEGORY_ID` ASC);


-- -----------------------------------------------------
-- Table `fasp`.`rm_planning_unit`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `fasp`.`rm_planning_unit` ;

CREATE TABLE IF NOT EXISTS `fasp`.`rm_planning_unit` (
  `PLANNING_UNIT_ID` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Unique Id for each Planning unit',
  `PRODUCT_ID` INT(10) UNSIGNED NOT NULL COMMENT 'Foreign key for the Product that this Planning unit represents',
  `LABEL_ID` INT(10) UNSIGNED NOT NULL COMMENT 'Label Id that points to the label table so that we can get the text in different languages',
  `UNIT_ID` INT(10) UNSIGNED NOT NULL COMMENT 'Unit of measure for this Planning unit',
  `QTY_OF_FORECASTING_UNITS` DECIMAL(12,2) NOT NULL COMMENT 'Quantity of items in this unit versus the Forecasting Unit Id',
  `PRICE` DECIMAL(14,4) NOT NULL COMMENT 'Default price that we should consider for this Planning unit. In case the Procurement Agent has not specified the price or if the Procurement agent has not been decided as yet we will default to this price.',
  `ACTIVE` TINYINT(1) UNSIGNED NOT NULL COMMENT 'If True indicates this Funding Source is Active. False indicates this Funding Source has been Deactivated',
  `CREATED_BY` INT(10) UNSIGNED NOT NULL COMMENT 'Created by',
  `CREATED_DATE` DATETIME NOT NULL COMMENT 'Created date',
  `LAST_MODIFIED_BY` INT(10) UNSIGNED NOT NULL COMMENT 'Last Modified by',
  `LAST_MODIFIED_DATE` DATETIME NOT NULL COMMENT 'Last Modified date',
  PRIMARY KEY (`PLANNING_UNIT_ID`),
  CONSTRAINT `fk_planning_unit_productId`
    FOREIGN KEY (`PRODUCT_ID`)
    REFERENCES `fasp`.`rm_product` (`PRODUCT_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_planning_unit_labelId`
    FOREIGN KEY (`LABEL_ID`)
    REFERENCES `fasp`.`ap_label` (`LABEL_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_planning_unit_unitId`
    FOREIGN KEY (`UNIT_ID`)
    REFERENCES `fasp`.`ap_unit` (`UNIT_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_planning_unit_createdBy`
    FOREIGN KEY (`CREATED_BY`)
    REFERENCES `fasp`.`us_user` (`USER_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_planning_unit_lastModifiedBy`
    FOREIGN KEY (`LAST_MODIFIED_BY`)
    REFERENCES `fasp`.`us_user` (`USER_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Table used to list the Planning units that will be used to map a Product to a Program\nNote: Units are Realm level master and can only be Administered by a Realm level admin';

CREATE INDEX `fk_planning_unit_productId_idx` ON `fasp`.`rm_planning_unit` (`PRODUCT_ID` ASC);

CREATE INDEX `fk_planning_unit_labelId_idx` ON `fasp`.`rm_planning_unit` (`LABEL_ID` ASC);

CREATE INDEX `fk_planning_unit_unitId_idx` ON `fasp`.`rm_planning_unit` (`UNIT_ID` ASC);

CREATE INDEX `fk_planning_unit_createdBy_idx` ON `fasp`.`rm_planning_unit` (`CREATED_BY` ASC)  COMMENT '\n';

CREATE INDEX `fk_planning_unit_lastModifiedBy_idx` ON `fasp`.`rm_planning_unit` (`LAST_MODIFIED_BY` ASC);


-- -----------------------------------------------------
-- Table `fasp`.`rm_logistics_unit`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `fasp`.`rm_logistics_unit` ;

CREATE TABLE IF NOT EXISTS `fasp`.`rm_logistics_unit` (
  `LOGISTICS_UNIT_ID` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Unique Id for each Logistics unit',
  `PLANNING_UNIT_ID` INT(10) UNSIGNED NOT NULL COMMENT 'Foreign key to point which Planning unit this maps to',
  `LABEL_ID` INT(10) UNSIGNED NOT NULL COMMENT 'Label Id that points to the label table so that we can get the text in different languages',
  `UNIT_ID` INT(10) UNSIGNED NOT NULL COMMENT 'Unit of measure for this sku',
  `QTY_OF_PLANNING_UNITS` DECIMAL(12,2) UNSIGNED NOT NULL COMMENT 'Quantity of items in this unit as per the Forecasting Unit Id',
  `VARIANT` VARCHAR(50) NULL COMMENT 'Variant of the SKU, text updated by the user while creating the SKU',
  `MANUFACTURER_ID` INT(10) UNSIGNED NOT NULL COMMENT 'Foreign key to point which Manufacturer this Logistics unit is from',
  `WIDTH_UNIT_ID` INT(10) UNSIGNED NULL COMMENT 'Unit Id for a the Width of the Logistics Unit',
  `WIDTH_QTY` DECIMAL(12,2) UNSIGNED NULL COMMENT 'Width',
  `HEIGHT_UNIT_ID` INT(10) UNSIGNED NULL COMMENT 'Unit Id for a the Height of the Logistics Unit',
  `HEIGHT_QTY` DECIMAL(12,2) UNSIGNED NULL COMMENT 'Height',
  `LENGTH_UNIT_ID` INT(10) UNSIGNED NULL COMMENT 'Unit Id for a the Length of the Logistics Unit',
  `LENGTH_QTY` DECIMAL(12,2) UNSIGNED NULL COMMENT 'Length',
  `WEIGHT_UNIT_ID` INT(10) UNSIGNED NULL COMMENT 'Unit Id for a the Weight of the Logistics Unit',
  `WEIGHT_QTY` DECIMAL(12,2) UNSIGNED NULL COMMENT 'Weight',
  `QTY_IN_EURO1` DECIMAL(12,2) UNSIGNED NULL COMMENT 'No of Forecast units that fit in a Euro1 pallet',
  `QTY_IN_EURO2` DECIMAL(12,2) UNSIGNED NULL COMMENT 'No of Forecast units that fit in a Euro2 pallet',
  `ACTIVE` TINYINT(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'If True indicates this Logistics unit is Active. False indicates this Logistics unit has been Deactivated',
  `CREATED_BY` INT(10) UNSIGNED NOT NULL COMMENT 'Create by',
  `CREATED_DATE` DATETIME NOT NULL COMMENT 'Created date',
  `LAST_MODIFIED_BY` INT(10) UNSIGNED NOT NULL COMMENT 'Last modified by',
  `LAST_MODIFIED_DATE` DATETIME NOT NULL COMMENT 'Last modified date',
  PRIMARY KEY (`LOGISTICS_UNIT_ID`),
  CONSTRAINT `fk_logistics_unit_planningUnitId`
    FOREIGN KEY (`PLANNING_UNIT_ID`)
    REFERENCES `fasp`.`rm_planning_unit` (`PLANNING_UNIT_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_logistics_unit_labelId`
    FOREIGN KEY (`LABEL_ID`)
    REFERENCES `fasp`.`ap_label` (`LABEL_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_logistics_unit_unitId`
    FOREIGN KEY (`UNIT_ID`)
    REFERENCES `fasp`.`ap_unit` (`UNIT_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_logistics_unit_widthUnitId`
    FOREIGN KEY (`WIDTH_UNIT_ID`)
    REFERENCES `fasp`.`ap_unit` (`UNIT_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_logistics_unit_heightUnitId`
    FOREIGN KEY (`HEIGHT_UNIT_ID`)
    REFERENCES `fasp`.`ap_unit` (`UNIT_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_logistics_unit_lengthUnitId`
    FOREIGN KEY (`LENGTH_UNIT_ID`)
    REFERENCES `fasp`.`ap_unit` (`UNIT_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_logistics_unit_weightUnitId`
    FOREIGN KEY (`WEIGHT_UNIT_ID`)
    REFERENCES `fasp`.`ap_unit` (`UNIT_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_logistics_unit_createdBy`
    FOREIGN KEY (`CREATED_BY`)
    REFERENCES `fasp`.`us_user` (`USER_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_logistics_unit_lastModifiedBy`
    FOREIGN KEY (`LAST_MODIFIED_BY`)
    REFERENCES `fasp`.`us_user` (`USER_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_logistics_unit_manufacturerId`
    FOREIGN KEY (`MANUFACTURER_ID`)
    REFERENCES `fasp`.`rm_manufacturer` (`MANUFACTURER_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Table used to list the SKU\'s for a Product					\nNote: Are based on a Planning unit and can be created or administered by a Realm Admin';

CREATE INDEX `fk_logistics_unit_planningUnitId_idx` ON `fasp`.`rm_logistics_unit` (`PLANNING_UNIT_ID` ASC);

CREATE INDEX `fk_logistics_unit_labelId_idx` ON `fasp`.`rm_logistics_unit` (`LABEL_ID` ASC);

CREATE INDEX `fk_logistics_unit_unitId_idx` ON `fasp`.`rm_logistics_unit` (`UNIT_ID` ASC);

CREATE INDEX `fk_logistics_unit_widthUnitId_idx` ON `fasp`.`rm_logistics_unit` (`WIDTH_UNIT_ID` ASC);

CREATE INDEX `fk_logistics_unit_heightUnitId_idx` ON `fasp`.`rm_logistics_unit` (`HEIGHT_UNIT_ID` ASC);

CREATE INDEX `fk_logistics_unit_lengthUnitId_idx` ON `fasp`.`rm_logistics_unit` (`LENGTH_UNIT_ID` ASC);

CREATE INDEX `fk_logistics_unit_weightUnitId_idx` ON `fasp`.`rm_logistics_unit` (`WEIGHT_UNIT_ID` ASC);

CREATE INDEX `fk_logistics_unit_createdBy_idx` ON `fasp`.`rm_logistics_unit` (`CREATED_BY` ASC);

CREATE INDEX `fk_logistics_unit_lastModifiedBy_idx` ON `fasp`.`rm_logistics_unit` (`LAST_MODIFIED_BY` ASC);

CREATE INDEX `fk_logistics_unit_manufacturerId_idx` ON `fasp`.`rm_logistics_unit` (`MANUFACTURER_ID` ASC);


-- -----------------------------------------------------
-- Table `fasp`.`rm_procurement_agent_logistics_unit`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `fasp`.`rm_procurement_agent_logistics_unit` ;

CREATE TABLE IF NOT EXISTS `fasp`.`rm_procurement_agent_logistics_unit` (
  `PROCUREMENT_AGENT_SKU_ID` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Unique Id for each Procurement Agent SKU',
  `PROCUREMENT_AGENT_ID` INT(10) UNSIGNED NOT NULL COMMENT 'Foreign key that determines the Procuremnt Agent this Logistics Unit belongs to',
  `SKU_CODE` VARCHAR(50) NOT NULL COMMENT 'The Sku code that the Procurement agent refers to this Sku as',
  `LOGISTICS_UNIT_ID` INT(10) UNSIGNED NOT NULL COMMENT 'Foreign key that indicates which Logistics Unit Id this Procurement Sku maps to',
  `PRICE` DECIMAL(14,4) NOT NULL COMMENT 'Price that this Procurement agent is purchasing this Logistics Unit at. If null then default to the price set in for the Planning Unit',
  `APPROVED_TO_SHIPPED_LEAD_TIME` INT(10) NOT NULL COMMENT 'No of days for an Order to move from Approved to Shipped, if we do not have this then take from SKU table',
  `ACTIVE` TINYINT(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'If True indicates this Procurement Sku mapping is Active. False indicates this Procurement Sku has been De-activated',
  `CREATED_BY` INT(10) UNSIGNED NOT NULL COMMENT 'Created by',
  `CREATED_DATE` DATETIME NOT NULL COMMENT 'Created date',
  `LAST_MODIFIED_BY` INT(10) UNSIGNED NOT NULL COMMENT 'Last modified by',
  `LAST_MODIFIED_DATE` DATETIME NOT NULL COMMENT 'Last modified date',
  PRIMARY KEY (`PROCUREMENT_AGENT_SKU_ID`),
  CONSTRAINT `fk_procurement_agent_logistics_unit_procurementAgentId`
    FOREIGN KEY (`PROCUREMENT_AGENT_ID`)
    REFERENCES `fasp`.`rm_procurement_agent` (`PROCUREMENT_AGENT_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_procurement_agent_logistics_unit_logisticsUnitId`
    FOREIGN KEY (`LOGISTICS_UNIT_ID`)
    REFERENCES `fasp`.`rm_logistics_unit` (`LOGISTICS_UNIT_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_procurement_agent_logistics_unit_createdBy`
    FOREIGN KEY (`CREATED_BY`)
    REFERENCES `fasp`.`us_user` (`USER_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_procurement_agent_logistics_unit_lastModifiedBy`
    FOREIGN KEY (`LAST_MODIFIED_BY`)
    REFERENCES `fasp`.`us_user` (`USER_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Table used to map the Procurement Agent Sku to Logistics Unit\nNote: Can be administered at the Realm admin';

CREATE INDEX `fk_procurement_agent_logistics_unit_procurementAgentId_idx` ON `fasp`.`rm_procurement_agent_logistics_unit` (`PROCUREMENT_AGENT_ID` ASC);

CREATE INDEX `fk_procurement_agent_logistics_unit_logisticsUnitId_idx` ON `fasp`.`rm_procurement_agent_logistics_unit` (`LOGISTICS_UNIT_ID` ASC);

CREATE INDEX `fk_procurement_agent_logistics_unit_createdBy_idx` ON `fasp`.`rm_procurement_agent_logistics_unit` (`CREATED_BY` ASC);

CREATE INDEX `fk_procurement_agent_logistics_unit_lastModifiedBy_idx` ON `fasp`.`rm_procurement_agent_logistics_unit` (`LAST_MODIFIED_BY` ASC);

CREATE UNIQUE INDEX `unqProcurementAgentLogisticsUnitId` ON `fasp`.`rm_procurement_agent_logistics_unit` (`PROCUREMENT_AGENT_ID` ASC, `LOGISTICS_UNIT_ID` ASC)  COMMENT 'Unique mapping for Procurement agent and Logistics Unit Id';


-- -----------------------------------------------------
-- Table `fasp`.`rm_country_logistics_unit`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `fasp`.`rm_country_logistics_unit` ;

CREATE TABLE IF NOT EXISTS `fasp`.`rm_country_logistics_unit` (
  `COUNTRY_SKU_ID` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Unique Id for each Country level SKU',
  `REALM_COUNTRY_ID` INT(10) UNSIGNED NOT NULL COMMENT 'Foreign key that determines the Realm-Country this Sku belongs to',
  `SKU_CODE` VARCHAR(50) NOT NULL COMMENT 'Code that the Country uses to identify the SKU',
  `LOGISTICS_UNIT_ID` INT(10) UNSIGNED NULL COMMENT 'Foreign key that indicates which Logistics unit Id this Country Sku maps to',
  `PLANNING_UNIT_ID` INT(10) UNSIGNED NULL COMMENT 'Foreign key that indicates which Planning unit Id this Country Sku maps to',
  `PACK_SIZE` DECIMAL(12,2) UNSIGNED NULL COMMENT 'No of items of Planning Unit inside this Country Sku',
  `ACTIVE` TINYINT(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'If True indicates this Country Sku is Active. False indicates this Country Sku has been Deactivated',
  `CREATED_BY` INT(10) UNSIGNED NOT NULL COMMENT 'Created by',
  `CREATED_DATE` DATETIME NOT NULL COMMENT 'Created date',
  `LAST_MODIFIED_BY` INT(10) UNSIGNED NOT NULL COMMENT 'Last Modified by',
  `LAST_MODIFIED_DATE` DATETIME NOT NULL COMMENT 'Last Modified date',
  PRIMARY KEY (`COUNTRY_SKU_ID`),
  CONSTRAINT `fk_country_logistics_unit_realmCountryId`
    FOREIGN KEY (`REALM_COUNTRY_ID`)
    REFERENCES `fasp`.`rm_realm_country` (`REALM_COUNTRY_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_country_logistics_unit_logisticsUnitId`
    FOREIGN KEY (`LOGISTICS_UNIT_ID`)
    REFERENCES `fasp`.`rm_logistics_unit` (`LOGISTICS_UNIT_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_country_logistics_unit_planningUnitId`
    FOREIGN KEY (`PLANNING_UNIT_ID`)
    REFERENCES `fasp`.`rm_planning_unit` (`PLANNING_UNIT_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_country_logistics_unit_createdBy`
    FOREIGN KEY (`CREATED_BY`)
    REFERENCES `fasp`.`us_user` (`USER_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_country_logistics_unit_lastModifiedBy`
    FOREIGN KEY (`LAST_MODIFIED_BY`)
    REFERENCES `fasp`.`us_user` (`USER_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Table used to map the Country Sku to Logistics Unit or Planning Unit\nNote: Can be administered at the Realm admin. We can either use the Logistics Unit or the Planning Unit + Unit and Qty';

CREATE INDEX `fk_country_logistics_unit_realmCountryId_idx` ON `fasp`.`rm_country_logistics_unit` (`REALM_COUNTRY_ID` ASC);

CREATE INDEX `fk_country_logistics_unit_logisticsUnitId_idx` ON `fasp`.`rm_country_logistics_unit` (`LOGISTICS_UNIT_ID` ASC);

CREATE INDEX `fk_country_logistics_unit_planningUnitId_idx` ON `fasp`.`rm_country_logistics_unit` (`PLANNING_UNIT_ID` ASC);

CREATE INDEX `fk_country_logistics_unit_createdBy_idx` ON `fasp`.`rm_country_logistics_unit` (`CREATED_BY` ASC);

CREATE INDEX `fk_country_logistics_unit_lastModifiedBy_idx` ON `fasp`.`rm_country_logistics_unit` (`LAST_MODIFIED_BY` ASC);

CREATE UNIQUE INDEX `unqCountryLogisticsUnitId` ON `fasp`.`rm_country_logistics_unit` (`REALM_COUNTRY_ID` ASC, `LOGISTICS_UNIT_ID` ASC)  COMMENT 'Unique mapping between Country and Logistics unit';

CREATE UNIQUE INDEX `unqCountryPlanningUnitAndUnitId` ON `fasp`.`rm_country_logistics_unit` (`REALM_COUNTRY_ID` ASC, `PLANNING_UNIT_ID` ASC)  COMMENT 'Unique mapping for Country - Planning Unit and Unit Id mapping';


-- -----------------------------------------------------
-- Table `fasp`.`rm_logistics_unit_capacity`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `fasp`.`rm_logistics_unit_capacity` ;

CREATE TABLE IF NOT EXISTS `fasp`.`rm_logistics_unit_capacity` (
  `LOGISTICS_UNIT_CAPACITY_ID` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Unique Id for each Logistics Unit Capacity Id',
  `LOGISTICS_UNIT_ID` INT(10) UNSIGNED NOT NULL COMMENT 'Foreign key that points to the Logistics Unit Id that this record is for',
  `CAPACITY` DECIMAL(12,2) UNSIGNED NOT NULL COMMENT 'Global capacity level beyond which the manufacture cannot produce that GTIN',
  `START_DATE` DATE NOT NULL COMMENT 'Start period for the Capacity for this Logistics Unit',
  `STOP_DATE` DATE NOT NULL COMMENT 'Stop period for the Capacity for this Logistics Unit',
  `CREATED_BY` INT(10) UNSIGNED NOT NULL COMMENT 'Created by',
  `CREATED_DATE` DATETIME NOT NULL COMMENT 'Created date',
  `LAST_MODIFIED_BY` INT(10) UNSIGNED NOT NULL COMMENT 'Last Modified by',
  `LAST_MODIFIED_DATE` DATETIME NOT NULL COMMENT 'Last Modified date',
  PRIMARY KEY (`LOGISTICS_UNIT_CAPACITY_ID`),
  CONSTRAINT `fk_logistics_unit_capacity_logisticsUnitId`
    FOREIGN KEY (`LOGISTICS_UNIT_ID`)
    REFERENCES `fasp`.`rm_logistics_unit` (`LOGISTICS_UNIT_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_logistics_unit_capacity_createdBy`
    FOREIGN KEY (`CREATED_BY`)
    REFERENCES `fasp`.`us_user` (`USER_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_logistics_unit_capacity_lastModifiedBy`
    FOREIGN KEY (`LAST_MODIFIED_BY`)
    REFERENCES `fasp`.`us_user` (`USER_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Table used to store the Global capacity for each Logistics unit\nNote: More than one record for each Logistics unit, we need to check if the periods overlap an existing record and not allow a new entry if it does overlap. Also only those Logistics unit should be allowed whose Unit Id is the same as the Forecasting Unit Id of the corresponding Planning unit';

CREATE INDEX `fk_logistics_unit_capacity_logisticsUnitId_idx` ON `fasp`.`rm_logistics_unit_capacity` (`LOGISTICS_UNIT_ID` ASC);

CREATE INDEX `fk_logistics_unit_capacity_createdBy_idx` ON `fasp`.`rm_logistics_unit_capacity` (`CREATED_BY` ASC);

CREATE INDEX `fk_logistics_unit_capacity_lastModifiedBy_idx` ON `fasp`.`rm_logistics_unit_capacity` (`LAST_MODIFIED_BY` ASC);


-- -----------------------------------------------------
-- Table `fasp`.`rm_program_product`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `fasp`.`rm_program_product` ;

CREATE TABLE IF NOT EXISTS `fasp`.`rm_program_product` (
  `PROGRAM_PRODUCT_ID` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Unique Id for each Program - Product',
  `PROGRAM_ID` INT(10) UNSIGNED NOT NULL COMMENT 'Foreign key for the Program that this mapping refers to',
  `PRODUCT_ID` INT(10) UNSIGNED NOT NULL COMMENT 'Foreign key for the Planning Unit that this mapping refers to',
  `MIN_MONTHS` INT(10) UNSIGNED NOT NULL COMMENT 'Min number of months of stock that we should have before triggering a reorder',
  `MAX_MONTHS` INT(10) UNSIGNED NULL COMMENT 'Max number of months of stock that is recommended',
  `ACTIVE` TINYINT(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'If True indicates this mapping is Active. False indicates this mapping has been Deactivated',
  `CREATED_BY` INT(10) UNSIGNED NOT NULL COMMENT 'Created by',
  `CREATED_DATE` DATETIME NOT NULL COMMENT 'Created date',
  `LAST_MODIFIED_BY` INT(10) UNSIGNED NOT NULL COMMENT 'Last Modified by',
  `LAST_MODIFIED_DATE` DATETIME NOT NULL COMMENT 'Last Modified date',
  PRIMARY KEY (`PROGRAM_PRODUCT_ID`),
  CONSTRAINT `fk_program_product_programId`
    FOREIGN KEY (`PROGRAM_ID`)
    REFERENCES `fasp`.`rm_program` (`PROGRAM_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_program_product_productId`
    FOREIGN KEY (`PRODUCT_ID`)
    REFERENCES `fasp`.`rm_product` (`PRODUCT_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_program_product_createdBy`
    FOREIGN KEY (`CREATED_BY`)
    REFERENCES `fasp`.`us_user` (`USER_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_program_product_lastModifiedBy`
    FOREIGN KEY (`LAST_MODIFIED_BY`)
    REFERENCES `fasp`.`us_user` (`USER_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Table used to map the Products inside a Program\nNote: Allow the user to select a Product Category and therefore then select all the Products that should be used in the Program';

CREATE INDEX `fk_program_product_programId_idx` ON `fasp`.`rm_program_product` (`PROGRAM_ID` ASC);

CREATE INDEX `fk_program_product_productId_idx` ON `fasp`.`rm_program_product` (`PRODUCT_ID` ASC);

CREATE INDEX `fk_program_product_createdBy_idx` ON `fasp`.`rm_program_product` (`CREATED_BY` ASC);

CREATE INDEX `fk_program_product_lastModifiedBy_idx` ON `fasp`.`rm_program_product` (`LAST_MODIFIED_BY` ASC);

CREATE UNIQUE INDEX `unqProgramIdProductId` ON `fasp`.`rm_program_product` (`PROGRAM_ID` ASC, `PRODUCT_ID` ASC)  COMMENT 'Unique mapping for Program - Product mapping';


-- -----------------------------------------------------
-- Table `fasp`.`rm_inventory`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `fasp`.`rm_inventory` ;

CREATE TABLE IF NOT EXISTS `fasp`.`rm_inventory` (
  `INVENTORY_ID` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Unique Inventory Id for each Inventory record',
  `INVENTORY_DATE` DATE NOT NULL COMMENT 'Date this Inventory record is for',
  `PROGRAM_ID` INT(10) UNSIGNED NOT NULL COMMENT 'Foreign key that indicates which Program this record is for',
  `REGION_ID` INT(10) UNSIGNED NOT NULL COMMENT 'Foreign key that indicates the Region that this record is for',
  `LOGISTICS_UNIT_ID` INT(10) UNSIGNED NULL COMMENT 'Foreign key that indicates which Logistics Id the Inventory is for',
  `PLANNING_UNIT_ID` INT(10) UNSIGNED NULL COMMENT 'Foreign key that indicates which Planning Id this Inventory maps to',
  `PACK_SIZE` DECIMAL(12,2) UNSIGNED NULL COMMENT 'Quantity of items in this unit versus the Forecasting Unit Id',
  `ACTUAL_QTY` DECIMAL(12,2) UNSIGNED NULL COMMENT 'Inventory could be in two ways actual count or adjustment to running balance. If Actual Qty is provided use that or else do a running balance on Adjustment Qty',
  `ADJUSTMENT_QTY` DECIMAL(12,2) NULL COMMENT 'Inventory could be in two ways actual count or adjustment to running balance. If Actual Qty is provided use that or else do a running balance on Adjustment Qty',
  `BATCH_NO` VARCHAR(25) NULL COMMENT 'Batch no of the record that the data is for, can only be provided when a full stock count is being taken',
  `EXPIRY_DATE` DATE NULL COMMENT 'Expiry date of that Batch, again can only be provided when a full stock count is being taken',
  `DATA_SOURCE_ID` INT(10) UNSIGNED NOT NULL COMMENT 'Source of the Inventory',
  `CREATED_BY` INT(10) UNSIGNED NOT NULL COMMENT 'Created by',
  `CREATED_DATE` DATETIME NOT NULL COMMENT 'Created date',
  `LAST_MODIFIED_BY` INT(10) UNSIGNED NOT NULL COMMENT 'Last modified by',
  `LAST_MODIFIED_DATE` DATETIME NOT NULL COMMENT 'Last modified date',
  PRIMARY KEY (`INVENTORY_ID`),
  CONSTRAINT `fk_inventory_programId`
    FOREIGN KEY (`PROGRAM_ID`)
    REFERENCES `fasp`.`rm_program` (`PROGRAM_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_inventory_regionId`
    FOREIGN KEY (`REGION_ID`)
    REFERENCES `fasp`.`rm_region` (`REGION_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_inventory_logisticsUnitId`
    FOREIGN KEY (`LOGISTICS_UNIT_ID`)
    REFERENCES `fasp`.`rm_logistics_unit` (`LOGISTICS_UNIT_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_inventory_planningUnitId`
    FOREIGN KEY (`PLANNING_UNIT_ID`)
    REFERENCES `fasp`.`rm_planning_unit` (`PLANNING_UNIT_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_inventory_dataSourceId`
    FOREIGN KEY (`DATA_SOURCE_ID`)
    REFERENCES `fasp`.`ap_data_source` (`DATA_SOURCE_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_inventory_createdBy`
    FOREIGN KEY (`CREATED_BY`)
    REFERENCES `fasp`.`us_user` (`USER_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_inventory_lastModifiedBy`
    FOREIGN KEY (`LAST_MODIFIED_BY`)
    REFERENCES `fasp`.`us_user` (`USER_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Table used to store the inventory of the Products\nNote: Could be manually fed or can come from feeds from eLMIS';

CREATE INDEX `fk_inventory_programId_idx` ON `fasp`.`rm_inventory` (`PROGRAM_ID` ASC);

CREATE INDEX `fk_inventory_regionId_idx` ON `fasp`.`rm_inventory` (`REGION_ID` ASC);

CREATE INDEX `fk_inventory_logisticsUnitId_idx` ON `fasp`.`rm_inventory` (`LOGISTICS_UNIT_ID` ASC);

CREATE INDEX `fk_inventory_planningUnitId_idx` ON `fasp`.`rm_inventory` (`PLANNING_UNIT_ID` ASC);

CREATE INDEX `fk_inventory_dataSourceId_idx` ON `fasp`.`rm_inventory` (`DATA_SOURCE_ID` ASC);

CREATE INDEX `fk_inventory_createdBy_idx` ON `fasp`.`rm_inventory` (`CREATED_BY` ASC);

CREATE INDEX `fk_inventory_lastModifiedBy_idx` ON `fasp`.`rm_inventory` (`LAST_MODIFIED_BY` ASC);


-- -----------------------------------------------------
-- Table `fasp`.`rm_consumption`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `fasp`.`rm_consumption` ;

CREATE TABLE IF NOT EXISTS `fasp`.`rm_consumption` (
  `CONSUMPTION_ID` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Unique Id for each Consumption that is entered',
  `PROGRAM_ID` INT(10) UNSIGNED NOT NULL COMMENT 'Foreign key that indicates which Program this record is for',
  `REGION_ID` INT(10) UNSIGNED NOT NULL COMMENT 'Foreign key that indicates the Region that this record is for',
  `LOGISTICS_UNIT_ID` INT(10) UNSIGNED NULL COMMENT 'Foreign key that indicates which Logistics Id the Inventory is for',
  `PLANNING_UNIT_ID` INT(10) UNSIGNED NULL COMMENT 'Foreign key that indicates which Planning Id this Consumption maps to',
  `PACK_SIZE` DECIMAL(12,2) NULL COMMENT 'Quantity of items in this unit versus the Forecasting Unit Id',
  `CONSUMPTION_QTY` DECIMAL(12,2) NOT NULL COMMENT 'Consumption qty',
  `START_DATE` DATE NOT NULL COMMENT 'Consumption start date',
  `STOP_DATE` DATE NOT NULL COMMENT 'Consumption stop date',
  `DAYS_OF_STOCK_OUT` INT(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Days that we were out of stock in the particular Region for this Product',
  `DATA_SOURCE_ID` INT(10) UNSIGNED NOT NULL COMMENT 'Source of the Consumption, Could be Forecasted or Actual',
  `CREATED_BY` INT(10) UNSIGNED NOT NULL COMMENT 'Created by',
  `CREATED_DATE` DATETIME NOT NULL COMMENT 'Created date',
  `LAST_MODIFIED_BY` INT(10) UNSIGNED NOT NULL COMMENT 'Last Modified by',
  `LAST_MODIFIED_DATE` DATETIME NOT NULL COMMENT 'Last Modified date',
  PRIMARY KEY (`CONSUMPTION_ID`),
  CONSTRAINT `fk_consumption_programId`
    FOREIGN KEY (`PROGRAM_ID`)
    REFERENCES `fasp`.`rm_program` (`PROGRAM_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_consumption_regionId`
    FOREIGN KEY (`REGION_ID`)
    REFERENCES `fasp`.`rm_region` (`REGION_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_consumption_planningUnitId`
    FOREIGN KEY (`PLANNING_UNIT_ID`)
    REFERENCES `fasp`.`rm_planning_unit` (`PLANNING_UNIT_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_consumption_logisticsUnitId`
    FOREIGN KEY (`LOGISTICS_UNIT_ID`)
    REFERENCES `fasp`.`rm_logistics_unit` (`LOGISTICS_UNIT_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_consumption_dataSourceId`
    FOREIGN KEY (`DATA_SOURCE_ID`)
    REFERENCES `fasp`.`ap_data_source` (`DATA_SOURCE_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_consumption_createdBy`
    FOREIGN KEY (`CREATED_BY`)
    REFERENCES `fasp`.`us_user` (`USER_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_consumption_lastModifiedBy`
    FOREIGN KEY (`LAST_MODIFIED_BY`)
    REFERENCES `fasp`.`us_user` (`USER_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Table used to list the Consumption of Products\nNote: Could be manually fed or can come from feeds from eLMIS';

CREATE INDEX `fk_consumption_programId_idx` ON `fasp`.`rm_consumption` (`PROGRAM_ID` ASC);

CREATE INDEX `fk_consumption_regionId_idx` ON `fasp`.`rm_consumption` (`REGION_ID` ASC);

CREATE INDEX `fk_consumption_planningUnitId_idx` ON `fasp`.`rm_consumption` (`PLANNING_UNIT_ID` ASC);

CREATE INDEX `fk_consumption_logisticsUnitId_idx` ON `fasp`.`rm_consumption` (`LOGISTICS_UNIT_ID` ASC);

CREATE INDEX `fk_consumption_dataSourceId_idx` ON `fasp`.`rm_consumption` (`DATA_SOURCE_ID` ASC);

CREATE INDEX `fk_consumption_createdBy_idx` ON `fasp`.`rm_consumption` (`CREATED_BY` ASC);

CREATE INDEX `fk_consumption_lastModifiedBy_idx` ON `fasp`.`rm_consumption` (`LAST_MODIFIED_BY` ASC);


-- -----------------------------------------------------
-- Table `fasp`.`rm_shipment`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `fasp`.`rm_shipment` ;

CREATE TABLE IF NOT EXISTS `fasp`.`rm_shipment` (
  `SHIPMENT_ID` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Unique Shipment Id for each Shipment',
  `PROGRAM_ID` INT(10) UNSIGNED NOT NULL COMMENT 'Foreign key that indicates which Program this record is for',
  `REGION_ID` INT(10) UNSIGNED NOT NULL COMMENT 'Foreign key that indicates the Region that this record is for',
  `PRODUCT_ID` INT(10) UNSIGNED NOT NULL COMMENT 'Foreign key that indicates which Product this record is for',
  `SUGGESTED_PLANNED_DATE` DATE NOT NULL COMMENT 'Date that the System is suggesting we need to Plan the shipment based on Lead times',
  `SUGGESTED_QTY` DECIMAL(12,2) UNSIGNED NOT NULL COMMENT 'Suggested qty for this Shipment, in terms of Forecasting unit',
  `LOGISTICS_UNIT_ID` INT(10) UNSIGNED NULL COMMENT 'Foreign key that indicates which Logistics Id the shipment is for. This will be filled out once we have concluded on the order',
  `QTY` DECIMAL(12,2) UNSIGNED NULL COMMENT 'Qty of Logistics Unit in the Shipment',
  `PROCUREMENT_AGENT_ID` INT(10) UNSIGNED NULL COMMENT 'Foreign key that indicates which Procurement Agent this shipment belongs to',
  `PO_RO_NUMBER` VARCHAR(50) NULL COMMENT 'PO / RO number for the shipment',
  `SHIPMENT_PRICE` DECIMAL(12,2) UNSIGNED NULL COMMENT 'Final price of the Shipment for the Goods',
  `FREIGHT_PRICE` DECIMAL(12,2) UNSIGNED NULL COMMENT 'Cost of Freight for the Shipment',
  `ORDER_DATE` DATE NULL COMMENT 'Date the Order was Placed',
  `SHIP_DATE` DATE NULL COMMENT 'Date the Order was Shipped',
  `ARRIVE_DATE` DATE NULL COMMENT 'Date the Order arrived in the Country',
  `RECEIVE_DATE` DATE NULL COMMENT 'Date the Order was received into Inventory',
  `SHIPMENT_STATUS_ID` INT(10) UNSIGNED NOT NULL COMMENT 'Shipment Status Id',
  `NOTES` TEXT(255) NOT NULL COMMENT 'Notes for this Shipment',
  `DATA_SOURCE_ID` INT(10) UNSIGNED NOT NULL COMMENT 'Source of the Inventory',
  `CREATED_BY` INT(10) UNSIGNED NOT NULL COMMENT 'Created by',
  `CREATED_DATE` DATETIME NOT NULL COMMENT 'Created date',
  `LAST_MODIFIED_BY` INT(10) UNSIGNED NOT NULL COMMENT 'Last Modified by',
  `LAST_MODIFIED_DATE` DATETIME NOT NULL COMMENT 'Last Modified date',
  PRIMARY KEY (`SHIPMENT_ID`),
  CONSTRAINT `fk_shipment_programId`
    FOREIGN KEY (`PROGRAM_ID`)
    REFERENCES `fasp`.`rm_program` (`PROGRAM_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_shipment_regionId`
    FOREIGN KEY (`REGION_ID`)
    REFERENCES `fasp`.`rm_region` (`REGION_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_shipment_logisticsUnitId`
    FOREIGN KEY (`LOGISTICS_UNIT_ID`)
    REFERENCES `fasp`.`rm_logistics_unit` (`LOGISTICS_UNIT_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_shipment_dataSourceId`
    FOREIGN KEY (`DATA_SOURCE_ID`)
    REFERENCES `fasp`.`ap_data_source` (`DATA_SOURCE_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_shipment_createdBy`
    FOREIGN KEY (`CREATED_BY`)
    REFERENCES `fasp`.`us_user` (`USER_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_shipment_lastModifiedBy`
    FOREIGN KEY (`LAST_MODIFIED_BY`)
    REFERENCES `fasp`.`us_user` (`USER_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_shipment_procurementAgentId`
    FOREIGN KEY (`PROCUREMENT_AGENT_ID`)
    REFERENCES `fasp`.`rm_procurement_agent` (`PROCUREMENT_AGENT_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_shipment_shipmentStatusId`
    FOREIGN KEY (`SHIPMENT_STATUS_ID`)
    REFERENCES `fasp`.`ap_shipment_status` (`SHIPMENT_STATUS_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Table used to list all the Shipments\nNote: Complete Shipment dump, data can be manually fed or can come for ARTMIS or the Procurement Agent system';

CREATE INDEX `fk_shipment_programId_idx` ON `fasp`.`rm_shipment` (`PROGRAM_ID` ASC);

CREATE INDEX `fk_shipment_regionId_idx` ON `fasp`.`rm_shipment` (`REGION_ID` ASC);

CREATE INDEX `fk_shipment_logisticsUnitId_idx` ON `fasp`.`rm_shipment` (`LOGISTICS_UNIT_ID` ASC);

CREATE INDEX `fk_shipment_dataSourceId_idx` ON `fasp`.`rm_shipment` (`DATA_SOURCE_ID` ASC);

CREATE INDEX `fk_shipment_createdBy_idx` ON `fasp`.`rm_shipment` (`CREATED_BY` ASC);

CREATE INDEX `fk_shipment_lastModifiedBy_idx` ON `fasp`.`rm_shipment` (`LAST_MODIFIED_BY` ASC);

CREATE INDEX `fk_shipment_procurementAgentId_idx` ON `fasp`.`rm_shipment` (`PROCUREMENT_AGENT_ID` ASC);

CREATE INDEX `fk_shipment_shipmentStatusId_idx` ON `fasp`.`rm_shipment` (`SHIPMENT_STATUS_ID` ASC);


-- -----------------------------------------------------
-- Table `fasp`.`rm_logistics_unit_gtin`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `fasp`.`rm_logistics_unit_gtin` ;

CREATE TABLE IF NOT EXISTS `fasp`.`rm_logistics_unit_gtin` (
  `LOGISTICS_UNIT_GTIN_ID` INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Unique Id for each Logistics Unit GTIN mapping',
  `LOGISTICS_UNIT_ID` INT(10) UNSIGNED NOT NULL COMMENT 'Foreign key that points to the Logistics Unit Id that this record is for',
  `GTIN` VARCHAR(14) NOT NULL COMMENT 'GTIN for this SKU, this is a Universal number used to identify a packing unit from a Manufacturer including the actual production line. 14 char long.',
  `ACTIVE` TINYINT(1) UNSIGNED NOT NULL COMMENT 'If True indicates this mapping is Active. False indicates this mapping has been Deactivated',
  `CREATED_BY` INT(10) UNSIGNED NOT NULL COMMENT 'Created by',
  `CREATED_DATE` DATETIME NOT NULL COMMENT 'Created date',
  `LAST_MODIFIED_BY` INT(10) UNSIGNED NOT NULL COMMENT 'Last modified by',
  `LAST_MODIFIED_DATE` DATETIME NOT NULL COMMENT 'Last modified date',
  PRIMARY KEY (`LOGISTICS_UNIT_GTIN_ID`),
  CONSTRAINT `fk_logistics_uni_gtin_logisticsUnitId`
    FOREIGN KEY (`LOGISTICS_UNIT_ID`)
    REFERENCES `fasp`.`rm_logistics_unit` (`LOGISTICS_UNIT_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_logistics_uni_gtin_createdBy`
    FOREIGN KEY (`CREATED_BY`)
    REFERENCES `fasp`.`us_user` (`USER_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_logistics_uni_gtin_lastModifiedBy`
    FOREIGN KEY (`LAST_MODIFIED_BY`)
    REFERENCES `fasp`.`us_user` (`USER_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Table used to store the different GTIN\'s for each Logistics Unit\nNote: Since there a GTIN is based on a Manufacturer site and the actual line where the Product was made you can have more than 1 GTIN for each Logistics Unit';

CREATE INDEX `fk_logistics_uni_gtin_logisticsUnitId_idx` ON `fasp`.`rm_logistics_unit_gtin` (`LOGISTICS_UNIT_ID` ASC);

CREATE INDEX `fk_logistics_uni_gtin_createdBy_idx` ON `fasp`.`rm_logistics_unit_gtin` (`CREATED_BY` ASC);

CREATE INDEX `fk_logistics_uni_gtin_lastModifiedBy_idx` ON `fasp`.`rm_logistics_unit_gtin` (`LAST_MODIFIED_BY` ASC);


-- -----------------------------------------------------
-- Table `fasp`.`rm_shipment_budget`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `fasp`.`rm_shipment_budget` ;

CREATE TABLE IF NOT EXISTS `fasp`.`rm_shipment_budget` (
  `SHIPMENT_BUDGET_ID` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Unique Id for each Shipment Budget',
  `SHIPMENT_ID` INT(10) UNSIGNED NOT NULL COMMENT 'Shipment that this record refers to ',
  `FUNDING_SOURCE_ID` INT(10) UNSIGNED NOT NULL COMMENT 'Foreign key that indicates which Funding source this shipment belongs to, cannot be null. If we do not know it will be TBD',
  `SUB_FUNDING_SOURCE_ID` INT(10) UNSIGNED NULL COMMENT 'Foreign key that indicates which Sub Funding source this shipment belongs to. Can be null initially and updated later',
  `BUDGET_ID` INT(10) UNSIGNED NULL COMMENT 'Foreign key that indicates which Budget this shipment belongs to. Can by null initially and updated later',
  `BUDGET_AMT` DECIMAL(12,2) UNSIGNED NOT NULL COMMENT 'Amt of Shipment cost taken from this record. total for a Shipment should match with the Shipment cost',
  `ACTIVE` TINYINT(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'If True indicates this Record is Active. False indicates this Record has been Deactivated',
  `CREATED_BY` INT(10) UNSIGNED NOT NULL COMMENT 'Created by',
  `CREATED_DATE` DATETIME NOT NULL COMMENT 'Created date',
  `LAST_MODIFIED_BY` INT(10) UNSIGNED NOT NULL COMMENT 'Last modified by',
  `LAST_MODIFIED_DATE` DATETIME NOT NULL COMMENT 'Last modified date',
  PRIMARY KEY (`SHIPMENT_BUDGET_ID`),
  CONSTRAINT `fk_shipment_budget_shipmentId`
    FOREIGN KEY (`SHIPMENT_ID`)
    REFERENCES `fasp`.`rm_shipment` (`SHIPMENT_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_shipment_budget_fundingSourceId`
    FOREIGN KEY (`FUNDING_SOURCE_ID`)
    REFERENCES `fasp`.`rm_funding_source` (`FUNDING_SOURCE_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_shipment_budget_subFundingSource`
    FOREIGN KEY (`SUB_FUNDING_SOURCE_ID`)
    REFERENCES `fasp`.`rm_sub_funding_source` (`SUB_FUNDING_SOURCE_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_shipment_budget_createdBy`
    FOREIGN KEY (`CREATED_BY`)
    REFERENCES `fasp`.`us_user` (`USER_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_shipment_budget_lastModifiedBy`
    FOREIGN KEY (`LAST_MODIFIED_BY`)
    REFERENCES `fasp`.`us_user` (`USER_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Table used to track the Budget that the Shipment is being funded by\nNote: When a Shipment is planned at that time there could be just a simple TBD in the Funding Source and entire Shipment towards the Budget Amt, with everything else as null.';

CREATE INDEX `fk_shipment_budget_shipmentId_idx` ON `fasp`.`rm_shipment_budget` (`SHIPMENT_ID` ASC);

CREATE INDEX `fk_shipment_budget_fundingSourceId_idx` ON `fasp`.`rm_shipment_budget` (`FUNDING_SOURCE_ID` ASC);

CREATE INDEX `fk_shipment_budget_subFundingSourceId_idx` ON `fasp`.`rm_shipment_budget` (`SUB_FUNDING_SOURCE_ID` ASC);

CREATE INDEX `fk_shipment_budget_createdBy_idx` ON `fasp`.`rm_shipment_budget` (`CREATED_BY` ASC);

CREATE INDEX `fk_shipment_budget_lastModifiedBy_idx` ON `fasp`.`rm_shipment_budget` (`LAST_MODIFIED_BY` ASC);


-- -----------------------------------------------------
-- Table `fasp`.`tk_ticket_type`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `fasp`.`tk_ticket_type` ;

CREATE TABLE IF NOT EXISTS `fasp`.`tk_ticket_type` (
  `TICKET_TYPE_ID` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Unique Id for each Ticket Type',
  `LABEL_ID` INT(10) UNSIGNED NOT NULL COMMENT 'Label Id that points to the label table so that we can get the text in different languages',
  `TICKET_LEVEL` INT(10) UNSIGNED NOT NULL COMMENT 'The Level the ticket is for. 1 - Application level, 2 - Realm level, 3 - Program level',
  `ACTIVE` TINYINT(1) UNSIGNED NOT NULL COMMENT 'If True indicates this Ticket Type is Active. False indicates this Ticket Type has been Deactivated',
  `CREATED_BY` INT(10) UNSIGNED NOT NULL COMMENT 'Created by',
  `CREATED_DATE` DATETIME NOT NULL COMMENT 'Created date',
  `LAST_MODIFIED_BY` INT(10) UNSIGNED NOT NULL COMMENT 'Last modified by',
  `LAST_MODIFIED_DATE` DATETIME NOT NULL COMMENT 'Last modified date',
  PRIMARY KEY (`TICKET_TYPE_ID`),
  CONSTRAINT `fk_ticket_type_createdBy`
    FOREIGN KEY (`CREATED_BY`)
    REFERENCES `fasp`.`us_user` (`USER_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ticket_type_lastModifiedBy`
    FOREIGN KEY (`LAST_MODIFIED_BY`)
    REFERENCES `fasp`.`us_user` (`USER_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ticket_type_labelId`
    FOREIGN KEY (`LABEL_ID`)
    REFERENCES `fasp`.`ap_label` (`LABEL_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Table used to store the Ticket types\nNote: The Level the ticket is for. 1 - Application level, 2 - Realm level, 3 - Program level';

CREATE INDEX `fk_ticket_type_createdBy_idx` ON `fasp`.`tk_ticket_type` (`CREATED_BY` ASC);

CREATE INDEX `fk_ticket_type_lastModifiedBy_idx` ON `fasp`.`tk_ticket_type` (`LAST_MODIFIED_BY` ASC);

CREATE INDEX `fk_ticket_type_labelId_idx` ON `fasp`.`tk_ticket_type` (`LABEL_ID` ASC);


-- -----------------------------------------------------
-- Table `fasp`.`tk_ticket_status`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `fasp`.`tk_ticket_status` ;

CREATE TABLE IF NOT EXISTS `fasp`.`tk_ticket_status` (
  `TICKET_STATUS_ID` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Unique Id for each Ticket Status	',
  `LABEL_ID` INT(10) UNSIGNED NOT NULL COMMENT 'Label Id that points to the label table so that we can get the text in different languages',
  `ACTIVE` TINYINT(1) UNSIGNED NOT NULL COMMENT 'If True indicates this Ticket Status is Active. False indicates this Ticket Status has been Deactivated',
  `CREATED_BY` INT(10) UNSIGNED NOT NULL COMMENT 'Created by',
  `CREATED_DATE` DATETIME NOT NULL COMMENT 'Created date',
  `LAST_MODIFIED_BY` INT(10) UNSIGNED NOT NULL COMMENT 'Last modified by',
  `LAST_MODIFIED_DATE` DATETIME NOT NULL COMMENT 'Last modified date',
  PRIMARY KEY (`TICKET_STATUS_ID`),
  CONSTRAINT `fk_ticket_status_createdBy`
    FOREIGN KEY (`LAST_MODIFIED_BY`)
    REFERENCES `fasp`.`us_user` (`USER_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ticket_status_lastModifiedBy`
    FOREIGN KEY (`CREATED_BY`)
    REFERENCES `fasp`.`us_user` (`USER_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ticket_status_labelId`
    FOREIGN KEY (`LABEL_ID`)
    REFERENCES `fasp`.`ap_label` (`LABEL_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Table used to store the Ticket statuses';

CREATE INDEX `fk_ticket_status_createdBy_idx` ON `fasp`.`tk_ticket_status` (`LAST_MODIFIED_BY` ASC);

CREATE INDEX `fk_ticket_status_lastModifiedBy_idx` ON `fasp`.`tk_ticket_status` (`CREATED_BY` ASC);

CREATE INDEX `fk_ticket_status_labelId_idx` ON `fasp`.`tk_ticket_status` (`LABEL_ID` ASC);


-- -----------------------------------------------------
-- Table `fasp`.`tk_ticket`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `fasp`.`tk_ticket` ;

CREATE TABLE IF NOT EXISTS `fasp`.`tk_ticket` (
  `TICKET_ID` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Unique Id for each Ticket',
  `TICKET_TYPE_ID` INT(10) UNSIGNED NOT NULL COMMENT 'Ticket type that this Ticket is of',
  `REFFERENCE_ID` INT(10) UNSIGNED NOT NULL COMMENT 'Foreign key that points to the Primary key of the Table that the Ticket is for',
  `NOTES` TEXT NOT NULL COMMENT 'Notes that the creator wants to include in the request for the Ticket',
  `TICKET_STATUS_ID` INT(10) UNSIGNED NOT NULL COMMENT 'Status for the Ticket',
  `CREATED_BY` INT(10) UNSIGNED NOT NULL COMMENT 'Created by',
  `CREATED_DATE` DATETIME NOT NULL COMMENT 'Created date',
  `LAST_MODIFIED_BY` INT(10) UNSIGNED NOT NULL COMMENT 'Last modified by',
  `LAST_MODIFIED_DATE` DATETIME NOT NULL COMMENT 'Last modified date',
  PRIMARY KEY (`TICKET_ID`),
  CONSTRAINT `fk_ticket_createdBy`
    FOREIGN KEY (`CREATED_BY`)
    REFERENCES `fasp`.`us_user` (`USER_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ticket_lastModifiedBy`
    FOREIGN KEY (`LAST_MODIFIED_BY`)
    REFERENCES `fasp`.`us_user` (`USER_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ticket_ticket_statusId`
    FOREIGN KEY (`TICKET_STATUS_ID`)
    REFERENCES `fasp`.`tk_ticket_status` (`TICKET_STATUS_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ticket_ticket_typeId`
    FOREIGN KEY (`TICKET_TYPE_ID`)
    REFERENCES `fasp`.`tk_ticket_type` (`TICKET_TYPE_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Table used to store the tickets received for different changes to Masters\nNote: Would only be for a specific Realm';

CREATE INDEX `fk_ticket_createdBy_idx` ON `fasp`.`tk_ticket` (`CREATED_BY` ASC);

CREATE INDEX `fk_ticket_lastModifiedBy_idx` ON `fasp`.`tk_ticket` (`LAST_MODIFIED_BY` ASC);

CREATE INDEX `fk_ticket_ticket_statusId_idx` ON `fasp`.`tk_ticket` (`TICKET_STATUS_ID` ASC);

CREATE INDEX `fk_ticket_ticket_typeId_idx` ON `fasp`.`tk_ticket` (`TICKET_TYPE_ID` ASC);


-- -----------------------------------------------------
-- Table `fasp`.`tk_ticket_trans`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `fasp`.`tk_ticket_trans` ;

CREATE TABLE IF NOT EXISTS `fasp`.`tk_ticket_trans` (
  `TICKET_TRANS_ID` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Transaction id',
  `TICKET_ID` INT(10) UNSIGNED NOT NULL COMMENT 'Ticket Id that this transaction is for',
  `TICKET_STATUS_ID` INT(10) UNSIGNED NOT NULL COMMENT 'Status for the Ticket',
  `NOTES` TEXT NOT NULL COMMENT 'Notes from the transaction',
  `LAST_MODIFIED_BY` INT(10) UNSIGNED NOT NULL COMMENT 'Last modified by',
  `LAST_MODIFIED_DATE` DATETIME NOT NULL COMMENT 'Last modified date',
  PRIMARY KEY (`TICKET_TRANS_ID`),
  CONSTRAINT `fk_ticket_trans_lastModifiedBy`
    FOREIGN KEY (`LAST_MODIFIED_BY`)
    REFERENCES `fasp`.`us_user` (`USER_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ticket_trans_ticketId`
    FOREIGN KEY (`TICKET_ID`)
    REFERENCES `fasp`.`tk_ticket` (`TICKET_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ticket_trans_ticket_statusId`
    FOREIGN KEY (`TICKET_STATUS_ID`)
    REFERENCES `fasp`.`tk_ticket_status` (`TICKET_STATUS_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Transaction table for the Tickets';

CREATE INDEX `fk_ticket_trans_lastModifiedBy_idx` ON `fasp`.`tk_ticket_trans` (`LAST_MODIFIED_BY` ASC);

CREATE INDEX `fk_ticket_trans_ticketId_idx` ON `fasp`.`tk_ticket_trans` (`TICKET_ID` ASC);

CREATE INDEX `fk_ticket_trans_ticket_statusId_idx` ON `fasp`.`tk_ticket_trans` (`TICKET_STATUS_ID` ASC);


-- -----------------------------------------------------
-- Table `fasp`.`em_email_template`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `fasp`.`em_email_template` ;

CREATE TABLE IF NOT EXISTS `fasp`.`em_email_template` (
  `EMAIL_TEMPLATE_ID` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `EMAIL_DESC` VARCHAR(150) NULL DEFAULT NULL,
  `SUBJECT` VARCHAR(250) NOT NULL,
  `SUBJECT_PARAM` VARCHAR(100) NULL DEFAULT NULL,
  `EMAIL_BODY` TEXT NULL DEFAULT NULL,
  `EMAIL_BODY_PARAM` VARCHAR(500) NULL DEFAULT NULL,
  `CC_TO` VARCHAR(150) NULL DEFAULT NULL,
  `CREATED_BY` INT(10) UNSIGNED NOT NULL,
  `CREATED_DATE` DATETIME NULL DEFAULT NULL,
  `LAST_MODIFIED_BY` INT(10) UNSIGNED NOT NULL,
  `LAST_MODIFIED_DATE` DATETIME NULL DEFAULT NULL,
  `ACTIVE` TINYINT(1) NULL DEFAULT '0',
  `TO_SEND` TEXT NULL DEFAULT NULL,
  `BCC` TEXT NULL DEFAULT NULL,
  PRIMARY KEY (`EMAIL_TEMPLATE_ID`),
  CONSTRAINT `fk_em_email_template_us_user1`
    FOREIGN KEY (`LAST_MODIFIED_BY`)
    REFERENCES `fasp`.`us_user` (`USER_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_em_email_template_us_user2`
    FOREIGN KEY (`CREATED_BY`)
    REFERENCES `fasp`.`us_user` (`USER_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 3
DEFAULT CHARACTER SET = latin1;

CREATE INDEX `fk_em_email_template_us_user1_idx` ON `fasp`.`em_email_template` (`LAST_MODIFIED_BY` ASC);

CREATE INDEX `fk_em_email_template_us_user2_idx` ON `fasp`.`em_email_template` (`CREATED_BY` ASC);


-- -----------------------------------------------------
-- Table `fasp`.`em_emailer`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `fasp`.`em_emailer` ;

CREATE TABLE IF NOT EXISTS `fasp`.`em_emailer` (
  `EMAILER_ID` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `TO_SEND` LONGTEXT NULL DEFAULT NULL,
  `SUBJECT` LONGTEXT NULL DEFAULT NULL,
  `BODY` LONGTEXT NULL DEFAULT NULL,
  `CC_SEND_TO` LONGTEXT NULL DEFAULT NULL,
  `CREATED_DATE` DATETIME NULL DEFAULT NULL,
  `TO_SEND_DATE` DATETIME NULL DEFAULT NULL,
  `LAST_MODIFIED_DATE` DATETIME NULL DEFAULT NULL,
  `ATTEMPTS` INT(10) UNSIGNED NULL DEFAULT '0',
  `STATUS` INT(10) UNSIGNED NULL DEFAULT '0' COMMENT '0-New,1-Sent,2-failed',
  `REASON` TEXT NULL DEFAULT NULL,
  `BCC` TEXT NULL DEFAULT NULL,
  PRIMARY KEY (`EMAILER_ID`))
ENGINE = InnoDB
AUTO_INCREMENT = 10
DEFAULT CHARACTER SET = latin1
COMMENT = 'Table that stores all the emails that have been sent from the system';

CREATE INDEX `idxStatus` ON `fasp`.`em_emailer` (`STATUS` ASC);

CREATE INDEX `idxCreatedDt` ON `fasp`.`em_emailer` (`CREATED_DATE` ASC);

CREATE INDEX `idxToSendDate` ON `fasp`.`em_emailer` (`TO_SEND_DATE` ASC);


-- -----------------------------------------------------
-- Table `fasp`.`em_file_store`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `fasp`.`em_file_store` ;

CREATE TABLE IF NOT EXISTS `fasp`.`em_file_store` (
  `FILE_ID` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `FILE_PATH` TEXT NOT NULL,
  `CREATED_DATE` DATETIME NOT NULL,
  `CREATED_BY` INT(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`FILE_ID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `fasp`.`em_emailer_filepath_mapping`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `fasp`.`em_emailer_filepath_mapping` ;

CREATE TABLE IF NOT EXISTS `fasp`.`em_emailer_filepath_mapping` (
  `EMAILER_FILEPATH_MAPPING_ID` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `EMAILER_ID` INT(10) UNSIGNED NOT NULL,
  `FILE_ID` INT(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`EMAILER_FILEPATH_MAPPING_ID`),
  CONSTRAINT `fk_em_emailer_filepath_mapping_em_file_store`
    FOREIGN KEY (`FILE_ID`)
    REFERENCES `fasp`.`em_file_store` (`FILE_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_em_emailer_filepath_mapping_em_emailer1`
    FOREIGN KEY (`EMAILER_ID`)
    REFERENCES `fasp`.`em_emailer` (`EMAILER_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

CREATE INDEX `FK_emailer_filepath_mapping_emailer_id` ON `fasp`.`em_emailer_filepath_mapping` (`EMAILER_ID` ASC);

CREATE INDEX `FK_emailer_filepath_mapping_file_id` ON `fasp`.`em_emailer_filepath_mapping` (`FILE_ID` ASC);


-- -----------------------------------------------------
-- Table `fasp`.`us_forgot_password_token`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `fasp`.`us_forgot_password_token` ;

CREATE TABLE IF NOT EXISTS `fasp`.`us_forgot_password_token` (
  `FORGOT_PASSWORD_TOKEN_ID` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Unique Id for each Token',
  `USER_ID` INT(10) UNSIGNED NOT NULL COMMENT 'User Id that this token is generated for',
  `TOKEN` VARCHAR(25) NOT NULL COMMENT 'Random Token string consisting of a-z, A-Z and 0-9 that is generated for the request',
  `TOKEN_GENERATION_DATE` DATETIME NOT NULL COMMENT 'Date that the request was generated',
  `TOKEN_TRIGGERED_DATE` DATETIME NULL COMMENT 'Date that the token was triggered by clicking on the link. If not triggered the value is null.',
  `TOKEN_COMPLETION_DATE` DATETIME NULL COMMENT 'Date that the token was completed by reseting the password. If not completed the value is null.',
  PRIMARY KEY (`FORGOT_PASSWORD_TOKEN_ID`),
  CONSTRAINT `fk_us_forgot_password_token_us_user1`
    FOREIGN KEY (`USER_ID`)
    REFERENCES `fasp`.`us_user` (`USER_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Table used to store the Tokens generated for a forgot password request';

CREATE INDEX `fk_us_forgot_password_token_us_user1_idx` ON `fasp`.`us_forgot_password_token` (`USER_ID` ASC);

CREATE UNIQUE INDEX `unq_token` ON `fasp`.`us_forgot_password_token` (`TOKEN` ASC)  COMMENT 'Token must be unique';

USE `fasp` ;

-- -----------------------------------------------------
-- procedure generateForgotPasswordToken
-- -----------------------------------------------------

USE `fasp`;
DROP procedure IF EXISTS `fasp`.`generateForgotPasswordToken`;

DELIMITER $$
USE `fasp`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateForgotPasswordToken`(`VAR_USER_ID` INT(10), `VAR_TOKEN_DATE` DATETIME)
BEGIN
	SET @userId = null;
	SELECT USER_ID INTO @userId FROM us_user WHERE USER_ID=VAR_USER_ID;
    IF @userId IS NOT NULL THEN 
		SET @rowCnt = 1;
		SET @token = '';
		WHILE (@rowCnt != 0) DO
			SET @token = '';
			SET @allowedChars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
			SET @allowedCharsLen = LENGTH(@allowedChars);
			SET @tokenLen = 25;
			SET @i = 0;
			WHILE (@i < @tokenLen) DO
				SET @token = CONCAT(@token, substring(@allowedChars, FLOOR(RAND() * @allowedCharsLen + 1), 1));
				SET @i = @i + 1;
			END WHILE;
			SELECT count(*) INTO @rowCnt FROM us_forgot_password_token WHERE TOKEN=@token;
		END WHILE;
		INSERT INTO us_forgot_password_token (USER_ID, TOKEN, TOKEN_GENERATION_DATE) VALUES (@userId, @token, `VAR_TOKEN_DATE`);
        SELECT @token;
	ELSE 
		select null;
    END IF;
END$$

DELIMITER ;
USE `fasp`;

DELIMITER $$

USE `fasp`$$
DROP TRIGGER IF EXISTS `fasp`.`ap_currency_AFTER_INSERT` $$
USE `fasp`$$
CREATE DEFINER = CURRENT_USER TRIGGER `fasp`.`ap_currency_AFTER_INSERT` AFTER INSERT ON `ap_currency` FOR EACH ROW
BEGIN
	INSERT INTO ap_currency_history (CURRENCY_ID, CONVERSION_RATE_TO_USD, LAST_MODIFIED_DATE) 
    VALUES(new.`CURRENCY_ID`,new.`CONVERSION_RATE_TO_USD`,new.`LAST_MODIFIED_DATE`);
END$$


USE `fasp`$$
DROP TRIGGER IF EXISTS `fasp`.`ap_currency_AFTER_UPDATE` $$
USE `fasp`$$
CREATE DEFINER = CURRENT_USER TRIGGER `fasp`.`ap_currency_AFTER_UPDATE` AFTER UPDATE ON `ap_currency` FOR EACH ROW
BEGIN
	INSERT INTO ap_currency_history (CURRENCY_ID, CONVERSION_RATE_TO_USD, LAST_MODIFIED_DATE) 
    VALUES(new.`CURRENCY_ID`,new.`CONVERSION_RATE_TO_USD`,new.`LAST_MODIFIED_DATE`);
END$$


DELIMITER ;

-- -----------------------------------------------------
-- Data for table `fasp`.`ap_language`
-- -----------------------------------------------------
START TRANSACTION;
USE `fasp`;
INSERT INTO `fasp`.`ap_language` (`LANGUAGE_ID`, `LANGUAGE_NAME`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (1, 'English', 1, 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');
INSERT INTO `fasp`.`ap_language` (`LANGUAGE_ID`, `LANGUAGE_NAME`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (2, 'French', 1, 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');
INSERT INTO `fasp`.`ap_language` (`LANGUAGE_ID`, `LANGUAGE_NAME`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (3, 'Spanish', 1, 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');
INSERT INTO `fasp`.`ap_language` (`LANGUAGE_ID`, `LANGUAGE_NAME`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (4, 'Pourtegese', 1, 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');

COMMIT;


-- -----------------------------------------------------
-- Data for table `fasp`.`ap_label`
-- -----------------------------------------------------
START TRANSACTION;
USE `fasp`;
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (1, 'United States of America', '', '', '', 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (2, 'Kenya', '', '', '', 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (3, 'Malawi', '', '', '', 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (4, 'US Aid', '', '', '', 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (5, 'US Dollar', '', '', '', 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (6, 'Length', '', '', '', 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (7, 'Weight', '', '', '', 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (8, 'Area', '', '', '', 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (9, 'Volume', '', '', '', 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (10, 'Items or Pieces', '', '', '', 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (11, 'Meters', '', '', '', 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (12, 'Centimeters', '', '', '', 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (13, 'Millimeters', '', '', '', 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (14, 'Feet', '', '', '', 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (15, 'Inches', '', '', '', 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (16, 'Planned', '', '', '', 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (17, 'Draft', '', '', '', 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (18, 'Submitted', '', '', '', 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (19, 'Approved', '', '', '', 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (20, 'Shipped', '', '', '', 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (21, 'Delivered', '', '', '', 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (22, 'Received', '', '', '', 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (23, 'Pound Sterling', '', '', '', 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (24, 'Euro', '', '', '', 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (25, 'Update Application Masters', '', '', '', 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (26, 'Create Realm', '', '', '', 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (27, 'Update Realm Masters', '', '', '', 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (28, 'Create Users', '', '', '', 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (29, 'Update Program Masters', '', '', '', 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (30, 'Update Program Data', '', '', '', 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (31, 'View Reports', '', '', '', 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (32, 'Application level Admin', '', '', '', 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (33, 'Realm level Admin', '', '', '', 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (34, 'Program level Admin', '', '', '', 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (35, 'Program User', '', '', '', 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (36, 'HIV / AIDS', '', '', '', 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (37, 'Family Planning', '', '', '', 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (38, 'Malaria', '', '', '', 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (39, 'Ministry of Health (MoH)', '', '', '', 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (40, 'National', '', '', '', 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (41, 'National level', '', '', '', 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (42, 'North', '', '', '', 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (43, 'South', '', '', '', 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (44, 'All Categories', '', '', '', 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (45, 'Reproductive Health', '', '', '', 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (46, 'Male Condom', '', '', '', 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (47, 'Female Condom', '', '', '', 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (48, 'Oral Hormonal Contraceptive', '', '', '', 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (49, 'Subdermal Implant', '', '', '', 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (50, 'Injectables', '', '', '', 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (51, 'Intra Uterine Device', '', '', '', 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (52, 'Diagnostic Test Kits', '', '', '', 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (53, 'HIV RDT Kits', '', '', '', 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (54, 'Malaria RDT Kits', '', '', '', 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (55, 'All other RDT kits', '', '', '', 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (56, 'All Introvirals', '', '', '', 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (57, 'Essential drugs', '', '', '', 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (58, 'Anti-Malarials', '', '', '', 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (59, 'HIV - tablets', '', '', '', 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (60, 'Lab Equipments and Supplies', '', '', '', 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (61, 'Other Commodities', '', '', '', 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (62, 'Malaria commodities', '', '', '', 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (63, 'All commodities', '', '', '', 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (64, 'Bed nets', '', '', '', 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (65, 'Male Condom - Strawbery', '', '', '', 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (66, 'Abacavir 300mg', '', '', '', 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (67, 'Male Condom - Banana', '', '', '', 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (68, 'Male Condom - No label', '', '', '', 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (69, 'TLD', '', '', '', 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (70, 'Kilograms', '', '', '', 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (71, 'Grams', '', '', '', 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (72, 'Pounds', '', '', '', 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (73, 'Ounces', '', '', '', 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (74, 'Tons', '', '', '', 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (75, 'Square feet', '', '', '', 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (76, 'Square meters', '', '', '', 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (77, 'Liters', '', '', '', 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (78, 'US Gallons', '', '', '', 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (79, 'Milliliters', '', '', '', 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (80, 'Pieces', '', '', '', 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (81, 'Items', '', '', '', 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (82, 'Each', '', '', '', 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (83, 'Box', '', '', '', 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (84, 'Case', '', '', '', 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (85, 'Euro 1 Pallet', '', '', '', 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (86, 'Euro 2 Pallet', '', '', '', 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (87, '40 ft container', '', '', '', 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (88, '20 ft container', '', '', '', 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (89, 'Tablet', '', '', '', 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (90, 'Bottle', '', '', '', 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (91, 'Bubble strip', '', '', '', 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (92, 'Pack', '', '', '', 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (93, 'No label Male Condom - Pack of 6', '', '', '', 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (94, 'Strawberry falvored Male Condom - Pack of 6', '', '', '', 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (95, 'No label Male Condom - Pack of 5', '', '', '', 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (96, 'Abacavir 300mg - Bottle of 60', '', '', '', 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (97, 'Abacavir 300mg - Strip of 12', '', '', '', 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (98, 'TLD - 90', '', '', '', 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (99, 'TLD - 30', '', '', '', 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (100, 'TLD - 90 - 1 Bottle', '', '', '', 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (101, 'TLD - 90 - 20 Bottles', '', '', '', 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (102, 'TLD - 90 - 4000 Bottles', '', '', '', 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (103, 'Strawberry falvored Male Condom - Case of 288', '', '', '', 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (104, 'Strawberry falvored Male Condom - Euro 1 Pallet of 28800', '', '', '', 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (105, 'Abacavir 300mg - Pack of 36', '', '', '', 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (106, 'Abacavir 300mg - Case of 3600', '', '', '', 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (107, 'Pink colored Male Condom - Case of 300', '', '', '', 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (108, 'pallet', '', '', '', 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (109, 'PSM', '', '', '', 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (110, 'GF', '', '', '', 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (111, 'PSM', '', '', '', 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (112, 'Glaxo', '', '', '', 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (113, 'Flazo', '', '', '', 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (114, 'Cloned Consumption', '', '', '', 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (115, 'Facility Reports', '', '', '', 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (116, 'Demographic Goal', '', '', '', 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (117, 'Interpolate', '', '', '', 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (118, 'LMIS Reports', '', '', '', 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (119, 'MSD Reports', '', '', '', 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (120, 'Physical Inventory Count', '', '', '', 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (121, 'SDP Reports', '', '', '', 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (122, 'Stock Cards', '', '', '', 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (123, 'Supplier Reports', '', '', '', 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (124, 'Projected Trend', '', '', '', 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (125, 'Warehouse Reports', '', '', '', 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (126, 'ACTCON', '', '', '', 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (127, 'FORCON', '', '', '', 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (128, 'INV', '', '', '', 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (129, 'SHIP', '', '', '', 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (130, 'USAID', '', '', '', 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (131, 'UNFPA', '', '', '', 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (132, 'PEPFAR', '', '', '', 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (133, 'Gates Foundation', '', '', '', 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (134, 'HIV / Aids - Kenya - Ministry of Health', '', '', '', 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (135, 'Malaria - Kenya - National', '', '', '', 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (136, 'Family planning - Malawi - National', '', '', '', 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (137, 'Kenya - 2020 H1', '', '', '', 1, '2020-03-01 10:00:00', 1, '2020-03-01 10:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (138, 'Malaria - 2020', '', '', '', 1, '2020-03-01 10:00:00', 1, '2020-03-01 10:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (139, 'Family Planning - Malawi 2020', '', '', '', 1, '2020-03-01 10:00:00', 1, '2020-03-01 10:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (140, 'HIV/AIDS', '', '', '', 1, '2020-03-02 10:00:00', 1, '2020-03-02 10:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (141, 'Malaria', '', '', '', 1, '2020-03-02 10:00:00', 1, '2020-03-02 10:00:00');
INSERT INTO `fasp`.`ap_label` (`LABEL_ID`, `LABEL_EN`, `LABEL_FR`, `LABEL_SP`, `LABEL_PR`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (142, 'Family Planning - Gates Found', '', '', '', 1, '2020-03-02 10:00:00', 1, '2020-03-02 10:00:00');

COMMIT;


-- -----------------------------------------------------
-- Data for table `fasp`.`rm_realm`
-- -----------------------------------------------------
START TRANSACTION;
USE `fasp`;
INSERT INTO `fasp`.`rm_realm` (`REALM_ID`, `REALM_CODE`, `LABEL_ID`, `MONTHS_IN_PAST_FOR_AMC`, `MONTHS_IN_FUTURE_FOR_AMC`, `ORDER_FREQUENCY`, `DEFAULT_REALM`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (1, 'UAID', 4, 3, 6, 4, 1, 1, 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');

COMMIT;


-- -----------------------------------------------------
-- Data for table `fasp`.`us_user`
-- -----------------------------------------------------
START TRANSACTION;
USE `fasp`;
INSERT INTO `fasp`.`us_user` (`USER_ID`, `REALM_ID`, `USERNAME`, `PASSWORD`, `EMAIL_ID`, `PHONE`, `LANGUAGE_ID`, `ACTIVE`, `FAILED_ATTEMPTS`, `EXPIRES_ON`, `SYNC_EXPIRES_ON`, `LAST_LOGIN_DATE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (1, 1, 'anchal', 0x24326124313024645875672E42784E52575748656F4A7746596C593575706E6E68397A4C56596A43616E615569395073494753566241577A507A7757, 'anchal.c@altius.cc', '96371396638', 1, 1, 0, '2020-03-10 12:00:00', '2020-03-10 12:00:00', NULL, 1, '2020-02-12 12:00:00', 1, '2020-02-12 12:00:00');

COMMIT;


-- -----------------------------------------------------
-- Data for table `fasp`.`ap_currency`
-- -----------------------------------------------------
START TRANSACTION;
USE `fasp`;
INSERT INTO `fasp`.`ap_currency` (`CURRENCY_ID`, `CURRENCY_CODE`, `CURRENCY_SYMBOL`, `LABEL_ID`, `CONVERSION_RATE_TO_USD`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (1, 'USD', '$', 5, 1, 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');
INSERT INTO `fasp`.`ap_currency` (`CURRENCY_ID`, `CURRENCY_CODE`, `CURRENCY_SYMBOL`, `LABEL_ID`, `CONVERSION_RATE_TO_USD`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (2, 'GBP', '£', 20, 1.29, 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');
INSERT INTO `fasp`.`ap_currency` (`CURRENCY_ID`, `CURRENCY_CODE`, `CURRENCY_SYMBOL`, `LABEL_ID`, `CONVERSION_RATE_TO_USD`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (3, 'EUR', '€', 21, 1.08, 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');

COMMIT;


-- -----------------------------------------------------
-- Data for table `fasp`.`ap_country`
-- -----------------------------------------------------
START TRANSACTION;
USE `fasp`;
INSERT INTO `fasp`.`ap_country` (`COUNTRY_ID`, `LABEL_ID`, `COUNTRY_CODE`, `CURRENCY_ID`, `LANGUAGE_ID`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (1, 1, 'USA', 1, 1, 1, 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');
INSERT INTO `fasp`.`ap_country` (`COUNTRY_ID`, `LABEL_ID`, `COUNTRY_CODE`, `CURRENCY_ID`, `LANGUAGE_ID`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (2, 2, 'KEN', 1, 1, 1, 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');
INSERT INTO `fasp`.`ap_country` (`COUNTRY_ID`, `LABEL_ID`, `COUNTRY_CODE`, `CURRENCY_ID`, `LANGUAGE_ID`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (3, 3, 'MWI', 1, 1, 1, 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');

COMMIT;


-- -----------------------------------------------------
-- Data for table `fasp`.`rm_realm_country`
-- -----------------------------------------------------
START TRANSACTION;
USE `fasp`;
INSERT INTO `fasp`.`rm_realm_country` (`REALM_COUNTRY_ID`, `REALM_ID`, `COUNTRY_ID`, `DEFAULT_CURRENCY_ID`, `PALLET_UNIT_ID`, `AIR_FREIGHT_PERC`, `SEA_FREIGHT_PERC`, `SHIPPED_TO_ARRIVED_AIR_LEAD_TIME`, `SHIPPED_TO_ARRIVED_SEA_LEAD_TIME`, `ARRIVED_TO_DELIVERED_LEAD_TIME`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (1, 1, 2, 1, 1, .20, .08, 10, 90, 15, 1, 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');
INSERT INTO `fasp`.`rm_realm_country` (`REALM_COUNTRY_ID`, `REALM_ID`, `COUNTRY_ID`, `DEFAULT_CURRENCY_ID`, `PALLET_UNIT_ID`, `AIR_FREIGHT_PERC`, `SEA_FREIGHT_PERC`, `SHIPPED_TO_ARRIVED_AIR_LEAD_TIME`, `SHIPPED_TO_ARRIVED_SEA_LEAD_TIME`, `ARRIVED_TO_DELIVERED_LEAD_TIME`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (2, 1, 3, 1, 1, .23, .10, 12, 80, 10, 1, 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');

COMMIT;


-- -----------------------------------------------------
-- Data for table `fasp`.`rm_health_area`
-- -----------------------------------------------------
START TRANSACTION;
USE `fasp`;
INSERT INTO `fasp`.`rm_health_area` (`HEALTH_AREA_ID`, `REALM_ID`, `LABEL_ID`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (1, 1, 36, 1, 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');
INSERT INTO `fasp`.`rm_health_area` (`HEALTH_AREA_ID`, `REALM_ID`, `LABEL_ID`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (2, 1, 37, 1, 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');
INSERT INTO `fasp`.`rm_health_area` (`HEALTH_AREA_ID`, `REALM_ID`, `LABEL_ID`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (3, 1, 38, 1, 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');

COMMIT;


-- -----------------------------------------------------
-- Data for table `fasp`.`rm_product_category`
-- -----------------------------------------------------
START TRANSACTION;
USE `fasp`;
INSERT INTO `fasp`.`rm_product_category` (`PRODUCT_CATEGORY_ID`, `LABEL_ID`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (1, 44, 1, 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`rm_product_category` (`PRODUCT_CATEGORY_ID`, `LABEL_ID`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (2, 45, 1, 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`rm_product_category` (`PRODUCT_CATEGORY_ID`, `LABEL_ID`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (3, 46, 1, 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`rm_product_category` (`PRODUCT_CATEGORY_ID`, `LABEL_ID`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (4, 47, 1, 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`rm_product_category` (`PRODUCT_CATEGORY_ID`, `LABEL_ID`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (5, 48, 1, 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`rm_product_category` (`PRODUCT_CATEGORY_ID`, `LABEL_ID`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (6, 49, 1, 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`rm_product_category` (`PRODUCT_CATEGORY_ID`, `LABEL_ID`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (7, 50, 1, 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`rm_product_category` (`PRODUCT_CATEGORY_ID`, `LABEL_ID`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (8, 51, 1, 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`rm_product_category` (`PRODUCT_CATEGORY_ID`, `LABEL_ID`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (9, 52, 1, 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`rm_product_category` (`PRODUCT_CATEGORY_ID`, `LABEL_ID`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (10, 53, 1, 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`rm_product_category` (`PRODUCT_CATEGORY_ID`, `LABEL_ID`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (11, 54, 1, 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`rm_product_category` (`PRODUCT_CATEGORY_ID`, `LABEL_ID`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (12, 55, 1, 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`rm_product_category` (`PRODUCT_CATEGORY_ID`, `LABEL_ID`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (13, 56, 1, 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`rm_product_category` (`PRODUCT_CATEGORY_ID`, `LABEL_ID`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (14, 57, 1, 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`rm_product_category` (`PRODUCT_CATEGORY_ID`, `LABEL_ID`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (15, 58, 1, 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`rm_product_category` (`PRODUCT_CATEGORY_ID`, `LABEL_ID`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (16, 59, 1, 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`rm_product_category` (`PRODUCT_CATEGORY_ID`, `LABEL_ID`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (17, 60, 1, 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`rm_product_category` (`PRODUCT_CATEGORY_ID`, `LABEL_ID`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (18, 61, 1, 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`rm_product_category` (`PRODUCT_CATEGORY_ID`, `LABEL_ID`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (19, 62, 1, 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`rm_product_category` (`PRODUCT_CATEGORY_ID`, `LABEL_ID`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (20, 63, 1, 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`rm_product_category` (`PRODUCT_CATEGORY_ID`, `LABEL_ID`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (21, 64, 1, 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');

COMMIT;


-- -----------------------------------------------------
-- Data for table `fasp`.`rm_organisation`
-- -----------------------------------------------------
START TRANSACTION;
USE `fasp`;
INSERT INTO `fasp`.`rm_organisation` (`ORGANISATION_ID`, `REALM_ID`, `LABEL_ID`, `ORGANISATION_CODE`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (1, 1, 39, 'MOH', 1, 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');
INSERT INTO `fasp`.`rm_organisation` (`ORGANISATION_ID`, `REALM_ID`, `LABEL_ID`, `ORGANISATION_CODE`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (2, 1, 40, 'NATL', 1, 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');

COMMIT;


-- -----------------------------------------------------
-- Data for table `fasp`.`rm_program`
-- -----------------------------------------------------
START TRANSACTION;
USE `fasp`;
INSERT INTO `fasp`.`rm_program` (`PROGRAM_ID`, `REALM_COUNTRY_ID`, `ORGANISATION_ID`, `HEALTH_AREA_ID`, `LABEL_ID`, `PROGRAM_MANAGER_USER_ID`, `PROGRAM_NOTES`, `AIR_FREIGHT_PERC`, `SEA_FREIGHT_PERC`, `PLANNED_TO_DRAFT_LEAD_TIME`, `DRAFT_TO_SUBMITTED_LEAD_TIME`, `SUBMITTED_TO_APPROVED_LEAD_TIME`, `APPROVED_TO_SHIPPED_LEAD_TIME`, `DELIVERED_TO_RECEIVED_LEAD_TIME`, `MONTHS_IN_PAST_FOR_AMC`, `MONTHS_IN_FUTURE_FOR_AMC`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (1, 1, 1, 1, 134, 1, '', .25, .08, 20, 15, 45, 60, 10, 3, 6, 1, 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');
INSERT INTO `fasp`.`rm_program` (`PROGRAM_ID`, `REALM_COUNTRY_ID`, `ORGANISATION_ID`, `HEALTH_AREA_ID`, `LABEL_ID`, `PROGRAM_MANAGER_USER_ID`, `PROGRAM_NOTES`, `AIR_FREIGHT_PERC`, `SEA_FREIGHT_PERC`, `PLANNED_TO_DRAFT_LEAD_TIME`, `DRAFT_TO_SUBMITTED_LEAD_TIME`, `SUBMITTED_TO_APPROVED_LEAD_TIME`, `APPROVED_TO_SHIPPED_LEAD_TIME`, `DELIVERED_TO_RECEIVED_LEAD_TIME`, `MONTHS_IN_PAST_FOR_AMC`, `MONTHS_IN_FUTURE_FOR_AMC`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (2, 1, 2, 3, 135, 1, '', .23, .07, 20, 15, 45, 60, 10, 3, 6, 1, 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');
INSERT INTO `fasp`.`rm_program` (`PROGRAM_ID`, `REALM_COUNTRY_ID`, `ORGANISATION_ID`, `HEALTH_AREA_ID`, `LABEL_ID`, `PROGRAM_MANAGER_USER_ID`, `PROGRAM_NOTES`, `AIR_FREIGHT_PERC`, `SEA_FREIGHT_PERC`, `PLANNED_TO_DRAFT_LEAD_TIME`, `DRAFT_TO_SUBMITTED_LEAD_TIME`, `SUBMITTED_TO_APPROVED_LEAD_TIME`, `APPROVED_TO_SHIPPED_LEAD_TIME`, `DELIVERED_TO_RECEIVED_LEAD_TIME`, `MONTHS_IN_PAST_FOR_AMC`, `MONTHS_IN_FUTURE_FOR_AMC`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (3, 2, 2, 2, 136, 1, '', .20, .12, 30, 20, 50, 60, 10, 3, 6, 1, 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');

COMMIT;


-- -----------------------------------------------------
-- Data for table `fasp`.`rm_region`
-- -----------------------------------------------------
START TRANSACTION;
USE `fasp`;
INSERT INTO `fasp`.`rm_region` (`REGION_ID`, `REALM_COUNTRY_ID`, `LABEL_ID`, `CAPACITY_CBM`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (1, 1, 41, 40000, 1, 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');
INSERT INTO `fasp`.`rm_region` (`REGION_ID`, `REALM_COUNTRY_ID`, `LABEL_ID`, `CAPACITY_CBM`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (2, 2, 42, 18000, 1, 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');
INSERT INTO `fasp`.`rm_region` (`REGION_ID`, `REALM_COUNTRY_ID`, `LABEL_ID`, `CAPACITY_CBM`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (3, 2, 43, 13500, 1, 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');

COMMIT;


-- -----------------------------------------------------
-- Data for table `fasp`.`us_role`
-- -----------------------------------------------------
START TRANSACTION;
USE `fasp`;
INSERT INTO `fasp`.`us_role` (`ROLE_ID`, `LABEL_ID`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES ('ROLE_APPL_ADMIN', 32, 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');
INSERT INTO `fasp`.`us_role` (`ROLE_ID`, `LABEL_ID`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES ('ROLE_REALM_ADMIN', 33, 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');
INSERT INTO `fasp`.`us_role` (`ROLE_ID`, `LABEL_ID`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES ('ROLE_PROG_ADMIN', 34, 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');
INSERT INTO `fasp`.`us_role` (`ROLE_ID`, `LABEL_ID`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES ('ROLE_USER', 35, 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');

COMMIT;


-- -----------------------------------------------------
-- Data for table `fasp`.`us_business_function`
-- -----------------------------------------------------
START TRANSACTION;
USE `fasp`;
INSERT INTO `fasp`.`us_business_function` (`BUSINESS_FUNCTION_ID`, `LABEL_ID`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES ('ROLE_BF_UPDATE_APPL_MASTER', 25, 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');
INSERT INTO `fasp`.`us_business_function` (`BUSINESS_FUNCTION_ID`, `LABEL_ID`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES ('ROLE_BF_CREATE_REALM', 26, 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');
INSERT INTO `fasp`.`us_business_function` (`BUSINESS_FUNCTION_ID`, `LABEL_ID`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES ('ROLE_BF_UPDATE_REALM_MASTER', 27, 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');
INSERT INTO `fasp`.`us_business_function` (`BUSINESS_FUNCTION_ID`, `LABEL_ID`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES ('ROLE_BF_CREATE_USER', 28, 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');
INSERT INTO `fasp`.`us_business_function` (`BUSINESS_FUNCTION_ID`, `LABEL_ID`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES ('ROLE_BF_UPDATE_PROGRAM_PROPERTIES', 29, 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');
INSERT INTO `fasp`.`us_business_function` (`BUSINESS_FUNCTION_ID`, `LABEL_ID`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES ('ROLE_BF_UPDATE_PROGRAM_DATA', 30, 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');
INSERT INTO `fasp`.`us_business_function` (`BUSINESS_FUNCTION_ID`, `LABEL_ID`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES ('ROLE_BF_VIEW_REPORTS', 31, 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');

COMMIT;


-- -----------------------------------------------------
-- Data for table `fasp`.`us_user_role`
-- -----------------------------------------------------
START TRANSACTION;
USE `fasp`;
INSERT INTO `fasp`.`us_user_role` (`USER_ROLE_ID`, `USER_ID`, `ROLE_ID`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (1, 1, 'ROLE_APPL_ADMIN', 1, '2020-03-10 12:00:00', 1, '2020-03-10 12:00:00');
INSERT INTO `fasp`.`us_user_role` (`USER_ROLE_ID`, `USER_ID`, `ROLE_ID`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (2, 1, 'ROLE_REALM_ADMIN', 1, '2020-03-10 12:00:00', 1, '2020-03-10 12:00:00');

COMMIT;


-- -----------------------------------------------------
-- Data for table `fasp`.`us_role_business_function`
-- -----------------------------------------------------
START TRANSACTION;
USE `fasp`;
INSERT INTO `fasp`.`us_role_business_function` (`ROLE_BUSINESS_FUNCTION_ID`, `ROLE_ID`, `BUSINESS_FUNCTION_ID`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (1, 'ROLE_APPL_ADMIN', 'ROLE_BF_UPDATE_APPL_MASTER', 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');
INSERT INTO `fasp`.`us_role_business_function` (`ROLE_BUSINESS_FUNCTION_ID`, `ROLE_ID`, `BUSINESS_FUNCTION_ID`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (2, 'ROLE_APPL_ADMIN', 'ROLE_BF_CREATE_REALM', 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');
INSERT INTO `fasp`.`us_role_business_function` (`ROLE_BUSINESS_FUNCTION_ID`, `ROLE_ID`, `BUSINESS_FUNCTION_ID`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (3, 'ROLE_APPL_ADMIN', 'ROLE_BF_CREATE_USER', 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');
INSERT INTO `fasp`.`us_role_business_function` (`ROLE_BUSINESS_FUNCTION_ID`, `ROLE_ID`, `BUSINESS_FUNCTION_ID`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (4, 'ROLE_REALM_ADMIN', 'ROLE_BF_UPDATE_REALM_MASTER', 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');
INSERT INTO `fasp`.`us_role_business_function` (`ROLE_BUSINESS_FUNCTION_ID`, `ROLE_ID`, `BUSINESS_FUNCTION_ID`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (5, 'ROLE_REALM_ADMIN', 'ROLE_BF_CREATE_USER', 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');
INSERT INTO `fasp`.`us_role_business_function` (`ROLE_BUSINESS_FUNCTION_ID`, `ROLE_ID`, `BUSINESS_FUNCTION_ID`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (6, 'ROLE_PROG_ADMIN', 'ROLE_BF_UPDATE_PROGRAM_PROPERTIES', 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');
INSERT INTO `fasp`.`us_role_business_function` (`ROLE_BUSINESS_FUNCTION_ID`, `ROLE_ID`, `BUSINESS_FUNCTION_ID`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (7, 'ROLE_PROG_ADMIN', 'ROLE_BF_UPDATE_PROGRAM_DATA', 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');
INSERT INTO `fasp`.`us_role_business_function` (`ROLE_BUSINESS_FUNCTION_ID`, `ROLE_ID`, `BUSINESS_FUNCTION_ID`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (8, 'ROLE_PROG_ADMIN', 'ROLE_BF_VIEW_REPORTS', 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');
INSERT INTO `fasp`.`us_role_business_function` (`ROLE_BUSINESS_FUNCTION_ID`, `ROLE_ID`, `BUSINESS_FUNCTION_ID`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (9, 'ROLE_USER', 'ROLE_BF_UPDATE_PROGRAM_DATA', 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');
INSERT INTO `fasp`.`us_role_business_function` (`ROLE_BUSINESS_FUNCTION_ID`, `ROLE_ID`, `BUSINESS_FUNCTION_ID`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (10, 'ROLE_USER', 'ROLE_BF_VIEW_REPORTS', 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');

COMMIT;


-- -----------------------------------------------------
-- Data for table `fasp`.`us_user_acl`
-- -----------------------------------------------------
START TRANSACTION;
USE `fasp`;
INSERT INTO `fasp`.`us_user_acl` (`USER_ACL_ID`, `USER_ID`, `REALM_COUNTRY_ID`, `HEALTH_AREA_ID`, `ORGANISATION_ID`, `PROGRAM_ID`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (1, 1, NULL, NULL, NULL, NULL, 1, '2020-03-10 12:00:00', 1, '2020-03-10 12:00:00');

COMMIT;


-- -----------------------------------------------------
-- Data for table `fasp`.`ap_data_source_type`
-- -----------------------------------------------------
START TRANSACTION;
USE `fasp`;
INSERT INTO `fasp`.`ap_data_source_type` (`DATA_SOURCE_TYPE_ID`, `LABEL_ID`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (1, 126, 1, 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_data_source_type` (`DATA_SOURCE_TYPE_ID`, `LABEL_ID`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (2, 127, 1, 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_data_source_type` (`DATA_SOURCE_TYPE_ID`, `LABEL_ID`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (3, 128, 1, 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_data_source_type` (`DATA_SOURCE_TYPE_ID`, `LABEL_ID`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (4, 129, 1, 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');

COMMIT;


-- -----------------------------------------------------
-- Data for table `fasp`.`ap_data_source`
-- -----------------------------------------------------
START TRANSACTION;
USE `fasp`;
INSERT INTO `fasp`.`ap_data_source` (`DATA_SOURCE_ID`, `DATA_SOURCE_TYPE_ID`, `LABEL_ID`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (1, 2, 114, '1', 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_data_source` (`DATA_SOURCE_ID`, `DATA_SOURCE_TYPE_ID`, `LABEL_ID`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (2, 3, 115, '1', 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_data_source` (`DATA_SOURCE_ID`, `DATA_SOURCE_TYPE_ID`, `LABEL_ID`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (3, 2, 116, '1', 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_data_source` (`DATA_SOURCE_ID`, `DATA_SOURCE_TYPE_ID`, `LABEL_ID`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (4, 2, 117, '1', 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_data_source` (`DATA_SOURCE_ID`, `DATA_SOURCE_TYPE_ID`, `LABEL_ID`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (5, 1, 118, '1', 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_data_source` (`DATA_SOURCE_ID`, `DATA_SOURCE_TYPE_ID`, `LABEL_ID`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (6, 1, 119, '1', 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_data_source` (`DATA_SOURCE_ID`, `DATA_SOURCE_TYPE_ID`, `LABEL_ID`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (7, 3, 120, '1', 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_data_source` (`DATA_SOURCE_ID`, `DATA_SOURCE_TYPE_ID`, `LABEL_ID`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (8, 1, 121, '1', 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_data_source` (`DATA_SOURCE_ID`, `DATA_SOURCE_TYPE_ID`, `LABEL_ID`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (9, 3, 122, '1', 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_data_source` (`DATA_SOURCE_ID`, `DATA_SOURCE_TYPE_ID`, `LABEL_ID`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (10, 4, 123, '1', 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_data_source` (`DATA_SOURCE_ID`, `DATA_SOURCE_TYPE_ID`, `LABEL_ID`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (11, 2, 124, '1', 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_data_source` (`DATA_SOURCE_ID`, `DATA_SOURCE_TYPE_ID`, `LABEL_ID`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (12, 4, 125, '1', 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');

COMMIT;


-- -----------------------------------------------------
-- Data for table `fasp`.`ap_shipment_status`
-- -----------------------------------------------------
START TRANSACTION;
USE `fasp`;
INSERT INTO `fasp`.`ap_shipment_status` (`SHIPMENT_STATUS_ID`, `LABEL_ID`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (1, 16, 1, 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');
INSERT INTO `fasp`.`ap_shipment_status` (`SHIPMENT_STATUS_ID`, `LABEL_ID`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (2, 17, 1, 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');
INSERT INTO `fasp`.`ap_shipment_status` (`SHIPMENT_STATUS_ID`, `LABEL_ID`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (3, 18, 1, 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');
INSERT INTO `fasp`.`ap_shipment_status` (`SHIPMENT_STATUS_ID`, `LABEL_ID`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (4, 19, 1, 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');
INSERT INTO `fasp`.`ap_shipment_status` (`SHIPMENT_STATUS_ID`, `LABEL_ID`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (5, 20, 1, 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');
INSERT INTO `fasp`.`ap_shipment_status` (`SHIPMENT_STATUS_ID`, `LABEL_ID`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (6, 21, 1, 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');
INSERT INTO `fasp`.`ap_shipment_status` (`SHIPMENT_STATUS_ID`, `LABEL_ID`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (7, 22, 1, 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');

COMMIT;


-- -----------------------------------------------------
-- Data for table `fasp`.`ap_shipment_status_allowed`
-- -----------------------------------------------------
START TRANSACTION;
USE `fasp`;
INSERT INTO `fasp`.`ap_shipment_status_allowed` (`SHIPMENT_STATUS_ALLOWED_ID`, `SHIPMENT_STATUS_ID`, `NEXT_SHIPMENT_STATUS_ID`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (1, 1, 1, 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');
INSERT INTO `fasp`.`ap_shipment_status_allowed` (`SHIPMENT_STATUS_ALLOWED_ID`, `SHIPMENT_STATUS_ID`, `NEXT_SHIPMENT_STATUS_ID`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (2, 1, 2, 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');
INSERT INTO `fasp`.`ap_shipment_status_allowed` (`SHIPMENT_STATUS_ALLOWED_ID`, `SHIPMENT_STATUS_ID`, `NEXT_SHIPMENT_STATUS_ID`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (3, 1, 3, 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');
INSERT INTO `fasp`.`ap_shipment_status_allowed` (`SHIPMENT_STATUS_ALLOWED_ID`, `SHIPMENT_STATUS_ID`, `NEXT_SHIPMENT_STATUS_ID`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (4, 2, 2, 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');
INSERT INTO `fasp`.`ap_shipment_status_allowed` (`SHIPMENT_STATUS_ALLOWED_ID`, `SHIPMENT_STATUS_ID`, `NEXT_SHIPMENT_STATUS_ID`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (5, 2, 2, 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');
INSERT INTO `fasp`.`ap_shipment_status_allowed` (`SHIPMENT_STATUS_ALLOWED_ID`, `SHIPMENT_STATUS_ID`, `NEXT_SHIPMENT_STATUS_ID`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (6, 3, 3, 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');
INSERT INTO `fasp`.`ap_shipment_status_allowed` (`SHIPMENT_STATUS_ALLOWED_ID`, `SHIPMENT_STATUS_ID`, `NEXT_SHIPMENT_STATUS_ID`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (7, 3, 4, 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');
INSERT INTO `fasp`.`ap_shipment_status_allowed` (`SHIPMENT_STATUS_ALLOWED_ID`, `SHIPMENT_STATUS_ID`, `NEXT_SHIPMENT_STATUS_ID`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (8, 4, 4, 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');
INSERT INTO `fasp`.`ap_shipment_status_allowed` (`SHIPMENT_STATUS_ALLOWED_ID`, `SHIPMENT_STATUS_ID`, `NEXT_SHIPMENT_STATUS_ID`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (9, 4, 5, 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');
INSERT INTO `fasp`.`ap_shipment_status_allowed` (`SHIPMENT_STATUS_ALLOWED_ID`, `SHIPMENT_STATUS_ID`, `NEXT_SHIPMENT_STATUS_ID`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (10, 4, 6, 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');
INSERT INTO `fasp`.`ap_shipment_status_allowed` (`SHIPMENT_STATUS_ALLOWED_ID`, `SHIPMENT_STATUS_ID`, `NEXT_SHIPMENT_STATUS_ID`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (11, 4, 7, 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');
INSERT INTO `fasp`.`ap_shipment_status_allowed` (`SHIPMENT_STATUS_ALLOWED_ID`, `SHIPMENT_STATUS_ID`, `NEXT_SHIPMENT_STATUS_ID`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (12, 5, 5, 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');
INSERT INTO `fasp`.`ap_shipment_status_allowed` (`SHIPMENT_STATUS_ALLOWED_ID`, `SHIPMENT_STATUS_ID`, `NEXT_SHIPMENT_STATUS_ID`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (13, 5, 6, 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');
INSERT INTO `fasp`.`ap_shipment_status_allowed` (`SHIPMENT_STATUS_ALLOWED_ID`, `SHIPMENT_STATUS_ID`, `NEXT_SHIPMENT_STATUS_ID`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (14, 5, 7, 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');
INSERT INTO `fasp`.`ap_shipment_status_allowed` (`SHIPMENT_STATUS_ALLOWED_ID`, `SHIPMENT_STATUS_ID`, `NEXT_SHIPMENT_STATUS_ID`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (15, 6, 6, 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');
INSERT INTO `fasp`.`ap_shipment_status_allowed` (`SHIPMENT_STATUS_ALLOWED_ID`, `SHIPMENT_STATUS_ID`, `NEXT_SHIPMENT_STATUS_ID`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (16, 6, 7, 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');
INSERT INTO `fasp`.`ap_shipment_status_allowed` (`SHIPMENT_STATUS_ALLOWED_ID`, `SHIPMENT_STATUS_ID`, `NEXT_SHIPMENT_STATUS_ID`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (17, 7, 7, 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');

COMMIT;


-- -----------------------------------------------------
-- Data for table `fasp`.`rm_manufacturer`
-- -----------------------------------------------------
START TRANSACTION;
USE `fasp`;
INSERT INTO `fasp`.`rm_manufacturer` (`MANUFACTURER_ID`, `REALM_ID`, `LABEL_ID`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (1, 1, 112, 1, 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`rm_manufacturer` (`MANUFACTURER_ID`, `REALM_ID`, `LABEL_ID`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (2, 1, 113, 1, 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');

COMMIT;


-- -----------------------------------------------------
-- Data for table `fasp`.`rm_organisation_country`
-- -----------------------------------------------------
START TRANSACTION;
USE `fasp`;
INSERT INTO `fasp`.`rm_organisation_country` (`ORGANISATION_COUNTRY_ID`, `ORGANISATION_ID`, `REALM_COUNTRY_ID`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (1, 1, 1, 1, 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');
INSERT INTO `fasp`.`rm_organisation_country` (`ORGANISATION_COUNTRY_ID`, `ORGANISATION_ID`, `REALM_COUNTRY_ID`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (2, 2, 1, 1, 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');
INSERT INTO `fasp`.`rm_organisation_country` (`ORGANISATION_COUNTRY_ID`, `ORGANISATION_ID`, `REALM_COUNTRY_ID`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (3, 2, 2, 1, 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');

COMMIT;


-- -----------------------------------------------------
-- Data for table `fasp`.`rm_health_area_country`
-- -----------------------------------------------------
START TRANSACTION;
USE `fasp`;
INSERT INTO `fasp`.`rm_health_area_country` (`HEALTH_AREA_COUNTRY_ID`, `HEALTH_AREA_ID`, `REALM_COUNTRY_ID`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (1, 1, 1, 1, 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');
INSERT INTO `fasp`.`rm_health_area_country` (`HEALTH_AREA_COUNTRY_ID`, `HEALTH_AREA_ID`, `REALM_COUNTRY_ID`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (2, 3, 1, 1, 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');
INSERT INTO `fasp`.`rm_health_area_country` (`HEALTH_AREA_COUNTRY_ID`, `HEALTH_AREA_ID`, `REALM_COUNTRY_ID`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (3, 2, 2, 1, 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');

COMMIT;


-- -----------------------------------------------------
-- Data for table `fasp`.`rm_program_region`
-- -----------------------------------------------------
START TRANSACTION;
USE `fasp`;
INSERT INTO `fasp`.`rm_program_region` (`PROGRAM_REGION_ID`, `PROGRAM_ID`, `REGION_ID`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (1, 1, 1, 1, 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');

COMMIT;


-- -----------------------------------------------------
-- Data for table `fasp`.`rm_funding_source`
-- -----------------------------------------------------
START TRANSACTION;
USE `fasp`;
INSERT INTO `fasp`.`rm_funding_source` (`FUNDING_SOURCE_ID`, `REALM_ID`, `LABEL_ID`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (1, 1, 130, 1, 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`rm_funding_source` (`FUNDING_SOURCE_ID`, `REALM_ID`, `LABEL_ID`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (2, 1, 131, 1, 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`rm_funding_source` (`FUNDING_SOURCE_ID`, `REALM_ID`, `LABEL_ID`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (3, 1, 132, 1, 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`rm_funding_source` (`FUNDING_SOURCE_ID`, `REALM_ID`, `LABEL_ID`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (4, 1, 133, 1, 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');

COMMIT;


-- -----------------------------------------------------
-- Data for table `fasp`.`rm_sub_funding_source`
-- -----------------------------------------------------
START TRANSACTION;
USE `fasp`;
INSERT INTO `fasp`.`rm_sub_funding_source` (`SUB_FUNDING_SOURCE_ID`, `FUNDING_SOURCE_ID`, `LABEL_ID`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (1, 1, 140, 1, 1, '2020-03-02 10:00:00', 1, '2020-03-02 10:00:00');
INSERT INTO `fasp`.`rm_sub_funding_source` (`SUB_FUNDING_SOURCE_ID`, `FUNDING_SOURCE_ID`, `LABEL_ID`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (2, 2, 141, 1, 1, '2020-03-02 10:00:00', 1, '2020-03-02 10:00:00');
INSERT INTO `fasp`.`rm_sub_funding_source` (`SUB_FUNDING_SOURCE_ID`, `FUNDING_SOURCE_ID`, `LABEL_ID`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (3, 3, 142, 1, 1, '2020-03-02 10:00:00', 1, '2020-03-02 10:00:00');

COMMIT;


-- -----------------------------------------------------
-- Data for table `fasp`.`rm_budget`
-- -----------------------------------------------------
START TRANSACTION;
USE `fasp`;
INSERT INTO `fasp`.`rm_budget` (`BUDGET_ID`, `PROGRAM_ID`, `SUB_FUNDING_SOURCE_ID`, `LABEL_ID`, `BUDGET_AMT`, `START_DATE`, `STOP_DATE`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (1, 1, 1, 137, 450000, '2020-01-01', '2020-06-30', 1, 1, '2020-03-01 10:00:00', 1, '2020-03-01 10:00:00');
INSERT INTO `fasp`.`rm_budget` (`BUDGET_ID`, `PROGRAM_ID`, `SUB_FUNDING_SOURCE_ID`, `LABEL_ID`, `BUDGET_AMT`, `START_DATE`, `STOP_DATE`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (2, 2, 2, 138, 2500000, '2020-01-01', '2020-12-31', 1, 1, '2020-03-01 10:00:00', 1, '2020-03-01 10:00:00');
INSERT INTO `fasp`.`rm_budget` (`BUDGET_ID`, `PROGRAM_ID`, `SUB_FUNDING_SOURCE_ID`, `LABEL_ID`, `BUDGET_AMT`, `START_DATE`, `STOP_DATE`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (3, 3, 3, 139, 1000000, '2020-01-01', '2020-12-31', 1, 1, '2020-03-01 10:00:00', 1, '2020-03-01 10:00:00');

COMMIT;


-- -----------------------------------------------------
-- Data for table `fasp`.`rm_procurement_agent`
-- -----------------------------------------------------
START TRANSACTION;
USE `fasp`;
INSERT INTO `fasp`.`rm_procurement_agent` (`PROCUREMENT_AGENT_ID`, `REALM_ID`, `PROGRAM_ID`, `LABEL_ID`, `SUBMITTED_TO_APPROVED_LEAD_TIME`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (1, 1, 1, 109, 0, 1, 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`rm_procurement_agent` (`PROCUREMENT_AGENT_ID`, `REALM_ID`, `PROGRAM_ID`, `LABEL_ID`, `SUBMITTED_TO_APPROVED_LEAD_TIME`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (2, 1, 1, 110, 0, 1, 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`rm_procurement_agent` (`PROCUREMENT_AGENT_ID`, `REALM_ID`, `PROGRAM_ID`, `LABEL_ID`, `SUBMITTED_TO_APPROVED_LEAD_TIME`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (3, 1, 1, 111, 0, 1, 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');

COMMIT;


-- -----------------------------------------------------
-- Data for table `fasp`.`ap_unit_type`
-- -----------------------------------------------------
START TRANSACTION;
USE `fasp`;
INSERT INTO `fasp`.`ap_unit_type` (`UNIT_TYPE_ID`, `LABEL_ID`) VALUES (1, 6);
INSERT INTO `fasp`.`ap_unit_type` (`UNIT_TYPE_ID`, `LABEL_ID`) VALUES (2, 7);
INSERT INTO `fasp`.`ap_unit_type` (`UNIT_TYPE_ID`, `LABEL_ID`) VALUES (3, 8);
INSERT INTO `fasp`.`ap_unit_type` (`UNIT_TYPE_ID`, `LABEL_ID`) VALUES (4, 9);
INSERT INTO `fasp`.`ap_unit_type` (`UNIT_TYPE_ID`, `LABEL_ID`) VALUES (5, 10);

COMMIT;


-- -----------------------------------------------------
-- Data for table `fasp`.`ap_unit`
-- -----------------------------------------------------
START TRANSACTION;
USE `fasp`;
INSERT INTO `fasp`.`ap_unit` (`UNIT_ID`, `UNIT_TYPE_ID`, `LABEL_ID`, `UNIT_CODE`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (1, 1, 11, 'm', 1, 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');
INSERT INTO `fasp`.`ap_unit` (`UNIT_ID`, `UNIT_TYPE_ID`, `LABEL_ID`, `UNIT_CODE`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (2, 1, 12, 'cm', 1, 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');
INSERT INTO `fasp`.`ap_unit` (`UNIT_ID`, `UNIT_TYPE_ID`, `LABEL_ID`, `UNIT_CODE`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (3, 1, 13, 'mm', 1, 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');
INSERT INTO `fasp`.`ap_unit` (`UNIT_ID`, `UNIT_TYPE_ID`, `LABEL_ID`, `UNIT_CODE`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (4, 1, 14, 'ft', 1, 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');
INSERT INTO `fasp`.`ap_unit` (`UNIT_ID`, `UNIT_TYPE_ID`, `LABEL_ID`, `UNIT_CODE`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (5, 1, 15, 'in', 1, 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00');
INSERT INTO `fasp`.`ap_unit` (`UNIT_ID`, `UNIT_TYPE_ID`, `LABEL_ID`, `UNIT_CODE`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (6, 2, 70, 'kg', 1, 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_unit` (`UNIT_ID`, `UNIT_TYPE_ID`, `LABEL_ID`, `UNIT_CODE`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (7, 2, 71, 'gm', 1, 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_unit` (`UNIT_ID`, `UNIT_TYPE_ID`, `LABEL_ID`, `UNIT_CODE`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (8, 2, 72, 'lbs', 1, 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_unit` (`UNIT_ID`, `UNIT_TYPE_ID`, `LABEL_ID`, `UNIT_CODE`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (9, 2, 73, 'oz', 1, 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_unit` (`UNIT_ID`, `UNIT_TYPE_ID`, `LABEL_ID`, `UNIT_CODE`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (10, 2, 74, 'ton', 1, 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_unit` (`UNIT_ID`, `UNIT_TYPE_ID`, `LABEL_ID`, `UNIT_CODE`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (11, 3, 75, 'sq ft', 1, 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_unit` (`UNIT_ID`, `UNIT_TYPE_ID`, `LABEL_ID`, `UNIT_CODE`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (12, 3, 76, 'sq m', 1, 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_unit` (`UNIT_ID`, `UNIT_TYPE_ID`, `LABEL_ID`, `UNIT_CODE`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (13, 4, 77, 'lt', 1, 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_unit` (`UNIT_ID`, `UNIT_TYPE_ID`, `LABEL_ID`, `UNIT_CODE`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (14, 4, 78, 'us gal', 1, 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_unit` (`UNIT_ID`, `UNIT_TYPE_ID`, `LABEL_ID`, `UNIT_CODE`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (15, 4, 79, 'ml', 1, 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_unit` (`UNIT_ID`, `UNIT_TYPE_ID`, `LABEL_ID`, `UNIT_CODE`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (16, 5, 80, 'peice', 1, 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_unit` (`UNIT_ID`, `UNIT_TYPE_ID`, `LABEL_ID`, `UNIT_CODE`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (17, 5, 81, 'item', 1, 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_unit` (`UNIT_ID`, `UNIT_TYPE_ID`, `LABEL_ID`, `UNIT_CODE`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (18, 5, 82, 'each', 1, 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_unit` (`UNIT_ID`, `UNIT_TYPE_ID`, `LABEL_ID`, `UNIT_CODE`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (19, 5, 83, 'box', 1, 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_unit` (`UNIT_ID`, `UNIT_TYPE_ID`, `LABEL_ID`, `UNIT_CODE`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (20, 5, 84, 'case', 1, 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_unit` (`UNIT_ID`, `UNIT_TYPE_ID`, `LABEL_ID`, `UNIT_CODE`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (21, 5, 85, 'Euro 1 Pallet', 1, 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_unit` (`UNIT_ID`, `UNIT_TYPE_ID`, `LABEL_ID`, `UNIT_CODE`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (22, 5, 86, 'Euro 2 Pallet', 1, 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_unit` (`UNIT_ID`, `UNIT_TYPE_ID`, `LABEL_ID`, `UNIT_CODE`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (23, 5, 87, '40ft Container', 1, 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_unit` (`UNIT_ID`, `UNIT_TYPE_ID`, `LABEL_ID`, `UNIT_CODE`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (24, 5, 88, '20ft Container', 1, 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_unit` (`UNIT_ID`, `UNIT_TYPE_ID`, `LABEL_ID`, `UNIT_CODE`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (25, 5, 89, 'Tablet', 1, 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_unit` (`UNIT_ID`, `UNIT_TYPE_ID`, `LABEL_ID`, `UNIT_CODE`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (26, 5, 90, 'bottle', 1, 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_unit` (`UNIT_ID`, `UNIT_TYPE_ID`, `LABEL_ID`, `UNIT_CODE`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (27, 5, 91, 'bubble strip', 1, 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_unit` (`UNIT_ID`, `UNIT_TYPE_ID`, `LABEL_ID`, `UNIT_CODE`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (28, 5, 92, 'Pack', 1, 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`ap_unit` (`UNIT_ID`, `UNIT_TYPE_ID`, `LABEL_ID`, `UNIT_CODE`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (29, 5, 108, 'pallet', 1, 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');

COMMIT;


-- -----------------------------------------------------
-- Data for table `fasp`.`rm_product`
-- -----------------------------------------------------
START TRANSACTION;
USE `fasp`;
INSERT INTO `fasp`.`rm_product` (`PRODUCT_ID`, `REALM_ID`, `PRODUCT_CATEGORY_ID`, `GENERIC_LABEL_ID`, `LABEL_ID`, `FORECASTING_UNIT_ID`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (1, 1, 3, 65, 65, 18, 1, 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`rm_product` (`PRODUCT_ID`, `REALM_ID`, `PRODUCT_CATEGORY_ID`, `GENERIC_LABEL_ID`, `LABEL_ID`, `FORECASTING_UNIT_ID`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (2, 1, 15, 66, 66, 25, 1, 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`rm_product` (`PRODUCT_ID`, `REALM_ID`, `PRODUCT_CATEGORY_ID`, `GENERIC_LABEL_ID`, `LABEL_ID`, `FORECASTING_UNIT_ID`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (3, 1, 3, 67, 67, 18, 1, 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`rm_product` (`PRODUCT_ID`, `REALM_ID`, `PRODUCT_CATEGORY_ID`, `GENERIC_LABEL_ID`, `LABEL_ID`, `FORECASTING_UNIT_ID`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (4, 1, 3, 68, 68, 18, 1, 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`rm_product` (`PRODUCT_ID`, `REALM_ID`, `PRODUCT_CATEGORY_ID`, `GENERIC_LABEL_ID`, `LABEL_ID`, `FORECASTING_UNIT_ID`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (5, 1, 16, 69, 69, 25, 1, 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');

COMMIT;


-- -----------------------------------------------------
-- Data for table `fasp`.`rm_planning_unit`
-- -----------------------------------------------------
START TRANSACTION;
USE `fasp`;
INSERT INTO `fasp`.`rm_planning_unit` (`PLANNING_UNIT_ID`, `PRODUCT_ID`, `LABEL_ID`, `UNIT_ID`, `QTY_OF_FORECASTING_UNITS`, `PRICE`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (1, 4, 93, 92, 6, 0, 1, 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`rm_planning_unit` (`PLANNING_UNIT_ID`, `PRODUCT_ID`, `LABEL_ID`, `UNIT_ID`, `QTY_OF_FORECASTING_UNITS`, `PRICE`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (2, 2, 94, 92, 6, 0, 1, 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`rm_planning_unit` (`PLANNING_UNIT_ID`, `PRODUCT_ID`, `LABEL_ID`, `UNIT_ID`, `QTY_OF_FORECASTING_UNITS`, `PRICE`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (3, 2, 95, 92, 5, 0, 1, 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`rm_planning_unit` (`PLANNING_UNIT_ID`, `PRODUCT_ID`, `LABEL_ID`, `UNIT_ID`, `QTY_OF_FORECASTING_UNITS`, `PRICE`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (4, 4, 96, 90, 60, 0, 1, 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`rm_planning_unit` (`PLANNING_UNIT_ID`, `PRODUCT_ID`, `LABEL_ID`, `UNIT_ID`, `QTY_OF_FORECASTING_UNITS`, `PRICE`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (5, 4, 97, 91, 12, 0, 1, 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`rm_planning_unit` (`PLANNING_UNIT_ID`, `PRODUCT_ID`, `LABEL_ID`, `UNIT_ID`, `QTY_OF_FORECASTING_UNITS`, `PRICE`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (6, 5, 98, 90, 90, 0, 1, 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`rm_planning_unit` (`PLANNING_UNIT_ID`, `PRODUCT_ID`, `LABEL_ID`, `UNIT_ID`, `QTY_OF_FORECASTING_UNITS`, `PRICE`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (7, 5, 99, 90, 30, 0, 1, 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');

COMMIT;


-- -----------------------------------------------------
-- Data for table `fasp`.`rm_logistics_unit`
-- -----------------------------------------------------
START TRANSACTION;
USE `fasp`;
INSERT INTO `fasp`.`rm_logistics_unit` (`LOGISTICS_UNIT_ID`, `PLANNING_UNIT_ID`, `LABEL_ID`, `UNIT_ID`, `QTY_OF_PLANNING_UNITS`, `VARIANT`, `MANUFACTURER_ID`, `WIDTH_UNIT_ID`, `WIDTH_QTY`, `HEIGHT_UNIT_ID`, `HEIGHT_QTY`, `LENGTH_UNIT_ID`, `LENGTH_QTY`, `WEIGHT_UNIT_ID`, `WEIGHT_QTY`, `QTY_IN_EURO1`, `QTY_IN_EURO2`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (1, 6, 100, 26, 1, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`rm_logistics_unit` (`LOGISTICS_UNIT_ID`, `PLANNING_UNIT_ID`, `LABEL_ID`, `UNIT_ID`, `QTY_OF_PLANNING_UNITS`, `VARIANT`, `MANUFACTURER_ID`, `WIDTH_UNIT_ID`, `WIDTH_QTY`, `HEIGHT_UNIT_ID`, `HEIGHT_QTY`, `LENGTH_UNIT_ID`, `LENGTH_QTY`, `WEIGHT_UNIT_ID`, `WEIGHT_QTY`, `QTY_IN_EURO1`, `QTY_IN_EURO2`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (2, 6, 101, 20, 1, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`rm_logistics_unit` (`LOGISTICS_UNIT_ID`, `PLANNING_UNIT_ID`, `LABEL_ID`, `UNIT_ID`, `QTY_OF_PLANNING_UNITS`, `VARIANT`, `MANUFACTURER_ID`, `WIDTH_UNIT_ID`, `WIDTH_QTY`, `HEIGHT_UNIT_ID`, `HEIGHT_QTY`, `LENGTH_UNIT_ID`, `LENGTH_QTY`, `WEIGHT_UNIT_ID`, `WEIGHT_QTY`, `QTY_IN_EURO1`, `QTY_IN_EURO2`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (3, 6, 102, 29, 1, NULL, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`rm_logistics_unit` (`LOGISTICS_UNIT_ID`, `PLANNING_UNIT_ID`, `LABEL_ID`, `UNIT_ID`, `QTY_OF_PLANNING_UNITS`, `VARIANT`, `MANUFACTURER_ID`, `WIDTH_UNIT_ID`, `WIDTH_QTY`, `HEIGHT_UNIT_ID`, `HEIGHT_QTY`, `LENGTH_UNIT_ID`, `LENGTH_QTY`, `WEIGHT_UNIT_ID`, `WEIGHT_QTY`, `QTY_IN_EURO1`, `QTY_IN_EURO2`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (4, 2, 103, 20, 1, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`rm_logistics_unit` (`LOGISTICS_UNIT_ID`, `PLANNING_UNIT_ID`, `LABEL_ID`, `UNIT_ID`, `QTY_OF_PLANNING_UNITS`, `VARIANT`, `MANUFACTURER_ID`, `WIDTH_UNIT_ID`, `WIDTH_QTY`, `HEIGHT_UNIT_ID`, `HEIGHT_QTY`, `LENGTH_UNIT_ID`, `LENGTH_QTY`, `WEIGHT_UNIT_ID`, `WEIGHT_QTY`, `QTY_IN_EURO1`, `QTY_IN_EURO2`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (5, 2, 104, 21, 1, NULL, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`rm_logistics_unit` (`LOGISTICS_UNIT_ID`, `PLANNING_UNIT_ID`, `LABEL_ID`, `UNIT_ID`, `QTY_OF_PLANNING_UNITS`, `VARIANT`, `MANUFACTURER_ID`, `WIDTH_UNIT_ID`, `WIDTH_QTY`, `HEIGHT_UNIT_ID`, `HEIGHT_QTY`, `LENGTH_UNIT_ID`, `LENGTH_QTY`, `WEIGHT_UNIT_ID`, `WEIGHT_QTY`, `QTY_IN_EURO1`, `QTY_IN_EURO2`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (6, 5, 105, 28, 1, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`rm_logistics_unit` (`LOGISTICS_UNIT_ID`, `PLANNING_UNIT_ID`, `LABEL_ID`, `UNIT_ID`, `QTY_OF_PLANNING_UNITS`, `VARIANT`, `MANUFACTURER_ID`, `WIDTH_UNIT_ID`, `WIDTH_QTY`, `HEIGHT_UNIT_ID`, `HEIGHT_QTY`, `LENGTH_UNIT_ID`, `LENGTH_QTY`, `WEIGHT_UNIT_ID`, `WEIGHT_QTY`, `QTY_IN_EURO1`, `QTY_IN_EURO2`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (7, 4, 106, 20, 1, NULL, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`rm_logistics_unit` (`LOGISTICS_UNIT_ID`, `PLANNING_UNIT_ID`, `LABEL_ID`, `UNIT_ID`, `QTY_OF_PLANNING_UNITS`, `VARIANT`, `MANUFACTURER_ID`, `WIDTH_UNIT_ID`, `WIDTH_QTY`, `HEIGHT_UNIT_ID`, `HEIGHT_QTY`, `LENGTH_UNIT_ID`, `LENGTH_QTY`, `WEIGHT_UNIT_ID`, `WEIGHT_QTY`, `QTY_IN_EURO1`, `QTY_IN_EURO2`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (8, 3, 107, 20, 1, NULL, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');

COMMIT;


-- -----------------------------------------------------
-- Data for table `fasp`.`rm_procurement_agent_logistics_unit`
-- -----------------------------------------------------
START TRANSACTION;
USE `fasp`;
INSERT INTO `fasp`.`rm_procurement_agent_logistics_unit` (`PROCUREMENT_AGENT_SKU_ID`, `PROCUREMENT_AGENT_ID`, `SKU_CODE`, `LOGISTICS_UNIT_ID`, `PRICE`, `APPROVED_TO_SHIPPED_LEAD_TIME`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (1, 1, 'ARTMIS 15 code', 1, 2.35, 0, 1, 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`rm_procurement_agent_logistics_unit` (`PROCUREMENT_AGENT_SKU_ID`, `PROCUREMENT_AGENT_ID`, `SKU_CODE`, `LOGISTICS_UNIT_ID`, `PRICE`, `APPROVED_TO_SHIPPED_LEAD_TIME`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (2, 1, 'ARTMIS 15 code', 2, 2.13, 0, 1, 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`rm_procurement_agent_logistics_unit` (`PROCUREMENT_AGENT_SKU_ID`, `PROCUREMENT_AGENT_ID`, `SKU_CODE`, `LOGISTICS_UNIT_ID`, `PRICE`, `APPROVED_TO_SHIPPED_LEAD_TIME`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (3, 1, 'ARTMIS 15 code', 3, 2.13, 0, 1, 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`rm_procurement_agent_logistics_unit` (`PROCUREMENT_AGENT_SKU_ID`, `PROCUREMENT_AGENT_ID`, `SKU_CODE`, `LOGISTICS_UNIT_ID`, `PRICE`, `APPROVED_TO_SHIPPED_LEAD_TIME`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (4, 2, 'G1021', 1, 2.38, 0, 1, 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`rm_procurement_agent_logistics_unit` (`PROCUREMENT_AGENT_SKU_ID`, `PROCUREMENT_AGENT_ID`, `SKU_CODE`, `LOGISTICS_UNIT_ID`, `PRICE`, `APPROVED_TO_SHIPPED_LEAD_TIME`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (5, 2, 'G1022', 2, 3.12, 0, 1, 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`rm_procurement_agent_logistics_unit` (`PROCUREMENT_AGENT_SKU_ID`, `PROCUREMENT_AGENT_ID`, `SKU_CODE`, `LOGISTICS_UNIT_ID`, `PRICE`, `APPROVED_TO_SHIPPED_LEAD_TIME`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (6, 2, 'G1023', 3, 97.2, 0, 1, 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`rm_procurement_agent_logistics_unit` (`PROCUREMENT_AGENT_SKU_ID`, `PROCUREMENT_AGENT_ID`, `SKU_CODE`, `LOGISTICS_UNIT_ID`, `PRICE`, `APPROVED_TO_SHIPPED_LEAD_TIME`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (7, 3, 'C1021G5011F1', 1, 0.00, 0, 1, 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');

COMMIT;


-- -----------------------------------------------------
-- Data for table `fasp`.`rm_country_logistics_unit`
-- -----------------------------------------------------
START TRANSACTION;
USE `fasp`;
INSERT INTO `fasp`.`rm_country_logistics_unit` (`COUNTRY_SKU_ID`, `REALM_COUNTRY_ID`, `SKU_CODE`, `LOGISTICS_UNIT_ID`, `PLANNING_UNIT_ID`, `PACK_SIZE`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (1, 2, 'MACON0003', NULL, NULL, NULL, 1, 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`rm_country_logistics_unit` (`COUNTRY_SKU_ID`, `REALM_COUNTRY_ID`, `SKU_CODE`, `LOGISTICS_UNIT_ID`, `PLANNING_UNIT_ID`, `PACK_SIZE`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (2, 2, 'MACON0102', NULL, 1, 50, 1, 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`rm_country_logistics_unit` (`COUNTRY_SKU_ID`, `REALM_COUNTRY_ID`, `SKU_CODE`, `LOGISTICS_UNIT_ID`, `PLANNING_UNIT_ID`, `PACK_SIZE`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (3, 1, 'KYABCD01', 1, NULL, NULL, 1, 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`rm_country_logistics_unit` (`COUNTRY_SKU_ID`, `REALM_COUNTRY_ID`, `SKU_CODE`, `LOGISTICS_UNIT_ID`, `PLANNING_UNIT_ID`, `PACK_SIZE`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (4, 1, 'KYXYZ01', 2, NULL, NULL, 1, 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');

COMMIT;


-- -----------------------------------------------------
-- Data for table `fasp`.`rm_logistics_unit_gtin`
-- -----------------------------------------------------
START TRANSACTION;
USE `fasp`;
INSERT INTO `fasp`.`rm_logistics_unit_gtin` (`LOGISTICS_UNIT_GTIN_ID`, `LOGISTICS_UNIT_ID`, `GTIN`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (1, 1, 'GT101020K01211', 1, 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`rm_logistics_unit_gtin` (`LOGISTICS_UNIT_GTIN_ID`, `LOGISTICS_UNIT_ID`, `GTIN`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (2, 2, 'GT101020M01211', 1, 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');
INSERT INTO `fasp`.`rm_logistics_unit_gtin` (`LOGISTICS_UNIT_GTIN_ID`, `LOGISTICS_UNIT_ID`, `GTIN`, `ACTIVE`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`) VALUES (3, 3, 'GT101020P01212', 1, 1, '2020-02-25 12:00:00', 1, '2020-02-25 12:00:00');

COMMIT;


-- -----------------------------------------------------
-- Data for table `fasp`.`em_email_template`
-- -----------------------------------------------------
START TRANSACTION;
USE `fasp`;
INSERT INTO `fasp`.`em_email_template` (`EMAIL_TEMPLATE_ID`, `EMAIL_DESC`, `SUBJECT`, `SUBJECT_PARAM`, `EMAIL_BODY`, `EMAIL_BODY_PARAM`, `CC_TO`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`, `ACTIVE`, `TO_SEND`, `BCC`) VALUES (1, 'Password reset link(Forgot password)', 'Your FASP password', NULL, 'Dear Sir/Mam,<br/>\r\nGreetings From FASP.<br/>\r\nWe received a request to reset the password for your account.<br/>\r\nPlease find below a temporary link that you can use to reset your password.<br/>\r\n<br/>\r\n<a href=\"<%HOST_URL%>/<%PASSWORD_RESET_URL%>?username=<%USERNAME%>&token=<%TOKEN%>0\">Reset password link</a></br><br/>\n\r\n<br/>FASP Team<br/>', 'HOST_URL,PASSWORD_RESET_URL,USERNAME,TOKEN', NULL, 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00', 1, NULL, NULL);
INSERT INTO `fasp`.`em_email_template` (`EMAIL_TEMPLATE_ID`, `EMAIL_DESC`, `SUBJECT`, `SUBJECT_PARAM`, `EMAIL_BODY`, `EMAIL_BODY_PARAM`, `CC_TO`, `CREATED_BY`, `CREATED_DATE`, `LAST_MODIFIED_BY`, `LAST_MODIFIED_DATE`, `ACTIVE`, `TO_SEND`, `BCC`) VALUES (2, 'New user creation', 'FASP login credentials', NULL, 'Dear Sir/Mam,<br/>\r\nGreetings From FASP.<br/>\r\nYour new fasp account has been created.<br/>\r\nPlease find below a temporary link that you can use to reset your password.<br/>\r\n<br/>\n<a href=\"<%HOST_URL%>/<%PASSWORD_RESET_URL%>?username=<%USERNAME%>&token=<%TOKEN%>0\">Reset password link</a></br><br/>\r\nYou can login using below Credentials: <br/>\r\n<b>Username=<%USERNAME%></b><br/><br/>\r\n\r\n<br/>FASP Team<br/>', 'HOST_URL,PASSWORD_RESET_URL,USERNAME,TOKEN', NULL, 1, '2020-02-20 12:00:00', 1, '2020-02-20 12:00:00', 1, NULL, NULL);

COMMIT;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
