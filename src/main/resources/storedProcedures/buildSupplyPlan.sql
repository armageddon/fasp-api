CREATE DEFINER=`faspUser`@`localhost` PROCEDURE `buildSupplyPlan`(PROGRAM_ID INT(10), VERSION_ID INT(10))
BEGIN
	SET @programId = PROGRAM_Id;
    SET @versionId = VERSION_ID;
    SET @cb = 0;
    
    DELETE spbi.* FROM rm_supply_plan_batch_info spbi WHERE spbi.PROGRAM_ID=@programId AND spbi.VERSION_ID=@versionId;
    DELETE sp.* FROM rm_supply_plan sp WHERE sp.PROGRAM_ID=@programId AND sp.VERSION_ID=@versionId;
    
	INSERT INTO rm_supply_plan (SUPPLY_PLAN_ID, VERSION_ID, PROGRAM_ID, PLANNING_UNIT_ID, TRANS_DATE, BATCH_ID, FORECASTED_CONSUMPTION_QTY, ACTUAL_CONSUMPTION_QTY, SHIPMENT_QTY, ADJUSTMENT_MULTIPLIED_QTY, ACTUAL_MULTIPLIED_QTY, OPENING_BALANCE, CLOSING_BALANCE)
	SELECT null, 1, oc.PROGRAM_ID, oc.PLANNING_UNIT_ID, oc.TRANS_DATE, oc.BATCH_ID, oc.FORECASTED_CONSUMPTION, oc.ACTUAL_CONSUMPTION, oc.SHIPMENT_QTY, oc.ADJUSTMENT_MULTIPLIED_QTY, oc.ACTUAL_MULTIPLIED_QTY, @cb, @cb:=@cb-oc.FORECASTED_CONSUMPTION-oc.ACTUAL_CONSUMPTION+oc.SHIPMENT_QTY+oc.ADJUSTMENT_MULTIPLIED_QTY FROM (
	SELECT o.PROGRAM_ID, o.PLANNING_UNIT_ID, DATE(CONCAT(o.TRANS_DATE,"-01")) `TRANS_DATE`, o.BATCH_ID, SUM(IFNULL(o.FORECASTED_CONSUMPTION,0)) `FORECASTED_CONSUMPTION`, SUM(IFNULL(o.ACTUAL_CONSUMPTION,0)) `ACTUAL_CONSUMPTION`, SUM(IFNULL(o.SHIPMENT_QTY,0)) `SHIPMENT_QTY`, SUM(IFNULL(o.ADJUSTMENT_MULTIPLIED_QTY,0)) `ADJUSTMENT_MULTIPLIED_QTY`, SUM(IFNULL(o.ACTUAL_MULTIPLIED_QTY,0)) `ACTUAL_MULTIPLIED_QTY` FROM (
		-- Consumption
		SELECT '2' `TRANS_TYPE`, c1.PROGRAM_ID, c1.CONSUMPTION_ID `TRANS_ID`, c1.PLANNING_UNIT_ID, LEFT(c1.CONSUMPTION_DATE, 7) `TRANS_DATE`, c1.BATCH_ID, c1.EXPIRY_DATE, SUM(FORECASTED_CONSUMPTION) `FORECASTED_CONSUMPTION`, SUM(ACTUAL_CONSUMPTION) `ACTUAL_CONSUMPTION`, null `SHIPMENT_QTY`, null  `ADJUSTMENT_MULTIPLIED_QTY`, null  `ACTUAL_MULTIPLIED_QTY` FROM (
		SELECT c.PROGRAM_ID, c.CONSUMPTION_ID, ct.REGION_ID, ct.PLANNING_UNIT_ID, ct.CONSUMPTION_DATE, ca.ACTUAL, ifnull(ctbi.BATCH_ID,0) `BATCH_ID`, ifnull(bi.EXPIRY_DATE,@defaultExpDate) `EXPIRY_DATE`, ct.ACTIVE, SUM(IF(ct.ACTUAL_FLAG=1, COALESCE(ctbi.CONSUMPTION_QTY, ct.CONSUMPTION_QTY),null)) `ACTUAL_CONSUMPTION`, SUM(IF(ct.ACTUAL_FLAG=0, COALESCE(ctbi.CONSUMPTION_QTY, ct.CONSUMPTION_QTY),null)) `FORECASTED_CONSUMPTION`
			FROM (
				SELECT c.CONSUMPTION_ID, MAX(ct.VERSION_ID) MAX_VERSION_ID 
				FROM rm_consumption c 
				LEFT JOIN rm_consumption_trans ct ON c.CONSUMPTION_ID=ct.CONSUMPTION_ID 
				WHERE c.PROGRAM_ID=@programId AND ct.VERSION_ID<=@versionId AND ct.CONSUMPTION_TRANS_ID IS NOT NULL AND ct.ACTIVE GROUP BY c.CONSUMPTION_ID
			) tc 
		LEFT JOIN rm_consumption c ON c.CONSUMPTION_ID=tc.CONSUMPTION_ID
		LEFT JOIN rm_consumption_trans ct ON c.CONSUMPTION_ID=ct.CONSUMPTION_ID AND tc.MAX_VERSION_ID=ct.VERSION_ID
		LEFT JOIN (SELECT ct.PLANNING_UNIT_ID, ct.CONSUMPTION_DATE, bit_OR(ct.ACTUAL_FLAG=1 AND ct.CONSUMPTION_QTY>0) ACTUAL FROM (SELECT c.CONSUMPTION_ID, MAX(ct.VERSION_ID) MAX_VERSION_ID  FROM rm_consumption c LEFT JOIN rm_consumption_trans ct ON c.CONSUMPTION_ID=ct.CONSUMPTION_ID WHERE c.PROGRAM_ID=@programId AND ct.VERSION_ID<=@versionId AND ct.CONSUMPTION_TRANS_ID IS NOT NULL AND ct.ACTIVE GROUP BY c.CONSUMPTION_ID) tc LEFT JOIN rm_consumption c ON c.CONSUMPTION_ID=tc.CONSUMPTION_ID LEFT JOIN rm_consumption_trans ct ON c.CONSUMPTION_ID=ct.CONSUMPTION_ID AND tc.MAX_VERSION_ID=ct.VERSION_ID GROUP BY ct.PLANNING_UNIT_ID, ct.CONSUMPTION_DATE) ca ON ct.PLANNING_UNIT_ID=ca.PLANNING_UNIT_ID AND ct.CONSUMPTION_DATE=ca.CONSUMPTION_DATE and ct.ACTUAL_FLAG=ca.ACTUAL
		LEFT JOIN rm_consumption_trans_batch_info ctbi ON ct.CONSUMPTION_TRANS_ID=ctbi.CONSUMPTION_TRANS_ID
		LEFT JOIN rm_batch_info bi ON ctbi.BATCH_ID=bi.BATCH_ID
		GROUP BY c.PROGRAM_ID, ct.REGION_ID, ct.PLANNING_UNIT_ID, ct.CONSUMPTION_DATE, ifnull(ctbi.BATCH_ID,0)) c1 WHERE c1.ACTUAL IS NOT NULL GROUP BY c1.PROGRAM_ID, c1.PLANNING_UNIT_ID, c1.CONSUMPTION_DATE, c1.BATCH_ID

		UNION 
		-- Shipment
		SELECT '1' `TRANS_TYPE`, s.PROGRAM_ID, s.SHIPMENT_ID `TRANS_ID`, st.PLANNING_UNIT_ID, LEFT(COALESCE(st.DELIVERED_DATE, st.EXPECTED_DELIVERY_DATE),7) `TRANS_DATE`, ifnull(stbi.BATCH_ID,0) `BATCH_ID`, ifnull(bi.EXPIRY_DATE, @defaultExpDate) `EXPIRY_DATE`, null `FORECASTED_CONSUMPTION`, null `ACTUAL_CONSUMPTION`, SUM(COALESCE(stbi.BATCH_SHIPMENT_QTY ,st.SHIPMENT_QTY)) `SHIPMENT_QTY`, null  `ADJUSTMENT_MULTIPLIED_QTY`, null  `ACTUAL_MULTIPLIED_QTY`
			FROM (
				SELECT s.PROGRAM_ID, s.SHIPMENT_ID, MAX(st.VERSION_ID) MAX_VERSION_ID 
				FROM rm_shipment s 
				LEFT JOIN rm_shipment_trans st ON s.SHIPMENT_ID=st.SHIPMENT_ID 
				WHERE s.PROGRAM_ID=@programId AND st.VERSION_ID<=@versionId AND st.SHIPMENT_TRANS_ID IS NOT NULL AND st.ACTIVE AND s.ACCOUNT_FLAG GROUP BY s.SHIPMENT_ID
			) ts
		LEFT JOIN rm_shipment s ON s.SHIPMENT_ID=ts.SHIPMENT_ID
		LEFT JOIN rm_shipment_trans st ON s.SHIPMENT_ID=st.SHIPMENT_ID AND ts.MAX_VERSION_ID=st.VERSION_ID
		LEFT JOIN rm_shipment_trans_batch_info stbi ON st.SHIPMENT_TRANS_ID=stbi.SHIPMENT_TRANS_ID
		LEFT JOIN rm_batch_info bi ON stbi.BATCH_ID=bi.BATCH_ID
		GROUP BY s.PROGRAM_ID, st.PLANNING_UNIT_ID, COALESCE(st.DELIVERED_DATE, st.EXPECTED_DELIVERY_DATE), ifnull(stbi.BATCH_ID,0)

		UNION 
		-- Inventory
		SELECT '3' `TRANS_TYPE`, i.PROGRAM_ID, i.INVENTORY_ID `TRANS_ID`, rcpu.PLANNING_UNIT_ID, LEFT(it.INVENTORY_DATE,7) `TRANS_DATE`, ifnull(itbi.BATCH_ID,0) `BATCH_ID`, IFNULL(bi.EXPIRY_DATE, @defaultExpDate) `EXPIRY_DATE`, null `FORECASTED_CONSUMPTION`, null `ACTUAL_CONSUMPTION`, null `SHIPMENT_QTY`, SUM(COALESCE(itbi.ADJUSTMENT_QTY, it.ADJUSTMENT_QTY)*rcpu.MULTIPLIER) `ADJUSTMENT_MULTIPLIED_QTY`, SUM(COALESCE(itbi.ACTUAL_QTY, it.ACTUAL_QTY)*rcpu.MULTIPLIER) `ACTUAL_MULTIPLIED_QTY` 
		FROM (
				SELECT i.PROGRAM_ID, i.INVENTORY_ID, MAX(it.VERSION_ID) MAX_VERSION_ID 
				FROM rm_inventory i 
				LEFT JOIN rm_inventory_trans it ON i.INVENTORY_ID=it.INVENTORY_ID 
				WHERE i.PROGRAM_ID=@programId AND it.VERSION_ID<=@versionId AND it.INVENTORY_TRANS_ID IS NOT NULL AND it.ACTIVE GROUP BY i.INVENTORY_ID
			) ti 
		LEFT JOIN rm_inventory i ON i.INVENTORY_ID=ti.INVENTORY_ID
		LEFT JOIN rm_inventory_trans it ON i.INVENTORY_ID=it.INVENTORY_ID AND ti.MAX_VERSION_ID=it.VERSION_ID
		LEFT JOIN rm_inventory_trans_batch_info itbi ON it.INVENTORY_TRANS_ID=itbi.INVENTORY_TRANS_ID
		LEFT JOIN rm_batch_info bi ON itbi.BATCH_ID=bi.BATCH_ID
		LEFT JOIN rm_realm_country_planning_unit rcpu ON it.REALM_COUNTRY_PLANNING_UNIT_ID=rcpu.REALM_COUNTRY_PLANNING_UNIT_ID
		GROUP BY i.PROGRAM_ID, rcpu.PLANNING_UNIT_ID, it.INVENTORY_DATE, ifnull(itbi.BATCH_ID,0)
	) AS o GROUP BY o.PROGRAM_ID, o.PLANNING_UNIT_ID, o.TRANS_DATE, o.BATCH_ID 
	) oc;
    
    -- SET the Min and Max Date Range
    SELECT MIN(sp.TRANS_DATE), MAX(sp.TRANS_DATE) into @startMonth, @stopMonth FROM rm_supply_plan sp WHERE sp.PROGRAM_ID=@programId and sp.VERSION_ID=@versionId;
    
    -- Populate the supplyPlan table with a record for every batch for every month
    SET @cb = 0;
	SET @oldBatchId = -1;
