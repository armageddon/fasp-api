/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package cc.altius.FASP.rest.controller;

import cc.altius.FASP.dao.ForecastMethodDao;
import cc.altius.FASP.dao.ForecastingStaticDataDao;
import cc.altius.FASP.dao.ModelingTypeDao;
import cc.altius.FASP.dao.UsagePeriodDao;
import cc.altius.FASP.model.CustomUserDetails;
import cc.altius.FASP.model.MastersSync;
import cc.altius.FASP.model.ResponseCode;
import cc.altius.FASP.service.BudgetService;
import cc.altius.FASP.service.CountryService;
import cc.altius.FASP.service.CurrencyService;
import cc.altius.FASP.service.DataSourceService;
import cc.altius.FASP.service.DataSourceTypeService;
import cc.altius.FASP.service.DimensionService;
import cc.altius.FASP.service.ForecastingUnitService;
import cc.altius.FASP.service.FundingSourceService;
import cc.altius.FASP.service.HealthAreaService;
import cc.altius.FASP.service.LanguageService;
import cc.altius.FASP.service.OrganisationService;
import cc.altius.FASP.service.OrganisationTypeService;
import cc.altius.FASP.service.PlanningUnitService;
import cc.altius.FASP.service.ProblemService;
import cc.altius.FASP.service.ProcurementAgentService;
import cc.altius.FASP.service.ProcurementUnitService;
import cc.altius.FASP.service.ProductCategoryService;
import cc.altius.FASP.service.ProgramService;
import cc.altius.FASP.service.RealmCountryService;
import cc.altius.FASP.service.RealmService;
import cc.altius.FASP.service.RegionService;
import cc.altius.FASP.service.ShipmentStatusService;
import cc.altius.FASP.service.SupplierService;
import cc.altius.FASP.service.TracerCategoryService;
import cc.altius.FASP.service.UnitService;
import cc.altius.FASP.service.UserService;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import javax.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 *
 * @author akil
 */
@Controller
@RequestMapping("/api")
public class SyncRestController {

    private final Logger logger = LoggerFactory.getLogger(this.getClass());

