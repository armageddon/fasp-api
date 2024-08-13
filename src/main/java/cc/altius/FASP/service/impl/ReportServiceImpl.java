/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package cc.altius.FASP.service.impl;

import cc.altius.FASP.dao.EquivalencyUnitDao;
import cc.altius.FASP.dao.ProgramCommonDao;
import cc.altius.FASP.dao.ProgramDao;
import cc.altius.FASP.dao.RealmCountryDao;
import cc.altius.FASP.dao.ReportDao;
import cc.altius.FASP.model.CustomUserDetails;
import cc.altius.FASP.model.SimpleCodeObject;
import cc.altius.FASP.model.report.AnnualShipmentCostInput;
import cc.altius.FASP.model.report.AnnualShipmentCostOutput;
import cc.altius.FASP.model.report.BudgetReportInput;
import cc.altius.FASP.model.report.BudgetReportOutput;
import cc.altius.FASP.model.report.ConsumptionForecastVsActualInput;
import cc.altius.FASP.model.report.ConsumptionForecastVsActualOutput;
import cc.altius.FASP.model.report.ConsumptionInfo;
import cc.altius.FASP.model.report.CostOfInventoryInput;
import cc.altius.FASP.model.report.CostOfInventoryOutput;
import cc.altius.FASP.model.report.DropdownsForStockStatusVerticalOutput;
import cc.altius.FASP.model.report.ExpiredStockInput;
import cc.altius.FASP.model.report.ExpiredStockOutput;
import cc.altius.FASP.model.report.ForecastErrorInput;
import cc.altius.FASP.model.report.ForecastErrorInputNew;
import cc.altius.FASP.model.report.ForecastErrorOutput;
import cc.altius.FASP.model.report.ForecastMetricsComparisionInput;
import cc.altius.FASP.model.report.ForecastMetricsComparisionOutput;
import cc.altius.FASP.model.report.ForecastMetricsMonthlyInput;
import cc.altius.FASP.model.report.ForecastMetricsMonthlyOutput;
import cc.altius.FASP.model.report.ForecastSummaryInput;
import cc.altius.FASP.model.report.ForecastSummaryOutput;
import cc.altius.FASP.model.report.FundingSourceShipmentReportInput;
import cc.altius.FASP.model.report.FundingSourceShipmentReportOutput;
import cc.altius.FASP.model.report.GlobalConsumptionInput;
import cc.altius.FASP.model.report.GlobalConsumptionOutput;
import cc.altius.FASP.model.report.InventoryInfo;
import cc.altius.FASP.model.report.InventoryTurnsInput;
import cc.altius.FASP.model.report.InventoryTurnsOutput;
import cc.altius.FASP.model.report.MonthlyForecastInput;
import cc.altius.FASP.model.report.MonthlyForecastOutput;
import cc.altius.FASP.model.report.ProcurementAgentShipmentReportInput;
import cc.altius.FASP.model.report.ProcurementAgentShipmentReportOutput;
import cc.altius.FASP.model.report.ProgramAndReportingUnit;
import cc.altius.FASP.model.report.ProgramLeadTimesInput;
import cc.altius.FASP.model.report.ProgramLeadTimesOutput;
import cc.altius.FASP.model.report.ProgramProductCatalogInput;
import cc.altius.FASP.model.report.ProgramProductCatalogOutput;
import cc.altius.FASP.model.report.ShipmentDetailsInput;
import cc.altius.FASP.model.report.ShipmentDetailsOutput;
import cc.altius.FASP.model.report.ShipmentGlobalDemandInput;
import cc.altius.FASP.model.report.ShipmentGlobalDemandOutput;
import cc.altius.FASP.model.report.ShipmentOverviewInput;
import cc.altius.FASP.model.report.ShipmentOverviewOutput;
import cc.altius.FASP.model.report.ShipmentReportInput;
import cc.altius.FASP.model.report.ShipmentReportOutput;
import cc.altius.FASP.model.report.StockAdjustmentReportInput;
import cc.altius.FASP.model.report.StockAdjustmentReportOutput;
import cc.altius.FASP.model.report.StockStatusAcrossProductsForProgram;
import cc.altius.FASP.model.report.StockStatusAcrossProductsInput;
import cc.altius.FASP.model.report.StockStatusAcrossProductsOutput;
import cc.altius.FASP.model.report.StockStatusOverTimeInput;
import cc.altius.FASP.model.report.StockStatusOverTimeOutput;
import cc.altius.FASP.model.report.StockStatusForProgramInput;
import cc.altius.FASP.model.report.StockStatusForProgramOutput;
import cc.altius.FASP.model.report.StockStatusMatrixInput;
import cc.altius.FASP.model.report.StockStatusMatrixOutput;
import cc.altius.FASP.model.report.StockStatusVerticalAggregateOutput;
import cc.altius.FASP.model.report.StockStatusVerticalInput;
import cc.altius.FASP.model.report.StockStatusVerticalOutput;
import cc.altius.FASP.model.report.WarehouseByCountryInput;
import cc.altius.FASP.model.report.WarehouseByCountryOutput;
import cc.altius.FASP.model.report.WarehouseCapacityInput;
import cc.altius.FASP.model.report.WarehouseCapacityOutput;
import cc.altius.FASP.service.ReportService;
import cc.altius.FASP.utils.ArrayUtils;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 *
 * @author ekta
 */
