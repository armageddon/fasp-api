/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package cc.altius.FASP.dao;

import cc.altius.FASP.model.CustomUserDetails;
import cc.altius.FASP.model.SimpleBaseModel;
import java.util.List;

/**
 *
 * @author akil
 */
public interface ForecastingStaticDataDao {

    public List<SimpleBaseModel> getUsageTypeList(boolean active, CustomUserDetails curUser);

    public List<SimpleBaseModel> getNodeTypeList(boolean active, CustomUserDetails curUser);

    public List<SimpleBaseModel> getForecastMethodTypeList(boolean active, CustomUserDetails curUser);

    public List<SimpleBaseModel> getUsageTypeListForSync(String lastSyncDate, CustomUserDetails curUser);

    public List<SimpleBaseModel> getNodeTypeListForSync(String lastSyncDate, CustomUserDetails curUser);

    public List<SimpleBaseModel> getForecastMethodTypeListForSync(String lastSyncDate, CustomUserDetails curUser);
}
