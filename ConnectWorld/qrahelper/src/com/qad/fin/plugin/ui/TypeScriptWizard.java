package com.qad.fin.plugin.ui;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Calendar;

import org.eclipse.core.resources.IFile;
import org.eclipse.core.resources.ResourcesPlugin;
import org.eclipse.core.runtime.IPath;
import org.eclipse.core.runtime.Path;
import org.eclipse.jface.dialogs.MessageDialog;
import org.eclipse.jface.preference.IPreferenceStore;
import org.eclipse.jface.wizard.Wizard;
import org.eclipse.swt.widgets.Shell;
import org.eclipse.ui.IWorkbenchPage;
import org.eclipse.ui.IWorkbenchWindow;
import org.eclipse.ui.PartInitException;
import org.eclipse.ui.PlatformUI;
import org.eclipse.ui.ide.IDE;

import com.qad.fin.plugin.activator.Activator;
import com.qad.fin.plugin.util.CodeUtil;
import com.qad.fin.plugin.util.FileUtil;

public class TypeScriptWizard extends Wizard {
	TypeScriptPage page;

	public TypeScriptWizard() {
		setWindowTitle("Typescript Wizard");
	}

	@Override
	public void addPages() {
		this.addPage(new TypeScriptPage());
	}

	@Override
	public boolean performFinish() {
		
		
		page = ((TypeScriptPage) this.getPage("wizardPage"));
		
		if(!page.checkForm())
		{
			MessageDialog.openError(new Shell(), "Error",
					"Please check the data!");	
			return false;
		}
		
		String pathName = "";
		ArrayList<String> lines;
		CodeUtil codeUtil = new CodeUtil();

		IPreferenceStore store = new Activator().getPreferenceStore();
		String templateDir = store.getString("QAD_TEMPLATE_FOLDER");
		if (page.chkInterfaceapi.getSelection()) {

			String infTemplateFileName = templateDir + "\\I_Template.tpl";
			lines = FileUtil.readFileByLines(infTemplateFileName);
			lines = codeUtil.FillInDataItemName(lines,
					page.elementCombo.getText());
			lines = codeUtil.FillInProperties(lines,
					page.dataFieldsList.getItems());
            lines = codeUtil.FillInElementsForComments(lines, "$BusinessEntity$", page.elementCombo.getText().substring(1));
            lines = codeUtil.FillInElementsForComments(lines, "$Year$", String.valueOf(Calendar.getInstance().get(Calendar.YEAR)));
            
			pathName = GenerateInterface(lines,page.elementCombo.getText());
			OpenTSFile(pathName);
		}

		if (page.chkInterfaceinstancetable.getSelection()) {
			String infTemplateFileName = templateDir
					+ "\\I_Template_Entity.tpl";
			lines = FileUtil.readFileByLines(infTemplateFileName);
			lines = codeUtil.FillInInterfaceName(lines,
					page.fileNameText.getText());
			lines = codeUtil.FillInDataItemVarName(lines,
					page.elementCombo.getText());
			lines = codeUtil.FillInPropertiesForDataSet(lines,
					page.dataFieldsList.getItems());
			lines = codeUtil
					.FillInModelName(lines, page.fileNameText.getText());
			lines = codeUtil.FillInElementsForComments(lines, "$BusinessEntity$", page.businessEntityCombo.getText().substring(1));
            lines = codeUtil.FillInElementsForComments(lines, "$Year$", String.valueOf(Calendar.getInstance().get(Calendar.YEAR)));
            
			pathName = GenerateInterface(lines,page.businessEntityCombo.getText());
			OpenTSFile(pathName);
		}

		if (page.chkUIWidgetHelper.getSelection()) {
			String infTemplateFileName = templateDir + "\\Helper_Template.tpl";
			lines = FileUtil.readFileByLines(infTemplateFileName);
			lines = codeUtil
					.FillInEntityName(lines, page.businessEntityCombo.getText());
			lines = codeUtil.FillInPropertiesForWidgetHelper(lines,
					page.dataFieldsList.getItems());
			lines = codeUtil.FillInElementsForComments(lines, "$BusinessEntity$", page.businessEntityCombo.getText().substring(1));
            lines = codeUtil.FillInElementsForComments(lines, "$Year$", String.valueOf(Calendar.getInstance().get(Calendar.YEAR)));
            //substring(1) means remove "I" from ICostCenter
			pathName = GenerateWidgetHelper(lines, page.businessEntityCombo.getText().substring(1));
			OpenTSFile(pathName);
		}

		return true;
	}

	private void OpenTSFile(String pathName) {
		if (pathName.trim().length() > 1) {
			MessageDialog.openInformation(new Shell(), "Warning",
					"TS File is created in " + pathName);
		}
		
		IPreferenceStore store = new Activator().getPreferenceStore();
		Boolean openFile = store.getBoolean("QAD_OPEN_FILE");
		if(!openFile)
			return;
		
		IPath path = new Path(pathName);
		IPath workspacePath = ResourcesPlugin.getWorkspace().getRoot().getLocation();
		path = path.makeRelativeTo(workspacePath);
		IFile sampleFile = ResourcesPlugin.getWorkspace().getRoot().getFile(path);


		IWorkbenchWindow window = PlatformUI.getWorkbench().getActiveWorkbenchWindow();
		IWorkbenchPage wpage = window.getActivePage();
		

		try {
			IDE.openEditor(wpage, sampleFile);
		} catch (Exception e) {
			MessageDialog.openInformation(new Shell(), "Warning",
					"File open failed, please check file in IDE.");
		}
	}

	private String GenerateWidgetHelper(ArrayList<String> result,
			String hellperTSFileName) {

		String folderName = page.fileNameText.getText();
		String LINE_SEPARATOR = System.getProperty("line.separator");
		FileWriter file;
		try {
			IPreferenceStore store = new Activator().getPreferenceStore();
			String tsHelperDir = store.getString("QAD_TS_HELPER");

			File outputFolder = new File(tsHelperDir + "\\" + folderName
					+ "\\");
			if (!outputFolder.exists()) {
				outputFolder.mkdir();
			}

			file = new FileWriter(tsHelperDir + "\\" + folderName + "\\"
					+ hellperTSFileName + "WidgetHelper" + ".ts", false);
			for (String line : result) {
				file.write(line + LINE_SEPARATOR);
			}
			file.close();
			return tsHelperDir + "\\" + folderName + "\\" + hellperTSFileName
					+ "WidgetHelper" + ".ts";
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return "";
	}

	private String GenerateInterface(ArrayList<String> result, String tsFileName) {
		
		String folderAndFileName = page.fileNameText.getText();
		String LINE_SEPARATOR = System.getProperty("line.separator");
		FileWriter tsFileWriter;
		try {
			IPreferenceStore store = new Activator().getPreferenceStore();
			String tsInterfaceDir = store.getString("QAD_TS_ENTITY");
			File outputFolder = new File(tsInterfaceDir + "\\"
					+ folderAndFileName + "\\");
			if (!outputFolder.exists()) {
				outputFolder.mkdir();
			}
			tsFileWriter = new FileWriter(tsInterfaceDir + "\\"
					+ folderAndFileName + "\\" + tsFileName + ".ts", false);

			for (String line : result) {
				tsFileWriter.write(line + LINE_SEPARATOR);
			}
			tsFileWriter.close();
			return tsInterfaceDir + "\\" + folderAndFileName + "\\"
					+ tsFileName + ".ts";
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return "";
	}

}
