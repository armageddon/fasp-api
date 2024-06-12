/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package cc.altius.FASP.service.impl;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import cc.altius.FASP.dao.HealthAreaDao;
import cc.altius.FASP.dao.OrganisationDao;
import cc.altius.FASP.dao.ProcurementAgentDao;
import cc.altius.FASP.dao.ProgramCommonDao;
import cc.altius.FASP.dao.ProgramDao;
import cc.altius.FASP.dao.ProgramDataDao;
import cc.altius.FASP.dao.RealmDao;
import cc.altius.FASP.framework.GlobalConstants;
import cc.altius.FASP.model.CustomUserDetails;
import cc.altius.FASP.model.DTO.ErpOrderAutocompleteDTO;
import cc.altius.FASP.model.DTO.HealthAreaAndRealmCountryDTO;
import cc.altius.FASP.model.DTO.ManualTaggingDTO;
import cc.altius.FASP.model.DTO.ManualTaggingOrderDTO;
import cc.altius.FASP.model.DTO.ProgramPlanningUnitProcurementAgentInput;
import cc.altius.FASP.model.DatasetTree;
import cc.altius.FASP.model.ForecastTree;
import cc.altius.FASP.model.LoadProgram;
import cc.altius.FASP.model.ProcurementAgent;
import cc.altius.FASP.model.Program;
import cc.altius.FASP.model.ProgramIdAndVersionId;
import cc.altius.FASP.model.ProgramInitialize;
import cc.altius.FASP.model.ProgramPlanningUnit;
import cc.altius.FASP.model.ProgramPlanningUnitProcurementAgentPrice;
import cc.altius.FASP.model.Realm;
import cc.altius.FASP.model.RealmCountry;
import cc.altius.FASP.model.SimpleCodeObject;
import cc.altius.FASP.model.SimpleProgram;
import cc.altius.FASP.model.SimpleObject;
import cc.altius.FASP.model.SimplePlanningUnitObject;
import cc.altius.FASP.model.TreeNode;
import cc.altius.FASP.model.Version;
import cc.altius.FASP.model.report.TreeAnchorInput;
import cc.altius.FASP.model.report.TreeAnchorOutput;
import cc.altius.FASP.model.report.UpdateProgramInfoOutput;
import cc.altius.FASP.service.AclService;
import cc.altius.FASP.service.ProgramService;
import cc.altius.FASP.service.RealmCountryService;
import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 *
 * @author altius
 */
@Service
public class ProgramServiceImpl implements ProgramService {

    @Autowired
    private ProgramDao programDao;
    @Autowired
    private ProgramDataDao programDataDao;
    @Autowired
    private ProgramCommonDao programCommonDao;
    @Autowired
    private RealmCountryService realmCountryService;
    @Autowired
    private RealmDao realmDao;
    @Autowired
    private HealthAreaDao healthAreaDao;
    @Autowired
    private OrganisationDao organisationDao;
    @Autowired
    private ProcurementAgentDao procurementAgentDao;
    @Autowired
    private AclService aclService;

    private final Logger logger = LoggerFactory.getLogger(this.getClass());

    @Override
    public List<SimpleProgram> getProgramListForDropdown(int realmId, int programTypeId, CustomUserDetails curUser) {
        return this.programDao.getProgramListForDropdown(realmId, programTypeId, curUser);
    }

    @Override
    public List<SimpleProgram> getProgramWithFilterForHealthAreaAndRealmCountryListForDropdown(int realmId, int programTypeId, HealthAreaAndRealmCountryDTO input, CustomUserDetails curUser) {
        return this.programDao.getProgramWithFilterForHealthAreaAndRealmCountryListForDropdown(realmId, programTypeId, input, curUser);
    }

    @Override
    public List<SimpleProgram> getProgramWithFilterForMultipleRealmCountryListForDropdown(int programTypeId, String realmCountryIdsStr, CustomUserDetails curUser) {
        return this.programDao.getProgramWithFilterForMultipleRealmCountryListForDropdown(programTypeId, realmCountryIdsStr, curUser);
    }

