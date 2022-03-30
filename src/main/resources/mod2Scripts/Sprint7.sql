/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
/**
 * Author:  altius
 * Created: 28-Mar-2022
 */

INSERT INTO fasp.ap_static_label(STATIC_LABEL_ID,LABEL_CODE,ACTIVE) VALUES ( NULL,'static.placeholder.placeholder','1');
SELECT MAX(l.STATIC_LABEL_ID) INTO @MAX FROM ap_static_label l ;

INSERT INTO ap_static_label_languages VALUES(NULL,@MAX,1,'[Placeholder]');-- en
INSERT INTO ap_static_label_languages VALUES(NULL,@MAX,2,'[Espace réservé]');-- fr
INSERT INTO ap_static_label_languages VALUES(NULL,@MAX,3,'[Marcador de posición]');-- sp
INSERT INTO ap_static_label_languages VALUES(NULL,@MAX,4,'[Espaço reservado]');-- pr


INSERT INTO fasp.ap_static_label(STATIC_LABEL_ID,LABEL_CODE,ACTIVE) VALUES ( NULL,'static.placeholder.monthlyForecastReport','1');
SELECT MAX(l.STATIC_LABEL_ID) INTO @MAX FROM ap_static_label l ;

INSERT INTO ap_static_label_languages VALUES(NULL,@MAX,1,'This report aggregates regional forecasts. For disaggregated regional forecasts, export CSV.');-- en
INSERT INTO ap_static_label_languages VALUES(NULL,@MAX,2,'Ce rapport regroupe les prévisions régionales. Pour les prévisions régionales désagrégées, exportez CSV.');-- fr
INSERT INTO ap_static_label_languages VALUES(NULL,@MAX,3,'Este informe agrega pronósticos regionales. Para pronósticos regionales desagregados, exporte CSV.');-- sp
INSERT INTO ap_static_label_languages VALUES(NULL,@MAX,4,'Este relatório agrega previsões regionais. Para previsões regionais desagregadas, exporte CSV.');-- pr

USE `fasp`;
DROP procedure IF EXISTS `getMonthlyForecast`;

