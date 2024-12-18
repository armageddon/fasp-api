/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package cc.altius.FASP.model;

import cc.altius.FASP.framework.JsonDateTimeDeserializer;
import cc.altius.FASP.framework.JsonDateTimeSerializer;
import com.fasterxml.jackson.annotation.JsonView;
import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import java.io.Serializable;
import java.util.Date;
import java.util.Objects;

/**
 *
 * @author akil
 */
public class UserAcl implements Serializable {

    @JsonView(Views.UserListView.class)
    private int userAclId;
    @JsonView(Views.UserListView.class)
    private int userId;
    @JsonView(Views.UserListView.class)
    private String username;
    @JsonView(Views.UserListView.class)
    private String roleId;
    @JsonView(Views.UserListView.class)
    private Label roleDesc;
    @JsonView(Views.UserListView.class)
    private int realmCountryId;
    @JsonView(Views.UserListView.class)
    private Label countryName;
    @JsonView(Views.UserListView.class)
    private int healthAreaId;
    @JsonView(Views.UserListView.class)
    private Label healthAreaName;
    @JsonView(Views.UserListView.class)
    private int organisationId;
    @JsonView(Views.UserListView.class)
    private Label organisationName;
    @JsonView(Views.UserListView.class)
    private int programId;
    @JsonView(Views.UserListView.class)
    private Label programName;
    @JsonView(Views.UserListView.class)
    private String programCode;
    @JsonView(Views.UserListView.class)
    private int programTypeId;
    @JsonDeserialize(using = JsonDateTimeDeserializer.class)
    @JsonSerialize(using = JsonDateTimeSerializer.class)
    @JsonView(Views.UserListView.class)
    private Date lastModifiedDate;

    public UserAcl() {
    }

    public UserAcl(int userId, String roleId, int realmCountryId, int healthAreaId, int organisationId, int programId, String lastModifiedDate) {
        this.userId = userId;
        this.roleId = roleId;
        this.setRealmCountryId(realmCountryId);
        this.setHealthAreaId(healthAreaId);
        this.setOrganisationId(organisationId);
        this.setProgramId(programId);
        this.lastModifiedDate = this.lastModifiedDate;
    }

    public UserAcl(int userId, String roleId, Label roleDesc, int realmCountryId, Label countryName, int healthAreaId, Label healthAreaName, int organisationId, Label organisationName, int programId, Label programName, String programCode, int programTypeId, Date lastModifiedDate) {
        this.userId = userId;
        this.roleId = roleId;
        this.setRealmCountryId(realmCountryId);
        this.setHealthAreaId(healthAreaId);
        this.setOrganisationId(organisationId);
        this.setProgramId(programId);
        this.roleDesc = roleDesc;
        this.countryName = countryName;
        this.healthAreaName = healthAreaName;
        this.organisationName = organisationName;
        this.programName = programName;
        this.programCode = programCode;
        this.programTypeId = programTypeId;
        this.lastModifiedDate = lastModifiedDate;
    }

    public int getUserAclId() {
        return userAclId;
    }

    public void setUserAclId(int userAclId) {
        this.userAclId = userAclId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getRoleId() {
        return roleId;
    }

    public void setRoleId(String roleId) {
        this.roleId = roleId;
    }

    public Label getRoleDesc() {
        return roleDesc;
    }

    public void setRoleDesc(Label roleDesc) {
        this.roleDesc = roleDesc;
    }

    public int getRealmCountryId() {
        return realmCountryId;
    }

    public void setRealmCountryId(int realmCountryId) {
        this.realmCountryId = realmCountryId == 0 ? -1 : realmCountryId;
    }

    public Label getCountryName() {
        return countryName;
    }

    public void setCountryName(Label countryName) {
        this.countryName = countryName;
    }

    public int getHealthAreaId() {
        return healthAreaId;
    }

    public void setHealthAreaId(int healthAreaId) {
        this.healthAreaId = healthAreaId == 0 ? -1 : healthAreaId;
    }

    public Label getHealthAreaName() {
        return healthAreaName;
    }

    public void setHealthAreaName(Label healthAreaName) {
        this.healthAreaName = healthAreaName;
    }

    public int getOrganisationId() {
        return organisationId;
    }

    public void setOrganisationId(int organisationId) {
        this.organisationId = organisationId == 0 ? -1 : organisationId;
    }

    public Label getOrganisationName() {
        return organisationName;
    }

    public void setOrganisationName(Label organisationName) {
        this.organisationName = organisationName;
    }

    public int getProgramId() {
        return programId;
    }

    public void setProgramId(int programId) {
        this.programId = programId == 0 ? -1 : programId;
    }

    public Label getProgramName() {
        return programName;
    }

    public void setProgramName(Label programName) {
        this.programName = programName;
    }

    public String getProgramCode() {
        return programCode;
    }

    public void setProgramCode(String programCode) {
        this.programCode = programCode;
    }

    public int getProgramTypeId() {
        return programTypeId;
    }

    public void setProgramTypeId(int programTypeId) {
        this.programTypeId = programTypeId;
    }

    public Date getLastModifiedDate() {
        return lastModifiedDate;
    }

    public void setLastModifiedDate(Date lastModifiedDate) {
        this.lastModifiedDate = lastModifiedDate;
    }

    @Override
    public int hashCode() {
        int hash = 7;
        hash = 79 * hash + this.userId;
        hash = 31 * hash + Objects.hashCode(this.roleId);
        hash = 79 * hash + this.realmCountryId;
        hash = 79 * hash + this.healthAreaId;
        hash = 79 * hash + this.organisationId;
        hash = 79 * hash + this.programId;
        return hash;
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj) {
            return true;
        }
        if (obj == null) {
            return false;
        }
        if (getClass() != obj.getClass()) {
            return false;
        }
        final UserAcl other = (UserAcl) obj;
        if (this.userId != other.userId) {
            return false;
        }
        if (this.realmCountryId != other.realmCountryId) {
            return false;
        }
        if (this.healthAreaId != other.healthAreaId) {
            return false;
        }
        if (this.organisationId != other.organisationId) {
            return false;
        }
        if (this.programId != other.programId) {
            return false;
        }
        return Objects.equals(this.roleId, other.roleId);
    }

    @Override
    public String toString() {
        return "UserAcl{" + "userId=" + userId + ", roleId=" + roleId + ", realmCountryId=" + realmCountryId + ", healthAreaId=" + healthAreaId + ", organisationId=" + organisationId + ", programId=" + programId + '}';
    }

}
