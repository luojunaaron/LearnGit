package com.qad.fin.plugin.ui;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.net.MalformedURLException;
import java.util.ArrayList;

import javax.xml.parsers.ParserConfigurationException;

import org.eclipse.core.resources.IFile;
import org.eclipse.core.resources.ResourcesPlugin;
import org.eclipse.core.runtime.IPath;
import org.eclipse.core.runtime.Path;
import org.eclipse.jface.dialogs.MessageDialog;
import org.eclipse.jface.preference.IPreferenceStore;
import org.eclipse.jface.wizard.WizardPage;
import org.eclipse.swt.SWT;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.widgets.Label;
import org.eclipse.swt.widgets.Shell;
import org.eclipse.swt.widgets.Text;
import org.xml.sax.SAXException;

import com.qad.fin.plugin.activator.Activator;
import com.qad.fin.plugin.util.HTMLReader;
import com.qad.fin.plugin.util.WSDLUtil;

import org.eclipse.swt.widgets.Button;
import org.eclipse.swt.widgets.Combo;
import org.eclipse.swt.widgets.List;
import org.eclipse.swt.events.SelectionAdapter;
import org.eclipse.swt.events.SelectionEvent;
import org.eclipse.swt.widgets.Group;
import org.eclipse.ui.IWorkbenchPage;
import org.eclipse.ui.IWorkbenchWindow;
import org.eclipse.ui.PlatformUI;
import org.eclipse.ui.ide.IDE;

public class TypeScriptPage extends WizardPage {
	Text wsdlPathText;
	ArrayList<String> components;
	Combo elementCombo;
	Button chkInterfaceapi;
	Button chkUIWidgetHelper;
	Button chkInterfaceinstancetable;
	Text fileNameText;
	List dataFieldsList;
	Combo businessEntityCombo ;
	Button chkSkipCustom;
    Text txtAutofield;
    String host ;
	String port ;
	Button chkSkipRowID ;
	Button chkSkipQAD;

	/**
	 * Create the wizard.
	 */
	public TypeScriptPage() {
		super("wizardPage");
		setTitle("Typescript Wizard:");
		setDescription("1) Dataitem of BLF Component and Output parameter\r\n2) UI Widget Helper class");
	}
	
	
	public boolean checkForm()
	{

		if(wsdlPathText.getText().trim().isEmpty() || elementCombo.getText().trim().isEmpty() || dataFieldsList.getItems().length==0
				|| fileNameText.getText().trim().isEmpty() || businessEntityCombo.getText().trim().isEmpty())
		{
			return false;			
		}
		return true;	
		
	}

