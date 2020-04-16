/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package cc.altius.FASP.dao.impl;

import cc.altius.FASP.dao.LabelDao;
import cc.altius.FASP.dao.ProductCategoryDao;
import cc.altius.FASP.model.CustomUserDetails;
import cc.altius.FASP.model.ExtendedProductCategory;
import cc.altius.FASP.model.ProductCategory;
import cc.altius.FASP.model.rowMapper.TreeExtendedProductCategoryResultSetExtractor;
import cc.altius.FASP.service.AclService;
import cc.altius.utils.DateUtils;
import cc.altius.utils.TreeUtils.Node;
import cc.altius.utils.TreeUtils.Tree;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import javax.sql.DataSource;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import org.springframework.jdbc.core.simple.SimpleJdbcInsert;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

/**
 *
 * @author altius
 */
@Repository
public class ProductCategoryDaoImpl implements ProductCategoryDao {

    @Autowired
    private LabelDao labelDao;
    @Autowired
    private AclService aclService;

    private NamedParameterJdbcTemplate namedParameterJdbcTemplate;
    private DataSource dataSource;

    @Autowired
    public void setDataSource(DataSource dataSource) {
        this.dataSource = dataSource;
        this.namedParameterJdbcTemplate = new NamedParameterJdbcTemplate(dataSource);
    }

    private final String sqlListString = "SELECT  "
            + "    pc.PRODUCT_CATEGORY_ID, pc.SORT_ORDER, pc.PARENT_PRODUCT_CATEGORY_ID, "
            + "    pcl.LABEL_ID, pcl.LABEL_EN, pcl.LABEL_FR, pcl.LABEL_PR, pcl.LABEL_SP, "
            + "    r.REALM_ID, r.REALM_CODE, rl.LABEL_ID `REALM_LABEL_ID`, rl.LABEL_EN `REALM_LABEL_EN`, rl.LABEL_FR `REALM_LABEL_FR`, rl.LABEL_PR `REALM_LABEL_PR`, rl.LABEL_SP `REALM_LABEL_SP`,"
            + "    cb.USER_ID `CB_USER_ID`, cb.USERNAME `CB_USERNAME`, lmb.USER_ID `LMB_USER_ID`, lmb.USERNAME `LMB_USERNAME`, pc.ACTIVE, pc.CREATED_DATE, pc.LAST_MODIFIED_DATE "
            + "	FROM rm_product_category pc  "
            + "LEFT JOIN ap_label pcl ON pc.LABEL_ID=pcl.LABEL_ID "
            + "LEFT JOIN rm_realm r ON pc.REALM_ID=r.REALM_ID "
            + "LEFT JOIN ap_label rl ON r.LABEL_ID=rl.LABEL_ID "
            + "LEFT JOIN us_user cb ON pc.CREATED_BY=cb.USER_ID "
            + "LEFT JOIN us_user lmb ON pc.LAST_MODIFIED_BY=lmb.USER_ID "
            + "WHERE TRUE ";

    @Override
    @Transactional(propagation = Propagation.NESTED)
    public int addProductCategory(Node<ProductCategory> productCategory, CustomUserDetails curUser) {
        SimpleJdbcInsert si = new SimpleJdbcInsert(dataSource).withTableName("rm_product_category").usingGeneratedKeyColumns("PRODUCT_CATEGORY_ID");
        int labelId = this.labelDao.addLabel(productCategory.getPayload().getLabel(), curUser.getUserId());
        Date curDate = DateUtils.getCurrentDateObject(DateUtils.EST);
        Map<String, Object> params = new HashMap<>();
        params.put("REALM_ID", productCategory.getPayload().getRealm().getId());
        params.put("LABEL_ID", labelId);
        params.put("SORT_ORDER", productCategory.getSortOrder());
        params.put("PARENT_PRODUCT_CATEGORY_ID", productCategory.getPayload().getParentProductCategoryId());
        params.put("CREATED_DATE", curDate);
        params.put("CREATED_BY", curUser.getUserId());
        params.put("LAST_MODIFIED_DATE", curDate);
        params.put("LAST_MODIFIED_BY", curUser.getUserId());
        params.put("ACTIVE", true);
        return si.executeAndReturnKey(params).intValue();
    }

