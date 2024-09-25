CREATE DEFINER=`faspUser`@`localhost` PROCEDURE `getDashboardActualConsumptionList`(VAR_PROGRAM_ID INT, VAR_CUR_DATE DATE)
BEGIN

    SET @stopDate = CONCAT(SUBSTRING(VAR_CUR_DATE,1,7),"-01");
    SET @startDate = DATE_SUB(@stopDate, INTERVAL 6 MONTH);
    SELECT p.CURRENT_VERSION_ID into @versionId FROM rm_program p WHERE p.PROGRAM_ID=VAR_PROGRAM_ID;
    SELECT COUNT(pr.REGION_ID) into @regionCount FROM rm_program_region pr LEFT JOIN rm_region r ON pr.REGION_ID=r.REGION_ID WHERE pr.PROGRAM_ID=VAR_PROGRAM_ID AND pr.ACTIVE AND r.ACTIVE;
    
    SELECT pu.PLANNING_UNIT_ID, mn.`MONTH` `CONSUMPTION_DATE` , IF(c1.ACTUAL_COUNT IS NULL, NULL, IF(c1.ACTUAL_COUNT=@regionCount, 1, 0)) `ACTUAL_COUNT`
    FROM vw_program p 
    LEFT JOIN rm_program_planning_unit ppu ON ppu.PROGRAM_ID=VAR_PROGRAM_ID AND ppu.ACTIVE
    LEFT JOIN vw_planning_unit pu ON ppu.PLANNING_UNIT_ID=pu.PLANNING_UNIT_ID AND pu.ACTIVE
    LEFT JOIN mn ON mn.MONTH BETWEEN @startDate and @stopDate
    LEFT JOIN (
        SELECT 
            ct.PLANNING_UNIT_ID, ct.CONSUMPTION_DATE, SUM(IF(ct.CONSUMPTION_QTY IS NOT NULL, 1, 0)) `ACTUAL_COUNT` 
        FROM (SELECT c.PROGRAM_ID, ct.CONSUMPTION_ID, MAX(ct.VERSION_ID) MAX_VERSION_ID FROM rm_consumption c LEFT JOIN rm_consumption_trans ct ON c.CONSUMPTION_ID=ct.CONSUMPTION_ID WHERE ct.VERSION_ID<=@versionId AND c.PROGRAM_ID=VAR_PROGRAM_ID GROUP BY ct.CONSUMPTION_ID) tc
        LEFT JOIN rm_consumption cons ON tc.CONSUMPTION_ID=cons.CONSUMPTION_ID
        LEFT JOIN rm_consumption_trans ct ON tc.CONSUMPTION_ID=ct.CONSUMPTION_ID AND tc.MAX_VERSION_ID=ct.VERSION_ID
        WHERE ct.ACTIVE AND ct.ACTUAL_FLAG=1 AND ct.CONSUMPTION_DATE BETWEEN @startDate and @stopDate
        GROUP BY ct.PLANNING_UNIT_ID, ct.CONSUMPTION_DATE
    ) c1 ON pu.PLANNING_UNIT_ID=c1.PLANNING_UNIT_ID AND mn.MONTH=c1.CONSUMPTION_DATE
    WHERE p.PROGRAM_ID=VAR_PROGRAM_ID
    ORDER BY pu.PLANNING_UNIT_ID, mn.MONTH DESC;
END