    @Override
    public int addProgram(Program p, CustomUserDetails curUser) {
        p.setRealmCountry(this.realmCountryService.getRealmCountryById(p.getRealmCountry().getRealmCountryId(), curUser));
        if (this.aclService.checkAccessForUser(
                curUser,
                p.getRealmCountry().getRealm().getRealmId(),
                p.getRealmCountry().getRealmCountryId(),
                p.getHealthAreaIdList(),
                p.getOrganisation().getId(),
                0)) {
            RealmCountry rc = this.realmCountryService.getRealmCountryById(p.getRealmCountry().getRealmCountryId(), curUser);
            StringBuilder healthAreaCode = new StringBuilder();
            for (int haId : p.getHealthAreaIdList()) {
                healthAreaCode.append(this.healthAreaDao.getHealthAreaById(haId, curUser).getHealthAreaCode() + "/");
            }
            StringBuilder programCode = new StringBuilder(rc.getCountry().getCountryCode()).append("-").append(healthAreaCode.substring(0, healthAreaCode.length() - 1)).append("-").append(this.organisationDao.getOrganisationById(p.getOrganisation().getId(), curUser).getOrganisationCode());
            if (p.getProgramCode() != null && !p.getProgramCode().isBlank()) {
                programCode.append("-").append(p.getProgramCode());
            }
            p.setProgramCode(programCode.toString());
            return this.programDao.addProgram(p, rc.getRealm().getRealmId(), curUser);
        } else {
            throw new AccessDeniedException("Access denied");
        }
    }

    @Override
    public int updateProgram(Program p, CustomUserDetails curUser) {
        SimpleProgram curProg = this.programCommonDao.getSimpleProgramById(p.getProgramId(), p.getProgramTypeId(), curUser);
        if (curProg == null) {
            throw new EmptyResultDataAccessException(1);
        }
        if (this.aclService.checkAccessForUser(
                curUser,
                curProg.getRealmId(),
                curProg.getRealmCountry().getId(),
                curProg.getHealthAreaIdList(),
                curProg.getOrganisation().getId(),
                curProg.getId())) {
            return this.programDao.updateProgram(p, curUser);
        } else {
            throw new AccessDeniedException("Access denied");
        }
    }

    @Override
    public List<Program> getProgramListForProgramIds(String[] programIds, CustomUserDetails curUser) {
        return this.programDao.getProgramListForProgramIds(programIds, curUser);
    }

    @Override
    public List<Program> getProgramList(int programTypeId, CustomUserDetails curUser, boolean active) {
        return this.programDao.getProgramList(programTypeId, curUser, active);
    }

    @Override
    public List<Program> getProgramListForRealmId(int realmId, int programTypeId, CustomUserDetails curUser) {
        Realm r = this.realmDao.getRealmById(realmId, curUser);
        if (r == null) {
            throw new EmptyResultDataAccessException(1);
        }
        if (this.aclService.checkRealmAccessForUser(curUser, realmId)) {
            return this.programDao.getProgramListForRealmId(realmId, programTypeId, curUser);
        } else {
            throw new AccessDeniedException("Access denied");
        }
    }

    @Override
    public Program getFullProgramById(int programId, int programTypeId, CustomUserDetails curUser) {
        Program p = this.programCommonDao.getFullProgramById(programId, programTypeId, curUser);
        if (p == null) {
            throw new AccessDeniedException("Access denied");
        }
        if (this.aclService.checkProgramAccessForUser(curUser, p.getRealmCountry().getRealm().getRealmId(), p.getProgramId(), p.getHealthAreaIdList(), p.getOrganisation().getId())) {
            return p;
        } else {
            throw new AccessDeniedException("Access denied");
        }
    }

    @Override
    public SimpleProgram getSimpleProgramById(int programId, CustomUserDetails curUser) {
        return this.programCommonDao.getSimpleProgramById(programId, 0, curUser);
    }

