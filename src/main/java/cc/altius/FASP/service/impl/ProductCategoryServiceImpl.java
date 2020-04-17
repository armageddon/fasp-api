/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package cc.altius.FASP.service.impl;

import cc.altius.FASP.dao.ProductCategoryDao;
import cc.altius.FASP.dao.RealmDao;
import cc.altius.FASP.model.CustomUserDetails;
import cc.altius.FASP.model.ExtendedProductCategory;
import cc.altius.FASP.model.ProductCategory;
import cc.altius.FASP.model.Realm;
import cc.altius.FASP.service.AclService;
import cc.altius.FASP.service.ProductCategoryService;
import cc.altius.utils.TreeUtils.Node;
import cc.altius.utils.TreeUtils.Tree;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 *
 * @author altius
 */
@Service
public class ProductCategoryServiceImpl implements ProductCategoryService {

    @Autowired
    private ProductCategoryDao productCategoryDao;
    @Autowired
    private RealmDao realmDao;
    @Autowired
    private AclService aclService;

    @Override
    @Transactional
    public int saveProductCategoryList(Node<ProductCategory>[] productCategorys, CustomUserDetails curUser) throws Exception {
        int rows = 0;
        boolean isFirst = true;
        Tree<ProductCategory> productCategoryTree = null;
        for (Node<ProductCategory> node : productCategorys) {
            node.setPayloadId(node.getPayload().getProductCategoryId());
            if (isFirst) {

                productCategoryTree = new Tree(node);
            } else {
                productCategoryTree.addNode(node);
            }
            isFirst = false;
        }
//        for (Node<ProductCategory> p1 : productCategoryList) {
//            if (p1.getParentId() != null && p1.getParentId() == productCategory.getId()) {
//                p1.getPayload().setParentProductCategoryId(productCategoryId);
//            }
//        }
        for (Node<ProductCategory> productCategory : productCategoryTree.getTreeList()) {
            if (productCategory.getPayloadId() == 0) {
                // Add the row
                if (this.aclService.checkRealmAccessForUser(curUser, productCategory.getPayload().getRealm().getId())) {
                    if (productCategory.getParentId()!=null && productCategory.getParentId()!=0) {
                        Node<ProductCategory> parent = productCategoryTree.findNode(productCategory.getParentId());
                        productCategory.getPayload().setParentProductCategoryId(parent.getPayloadId());
                    }
                    int productCategoryId = this.productCategoryDao.addProductCategory(productCategory, curUser);
                    productCategory.setPayloadId(productCategoryId);
                } else {
                    throw new AccessDeniedException("Access denied");
                }
            }
        }

        for (Node<ProductCategory> productCategory : productCategorys) {
            if (productCategory.getPayload().getProductCategoryId() != 0) {
                // Update 
                if (this.aclService.checkRealmAccessForUser(curUser, productCategory.getPayload().getRealm().getId())) {
                    if (productCategory.getParentId() != null && productCategory.getParentId()!=0) {
                        Node<ProductCategory> parent = productCategoryTree.findNode(productCategory.getParentId());
                        productCategory.getPayload().setParentProductCategoryId(parent.getPayloadId());
                    }
                    rows += this.productCategoryDao.updateProductCategory(productCategory, curUser);
                } else {
                    throw new AccessDeniedException("Access denied");
                }
            }
        }
        return rows;
    }

    @Override
    public Tree<ExtendedProductCategory> getProductCategoryListForRealm(CustomUserDetails curUser, int realmId
    ) {
        Realm r = this.realmDao.getRealmById(realmId, curUser);
        if (this.aclService.checkRealmAccessForUser(curUser, realmId)) {
            return this.productCategoryDao.getProductCategoryListForRealm(curUser, realmId);
        } else {
            throw new AccessDeniedException("Access denied");
        }

    }

    @Override
    public Tree<ExtendedProductCategory> getProductCategoryList(CustomUserDetails curUser, int realmId, int productCategoryId, boolean includeCurrentLevel, boolean includeAllChildren
    ) {
        Realm r = this.realmDao.getRealmById(realmId, curUser);
//        ProductCategory pc = getProductCategoryById(productCategoryId, curUser);
//        if (r == null || pc == null) {
//            throw new EmptyResultDataAccessException(1);
//        }
        return this.productCategoryDao.getProductCategoryList(curUser, realmId, productCategoryId, includeCurrentLevel, includeAllChildren);
    }

//    @Override
//    public ProductCategory getProductCategoryById(int productCategoryId, CustomUserDetails curUser) {
//        return this.productCategoryDao.getProductCategoryById(productCategoryId, curUser);
//    }
    @Override
    public Tree<ExtendedProductCategory> getProductCategoryListForSync(String lastSyncDate, CustomUserDetails curUser
    ) {
        return this.productCategoryDao.getProductCategoryListForSync(lastSyncDate, curUser);
    }

}
