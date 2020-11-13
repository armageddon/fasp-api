/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package cc.altius.FASP.model;

import cc.altius.utils.TreeUtils.Node;
import com.fasterxml.jackson.annotation.JsonInclude;
import java.io.Serializable;
import java.util.List;

/**
 *
 * @author akil
 */
@JsonInclude(JsonInclude.Include.NON_NULL)
public class MastersSync implements Serializable {

    private List<Country> countryList;
    private List<Currency> currencyList;
    private List<Dimension> dimensionList;
    private List<Language> languageList;
    private List<ShipmentStatus> shipmentStatusList;
    private List<Unit> unitList;
    private List<DataSourceType> dataSourceTypeList;
    private List<DataSource> dataSourceList;
    private List<TracerCategory> tracerCategoryList;
    private List<Node<ExtendedProductCategory>> productCategoryList;
    private List<Realm> realmList;
    private List<RealmCountry> realmCountryList;
    private List<HealthArea> healthAreaList;
    private List<Organisation> organisationList;
    private List<FundingSource> fundingSourceList;
    private List<ProcurementAgent> procurementAgentList;
    private List<Supplier> supplierList;
    private List<ForecastingUnit> forecastingUnitList;
    private List<PlanningUnit> planningUnitList;
    private List<ProcurementUnit> procurementUnitList;
    private List<RealmCountryPlanningUnit> realmCountryPlanningUnitList;
    private List<ProcurementAgentPlanningUnit> procurementAgentPlanningUnitList;
    private List<ProcurementAgentProcurementUnit> procurementAgentProcurementUnitList;
    private List<Program> programList;
    private List<Region> regionList;
    private List<ProgramPlanningUnit> programPlanningUnitList;
    private List<ProblemStatus> problemStatusList;
    private List<SimpleObject> problemCriticalityList;
    private List<SimpleObject> problemCategoryList;
    private List<RealmProblem> realmProblemList;
    private List<Budget> budgetList;

    public List<Country> getCountryList() {
        return countryList;
    }

    public void setCountryList(List<Country> countryList) {
        this.countryList = countryList;
    }

    public List<Currency> getCurrencyList() {
        return currencyList;
    }

    public void setCurrencyList(List<Currency> currencyList) {
        this.currencyList = currencyList;
    }

    public List<Dimension> getDimensionList() {
        return dimensionList;
    }

    public void setDimensionList(List<Dimension> dimensionList) {
        this.dimensionList = dimensionList;
    }

    public List<Language> getLanguageList() {
        return languageList;
    }

    public void setLanguageList(List<Language> languageList) {
        this.languageList = languageList;
    }

    public List<ShipmentStatus> getShipmentStatusList() {
        return shipmentStatusList;
    }

    public void setShipmentStatusList(List<ShipmentStatus> shipmentStatusList) {
        this.shipmentStatusList = shipmentStatusList;
    }

    public List<Unit> getUnitList() {
        return unitList;
    }

    public void setUnitList(List<Unit> unitList) {
        this.unitList = unitList;
    }

    public List<DataSourceType> getDataSourceTypeList() {
        return dataSourceTypeList;
    }

    public void setDataSourceTypeList(List<DataSourceType> dataSourceTypeList) {
        this.dataSourceTypeList = dataSourceTypeList;
    }

    public List<DataSource> getDataSourceList() {
        return dataSourceList;
    }

    public void setDataSourceList(List<DataSource> dataSourceList) {
        this.dataSourceList = dataSourceList;
    }

    public List<TracerCategory> getTracerCategoryList() {
        return tracerCategoryList;
    }

    public void setTracerCategoryList(List<TracerCategory> tracerCategoryList) {
        this.tracerCategoryList = tracerCategoryList;
    }

    public List<Node<ExtendedProductCategory>> getProductCategoryList() {
        return productCategoryList;
    }

    public void setProductCategoryList(List<Node<ExtendedProductCategory>> productCategoryList) {
        this.productCategoryList = productCategoryList;
    }

    public List<Realm> getRealmList() {
        return realmList;
    }

    public void setRealmList(List<Realm> realmList) {
        this.realmList = realmList;
    }

    public List<RealmCountry> getRealmCountryList() {
        return realmCountryList;
    }

    public void setRealmCountryList(List<RealmCountry> realmCountryList) {
        this.realmCountryList = realmCountryList;
    }

    public List<HealthArea> getHealthAreaList() {
        return healthAreaList;
    }