    @Override
    public SimpleProgram getSimpleProgramById(int programId, int programTypeId, CustomUserDetails curUser) {
        return this.programCommonDao.getSimpleProgramById(programId, programTypeId, curUser);
    }

    @Override
    public List<ProgramPlanningUnit> getPlanningUnitListForProgramId(int programId, boolean active, CustomUserDetails curUser) {
        SimpleProgram sp = this.programCommonDao.getSimpleProgramById(programId, GlobalConstants.PROGRAM_TYPE_SUPPLY_PLAN, curUser);
        if (this.aclService.checkProgramAccessForUser(curUser, sp.getRealmId(), programId, sp.getHealthAreaIdList(), sp.getOrganisation().getId())) {
            return this.programDao.getPlanningUnitListForProgramId(programId, active, curUser);
        } else {
            throw new AccessDeniedException("Access denied");
        }
    }

    @Override
    public List<ProgramPlanningUnit> getPlanningUnitListForProgramIdAndTracerCategoryIds(int programId, boolean active, String[] tracerCategoryIds, CustomUserDetails curUser) {
        SimpleProgram sp = this.programCommonDao.getSimpleProgramById(programId, GlobalConstants.PROGRAM_TYPE_SUPPLY_PLAN, curUser);
        if (this.aclService.checkProgramAccessForUser(curUser, sp.getRealmId(), programId, sp.getHealthAreaIdList(), sp.getOrganisation().getId())) {
            return this.programDao.getPlanningUnitListForProgramIdAndTracerCategoryIds(programId, active, tracerCategoryIds, curUser);
        } else {
            throw new AccessDeniedException("Access denied");
        }
    }

    @Override
    public List<SimplePlanningUnitObject> getSimplePlanningUnitListForProgramIdAndTracerCategoryIds(int programId, boolean active, String[] tracerCategoryIds, CustomUserDetails curUser) {
        SimpleProgram sp = this.programCommonDao.getSimpleProgramById(programId, GlobalConstants.PROGRAM_TYPE_SUPPLY_PLAN, curUser);
        if (this.aclService.checkProgramAccessForUser(curUser, sp.getRealmId(), programId, sp.getHealthAreaIdList(), sp.getOrganisation().getId())) {
            return this.programDao.getSimplePlanningUnitListForProgramIdAndTracerCategoryIds(programId, active, tracerCategoryIds, curUser);
        } else {
            throw new AccessDeniedException("Access denied");
        }
    }

    @Override
    public List<SimpleObject> getPlanningUnitListForProgramIds(Integer[] programIds, CustomUserDetails curUser) {
        StringBuilder programList = new StringBuilder();
        for (int programId : programIds) {
            SimpleProgram sp = this.programCommonDao.getSimpleProgramById(programId, GlobalConstants.PROGRAM_TYPE_SUPPLY_PLAN, curUser);
            if (this.aclService.checkProgramAccessForUser(curUser, sp.getRealmId(), programId, sp.getHealthAreaIdList(), sp.getOrganisation().getId())) {
                programList.append("'").append(programId).append("',");
            } else {
                throw new AccessDeniedException("Access denied");
            }
        }
        if (programList.length() > 0) {
            programList.setLength(programList.length() - 1);
            return this.programDao.getPlanningUnitListForProgramIds(programList.toString(), curUser);
        } else {
            return new LinkedList<>();
        }

    }

    @Override
    public int saveProgramPlanningUnit(ProgramPlanningUnit[] programPlanningUnits, CustomUserDetails curUser) {
        for (ProgramPlanningUnit ppu : programPlanningUnits) {
            SimpleProgram sp = this.programCommonDao.getSimpleProgramById(ppu.getProgram().getId(), GlobalConstants.PROGRAM_TYPE_SUPPLY_PLAN, curUser);
            if (!this.aclService.checkProgramAccessForUser(curUser, sp.getRealmId(), sp.getId(), sp.getHealthAreaIdList(), sp.getOrganisation().getId())) {
                throw new AccessDeniedException("Access denied");
            }
        }
        return this.programDao.saveProgramPlanningUnit(programPlanningUnits, curUser);
    }

