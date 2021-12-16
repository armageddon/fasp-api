/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package cc.altius.FASP.dao.impl;

import cc.altius.FASP.dao.CommitRequestDao;
import cc.altius.FASP.exception.CouldNotSaveException;
import cc.altius.FASP.model.CommitRequest;
import cc.altius.FASP.model.CustomUserDetails;
import cc.altius.FASP.model.DatasetData;
import cc.altius.FASP.model.ProgramData;
import cc.altius.FASP.model.Version;
import cc.altius.FASP.model.report.CommitRequestInput;
import cc.altius.FASP.model.rowMapper.CommitRequestRowMapper;
import cc.altius.FASP.service.AclService;
import cc.altius.FASP.service.UserService;
import cc.altius.utils.DateUtils;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.sql.DataSource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import org.springframework.jdbc.core.simple.SimpleJdbcInsert;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

/**
 *
 * @author akil
 */
@Repository
public class CommitRequestDaoImpl implements CommitRequestDao {

    private DataSource dataSource;
    private JdbcTemplate jdbcTemplate;
    private NamedParameterJdbcTemplate namedParameterJdbcTemplate;
    @Autowired
    private AclService aclService;
    @Autowired
    private UserService userService;

    private final Logger logger = LoggerFactory.getLogger(ProgramDaoImpl.class);

    @Autowired
    public void setDataSource(DataSource dataSource) {
        this.dataSource = dataSource;
        this.jdbcTemplate = new JdbcTemplate(dataSource);
        this.namedParameterJdbcTemplate = new NamedParameterJdbcTemplate(dataSource);
    }

    private static String commitRequestSql = "SELECT spcr.COMMIT_REQUEST_ID,spcr.`COMMITTED_VERSION_ID`, "
            + "p.PROGRAM_ID, p.PROGRAM_CODE, l.LABEL_ID `PROGRAM_LABEL_ID`, l.LABEL_EN `PROGRAM_LABEL_EN`, l.LABEL_FR `PROGRAM_LABEL_FR`, l.LABEL_SP `PROGRAM_LABEL_SP`, l.LABEL_PR `PROGRAM_LABEL_PR`, p.PROGRAM_TYPE_ID, "
            + "vt.VERSION_TYPE_ID, vt.LABEL_ID `VERSION_TYPE_LABEL_ID`, vt.LABEL_EN `VERSION_TYPE_LABEL_EN`, vt.LABEL_FR `VERSION_TYPE_LABEL_FR`, vt.LABEL_SP `VERSION_TYPE_LABEL_SP`, vt.LABEL_PR `VERSION_TYPE_LABEL_PR`, "
            + "spcr.`NOTES`,spcr.`SAVE_DATA`, cb.USER_ID `CB_USER_ID`, cb.USERNAME `CB_USERNAME`, spcr.CREATED_DATE, spcr.COMPLETED_DATE, spcr.STATUS, spcr.JSON "
            + "FROM ct_commit_request spcr "
            + "LEFT JOIN vw_all_program p ON spcr.PROGRAM_ID=p.PROGRAM_ID "
            + "LEFT JOIN ap_label l ON p.LABEL_ID=l.LABEL_ID "
            + "LEFT JOIN vw_version_type vt ON spcr.VERSION_TYPE_ID=vt.VERSION_TYPE_ID "
            + "LEFT JOIN us_user cb ON spcr.CREATED_BY=cb.USER_ID "
            + "WHERE TRUE ";

    @Override
    public CommitRequest getPendingCommitRequestProcessList() {
        StringBuilder sb = new StringBuilder(commitRequestSql).append(" AND STATUS=1 LIMIT 1");
        Map<String, Object> params = new HashMap<>();
        return this.namedParameterJdbcTemplate.queryForObject(sb.toString(), params, new CommitRequestRowMapper());
    }

    @Override
    @Transactional
    public int saveProgramData(ProgramData programData, String json, CustomUserDetails curUser) throws CouldNotSaveException {
        Date curDate = DateUtils.getCurrentDateObject(DateUtils.EST);
        SimpleJdbcInsert si = new SimpleJdbcInsert(dataSource).withTableName("ct_commit_request").usingGeneratedKeyColumns("ID");
        Map<String, Object> params = new HashMap<>();
        params.put("PROGRAM_ID", programData.getProgramId());
        params.put("COMMITTED_VERSION_ID", programData.getRequestedProgramVersion());
        params.put("VERSION_TYPE_ID", programData.getVersionType().getId());
        params.put("NOTES", programData.getNotes());
        params.put("SAVE_DATA", 1);
        params.put("CREATED_BY", curUser.getUserId());
        params.put("CREATED_DATE", curDate);
        params.put("STATUS", 1); // New request
        params.put("JSON", json);
        return si.executeAndReturnKey(params).intValue();
    }