    public void setHealthAreaList(List<HealthArea> healthAreaList) {
        this.healthAreaList = healthAreaList;
    }

    public List<Organisation> getOrganisationList() {
        return organisationList;
    }

    public void setOrganisationList(List<Organisation> organisationList) {
        this.organisationList = organisationList;
    }

    public List<FundingSource> getFundingSourceList() {
        return fundingSourceList;
    }

    public void setFundingSourceList(List<FundingSource> fundingSourceList) {
        this.fundingSourceList = fundingSourceList;
    }

    public List<ProcurementAgent> getProcurementAgentList() {
        return procurementAgentList;
    }

    public void setProcurementAgentList(List<ProcurementAgent> procurementAgentList) {
        this.procurementAgentList = procurementAgentList;
    }

    public List<Supplier> getSupplierList() {
        return supplierList;
    }

    public void setSupplierList(List<Supplier> supplierList) {
        this.supplierList = supplierList;
    }

    public List<ForecastingUnit> getForecastingUnitList() {
        return forecastingUnitList;
    }

    public void setForecastingUnitList(List<ForecastingUnit> forecastingUnitList) {
        this.forecastingUnitList = forecastingUnitList;
    }

    public List<PlanningUnit> getPlanningUnitList() {
        return planningUnitList;
    }

    public void setPlanningUnitList(List<PlanningUnit> planningUnitList) {
        this.planningUnitList = planningUnitList;
    }

    public List<ProcurementUnit> getProcurementUnitList() {
        return procurementUnitList;
    }

    public void setProcurementUnitList(List<ProcurementUnit> procurementUnitList) {
        this.procurementUnitList = procurementUnitList;
    }

    public List<RealmCountryPlanningUnit> getRealmCountryPlanningUnitList() {
        return realmCountryPlanningUnitList;
    }

    public void setRealmCountryPlanningUnitList(List<RealmCountryPlanningUnit> realmCountryPlanningUnitList) {
        this.realmCountryPlanningUnitList = realmCountryPlanningUnitList;
    }

    public List<ProcurementAgentPlanningUnit> getProcurementAgentPlanningUnitList() {
        return procurementAgentPlanningUnitList;
    }

    public void setProcurementAgentPlanningUnitList(List<ProcurementAgentPlanningUnit> procurementAgentPlanningUnitList) {
        this.procurementAgentPlanningUnitList = procurementAgentPlanningUnitList;
    }

    public List<ProcurementAgentProcurementUnit> getProcurementAgentProcurementUnitList() {
        return procurementAgentProcurementUnitList;
    }

    public void setProcurementAgentProcurementUnitList(List<ProcurementAgentProcurementUnit> procurementAgentProcurementUnitList) {
        this.procurementAgentProcurementUnitList = procurementAgentProcurementUnitList;
    }

    public List<Program> getProgramList() {
        return programList;
    }

    public void setProgramList(List<Program> programList) {
        this.programList = programList;
    }

    public List<Region> getRegionList() {
        return regionList;
    }

    public void setRegionList(List<Region> regionList) {
        this.regionList = regionList;
    }

    public List<ProgramPlanningUnit> getProgramPlanningUnitList() {
        return programPlanningUnitList;
    }

    public void setProgramPlanningUnitList(List<ProgramPlanningUnit> programPlanningUnitList) {
        this.programPlanningUnitList = programPlanningUnitList;
    }

    public List<SimpleObject> getProblemCategoryList() {
        return problemCategoryList;
    }

    public void setProblemCategoryList(List<SimpleObject> problemCategoryList) {
        this.problemCategoryList = problemCategoryList;
    }

    public List<RealmProblem> getRealmProblemList() {
        return realmProblemList;
    }

    public void setRealmProblemList(List<RealmProblem> realmProblemList) {
        this.realmProblemList = realmProblemList;
    }

    public List<ProblemStatus> getProblemStatusList() {
        return problemStatusList;
    }

    public void setProblemStatusList(List<ProblemStatus> problemStatusList) {
        this.problemStatusList = problemStatusList;
    }

    public List<SimpleObject> getProblemCriticalityList() {
        return problemCriticalityList;
    }

    public void setProblemCriticalityList(List<SimpleObject> problemCriticalityList) {
        this.problemCriticalityList = problemCriticalityList;
    }

    public List<Budget> getBudgetList() {
        return budgetList;
    }

    public void setBudgetList(List<Budget> budgetList) {
        this.budgetList = budgetList;
    }

}
