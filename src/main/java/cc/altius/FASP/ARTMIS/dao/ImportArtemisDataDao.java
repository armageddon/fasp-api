/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package cc.altius.FASP.ARTMIS.dao;

import cc.altius.FASP.model.Shipment;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.List;
import javax.xml.parsers.ParserConfigurationException;
import org.xml.sax.SAXException;

/**
 *
 * @author altius
 */
public interface ImportArtemisDataDao {

    public void importOrderAndShipmentData(String orderDataFilePath, String shipmentDataFilePath) throws ParserConfigurationException, SAXException, IOException, FileNotFoundException;
}
