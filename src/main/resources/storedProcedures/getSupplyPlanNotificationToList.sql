CREATE DEFINER=`faspUser`@`%` PROCEDURE `getSupplyPlanNotificationToList`(VAR_PROGRAM_ID INT(10), VAR_VERSION_ID INT(10), VAR_STATUS_ID INT(10))
BEGIN
    -- This SP is only called for Final Supply Plan submissions not for Draft
    SET @programId = VAR_PROGRAM_ID;
    SET @versionId = VAR_VERSION_ID;
    SET @statusId = VAR_STATUS_ID;
    -- statusId = 1 -> Final Submitted
    -- statusId = 2 -> Final Approved
    -- statusId = 3 -> Final Rejected
    -- statusId = 4 -> No review required
    SELECT pv.CREATED_BY `COMMITTED_BY`, pvt.LAST_MODIFIED_BY INTO @committedId, @approverId FROM rm_program_version pv LEFT JOIN rm_program_version_trans pvt ON pv.PROGRAM_VERSION_ID=pvt.PROGRAM_VERSION_ID AND pvt.VERSION_STATUS_ID=@statusId WHERE pv.PROGRAM_ID=@programId and pv.VERSION_ID=@versionId;
    
    IF @statusId=1 THEN
        -- Final submitted
        -- toList
        SELECT u.USER_ID, u.USERNAME, u.EMAIL_ID
        FROM vw_program p 
        LEFT JOIN us_user_acl acl ON 
            (acl.REALM_COUNTRY_ID is null OR acl.REALM_COUNTRY_ID=p.REALM_COUNTRY_ID)
            AND (acl.PROGRAM_ID is null OR acl.PROGRAM_ID=p.PROGRAM_ID)
            AND (acl.HEALTH_AREA_ID is null OR FIND_IN_SET(acl.HEALTH_AREA_ID,p.HEALTH_AREA_ID))
            AND (acl.ORGANISATION_ID is null OR acl.ORGANISATION_ID=p.ORGANISATION_ID)
        LEFT JOIN us_user u ON acl.USER_ID=u.USER_ID
        LEFT JOIN us_user_role ur ON u.USER_ID=ur.USER_ID 
        LEFT JOIN us_role_business_function rbf ON ur.ROLE_ID=rbf.ROLE_ID
        WHERE u.REALM_ID=1 AND rbf.BUSINESS_FUNCTION_ID='ROLE_BF_NOTIFICATION_TO_COMMIT' AND p.PROGRAM_ID=@programId AND u.ACTIVE
        GROUP BY u.USER_ID;

    ELSEIF @statusId=2 THEN
        -- Approved
        -- toList
        SELECT u.USER_ID, u.USERNAME, u.EMAIL_ID 
        FROM (
            SELECT u.USER_ID
            FROM vw_program p 
            LEFT JOIN us_user_acl acl ON 
                    (acl.REALM_COUNTRY_ID is null OR acl.REALM_COUNTRY_ID=p.REALM_COUNTRY_ID)
                    AND (acl.PROGRAM_ID is null OR acl.PROGRAM_ID=p.PROGRAM_ID)
                    AND (acl.HEALTH_AREA_ID is null OR FIND_IN_SET(acl.HEALTH_AREA_ID,p.HEALTH_AREA_ID))
                    AND (acl.ORGANISATION_ID is null OR acl.ORGANISATION_ID=p.ORGANISATION_ID)
            LEFT JOIN us_user u ON acl.USER_ID=u.USER_ID
            LEFT JOIN us_user_role ur ON u.USER_ID=ur.USER_ID 
            LEFT JOIN us_role_business_function rbf ON ur.ROLE_ID=rbf.ROLE_ID
            WHERE u.REALM_ID=1 AND rbf.BUSINESS_FUNCTION_ID='ROLE_BF_NOTIFICATION_TO_APPROVE' AND p.PROGRAM_ID=@programId AND u.ACTIVE

        UNION

            SELECT @committedId
        ) uTo
        LEFT JOIN us_user u ON uTo.USER_ID=u.USER_ID
        GROUP BY u.USER_ID;

    ELSEIF @statusId=3 THEN
        -- Rejected
        -- toList
        SELECT u.USER_ID, u.USERNAME, u.EMAIL_ID 
        FROM (
            SELECT u.USER_ID
            FROM vw_program p 
            LEFT JOIN us_user_acl acl ON 
                    (acl.REALM_COUNTRY_ID is null OR acl.REALM_COUNTRY_ID=p.REALM_COUNTRY_ID)
                    AND (acl.PROGRAM_ID is null OR acl.PROGRAM_ID=p.PROGRAM_ID)
                    AND (acl.HEALTH_AREA_ID is null OR FIND_IN_SET(acl.HEALTH_AREA_ID,p.HEALTH_AREA_ID))
                    AND (acl.ORGANISATION_ID is null OR acl.ORGANISATION_ID=p.ORGANISATION_ID)
            LEFT JOIN us_user u ON acl.USER_ID=u.USER_ID
            LEFT JOIN us_user_role ur ON u.USER_ID=ur.USER_ID 
            LEFT JOIN us_role_business_function rbf ON ur.ROLE_ID=rbf.ROLE_ID
            WHERE u.REALM_ID=1 AND rbf.BUSINESS_FUNCTION_ID='ROLE_BF_NOTIFICATION_TO_REJECT' AND p.PROGRAM_ID=@programId AND u.ACTIVE

        UNION

            SELECT @committedId
        ) uTo
        LEFT JOIN us_user u ON uTo.USER_ID=u.USER_ID
        GROUP BY u.USER_ID;

    ELSEIF @statusId=4 THEN
        -- No review required
        -- toList
        SELECT u.USER_ID, u.USERNAME, u.EMAIL_ID 
        FROM (
            SELECT u.USER_ID
            FROM vw_program p 
            LEFT JOIN us_user_acl acl ON 
                    (acl.REALM_COUNTRY_ID is null OR acl.REALM_COUNTRY_ID=p.REALM_COUNTRY_ID)
                    AND (acl.PROGRAM_ID is null OR acl.PROGRAM_ID=p.PROGRAM_ID)
                    AND (acl.HEALTH_AREA_ID is null OR FIND_IN_SET(acl.HEALTH_AREA_ID,p.HEALTH_AREA_ID))
                    AND (acl.ORGANISATION_ID is null OR acl.ORGANISATION_ID=p.ORGANISATION_ID)
            LEFT JOIN us_user u ON acl.USER_ID=u.USER_ID
            LEFT JOIN us_user_role ur ON u.USER_ID=ur.USER_ID 
            LEFT JOIN us_role_business_function rbf ON ur.ROLE_ID=rbf.ROLE_ID
            WHERE u.REALM_ID=1 AND rbf.BUSINESS_FUNCTION_ID='ROLE_BF_NOTIFICATION_TO_NOREVIEW' AND p.PROGRAM_ID=@programId AND u.ACTIVE

        UNION

            SELECT @committedId
        ) uTo
        LEFT JOIN us_user u ON uTo.USER_ID=u.USER_ID
        GROUP BY u.USER_ID;
    END IF; 
    
END