DELIMITER $$
USE `fasp`$$
CREATE DEFINER=`faspUser`@`%` PROCEDURE `getMonthlyForecast`(VAR_PROGRAM_ID INT(10), VAR_VERSION_ID INT(10), VAR_START_MONTH DATE, VAR_STOP_MONTH DATE, VAR_REPORT_VIEW INT, VAR_UNIT_IDS TEXT)
BEGIN

    -- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    -- Mod 2 Report no 1 - MonthlyForecast
    -- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    -- programId must be a single Program
    -- versionId must be the actual version 
    -- startMonth is the month from which you want the consumption data 
    -- stopMonth is the month till which you want the consumption data 
    -- reportView 1 = PU view, 2 = FU View  
    -- unitIdsList -- List of the PU Id's or FU Id's that you want the report for

    SET @programId = VAR_PROGRAM_ID;
    SET @versionId = VAR_VERSION_ID;
    SET @startMonth = VAR_START_MONTH;
    SET @stopMonth = VAR_STOP_MONTH;
    SET @reportView = VAR_REPORT_VIEW;
    SET @unitIdList = VAR_UNIT_IDS;
    
    IF @reportView = 1 THEN
        SELECT 
            pu.PLANNING_UNIT_ID, pu.LABEL_ID `PU_LABEL_ID`, pu.LABEL_EN `PU_LABEL_EN`, pu.LABEL_FR `PU_LABEL_FR`, pu.LABEL_SP `PU_LABEL_SP`, pu.LABEL_PR `PU_LABEL_PR`, pu.MULTIPLIER,
            fu.FORECASTING_UNIT_ID, fu.LABEL_ID `FU_LABEL_ID`, fu.LABEL_EN `FU_LABEL_EN`, fu.LABEL_FR `FU_LABEL_FR`, fu.LABEL_SP `FU_LABEL_SP`, fu.LABEL_PR `FU_LABEL_PR`,
            r.REGION_ID, r.LABEL_ID `R_LABEL_ID`, r.LABEL_EN `R_LABEL_EN`, r.LABEL_FR `R_LABEL_FR`, r.LABEL_SP `R_LABEL_SP`, r.LABEL_PR `R_LABEL_PR`,
            dpus.TREE_ID, dpus.SCENARIO_ID, mom.MONTH, mom.CALCULATED_MMD_VALUE
        FROM rm_dataset_planning_unit dpu 
        LEFT JOIN rm_dataset_planning_unit_selected dpus ON dpu.PROGRAM_PLANNING_UNIT_ID=dpus.PROGRAM_PLANNING_UNIT_ID
        LEFT JOIN vw_planning_unit pu ON dpu.PLANNING_UNIT_ID=pu.PLANNING_UNIT_ID
        LEFT JOIN vw_forecasting_unit fu ON pu.FORECASTING_UNIT_ID=fu.FORECASTING_UNIT_ID
        LEFT JOIN 
            (
            SELECT 
                ftn.TREE_ID, ftn.NODE_ID, ftnd.NODE_DATA_ID, ftnd.SCENARIO_ID, ftndpu.PLANNING_UNIT_ID
            FROM vw_forecast_tree_node ftn     
            LEFT JOIN rm_forecast_tree_node_data ftnd ON ftnd.NODE_ID=ftn.NODE_ID
            LEFT JOIN rm_forecast_tree_node_data_pu ftndpu ON ftndpu.NODE_DATA_PU_ID=ftnd.NODE_DATA_PU_ID 
            WHERE ftn.NODE_TYPE_ID=5
        ) tree ON dpus.TREE_ID=tree.TREE_ID AND tree.SCENARIO_ID=dpus.SCENARIO_ID AND pu.PLANNING_UNIT_ID=tree.PLANNING_UNIT_ID
        LEFT JOIN rm_forecast_tree_node_data_mom mom ON mom.NODE_DATA_ID=tree.NODE_DATA_ID AND mom.MONTH BETWEEN @startMonth AND @stopMonth 
        LEFT JOIN vw_region r ON dpus.REGION_ID=r.REGION_ID
        WHERE 
            dpu.PROGRAM_ID=@programId 
            AND dpu.VERSION_ID=@versionId 
            AND FIND_IN_SET(pu.PLANNING_UNIT_ID, @unitIdList);
    ELSEIF @reportView = 2 THEN
        SELECT 
            pu.PLANNING_UNIT_ID, pu.LABEL_ID `PU_LABEL_ID`, pu.LABEL_EN `PU_LABEL_EN`, pu.LABEL_FR `PU_LABEL_FR`, pu.LABEL_SP `PU_LABEL_SP`, pu.LABEL_PR `PU_LABEL_PR`, pu.MULTIPLIER,
            fu.FORECASTING_UNIT_ID, fu.LABEL_ID `FU_LABEL_ID`, fu.LABEL_EN `FU_LABEL_EN`, fu.LABEL_FR `FU_LABEL_FR`, fu.LABEL_SP `FU_LABEL_SP`, fu.LABEL_PR `FU_LABEL_PR`,
            r.REGION_ID, r.LABEL_ID `R_LABEL_ID`, r.LABEL_EN `R_LABEL_EN`, r.LABEL_FR `R_LABEL_FR`, r.LABEL_SP `R_LABEL_SP`, r.LABEL_PR `R_LABEL_PR`,
            dpus.TREE_ID, dpus.SCENARIO_ID, mom.MONTH, mom.CALCULATED_MMD_VALUE
        FROM rm_dataset_planning_unit dpu 
        LEFT JOIN rm_dataset_planning_unit_selected dpus ON dpu.PROGRAM_PLANNING_UNIT_ID=dpus.PROGRAM_PLANNING_UNIT_ID
        LEFT JOIN vw_planning_unit pu ON dpu.PLANNING_UNIT_ID=pu.PLANNING_UNIT_ID
        LEFT JOIN vw_forecasting_unit fu ON pu.FORECASTING_UNIT_ID=fu.FORECASTING_UNIT_ID
        LEFT JOIN 
            (
            SELECT 
                ftn.TREE_ID, ftn.NODE_ID, ftnd.NODE_DATA_ID, ftnd.SCENARIO_ID, ftndfu.FORECASTING_UNIT_ID
            FROM vw_forecast_tree_node ftn     
            LEFT JOIN rm_forecast_tree_node_data ftnd ON ftnd.NODE_ID=ftn.NODE_ID
            LEFT JOIN rm_forecast_tree_node_data_fu ftndfu ON ftndfu.NODE_DATA_FU_ID=ftnd.NODE_DATA_FU_ID 
            WHERE ftn.NODE_TYPE_ID=4
        ) tree ON dpus.TREE_ID=tree.TREE_ID AND tree.SCENARIO_ID=dpus.SCENARIO_ID AND fu.FORECASTING_UNIT_ID=tree.FORECASTING_UNIT_ID
        LEFT JOIN rm_forecast_tree_node_data_mom mom ON mom.NODE_DATA_ID=tree.NODE_DATA_ID AND mom.MONTH BETWEEN @startMonth AND @stopMonth 
        LEFT JOIN vw_region r ON dpus.REGION_ID=r.REGION_ID
        WHERE 
            dpu.PROGRAM_ID=@programId 
            AND dpu.VERSION_ID=@versionId 
            AND FIND_IN_SET(fu.FORECASTING_UNIT_ID, @unitIdList);
    END IF;
