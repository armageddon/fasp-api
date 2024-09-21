-- #########################################################################################################
-- One time run
-- #########################################################################################################
ALTER TABLE `fasp`.`us_user_acl` ADD COLUMN `ROLE_ID` VARCHAR(50) NULL AFTER `USER_ID`;

INSERT INTO ap_label VALUES (null, 'View Master Data', null, null, null, 1, now(), 1, now(), 24);
INSERT INTO us_business_function VALUES ('ROLE_BF_LIST_MASTER_DATA', LAST_INSERT_ID(), 1, now(), 1, now());
INSERT INTO us_role_business_function VALUES 
    (null, 'ROLE_APPLICATION_ADMIN', 'ROLE_BF_LIST_MASTER_DATA', 1, now(), 1, now()),
    (null, 'ROLE_INTERNAL_USER', 'ROLE_BF_LIST_MASTER_DATA', 1, now(), 1, now()),
    (null, 'ROLE_REALM_ADMIN', 'ROLE_BF_LIST_MASTER_DATA', 1, now(), 1, now()),
    (null, 'ROLE_TRAINER_ADMIN', 'ROLE_BF_LIST_MASTER_DATA', 1, now(), 1, now()),
    (null, 'ROLE_PROGRAM_ADMIN', 'ROLE_BF_LIST_MASTER_DATA', 1, now(), 1, now()),
    (null, 'ROLE_PROGRAM_USER', 'ROLE_BF_LIST_MASTER_DATA', 1, now(), 1, now()),
    (null, 'ROLE_VIEW_DATA_ENTRY', 'ROLE_BF_LIST_MASTER_DATA', 1, now(), 1, now()),
    (null, 'ROLE_REPORT_USER', 'ROLE_BF_LIST_MASTER_DATA', 1, now(), 1, now()),
    (null, 'ROLE_DATASET_ADMIN', 'ROLE_BF_LIST_MASTER_DATA', 1, now(), 1, now()),
    (null, 'ROLE_DATASET_USER', 'ROLE_BF_LIST_MASTER_DATA', 1, now(), 1, now()),
    (null, 'ROLE_FORECAST_VIEWER', 'ROLE_BF_LIST_MASTER_DATA', 1, now(), 1, now()),
    (null, 'ROLE_GUEST_USER', 'ROLE_BF_LIST_MASTER_DATA', 1, now(), 1, now());

-- #########################################################################################################

-- DROP TABLE IF EXISTS `fasp`.`temp_security`;
-- CREATE TABLE `fasp`.`temp_security` (
--   `SECURITY_ID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
--   `METHOD` VARCHAR(45) NULL,
--   `URL_LIST` TEXT NOT NULL,
--   `BF_LIST` TEXT NOT NULL,
--   PRIMARY KEY (`SECURITY_ID`));
DROP TABLE IF EXISTS `fasp`.`ap_security`;
CREATE TABLE `fasp`.`ap_security` (
  `SECURITY_ID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `METHOD` VARCHAR(45) NULL,
  `URL` VARCHAR(255) NOT NULL,
  `BF` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`SECURITY_ID`));

-- ALTER TABLE `fasp`.`temp_security` CHANGE COLUMN `METHOD` `METHOD` INT NOT NULL ;
ALTER TABLE `fasp`.`ap_security` CHANGE COLUMN `METHOD` `METHOD` INT NOT NULL ;

ALTER TABLE `fasp`.`ap_security` ADD UNIQUE INDEX `index2` (`METHOD` ASC, `URL` ASC, `BF` ASC) VISIBLE;
ALTER TABLE `fasp`.`ap_security` CHANGE COLUMN `BF` `BF` VARCHAR(50) NOT NULL ;



TRUNCATE TABLE ap_security;