@Service
public class ReportServiceImpl implements ReportService {

    @Autowired
    private ReportDao reportDao;
    @Autowired
    private ProgramCommonDao programCommonDao;
    @Autowired
    private ProgramDao programDao;
    @Autowired
    private RealmCountryDao realmCountryDao;
    @Autowired
    private EquivalencyUnitDao equivalencyUnitDao;

    @Override
    public List<StockStatusMatrixOutput> getStockStatusMatrix(StockStatusMatrixInput ssm) {
        return this.reportDao.getStockStatusMatrix(ssm);
    }

    // Report no 1
    @Override
    public List<ProgramProductCatalogOutput> getProgramProductCatalog(ProgramProductCatalogInput ppc, CustomUserDetails curUser) {
        return this.reportDao.getProgramProductCatalog(ppc, curUser);
    }

    //Report no 2
    @Override
    public List<ConsumptionForecastVsActualOutput> getConsumptionForecastVsActual(ConsumptionForecastVsActualInput cfa, CustomUserDetails curUser) {
        return this.reportDao.getConsumptionForecastVsActual(cfa, curUser);
    }

    // Report no 3
    @Override
    public List<GlobalConsumptionOutput> getGlobalConsumption(GlobalConsumptionInput gci, CustomUserDetails curUser) {
        return this.reportDao.getGlobalConsumption(gci, curUser);
    }

    // Report no 4
    @Override
    public List<ForecastMetricsMonthlyOutput> getForecastMetricsMonthly(ForecastMetricsMonthlyInput fmi, CustomUserDetails curUser) {
        return this.reportDao.getForecastMetricsMonthly(fmi, curUser);
    }

    // Report no 5
    @Override
    public List<ForecastMetricsComparisionOutput> getForecastMetricsComparision(ForecastMetricsComparisionInput fmi, CustomUserDetails curUser) {
        return this.reportDao.getForecastMetricsComparision(fmi, curUser);
    }

    @Override
    public List<StockStatusOverTimeOutput> getStockStatusOverTime(StockStatusOverTimeInput ssot, CustomUserDetails curUser) {
        return this.reportDao.getStockStatusOverTime(ssot, curUser);
    }

    @Override
    public List<AnnualShipmentCostOutput> getAnnualShipmentCost(AnnualShipmentCostInput asci, CustomUserDetails curUser) {
        return this.reportDao.getAnnualShipmentCost(asci, curUser);
    }

    @Override
    public List<CostOfInventoryOutput> getCostOfInventory(CostOfInventoryInput cii, CustomUserDetails curUser) {
        return this.reportDao.getCostOfInventory(cii, curUser);
    }

    @Override
    public List<InventoryTurnsOutput> getInventoryTurns(InventoryTurnsInput it, CustomUserDetails curUser) {
        return this.reportDao.getInventoryTurns(it, curUser);
    }

    @Override
    public List<ExpiredStockOutput> getExpiredStock(ExpiredStockInput esi, CustomUserDetails curUser) {
        return this.reportDao.getExpiredStock(esi, curUser);
    }

