/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package cc.altius.FASP.service;

import cc.altius.FASP.model.Organisation;

import cc.altius.FASP.model.DTO.PrgOrganisationDTO;

import java.util.List;

/**
 *
 * @author altius
 */
public interface OrganisationService {

    public int addOrganisation(Organisation organisation, int curUser);

    public int updateOrganisation(Organisation organisation, int curUser);

    public List<Organisation> getOrganisationList();

    public Organisation getOrganisationById(int organisationId);

    public List<PrgOrganisationDTO> getOrganisationListForSync(String lastSyncDate);

}
