ALTER TABLE `fasp`.`rm_procurement_agent` 
ADD COLUMN `COLOR_HTML_DARK_CODE` VARCHAR(7) NOT NULL AFTER `COLOR_HTML_CODE`;

USE `fasp`;
CREATE 
     OR REPLACE ALGORITHM = UNDEFINED 
    DEFINER = `faspUser`@`localhost` 
    SQL SECURITY DEFINER
VIEW `vw_procurement_agent` AS
    SELECT 
        `pa`.`PROCUREMENT_AGENT_ID` AS `PROCUREMENT_AGENT_ID`,
        `pa`.`REALM_ID` AS `REALM_ID`,
        `pa`.`PROCUREMENT_AGENT_TYPE_ID` AS `PROCUREMENT_AGENT_TYPE_ID`,
        `pa`.`PROCUREMENT_AGENT_CODE` AS `PROCUREMENT_AGENT_CODE`,
        `pa`.`COLOR_HTML_CODE` AS `COLOR_HTML_CODE`,
        `pa`.`COLOR_HTML_DARK_CODE` AS `COLOR_HTML_DARK_CODE`,
        `pa`.`LABEL_ID` AS `LABEL_ID`,
        `pa`.`SUBMITTED_TO_APPROVED_LEAD_TIME` AS `SUBMITTED_TO_APPROVED_LEAD_TIME`,
        `pa`.`APPROVED_TO_SHIPPED_LEAD_TIME` AS `APPROVED_TO_SHIPPED_LEAD_TIME`,
        `pa`.`ACTIVE` AS `ACTIVE`,
        `pa`.`CREATED_BY` AS `CREATED_BY`,
        `pa`.`CREATED_DATE` AS `CREATED_DATE`,
        `pa`.`LAST_MODIFIED_BY` AS `LAST_MODIFIED_BY`,
        `pa`.`LAST_MODIFIED_DATE` AS `LAST_MODIFIED_DATE`,
        `pal`.`LABEL_EN` AS `LABEL_EN`,
        `pal`.`LABEL_FR` AS `LABEL_FR`,
        `pal`.`LABEL_SP` AS `LABEL_SP`,
        `pal`.`LABEL_PR` AS `LABEL_PR`
    FROM
        (`rm_procurement_agent` `pa`
        LEFT JOIN `ap_label` `pal` ON ((`pa`.`LABEL_ID` = `pal`.`LABEL_ID`)));
