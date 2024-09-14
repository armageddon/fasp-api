CREATE DEFINER=`faspUser`@`localhost` PROCEDURE `getDashboardInventoryProblems`(VAR_PROGRAM_ID INT, VAR_CUR_DATE DATE)
BEGIN

    SET @stopDate = CONCAT(SUBSTRING(VAR_CUR_DATE,1,7),"-01");
    SET @startDate = DATE_SUB(@stopDate, INTERVAL 3 MONTH);
    SELECT p.CURRENT_VERSION_ID into @versionId FROM rm_program p WHERE p.PROGRAM_ID=VAR_PROGRAM_ID;
    
    SELECT COUNT(pu.PLANNING_UNIT_ID) `PU_COUNT`, SUM(IF(IFNULL(i1.ACTUAL_QTY_COUNT,0)>=pr1.REGION_COUNT,1,0)) `GOOD_COUNT`
    FROM vw_program p 
    LEFT JOIN rm_program_planning_unit ppu ON ppu.PROGRAM_ID=VAR_PROGRAM_ID AND ppu.ACTIVE
    LEFT JOIN vw_planning_unit pu ON ppu.PLANNING_UNIT_ID=pu.PLANNING_UNIT_ID AND pu.ACTIVE
    LEFT JOIN (SELECT pr.PROGRAM_ID, COUNT(pr.REGION_ID) REGION_COUNT FROM rm_program_region pr WHERE pr.PROGRAM_ID=VAR_PROGRAM_ID GROUP BY pr.PROGRAM_ID) pr1 ON pr1.PROGRAM_ID=p.PROGRAM_ID
    LEFT JOIN (
        SELECT 
            rcpu.PLANNING_UNIT_ID, SUM(IF(it.ACTUAL_QTY IS NOT NULL, 1, 0)) ACTUAL_QTY_COUNT
        FROM (SELECT i.INVENTORY_ID, MAX(it.VERSION_ID) MAX_VERSION_ID FROM rm_inventory i LEFT JOIN rm_inventory_trans it ON i.INVENTORY_ID=it.INVENTORY_ID WHERE i.PROGRAM_ID=VAR_PROGRAM_ID AND (it.VERSION_ID<=@versionId OR @versionId=-1) GROUP BY i.INVENTORY_ID) tc 
        LEFT JOIN rm_inventory i ON tc.INVENTORY_ID=i.INVENTORY_ID
        LEFT JOIN rm_inventory_trans it ON tc.INVENTORY_ID=it.INVENTORY_ID AND tc.MAX_VERSION_ID=it.VERSION_ID
        LEFT JOIN rm_realm_country_planning_unit rcpu ON rcpu.REALM_COUNTRY_PLANNING_UNIT_ID=it.REALM_COUNTRY_PLANNING_UNIT_ID
        WHERE it.ACTIVE AND it.INVENTORY_DATE BETWEEN @startDate AND @stopDate
        GROUP BY rcpu.PLANNING_UNIT_ID
    ) i1 ON pu.PLANNING_UNIT_ID=i1.PLANNING_UNIT_ID
    WHERE p.PROGRAM_ID=VAR_PROGRAM_ID;
END