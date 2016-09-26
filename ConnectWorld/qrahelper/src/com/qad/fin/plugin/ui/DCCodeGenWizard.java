package com.qad.fin.plugin.ui;

import java.util.ArrayList;

import org.eclipse.jface.dialogs.MessageDialog;
import org.eclipse.jface.preference.IPreferenceStore;
import org.eclipse.jface.text.IDocument;
import org.eclipse.jface.text.TextSelection;
import org.eclipse.jface.viewers.ISelection;
import org.eclipse.jface.wizard.Wizard;
import org.eclipse.swt.widgets.Shell;
import org.eclipse.ui.IEditorPart;
import org.eclipse.ui.IWorkbenchPage;
import org.eclipse.ui.PlatformUI;
import org.eclipse.ui.texteditor.IDocumentProvider;
import org.eclipse.ui.texteditor.ITextEditor;

import com.qad.fin.plugin.activator.Activator;
import com.qad.fin.plugin.util.FileUtil;

public class DCCodeGenWizard extends Wizard {

	public DCCodeGenWizard() {
		setWindowTitle("Data Controller Wizard");
	}

	@Override
	public void addPages() {
		DCCodeGenPage page = new DCCodeGenPage();
		this.addPage(page);
	}


	public String FormatParameterString(String str) {
		String paramStr = "";
		String[] params = str.split("\\,");

		StringBuffer spaceStr = new StringBuffer();
		DCCodeGenPage page = ((DCCodeGenPage) this.getPage("wizardPage"));


		spaceStr = spaceStr.append("          ");

		int k = 0;
		for (String bb : params) {

			if (k > 1) {
				paramStr = paramStr;
			}
			if (k != params.length - 1) {
				paramStr = paramStr + spaceStr + bb.trim().split(" ")[1] + ",\n";
			} else if (k == 0) {
				paramStr = paramStr + bb.trim().split(" ")[1];
			} else {
				paramStr = paramStr + spaceStr + bb.trim().split(" ")[1];
			}

			k++;
		}

		return paramStr;
	}

	private String GenerateDataController() {
		// DataController Generate
		IPreferenceStore store = new Activator().getPreferenceStore();
		String templateDir = store.getString("QAD_TEMPLATE_FOLDER");

		ArrayList<String> lines = FileUtil.readFileByLines(templateDir + "\\Template_DataController.tpl");
		DCCodeGenPage page = ((DCCodeGenPage) this.getPage("wizardPage"));
		String[] paramList = page.parameterList.getItems();
		String paramListString = "";
		for (int i = 0; i < paramList.length; i++) {
			paramListString = paramListString + paramList[i].toString();
		}

		

		System.out.println(paramListString);
		String[] codeResult = new String[lines.size()];
		int jj = 0;

		String annotationTemplate = "    @RequestParam(value = \"$ParamName$\", required = false) $ParamType$ $ParamName$";

		String annotationList = "";
		String outputParamList = "";

		for (int i = 0; i < paramList.length; i++) {
			String theParam = paramList[i].toString().trim();
			if (!theParam.trim().contains(";") && theParam.trim().split(" ")[1].startsWith("o")) {
				String newOutputParam = "    " + theParam.trim().substring(0, theParam.trim().length() - 1) + " = new "
						+ theParam.trim().split(" ")[0] + "();\n";
				outputParamList = outputParamList + newOutputParam;
			} else if (!theParam.trim().contains(";")) {
				String pn = theParam.trim().split(" ")[1];
				if(pn.endsWith(","))
				   pn=pn.replace(",", "");
				String pt = theParam.trim().split(" ")[0];
				if (annotationList.trim().length() == 0) {
					String newAnnotationParam = annotationTemplate.trim().replace("$ParamName$", pn)
							.replace("$ParamType$", pt) + "\n";
					annotationList = annotationList + newAnnotationParam;
				} else {
					String newAnnotationParam = annotationTemplate.replace("$ParamName$", pn).replace("$ParamType$", pt)
							+ "\n";
					annotationList = annotationList + newAnnotationParam;
				}
			}
		}
		paramListString = "";
		for (int i = 0; i < paramList.length; i++) {
			paramListString = paramListString + paramList[i].toString();
		}

		jj = 0;
		for (String line : lines) {

			if (line.contains("$MethodName$")) {
				line = line.replace("$MethodName$", page.dcMethodNameText.getText().trim());
			}

			if (line.contains("$OutputHolderList$")) {
				line = line.replace("$OutputHolderList$", outputParamList);
			}
			
			if (line.contains("$AnnotationList$")) {
				if(annotationList.trim().endsWith(","))
				{
					annotationList= annotationList.substring(0,annotationList.length()-2);
				}
				line = line.replace("$AnnotationList$", annotationList);
			}

			if (line.contains("$Entity$")) {
				line = line.replace("$Entity$",
						page.entityNameText.getText().trim().substring(0, 1).toLowerCase() + page.entityNameText.getText().trim().substring(1));
			}

			if (line.contains("$ServiceClassName$")) {

				line = line.replace("$ServiceClassName$", page.serviceImplClassCombo.getText());
			}

			if (line.contains("$ParamList$")) {
				line = line.replace("$ParamList$", FormatParameterString(paramListString.trim()).trim());
			}
			
			if (line.contains("")) {
				line = line.replace("$ServiceMethodName$",page.methodCombo.getText().trim());
			}


			codeResult[jj] = line;
			jj++;
		}

		String ret = "";
		for (int i = 0; i < codeResult.length; i++) {
			ret = ret + codeResult[i] + "\n";

		}

		return ret;

	}

	@Override
	public boolean performFinish() {		
		
		
		IWorkbenchPage wbpage = PlatformUI.getWorkbench().getActiveWorkbenchWindow().getActivePage();
		IEditorPart part = wbpage.getActiveEditor();
		ITextEditor editor = (ITextEditor) part;
		IDocumentProvider dp = editor.getDocumentProvider();
		
		IDocument doc = dp.getDocument(editor.getEditorInput());
		ISelection sel = editor.getSelectionProvider().getSelection();
		TextSelection textSel = (TextSelection) sel;
		DCCodeGenPage page = ((DCCodeGenPage) this.getPage("wizardPage"));
		
		if(!page.checkForm())
		{
			MessageDialog.openError(new Shell(), "Error",
					"Please check the data!");	
			return false;
		}
		
		try {
			String ret = "";
			if (editor.getTitle().contains("DataControl")) {
				ret = this.GenerateDataController();
				
			}

		
			doc.replace(textSel.getOffset(), textSel.getLength(), ret);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return true;
	}
}
