package com.qad.fin.plugin.ui;

import java.util.ArrayList;

import org.eclipse.jface.dialogs.MessageDialog;
import org.eclipse.jface.preference.IPreferenceStore;
import org.eclipse.jface.text.BadLocationException;
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

public class CodeGenWizard extends Wizard {

	private Boolean onlyOneContainer = false;
	private String theContainerNameInPage = "";
    
	public CodeGenWizard() {
		setWindowTitle("CodeGen(Java API Calling) Wizard");
	}

	@Override
	public void addPages() {
		CodeGenPage page = new CodeGenPage();
		this.addPage(page);

	}

	public String FormatMethodSig(String str) {
		String strParam = "";
		String[] params = str.split("\\,");
		int i = 0;

		for (String bb : params) {
			if (!bb.contains("Container")) {
				strParam = strParam + bb + ",";
			}

		}
		
		if(strParam.trim().length()>0)
		{
		   strParam = strParam.trim().substring(0, strParam.length() - 1);
		}
		return strParam;
	}

	public String FormatParameterString(String str) {
		String paramStr = "";
		String[] params = str.split("\\,");

		StringBuffer spaceStr = new StringBuffer();
		CodeGenPage page = ((CodeGenPage) this.getPage("wizardPage"));
		int sk = (29 + 2 * (page.getEntityName().length() + page.getAPIMethodName().length()
				+ page.getGenMethodName().length()));

		for (int j = 0; j < sk; j++) {
			spaceStr = spaceStr.append(" ");
			j++;
		}
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
		CodeGenPage page = ((CodeGenPage) this.getPage("wizardPage"));
		String[] paramList = page.getAPIInterface();
		String paramListString = "";
		for (int i = 0; i < paramList.length; i++) {
			paramListString = paramListString + paramList[i].toString();
		}
		int startP = 0;
		startP = paramListString.indexOf("(");
		int endP = 0;
		endP = paramListString.lastIndexOf(");");
		paramListString = paramListString.substring(startP + 1, endP).replace(",", ",\n");


		String[] codeResult = new String[lines.size()];
		int jj = 0;

		String annotationTemplate = "    @RequestParam(value = \"$ParamName$\", required = false) $ParamType$ $ParamName$";

		String annotationList = "";
		String outputParamList = "";

		for (int i = 1; i < paramList.length; i++) {
			String theParam = paramList[i].toString().trim();
			if (!theParam.trim().contains(";") && theParam.trim().split(" ")[1].startsWith("o")) {
				String newOutputParam = "    " + theParam.trim().substring(0, theParam.trim().length() - 2) + " = new "
						+ theParam.trim().split(" ")[0] + "();\n";
				outputParamList = outputParamList + newOutputParam;
			} else if (!theParam.trim().contains(";")) {
				String pn = theParam.trim().split(" ")[1];
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
		startP = 0;
		startP = paramListString.indexOf("(");
		endP = 0;
		endP = paramListString.lastIndexOf(");");
		paramListString = paramListString.substring(startP + 1, endP).replace(",", ",\n");

		jj = 0;
		for (String line : lines) {

			if (line.contains("$MethodName$")) {
				line = line.replace("$MethodName$", page.getAPIMethodName());
			}

			if (line.contains("$OutputHolderList$")) {
				line = line.replace("$OutputHolderList$", outputParamList);
			}

			if (line.contains("$AnnotationList$")) {
				line = line.replace("$AnnotationList$", annotationList);
			}

			if (line.contains("$Entity$")) {
				line = line.replace("$Entity$",
						page.getEntityName().substring(0, 1).toLowerCase() + page.getEntityName().substring(1));
			}

			if (line.contains("$ServiceClassName$")) {
				String[] cn = page.getServiceClassName().split("/");
				int i = cn.length;
				String className = cn[i - 1].replace(".class", "");
				line = line.replace("$ServiceClassName$", className);
			}

			if (line.contains("$ParamList$")) {
				line = line.replace("$ParamList$", FormatParameterString(paramListString.trim()).trim());
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
		System.out.print(doc.get());
		ISelection sel = editor.getSelectionProvider().getSelection();
		TextSelection textSel = (TextSelection) sel;
		CodeGenPage page = ((CodeGenPage) this.getPage("wizardPage"));
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

			if (editor.getTitle().contains("ServiceImpl")) {
				ret = this.GenerateServiceImpl();
				IPreferenceStore store = new Activator().getPreferenceStore();
				String oldValue = store.getString("QAD_ServiceImplHist");
			    store.setValue("QAD_ServiceImplHist",  oldValue + "," + editor.getTitle() + "." + page.getGenMethodName());
			}

			doc.replace(textSel.getOffset(), textSel.getLength(), ret);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return true;
	}

	public String getContainerDefinition(String[] interfaceParams) {
		CodeGenPage page = ((CodeGenPage) this.getPage("wizardPage"));
		String containerList = "        ";
		int cnt = 0;

		for (String s : interfaceParams) {
			if (s.contains("Container")) {
				String containerVarName = s.trim().split(" ")[1].replace(",", "");
				String containerType = s.trim().split(" ")[0].substring(0);
				theContainerNameInPage = containerVarName;
				containerList = containerList + containerType + " " + containerVarName + " = "
						+ page.getEntityName().substring(0, 1).toLowerCase() + page.getEntityName().substring(1)
						+ "Factory.create" + containerType.trim() + "();\n        ";
                 cnt ++;
			}
		}
		
		if(cnt == 1)
		{			
			this.onlyOneContainer = true;
		}
		return containerList;

	}

	private String GenerateServiceImpl() {
		IPreferenceStore store = new Activator().getPreferenceStore();
		String templateDir = store.getString("QAD_TEMPLATE_FOLDER");

		ArrayList<String> lines = FileUtil.readFileByLines(templateDir + "\\Template_ServiceImpl.tpl");
		CodeGenPage page = ((CodeGenPage) this.getPage("wizardPage"));
		String[] paramList = page.getAPIInterface();
		String paramListString = "";
		for (int i = 0; i < paramList.length; i++) {
			paramListString = paramListString + paramList[i].toString();
		}
		int startP = 0;
		startP = paramListString.indexOf("(");
		int endP = 0;
		endP = paramListString.lastIndexOf(");");
		paramListString = paramListString.substring(startP + 1, endP).replace(",", ",\n");


		String[] codeResult = new String[lines.size()];
		int jj = 0;
		for (String line : lines) {
			if (line.contains("$ReturnDataType$")) {
				if(page.getReturnDataType().trim().toLowerCase().equals("void") && !line.trim().startsWith("public"))
				    line = "";
				else
				    line = line.replace("$ReturnDataType$", page.getReturnDataType());
			}

			if (line.contains("$MethodName$")) {
				line = line.replace("$MethodName$", page.getGenMethodName());
			}

			if (line.contains("$ServiceMethodName$")) {
				line = line.replace("$ServiceMethodName$", page.getAPIMethodName());
			}

			if (line.contains("$Params$")) {
				line = line.replace("$Params$", FormatMethodSig(paramListString.trim()));
			}

			if (line.contains("$CallParams$")) {
				line = line.replace("$CallParams$", FormatParameterString(paramListString.trim()).trim());
			}

			if (line.contains("$ContainerDefinition$")) {
				String container = getContainerDefinition(page.getAPIInterface());
				if(container.trim().length() > 0)
				{
				    line = container;
				}
				else
				{
					line = "";
					
				}	
			}
			
			if(line.contains("$ReturnContainer$"))
			{
				if(this.onlyOneContainer && page.getReturnDataType().toLowerCase().contains("container"))
				{
					line = "    o" + page.getReturnDataType() + " = " + this.theContainerNameInPage + ";";
				}
				else
				{
					line = "";					
				}	
			}

			if (line.contains("$ReturnVariable$")) {
				if(page.getReturnDataType().trim().toLowerCase().equals("void"))
				{
					
					line = "";
					continue;
				}
				
				
				// Return variable creation
			    line = line.replace("$ReturnVariable$", "o" + page.getReturnDataType());


//				// Return variable init
//				if (page.getReturnDataType().toLowerCase().contains("container")) {
//					line = line.replace("$ReturnVariable$", "o" + page.getReturnDataType());
//				} else {
//					line = "//TODO \n" +  "o" + page.getReturnDataType() + " = yyynull;";
//				}
			}

			if (line.contains("$Entity$")) {
				line = line.replace("$Entity$", page.getEntityName());
			}

			if (line.contains("$Entity_Low$")) {
				line = line.replace("$Entity_Low$",
						page.getEntityName().substring(0, 1).toLowerCase() + page.getEntityName().substring(1));
			}
			
			if(line.contains("$ReturnStatement$") )
			{
				if(page.getReturnDataType().toLowerCase().equals("void"))
				{
					line = "";
				}
				else
				{
				    line = line.replace("$ReturnStatement$", "return " + "o" + page.getReturnDataType() + ";");
				}
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

}