    @Override
    public List<StockAdjustmentReportOutput> getStockAdjustmentReport(StockAdjustmentReportInput si, CustomUserDetails curUser) {
        return this.reportDao.getStockAdjustmentReport(si, curUser);
    }

    @Override
    public List<ProcurementAgentShipmentReportOutput> getProcurementAgentShipmentReport(ProcurementAgentShipmentReportInput pari, CustomUserDetails curUser) {
        return this.reportDao.getProcurementAgentShipmentReport(pari, curUser);
    }

    @Override
    public List<FundingSourceShipmentReportOutput> getFundingSourceShipmentReport(FundingSourceShipmentReportInput fsri, CustomUserDetails curUser) {
        return this.reportDao.getFundingSourceShipmentReport(fsri, curUser);
    }

    @Override
    public List<ShipmentReportOutput> getAggregateShipmentByProduct(ShipmentReportInput sri, CustomUserDetails curUser) {
        return this.reportDao.getAggregateShipmentByProduct(sri, curUser);
    }

    @Override
    public List<WarehouseCapacityOutput> getWarehouseCapacityReport(WarehouseCapacityInput wci, CustomUserDetails curUser) {
        return this.reportDao.getWarehouseCapacityReport(wci, curUser);
    }

    @Override
    public List<WarehouseByCountryOutput> getWarehouseByCountryReport(WarehouseByCountryInput wci, CustomUserDetails curUser) {
        return this.reportDao.getWarehouseByCountryReport(wci, curUser);
    }

    @Override
    public List<StockStatusForProgramOutput> getStockStatusForProgram(StockStatusForProgramInput sspi, CustomUserDetails curUser) {
        return this.reportDao.getStockStatusForProgram(sspi, curUser);
    }

    @Override
    public List<ProgramLeadTimesOutput> getProgramLeadTimes(ProgramLeadTimesInput plt, CustomUserDetails curUser) {
        return this.reportDao.getProgramLeadTimes(plt, curUser);
    }

    @Override
    public Map<ProgramAndReportingUnit, List<StockStatusVerticalOutput>> getStockStatusVertical(StockStatusVerticalInput ssv, CustomUserDetails curUser) {
        Map<ProgramAndReportingUnit, List<StockStatusVerticalOutput>> map = new HashMap<>();
        for (int programId : ssv.getProgramIds()) {
            for (int reportingUnitId : ssv.getReportingUnitIds()) {
                SimpleCodeObject program = this.programCommonDao.getSimpleSupplyPlanProgramById(programId, curUser);
                ssv.setProgramId(programId);
                ssv.setReportingUnitId(reportingUnitId);
                List<StockStatusVerticalOutput> ssvoList = this.reportDao.getStockStatusVertical(ssv, curUser);
                List<ConsumptionInfo> cList = this.reportDao.getConsumptionInfoForSSVReport(ssv, curUser);
                cList.forEach(c -> {
                    int idx = ssvoList.indexOf(new StockStatusVerticalOutput(c.getConsumptionDate()));
                    if (idx != -1) {
                        ssvoList.get(idx).getConsumptionInfo().add(c);
                    }
                });

                List<InventoryInfo> iList = this.reportDao.getInventoryInfoForSSVReport(ssv, curUser);
                iList.forEach(i -> {
                    int idx = ssvoList.indexOf(new StockStatusVerticalOutput(i.getInventoryDate()));
                    if (idx != -1) {
                        ssvoList.get(idx).getInventoryInfo().add(i);
                    }
                });
                map.put(new ProgramAndReportingUnit(program, ssvoList.get(0).getReportingUnit()), ssvoList);
            }
        }
        return map;
    }

    @Override
    public List<StockStatusVerticalAggregateOutput> getStockStatusVerticalAggregate(StockStatusVerticalInput ssv, CustomUserDetails curUser) {
        List<StockStatusVerticalAggregateOutput> ssvoList = this.reportDao.getStockStatusVerticalAggregate(ssv, curUser);
        List<ConsumptionInfo> cList = this.reportDao.getConsumptionInfoForSSVReport(ssv, curUser);
        cList.forEach(c -> {
            int idx = ssvoList.indexOf(new StockStatusVerticalOutput(c.getConsumptionDate()));
            if (idx != -1) {
                ssvoList.get(idx).getConsumptionInfo().add(c);
            }
        });

        List<InventoryInfo> iList = this.reportDao.getInventoryInfoForSSVReport(ssv, curUser);
        iList.forEach(i -> {
            int idx = ssvoList.indexOf(new StockStatusVerticalOutput(i.getInventoryDate()));
            if (idx != -1) {
                ssvoList.get(idx).getInventoryInfo().add(i);
            }
        });
        return ssvoList;
    }