    @Override
    @Transactional
    public int updateProductCategory(Node<ProductCategory> productCategory, CustomUserDetails curUser) {
        Date curDate = DateUtils.getCurrentDateObject(DateUtils.EST);
        String sqlString = "UPDATE rm_product_category pc "
                + "LEFT JOIN ap_label pcl ON pc.LABEL_ID=pcl.LABEL_ID "
                + "SET "
                + "pc.SORT_ORDER=:sortOrder, "
                + "pc.`PARENT_PRODUCT_CATEGORY_ID`=:parent, "
                + "pc.ACTIVE=:active, "
                + "pc.LAST_MODIFIED_BY=IF(pcl.LABEL_EN!=:labelEn OR pc.`PARENT_PRODUCT_CATEGORY_ID`!=:parent OR pc.SORT_ORDER!=:sortOrder OR pc.ACTIVE!=:active, :curUser, pc.LAST_MODIFIED_BY), "
                + "pc.LAST_MODIFIED_DATE=IF(pcl.LABEL_EN!=:labelEn OR pc.`PARENT_PRODUCT_CATEGORY_ID`!=:parent OR pc.SORT_ORDER!=:sortOrder OR pc.ACTIVE!=:active, :curDate, pc.LAST_MODIFIED_DATE), "
                + "pcl.LABEL_EN=:labelEn, "
                + "pcl.LAST_MODIFIED_BY=IF(pcl.LABEL_EN!=:labelEn, :curUser, pcl.LAST_MODIFIED_BY), "
                + "pcl.LAST_MODIFIED_DATE=IF(pcl.LABEL_EN!=:labelEn, :curDate, pcl.LAST_MODIFIED_DATE) "
                + "WHERE PRODUCT_CATEGORY_ID=:productCategoryId ";
        Map<String, Object> params = new HashMap<>();
        params.put("productCategoryId", productCategory.getPayload().getProductCategoryId());
        params.put("parent", productCategory.getPayload().getParentProductCategoryId());
        params.put("sortOrder", productCategory.getSortOrder());
        params.put("labelEn", productCategory.getPayload().getLabel().getLabel_en());
        params.put("lastModifiedDate", curDate);
        params.put("lastModifiedBy", curUser.getUserId());
        params.put("active", productCategory.getPayload().isActive());
        params.put("curUser", curUser.getUserId());
        params.put("curDate", curDate);
        return this.namedParameterJdbcTemplate.update(sqlString, params);
    }

    @Override
    public Tree<ExtendedProductCategory> getProductCategoryListForRealm(CustomUserDetails curUser, int realmId) {
        StringBuilder sqlStringBuilder = new StringBuilder(this.sqlListString);
        Map<String, Object> params = new HashMap<>();
        this.aclService.addUserAclForRealm(sqlStringBuilder, params, "r", realmId, curUser);
        sqlStringBuilder.append(" ORDER BY pc.SORT_ORDER");
        return this.namedParameterJdbcTemplate.query(sqlStringBuilder.toString(), params, new TreeExtendedProductCategoryResultSetExtractor());
    }

//    @Override
//    public ProductCategory getProductCategoryById(int productCategoryId, CustomUserDetails curUser) {
//        StringBuilder sqlStringBuilder = new StringBuilder(this.sqlListString).append(" AND pc.PRODUCT_CATEGORY_ID=:productCategoryId ");
//        Map<String, Object> params = new HashMap<>();
//        params.put("productCategoryId", productCategoryId);
//        this.aclService.addUserAclForRealm(sqlListString, params, "r", curUser);
//        return this.namedParameterJdbcTemplate.queryForObject(sqlStringBuilder.toString(), params, new TreeExtendedProductCategoryResultSetExtractor());
//    }

