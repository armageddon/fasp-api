/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package cc.altius.FASP.model.DTO.rowMapper;

import cc.altius.FASP.model.DTO.PrgLabelDTO;
import cc.altius.FASP.model.DTO.PrgUnitTypeDTO;
import java.sql.ResultSet;
import java.sql.SQLException;
import org.springframework.jdbc.core.RowMapper;

/**
 *
 * @author altius
 */
public class PrgUnitTypeDTORowMapper implements RowMapper<PrgUnitTypeDTO>{

    @Override
    public PrgUnitTypeDTO mapRow(ResultSet rs, int i) throws SQLException {
        PrgUnitTypeDTO unitType=new PrgUnitTypeDTO();
        unitType.setUnitTypeId(rs.getInt("UNIT_TYPE_ID"));
        PrgLabelDTO label = new PrgLabelDTO();
        label.setLabelEn(rs.getString("LABEL_EN"));
        label.setLabelFr(rs.getString("LABEL_FR"));
        label.setLabelPr(rs.getString("LABEL_PR"));
        label.setLabelSp(rs.getString("LABEL_SP"));
        unitType.setLabel(label);
        return unitType;
    }

    
    
    
    
}
