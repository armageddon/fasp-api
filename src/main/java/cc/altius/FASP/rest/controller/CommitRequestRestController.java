/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package cc.altius.FASP.rest.controller;

import cc.altius.FASP.exception.AccessControlFailedException;
import cc.altius.FASP.exception.CouldNotSaveException;
import cc.altius.FASP.model.CommitRequest;
import cc.altius.FASP.model.CustomUserDetails;
import cc.altius.FASP.model.DatasetDataJson;
import cc.altius.FASP.model.EmptyDoubleTypeAdapter;
import cc.altius.FASP.model.EmptyIntegerTypeAdapter;
import cc.altius.FASP.model.EmptyStringToDefaultBooleanDeserializer;
import cc.altius.FASP.model.EmptyStringToDefaultDateDeserializer;
import cc.altius.FASP.model.EmptyStringToDefaultDoubleDeserializer;
import cc.altius.FASP.model.EmptyStringToDefaultFloatDeserializer;
import cc.altius.FASP.model.EmptyStringToDefaultIntDeserializer;
import cc.altius.FASP.model.ProgramData;
import cc.altius.FASP.model.ResponseCode;
import cc.altius.FASP.model.report.CommitRequestInput;
import cc.altius.FASP.service.CommitRequestService;
import cc.altius.FASP.service.ProgramService;
import cc.altius.FASP.service.UserService;
import cc.altius.FASP.utils.CompressUtils;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.reflect.TypeToken;
import jakarta.servlet.http.HttpServletRequest;
import java.io.FileInputStream;
import java.lang.reflect.Type;
import java.util.Date;
import java.util.List;
import java.util.Properties;
import org.apache.commons.io.IOUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

/**
 *
 * @author akil
 */
@RestController
@RequestMapping("/api/commit")
public class CommitRequestRestController {

    @Autowired
    private UserService userService;
    @Autowired
    private CommitRequestService commitRequestService;
    @Autowired
    private ProgramService programService;
    @Value("${qat.homeFolder}")
    private String QAT_FILE_PATH;

    private final Logger logger = LoggerFactory.getLogger(this.getClass());

