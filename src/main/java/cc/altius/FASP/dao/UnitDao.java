/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package cc.altius.FASP.dao;

import cc.altius.FASP.model.DTO.PrgUnitDTO;
import cc.altius.FASP.model.Unit;
import java.util.List;

/**
 *
 * @author altius
 */
public interface UnitDao {

    public List<PrgUnitDTO> getUnitListForSync(String lastSyncDate);

    public int addUnit(Unit u, int curUser);

    public int updateUnit(Unit u, int CurUser);

    public List<Unit> getUnitList();

    public Unit getUnitById(int unitId);
}