INSERT IGNORE INTO ap_security VALUES (null, 2, '/api/budget', 'ROLE_BF_ADD_BUDGET');
INSERT IGNORE INTO ap_security VALUES (null, 3, '/api/budget', 'ROLE_BF_EDIT_BUDGET');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/budget', 'ROLE_BF_LIST_BUDGET');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/budget/*', 'ROLE_BF_LIST_BUDGET');
INSERT IGNORE INTO ap_security VALUES (null, 2, '/api/budget/programIds', 'ROLE_BF_LIST_BUDGET');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/budget/realmId/*', 'ROLE_BF_LIST_BUDGET');

INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/country', 'ROLE_BF_LIST_COUNTRY');
INSERT IGNORE INTO ap_security VALUES (null, 2, '/api/country', 'ROLE_BF_ADD_COUNTRY');
INSERT IGNORE INTO ap_security VALUES (null, 3, '/api/country', 'ROLE_BF_EDIT_COUNTRY');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/country/*', 'ROLE_BF_LIST_COUNTRY');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/country/*', 'ROLE_BF_LIST_COUNTRY');

INSERT IGNORE INTO ap_security VALUES (null, 2, '/api/currency', 'ROLE_BF_ADD_CURRENCY');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/currency', 'ROLE_BF_LIST_CURRENCY');
INSERT IGNORE INTO ap_security VALUES (null, 3, '/api/currency', 'ROLE_BF_EDIT_CURRENCY');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/currency/*', 'ROLE_BF_LIST_CURRENCY');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/currency/*', 'ROLE_BF_LIST_CURRENCY');

INSERT IGNORE INTO ap_security VALUES (null, 2, '/api/dataSource', 'ROLE_BF_ADD_DATA_SOURCE');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/dataSource', 'ROLE_BF_LIST_DATA_SOURCE');
INSERT IGNORE INTO ap_security VALUES (null, 3, '/api/dataSource', 'ROLE_BF_EDIT_DATA_SOURCE');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/dataSource/**', 'ROLE_BF_LIST_DATA_SOURCE');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/dataSource/**', 'ROLE_BF_LIST_DATA_SOURCE');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/dataSource/**', 'ROLE_BF_LIST_DATA_SOURCE');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/dataSource/**', 'ROLE_BF_LIST_DATA_SOURCE');

INSERT IGNORE INTO ap_security VALUES (null, 2, '/api/dataSourceType', 'ROLE_BF_ADD_DATA_SOURCE_TYPE');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/dataSourceType', 'ROLE_BF_LIST_DATA_SOURCE_TYPE');
INSERT IGNORE INTO ap_security VALUES (null, 3, '/api/dataSourceType', 'ROLE_BF_EDIT_DATA_SOURCE_TYPE');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/dataSourceType/**', 'ROLE_BF_LIST_DATA_SOURCE_TYPE');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/dataSourceType/**', 'ROLE_BF_LIST_DATA_SOURCE_TYPE');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/dataSourceType/**', 'ROLE_BF_LIST_DATA_SOURCE_TYPE');

INSERT IGNORE INTO ap_security VALUES (null, 2, '/api/dimension', 'ROLE_BF_ADD_DIMENSION');
INSERT IGNORE INTO ap_security VALUES (null, 3, '/api/dimension', 'ROLE_BF_EDIT_DIMENSION');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/dimension', 'ROLE_BF_LIST_DIMENSION');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/dimension/*', 'ROLE_BF_LIST_DIMENSION');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/dimension/*', 'ROLE_BF_LIST_DIMENSION');

INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/master/*', 'ROLE_BF_LIST_MASTER_DATA');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/master/*', 'ROLE_BF_LIST_MASTER_DATA');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/master/*', 'ROLE_BF_LIST_MASTER_DATA');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/master/*', 'ROLE_BF_LIST_MASTER_DATA');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/master/*', 'ROLE_BF_LIST_MASTER_DATA');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/master/*', 'ROLE_BF_LIST_MASTER_DATA');

INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/program/supplyPlan/list', 'ROLE_BF_LIST_PROGRAM');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/program/dataset/list', 'ROLE_BF_LIST_DATASET');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/user/details', '');

INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/forecastMethod', 'ROLE_BF_LIST_FORECAST_METHOD');
INSERT IGNORE INTO ap_security VALUES (null, 2, '/api/forecastMethod', 'ROLE_BF_ADD_FORECAST_METHOD');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/forecastMethod/*', 'ROLE_BF_LIST_FORECAST_METHOD');

INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/modelingType', 'ROLE_BF_LIST_MODELING_TYPE');
INSERT IGNORE INTO ap_security VALUES (null, 2, '/api/modelingType', 'ROLE_BF_ADD_MODELING_TYPE');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/modelingType/*', 'ROLE_BF_LIST_MODELING_TYPE');

INSERT INTO us_role_business_function VALUES (null, 'ROLE_INTERNAL_USER', 'ROLE_BF_ADD_MODELING_TYPE', 1, now(), 1, now()), (null, 'ROLE_REALM_ADMIN', 'ROLE_BF_ADD_MODELING_TYPE', 1, now(), 1, now());

INSERT IGNORE INTO ap_security VALUES (null, 2, '/api/problemReport/createManualProblem', 'ROLE_BF_SUPPLY_PLAN_VERSION_AND_REVIEW');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/problemStatus', 'ROLE_BF_SUPPLY_PLAN_VERSION_AND_REVIEW');

INSERT IGNORE INTO ap_security VALUES (null, 2, '/api/supplier', 'ROLE_BF_ADD_SUPPLIER');
INSERT IGNORE INTO ap_security VALUES (null, 3, '/api/supplier', 'ROLE_BF_EDIT_SUPPLIER');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/supplier', 'ROLE_BF_LIST_SUPPLIER');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/supplier/**', 'ROLE_BF_LIST_SUPPLIER');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/supplier/**', 'ROLE_BF_LIST_SUPPLIER');

INSERT IGNORE INTO ap_security VALUES (null, 2, '/api/unit', 'ROLE_BF_ADD_UNIT');
INSERT IGNORE INTO ap_security VALUES (null, 3, '/api/unit', 'ROLE_BF_EDIT_UNIT');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/unit', 'ROLE_BF_LIST_UNIT');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/unit/**', 'ROLE_BF_LIST_UNIT');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/unit/**', 'ROLE_BF_LIST_UNIT');

INSERT IGNORE INTO ap_security VALUES (null, 2, '/api/fundingSource', 'ROLE_BF_ADD_FUNDING_SOURCE');
INSERT IGNORE INTO ap_security VALUES (null, 3, '/api/fundingSource', 'ROLE_BF_EDIT_FUNDING_SOURCE');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/fundingSource', 'ROLE_BF_LIST_FUNDING_SOURCE');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/fundingSource/**', 'ROLE_BF_LIST_FUNDING_SOURCE');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/fundingSource/**', 'ROLE_BF_LIST_FUNDING_SOURCE');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/fundingSource/**', 'ROLE_BF_LIST_FUNDING_SOURCE');
INSERT IGNORE INTO ap_security VALUES (null, 2, '/api/fundingSourceType', 'ROLE_BF_ADD_FUNDING_SOURCE');
INSERT IGNORE INTO ap_security VALUES (null, 3, '/api/fundingSourceType', 'ROLE_BF_EDIT_FUNDING_SOURCE');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/fundingSourceType', 'ROLE_BF_LIST_FUNDING_SOURCE');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/fundingSourceType/**', 'ROLE_BF_LIST_FUNDING_SOURCE');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/fundingSourceType/**', 'ROLE_BF_LIST_FUNDING_SOURCE');

INSERT IGNORE INTO ap_security VALUES (null, 2, '/api/healthArea', 'ROLE_BF_ADD_HEALTH_AREA');
INSERT IGNORE INTO ap_security VALUES (null, 3, '/api/healthArea', 'ROLE_BF_EDIT_HEALTH_AREA');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/healthArea', 'ROLE_BF_LIST_HEALTH_AREA');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/healthArea/**', 'ROLE_BF_LIST_HEALTH_AREA');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/healthArea/**', 'ROLE_BF_LIST_HEALTH_AREA');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/healthArea/**', 'ROLE_BF_LIST_HEALTH_AREA');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/healthArea/**', 'ROLE_BF_LIST_HEALTH_AREA');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/healthArea/**', 'ROLE_BF_LIST_HEALTH_AREA');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/healthArea/**', 'ROLE_BF_LIST_HEALTH_AREA');

INSERT IGNORE INTO ap_security VALUES (null, 2, '/api/organisation', 'ROLE_BF_ADD_ORGANIZATION');
INSERT IGNORE INTO ap_security VALUES (null, 3, '/api/organisation', 'ROLE_BF_EDIT_ORGANIZATION');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/organisation', 'ROLE_BF_LIST_ORGANIZATION');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/organisation/**', 'ROLE_BF_LIST_ORGANIZATION');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/organisation/**', 'ROLE_BF_LIST_ORGANIZATION');
INSERT IGNORE INTO ap_security VALUES (null, 2, '/api/organisationType', 'ROLE_BF_ADD_ORGANIZATION_TYPE');
INSERT IGNORE INTO ap_security VALUES (null, 3, '/api/organisationType', 'ROLE_BF_EDIT_ORGANIZATION_TYPE');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/organisationType', 'ROLE_BF_LIST_ORGANIZATION_TYPE');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/organisationType/**', 'ROLE_BF_LIST_ORGANIZATION_TYPE');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/organisationType/**', 'ROLE_BF_LIST_ORGANIZATION_TYPE');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/organisationType/**', 'ROLE_BF_LIST_ORGANIZATION_TYPE');

INSERT IGNORE INTO ap_security VALUES (null, 2, '/api/procurementAgentType', 'ROLE_BF_ADD_PROCUREMENT_AGENT');
INSERT IGNORE INTO ap_security VALUES (null, 3, '/api/procurementAgentType', 'ROLE_BF_EDIT_PROCUREMENT_AGENT');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/procurementAgentType', 'ROLE_BF_LIST_PROCUREMENT_AGENT');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/procurementAgentType/**', 'ROLE_BF_LIST_PROCUREMENT_AGENT');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/procurementAgentType/**', 'ROLE_BF_LIST_PROCUREMENT_AGENT');

INSERT IGNORE INTO ap_security VALUES (null, 2, '/api/procurementAgent', 'ROLE_BF_ADD_PROCUREMENT_AGENT');
INSERT IGNORE INTO ap_security VALUES (null, 3, '/api/procurementAgent', 'ROLE_BF_EDIT_PROCUREMENT_AGENT');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/procurementAgent', 'ROLE_BF_LIST_PROCUREMENT_AGENT');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/procurementAgent/**', 'ROLE_BF_LIST_PROCUREMENT_AGENT');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/procurementAgent/**', 'ROLE_BF_LIST_PROCUREMENT_AGENT');
INSERT IGNORE INTO ap_security VALUES (null, 3, '/api/procurementAgent/**', 'ROLE_BF_LIST_PROCUREMENT_AGENT');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/procurementAgent/**', 'ROLE_BF_LIST_PROCUREMENT_AGENT');
INSERT IGNORE INTO ap_security VALUES (null, 2, '/api/procurementAgent/**', 'ROLE_BF_LIST_PROCUREMENT_AGENT');
INSERT IGNORE INTO ap_security VALUES (null, 3, '/api/procurementAgent/**', 'ROLE_BF_LIST_PROCUREMENT_AGENT');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/procurementAgent/**', 'ROLE_BF_LIST_PROCUREMENT_AGENT');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/procurementAgent/**', 'ROLE_BF_LIST_PROCUREMENT_AGENT');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/procurementAgent/**', 'ROLE_BF_LIST_PROCUREMENT_AGENT');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/procurementAgent/**', 'ROLE_BF_LIST_PROCUREMENT_AGENT');
INSERT IGNORE INTO ap_security VALUES (null, 3, '/api/procurementAgent/**', 'ROLE_BF_LIST_PROCUREMENT_AGENT');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/procurementAgent/**', 'ROLE_BF_LIST_PROCUREMENT_AGENT');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/procurementAgent/**', 'ROLE_BF_LIST_PROCUREMENT_AGENT');

INSERT IGNORE INTO ap_security VALUES (null, 3, '/api/productCategory', 'ROLE_BF_MANAGE_PRODUCT_CATEGORY');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/productCategory/**', 'ROLE_BF_LIST_PRODUCT_CATEGORY');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/productCategory/**', 'ROLE_BF_LIST_PRODUCT_CATEGORY');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/productCategory/**', 'ROLE_BF_LIST_PRODUCT_CATEGORY');

INSERT IGNORE INTO ap_security VALUES (null, 2, '/api/tracerCategory', 'ROLE_BF_ADD_TRACER_CATEGORY');
INSERT IGNORE INTO ap_security VALUES (null, 3, '/api/tracerCategory', 'ROLE_BF_EDIT_TRACER_CATEGORY');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/tracerCategory', 'ROLE_BF_LIST_TRACER_CATEGORY');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/tracerCategory/**', 'ROLE_BF_LIST_TRACER_CATEGORY');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/tracerCategory/**', 'ROLE_BF_LIST_TRACER_CATEGORY');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/tracerCategory/**', 'ROLE_BF_LIST_TRACER_CATEGORY');
INSERT IGNORE INTO ap_security VALUES (null, 2, '/api/tracerCategory/**', 'ROLE_BF_LIST_TRACER_CATEGORY');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/tracerCategory/**', 'ROLE_BF_LIST_TRACER_CATEGORY');

INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/usagePeriod', 'ROLE_BF_LIST_USAGE_PERIOD');
INSERT IGNORE INTO ap_security VALUES (null, 2, '/api/usagePeriod', 'ROLE_BF_ADD_USAGE_PERIOD');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/usagePeriod/**', 'ROLE_BF_LIST_USAGE_PERIOD');

INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/usageTemplate**', 'ROLE_BF_LIST_USAGE_TEMPLATE');
INSERT IGNORE INTO ap_security VALUES (null, 2, '/api/usageTemplate**', 'ROLE_BF_EDIT_USAGE_TEMPLATE');
INSERT IGNORE INTO ap_security VALUES (null, 2, '/api/usageTemplate**', 'ROLE_BF_EDIT_USAGE_TEMPLATE_ALL');
INSERT IGNORE INTO ap_security VALUES (null, 2, '/api/usageTemplate**', 'ROLE_BF_EDIT_USAGE_TEMPLATE_OWN');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/usageTemplate**', 'ROLE_BF_LIST_USAGE_TEMPLATE');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/usageTemplate**', 'ROLE_BF_LIST_USAGE_TEMPLATE');

INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/equivalencyUnit', 'ROLE_BF_LIST_EQUIVALENCY_UNIT');
INSERT IGNORE INTO ap_security VALUES (null, 2, '/api/equivalencyUnit', 'ROLE_BF_ADD_EQUIVALENCY_UNIT');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/equivalencyUnit/**', 'ROLE_BF_LIST_EQUIVALENCY_UNIT');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/equivalencyUnit/**', 'ROLE_BF_LIST_EQUIVALENCY_UNIT');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/equivalencyUnit/mapping', 'ROLE_BF_LIST_EQUIVALENCY_UNIT_MAPPING');
INSERT IGNORE INTO ap_security VALUES (null, 2, '/api/equivalencyUnit/mapping', 'ROLE_BF_ADD_EQUIVALENCY_UNIT_MAPPING');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/equivalencyUnit/mapping/**', 'ROLE_BF_LIST_EQUIVALENCY_UNIT_MAPPING');

INSERT IGNORE INTO ap_security VALUES (null, 2, '/api/forecastingUnit', 'ROLE_BF_ADD_FORECASTING_UNIT');
INSERT IGNORE INTO ap_security VALUES (null, 3, '/api/forecastingUnit', 'ROLE_BF_EDIT_FORECASTING_UNIT');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/forecastingUnit', 'ROLE_BF_LIST_FORECASTING_UNIT');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/forecastingUnit/**', 'ROLE_BF_LIST_FORECASTING_UNIT');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/forecastingUnit/**', 'ROLE_BF_LIST_FORECASTING_UNIT');
INSERT IGNORE INTO ap_security VALUES (null, 2, '/api/forecastingUnit/**', 'ROLE_BF_LIST_FORECASTING_UNIT');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/forecastingUnit/**', 'ROLE_BF_LIST_FORECASTING_UNIT');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/forecastingUnit/**', 'ROLE_BF_LIST_FORECASTING_UNIT');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/forecastingUnit/**', 'ROLE_BF_LIST_FORECASTING_UNIT');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/forecastingUnit/**', 'ROLE_BF_LIST_FORECASTING_UNIT');
INSERT IGNORE INTO ap_security VALUES (null, 2, '/api/forecastingUnit/**', 'ROLE_BF_LIST_FORECASTING_UNIT');
INSERT IGNORE INTO ap_security VALUES (null, 2, '/api/forecastingUnit/**', 'ROLE_BF_LIST_FORECASTING_UNIT');

INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/integration', 'ROLE_BF_LIST_INTEGRATION');
INSERT IGNORE INTO ap_security VALUES (null, 2, '/api/integration', 'ROLE_BF_ADD_INTEGRATION');
INSERT IGNORE INTO ap_security VALUES (null, 3, '/api/integration', 'ROLE_BF_EDIT_INTEGRATION');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/integration/*', 'ROLE_BF_LIST_INTEGRATION');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/integration/*', 'ROLE_BF_LIST_INTEGRATION');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/integrationProgram', 'ROLE_BF_ADD_INTEGRATION_PROGRAM');
INSERT IGNORE INTO ap_security VALUES (null, 3, '/api/integrationProgram', 'ROLE_BF_ADD_INTEGRATION_PROGRAM');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/integrationProgram/**', 'ROLE_BF_ADD_INTEGRATION_PROGRAM');
INSERT IGNORE INTO ap_security VALUES (null, 2, '/api/integrationProgram/**', 'ROLE_BF_MANUAL_INTEGRATION');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/integrationProgram/**', 'ROLE_BF_ADD_INTEGRATION_PROGRAM');

INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/planningUnit/**', 'ROLE_BF_LIST_PLANNING_UNIT');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/planningUnit/**', 'ROLE_BF_LIST_PLANNING_UNIT');
INSERT IGNORE INTO ap_security VALUES (null, 2, '/api/planningUnit', 'ROLE_BF_ADD_PLANNING_UNIT');
INSERT IGNORE INTO ap_security VALUES (null, 3, '/api/planningUnit', 'ROLE_BF_EDIT_PLANNING_UNIT');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/planningUnit', 'ROLE_BF_LIST_PLANNING_UNIT');
INSERT IGNORE INTO ap_security VALUES (null, 2, '/api/planningUnit/**', 'ROLE_BF_LIST_PLANNING_UNIT');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/planningUnit/capacity/**', 'ROLE_BF_LIST_PLANNING_UNIT_CAPACITY');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/planningUnit/capacity/**', 'ROLE_BF_LIST_PLANNING_UNIT_CAPACITY');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/planningUnit/capacity/**', 'ROLE_BF_LIST_PLANNING_UNIT_CAPACITY');
INSERT IGNORE INTO ap_security VALUES (null, 3, '/api/planningUnit/capacity', 'ROLE_BF_MAP_PLANNING_UNIT_CAPACITY');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/planningUnit/capacity/**', 'ROLE_BF_LIST_PLANNING_UNIT_CAPACITY');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/planningUnit/capacity/**', 'ROLE_BF_LIST_PLANNING_UNIT_CAPACITY');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/planningUnit/**', 'ROLE_BF_LIST_PLANNING_UNIT');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/planningUnit/**', 'ROLE_BF_LIST_PLANNING_UNIT');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/planningUnit/**', 'ROLE_BF_LIST_PLANNING_UNIT');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/planningUnit/**', 'ROLE_BF_LIST_PLANNING_UNIT');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/planningUnit/**', 'ROLE_BF_LIST_PLANNING_UNIT');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/planningUnit/**', 'ROLE_BF_LIST_PLANNING_UNIT');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/planningUnit/**', 'ROLE_BF_LIST_PLANNING_UNIT');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/planningUnit/**', 'ROLE_BF_LIST_PLANNING_UNIT');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/planningUnit/**', 'ROLE_BF_LIST_PLANNING_UNIT');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/planningUnit/**', 'ROLE_BF_LIST_PLANNING_UNIT');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/planningUnit/**', 'ROLE_BF_LIST_PLANNING_UNIT');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/planningUnit/**', 'ROLE_BF_LIST_PLANNING_UNIT');
INSERT IGNORE INTO ap_security VALUES (null, 2, '/api/planningUnit/productCategoryList/active/realmCountryId/*', 'ROLE_BF_MANUAL_TAGGING');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/planningUnit/**', 'ROLE_BF_LIST_PLANNING_UNIT');
INSERT IGNORE INTO ap_security VALUES (null, 2, '/api/planningUnit/**', 'ROLE_BF_LIST_PLANNING_UNIT');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/planningUnit/**', 'ROLE_BF_LIST_PLANNING_UNIT');
INSERT IGNORE INTO ap_security VALUES (null, 2, '/api/planningUnit/**', 'ROLE_BF_LIST_PLANNING_UNIT');

INSERT IGNORE INTO ap_security VALUES (null, 2, '/api/procurementUnit', 'ROLE_BF_ADD_PROCUREMENT_UNIT');
INSERT IGNORE INTO ap_security VALUES (null, 3, '/api/procurementUnit', 'ROLE_BF_EDIT_PROCUREMENT_UNIT');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/procurementUnit', 'ROLE_BF_LIST_PROCUREMENT_UNIT');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/procurementUnit/**', 'ROLE_BF_LIST_PROCUREMENT_UNIT');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/procurementUnit/**', 'ROLE_BF_LIST_PROCUREMENT_UNIT');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/procurementUnit/**', 'ROLE_BF_LIST_PROCUREMENT_UNIT');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/procurementUnit/**', 'ROLE_BF_LIST_PROCUREMENT_UNIT');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/procurementUnit/**', 'ROLE_BF_LIST_PROCUREMENT_UNIT');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/procurementUnit/**', 'ROLE_BF_LIST_PROCUREMENT_UNIT');

INSERT IGNORE INTO ap_security VALUES (null, 2, '/api/realmCountry', 'ROLE_BF_MAP_REALM_COUNTRY');
INSERT IGNORE INTO ap_security VALUES (null, 3, '/api/realmCountry', 'ROLE_BF_MAP_REALM_COUNTRY');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/realmCountry', 'ROLE_BF_LIST_REALM_COUNTRY');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/realmCountry/**', 'ROLE_BF_LIST_REALM_COUNTRY');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/realmCountry/**', 'ROLE_BF_MANAGE_REALM_COUNTRY_PLANNING_UNIT');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/realmCountry/**', 'ROLE_BF_MANAGE_REALM_COUNTRY_PLANNING_UNIT');
INSERT IGNORE INTO ap_security VALUES (null, 3, '/api/realmCountry/**', 'ROLE_BF_MANAGE_REALM_COUNTRY_PLANNING_UNIT');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/realmCountry/**', 'ROLE_BF_LIST_REALM_COUNTRY');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/realmCountry/**', 'ROLE_BF_LIST_REALM_COUNTRY');
INSERT IGNORE INTO ap_security VALUES (null, 2, '/api/realmCountry/**', 'ROLE_BF_MANAGE_REALM_COUNTRY_PLANNING_UNIT');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/realmCountry/**', 'ROLE_BF_LIST_REALM_COUNTRY');

INSERT IGNORE INTO ap_security VALUES (null, 2, '/api/realm', 'ROLE_BF_CREATE_REALM');
INSERT IGNORE INTO ap_security VALUES (null, 3, '/api/realm', 'ROLE_BF_EDIT_REALM');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/realm', 'ROLE_BF_LIST_REALM');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/realm/*', 'ROLE_BF_LIST_REALM');

INSERT IGNORE INTO ap_security VALUES (null, 3, '/api/region', 'ROLE_BF_MAP_REGION');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/region', 'ROLE_BF_MAP_REGION');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/region/**', 'ROLE_BF_MAP_REGION');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/region/**', 'ROLE_BF_MAP_REGION');

INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/treeTemplate', 'ROLE_BF_VIEW_TREE_TEMPLATES');
INSERT IGNORE INTO ap_security VALUES (null, 2, '/api/treeTemplate', 'ROLE_BF_ADD_TREE_TEMPLATE');
INSERT IGNORE INTO ap_security VALUES (null, 3, '/api/treeTemplate', 'ROLE_BF_EDIT_TREE_TEMPLATE');
INSERT IGNORE INTO ap_security VALUES (null, 1, '/api/treeTemplate/*', 'ROLE_BF_VIEW_TREE_TEMPLATES');

UPDATE us_user u set u.REALM_ID=null where u.USER_ID=36;


-- TRUNCATE TABLE temp_security;
-- INSERT INTO temp_security VALUES (null, 2, '/api/budget','ROLE_BF_ADD_BUDGET');
-- INSERT INTO temp_security VALUES (null, 1, '/api/budget','ROLE_BF_TICKETING~ROLE_BF_LIST_BUDGET');
-- INSERT INTO temp_security VALUES (null, 0, '/api/budget/**','ROLE_BF_EDIT_BUDGET');
-- INSERT INTO temp_security VALUES (null, 2, '/api/country','ROLE_BF_ADD_COUNTRY');
-- INSERT INTO temp_security VALUES (null, 3, '/api/country','ROLE_BF_EDIT_COUNTRY');
-- INSERT INTO temp_security VALUES (null, 1, '/api/country/all','ROLE_BF_TICKETING~ROLE_BF_LIST_COUNTRY~ROLE_BF_ADD_HEALTH_AREA~ROLE_BF_MAP_REALM_COUNTRY~ROLE_BF_LIST_REALM');
-- INSERT INTO temp_security VALUES (null, 1, '/api/country/*','ROLE_BF_EDIT_COUNTRY');
-- INSERT INTO temp_security VALUES (null, 1, '/api/country','ROLE_BF_LIST_COUNTRY');
-- INSERT INTO temp_security VALUES (null, 2, '/api/currency','ROLE_BF_ADD_CURRENCY');
-- INSERT INTO temp_security VALUES (null, 3, '/api/currency','ROLE_BF_EDIT_CURRENCY');
-- INSERT INTO temp_security VALUES (null, 1, '/api/currency','ROLE_BF_LIST_CURRENCY~ROLE_BF_ADD_BUDGET~ROLE_BF_SUPPLY_PLAN_VERSION_AND_REVIEW~ROLE_BF_EDIT_COUNTRY~ROLE_BF_ADD_COUNTRY~ROLE_BF_MAP_REALM_COUNTRY~ROLE_BF_TICKETING');
-- INSERT INTO temp_security VALUES (null, 1, '/api/currency/all','ROLE_BF_LIST_CURRENCY~ROLE_BF_ADD_COUNTRY~ROLE_BF_EDIT_COUNTRY~ROLE_BF_MAP_REALM_COUNTRY~ROLE_BF_TICKETING');
-- INSERT INTO temp_security VALUES (null, 1, '/api/currency/**','ROLE_BF_EDIT_CURRENCY');
-- INSERT INTO temp_security VALUES (null, 1, '/api/applicationLevelDashboard~/api/applicationLevelDashboardUserList~/api/ticket/openIssues~/api/supplyPlanReviewerLevelDashboard~/api/realmLevelDashboard~/api/realmLevelDashboardUserList','ROLE_BF_APPLICATION_DASHBOARD');
-- INSERT INTO temp_security VALUES (null, 2, '/api/ticket/addIssue~/api/ticket/addIssueAttachment/**~/api/user/language','ROLE_BF_TICKETING');
-- INSERT INTO temp_security VALUES (null, 1, '/api/dataset','ROLE_BF_COMPARE_VERSION~ROLE_BF_SUPPLY_PLAN_IMPORT~ROLE_BF_LIST_EQUIVALENCY_UNIT_MAPPING~ROLE_BF_LIST_USAGE_TEMPLATE~ROLE_BF_MODELING_VALIDATION~ROLE_BF_PRODUCT_VALIDATION');
-- INSERT INTO temp_security VALUES (null, 1, '/api/loadDataset','ROLE_BF_LOAD_DELETE_DATASET');
-- INSERT INTO temp_security VALUES (null, 1, '/api/loadDataset/programId/**','ROLE_BF_LOAD_DELETE_DATASET');
-- INSERT INTO temp_security VALUES (null, 1, '/api/treeTemplate','ROLE_BF_TICKETING~ROLE_BF_LIST_TREE_TEMPLATE');
-- INSERT INTO temp_security VALUES (null, 1, '/api/treeTemplate/**','ROLE_BF_EDIT_TREE_TEMPLATE~ROLE_BF_ADD_TREE_TEMPLATE~ROLE_BF_VIEW_TREE_TEMPLATES~ROLE_BF_LIST_TREE_TEMPLATE');
-- INSERT INTO temp_security VALUES (null, 1, '/api/usageType','ROLE_BF_EDIT_TREE_TEMPLATE~ROLE_BF_ADD_TREE_TEMPLATE~ROLE_BF_VIEW_TREE_TEMPLATES');
-- INSERT INTO temp_security VALUES (null, 2, '/api/treeTemplate/**','ROLE_BF_EDIT_TREE_TEMPLATE~ROLE_BF_ADD_TREE_TEMPLATE~ROLE_BF_VIEW_TREE_TEMPLATES~ROLE_BF_LIST_TREE_TEMPLATE');
-- INSERT INTO temp_security VALUES (null, 3, '/api/treeTemplate/**','ROLE_BF_EDIT_TREE_TEMPLATE~ROLE_BF_ADD_TREE_TEMPLATE~ROLE_BF_VIEW_TREE_TEMPLATES');
-- INSERT INTO temp_security VALUES (null, 2, '/api/datasetData','ROLE_BF_COMMIT_DATASET~ROLE_BF_LIST_TREE~ROLE_BF_LOAD_DELETE_DATASET~ROLE_BF_MODELING_VALIDATION~ROLE_BF_PRODUCT_VALIDATION');
-- INSERT INTO temp_security VALUES (null, 3, '/api/datasetData/**','ROLE_BF_COMMIT_DATASET');
-- INSERT INTO temp_security VALUES (null, 1, '/api/datasetData/programId/**','ROLE_BF_VERSION_SETTINGS~ROLE_BF_LIST_TREE');
-- INSERT INTO temp_security VALUES (null, 2, '/api/dataSource','ROLE_BF_ADD_DATA_SOURCE');
-- INSERT INTO temp_security VALUES (null, 3, '/api/dataSource','ROLE_BF_EDIT_DATA_SOURCE');
-- INSERT INTO temp_security VALUES (null, 1, '/api/dataSource/all','ROLE_BF_TICKETING~ROLE_BF_LIST_DATA_SOURCE~ROLE_BF_PIPELINE_PROGRAM_IMPORT~ROLE_BF_SUPPLY_PLAN_VERSION_AND_REVIEW');
-- INSERT INTO temp_security VALUES (null, 1, '/api/dataSource/**','ROLE_BF_EDIT_DATA_SOURCE');
-- INSERT INTO temp_security VALUES (null, 2, '/api/dataSourceType','ROLE_BF_ADD_DATA_SOURCE_TYPE');
-- INSERT INTO temp_security VALUES (null, 3, '/api/dataSourceType','ROLE_BF_EDIT_DATA_SOURCE_TYPE');
-- INSERT INTO temp_security VALUES (null, 1, '/api/dataSourceType','ROLE_BF_LIST_DATA_SOURCE_TYPE~ROLE_BF_PIPELINE_PROGRAM_IMPORT~ROLE_BF_EDIT_DATA_SOURCE_TYPE');
-- INSERT INTO temp_security VALUES (null, 1, '/api/dataSourceType/all','ROLE_BF_LIST_DATA_SOURCE_TYPE~ROLE_BF_LIST_DATA_SOURCE');
-- INSERT INTO temp_security VALUES (null, 1, '/api/dataSourceType/realmId/**','ROLE_BF_ADD_DATA_SOURCE~ROLE_BF_TICKETING');
-- INSERT INTO temp_security VALUES (null, 1, '/api/dataSourceType/**','ROLE_BF_EDIT_DATA_SOURCE_TYPE');
-- INSERT INTO temp_security VALUES (null, 1, '/api/equivalencyUnit/mapping/all','ROLE_BF_LIST_EQUIVALENCY_UNIT_MAPPING~ROLE_BF_LIST_MONTHLY_FORECAST~ROLE_BF_FORECAST_ERROR_OVER_TIME_REPORT');
-- INSERT INTO temp_security VALUES (null, 2, '/api/equivalencyUnit/mapping','ROLE_BF_LIST_EQUIVALENCY_UNIT_MAPPING');
-- INSERT INTO temp_security VALUES (null, 1, '/api/equivalencyUnit/all','ROLE_BF_LIST_EQUIVALENCY_UNIT_MAPPING');
-- INSERT INTO temp_security VALUES (null, 2, '/api/equivalencyUnit','ROLE_BF_LIST_EQUIVALENCY_UNIT_MAPPING');
-- INSERT INTO temp_security VALUES (null, 2, '/api/forecastingUnit/byIds','ROLE_BF_LIST_USAGE_TEMPLATE');
-- INSERT INTO temp_security VALUES (null, 1, '/api/forecastingUnit/tracerCategory/**','ROLE_BF_EDIT_TREE_TEMPLATE~ROLE_BF_ADD_TREE_TEMPLATE~ROLE_BF_VIEW_TREE_TEMPLATES');
-- INSERT INTO temp_security VALUES (null, 2, '/api/forecastingUnit/tracerCategorys','ROLE_BF_LIST_EQUIVALENCY_UNIT_MAPPING');
-- INSERT INTO temp_security VALUES (null, 2, '/api/forecastingUnit/**','ROLE_BF_ADD_FORECASTING_UNIT');
-- INSERT INTO temp_security VALUES (null, 1, '/api/forecastingUnit','ROLE_BF_TICKETING~ROLE_BF_ADD_PLANNING_UNIT');
-- INSERT INTO temp_security VALUES (null, 1, '/api/forecastingUnit/all','ROLE_BF_LIST_FORECASTING_UNIT');
-- INSERT INTO temp_security VALUES (null, 3, '/api/forecastingUnit/**','ROLE_BF_EDIT_FORECASTING_UNIT');
-- INSERT INTO temp_security VALUES (null, 2, '/api/forecastingUnit/tracerCategory/productCategory~/api/planningUnit/tracerCategory/productCategory/forecastingUnit','ROLE_BF_LIST_FORECASTING_UNIT');
-- INSERT INTO temp_security VALUES (null, 1, '/api/forecastingUnit/realmId/**','ROLE_BF_LIST_FORECASTING_UNIT~ROLE_BF_LIST_PLANNING_UNIT~ROLE_BF_TICKETING');
-- INSERT INTO temp_security VALUES (null, 1, '/api/forecastingUnit/programId/**','ROLE_BF_LIST_MONTHLY_FORECAST');
-- INSERT INTO temp_security VALUES (null, 1, '/api/forecastingUnit/**','ROLE_BF_ADD_PLANNING_UNIT');
-- INSERT INTO temp_security VALUES (null, 1, '/api/forecastMethod/all','ROLE_BF_TICKETING~ROLE_BF_LIST_FORECAST_METHOD');
-- INSERT INTO temp_security VALUES (null, 1, '/api/forecastMethod','ROLE_BF_EDIT_TREE_TEMPLATE~ROLE_BF_ADD_TREE_TEMPLATE~ROLE_BF_VIEW_TREE_TEMPLATES');
-- INSERT INTO temp_security VALUES (null, 2, '/api/forecastMethod**','ROLE_BF_LIST_FORECAST_METHOD');
-- INSERT INTO temp_security VALUES (null, 1, '/api/forecastMethodType','ROLE_BF_TICKETING~ROLE_BF_LIST_FORECAST_METHOD');
-- INSERT INTO temp_security VALUES (null, 2, '/api/fundingSource/**','ROLE_BF_ADD_FUNDING_SOURCE');
-- INSERT INTO temp_security VALUES (null, 1, '/api/fundingSource','ROLE_BF_ADD_BUDGET~ROLE_BF_EDIT_BUDGET~ROLE_BF_LIST_BUDGET~ROLE_BF_LIST_FUNDING_SOURCE~ROLE_BF_MANUAL_TAGGING~ROLE_BF_PIPELINE_PROGRAM_IMPORT~ROLE_BF_SUPPLY_PLAN_VERSION_AND_REVIEW~ROLE_BF_SHIPMENT_COST_DETAILS_REPORT~ROLE_BF_SHIPMENT_OVERVIEW_REPORT~ROLE_BF_GLOBAL_DEMAND_REPORT~ROLE_BF_TICKETING');
-- INSERT INTO temp_security VALUES (null, 0, '/api/fundingSource/**','ROLE_BF_EDIT_FUNDING_SOURCE');
-- INSERT INTO temp_security VALUES (null, 1, '/api/fundingSource/getDisplayName/realmId/**','ROLE_BF_ADD_FUNDING_SOURCE');
-- INSERT INTO temp_security VALUES (null, 1, '/api/healthArea/realmId/**','ROLE_BF_TICKETING~ROLE_BF_PIPELINE_PROGRAM_IMPORT~ROLE_BF_CREATE_A_PROGRAM~ROLE_BF_EDIT_PROGRAM~ROLE_BF_ADD_DATASET~ROLE_BF_EDIT_DATASET');
-- INSERT INTO temp_security VALUES (null, 1, '/api/healthArea/realmCountryId/**','ROLE_BF_ADD_DATASET~ROLE_BF_EDIT_DATASET~ROLE_BF_EDIT_PROGRAM~ROLE_BF_SET_UP_PROGRAM');
-- INSERT INTO temp_security VALUES (null, 2, '/api/healthArea/**','ROLE_BF_ADD_HEALTH_AREA');
-- INSERT INTO temp_security VALUES (null, 3, '/api/healthArea/**','ROLE_BF_EDIT_HEALTH_AREA');
-- INSERT INTO temp_security VALUES (null, 1, '/api/healthArea','ROLE_BF_TICKETING~ROLE_BF_LIST_HEALTH_AREA~ROLE_BF_EDIT_HEALTH_AREA');
-- INSERT INTO temp_security VALUES (null, 1, '/api/healthArea/**','ROLE_BF_EDIT_HEALTH_AREA');
-- INSERT INTO temp_security VALUES (null, 1, '/api/healthArea/getDisplayName/realmId/**','ROLE_BF_ADD_HEALTH_AREA');
-- INSERT INTO temp_security VALUES (null, 2, '/api/integration/**','ROLE_BF_ADD_INTEGRATION');
-- INSERT INTO temp_security VALUES (null, 1, '/api/integration','ROLE_BF_LIST_INTEGRATION~ROLE_BF_ADD_INTEGRATION');
-- INSERT INTO temp_security VALUES (null, 1, '/api/integration/viewList','ROLE_BF_ADD_INTEGRATION~ROLE_BF_EDIT_INTEGRATION');
-- INSERT INTO temp_security VALUES (null, 0, '/api/integration/**','ROLE_BF_EDIT_INTEGRATION');
-- INSERT INTO temp_security VALUES (null, 3, '/api/integrationProgram/**','ROLE_BF_ADD_INTEGRATION_PROGRAM');
-- INSERT INTO temp_security VALUES (null, 1, '/api/integrationProgram/program/**','ROLE_BF_ADD_INTEGRATION_PROGRAM');
-- INSERT INTO temp_security VALUES (null, 2, '/api/integrationProgram/manualJson','ROLE_BF_MANUAL_INTEGRATION');
-- INSERT INTO temp_security VALUES (null, 2, '/api/report/manualJson','ROLE_BF_MANUAL_INTEGRATION');
-- INSERT INTO temp_security VALUES (null, 1, '/api/businessFunction/**','ROLE_BF_ADD_ROLE~ROLE_BF_EDIT_ROLE');
-- INSERT INTO temp_security VALUES (null, 1, '/api/role','ROLE_BF_TICKETING~ROLE_BF_ADD_ROLE~ROLE_BF_EDIT_ROLE~ROLE_BF_LIST_ROLE~ROLE_BF_ADD_USER~ROLE_BF_EDIT_USER~ROLE_BF_LIST_USER');
-- INSERT INTO temp_security VALUES (null, 1, '/api/role/**','ROLE_BF_EDIT_ROLE');
-- INSERT INTO temp_security VALUES (null, 2, '/api/role/**','ROLE_BF_ADD_ROLE');
-- INSERT INTO temp_security VALUES (null, 3, '/api/role/**','ROLE_BF_EDIT_ROLE');
-- INSERT INTO temp_security VALUES (null, 2, '/api/programData/getLatestVersionForPrograms~/api/user/module/**~/api/user/agreement~/api/programData/checkNewerVersions~/api/changePassword','');
-- INSERT INTO temp_security VALUES (null, 2, '/api/user/**','ROLE_BF_ADD_USER');
-- INSERT INTO temp_security VALUES (null, 3, '/api/user/**','ROLE_BF_LIST_USER~ROLE_BF_EDIT_USER');
-- INSERT INTO temp_security VALUES (null, 1, '/api/user','ROLE_BF_LIST_USER');
-- INSERT INTO temp_security VALUES (null, 1, '/api/user/**~/api/procurementAgent~/api/erpLinking/getNotificationCount','');
-- INSERT INTO temp_security VALUES (null, 2, '/api/userManual/uploadUserManual/**','ROLE_BF_UPLOAD_USER_MANUAL');
-- INSERT INTO temp_security VALUES (null, 1, '/api/usageTemplate/all','ROLE_BF_LIST_USAGE_TEMPLATE');
-- INSERT INTO temp_security VALUES (null, 2, '/api/usageTemplate/**','ROLE_BF_LIST_USAGE_TEMPLATE');
-- INSERT INTO temp_security VALUES (null, 1, '/api/usageTemplate/tracerCategory/**','ROLE_BF_EDIT_TREE_TEMPLATE~ROLE_BF_ADD_TREE_TEMPLATE~ROLE_BF_VIEW_TREE_TEMPLATES');
-- INSERT INTO temp_security VALUES (null, 1, '/api/usagePeriod/all','ROLE_BF_LIST_USAGE_PERIOD~ROLE_BF_TICKETING');
-- INSERT INTO temp_security VALUES (null, 1, '/api/usagePeriod','ROLE_BF_EDIT_TREE_TEMPLATE~ROLE_BF_ADD_TREE_TEMPLATE~ROLE_BF_VIEW_TREE_TEMPLATES~ROLE_BF_LIST_USAGE_TEMPLATE~ROLE_BF_LIST_USAGE_PERIOD');
-- INSERT INTO temp_security VALUES (null, 2, '/api/usagePeriod/**','ROLE_BF_LIST_USAGE_PERIOD');
-- INSERT INTO temp_security VALUES (null, 1, '/api/unit/dimension/**','ROLE_BF_EDIT_TREE_TEMPLATE~ROLE_BF_ADD_TREE_TEMPLATE~ROLE_BF_VIEW_TREE_TEMPLATES~ROLE_BF_LIST_USAGE_TEMPLATE');
-- INSERT INTO temp_security VALUES (null, 2, '/api/unit','ROLE_BF_ADD_UNIT');
-- INSERT INTO temp_security VALUES (null, 3, '/api/unit','ROLE_BF_EDIT_UNIT');
-- INSERT INTO temp_security VALUES (null, 1, '/api/unit','ROLE_BF_TICKETING~ROLE_BF_EDIT_TREE_TEMPLATE~ROLE_BF_ADD_TREE_TEMPLATE~ROLE_BF_VIEW_TREE_TEMPLATES~ROLE_BF_LIST_EQUIVALENCY_UNIT_MAPPING~ROLE_BF_ADD_FORECASTING_UNIT~ROLE_BF_EDIT_FORECASTING_UNIT~ROLE_BF_ADD_PLANNING_UNIT~ROLE_BF_EDIT_PLANNING_UNIT~ROLE_BF_ADD_PROCUREMENT_UNIT~ROLE_BF_EDIT_PROCUREMENT_UNIT~ROLE_BF_MANAGE_REALM_COUNTRY_PLANNING_UNIT~ROLE_BF_LIST_USAGE_TEMPLATE');
-- INSERT INTO temp_security VALUES (null, 1, '/api/unit/**','ROLE_BF_EDIT_UNIT');
-- INSERT INTO temp_security VALUES (null, 1, '/api/tracerCategory','ROLE_BF_TICKETING~ROLE_BF_LIST_EQUIVALENCY_UNIT_MAPPING~ROLE_BF_LIST_PLANNING_UNIT_SETTING~ROLE_BF_LIST_TRACER_CATEGORY~ROLE_BF_LIST_USAGE_TEMPLATE~ROLE_BF_SUPPLY_PLAN_IMPORT');
-- INSERT INTO temp_security VALUES (null, 2, '/api/tracerCategory/realmId/**','ROLE_BF_FORECAST_MATRIX_REPORT');
-- INSERT INTO temp_security VALUES (null, 2, '/api/tracerCategory/**','ROLE_BF_ADD_TRACER_CATEGORY');
-- INSERT INTO temp_security VALUES (null, 3, '/api/tracerCategory/**','ROLE_BF_EDIT_TRACER_CATEGORY');
-- INSERT INTO temp_security VALUES (null, 1, '/api/tracerCategory/realmId/**','ROLE_BF_LIST_PLANNING_UNIT~ROLE_BF_FORECAST_MATRIX_REPORT~ROLE_BF_PRODUCT_CATALOG_REPORT~ROLE_BF_STOCK_STATUS_GLOBAL_VIEW_REPORT~ROLE_BF_VIEW_STOCK_STATUS_MATRIX');
-- INSERT INTO temp_security VALUES (null, 1, '/api/tracerCategory/**','ROLE_BF_EDIT_TREE_TEMPLATE~ROLE_BF_ADD_TREE_TEMPLATE~ROLE_BF_VIEW_TREE_TEMPLATES~ROLE_BF_LIST_EQUIVALENCY_UNIT_MAPPING~ROLE_BF_LIST_PLANNING_UNIT_SETTING~ROLE_BF_LIST_TRACER_CATEGORY~ROLE_BF_LIST_USAGE_TEMPLATE~ROLE_BF_EDIT_TRACER_CATEGORY');
-- INSERT INTO temp_security VALUES (null, 2, '/api/supplier/**','ROLE_BF_ADD_SUPPLIER');
-- INSERT INTO temp_security VALUES (null, 1, '/api/supplier/**','ROLE_BF_MAP_PLANNING_UNIT_CAPACITY~ROLE_BF_ADD_PROCUREMENT_UNIT~ROLE_BF_LIST_SUPPLIER~ROLE_BF_EDIT_SUPPLIER~ROLE_BF_PIPELINE_PROGRAM_IMPORT');
-- INSERT INTO temp_security VALUES (null, 3, '/api/supplier/**','ROLE_BF_EDIT_SUPPLIER');
-- INSERT INTO temp_security VALUES (null, 1, '/api/getShipmentStatusListActive/**','ROLE_BF_ANNUAL_SHIPMENT_COST_REPORT~ROLE_BF_SUPPLY_PLAN_VERSION_AND_REVIEW~ROLE_BF_SHIPMENT_OVERVIEW_REPORT~ROLE_BF_PIPELINE_PROGRAM_IMPORT');
-- INSERT INTO temp_security VALUES (null, 2, '/api/report/forecastMetricsMonthly','ROLE_BF_FORECAST_ERROR_OVER_TIME_REPORT');
-- INSERT INTO temp_security VALUES (null, 2, '/api/report/globalConsumption','ROLE_BF_CONSUMPTION_GLOBAL_VIEW_REPORT');
-- INSERT INTO temp_security VALUES (null, 2, '/api/report/forecastMetricsComparision','ROLE_BF_FORECAST_MATRIX_REPORT');
-- INSERT INTO temp_security VALUES (null, 2, '/api/report/annualShipmentCost','ROLE_BF_ANNUAL_SHIPMENT_COST_REPORT');
-- INSERT INTO temp_security VALUES (null, 2, '/api/report/stockStatusOverTime','ROLE_BF_STOCK_STATUS_OVER_TIME_REPORT');
-- INSERT INTO temp_security VALUES (null, 1, '/api/programVersion/programId/**','ROLE_BF_SUPPLY_PLAN_VERSION_AND_REVIEW');
-- INSERT INTO temp_security VALUES (null, 2, '/api/report/costOfInventory','ROLE_BF_COST_OF_INVENTORY_REPORT');
-- INSERT INTO temp_security VALUES (null, 2, '/api/report/stockStatusVertical','ROLE_BF_SUPPLY_PLAN_REPORT');
-- INSERT INTO temp_security VALUES (null, 2, '/api/report/inventoryTurns','ROLE_BF_INVENTORY_TURNS_REPORT');
-- INSERT INTO temp_security VALUES (null, 2, '/api/report/stockAdjustmentReport','ROLE_BF_STOCK_ADJUSTMENT_REPORT');
-- INSERT INTO temp_security VALUES (null, 2, '/api/report/procurementAgentShipmentReport','ROLE_BF_SHIPMENT_COST_DETAILS_REPORT');
-- INSERT INTO temp_security VALUES (null, 2, '/api/report/fundingSourceShipmentReport','ROLE_BF_FUNDER_REPORT~ROLE_BF_SHIPMENT_COST_DETAILS_REPORT');
-- INSERT INTO temp_security VALUES (null, 2, '/api/report/aggregateShipmentByProduct','ROLE_BF_SHIPMENT_COST_DETAILS_REPORT');
-- INSERT INTO temp_security VALUES (null, 2, '/api/report/warehouseCapacityReport','ROLE_BF_WAREHOUSE_CAPACITY_REPORT');
-- INSERT INTO temp_security VALUES (null, 2, '/api/report/stockStatusForProgram','ROLE_BF_STOCK_STATUS_REPORT~ROLE_BF_STOCK_STATUS_GLOBAL_VIEW_REPORT');
-- INSERT INTO temp_security VALUES (null, 2, '/api/report/programProductCatalog','ROLE_BF_PRODUCT_CATALOG_REPORT');
-- INSERT INTO temp_security VALUES (null, 2, '/api/report/shipmentGlobalDemand','ROLE_BF_GLOBAL_DEMAND_REPORT');
-- INSERT INTO temp_security VALUES (null, 2, '/api/report/programLeadTimes','ROLE_BF_PROCUREMENT_AGENT_REPORT');
-- INSERT INTO temp_security VALUES (null, 2, '/api/report/shipmentDetails','ROLE_BF_SHIPMENT_DETAILS_REPORT');
-- INSERT INTO temp_security VALUES (null, 2, '/api/report/shipmentOverview','ROLE_BF_SHIPMENT_OVERVIEW_REPORT');
-- INSERT INTO temp_security VALUES (null, 2, '/api/report/budgetReport','ROLE_BF_BUDGET_REPORT');
-- INSERT INTO temp_security VALUES (null, 2, '/api/report/stockStatusAcrossProducts','ROLE_BF_STOCK_STATUS_GLOBAL_VIEW_REPORT');
-- INSERT INTO temp_security VALUES (null, 2, '/api/report/expiredStock','ROLE_BF_EXPIRIES_REPORT');
-- INSERT INTO temp_security VALUES (null, 2, '/api/report/warehouseByCountry','ROLE_BF_REGION');
-- INSERT INTO temp_security VALUES (null, 2, '/api/report/monthlyForecast','ROLE_BF_SUPPLY_PLAN_IMPORT~ROLE_BF_LIST_MONTHLY_FORECAST');
-- INSERT INTO temp_security VALUES (null, 2, '/api/report/forecastSummary','ROLE_BF_LIST_FORECAST_SUMMARY~ROLE_BF_VIEW_FORECAST_SUMMARY~ROLE_BF_COMPARE_VERSION');
-- INSERT INTO temp_security VALUES (null, 2, '/api/report/forecastError','ROLE_BF_FORECAST_ERROR_OVER_TIME_REPORT');
-- INSERT INTO temp_security VALUES (null, 2, '/api/report/forecastErrorNew','ROLE_BF_FORECAST_ERROR_OVER_TIME_REPORT');
-- INSERT INTO temp_security VALUES (null, 1, '/api/report/updateProgramInfo/programTypeId/**','ROLE_BF_LIST_PROGRAM~ROLE_BF_LIST_DATASET~ROLE_BF_LIST_ALTERNATE_REPORTING_UNIT');
-- INSERT INTO temp_security VALUES (null, 1, '/api/region/realmCountryId/**','ROLE_BF_MAP_REGION~ROLE_BF_ADD_DATASET~ROLE_BF_EDIT_DATASET~ROLE_BF_PIPELINE_PROGRAM_IMPORT~ROLE_BF_CREATE_A_PROGRAM~ROLE_BF_EDIT_PROGRAM~ROLE_BF_SET_UP_PROGRAM');
-- INSERT INTO temp_security VALUES (null, 2, '/api/realm','ROLE_BF_CREATE_REALM');
-- INSERT INTO temp_security VALUES (null, 1, '/api/realm','ROLE_BF_LOAD_DELETE_DATASET~ROLE_BF_ADD_DATA_SOURCE~ROLE_BF_LIST_DATA_SOURCE~ROLE_BF_ADD_DATA_SOURCE_TYPE~ROLE_BF_LIST_DATA_SOURCE_TYPE~ROLE_BF_ADD_FORECASTING_UNIT~ROLE_BF_LIST_FORECASTING_UNIT~ROLE_BF_LIST_FORECAST_METHOD~ROLE_BF_ADD_FUNDING_SOURCE~ROLE_BF_LIST_FUNDING_SOURCE~ROLE_BF_LIST_HEALTH_AREA~ROLE_BF_ADD_INTEGRATION_PROGRAM~ROLE_BF_LIST_ORGANIZATION~ROLE_BF_LIST_ORGANIZATION_TYPE~ROLE_BF_LIST_PLANNING_UNIT~ROLE_BF_ADD_PROCUREMENT_AGENT~ROLE_BF_LIST_PROCUREMENT_AGENT~ROLE_BF_LIST_PRODUCT_CATEGORY~ROLE_BF_LIST_REALM~ROLE_BF_LIST_REALM_COUNTRY~ROLE_BF_CONSUMPTION_REPORT~ROLE_BF_ADD_SUPPLIER~ROLE_BF_LIST_SUPPLIER~ROLE_BF_ADD_TRACER_CATEGORY~ROLE_BF_LIST_TRACER_CATEGORY~ROLE_BF_ADD_USER~ROLE_BF_EDIT_USER~ROLE_BF_LIST_USER~ROLE_BF_ADD_DATASET~ROLE_BF_CREATE_A_PROGRAM~ROLE_BF_SET_UP_PROGRAM~ROLE_BF_TICKETING');
-- INSERT INTO temp_security VALUES (null, 1, '/api/realm/**','ROLE_BF_EDIT_REALM~ROLE_BF_MAP_REALM_COUNTRY');
-- INSERT INTO temp_security VALUES (null, 3, '/api/realm','ROLE_BF_EDIT_REALM~ROLE_BF_LIST_REALM');
-- INSERT INTO temp_security VALUES (null, 2, '/api/realmCountry','ROLE_BF_MAP_REGION');
-- INSERT INTO temp_security VALUES (null, 1, '/api/realmCountry','ROLE_BF_TICKETING~ROLE_BF_LIST_REALM_COUNTRY');
-- INSERT INTO temp_security VALUES (null, 3, '/api/realmCountry/planningUnit','ROLE_BF_LIST_ALTERNATE_REPORTING_UNIT');
-- INSERT INTO temp_security VALUES (null, 2, '/api/realmCountry/programIds/planningUnit','ROLE_BF_MANUAL_TAGGING~ROLE_BF_LIST_ALTERNATE_REPORTING_UNIT~ROLE_BF_SUPPLY_PLAN');
-- INSERT INTO temp_security VALUES (null, 1, '/api/realmCountry/realmId/**','ROLE_BF_TICKETING~ROLE_BF_PIPELINE_PROGRAM_IMPORT~ROLE_BF_ADD_HEALTH_AREA~ROLE_BF_EDIT_HEALTH_AREA~ROLE_BF_ADD_DATASET~ROLE_BF_CREATE_A_PROGRAM~ROLE_BF_SET_UP_PROGRAM~ROLE_BF_ADD_ORGANIZATION~ROLE_BF_EDIT_ORGANIZATION~ROLE_BF_LIST_DATASET~ROLE_BF_LIST_PROGRAM~ROLE_BF_MAP_REALM_COUNTRY');
-- INSERT INTO temp_security VALUES (null, 1, '/api/realmCountry/program/realmId/**','ROLE_BF_TICKETING~ROLE_BF_LOAD_DELETE_DATASET~ROLE_BF_MANUAL_TAGGING~ROLE_BF_REGION~ROLE_BF_FORECAST_MATRIX_REPORT~ROLE_BF_CONSUMPTION_GLOBAL_VIEW_REPORT~ROLE_BF_SHIPMENT_OVERVIEW_REPORT~ROLE_BF_GLOBAL_DEMAND_REPORT~ROLE_BF_STOCK_STATUS_GLOBAL_VIEW_REPORT~ROLE_BF_STOCK_STATUS_OVER_TIME_REPORT~ROLE_BF_SUPPLY_PLAN_VERSION_AND_REVIEW~ROLE_BF_WAREHOUSE_CAPACITY_REPORT~ROLE_BF_DOWNLOAD_PROGARM');
-- INSERT INTO temp_security VALUES (null, 2, '/api/quantimed/quantimedImport/**','ROLE_BF_QUANTIMED_IMPORT');
-- INSERT INTO temp_security VALUES (null, 1, '/api/programData/programId/**','ROLE_BF_COMMIT_VERSION~ROLE_BF_SUPPLY_PLAN_VERSION_AND_REVIEW');
-- INSERT INTO temp_security VALUES (null, 2, '/api/programData','ROLE_BF_DOWNLOAD_PROGARM~ROLE_BF_COMMIT_VERSION');
-- INSERT INTO temp_security VALUES (null, 1, '/api/program','ROLE_BF_ADD_PROCUREMENT_AGENT~ROLE_BF_EDIT_PROCUREMENT_AGENT~ROLE_BF_FORECAST_ERROR_OVER_TIME_REPORT~ROLE_BF_INVENTORY_TURNS_REPORT~ROLE_BF_TICKETING');
-- INSERT INTO temp_security VALUES (null, 1, '/api/dataset','ROLE_BF_COMPARE_VERSION~ROLE_BF_LIST_EQUIVALENCY_UNIT_MAPPING~ROLE_BF_LIST_USAGE_TEMPLATE~ROLE_BF_MODELING_VALIDATION~ROLE_BF_PRODUCT_VALIDATION');
-- INSERT INTO temp_security VALUES (null, 1, '/api/loadProgram/programId/**','ROLE_BF_DOWNLOAD_PROGARM');
-- INSERT INTO temp_security VALUES (null, 2, '/api/program/realmCountryList','ROLE_BF_INVENTORY_TURNS_REPORT');
-- INSERT INTO temp_security VALUES (null, 2, '/api/program/productCategoryList','ROLE_BF_INVENTORY_TURNS_REPORT');
-- INSERT INTO temp_security VALUES (null, 2, '/api/program/**','ROLE_BF_CREATE_A_PROGRAM~ROLE_BF_ADD_PROGRAM_PRODUCT~ROLE_BF_MAP_PROCUREMENT_AGENT~ROLE_BF_LIST_IMPORT_FROM_QAT_SUPPLY_PLAN');
-- INSERT INTO temp_security VALUES (null, 3, '/api/program','ROLE_BF_EDIT_PROGRAM');
-- INSERT INTO temp_security VALUES (null, 1, '/api/organisation/realmId/**','ROLE_BF_TICKETING~ROLE_BF_PIPELINE_PROGRAM_IMPORT~ROLE_BF_CREATE_A_PROGRAM');
-- INSERT INTO temp_security VALUES (null, 3, '/api/region','ROLE_BF_TICKETING');
-- INSERT INTO temp_security VALUES (null, 1, '/api/region~/api/region/**','ROLE_BF_TICKETING');
-- INSERT INTO temp_security VALUES (null, 1, '/api/program/**','ROLE_BF_MANUAL_TAGGING~ROLE_BF_MAP_COUNTRY_SPECIFIC_PRICES~ROLE_BF_ADD_PROGRAM_PRODUCT~ROLE_BF_ADD_INTEGRATION_PROGRAM~ROLE_BF_EDIT_PROGRAM~ROLE_BF_FORECAST_ERROR_OVER_TIME_REPORT~ROLE_BF_SUPPLY_PLAN_VERSION_AND_REVIEW~ROLE_BF_EXPIRIES_REPORT~ROLE_BF_SUPPLY_PLAN_REPORT~ROLE_BF_MAP_PROCUREMENT_AGENT');
-- INSERT INTO temp_security VALUES (null, 1, '/api/loadProgram','ROLE_BF_DOWNLOAD_PROGARM');
-- INSERT INTO temp_security VALUES (null, 3, '/api/program/planningUnit/**','ROLE_BF_ADD_PROGRAM_PRODUCT');
-- INSERT INTO temp_security VALUES (null, 1, '/api/user/realmId/**','ROLE_BF_ADD_DATASET~ROLE_BF_EDIT_DATASET~ROLE_BF_CREATE_A_PROGRAM~ROLE_BF_EDIT_PROGRAM~ROLE_BF_SET_UP_PROGRAM~ROLE_BF_PIPELINE_PROGRAM_IMPORT');
-- INSERT INTO temp_security VALUES (null, 3, '/api/programData/**','ROLE_BF_COMMIT_VERSION');
-- INSERT INTO temp_security VALUES (null, 2, '/api/program/initialize/**','ROLE_BF_SET_UP_PROGRAM');
-- INSERT INTO temp_security VALUES (null, 1, '/api/versionStatus/**','ROLE_BF_ADD_INTEGRATION_PROGRAM~ROLE_BF_SUPPLY_PLAN_VERSION_AND_REVIEW');
-- INSERT INTO temp_security VALUES (null, 3, '/api/programVersion/**','ROLE_BF_SUPPLY_PLAN_VERSION_AND_REVIEW');
-- INSERT INTO temp_security VALUES (null, 1, '/api/versionType/**','ROLE_BF_SUPPLY_PLAN_VERSION_AND_REVIEW~ROLE_BF_COMMIT_VERSION~ROLE_BF_ADD_INTEGRATION_PROGRAM~ROLE_BF_VERSION_SETTINGS');
-- INSERT INTO temp_security VALUES (null, 1, '/api/problemStatus/**','ROLE_BF_SUPPLY_PLAN_VERSION_AND_REVIEW');
-- INSERT INTO temp_security VALUES (null, 1, '/api/programData/getLatestVersionForProgram/**','ROLE_BF_COMMIT_DATASET~ROLE_BF_COMMIT_VERSION');
-- INSERT INTO temp_security VALUES (null, 1, '/api/programData/getLastModifiedDateForProgram/**','ROLE_BF_COMMIT_VERSION');
-- INSERT INTO temp_security VALUES (null, 2, '/api/dataset/versions','ROLE_BF_VERSION_SETTINGS');
-- INSERT INTO temp_security VALUES (null, 2, '/api/dataset/**','ROLE_BF_ADD_DATASET');
-- INSERT INTO temp_security VALUES (null, 1, '/api/dataset/**','ROLE_BF_EDIT_DATASET');
-- INSERT INTO temp_security VALUES (null, 3, '/api/dataset/**','ROLE_BF_EDIT_DATASET');
-- INSERT INTO temp_security VALUES (null, 2, '/api/program/actualConsumptionReport/**','ROLE_BF_LIST_IMPORT_FROM_QAT_SUPPLY_PLAN');
-- INSERT INTO temp_security VALUES (null, 1, '/api/programData/checkIfCommitRequestExistsForProgram//**','ROLE_BF_COMMIT_VERSION');
-- INSERT INTO temp_security VALUES (null, 1, '/api/sendNotification/**','ROLE_BF_COMMIT_VERSION~ROLE_BF_COMMIT_DATASET');
-- INSERT INTO temp_security VALUES (null, 2, '/api/erpLinking/otherProgramCheck/**','ROLE_BF_COMMIT_VERSION');
-- INSERT INTO temp_security VALUES (null, 1, '/api/user/programId/**','ROLE_BF_EDIT_DATASET~ROLE_BF_EDIT_PROGRAM');
-- INSERT INTO temp_security VALUES (null, 2, '/api/problemReport/createManualProblem/**','ROLE_BF_SUPPLY_PLAN_VERSION_AND_REVIEW');
-- INSERT INTO temp_security VALUES (null, 2, '/api/report/consumptionForecastVsActual/**','ROLE_BF_CONSUMPTION_REPORT');
-- INSERT INTO temp_security VALUES (null, 2, '/api/report/stockStatusMatrix/**','ROLE_BF_STOCK_STATUS_MATRIX_REPORT');
-- INSERT INTO temp_security VALUES (null, 1, '/api/procurementUnit/all','ROLE_BF_MAP_PROCUREMENT_UNIT~ROLE_BF_LIST_PROCUREMENT_UNIT');
-- INSERT INTO temp_security VALUES (null, 0, '/api/procurementUnit/**','ROLE_BF_EDIT_PROCUREMENT_UNIT');
-- INSERT INTO temp_security VALUES (null, 2, '/api/procurementUnit/**','ROLE_BF_ADD_PROCUREMENT_UNIT');
-- INSERT INTO temp_security VALUES (null, 2, '/api/procurementAgent/**','ROLE_BF_ADD_PROCUREMENT_AGENT~ROLE_BF_MAP_PLANNING_UNIT~ROLE_BF_MAP_PROCUREMENT_UNIT');
-- INSERT INTO temp_security VALUES (null, 3, '/api/procurementAgent/**','ROLE_BF_EDIT_PROCUREMENT_AGENT~ROLE_BF_MAP_PROCUREMENT_AGENT');
-- INSERT INTO temp_security VALUES (null, 1, '/api/procurementAgent/**','ROLE_BF_LIST_PROCUREMENT_AGENT~ROLE_BF_MAP_PLANNING_UNIT~ROLE_BF_MAP_PROCUREMENT_UNIT~ROLE_BF_MAP_COUNTRY_SPECIFIC_PRICES~ROLE_BF_EDIT_PROCUREMENT_AGENT');
-- INSERT INTO temp_security VALUES (null, 2, '/api/program/planningUnit/procurementAgent/**','ROLE_BF_MAP_COUNTRY_SPECIFIC_PRICES');
-- INSERT INTO temp_security VALUES (null, 3, '/api/procurementAgent/planningUnit/**','ROLE_BF_MAP_PLANNING_UNIT');
-- INSERT INTO temp_security VALUES (null, 3, '/api/program/planningingUnit/procurementAgent/**','ROLE_BF_MAP_COUNTRY_SPECIFIC_PRICES');
-- INSERT INTO temp_security VALUES (null, 3, '/api/procurementAgent/procurementUnit/**','ROLE_BF_MAP_PROCUREMENT_UNIT');
-- INSERT INTO temp_security VALUES (null, 0, '/api/procurementAgent/getDisplayName/realmId/**','ROLE_BF_ADD_PROCUREMENT_AGENT');
-- INSERT INTO temp_security VALUES (null, 2, '/api/procurementAgentType/**','ROLE_BF_ADD_PROCUREMENT_AGENT');
-- INSERT INTO temp_security VALUES (null, 1, '/api/procurementAgentType','ROLE_BF_TICKETING~ROLE_BF_ADD_PROCUREMENT_AGENT~ROLE_BF_EDIT_PROCUREMENT_AGENT~ROLE_BF_LIST_PROCUREMENT_AGENT~ROLE_BF_GLOBAL_DEMAND_REPORT');
-- INSERT INTO temp_security VALUES (null, 1, '/api/procurementAgentType/**','ROLE_BF_EDIT_PROCUREMENT_AGENT');
-- INSERT INTO temp_security VALUES (null, 3, '/api/procurementAgentType','ROLE_BF_EDIT_PROCUREMENT_AGENT');
-- INSERT INTO temp_security VALUES (null, 1, '/api/fundingSourceType/realmId/**','ROLE_BF_TICKETING');
-- INSERT INTO temp_security VALUES (null, 2, '/api/fundingSourceType/**','ROLE_BF_ADD_FUNDING_SOURCE');
-- INSERT INTO temp_security VALUES (null, 1, '/api/fundingSourceType','ROLE_BF_TICKETING~ROLE_BF_ADD_FUNDING_SOURCE~ROLE_BF_EDIT_FUNDING_SOURCE~ROLE_BF_LIST_FUNDING_SOURCE');
-- INSERT INTO temp_security VALUES (null, 1, '/api/fundingSourceType/**','ROLE_BF_EDIT_FUNDING_SOURCE');
-- INSERT INTO temp_security VALUES (null, 3, '/api/fundingSourceType','ROLE_BF_EDIT_FUNDING_SOURCE');
-- INSERT INTO temp_security VALUES (null, 1, '/api/productCategory/realmId/**','ROLE_BF_TICKETING~ROLE_BF_ADD_FORECASTING_UNIT~ROLE_BF_LIST_FORECASTING_UNIT~ROLE_BF_MANUAL_TAGGING~ROLE_BF_LIST_PLANNING_UNIT~ROLE_BF_PRODUCT_CATALOG_REPORT~ROLE_BF_GLOBAL_DEMAND_REPORT~ROLE_BF_LIST_PRODUCT_CATEGORY~ROLE_BF_ADD_PROGRAM_PRODUCT~ROLE_BF_INVENTORY_TURNS_REPORT');
-- INSERT INTO temp_security VALUES (null, 2, '/api/report/consumptionForecastVsActual/**','ROLE_BF_CONSUMPTION_REPORT');
-- INSERT INTO temp_security VALUES (null, 2, '/api/report/stockStatusMatrix/**','ROLE_BF_STOCK_STATUS_MATRIX_REPORT');
-- INSERT INTO temp_security VALUES (null, 3, '/api/productCategory/**','ROLE_BF_LIST_PRODUCT_CATEGORY');
-- INSERT INTO temp_security VALUES (null, 2, '/api/planningUnit/productCategoryList/active/realmCountryId/**','ROLE_BF_MANUAL_TAGGING');
-- INSERT INTO temp_security VALUES (null, 2, '/api/planningUnit/programs','ROLE_BF_LIST_ALTERNATE_REPORTING_UNIT');
-- INSERT INTO temp_security VALUES (null, 2, '/api/planningUnit/byIds','ROLE_BF_LIST_PLANNING_UNIT_SETTING');
-- INSERT INTO temp_security VALUES (null, 2, '/api/planningUnit/withPrices/byIds','ROLE_BF_ADD_TREE~ROLE_BF_VIEW_TREE~ROLE_BF_EDIT_TREE~ROLE_BF_EDIT_TREE_TEMPLATE~ROLE_BF_ADD_TREE_TEMPLATE~ROLE_BF_VIEW_TREE_TEMPLATES~ROLE_BF_LIST_TREE~ROLE_BF_LIST_TREE_TEMPLATE~ROLE_BF_LIST_PLANNING_UNIT_SETTING');
-- INSERT INTO temp_security VALUES (null, 2, '/api/planningUnit/**','ROLE_BF_ADD_PLANNING_UNIT');
-- INSERT INTO temp_security VALUES (null, 1, '/api/planningUnit/all','ROLE_BF_TICKETING~ROLE_BF_LIST_PLANNING_UNIT_CAPACITY~ROLE_BF_MAP_PLANNING_UNIT~ROLE_BF_ADD_PROGRAM_PRODUCT~ROLE_BF_LIST_ALTERNATE_REPORTING_UNIT~ROLE_BF_PIPELINE_PROGRAM_IMPORT~ROLE_BF_ADD_PROCUREMENT_AGENT');
-- INSERT INTO temp_security VALUES (null, 1, '/api/planningUnit/realmId/**','ROLE_BF_LIST_PLANNING_UNIT_SETTING~ROLE_BF_LIST_PLANNING_UNIT~ROLE_BF_TICKETING');
-- INSERT INTO temp_security VALUES (null, 1, '/api/planningUnit/**','ROLE_BF_EDIT_TREE_TEMPLATE~ROLE_BF_ADD_TREE_TEMPLATE~ROLE_BF_VIEW_TREE_TEMPLATES~ROLE_BF_PIPELINE_PROGRAM_IMPORT~ROLE_BF_SET_UP_PROGRAM~ROLE_BF_EDIT_PLANNING_UNIT~ROLE_BF_LIST_PLANNING_UNIT_SETTING~ROLE_BF_CONSUMPTION_REPORT');
-- INSERT INTO temp_security VALUES (null, 3, '/api/planningUnit/**','ROLE_BF_EDIT_PLANNING_UNIT~ROLE_BF_MAP_PLANNING_UNIT_CAPACITY');
-- INSERT INTO temp_security VALUES (null, 2, '/api/planningUnit/programs/**~/api/programAndPlanningUnit/programs','ROLE_BF_LIST_ALTERNATE_REPORTING_UNIT~ROLE_BF_FORECAST_MATRIX_REPORT~ROLE_BF_CONSUMPTION_GLOBAL_VIEW_REPORT~ROLE_BF_SHIPMENT_OVERVIEW_REPORT');
-- INSERT INTO temp_security VALUES (null, 1, '/api/planningUnit/productCategory/**','ROLE_BF_MANUAL_TAGGING~ROLE_BF_SHIPMENT_OVERVIEW_REPORT~ROLE_BF_GLOBAL_DEMAND_REPORT');
-- INSERT INTO temp_security VALUES (null, 2, '/api/planningUnit/programs/**','ROLE_BF_LIST_ALTERNATE_REPORTING_UNIT~ROLE_BF_FORECAST_MATRIX_REPORT~ROLE_BF_CONSUMPTION_GLOBAL_VIEW_REPORT~ROLE_BF_SHIPMENT_OVERVIEW_REPORT');
-- INSERT INTO temp_security VALUES (null, 1, '/api/planningUnit/productCategory/**','ROLE_BF_MANUAL_TAGGING~ROLE_BF_SHIPMENT_OVERVIEW_REPORT~ROLE_BF_GLOBAL_DEMAND_REPORT');
-- INSERT INTO temp_security VALUES (null, 2, '/api/planningUnit/productCategoryList/active/realmCountryId/**','ROLE_BF_MANUAL_TAGGING');
-- INSERT INTO temp_security VALUES (null, 1, '/api/planningUnit/realmCountry/**','ROLE_BF_MANUAL_TAGGING');
-- INSERT INTO temp_security VALUES (null, 1, '/api/planningUnit/forecastingUnit/**','ROLE_BF_EDIT_TREE_TEMPLATE~ROLE_BF_ADD_TREE_TEMPLATE~ROLE_BF_VIEW_TREE_TEMPLATES');
-- INSERT INTO temp_security VALUES (null, 1, '/api/planningUnit/programId/**','ROLE_BF_LIST_MONTHLY_FORECAST~ROLE_BF_LIST_IMPORT_FROM_QAT_SUPPLY_PLAN~ROLE_BF_SUPPLY_PLAN_IMPORT');
-- INSERT INTO temp_security VALUES (null, 1, '/api/planningUnit/basic/**','ROLE_BF_ADD_PROGRAM_PRODUCT');
-- INSERT INTO temp_security VALUES (null, 1, '/api/planningUnit/capacity/all','ROLE_BF_LIST_PLANNING_UNIT_CAPACITY');
-- INSERT INTO temp_security VALUES (null, 2, '/api/pipelineJson/**~/api/qatTemp/program/**~/api/pipeline/shipment/**~/api/pipeline/programdata/**','ROLE_BF_PIPELINE_PROGRAM_IMPORT');
-- INSERT INTO temp_security VALUES (null, 1, '/api/pipeline/**~/api/pipeline/programInfo/**~/api/qatTemp/program/**~/api/pipeline/shipment/**~/api/qatTemp/planningUnitList/**~/api/qatTemp/regions/**~/api/pipeline/consumption/**~/api/qatTemp/consumption/**~/api/pipeline/inventory/**~/api/qatTemp/planningUnitListFinalInventry/**~/api/qatTemp/datasource/**~/api/qatTemp/fundingsource/**~/api/qatTemp/procurementagent/**','ROLE_BF_PIPELINE_PROGRAM_IMPORT');
-- INSERT INTO temp_security VALUES (null, 3, '/api/pipeline/planningUnit/**~/api/pipeline/consumption/**~/api/pipeline/inventory/**~/api/pipeline/datasource/**~/api/pipeline/fundingsource/**~/api/pipeline/procurementagent/**~/api/pipeline/realmCountryPlanningUnit/**','ROLE_BF_PIPELINE_PROGRAM_IMPORT');
-- INSERT INTO temp_security VALUES (null, 1, '/api/organisationType/all','ROLE_BF_TICKETING~ROLE_BF_LIST_ORGANIZATION_TYPE');
-- INSERT INTO temp_security VALUES (null, 2, '/api/organisationType','ROLE_BF_ADD_ORGANIZATION_TYPE');
-- INSERT INTO temp_security VALUES (null, 3, '/api/organisationType','ROLE_BF_EDIT_ORGANIZATION_TYPE');
-- INSERT INTO temp_security VALUES (null, 1, '/api/organisationType/realmId/**','ROLE_BF_TICKETING~ROLE_BF_ADD_ORGANIZATION_TYPE~ROLE_BF_EDIT_ORGANIZATION_TYPE');
-- INSERT INTO temp_security VALUES (null, 0, '/api/organisationType/**','ROLE_BF_EDIT_ORGANIZATION_TYPE');
-- INSERT INTO temp_security VALUES (null, 2, '/api/organisation/**','ROLE_BF_ADD_ORGANIZATION');
-- INSERT INTO temp_security VALUES (null, 1, '/api/organisation','ROLE_BF_TICKETING~ROLE_BF_LIST_ORGANIZATION');
-- INSERT INTO temp_security VALUES (null, 3, '/api/organisation/**','ROLE_BF_EDIT_ORGANIZATION');
-- INSERT INTO temp_security VALUES (null, 1, '/api/organisation/**','ROLE_BF_LIST_ORGANIZATION~ROLE_BF_EDIT_ORGANIZATION');
-- INSERT INTO temp_security VALUES (null, 1, '/api/realmCountry/realmId/**','ROLE_BF_TICKETING~ROLE_BF_MAP_REALM_COUNTRY~ROLE_BF_CREATE_A_PROGRAM~ROLE_BF_PIPELINE_PROGRAM_IMPORT~ROLE_BF_EDIT_HEALTH_AREA~ROLE_BF_ADD_ORGANIZATION~ROLE_BF_EDIT_ORGANIZATION');
-- INSERT INTO temp_security VALUES (null, 1, '/api/organisation/getDisplayName/realmId/**','ROLE_BF_ADD_ORGANIZATION');
-- INSERT INTO temp_security VALUES (null, 1, '/api/modelingType/all','ROLE_BF_TICKETING~ROLE_BF_EDIT_TREE_TEMPLATE~ROLE_BF_ADD_TREE_TEMPLATE~ROLE_BF_VIEW_TREE_TEMPLATES~ROLE_BF_LIST_MODELING_TYPE');
-- INSERT INTO temp_security VALUES (null, 1, '/api/modelingType/**','ROLE_BF_EDIT_TREE_TEMPLATE~ROLE_BF_ADD_TREE_TEMPLATE~ROLE_BF_VIEW_TREE_TEMPLATES');
-- INSERT INTO temp_security VALUES (null, 2, '/api/manualTagging/**','ROLE_BF_MANUAL_TAGGING~ROLE_BF_DELINKING');
-- INSERT INTO temp_security VALUES (null, 1, '/api/erpLinking/shipmentLinkingNotification/programId/**','ROLE_BF_MANUAL_TAGGING');
-- INSERT INTO temp_security VALUES (null, 3, '/api/erpLinking/updateNotification/**','ROLE_BF_MANUAL_TAGGING');
-- INSERT INTO temp_security VALUES (null, 1, '/api/manualTagging/notLinkedShipments/**','ROLE_BF_MANUAL_TAGGING~ROLE_BF_DELINKING');
-- INSERT INTO temp_security VALUES (null, 1, '/api/erpLinking/artmisHistory/**','ROLE_BF_MANUAL_TAGGING~ROLE_BF_DELINKING');
-- INSERT INTO temp_security VALUES (null, 1, '/api/erpLinking/getNotificationSummary/**~/api/erpLinking/productCategory/realmCountryId/**','ROLE_BF_MANUAL_TAGGING');
-- INSERT INTO temp_security VALUES (null, 2, '/api/erpLinking/notLinkedQatShipments/programId/**','ROLE_BF_MANUAL_TAGGING');
-- INSERT INTO temp_security VALUES (null, 2, '/api/erpLinking/autoCompleteOrder/**','ROLE_BF_MANUAL_TAGGING');
-- INSERT INTO temp_security VALUES (null, 2, '/api/erpLinking/autoCompletePu/**','ROLE_BF_MANUAL_TAGGING');
-- INSERT INTO temp_security VALUES (null, 2, '/api/erpLinking/notLinkedErpShipments/**','ROLE_BF_MANUAL_TAGGING');
-- INSERT INTO temp_security VALUES (null, 2, '/api/erpLinking/notLinkedErpShipments/tab3/**','ROLE_BF_MANUAL_TAGGING');
-- INSERT INTO temp_security VALUES (null, 2, '/api/erpLinking/linkedShipments/programId/**','ROLE_BF_MANUAL_TAGGING');
-- INSERT INTO temp_security VALUES (null, 2, '/api/erpLinking/batchDetails/**','ROLE_BF_MANUAL_TAGGING');
-- INSERT INTO temp_security VALUES (null, 2, '/api/language/**','ROLE_BF_ADD_LANGUAGE');
-- INSERT INTO temp_security VALUES (null, 1, '/api/language','ROLE_BF_ADD_COUNTRY~ROLE_BF_EDIT_COUNTRY~ROLE_BF_LABEL_TRANSLATIONS~ROLE_BF_ADD_USER~ROLE_BF_EDIT_USER~ROLE_BF_LIST_USER~ROLE_BF_EDIT_LANGUAGE~ROLE_BF_TICKETING');
-- INSERT INTO temp_security VALUES (null, 1, '/api/language/**','ROLE_BF_EDIT_LANGUAGE');
-- INSERT INTO temp_security VALUES (null, 3, '/api/language','ROLE_BF_EDIT_LANGUAGE');
-- INSERT INTO temp_security VALUES (null, 1, '/api/language/all','ROLE_BF_ADD_COUNTRY~ROLE_BF_EDIT_COUNTRY~ROLE_BF_LIST_LANGUAGE~ROLE_BF_LABEL_TRANSLATIONS~ROLE_BF_ADD_USER~ROLE_BF_EDIT_USER~ROLE_BF_LIST_USER');
-- INSERT INTO temp_security VALUES (null, 0, '/api/getDatabaseLabelsListAll','ROLE_BUSINESS_FUNCTION_EDIT_APPLICATION_LABELS~ROLE_BUSINESS_FUNCTION_EDIT_REALM_LABELS~ROLE_BUSINESS_FUNCTION_EDIT_PROGRAM_LABELS');
-- INSERT INTO temp_security VALUES (null, 0, '/api/getStaticLabelsListAll','ROLE_BF_LABEL_TRANSLATIONS');
-- INSERT INTO temp_security VALUES (null, 0, '/api/saveDatabaseLabels','ROLE_BUSINESS_FUNCTION_EDIT_APPLICATION_LABELS~ROLE_BUSINESS_FUNCTION_EDIT_REALM_LABELS~ROLE_BUSINESS_FUNCTION_EDIT_PROGRAM_LABELS');
-- INSERT INTO temp_security VALUES (null, 0, '/api/saveStaticLabels','ROLE_BF_LABEL_TRANSLATIONS');
-- INSERT INTO temp_security VALUES (null, 0, '/api/programData/shipmentSync/programId/**~/api/sync/allMasters/forPrograms/**~/api/erpLinking/shipmentSync~/api/getCommitRequest/**','');
-- INSERT INTO temp_security VALUES (null, 2, '/api/dimension','ROLE_BF_ADD_DIMENSION');
-- INSERT INTO temp_security VALUES (null, 1, '/api/dimension/all','ROLE_BF_LIST_DIMENSION~ROLE_BF_ADD_UNIT~ROLE_BF_LIST_UNIT');
-- INSERT INTO temp_security VALUES (null, 3, '/api/dimension','ROLE_BF_EDIT_DIMENSION');
-- INSERT INTO temp_security VALUES (null, 1, '/api/dimension/**','ROLE_BF_EDIT_DIMENSION');
-- INSERT INTO temp_security VALUES (null, 1, '/api/realmCountry/**','ROLE_BF_MAP_REGION~ROLE_BF_PIPELINE_PROGRAM_IMPORT');
-- INSERT INTO temp_security VALUES (null, 2, '/api/forecastStats/**','ROLE_BF_EXTRAPOLATION');
-- INSERT INTO temp_security VALUES (null, 0, '/api/dropdown/**','ROLE_BF_TICKETING');
-- INSERT INTO temp_security VALUES (null, 0, '/api/export/supplyPlan/**','ROLE_BF_COUNTRY_INTEGRATION_SP');
-- INSERT INTO temp_security VALUES (null, 0, '/api/export/dataset/**','ROLE_BF_COUNTRY_INTEGRATION_FC');
-- SELECT GROUP_CONCAT(s2.SECURITY_ID) into @dupSecurityId FROM (SELECT MIN(s.SECURITY_ID) SECURITY_ID FROM ap_security s group by s.METHOD, s.URL, s.BF HAVING COUNT(*)>1) s2;
-- SELECT @dupSecurityId;
-- DELETE s.* FROM ap_security s WHERE FIND_IN_SET(s.SECURITY_ID, @dupSecurityId);

-- UPDATE `fasp`.`ap_security` SET `URL` = '/api/dropdown/supplyPlan/**', `BF` = 'ROLE_BF_LIST_PROGRAM' WHERE (`SECURITY_ID` = '655');
-- INSERT INTO `fasp`.`ap_security` (`METHOD`, `URL`, `BF`) VALUES ('0', '/api/dropdown/dataset/**', 'ROLE_BF_LIST_DATASET');