    @Autowired
    private CountryService countryService;
    @Autowired
    private CurrencyService currencyService;
    @Autowired
    private DimensionService dimensionService;
    @Autowired
    private LanguageService languageService;
    @Autowired
    private ShipmentStatusService shipmentStatusService;
    @Autowired
    private UnitService unitService;
    @Autowired
    private DataSourceTypeService dataSourceTypeService;
    @Autowired
    private DataSourceService dataSourceService;
    @Autowired
    private TracerCategoryService tracerCategoryService;
    @Autowired
    private ProductCategoryService productCategoryService;
    @Autowired
    private RealmService realmService;
    @Autowired
    private HealthAreaService healthAreaService;
    @Autowired
    private OrganisationService organisationService;
    @Autowired
    private OrganisationTypeService organisationTypeService;
    @Autowired
    private FundingSourceService fundingSourceService;
    @Autowired
    private ProcurementAgentService procurementAgentService;
    @Autowired
    private SupplierService supplierService;
    @Autowired
    private ForecastingUnitService forecastingUnitService;
    @Autowired
    private PlanningUnitService planningUnitService;
    @Autowired
    private ProcurementUnitService procurementUnitService;
    @Autowired
    private RealmCountryService realmCountryService;
    @Autowired
    private ProgramService programService;
    @Autowired
    private RegionService regionService;
    @Autowired
    private BudgetService budgetService;
    @Autowired
    private ProblemService problemService;
    @Autowired
    private UserService userService;
    @Autowired
    private ForecastingStaticDataDao forecastingStaticDataDao;
    @Autowired
    private UsagePeriodDao usagePeriodDao;
    @Autowired
    private ModelingTypeDao modelingTypeDao;
    @Autowired
    private ForecastMethodDao forecastMethodDao;
    
//    @GetMapping(value = "/sync/allMasters/{lastSyncDate}")
//    public ResponseEntity getAllMastersForSync(@PathVariable("lastSyncDate") String lastSyncDate, Authentication auth, HttpServletResponse response) {
//        try {
//            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
//            sdf.parse(lastSyncDate);
//            CustomUserDetails curUser = this.userService.getCustomUserByUserId(((CustomUserDetails) auth.getPrincipal()).getUserId());
//            MastersSync masters = new MastersSync();
//            masters.setCountryList(this.countryService.getCountryListForSync(lastSyncDate));
//            masters.setCurrencyList(this.currencyService.getCurrencyListForSync(lastSyncDate));
//            masters.setDimensionList(this.dimensionService.getDimensionListForSync(lastSyncDate));
//            masters.setLanguageList(this.languageService.getLanguageListForSync(lastSyncDate));
//            masters.setShipmentStatusList(this.shipmentStatusService.getShipmentStatusListForSync(lastSyncDate, curUser));
//            masters.setUnitList(this.unitService.getUnitListForSync(lastSyncDate));
//            masters.setDataSourceTypeList(this.dataSourceTypeService.getDataSourceTypeListForSync(lastSyncDate, curUser));
//            masters.setDataSourceList(this.dataSourceService.getDataSourceListForSync(lastSyncDate, curUser));
//            masters.setTracerCategoryList(this.tracerCategoryService.getTracerCategoryListForSync(lastSyncDate, curUser));
//            masters.setProductCategoryList(this.productCategoryService.getProductCategoryListForSync(lastSyncDate, curUser));
//            masters.setRealmList(this.realmService.getRealmListForSync(lastSyncDate, curUser));
//            masters.setHealthAreaList(this.healthAreaService.getHealthAreaListForSync(lastSyncDate, curUser));
//            masters.setOrganisationList(this.organisationService.getOrganisationListForSync(lastSyncDate, curUser));
//            masters.setOrganisationTypeList(this.organisationTypeService.getOrganisationTypeListForSync(lastSyncDate, curUser));
//            masters.setFundingSourceList(this.fundingSourceService.getFundingSourceListForSync(lastSyncDate, curUser));
//            masters.setProcurementAgentList(this.procurementAgentService.getProcurementAgentListForSync(lastSyncDate, curUser));
//            masters.setSupplierList(this.supplierService.getSupplierListForSync(lastSyncDate, curUser));
//            masters.setForecastingUnitList(this.forecastingUnitService.getForecastingUnitListForSync(lastSyncDate, curUser));
//            masters.setPlanningUnitList(this.planningUnitService.getPlanningUnitListForSync(lastSyncDate, curUser));
//            masters.setProcurementUnitList(this.procurementUnitService.getProcurementUnitListForSync(lastSyncDate, curUser));
//            masters.setRealmCountryList(this.realmCountryService.getRealmCountryListForSync(lastSyncDate, curUser));
//            masters.setRealmCountryPlanningUnitList(this.realmCountryService.getRealmCountryPlanningUnitListForSync(lastSyncDate, curUser));
//            masters.setProcurementAgentPlanningUnitList(this.procurementAgentService.getProcurementAgentPlanningUnitListForSync(lastSyncDate, curUser));
//            masters.setProcurementAgentProcurementUnitList(this.procurementAgentService.getProcurementAgentProcurementUnitListForSync(lastSyncDate, curUser));
//            masters.setProgramList(this.programService.getProgramListForSync(lastSyncDate, curUser));
//            masters.setProgramPlanningUnitList(this.programService.getProgramPlanningUnitListForSync(lastSyncDate, curUser));
//            masters.setRegionList(this.regionService.getRegionListForSync(lastSyncDate, curUser));
//            masters.setBudgetList(this.budgetService.getBudgetListForSync(lastSyncDate, curUser));
//            masters.setProblemStatusList(this.problemService.getProblemStatusForSync(lastSyncDate, curUser));
//            masters.setProblemCriticalityList(this.problemService.getProblemCriticalityForSync(lastSyncDate, curUser));
//            masters.setProblemCategoryList(this.problemService.getProblemCategoryForSync(lastSyncDate, curUser));
//            masters.setRealmProblemList(this.problemService.getProblemListForSync(lastSyncDate, curUser));
//            return new ResponseEntity(masters, HttpStatus.OK);
//        } catch (ParseException p) {
//            logger.error("Error in masters sync", p);
//            return new ResponseEntity(new ResponseCode("static.message.listFailed"), HttpStatus.PRECONDITION_FAILED);
//        } catch (Exception e) {
//            logger.error("Error in masters sync", e);
//            return new ResponseEntity(new ResponseCode("static.message.listFailed"), HttpStatus.INTERNAL_SERVER_ERROR);
//        }
//    }
    private String getProgramIds(String[] programIds) {
        if (programIds == null) {
            return "";
        } else {
            String opt = String.join("','", programIds);
            if (programIds.length > 0) {
                return "'" + opt + "'";
            } else {
                return opt;
            }
        }
    }

