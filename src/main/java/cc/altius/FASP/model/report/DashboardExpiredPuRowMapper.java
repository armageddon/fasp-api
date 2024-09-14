/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package cc.altius.FASP.model.report;

import cc.altius.FASP.model.SimpleObject;
import cc.altius.FASP.model.rowMapper.LabelRowMapper;
import java.sql.ResultSet;
import java.sql.SQLException;
import org.springframework.jdbc.core.RowMapper;

/**
 *
 * @author akil
 */
public class DashboardExpiredPuRowMapper implements RowMapper<DashboardExpiredPu> {

    @Override
    public DashboardExpiredPu mapRow(ResultSet rs, int rowNum) throws SQLException {
        return new DashboardExpiredPu(
                new SimpleObject(rs.getInt("PLANNING_UNIT_ID"), new LabelRowMapper("").mapRow(rs, rowNum)),
                rs.getDate("EXPIRY_DATE"),
                rs.getInt("BATCH_ID"), rs.getString("BATCH_NO"), rs.getBoolean("AUTO_GENERATED"),
                rs.getInt("EXPIRED_STOCK"),
                rs.getDouble("RATE"));
    }

}
