/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package cc.altius.FASP.service;

import java.io.FileNotFoundException;
import java.io.IOException;
import javax.xml.parsers.ParserConfigurationException;
import org.springframework.jdbc.BadSqlGrammarException;
import org.xml.sax.SAXException;

/**
 *
 * @author altius
 */
public interface ImportProductCatalogueService {

    public void importProductCatalogue() throws ParserConfigurationException, SAXException, IOException, FileNotFoundException, BadSqlGrammarException;
}
