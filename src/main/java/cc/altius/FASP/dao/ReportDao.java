/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package cc.altius.FASP.dao;

import java.util.List;
import java.util.Map;

/**
 *
 * @author ekta
 */
public interface ReportDao {
    public List<Map<String,Object>> getConsumptionData(int realmId, int productcategoryId, int planningUnitId,String StartDate,String endDate);
    
    public List<Map<String,Object>> getStockStatusMatrix(int realmId, int productcategoryId, int planningUnitId, int view,String startDate,String endDate);
    
    public List<Map<String, Object>> getForecastMatricsOverTime(String startDate,String stopDate,int realmCountryId,int planningUnitId);
    
     public List<Map<String, Object>> getGlobalConsumption(String startDate, String stopDate, String realmCountryIds, String planningUnitIds,String programIds);
}