    @PostMapping(value = "/sync/allMasters/forPrograms/{lastSyncDate}")
    public ResponseEntity getAllMastersForSyncWithProgramIds(@RequestBody String[] programIds, @PathVariable("lastSyncDate") String lastSyncDate, Authentication auth, HttpServletResponse response) {
        try {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            sdf.parse(lastSyncDate);
            String programIdsString = getProgramIds(programIds);
            CustomUserDetails curUser = this.userService.getCustomUserByUserId(((CustomUserDetails) auth.getPrincipal()).getUserId());
            MastersSync masters = new MastersSync();
            masters.setCountryList(this.countryService.getCountryListForSyncProgram(programIdsString, curUser));//programIds
//            System.out.println("Country -> " + masters.getCountryList().size());
            masters.setCurrencyList(this.currencyService.getCurrencyListForSync(lastSyncDate));
//            System.out.println("Currency -> " + masters.getCurrencyList().size());
            masters.setDimensionList(this.dimensionService.getDimensionListForSync(lastSyncDate));
//            System.out.println("Dimension -> " + masters.getDimensionList().size());
            masters.setLanguageList(this.languageService.getLanguageListForSync(lastSyncDate));
//            System.out.println("Language -> " + masters.getLanguageList().size());
            masters.setShipmentStatusList(this.shipmentStatusService.getShipmentStatusListForSync(lastSyncDate, curUser));
//            System.out.println("ShipmentStatus -> " + masters.getShipmentStatusList().size());
            masters.setUnitList(this.unitService.getUnitListForSync(lastSyncDate));
//            System.out.println("Unit -> " + masters.getUnitList().size());
            masters.setDataSourceTypeList(this.dataSourceTypeService.getDataSourceTypeListForSync(lastSyncDate, curUser));
//            System.out.println("DataSourceType -> " + masters.getDataSourceTypeList().size());
            masters.setDataSourceList(this.dataSourceService.getDataSourceListForSync(lastSyncDate, curUser));
//            System.out.println("DataSource -> " + masters.getDataSourceList().size());
            masters.setTracerCategoryList(this.tracerCategoryService.getTracerCategoryListForSync(lastSyncDate, curUser));
//            System.out.println("TracerCategory -> " + masters.getTracerCategoryList().size());
            masters.setProductCategoryList(this.productCategoryService.getProductCategoryListForSync(lastSyncDate, curUser));
//            System.out.println("ProductCategory -> " + masters.getProductCategoryList().size());
            masters.setRealmList(this.realmService.getRealmListForSync(lastSyncDate, curUser));
//            System.out.println("Realm -> " + masters.getRealmList().size());
            masters.setHealthAreaList(this.healthAreaService.getHealthAreaListForSync(lastSyncDate, curUser));
//            System.out.println("HealthArea -> " + masters.getHealthAreaList().size());
            masters.setOrganisationList(this.organisationService.getOrganisationListForSync(lastSyncDate, curUser));
            masters.setOrganisationTypeList(this.organisationTypeService.getOrganisationTypeListForSync(lastSyncDate, curUser));
//            System.out.println("Organisation -> " + masters.getOrganisationList().size());
            masters.setFundingSourceList(this.fundingSourceService.getFundingSourceListForSync(lastSyncDate, curUser));
//            System.out.println("FundingSource -> " + masters.getFundingSourceList().size());
            masters.setProcurementAgentList(this.procurementAgentService.getProcurementAgentListForSync(lastSyncDate, curUser));
//            System.out.println("ProcurementAgent -> " + masters.getProcurementAgentList().size());
//            masters.setSupplierList(this.supplierService.getSupplierListForSync(lastSyncDate, curUser));
            masters.setForecastingUnitList(this.forecastingUnitService.getForecastingUnitListForSyncProgram(programIdsString, curUser)); // programIds, 
//            System.out.println("ForecastingUnit -> " + masters.getForecastingUnitList().size());
            masters.setPlanningUnitList(this.planningUnitService.getPlanningUnitListForSyncProgram(programIdsString, curUser)); //programIds, 
//            System.out.println("PlanningUnit -> " + masters.getPlanningUnitList().size());
            masters.setProcurementUnitList(this.procurementUnitService.getProcurementUnitListForSyncProgram(programIdsString, curUser));//programIds, 
//            System.out.println("ProcurementUnit -> " + masters.getProcurementUnitList().size());
            masters.setRealmCountryList(this.realmCountryService.getRealmCountryListForSyncProgram(programIdsString, curUser));//programIds, 
//            System.out.println("RealmCountry -> " + masters.getRealmCountryList().size());
            masters.setRealmCountryPlanningUnitList(this.realmCountryService.getRealmCountryPlanningUnitListForSyncProgram(programIdsString, curUser));//programIds, 
//            System.out.println("RealmCountryPlanningUnit -> " + masters.getRealmCountryPlanningUnitList().size());
            masters.setProcurementAgentPlanningUnitList(this.procurementAgentService.getProcurementAgentPlanningUnitListForSyncProgram(programIdsString, curUser));//programIds, 
//            System.out.println("ProcurementAgentPlanningUnit -> " + masters.getProcurementAgentPlanningUnitList().size());
            masters.setProcurementAgentProcurementUnitList(this.procurementAgentService.getProcurementAgentProcurementUnitListForSyncProgram(programIdsString, curUser));//programIds, 
//            System.out.println("ProcurementAgentProcurementUnit -> " + masters.getProcurementAgentProcurementUnitList().size());
            masters.setProgramList(this.programService.getProgramListForSyncProgram(programIdsString, curUser));//programIds, 
//            System.out.println("Program -> " + m/sync/allMasters/forPrograms/{lastSyncDate}asters.getProgramList().size());
            masters.setProgramPlanningUnitList(this.programService.getProgramPlanningUnitListForSyncProgram(programIdsString, curUser));//programIds, 
//            System.out.println("ProgramPlanningUnit -> " + masters.getProgramPlanningUnitList().size());
            masters.setRegionList(this.regionService.getRegionListForSyncProgram(programIdsString, curUser));//programIds, 
//            System.out.println("Region -> " + masters.getRegionList().size());
            masters.setBudgetList(this.budgetService.getBudgetListForSyncProgram(programIdsString, curUser));//programIds, 
//            System.out.println("Budget -> " + masters.getBudgetList().size());
            masters.setProblemStatusList(this.problemService.getProblemStatusForSync(lastSyncDate, curUser));
//            System.out.println("ProblemStatus -> " + masters.getProblemStatusList().size());
            masters.setProblemCriticalityList(this.problemService.getProblemCriticalityForSync(lastSyncDate, curUser));
//            System.out.println("ProblemCriticality -> " + masters.getProblemCriticalityList().size());
            masters.setProblemCategoryList(this.problemService.getProblemCategoryForSync(lastSyncDate, curUser));
//            System.out.println("ProblemCategory -> " + masters.getProblemCategoryList().size());
            masters.setRealmProblemList(this.problemService.getProblemListForSync(lastSyncDate, curUser));
//            System.out.println("RealmProblem -> " + masters.getRealmProblemList().size());
            masters.setUsageTypeList(this.forecastingStaticDataDao.getUsageTypeListForSync(lastSyncDate, curUser));
            masters.setNodeTypeList(this.forecastingStaticDataDao.getNodeTypeListForSync(lastSyncDate, curUser));
            masters.setForecastMethodTypeList(this.forecastingStaticDataDao.getForecastMethodTypeListForSync(lastSyncDate, curUser));
            masters.setUsagePeriodList(this.usagePeriodDao.getUsagePeriodListForSync(lastSyncDate, curUser));
            masters.setModelingTypeList(this.modelingTypeDao.getModelingTypeListForSync(lastSyncDate, curUser));
            masters.setForecastMethodList(this.forecastMethodDao.getForecastMethodListForSync(lastSyncDate, curUser));
            return new ResponseEntity(masters, HttpStatus.OK);
        } catch (ParseException p) {
            logger.error("Error in masters sync", p);
            return new ResponseEntity(new ResponseCode("static.message.listFailed"), HttpStatus.PRECONDITION_FAILED);
        } catch (Exception e) {
            logger.error("Error in masters sync", e);
            return new ResponseEntity(new ResponseCode("static.message.listFailed"), HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @GetMapping(value = "/sync/language/{lastSyncDate}")
    public ResponseEntity getLanguageListForSync(@PathVariable("lastSyncDate") String lastSyncDate) {
        try {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            sdf.parse(lastSyncDate);
            return new ResponseEntity(this.languageService.getLanguageListForSync(lastSyncDate), HttpStatus.OK);
        } catch (ParseException p) {
            logger.error("Error while listing language", p);
            return new ResponseEntity(new ResponseCode("static.message.listFailed"), HttpStatus.PRECONDITION_FAILED);
        } catch (Exception e) {
            logger.error("Error while listing language", e);
            return new ResponseEntity(new ResponseCode("static.message.listFailed"), HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
}