END$$

DELIMITER ;

USE `fasp`;
DROP procedure IF EXISTS `getForecastSummary`;

DELIMITER $$
USE `fasp`$$
CREATE DEFINER=`faspUser`@`%` PROCEDURE `getForecastSummary`(VAR_PROGRAM_ID INT(10), VAR_VERSION_ID INT(10))
BEGIN

    -- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    -- Mod 2 Report no 2 - ForecastSummary
    -- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    -- programId must be a single Program
    -- versionId must be the actual version 

    SET @programId = VAR_PROGRAM_ID;
    SET @versionId = VAR_VERSION_ID;
    
    SELECT 
	pu.PLANNING_UNIT_ID, pu.LABEL_ID `PU_LABEL_ID`, pu.LABEL_EN `PU_LABEL_EN`, pu.LABEL_FR `PU_LABEL_FR`, pu.LABEL_SP `PU_LABEL_SP`, pu.LABEL_PR `PU_LABEL_PR`, pu.MULTIPLIER,
	r.REGION_ID, r.LABEL_ID `R_LABEL_ID`, r.LABEL_EN `R_LABEL_EN`, r.LABEL_FR `R_LABEL_FR`, r.LABEL_SP `R_LABEL_SP`, r.LABEL_PR `R_LABEL_PR`,
	dpus.TREE_ID, dpus.SCENARIO_ID, SUM(mom.CALCULATED_MMD_VALUE) `CALCULATED_MMD_VALUE`
    FROM rm_dataset_planning_unit dpu 
    LEFT JOIN rm_program_region pr ON pr.PROGRAM_ID=@programId
    LEFT JOIN rm_dataset_planning_unit_selected dpus ON dpu.PROGRAM_PLANNING_UNIT_ID=dpus.PROGRAM_PLANNING_UNIT_ID AND pr.REGION_ID=dpus.REGION_ID
    LEFT JOIN 
        (
        SELECT 
            ftn.TREE_ID, ftn.NODE_ID, ftnd.NODE_DATA_ID, ftnd.SCENARIO_ID, ftndpu.PLANNING_UNIT_ID
        FROM vw_forecast_tree_node ftn     
        LEFT JOIN rm_forecast_tree_node_data ftnd ON ftnd.NODE_ID=ftn.NODE_ID
        LEFT JOIN rm_forecast_tree_node_data_pu ftndpu ON ftndpu.NODE_DATA_PU_ID=ftnd.NODE_DATA_PU_ID 
        WHERE ftn.NODE_TYPE_ID=5
    ) tree ON dpus.TREE_ID=tree.TREE_ID AND tree.SCENARIO_ID=dpus.SCENARIO_ID AND dpu.PLANNING_UNIT_ID=tree.PLANNING_UNIT_ID
    LEFT JOIN rm_forecast_tree_node_data_mom mom ON mom.NODE_DATA_ID=tree.NODE_DATA_ID
    LEFT JOIN vw_planning_unit pu ON dpu.PLANNING_UNIT_ID=pu.PLANNING_UNIT_ID 
    LEFT JOIN vw_region r ON pr.REGION_ID=r.REGION_ID
    WHERE dpu.PROGRAM_ID=@programId and dpu.VERSION_ID=@versionId
    GROUP BY pr.REGION_ID, dpu.PLANNING_UNIT_ID;
