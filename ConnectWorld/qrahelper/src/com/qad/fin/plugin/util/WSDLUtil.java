package com.qad.fin.plugin.util;

import java.io.*;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathExpression;
import javax.xml.xpath.XPathFactory;

import org.w3c.dom.Document;
import org.w3c.dom.NamedNodeMap;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

public class WSDLUtil {

	public ArrayList<String> GetElementList(String urlPath)
			throws MalformedURLException, SAXException, IOException, ParserConfigurationException {

		Document d = DocumentBuilderFactory.newInstance().newDocumentBuilder().parse(new URL(urlPath).openStream());
		NodeList elements = d.getElementsByTagName("element");
		ArrayList<String> elementList = new ArrayList();
		for (int j = 0; j < elements.getLength(); j++) {
			Node node = elements.item(j);

			NamedNodeMap map = node.getAttributes();
			for (int i = 0; i < map.getLength(); i++) {
				if (map.item(i).toString().startsWith("prodata:datasetName")) {
					elementList.add(node.getAttributes().getNamedItem("name").getNodeValue());
				}

			}
		}
		return elementList;
	}

	public ArrayList<String> GetFieldList(String wsdlURL, String dsName) {
		ArrayList<String> ret = new ArrayList();
		String dsName1 = dsName;
		if (dsName.endsWith("s")) {
			dsName1 = dsName.substring(0, dsName.length() - 1);
		}

		try {

			Document document = DocumentBuilderFactory.newInstance().newDocumentBuilder()
					.parse(new URL(wsdlURL).openStream());

			XPath xPath = XPathFactory.newInstance().newXPath();
			XPathExpression expression = xPath.compile("//element[@maxOccurs]/complexType/sequence");
			NodeList nodelist = (NodeList) expression.evaluate(document, XPathConstants.NODESET);

			for (int i = 0; i < nodelist.getLength(); i++) {
				Node node = nodelist.item(i);
				String datasetName = node.getParentNode().getParentNode().getAttributes().getNamedItem("name")
						.getNodeValue();

				for (int j = 0; j < node.getChildNodes().getLength(); j++) {
					if (datasetName.equals(dsName) || datasetName.equals(dsName1)) {
						ret.add(node.getChildNodes().item(j).getAttributes().getNamedItem("name").getNodeValue() + "("
								+ (node.getChildNodes().item(j).getAttributes().getNamedItem("type").getNodeValue())
								+ ")");
					}
				}

			}
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return ret;

	}

	public ArrayList<String> getFieldListForInstanceTable(String filename, String dsName)  {
		Document doc = null;
		try {
			doc = DocumentBuilderFactory.newInstance().newDocumentBuilder().parse(new URL(filename).openStream());
		} catch (MalformedURLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SAXException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (ParserConfigurationException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		ArrayList<String> ret = new ArrayList<String>();
		NodeList elements = doc.getElementsByTagName("element");
		for (int j = 0; j < elements.getLength(); j++) {
			Node node = elements.item(j);

			NamedNodeMap map = node.getAttributes();
			for (int i = 0; i < map.getLength(); i++) {
				if (map.item(i).toString().startsWith("prodata:datasetName")) {
					if (node.getAttributes().getNamedItem("name").getNodeValue().equals(dsName)) {
						NodeList els = node.getChildNodes();
						for (int k = 0; k < els.getLength(); k++) {
							if (els.item(k).getNodeName().equals("complexType")) {
								NodeList tablelist = els.item(k).getChildNodes().item(0).getChildNodes();
								for (int kk = 0; kk < tablelist.getLength(); kk++) {
									NodeList fieldsList = tablelist.item(kk).getFirstChild().getFirstChild()
											.getChildNodes();
									ret.add(tablelist.item(kk).getAttributes().getNamedItem("name").getNodeValue());
									for (int jj = 0; jj < fieldsList.getLength(); jj++) {
										ret.add("  " + fieldsList.item(jj).getAttributes().getNamedItem("name").getNodeValue() + "("
												+ fieldsList.item(jj).getAttributes().getNamedItem("type").getNodeValue() + ")");

									}
								}
							}
						}

					}
				}

			}

		}

		return ret;
	}
}
