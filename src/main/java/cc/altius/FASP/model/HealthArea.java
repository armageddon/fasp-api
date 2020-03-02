/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package cc.altius.FASP.model;

import com.fasterxml.jackson.annotation.JsonIgnore;
import java.io.Serializable;
import java.util.List;

/**
 *
 * @author akil
 */
public class HealthArea extends BaseModel implements Serializable {

    private int healthAreaId;
    private Realm realm;
    private Label label;
    @JsonIgnore
    List<RealmCountry> realmCountryList;
    int[] realmCountryArray;

    public HealthArea() {
    }

    public HealthArea(int healthAreaId, Realm realm, Label label) {
        this.healthAreaId = healthAreaId;
        this.realm = realm;
        this.label = label;
    }

    public int getHealthAreaId() {
        return healthAreaId;
    }

    public void setHealthAreaId(int healthAreaId) {
        this.healthAreaId = healthAreaId;
    }

    public Realm getRealm() {
        return realm;
    }

    public void setRealm(Realm realm) {
        this.realm = realm;
    }

    public Label getLabel() {
        return label;
    }

    public void setLabel(Label label) {
        this.label = label;
    }

    public List<RealmCountry> getRealmCountryList() {
        return realmCountryList;
    }

    public void setRealmCountryList(List<RealmCountry> realmCountryList) {
        this.realmCountryList = realmCountryList;
    }

    public int[] getRealmCountryArray() {
        return realmCountryArray;
    }

    public void setRealmCountryArray(int[] realmCountryArray) {
        this.realmCountryArray = realmCountryArray;
    }

    @Override
    public int hashCode() {
        int hash = 7;
        hash = 47 * hash + this.healthAreaId;
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
        final HealthArea other = (HealthArea) obj;
        if (this.healthAreaId != other.healthAreaId) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "HealthArea{" + "healthAreaId=" + healthAreaId + ", realm=" + realm + ", label=" + label + '}';
    }

}