-- 	INSERT INTO rm_supply_plan_batch_info (PROGRAM_ID, VERSION_ID, BATCH_ID, TRANS_DATE, EXPIRY_DATE, SHIPMENT_QTY, ACTUAL_CONSUMPTION_QTY, FORECASTED_CONSUMPTION_QTY, ADJUSTMENT_MULTIPLIED_QTY, OPENING_BALANCE, CLOSING_BALANCE, EXPIRED_STOCK, EXPIRED_CONSUMPTION, FINAL_OPENING_BALANCE, FINAL_CLOSING_BALANCE)
-- 		SELECT spc2.PROGRAM_ID, spc2.VERSION_ID, spc2.BATCH_ID, spc2.TRANS_DATE, spc2.EXPIRY_DATE, spc2.SHIPMENT_QTY, spc2.ACTUAL_CONSUMPTION_QTY, spc2.FORECASTED_CONSUMPTION_QTY, spc2.ADJUSTMENT_MULTIPLIED_QTY, spc2.OB, spc2.CB, spc2.EXPIRED_STOCK, spc2.EXPIRED_CONSUMPTION, spc2.OB, spc2.CB
-- 		FROM (SELECT spc.*, IF(@oldBatchId!=spc.BATCH_ID, @cb:=0, @cb:=@cb) `OB`, IF(spc.TRANS_DATE>=spc.EXPIRY_DATE, @cb, 0) `EXPIRED_STOCK`,IF(spc.TRANS_DATE>=spc.EXPIRY_DATE,spc.ACTUAL_CONSUMPTION_QTY,0) `EXPIRED_CONSUMPTION`, @cb:=@cb+spc.SHIPMENT_QTY-IF(spc.TRANS_DATE>=spc.EXPIRY_DATE,0,spc.ACTUAL_CONSUMPTION_QTY)+spc.ADJUSTMENT_MULTIPLIED_QTY-IF(spc.TRANS_DATE>=spc.EXPIRY_DATE, @cb, 0) `CB`, @oldBatchId := spc.BATCH_ID FROM (SELECT sp.PROGRAM_ID, sp.VERSION_ID, sp.BATCH_ID, sp.TRANS_DATE, IFNULL(bi.EXPIRY_DATE, '2099-12-31') EXPIRY_DATE, sp.SHIPMENT_QTY, sp.ACTUAL_CONSUMPTION_QTY, sp.ADJUSTMENT_MULTIPLIED_QTY, sp.FORECASTED_CONSUMPTION_QTY FROM rm_supply_plan sp LEFT JOIN rm_batch_info bi ON sp.BATCH_ID=bi.BATCH_ID ORDER BY sp.BATCH_ID, sp.TRANS_DATE, sp.SHIPMENT_QTY) spc) spc2;
	INSERT INTO rm_supply_plan_batch_info (PROGRAM_ID, VERSION_ID, BATCH_ID, TRANS_DATE, EXPIRY_DATE, SHIPMENT_QTY, ACTUAL_CONSUMPTION_QTY, FORECASTED_CONSUMPTION_QTY, ADJUSTMENT_MULTIPLIED_QTY, OPENING_BALANCE, CLOSING_BALANCE, EXPIRED_STOCK, EXPIRED_CONSUMPTION, FINAL_OPENING_BALANCE, FINAL_CLOSING_BALANCE)
	SELECT spc2.PROGRAM_ID, spc2.VERSION_ID, spc2.BATCH_ID, spc2.TRANS_DATE, spc2.EXPIRY_DATE, spc2.SHIPMENT_QTY, spc2.ACTUAL_CONSUMPTION_QTY, spc2.FORECASTED_CONSUMPTION_QTY, spc2.ADJUSTMENT_MULTIPLIED_QTY, spc2.OB, spc2.CB, spc2.EXPIRED_STOCK, spc2.EXPIRED_CONSUMPTION, spc2.OB, spc2.CB
 		FROM 
			(
			SELECT 
				spc.*, 
				IF(@oldBatchId!=spc.BATCH_ID, @cb:=0, @cb:=@cb) `OB`, IF(spc.TRANS_DATE>=spc.EXPIRY_DATE, @cb, 0) `EXPIRED_STOCK`,
				IF(spc.TRANS_DATE>=spc.EXPIRY_DATE,spc.ACTUAL_CONSUMPTION_QTY,0) `EXPIRED_CONSUMPTION`, @cb:=@cb+spc.SHIPMENT_QTY-IF(spc.TRANS_DATE>=spc.EXPIRY_DATE,0,spc.ACTUAL_CONSUMPTION_QTY)+spc.ADJUSTMENT_MULTIPLIED_QTY-IF(spc.TRANS_DATE>=spc.EXPIRY_DATE, @cb, 0) `CB`, 
				@oldBatchId := spc.BATCH_ID 
			FROM 
				(
				SELECT 
					@programId `PROGRAM_ID`, @versionId `VERSION_ID`, m3.BATCH_ID, m3.MONTH `TRANS_DATE`, IFNULL(bi.EXPIRY_DATE, '2099-12-31') EXPIRY_DATE, IFNULL(sp.SHIPMENT_QTY,0) `SHIPMENT_QTY`, 
					IFNULL(sp.ACTUAL_CONSUMPTION_QTY, 0) `ACTUAL_CONSUMPTION_QTY`, IFNULL(sp.ADJUSTMENT_MULTIPLIED_QTY,0) `ADJUSTMENT_MULTIPLIED_QTY`, IFNULL(sp.FORECASTED_CONSUMPTION_QTY,0) `FORECASTED_CONSUMPTION_QTY` 
				FROM 
					(
					SELECT 
						m.BATCH_ID, 
                        mn.MONTH 
					FROM 
						(
                        SELECT 
							sp.BATCH_ID 
						FROM rm_supply_plan sp 
                        WHERE sp.PROGRAM_ID=@programId and sp.VERSION_ID=@versionId 
                        GROUP BY sp.BATCH_ID
					) m JOIN mn ON mn.MONTH BETWEEN @startMonth AND @stopMonth
				) m3 
				LEFT JOIN rm_supply_plan sp ON m3.BATCH_ID=sp.BATCH_ID AND m3.MONTH=sp.TRANS_DATE
				LEFT JOIN rm_batch_info bi ON m3.BATCH_ID=bi.BATCH_ID 
				ORDER BY IF(m3.BATCH_ID=0,9999999999,m3.BATCH_ID), `TRANS_DATE`, `SHIPMENT_QTY`
			) spc
		) spc2;
	CALL buildStockBalances(@programId, @versionId);
END