    @Override
    @Transactional
    public int saveDatasetData(DatasetData programData, int requestedVersionId, String json, CustomUserDetails curUser) throws CouldNotSaveException {
        Date curDate = DateUtils.getCurrentDateObject(DateUtils.EST);
        SimpleJdbcInsert si = new SimpleJdbcInsert(dataSource).withTableName("ct_commit_request").usingGeneratedKeyColumns("ID");
        Map<String, Object> params = new HashMap<>();
        params.put("PROGRAM_ID", programData.getProgramId());
        params.put("COMMITTED_VERSION_ID", requestedVersionId);
        params.put("VERSION_TYPE_ID", programData.getCurrentVersion().getVersionType().getId());
        params.put("NOTES", programData.getCurrentVersion().getNotes());
        params.put("SAVE_DATA", 1);
        params.put("CREATED_BY", curUser.getUserId());
        params.put("CREATED_DATE", curDate);
        params.put("STATUS", 1); // New request
        params.put("JSON", json);
        return si.executeAndReturnKey(params).intValue();
    }

    @Override
    public Version updateCommitRequest(int commitRequestId, int status, String message, int versionId) {
        Map<String, Object> params = new HashMap<>();
        params.put("FAILED_REASON", message != "" ? message : null);
        params.put("COMMIT_REQUEST_ID", commitRequestId);
        params.put("STATUS", status);
        params.put("VERSION_ID", versionId);
        params.put("curDate", DateUtils.getCurrentDateObject(DateUtils.EST));
        this.namedParameterJdbcTemplate.update("UPDATE ct_commit_request spcr SET spcr.STATUS=:STATUS, spcr.FAILED_REASON=:FAILED_REASON,spcr.COMPLETED_DATE=:curDate,spcr.VERSION_ID=:VERSION_ID WHERE spcr.COMMIT_REQUEST_ID=:COMMIT_REQUEST_ID", params);
        return new Version(0, null, null, null, null, null, null, null);
    }

    @Override
    public List<CommitRequest> getCommitRequestList(CommitRequestInput spcr, int requestStatus, CustomUserDetails curUser) {
        StringBuilder sb = new StringBuilder(commitRequestSql).append(" AND FIND_IN_SET(spcr.PROGRAM_ID,'" + spcr.getProgramIdsString() + "') AND spcr.CREATED_DATE BETWEEN :startDate AND :stopDate AND spcr.CREATED_BY=:curUser");
        Map<String, Object> params = new HashMap<>();
        if (requestStatus != -1) {
            sb.append(" AND STATUS=:requestStatus");
            params.put("requestStatus", requestStatus);
        }
        params.put("startDate", spcr.getStartDateString() + " 00:00:00");
        params.put("stopDate", spcr.getStopDateString() + " 23:59:59");
        params.put("curUser", curUser.getUserId());
        this.aclService.addFullAclForProgram(sb, params, "p", curUser);
        return this.namedParameterJdbcTemplate.query(sb.toString(), params, new CommitRequestRowMapper());
    }

    @Override
    public CommitRequest getCommitRequestByCommitRequestId(int commitRequestId) {
        StringBuilder sb = new StringBuilder(commitRequestSql).append(" AND spcr.COMMIT_REQUEST_ID=:commitRequestId");
        Map<String, Object> params = new HashMap<>();
        params.put("commitRequestId", commitRequestId);
        return this.namedParameterJdbcTemplate.queryForObject(sb.toString(), params, new CommitRequestRowMapper());
    }

    public boolean checkIfCommitRequestExistsForProgram(int programId) {
        String sql = "SELECT COUNT(*) FROM ct_commit_request ct WHERE ct.STATUS=1 AND ct.PROGRAM_ID=?";
        return (this.jdbcTemplate.queryForObject(sql, Integer.class, programId) > 0);
    }
}