	/**
	 * Create contents of the wizard.
	 * 
	 * @param parent
	 */
	public void createControl(Composite parent) {
		Composite container = new Composite(parent, SWT.NULL);

		setControl(container);

		Composite composite = new Composite(container, SWT.NONE);
		composite.setBounds(5, -2, 687, 356);

		Label lblWsdl = new Label(composite, SWT.NONE);
		lblWsdl.setText("WSDL Path:");
		lblWsdl.setAlignment(SWT.RIGHT);
		lblWsdl.setBounds(10, 45, 90, 15);

		elementCombo = new Combo(composite, SWT.NONE);

		elementCombo.setBounds(109, 296, 190, 23);

		Label lblElement = new Label(composite, SWT.NONE);
		lblElement.setText("Element:");
		lblElement.setAlignment(SWT.RIGHT);
		lblElement.setBounds(10, 299, 90, 15);

		Button button_1 = new Button(composite, SWT.NONE);
		button_1.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				elementCombo.removeAll();
				ArrayList<String> els = new ArrayList();
				try {
					els = new WSDLUtil().GetElementList(wsdlPathText.getText());
				} catch (Exception e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}
				for (String s : els) {
					elementCombo.add(s);
				}

			}
		});
		button_1.setText("Search");
		button_1.setBounds(625, 42, 52, 21);

		wsdlPathText = new Text(composite, SWT.BORDER);
		wsdlPathText.setBounds(109, 42, 513, 21);
		wsdlPathText.setText("");

		Label lblBusinessEntity = new Label(composite, SWT.NONE);
		lblBusinessEntity.setText("Business Entity:");
		lblBusinessEntity.setAlignment(SWT.RIGHT);
		lblBusinessEntity.setBounds(10, 13, 90, 15);

		IPreferenceStore store = new Activator().getPreferenceStore();
	    host = store.getString("QAD_HOSTNAME");
		port = store.getString("QAD_PORT");

	    businessEntityCombo = new Combo(composite, SWT.NONE);
		businessEntityCombo.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				String url = "";
				String comp = businessEntityCombo.getText();
				for (String s : components) {
					if (s.contains(":" + comp + ":"))
						url = s;

				}
				wsdlPathText.setText("http://" + host + ":" + port + url);
				
				elementCombo.removeAll();
				ArrayList<String> els = new ArrayList();
				try {
					els = new WSDLUtil().GetElementList(wsdlPathText.getText());
				} catch (Exception e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}
				for (String s : els) {
					elementCombo.add(s);
				}
			}
		});
		businessEntityCombo.setBounds(109, 10, 190, 23);

		Group grpOptions = new Group(composite, SWT.NONE);
		grpOptions.setText("Generate Options");
		grpOptions.setBounds(10, 77, 289, 96);

		chkInterfaceapi = new Button(grpOptions, SWT.RADIO);
		chkInterfaceapi.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
			}
		});
		chkInterfaceapi.setSelection(true);
		chkInterfaceapi.setBounds(10, 22, 93, 16);
		chkInterfaceapi.setText("Interface(API)");

		chkInterfaceinstancetable = new Button(grpOptions, SWT.RADIO);
		chkInterfaceinstancetable.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
			}
		});

		chkInterfaceinstancetable.setText("Interface(Entity)");
		chkInterfaceinstancetable.setBounds(159, 22, 105, 16);

		chkUIWidgetHelper = new Button(grpOptions, SWT.CHECK);
		chkUIWidgetHelper.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				txtAutofield.setEnabled(chkUIWidgetHelper.getSelection());
			}
		});
		chkUIWidgetHelper.setText("UI Widget Helper");
		chkUIWidgetHelper.setBounds(10, 49, 108, 16);
		
		Label lblFieldSuffix = new Label(grpOptions, SWT.NONE);
		lblFieldSuffix.setText("Suffix(Field Name):");
		lblFieldSuffix.setBounds(10, 71, 105, 15);
		
		txtAutofield = new Text(grpOptions, SWT.BORDER);
		txtAutofield.setEnabled(false);
		txtAutofield.setText("AutoField");
		txtAutofield.setBounds(116, 69, 154, 21);

		Label lblFileName = new Label(composite, SWT.NONE);
		lblFileName.setText("Folder Name:");
		lblFileName.setAlignment(SWT.RIGHT);
		lblFileName.setBounds(10, 332, 90, 15);

		fileNameText = new Text(composite, SWT.BORDER);
		fileNameText.setText("");
		fileNameText.setBounds(110, 329, 190, 21);
		
		Group grpFieldOptions = new Group(composite, SWT.NONE);
		grpFieldOptions.setText("Field Options");
		grpFieldOptions.setBounds(10, 186, 289, 96);
		
	    chkSkipRowID = new Button(grpFieldOptions, SWT.CHECK);
		chkSkipRowID.setText("Skip Row ID");
		chkSkipRowID.setBounds(10, 66, 134, 16);
		
	    chkSkipQAD = new Button(grpFieldOptions, SWT.CHECK);
		chkSkipQAD.setText("Skip QAD Fields");
		chkSkipQAD.setBounds(10, 44, 134, 16);
		
	    chkSkipCustom = new Button(grpFieldOptions, SWT.CHECK);
		chkSkipCustom.setText("Skip Custom Fields");
		chkSkipCustom.setBounds(10, 22, 134, 16);
		
		Group grpFieldPreview = new Group(composite, SWT.NONE);
		grpFieldPreview.setText("Fields Preview");
		grpFieldPreview.setBounds(347, 69, 280, 285);
		
	    dataFieldsList = new List(grpFieldPreview, SWT.BORDER | SWT.H_SCROLL | SWT.V_SCROLL);
		dataFieldsList.setBounds(7, 16, 266, 262);

		// http://vmzal03:16560/wsa/wsa1/wsdl?targetURI=urn:services-qad-com:finproto:IBJournal:2015-12-12
		components = HTMLReader.getComponentURL("http://" + host + ":" + port + "/wsa/wsa1/wsdl");
		for (String comp : components) {
			int k = comp.split(":").length;
			businessEntityCombo.add(comp.split(":")[k - 2]);
		}

		elementCombo.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				String url = "";
				String componentName = businessEntityCombo.getText();
				String folderName = "";
				if(componentName.startsWith("I"))
				{
					folderName = componentName.substring(1);
				}
				
				if(folderName.endsWith("s"))
				{
					folderName= folderName.substring(0,folderName.length()-1);					
				}
				fileNameText.setText(folderName);
				for (String s : components) {
					if (s.contains(":" + componentName + ":"))
						url = s;

				}

				ArrayList<String> fieldList  = new ArrayList<String>();
				dataFieldsList.removeAll();
				
				if (chkInterfaceapi.getSelection()) {
					fieldList = new WSDLUtil().GetFieldList("http://" + host + ":" + port + url, elementCombo.getText());
				}
				else
				{
					fieldList = new WSDLUtil().getFieldListForInstanceTable("http://" + host + ":" + port + url, elementCombo.getText());					
				}
				
				for (String s : fieldList) {
					
				    if (chkSkipCustom.getSelection() && s.trim().startsWith("Custom"))
                         continue;

                    if (chkSkipQAD.getSelection() && s.trim().startsWith("QAD"))
                         continue;

                    if (chkSkipRowID.getSelection() && s.trim().contains("_Rowid("))
                         continue;
					dataFieldsList.add(s);

				}

			}
		});

	}
}