    @Override
    public DropdownsForStockStatusVerticalOutput getDropdownsForStockStatusVertical(String[] programIds, CustomUserDetails curUser) {
        DropdownsForStockStatusVerticalOutput dd = new DropdownsForStockStatusVerticalOutput();
        dd.setPlanningUnitList(this.programDao.getSimplePlanningUnitAndForecastingUnits(ArrayUtils.convertArrayToString(programIds), curUser));
        dd.setRealmCountryPlanningUnitList(this.realmCountryDao.getSimpleRealmCountryPlanningUnits(ArrayUtils.convertArrayToString(programIds), curUser));
        dd.setEquivalencyUnitList(this.equivalencyUnitDao.getSimpleEquivalencyUnits(ArrayUtils.convertArrayToString(programIds), curUser));
        return dd;
    }

    @Override
    public ShipmentDetailsOutput getShipmentDetails(ShipmentDetailsInput sd, CustomUserDetails curUser) {
        return this.reportDao.getShipmentDetails(sd, curUser);
    }

    @Override
    public ShipmentOverviewOutput getShipmentOverview(ShipmentOverviewInput so, CustomUserDetails curUser) {
        return this.reportDao.getShipmentOverview(so, curUser);
    }

    @Override
    public ShipmentGlobalDemandOutput getShipmentGlobalDemand(ShipmentGlobalDemandInput sgd, CustomUserDetails curUser) {
        return this.reportDao.getShipmentGlobalDemand(sgd, curUser);
    }

    @Override
    public List<BudgetReportOutput> getBudgetReport(BudgetReportInput br, CustomUserDetails curUser) {
        return this.reportDao.getBudgetReport(br, curUser);
    }

    // Report no 30
    @Override
    public List<StockStatusAcrossProductsOutput> getStockStatusAcrossProducts(StockStatusAcrossProductsInput ssap, CustomUserDetails curUser) {
        List<StockStatusAcrossProductsOutput> ssapList = this.reportDao.getStockStatusAcrossProductsBasicInfo(ssap, curUser);
        List<StockStatusAcrossProductsOutput> finalList = new LinkedList<>();
        for (StockStatusAcrossProductsOutput s : ssapList) {
            StockStatusAcrossProductsOutput m = new StockStatusAcrossProductsOutput();
            m.setPlanningUnit(s.getPlanningUnit());
            finalList.add(m);
            for (StockStatusAcrossProductsForProgram progData : s.getProgramData()) {
                StockStatusAcrossProductsForProgram sData = this.reportDao.getStockStatusAcrossProductsProgramData(progData.getProgram().getId(), s.getPlanningUnit().getId(), ssap.getDt(), ssap.isUseApprovedSupplyPlanOnly());
                m.getProgramData().add(sData);
            }
        }
        return finalList;
    }

    // Report no 31
    @Override
    public List<ForecastErrorOutput> getForecastError(ForecastErrorInput fei, CustomUserDetails curUser) {
        return this.reportDao.getForecastError(fei, curUser);
    }

    // Report no 31 new
    @Override
    public List<ForecastErrorOutput> getForecastError(ForecastErrorInputNew fei, CustomUserDetails curUser) {
        return this.reportDao.getForecastError(fei, curUser);
    }

    // Mod 2 Report 1 -- Monthly Forecast
    @Override
    public List<MonthlyForecastOutput> getMonthlyForecast(MonthlyForecastInput mf, CustomUserDetails curUser) {
        return this.reportDao.getMonthlyForecast(mf, curUser);
    }

    // Mod 2 Report 2 -- Forecast Summary
    @Override
    public List<ForecastSummaryOutput> getForecastSummary(ForecastSummaryInput fs, CustomUserDetails curUser) {
        return this.reportDao.getForecastSummary(fs, curUser);
    }

}
