CREATE DEFINER=`faspUser`@`localhost` PROCEDURE `getInventoryInfoForSSVReport`  (VAR_START_DATE DATE, VAR_STOP_DATE DATE, VAR_PROGRAM_IDS TEXT, VAR_VERSION_ID INT, VAR_REPORTING_UNIT_IDS TEXT, VAR_VIEW_BY INT(10))
BEGIN
    -- %%%%%%%%%%%%%%%%%%%%%
    -- Report no 16b
    -- %%%%%%%%%%%%%%%%%%%%%
	
    SET @varStartDate = VAR_START_DATE;
    SET @varStopDate = VAR_STOP_DATE;
    SET @varProgramIds = VAR_PROGRAM_IDS;
    SET @varVersionId = VAR_VERSION_ID;
    SET @varReportingUnitIds = VAR_REPORTING_UNIT_IDS;
    SET @varViewBy = VAR_VIEW_BY;

    IF @varViewBy = 1 THEN -- PlanningUnitIds
	SELECT GROUP_CONCAT(DISTINCT p.REALM_COUNTRY_ID) INTO @varRealmCountryIds FROM vw_program p WHERE FIND_IN_SET(p.PROGRAM_ID, @varProgramIds);
        SELECT GROUP_CONCAT(DISTINCT rcpu.REALM_COUNTRY_PLANNING_UNIT_ID) INTO @varRealmCountryPlanningUnitIds FROM rm_realm_country_planning_unit rcpu WHERE FIND_IN_SET(rcpu.REALM_COUNTRY_ID, @varRealmCountryIds) AND (@varViewBy=1 AND FIND_IN_SET(rcpu.PLANNING_UNIT_ID, @varReportingUnitIds));
    ELSEIF @varViewBy = 2 THEN -- ARU RealmCountryPlanningUnits
        SET @varRealmCountryPlanningUnitIds = @varReportingUnitIds;
    END IF;
    
    SELECT 
	it.INVENTORY_ID, it.INVENTORY_DATE, it.NOTES,
	p.PROGRAM_ID, p.PROGRAM_CODE, p.LABEL_ID `PROGRAM_LABEL_ID`, p.LABEL_EN `PROGRAM_LABEL_EN`, p.LABEL_FR `PROGRAM_LABEL_FR`, p.LABEL_SP `PROGRAM_LABEL_SP`, p.LABEL_PR `PROGRAM_LABEL_PR`,
        pu.PLANNING_UNIT_ID, pu.LABEL_ID `PLANNING_UNIT_LABEL_ID`, pu.LABEL_EN `PLANNING_UNIT_LABEL_EN`, pu.LABEL_FR `PLANNING_UNIT_LABEL_FR`, pu.LABEL_SP `PLANNING_UNIT_LABEL_SP`, pu.LABEL_PR `PLANNING_UNIT_LABEL_PR`,
        r.REGION_ID, r.LABEL_ID `REGION_LABEL_ID`, r.LABEL_EN `REGION_LABEL_EN`, r.LABEL_FR `REGION_LABEL_FR`, r.LABEL_SP `REGION_LABEL_SP`, r.LABEL_PR `REGION_LABEL_PR`,
	ds.DATA_SOURCE_ID, ds.LABEL_ID `DATA_SOURCE_LABEL_ID`, ds.LABEL_EN `DATA_SOURCE_LABEL_EN`, ds.LABEL_FR `DATA_SOURCE_LABEL_FR`, ds.LABEL_SP `DATA_SOURCE_LABEL_SP`, ds.LABEL_PR `DATA_SOURCE_LABEL_PR`
    FROM (SELECT it.INVENTORY_ID, MAX(it.VERSION_ID) MAX_VERSION_ID FROM rm_inventory i LEFT JOIN rm_inventory_trans it ON i.INVENTORY_ID=it.INVENTORY_ID WHERE (@varVersionId=-1 OR it.VERSION_ID<=@varVersionId) AND FIND_IN_SET(i.PROGRAM_ID, @varProgramIds) AND FIND_IN_SET(it.REALM_COUNTRY_PLANNING_UNIT_ID, @varRealmCountryPlanningUnitIds) GROUP BY it.INVENTORY_ID) tc 
    LEFT JOIN rm_inventory i ON tc.INVENTORY_ID=i.INVENTORY_ID
    LEFT JOIN rm_inventory_trans it ON tc.INVENTORY_ID=it.INVENTORY_ID AND tc.MAX_VERSION_ID=it.VERSION_ID
    LEFT JOIN rm_realm_country_planning_unit rcpu ON it.REALM_COUNTRY_PLANNING_UNIT_ID=rcpu.REALM_COUNTRY_PLANNING_UNIT_ID
    LEFT JOIN vw_program p ON i.PROGRAM_ID=p.PROGRAM_ID
    LEFT JOIN vw_planning_unit pu ON rcpu.PLANNING_UNIT_ID=pu.PLANNING_UNIT_ID
    LEFT JOIN vw_region r ON it.REGION_ID=r.REGION_ID
    LEFT JOIN vw_data_source ds ON it.DATA_SOURCE_ID=ds.DATA_SOURCE_ID
    WHERE it.INVENTORY_DATE BETWEEN @startDate AND @stopDate AND it.ACTIVE AND ((@varViewBy=1 AND FIND_IN_SET(rcpu.PLANNING_UNIT_ID, @varReportingUnitIds)) OR (@varViewBy=1 AND FIND_IN_SET(it.REALM_COUNTRY_PLANNING_UNIT_ID, @varReportingUnitIds))) 
    ORDER BY it.INVENTORY_DATE,p.PROGRAM_CODE,pu.LABEL_EN,it.REGION_ID,i.INVENTORY_ID;
END