    @Override
    public Tree<ExtendedProductCategory> getProductCategoryList(CustomUserDetails curUser, int realmId, int productCategoryId, boolean includeMainBranch, boolean includeAllChildren) {
        String sqlString = "SELECT pc.SORT_ORDER from rm_product_category pc where pc.PRODUCT_CATEGORY_ID=:productCategoryId";
        Map<String, Object> params = new HashMap<>();
        params.put("productCategoryId", productCategoryId);
        
        String sortOrder = this.namedParameterJdbcTemplate.queryForObject(sqlString, params, String.class);
        params.put("sortOrder", sortOrder);        
        StringBuilder sqlStringBuilder = new StringBuilder(this.sqlListString);
        this.aclService.addUserAclForRealm(sqlString, params, "r", curUser);
        if (!includeAllChildren) {
            sqlStringBuilder.append(" AND pc.`SORT_ORDER` = :sortOrder ");
        }
        if (!includeMainBranch) { 
            sqlStringBuilder.append(" AND pc.`SORT_ORDER` != :sortOrder ");
        }
        sqlStringBuilder.append(" AND pc.`SORT_ORDER` LIKE CONCAT(:sortOrder, '%') ORDER BY pc.SORT_ORDER");
        return this.namedParameterJdbcTemplate.query(sqlStringBuilder.toString(), params, new TreeExtendedProductCategoryResultSetExtractor());
    }

    @Override
    public Tree<ExtendedProductCategory> getProductCategoryListForSync(String lastSyncDate, CustomUserDetails curUser) {
        String sqlString = "SELECT  "
                + "    pc.PRODUCT_CATEGORY_ID, pc.SORT_ORDER, pc.LEVEL, pc.SORT_ORDER,  "
                + "    pcl.LABEL_ID, pcl.LABEL_EN, pcl.LABEL_FR, pcl.LABEL_PR, pcl.LABEL_SP, "
                + "    r.REALM_ID, r.REALM_CODE,  "
                + "    rl.LABEL_ID `REALM_LABEL_ID`, rl.LABEL_EN `REALM_LABEL_EN`, rl.LABEL_FR `REALM_LABEL_FR`, rl.LABEL_PR `REALM_LABEL_PR`, rl.LABEL_SP `REALM_LABEL_SP`,"
                + "    cb.USER_ID `CB_USER_ID`, cb.USERNAME `CB_USERNAME`, lmb.USER_ID `LMB_USER_ID`, lmb.USERNAME `LMB_USERNAME`, pc.ACTIVE, pc.CREATED_DATE, pc.LAST_MODIFIED_DATE "
                + "	FROM rm_product_category pc  "
                + "LEFT JOIN ap_label pcl ON pc.LABEL_ID=pcl.LABEL_ID "
                + "LEFT JOIN rm_realm r ON pc.REALM_ID=r.REALM_ID "
                + "LEFT JOIN ap_label rl ON r.LABEL_ID=rl.LABEL_ID "
                + "LEFT JOIN us_user cb ON pc.CREATED_BY=cb.USER_ID "
                + "LEFT JOIN us_user lmb ON pc.LAST_MODIFIED_BY=lmb.USER_ID "
                + "WHERE pc.LAST_MODIFIED_DATE>:lastSyncDate ";
        Map<String, Object> params = new HashMap<>();
        params.put("lastSyncDate", lastSyncDate);
        if (curUser.getRealm().getRealmId() != -1) {
            sqlString += "AND pc.REALM_ID=:realmId ";
            params.put("realmId", curUser.getRealm().getRealmId());
        }
        sqlString += "ORDER BY pc.SORT_ORDER";
        return this.namedParameterJdbcTemplate.query(sqlString, params, new TreeExtendedProductCategoryResultSetExtractor());
    }

}
