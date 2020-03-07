/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package cc.altius.FASP.service;

import cc.altius.FASP.model.CustomUserDetails;
import cc.altius.FASP.model.Unit;
import java.util.List;

/**
 *
 * @author akil
 */
public interface UnitService {

    public int addUnit(Unit u, CustomUserDetails curUser);

    public int updateUnit(Unit u, CustomUserDetails curUser);

    public List<Unit> getUnitList();

    public Unit getUnitById(int unitId);
}