    /**
     * Part 1 of the Commit Request for Supply Plan
     *
     * @param comparedVersionId
     * @param programDataCompressed
     * @param auth
     * @return
     */
    @PutMapping("/programData/{comparedVersionId}")
    public ResponseEntity putProgramData(@PathVariable(value = "comparedVersionId", required = true) int comparedVersionId, @RequestBody String programDataCompressed, Authentication auth) {
        try {
            String programDataBytes = CompressUtils.decompress(programDataCompressed);
            Gson gson = new GsonBuilder()
                    .registerTypeAdapter(Integer.class, new EmptyStringToDefaultIntDeserializer())
                    .registerTypeAdapter(int.class, new EmptyStringToDefaultIntDeserializer())
                    .registerTypeAdapter(Double.class, new EmptyStringToDefaultDoubleDeserializer())
                    .registerTypeAdapter(double.class, new EmptyStringToDefaultDoubleDeserializer())
                    .registerTypeAdapter(Float.class, new EmptyStringToDefaultFloatDeserializer())
                    .registerTypeAdapter(float.class, new EmptyStringToDefaultFloatDeserializer())
                    .registerTypeAdapter(Date.class, new EmptyStringToDefaultDateDeserializer())
                    .registerTypeAdapter(Boolean.class, new EmptyStringToDefaultBooleanDeserializer())
                    .registerTypeAdapter(boolean.class, new EmptyStringToDefaultBooleanDeserializer())
                    .serializeSpecialFloatingPointValues()
                    .setDateFormat("yyyy-MM-dd HH:mm:ss")
                    .create();
            Type type = new TypeToken<ProgramData>() {
            }.getType();
            ProgramData programData = gson.fromJson(programDataBytes, type);
            int latestVersion = this.programService.getLatestVersionForPrograms("" + programData.getProgramId()).get(0).getVersionId();
            if (latestVersion == comparedVersionId) {
                boolean checkIfRequestExists = this.commitRequestService.checkIfCommitRequestExistsForProgram(programData.getProgramId());
                if (!checkIfRequestExists) {
                    CustomUserDetails curUser = this.userService.getCustomUserByUserIdForApi(((CustomUserDetails) auth.getPrincipal()).getUserId(), ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest().getMethod(), ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest().getRequestURI());
                    int commitRequestId = this.commitRequestService.saveProgramData(programData, gson.toJson(programData), curUser);
                    return new ResponseEntity(commitRequestId, HttpStatus.OK);
                } else {
                    logger.error("Request already exists");
                    return new ResponseEntity(new ResponseCode("static.commitVersion.requestAlreadyExists"), HttpStatus.NOT_ACCEPTABLE);
                }
            } else {
                logger.error("Compared version is not latest");
                return new ResponseEntity(new ResponseCode("static.commitVersion.versionIsOutDated"), HttpStatus.NOT_ACCEPTABLE);
            }
//            this.programDataService.getProgramData(programData.getProgramId(), v.getVersionId(), curUser,false)
        } catch (AccessControlFailedException e) {
            logger.error("Error while trying to update ProgramData", e);
            return new ResponseEntity(new ResponseCode("static.message.addFailed"), HttpStatus.CONFLICT);
        } catch (CouldNotSaveException e) {
            logger.error("Error while trying to update ProgramData", e);
            return new ResponseEntity(new ResponseCode("static.message.updateFailed"), HttpStatus.PRECONDITION_FAILED);
        } catch (EmptyResultDataAccessException e) {
            logger.error("Error while trying to update ProgramData", e);
            return new ResponseEntity(new ResponseCode("static.message.updateFailed"), HttpStatus.NOT_FOUND);
        } catch (AccessDeniedException e) {
            logger.error("Error while trying to update ProgramData", e);
            return new ResponseEntity(new ResponseCode("static.message.updateFailed"), HttpStatus.FORBIDDEN);
        } catch (Exception e) {
            logger.error("Error while trying to update ProgramData", e);
            return new ResponseEntity(new ResponseCode("static.message.updateFailed"), HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    /**
     * Part 1 of the Commit Request for Dataset
     *
     * @param comparedVersionId
     * @param request
     * @param auth
     * @return
     */
    @PutMapping("/datasetData/{comparedVersionId}")
    public ResponseEntity putDatasetData(@PathVariable(value = "comparedVersionId", required = true) int comparedVersionId, HttpServletRequest request, Authentication auth) {
        String json = null;
        try {
            String datasetBytes = CompressUtils.decompress(IOUtils.toString(request.getReader()));
            json = datasetBytes;
            String emptyFuNodeString1 = "\"fuNode\":{\"noOfForecastingUnitsPerPerson\":\"\",\"usageFrequency\":\"\",\"forecastingUnit\":{\"label\":{\"label_en\":\"\"},\"tracerCategory\":{},\"unit\":{\"id\":\"\"}},\"usageType\":{\"id\":\"\"},\"usagePeriod\":{\"usagePeriodId\":\"\"},\"repeatUsagePeriod\":{\"usagePeriodId\":\"\"},\"noOfPersons\":\"\"}";
            String emptyFuNodeString2 = "\"fuNode\":{\"lagInMonths\":0,\"noOfForecastingUnitsPerPerson\":\"\",\"usageFrequency\":\"\",\"forecastingUnit\":{\"label\":{\"label_en\":\"\"},\"tracerCategory\":{},\"unit\":{\"id\":\"\"}},\"usageType\":{\"id\":\"\"},\"usagePeriod\":{\"usagePeriodId\":1},\"repeatUsagePeriod\":{\"usagePeriodId\":1},\"noOfPersons\":\"\"}";
            String emptyFuNodeString3 = "\"fuNode\":{\"lagInMonths\":0,\"noOfForecastingUnitsPerPerson\":\"\",\"usageFrequency\":\"\",\"forecastingUnit\":{\"label\":{\"label_en\":\"\"},\"tracerCategory\":{\"id\":3},\"unit\":{\"id\":\"\"}},\"usageType\":{\"id\":\"\"},\"usagePeriod\":{\"usagePeriodId\":1},\"repeatUsagePeriod\":{\"usagePeriodId\":1},\"noOfPersons\":\"\"}";
            String emptyFuNodeString4 = "\"fuNode\":{\"oneTimeUsage\":\"false\",\"lagInMonths\":0,\"noOfForecastingUnitsPerPerson\":\"\",\"usageFrequency\":\"\",\"forecastingUnit\":{\"label\":{\"label_en\":\"\"},\"tracerCategory\":{\"id\":3},\"unit\":{\"id\":\"\"}},\"usageType\":{\"id\":\"\"},\"usagePeriod\":{\"usagePeriodId\":1},\"repeatUsagePeriod\":{\"usagePeriodId\":1},\"noOfPersons\":\"\"}";
            String emptyFuNodeString5 = "\"fuNode\":{\"oneTimeUsage\":\"false\",\"lagInMonths\":0,\"noOfForecastingUnitsPerPerson\":\"\",\"usageFrequency\":\"\",\"forecastingUnit\":{\"label\":{\"label_en\":\"\"},\"tracerCategory\":{},\"unit\":{\"id\":\"\"}},\"usageType\":{\"id\":\"\"},\"usagePeriod\":{\"usagePeriodId\":1},\"repeatUsagePeriod\":{\"usagePeriodId\":1},\"noOfPersons\":\"\"}";
            String emptyFuNodeString6 = "\"fuNode\":{\"oneTimeUsage\":\"false\",\"lagInMonths\":0,\"noOfForecastingUnitsPerPerson\":\"\",\"usageFrequency\":null,\"forecastingUnit\":{\"label\":{\"label_en\":\"\"},\"tracerCategory\":{\"id\":18},\"unit\":{\"id\":\"\"}},\"usageType\":{\"id\":\"\"},\"usagePeriod\":{\"usagePeriodId\":1},\"repeatUsagePeriod\":{\"usagePeriodId\":1},\"noOfPersons\":\"\"}";
            String emptyFuNodeString7 = "\"fuNode\":{\"oneTimeUsage\":\"false\",\"lagInMonths\":0,\"noOfForecastingUnitsPerPerson\":\"\",\"usageFrequency\":\"\",\"forecastingUnit\":{\"label\":{\"label_en\":\"\"},\"tracerCategory\":{\"id\":18},\"unit\":{\"id\":\"\"}},\"usageType\":{\"id\":\"\"},\"usagePeriod\":{\"usagePeriodId\":1},\"repeatUsagePeriod\":{\"usagePeriodId\":1},\"noOfPersons\":\"\"}";

            json = json.replace(emptyFuNodeString1, "\"fuNode\": null");
            json = json.replace(emptyFuNodeString2, "\"fuNode\": null");
            json = json.replace(emptyFuNodeString3, "\"fuNode\": null");
            json = json.replace(emptyFuNodeString4, "\"fuNode\": null");
            json = json.replace(emptyFuNodeString5, "\"fuNode\": null");
            json = json.replace(emptyFuNodeString6, "\"fuNode\": null");
            json = json.replace(emptyFuNodeString7, "\"fuNode\": null");
            json = json.replace(",,", ",");
            String emptyPuNodeString1 = "\"puNode\":{\"planningUnit\":{\"unit\":{}},\"refillMonths\":\"\"}";
            String emptyPuNodeString2 = "\"puNode\":{\"planningUnit\":{\"id\":\"\",\"unit\":{},\"multiplier\":\"\"},\"refillMonths\":\"\"}";
            String emptyPuNodeString3 = "\"puNode\":{\"planningUnit\":{\"id\":\"\",\"unit\":{\"id\":\"\"},\"multiplier\":\"\"},\"refillMonths\":\"\"}";
            String emptyPuNodeString4 = "\"puNode\":{\"planningUnit\":{\"id\":\"\",\"unit\":{\"id\":\"\"},\"multiplier\":\"\"},\"refillMonths\":\"\",\"sharePlanningUnit\":\"false\"}";
            json = json.replace(emptyPuNodeString1, "\"puNode\": null");
            json = json.replace(emptyPuNodeString2, "\"puNode\": null");
            json = json.replace(emptyPuNodeString3, "\"puNode\": null");
            json = json.replace(emptyPuNodeString4, "\"puNode\": null");
            json = json.replace(",,", ",");
            String emptyUsageFrequency = "\"usageFrequency\":\"\",";
            json = json.replace(emptyUsageFrequency, "\"usageFrequency\":null,");
            String emptyUsagePeriod = "\"usagePeriod\":{\"usagePeriodId\":\"\"},";
            json = json.replace(emptyUsagePeriod, "\"usagePeriod\":null,");
            String emptyRepeatUsagePeriod = "\"repeatUsagePeriod\":{\"usagePeriodId\":\"\"},";
            json = json.replace(emptyRepeatUsagePeriod, "\"repeatUsagePeriod\":null,");
            String emptyNodeUnitString = "\"nodeUnit\":{\"id\":\"\"},";
            json = json.replace(emptyNodeUnitString, "\"nodeUnit\":null,");
            String emptyParentItem = ",\"parentItem\":{\"payload\":{\"nodeUnit\":{}}}";
            json = json.replace(emptyParentItem, "");
            Gson gson = new GsonBuilder()
                    .registerTypeAdapter(Double.class, new EmptyDoubleTypeAdapter())
                    .registerTypeAdapter(Integer.class, new EmptyIntegerTypeAdapter())
                    .setDateFormat("yyyy-MM-dd HH:mm:ss").setLenient()
                    .create();
            DatasetDataJson datasetData = gson.fromJson(json, new TypeToken<DatasetDataJson>() {
            }.getType());
            int latestVersion = this.programService.getLatestVersionForPrograms("" + datasetData.getProgramId()).get(0).getVersionId();
            if (latestVersion == comparedVersionId) {
                boolean checkIfRequestExists = this.commitRequestService.checkIfCommitRequestExistsForProgram(datasetData.getProgramId());
                if (!checkIfRequestExists) {
                    CustomUserDetails curUser = this.userService.getCustomUserByUserIdForApi(((CustomUserDetails) auth.getPrincipal()).getUserId(), ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest().getMethod(), ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest().getRequestURI());
                    int commitRequestId = this.commitRequestService.saveDatasetData(datasetData, json, curUser);
                    logger.info("Commit request received and stored in the db commitRequestId=" + commitRequestId);
                    return new ResponseEntity(commitRequestId, HttpStatus.OK);
                } else {
                    logger.error("Request already exists");
                    return new ResponseEntity(new ResponseCode("static.commitVersion.requestAlreadyExists"), HttpStatus.NOT_ACCEPTABLE);
                }
            } else {
                logger.error("Compared version is not latest");
                return new ResponseEntity(new ResponseCode("static.commitVersion.versionIsOutDated"), HttpStatus.NOT_ACCEPTABLE);
            }
//            this.programDataService.getProgramData(programData.getProgramId(), v.getVersionId(), curUser,false)
        } catch (AccessControlFailedException e) {
            logger.error("Error while trying to update ProgramData", e);
            return new ResponseEntity(new ResponseCode("static.message.addFailed"), HttpStatus.CONFLICT);
        } catch (CouldNotSaveException e) {
            logger.error("Error while trying to update ProgramData", e);
            return new ResponseEntity(new ResponseCode("static.message.updateFailed"), HttpStatus.PRECONDITION_FAILED);
        } catch (EmptyResultDataAccessException e) {
            logger.error("Error while trying to update ProgramData", e);
            return new ResponseEntity(new ResponseCode("static.message.updateFailed"), HttpStatus.NOT_FOUND);
        } catch (AccessDeniedException e) {
            logger.error("Error while trying to update ProgramData", e);
            return new ResponseEntity(new ResponseCode("static.message.updateFailed"), HttpStatus.FORBIDDEN);
        } catch (Exception e) {
            logger.error(json);
            logger.error("Error while trying to update ProgramData", e);
            return new ResponseEntity(new ResponseCode("static.message.updateFailed"), HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    // Part 2 of the Commit Request
    // @GetMapping("/processCommitRequest")
    @Scheduled(fixedDelay = 60000, initialDelay = 60000)//fixedDelay=1mins and initialDelay=1min
    public ResponseEntity processCommitRequest() {
        try {
            String propertyFilePath = QAT_FILE_PATH + "/properties/scheduler.properties";
            Properties props = new Properties();
            props.load(new FileInputStream(propertyFilePath));
            String propertyValue = props.getProperty("commitRequestSchedulerActive");
            if (propertyValue.equals("1")) {
                logger.info("Starting the Commit request scheduler");
                CustomUserDetails curUser = this.userService.getCustomUserByUserId(1);
                this.commitRequestService.processCommitRequest(curUser);
                return new ResponseEntity(HttpStatus.OK);
            } else {
                logger.info("Commit request scheduler is not active");
                return new ResponseEntity(new ResponseCode("Scheduler for commit is not active"), HttpStatus.PRECONDITION_FAILED);
            }
//        } catch (CouldNotSaveException e) {
//            logger.error("Error while trying to processCommitRequest", e);
//            return new ResponseEntity(new ResponseCode("static.message.updateFailed"), HttpStatus.PRECONDITION_FAILED);
        } catch (EmptyResultDataAccessException e) {
            logger.error("Error while trying to processCommitRequest", e);
            return new ResponseEntity(new ResponseCode("static.message.updateFailed"), HttpStatus.NOT_FOUND);
        } catch (AccessDeniedException e) {
            logger.error("Error while trying to processCommitRequest", e);
            return new ResponseEntity(new ResponseCode("static.message.updateFailed"), HttpStatus.FORBIDDEN);
        } catch (Exception e) {
            logger.error("Error while trying to processCommitRequest", e);
            return new ResponseEntity(new ResponseCode("static.message.updateFailed"), HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    /**
     * Seems to return a list of the CommitRequests with status
     *
     * @param spcr
     * @param requestStatus
     * @param auth
     * @return
     */
    @PostMapping("/getCommitRequest/{requestStatus}")
    public ResponseEntity getProgramDataCommitRequest(@RequestBody CommitRequestInput spcr, @PathVariable(value = "requestStatus", required = true) int requestStatus, Authentication auth) {
        try {
            CustomUserDetails curUser = this.userService.getCustomUserByUserIdForApi(((CustomUserDetails) auth.getPrincipal()).getUserId(), ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest().getMethod(), ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest().getRequestURI());
            List<CommitRequest> spcrList = this.commitRequestService.getCommitRequestList(spcr, requestStatus, curUser);
            return new ResponseEntity(spcrList, HttpStatus.OK);
//            this.programDataService.getProgramData(programData.getProgramId(), v.getVersionId(), curUser,false)
        } catch (AccessDeniedException e) {
            logger.error("Error while trying to get SupplyPlanCommitRequest list", e);
            return new ResponseEntity(new ResponseCode("static.message.listFailed"), HttpStatus.FORBIDDEN);
        } catch (Exception e) {
            logger.error("Error while trying to get SupplyPlanCommitRequest list", e);
            return new ResponseEntity(new ResponseCode("static.message.listFailed"), HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    /**
     * Gets the status of a CommitRequest based on Id
     *
     * @param commitRequestId
     * @return
     */
    @GetMapping("/sendNotification/{commitRequestId}")
    public ResponseEntity sendNotification(@PathVariable("commitRequestId") int commitRequestId) {
        try {
            return new ResponseEntity(this.commitRequestService.getCommitRequestStatusByCommitRequestId(commitRequestId), HttpStatus.OK);
        } catch (Exception e) {
            return new ResponseEntity(new ResponseCode("static.message.listFailed"), HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
}
