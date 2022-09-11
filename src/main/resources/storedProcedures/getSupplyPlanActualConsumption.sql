CREATE DEFINER=`faspUser`@`%` PROCEDURE `getSupplyPlanActualConsumption`(PROGRAM_ID INT(10), VERSION_ID INT (10), PLANNING_UNIT_LIST TEXT, REGION_LIST VARCHAR(255), START_DATE DATE, STOP_DATE DATE)
BEGIN
	SET @programId = PROGRAM_ID;
    SET @versionId = VERSION_ID;
    SET @planningUnitList = PLANNING_UNIT_LIST;
    SET @regionList = REGION_LIST;
    SET @startDate = START_DATE;
    SET @stopDate = STOP_DATE;
    
    SELECT 
		mn.MONTH `CONSUMPTION_DATE`, c1.CONSUMPTION_QTY, 
		c1.PLANNING_UNIT_ID, c1.`PU_LABEL_ID`, c1.`PU_LABEL_EN`, c1.`PU_LABEL_FR`, c1.`PU_LABEL_SP`, c1.`PU_LABEL_PR`,
		c1.FORECASTING_UNIT_ID, c1.`FU_LABEL_ID`, c1.`FU_LABEL_EN`, c1.`FU_LABEL_FR`, c1.`FU_LABEL_SP`, c1.`FU_LABEL_PR`,
		c1.PRODUCT_CATEGORY_ID, c1.`PC_LABEL_ID`, c1.`PC_LABEL_EN`, c1.`PC_LABEL_FR`, c1.`PC_LABEL_SP`, c1.`PC_LABEL_PR`,
		c1.REGION_ID, c1.`REG_LABEL_ID`, c1.`REG_LABEL_EN`, c1.`REG_LABEL_FR`, c1.`REG_LABEL_SP`, c1.`REG_LABEL_PR`
    FROM mn LEFT JOIN (
		SELECT 
			ct.CONSUMPTION_DATE, ct.CONSUMPTION_QTY, 
			pu.PLANNING_UNIT_ID, pu.LABEL_ID `PU_LABEL_ID`, pu.LABEL_EN `PU_LABEL_EN`, pu.LABEL_FR `PU_LABEL_FR`, pu.LABEL_SP `PU_LABEL_SP`, pu.LABEL_PR `PU_LABEL_PR`,
			fu.FORECASTING_UNIT_ID, fu.LABEL_ID `FU_LABEL_ID`, fu.LABEL_EN `FU_LABEL_EN`, fu.LABEL_FR `FU_LABEL_FR`, fu.LABEL_SP `FU_LABEL_SP`, fu.LABEL_PR `FU_LABEL_PR`,
			pc.PRODUCT_CATEGORY_ID, pc.LABEL_ID `PC_LABEL_ID`, pc.LABEL_EN `PC_LABEL_EN`, pc.LABEL_FR `PC_LABEL_FR`, pc.LABEL_SP `PC_LABEL_SP`, pc.LABEL_PR `PC_LABEL_PR`,
			r.REGION_ID, r.LABEL_ID `REG_LABEL_ID`, r.LABEL_EN `REG_LABEL_EN`, r.LABEL_FR `REG_LABEL_FR`, r.LABEL_SP `REG_LABEL_SP`, r.LABEL_PR `REG_LABEL_PR`
		FROM (SELECT ct.CONSUMPTION_ID, MAX(ct.VERSION_ID) MAX_VERSION_ID FROM rm_consumption c LEFT JOIN rm_consumption_trans ct ON c.CONSUMPTION_ID=ct.CONSUMPTION_ID WHERE (ct.VERSION_ID<=@versionId) AND c.PROGRAM_ID=@programId GROUP BY ct.CONSUMPTION_ID) tc 
		LEFT JOIN rm_consumption cons ON tc.CONSUMPTION_ID=cons.CONSUMPTION_ID
		LEFT JOIN rm_consumption_trans ct ON tc.CONSUMPTION_ID=ct.CONSUMPTION_ID AND tc.MAX_VERSION_ID=ct.VERSION_ID
		LEFT JOIN vw_planning_unit pu ON ct.PLANNING_UNIT_ID=pu.PLANNING_UNIT_ID
		LEFT JOIN vw_forecasting_unit fu ON pu.FORECASTING_UNIT_ID=fu.FORECASTING_UNIT_ID
		LEFT JOIN vw_product_category pc ON fu.PRODUCT_CATEGORY_ID=pc.PRODUCT_CATEGORY_ID
		LEFT JOIN vw_region r ON ct.REGION_ID=r.REGION_ID
		WHERE ct.CONSUMPTION_DATE BETWEEN @startDate AND @stopDate   
		AND FIND_IN_SET(ct.PLANNING_UNIT_ID, @planningUnitList) 
		AND ct.ACTIVE AND ct.ACTUAL_FLAG AND FIND_IN_SET(ct.REGION_ID, @regionList)
		ORDER BY ct.PLANNING_UNIT_ID, ct.REGION_ID, ct.CONSUMPTION_DATE) as c1 ON mn.MONTH=c1.CONSUMPTION_DATE
        WHERE mn.MONTH BETWEEN @startDate AND @stopDate;
END