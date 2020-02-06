/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package cc.altius.FASP.model.rowMapper;

import cc.altius.FASP.model.Label;
import cc.altius.FASP.model.Language;
import cc.altius.FASP.model.Realm;
import cc.altius.FASP.model.Role;
import cc.altius.FASP.model.User;
import java.sql.ResultSet;
import java.sql.SQLException;
import org.springframework.jdbc.core.RowMapper;

/**
 *
 * @author altius
 */
public class UserRowMapper implements RowMapper<User> {
    
    @Override
    public User mapRow(ResultSet rs, int i) throws SQLException {
        User u = new User();
        u.setUserId(rs.getInt("USER_ID"));
        u.setUsername(rs.getString("USERNAME"));
        u.setEmailId(rs.getString("EMAIL_ID"));
        u.setPhoneNumber(rs.getString("PHONE_NO"));
        Realm r = new Realm();
        r.setRealmId(rs.getInt("REALM_ID"));
        r.setRealmCode(rs.getString("REALM_CODE"));
        u.setRealm(r);
        Language l = new Language();
        l.setLanguageId(rs.getInt("LANGUAGE_ID"));
        l.setLanguageName(rs.getString("LANGUAGE_NAME"));
        u.setLanguage(l);
        Role role = new Role();
        role.setRoleId(rs.getString("ROLE_ID"));
        Label lb = new Label();
        lb.setLabelId(rs.getInt("LABEL_ID"));
        lb.setEngLabel(rs.getString("LABEL_EN"));
        lb.setFreLabel(rs.getString("LABEL_FR"));
        lb.setSpaLabel(rs.getString("LABEL_SP"));
        lb.setPorLabel(rs.getString("LABEL_PR"));
        role.setLabel(lb);
        u.setRole(role);
        u.setLastLoginDate(rs.getDate("LAST_LOGIN_DATE"));
        u.setFaildAttempts(rs.getInt("FAILED_ATTEMPTS"));
        u.setActive(rs.getBoolean("ACTIVE"));
        return u;
    }
    
}
