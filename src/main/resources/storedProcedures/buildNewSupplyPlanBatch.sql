CREATE DEFINER=`faspUser`@`%` PROCEDURE `buildNewSupplyPlanBatch`(VAR_PROGRAM_ID INT(10), VAR_VERSION_ID INT(10))
BEGIN
    SET @programId = VAR_PROGRAM_ID;
    SET @versionId = VAR_VERSION_ID;
    
        SELECT 
        o.PROGRAM_ID, @versionId, o.PLANNING_UNIT_ID, DATE(CONCAT(o.TRANS_DATE,"-01")) `TRANS_DATE`, o.BATCH_ID, o.EXPIRY_DATE, o.SHELF_LIFE,
        SUM(o.FORECASTED_CONSUMPTION) `FORECASTED_CONSUMPTION`, SUM(o.ACTUAL_CONSUMPTION) `ACTUAL_CONSUMPTION`, 
        SUM(o.SHIPMENT) `SHIPMENT`, SUM(o.SHIPMENT_WPS) `SHIPMENT_WPS`, SUM(o.ADJUSTMENT) `ADJUSTMENT`, SUM(o.STOCK) `STOCK`, SUM(o.INVENTORY_QTY) `INVENTORY_QTY`  
        FROM ( 
            SELECT 
            tc.PROGRAM_ID, tc.CONSUMPTION_ID `TRANS_ID`, tc.PLANNING_UNIT_ID, LEFT(tc.CONSUMPTION_DATE, 7) `TRANS_DATE`, tc.BATCH_ID, tc.EXPIRY_DATE `EXPIRY_DATE`, tc.SHELF_LIFE,
            SUM(FORECASTED_CONSUMPTION) `FORECASTED_CONSUMPTION`, SUM(ACTUAL_CONSUMPTION) `ACTUAL_CONSUMPTION`, 
            null `SHIPMENT`, null `SHIPMENT_WPS`,null `ADJUSTMENT`, null  `STOCK`, 0 `INVENTORY_QTY` 
            FROM (
                SELECT 
                    c.PROGRAM_ID, c.CONSUMPTION_ID, ct.REGION_ID, ct.PLANNING_UNIT_ID, ct.CONSUMPTION_DATE, 
                    ctbi.BATCH_ID `BATCH_ID`, bi.EXPIRY_DATE, IFNULL(ppu.SHELF_LIFE,24) `SHELF_LIFE`,
                    SUM(IF(ct.ACTUAL_FLAG=1, COALESCE(ROUND(ctbi.CONSUMPTION_QTY * IF(rcpu.CONVERSION_METHOD IS NULL OR rcpu.CONVERSION_METHOD=1, rcpu.CONVERSION_NUMBER, IF(rcpu.CONVERSION_METHOD=2,1/rcpu.CONVERSION_NUMBER,0))), ct.CONSUMPTION_QTY), null)) `ACTUAL_CONSUMPTION`, 
                    SUM(IF(ct.ACTUAL_FLAG=0, COALESCE(ROUND(ctbi.CONSUMPTION_QTY * IF(rcpu.CONVERSION_METHOD IS NULL OR rcpu.CONVERSION_METHOD=1, rcpu.CONVERSION_NUMBER, IF(rcpu.CONVERSION_METHOD=2,1/rcpu.CONVERSION_NUMBER,0))), ct.CONSUMPTION_QTY), null)) `FORECASTED_CONSUMPTION`
                FROM (
                    SELECT c.CONSUMPTION_ID, MAX(ct.VERSION_ID) MAX_VERSION_ID FROM rm_consumption c LEFT JOIN rm_consumption_trans ct ON c.CONSUMPTION_ID=ct.CONSUMPTION_ID WHERE c.PROGRAM_ID=@programId AND ct.VERSION_ID<=@versionId AND ct.CONSUMPTION_TRANS_ID IS NOT NULL GROUP BY c.CONSUMPTION_ID
                ) tc
                LEFT JOIN rm_consumption c ON c.CONSUMPTION_ID=tc.CONSUMPTION_ID
                LEFT JOIN rm_consumption_trans ct ON c.CONSUMPTION_ID=ct.CONSUMPTION_ID AND tc.MAX_VERSION_ID=ct.VERSION_ID
                LEFT JOIN rm_consumption_trans_batch_info ctbi ON ct.CONSUMPTION_TRANS_ID=ctbi.CONSUMPTION_TRANS_ID
                LEFT JOIN rm_batch_info bi ON ctbi.BATCH_ID=bi.BATCH_ID
                LEFT JOIN rm_realm_country_planning_unit rcpu ON ct.REALM_COUNTRY_PLANNING_UNIT_ID=rcpu.REALM_COUNTRY_PLANNING_UNIT_ID
                LEFT JOIN rm_program_planning_unit ppu ON c.PROGRAM_ID=ppu.PROGRAM_ID AND ct.PLANNING_UNIT_ID=ppu.PLANNING_UNIT_ID
                WHERE ct.ACTIVE AND ctbi.BATCH_ID IS NOT NULL AND ppu.PLANNING_UNIT_ID IS NOT NULL 
                GROUP BY c.PROGRAM_ID, ct.REGION_ID, ct.PLANNING_UNIT_ID, ct.CONSUMPTION_DATE, ctbi.BATCH_ID
            ) tc 
            GROUP BY tc.PROGRAM_ID, tc.PLANNING_UNIT_ID, tc.CONSUMPTION_DATE, tc.BATCH_ID

            UNION

            SELECT 
                s.PROGRAM_ID, s.SHIPMENT_ID `TRANS_ID`, st.PLANNING_UNIT_ID, LEFT(COALESCE(st.RECEIVED_DATE, st.EXPECTED_DELIVERY_DATE),7) `TRANS_DATE`, stbi.BATCH_ID, bi.EXPIRY_DATE, IFNULL(ppu.SHELF_LIFE,24) `SHELF_LIFE`,
                null `FORECASTED_CONSUMPTION`, null `ACTUAL_CONSUMPTION`, 
                SUM(IF(st.SHIPMENT_STATUS_ID IN (1,3,4,5,6,7,9), COALESCE(ROUND(stbi.BATCH_SHIPMENT_QTY * IF(rcpu.CONVERSION_METHOD IS NULL OR rcpu.CONVERSION_METHOD=1, rcpu.CONVERSION_NUMBER, IF(rcpu.CONVERSION_METHOD=2,1/rcpu.CONVERSION_NUMBER,0))) ,st.SHIPMENT_QTY),0)) `SHIPMENT`, 
                SUM(IF(st.SHIPMENT_STATUS_ID IN (3,4,5,6,7,9), COALESCE(ROUND(stbi.BATCH_SHIPMENT_QTY * IF(rcpu.CONVERSION_METHOD IS NULL OR rcpu.CONVERSION_METHOD=1, rcpu.CONVERSION_NUMBER, IF(rcpu.CONVERSION_METHOD=2,1/rcpu.CONVERSION_NUMBER,0))) ,st.SHIPMENT_QTY), 0)) `SHIPMENT_WPS`, 
                null  `ADJUSTMENT_MULTIPLIED_QTY`, null  `STOCK_MULTIPLIED_QTY`, 0 `INVENTORY_QTY` 
            FROM (
                SELECT s.PROGRAM_ID, s.SHIPMENT_ID, MAX(st.VERSION_ID) MAX_VERSION_ID FROM rm_shipment s LEFT JOIN rm_shipment_trans st ON s.SHIPMENT_ID=st.SHIPMENT_ID WHERE s.PROGRAM_ID=@programId AND st.VERSION_ID<=@versionId AND st.SHIPMENT_TRANS_ID IS NOT NULL GROUP BY s.SHIPMENT_ID
            ) ts
            LEFT JOIN rm_shipment s ON s.SHIPMENT_ID=ts.SHIPMENT_ID
            LEFT JOIN rm_shipment_trans st ON s.SHIPMENT_ID=st.SHIPMENT_ID AND ts.MAX_VERSION_ID=st.VERSION_ID
            LEFT JOIN rm_shipment_trans_batch_info stbi ON st.SHIPMENT_TRANS_ID=stbi.SHIPMENT_TRANS_ID
            LEFT JOIN rm_batch_info bi ON stbi.BATCH_ID=bi.BATCH_ID
            LEFT JOIN rm_realm_country_planning_unit rcpu ON st.REALM_COUNTRY_PLANNING_UNIT_ID=rcpu.REALM_COUNTRY_PLANNING_UNIT_ID
            LEFT JOIN rm_program_planning_unit ppu ON s.PROGRAM_ID=ppu.PROGRAM_ID AND st.PLANNING_UNIT_ID=ppu.PLANNING_UNIT_ID
            WHERE st.ACTIVE AND st.ACCOUNT_FLAG AND st.SHIPMENT_STATUS_ID!=8 AND stbi.BATCH_ID IS NOT NULL  AND ppu.PLANNING_UNIT_ID IS NOT NULL 
            GROUP BY s.PROGRAM_ID, st.PLANNING_UNIT_ID, COALESCE(st.RECEIVED_DATE, st.EXPECTED_DELIVERY_DATE), stbi.BATCH_ID

            UNION

            SELECT 
                i.PROGRAM_ID, i.INVENTORY_ID `TRANS_ID`, rcpu.PLANNING_UNIT_ID, LEFT(it.INVENTORY_DATE,7) `TRANS_DATE`, itbi.BATCH_ID, bi.EXPIRY_DATE, IFNULL(ppu.SHELF_LIFE,24) `SHELF_LIFE`,
                null `FORECASTED_CONSUMPTION`, null `ACTUAL_CONSUMPTION`, 
                null `SHIPMENT`, null `SHIPMENT_WPS`, SUM(COALESCE(itbi.ADJUSTMENT_QTY, it.ADJUSTMENT_QTY)*IF(rcpu.CONVERSION_METHOD IS NULL OR rcpu.CONVERSION_METHOD=1, rcpu.CONVERSION_NUMBER, IF(rcpu.CONVERSION_METHOD=2,1/rcpu.CONVERSION_NUMBER,0))) `ADJUSTMENT`,  SUM(COALESCE(itbi.ACTUAL_QTY, it.ACTUAL_QTY)*IF(rcpu.CONVERSION_METHOD IS NULL OR rcpu.CONVERSION_METHOD=1, rcpu.CONVERSION_NUMBER, IF(rcpu.CONVERSION_METHOD=2,1/rcpu.CONVERSION_NUMBER,0))) `STOCK`, 0 `INVENTORY_QTY` 
            FROM (
                SELECT i.PROGRAM_ID, i.INVENTORY_ID, MAX(it.VERSION_ID) MAX_VERSION_ID FROM rm_inventory i LEFT JOIN rm_inventory_trans it ON i.INVENTORY_ID=it.INVENTORY_ID WHERE i.PROGRAM_ID=@programId AND it.VERSION_ID<=@versionId AND it.INVENTORY_TRANS_ID IS NOT NULL GROUP BY i.INVENTORY_ID
            ) ti
            LEFT JOIN rm_inventory i ON i.INVENTORY_ID=ti.INVENTORY_ID
            LEFT JOIN rm_inventory_trans it ON i.INVENTORY_ID=it.INVENTORY_ID AND ti.MAX_VERSION_ID=it.VERSION_ID
            LEFT JOIN rm_inventory_trans_batch_info itbi ON it.INVENTORY_TRANS_ID=itbi.INVENTORY_TRANS_ID
            LEFT JOIN rm_batch_info bi ON itbi.BATCH_ID=bi.BATCH_ID
            LEFT JOIN rm_realm_country_planning_unit rcpu ON it.REALM_COUNTRY_PLANNING_UNIT_ID=rcpu.REALM_COUNTRY_PLANNING_UNIT_ID
            LEFT JOIN rm_program_planning_unit ppu ON i.PROGRAM_ID=ppu.PROGRAM_ID AND rcpu.PLANNING_UNIT_ID=ppu.PLANNING_UNIT_ID
            WHERE it.ACTIVE AND itbi.BATCH_ID IS NOT NULL AND ppu.PLANNING_UNIT_ID IS NOT NULL 
            GROUP BY i.PROGRAM_ID, rcpu.PLANNING_UNIT_ID, it.INVENTORY_DATE, itbi.BATCH_ID

            UNION

            SELECT 
                bi.PROGRAM_ID, bi.BATCH_INVENTORY_ID `TRANS_ID`, bi.PLANNING_UNIT_ID, LEFT(bi.INVENTORY_DATE,7) `TRANS_DATE`, bt.BATCH_ID, rm_batch_info.EXPIRY_DATE, IFNULL(ppu.SHELF_LIFE,24) `SHELF_LIFE`,
                null `FORECASTED_CONSUMPTION`, null `ACTUAL_CONSUMPTION`, 
                null `SHIPMENT`, null `SHIPMENT_WPS`, null `ADJUSTMENT`,  null `STOCK`, bt.QTY `INVENTORY_QTY` 
            FROM (
                SELECT bi.PROGRAM_ID, bi.BATCH_INVENTORY_ID, MAX(bt.VERSION_ID) MAX_VERSION_ID FROM rm_batch_inventory bi LEFT JOIN rm_batch_inventory_trans bt ON bi.BATCH_INVENTORY_ID=bt.BATCH_INVENTORY_ID WHERE bi.PROGRAM_ID=@programId AND bt.VERSION_ID<=@versionId AND bt.BATCH_INVENTORY_TRANS_ID IS NOT NULL GROUP BY bi.BATCH_INVENTORY_ID
            ) tbi
            LEFT JOIN rm_batch_inventory bi ON bi.BATCH_INVENTORY_ID=tbi.BATCH_INVENTORY_ID
            LEFT JOIN rm_batch_inventory_trans bt ON bt.BATCH_INVENTORY_ID=bi.BATCH_INVENTORY_ID AND bt.VERSION_ID=tbi.MAX_VERSION_ID
            LEFT JOIN rm_batch_info ON bt.BATCH_ID=rm_batch_info.BATCH_ID
            LEFT JOIN rm_program_planning_unit ppu ON bi.PROGRAM_ID=ppu.PROGRAM_ID AND bi.PLANNING_UNIT_ID=ppu.PLANNING_UNIT_ID            
            WHERE bt.ACTIVE
        ) AS o 
        GROUP BY o.PROGRAM_ID, o.PLANNING_UNIT_ID, o.TRANS_DATE, o.BATCH_ID ORDER BY o.PROGRAM_ID, o.PLANNING_UNIT_ID, o.TRANS_DATE, IFNULL(o.EXPIRY_DATE,'2999-12-31');

END