    @Override
    public List<ProgramPlanningUnitProcurementAgentPrice> getProgramPlanningUnitProcurementAgentList(ProgramPlanningUnitProcurementAgentInput ppupa, boolean active, CustomUserDetails curUser) {
        return this.programDao.getProgramPlanningUnitProcurementAgentList(ppupa, active, curUser);
    }

    @Override
    public int saveProgramPlanningUnitProcurementAgentPrice(ProgramPlanningUnitProcurementAgentPrice[] programPlanningUnitProcurementAgentPrices, CustomUserDetails curUser) {
        for (ProgramPlanningUnitProcurementAgentPrice papup : programPlanningUnitProcurementAgentPrices) {
            ProcurementAgent pa = this.procurementAgentDao.getProcurementAgentById(papup.getProcurementAgent().getId(), curUser);
            if (!this.aclService.checkRealmAccessForUser(curUser, pa.getRealm().getId())) {
                throw new AccessDeniedException("Access denied");
            }
        }
        return this.programDao.saveProgramPlanningUnitProcurementAgentPrice(programPlanningUnitProcurementAgentPrices, curUser);
    }

    @Override
    public List<Program> getProgramListForSync(String lastSyncDate, CustomUserDetails curUser) {
        return this.programDao.getProgramListForSync(lastSyncDate, curUser);
    }

    @Override
    public List<ProgramPlanningUnit> getProgramPlanningUnitListForSync(String lastSyncDate, CustomUserDetails curUser) {
        return this.programDao.getProgramPlanningUnitListForSync(lastSyncDate, curUser);
    }

    @Override
    public List<ProgramPlanningUnit> getPlanningUnitListForProgramAndCategoryId(int programId, int productCategoryId, boolean active, CustomUserDetails curUser) {
        SimpleProgram sp = this.programCommonDao.getSimpleProgramById(programId, GlobalConstants.PROGRAM_TYPE_SUPPLY_PLAN, curUser);
        if (this.aclService.checkProgramAccessForUser(curUser, sp.getRealmId(), programId, sp.getHealthAreaIdList(), sp.getOrganisation().getId())) {
            return this.programDao.getPlanningUnitListForProgramAndCategoryId(programId, productCategoryId, active, curUser);
        } else {
            throw new AccessDeniedException("Access denied");
        }
    }

    @Override
    @Transactional
    public int addProgramInitialize(ProgramInitialize program, CustomUserDetails curUser) {
        RealmCountry rc = this.realmCountryService.getRealmCountryById(program.getRealmCountry().getRealmCountryId(), curUser);
        StringBuilder healthAreaCode = new StringBuilder();
        for (int haId : program.getHealthAreaIdList()) {
            healthAreaCode.append(this.healthAreaDao.getHealthAreaById(haId, curUser).getHealthAreaCode() + "/");
        }
        StringBuilder programCode = new StringBuilder(rc.getCountry().getCountryCode()).append("-").append(healthAreaCode.substring(0, healthAreaCode.length() - 1)).append("-").append(this.organisationDao.getOrganisationById(program.getOrganisation().getId(), curUser).getOrganisationCode());
        if (program.getProgramCode() != null && !program.getProgramCode().isBlank()) {
            programCode.append("-").append(program.getProgramCode());
        }
        program.setProgramCode(programCode.toString());
        int programId = this.programDao.addProgram(program, rc.getRealm().getRealmId(), curUser);
        for (ProgramPlanningUnit ppu : program.getProgramPlanningUnits()) {
            ppu.getProgram().setId(programId);
        }
        this.programDao.saveProgramPlanningUnit(program.getProgramPlanningUnits(), curUser);
        return programId;
    }

    @Override
    public Program getProgramList(int realmId, int programId, int versionId) {
        return this.programDao.getProgramList(realmId, programId, versionId);
    }