END$$

DELIMITER ;


update ap_static_label l 
left join ap_static_label_languages ll on l.STATIC_LABEL_ID=ll.STATIC_LABEL_ID
set ll.LABEL_TEXT='(No seasonality)'
where l.LABEL_CODE='static.tree.monthlyEndNoSeasonality' and ll.LANGUAGE_ID=1;

update ap_static_label l 
left join ap_static_label_languages ll on l.STATIC_LABEL_ID=ll.STATIC_LABEL_ID
set ll.LABEL_TEXT='(Pas de saisonnalité)'
where l.LABEL_CODE='static.tree.monthlyEndNoSeasonality' and ll.LANGUAGE_ID=2;

update ap_static_label l 
left join ap_static_label_languages ll on l.STATIC_LABEL_ID=ll.STATIC_LABEL_ID
set ll.LABEL_TEXT='(Sin estacionalidad)'
where l.LABEL_CODE='static.tree.monthlyEndNoSeasonality' and ll.LANGUAGE_ID=3;

update ap_static_label l 
left join ap_static_label_languages ll on l.STATIC_LABEL_ID=ll.STATIC_LABEL_ID
set ll.LABEL_TEXT='(Sem sazonalidade)'
where l.LABEL_CODE='static.tree.monthlyEndNoSeasonality' and ll.LANGUAGE_ID=4;

INSERT INTO `fasp`.`ap_static_label`(`STATIC_LABEL_ID`,`LABEL_CODE`,`ACTIVE`) VALUES ( NULL,'static.sync.clickOkMsg','1'); 
SELECT MAX(l.STATIC_LABEL_ID) INTO @MAX FROM ap_static_label l ;

INSERT INTO ap_static_label_languages VALUES(NULL,@MAX,1,'* Click `OK` to load latest server version (overrides local version)');-- en
INSERT INTO ap_static_label_languages VALUES(NULL,@MAX,2,'* Cliquez sur `OK` pour charger la dernière version du serveur (remplace la version locale)');-- fr
INSERT INTO ap_static_label_languages VALUES(NULL,@MAX,3,'* Haga clic en `Aceptar` para cargar la última versión del servidor (anula la versión local)');-- sp
INSERT INTO ap_static_label_languages VALUES(NULL,@MAX,4,'* Clique em `OK` para carregar a versão mais recente do servidor (substitui a versão local)');-- pr
INSERT INTO `fasp`.`ap_static_label`(`STATIC_LABEL_ID`,`LABEL_CODE`,`ACTIVE`) VALUES ( NULL,'static.sync.clickCancelMsg','1'); 
SELECT MAX(l.STATIC_LABEL_ID) INTO @MAX FROM ap_static_label l ;

INSERT INTO ap_static_label_languages VALUES(NULL,@MAX,1,'* Click `Cancel` to keep your local version');-- en
INSERT INTO ap_static_label_languages VALUES(NULL,@MAX,2,'* Cliquez sur ""Annuler"" pour conserver votre version locale');-- fr
INSERT INTO ap_static_label_languages VALUES(NULL,@MAX,3,'* Haga clic en `Cancelar` para mantener su versión local');-- sp
INSERT INTO ap_static_label_languages VALUES(NULL,@MAX,4,'* Clique em `Cancelar` para manter sua versão local');-- pr