    @Override
    public List<ManualTaggingDTO> getShipmentListForManualTagging(ManualTaggingDTO manualTaggingDTO, CustomUserDetails curUser) {
        return this.programDao.getShipmentListForManualTagging(manualTaggingDTO, curUser);
    }

    @Override
    public List<ManualTaggingOrderDTO> getOrderDetailsByOrderNoAndPrimeLineNo(String roNoOrderNo, int programId, int planningUnitId, int linkingType, int parentShipmentId) {
        return this.programDao.getOrderDetailsByOrderNoAndPrimeLineNo(roNoOrderNo, programId, planningUnitId, linkingType, parentShipmentId);
    }

    @Override
    public List<Integer> linkShipmentWithARTMIS(ManualTaggingOrderDTO[] manualTaggingOrderDTO, CustomUserDetails curUser) {
        try {
            List<Integer> result = new ArrayList<>();
//            System.out.println("length---" + manualTaggingOrderDTO.length);
            for (int i = 0; i < manualTaggingOrderDTO.length; i++) {
//                System.out.println("manualTaggingOrderDTO[i]---" + manualTaggingOrderDTO[i]);
                if (manualTaggingOrderDTO[i].isActive()) {
                    int id = 0;
                    int count = this.programDao.checkIfOrderNoAlreadyTagged(manualTaggingOrderDTO[i].getOrderNo(), manualTaggingOrderDTO[i].getPrimeLineNo());
                    if (manualTaggingOrderDTO[i].getShipmentId() != 0) {
                        if (count != 0) {
                            id = this.programDao.updateERPLinking(manualTaggingOrderDTO[i], curUser);
                        } else {
                            id = this.programDao.linkShipmentWithARTMIS(manualTaggingOrderDTO[i], curUser);
                        }
                    } else {
                        if (count == 0) {
                            id = this.programDao.linkShipmentWithARTMISWithoutShipmentid(manualTaggingOrderDTO[i], curUser);
                        }
                    }
                    result.add(id);
                } else if (!manualTaggingOrderDTO[i].isActive()) {
//                    System.out.println("****************************************************************************************" + manualTaggingOrderDTO[i]);
                    this.programDao.delinkShipment(manualTaggingOrderDTO[i], curUser);
                }
            }
            return result;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public List<ManualTaggingDTO> getShipmentListForDelinking(int programId, int planningUnitId) {
        return this.programDao.getShipmentListForDelinking(programId, planningUnitId);
    }

    @Override
    public List<ManualTaggingDTO> getNotLinkedShipments(int programId, int linkingTypeId) {
        return this.programDao.getNotLinkedShipments(programId, linkingTypeId);
    }

    @Override
    public void delinkShipment(ManualTaggingOrderDTO erpOrderDTO, CustomUserDetails curUser) {
        this.programDao.delinkShipment(erpOrderDTO, curUser);
    }

    @Override
    public List<LoadProgram> getLoadProgram(int programTypeId, CustomUserDetails curUser) {
        return this.programDao.getLoadProgram(programTypeId, curUser);
    }

    @Override
    public LoadProgram getLoadProgram(int programId, int page, int programTypeId, CustomUserDetails curUser) {
        return this.programDao.getLoadProgram(programId, page, programTypeId, curUser);
    }

    @Override
    public boolean validateProgramCode(int realmId, int programId, String programCode, CustomUserDetails curUser) {
        if (curUser.getRealm().getRealmId() != realmId) {
            throw new AccessDeniedException("Access denied");
        }
        return this.programDao.validateProgramCode(realmId, programId, programCode, curUser);
    }

    @Override
    public List<Program> getProgramListForSyncProgram(String programIdsString, CustomUserDetails curUser) {
        if (programIdsString.length() > 0) {
            return this.programDao.getProgramListForSyncProgram(programIdsString, curUser);
        } else {
            return new LinkedList<>();
        }
    }

    @Override
    public List<ProgramPlanningUnit> getProgramPlanningUnitListForSyncProgram(String programIdsString, CustomUserDetails curUser) {
        if (programIdsString.length() > 0) {
            return this.programDao.getProgramPlanningUnitListForSyncProgram(programIdsString, curUser);
        } else {
            return new LinkedList<>();
        }
    }

    @Override
    public List<ErpOrderAutocompleteDTO> getErpOrderSearchData(String term, int programId, int planningUnitId, int linkingType) {
        return this.programDao.getErpOrderSearchData(term, programId, planningUnitId, linkingType);
    }

    @Override
    public String getSupplyPlanReviewerList(int programId, CustomUserDetails curUser) {
        return this.programDao.getSupplyPlanReviewerList(programId, curUser);
    }

    @Override
    public List<ManualTaggingDTO> getOrderDetailsByForNotLinkedERPShipments(String roNoOrderNo, int planningUnitId, int linkingType) {
        return this.programDao.getOrderDetailsByForNotLinkedERPShipments(roNoOrderNo, planningUnitId, linkingType);
    }

    @Override
    public ManualTaggingDTO getShipmentDetailsByParentShipmentId(int parentShipmentId) {
        return this.programDao.getShipmentDetailsByParentShipmentId(parentShipmentId);
    }

    @Override
    public int checkPreviousARTMISPlanningUnitId(String orderNo, int primeLineNo) {
        return this.programDao.checkPreviousARTMISPlanningUnitId(orderNo, primeLineNo);
    }

    @Override
    public List<DatasetTree> getTreeListForDataset(int programId, int versionId, CustomUserDetails curUser) {
        if (this.programCommonDao.getSimpleProgramById(programId, GlobalConstants.PROGRAM_TYPE_DATASET, curUser) == null) {
            // ACL check fail
            return null;
        } else {
            return this.programDataDao.getTreeListForDataset(programId, versionId, curUser);
        }
    }

    @Override
    public ForecastTree<TreeNode> getTreeData(int treeId, CustomUserDetails curUser) {
        return this.programDataDao.getTreeData(treeId, curUser);
    }

    @Override
    public List<ProgramIdAndVersionId> getLatestVersionForPrograms(String programIds) {
        return this.programDao.getLatestVersionForPrograms(programIds);
    }

    @Override
    public List<Version> getVersionListForProgramId(int programTypeId, int programId, CustomUserDetails curUser) {
        return this.programCommonDao.getVersionListForProgramId(programTypeId, programId, curUser);
    }

    @Override
    public Map<Integer, List<Version>> getVersionListForPrograms(int programTypeId, String[] programIds, CustomUserDetails curUser) {
        return this.programCommonDao.getVersionListForPrograms(programTypeId, programIds, curUser);
    }

    @Override
    public List<UpdateProgramInfoOutput> getUpdateProgramInfoReport(int programTypeId, int realmCountryId, int active, CustomUserDetails curUser) {
        return this.programCommonDao.getUpdateProgramInfoReport(programTypeId, realmCountryId, active, curUser);
    }

    @Override
    public SimpleCodeObject getSimpleSupplyPlanProgramByProgramId(int programId, CustomUserDetails curUser) {
        return this.programCommonDao.getSimpleSupplyPlanProgramById(programId, curUser);
    }

    @Override
    public List<SimpleCodeObject> getSimpleProgramListByRealmCountryIdList(String[] realmCountryIds, CustomUserDetails curUser) {
        return this.programDao.getSimpleProgramListByRealmCountryIdList(realmCountryIds, curUser);
    }

    @Override
    public List<SimpleCodeObject> getSimpleProgramListByProductCategoryIdList(String[] productCategoryIds, CustomUserDetails curUser) {
        return this.programDao.getSimpleProgramListByProductCategoryIdList(productCategoryIds, curUser);
    }

    @Override
    public List<TreeAnchorOutput> getTreeAnchorForSync(TreeAnchorInput ta, CustomUserDetails curUser) {
        return this.programDao.getTreeAnchorForSync(ta, curUser);
    }

}
