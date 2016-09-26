package com.qad.fin.plugin.ui;

import java.lang.reflect.Method;
import java.util.*;

import org.eclipse.core.resources.IProject;
import org.eclipse.core.resources.IWorkspaceRoot;
import org.eclipse.core.resources.ResourcesPlugin;
import org.eclipse.jdt.core.ICompilationUnit;
import org.eclipse.jdt.core.IJavaProject;
import org.eclipse.jdt.core.IMethod;
import org.eclipse.jdt.core.IPackageFragment;
import org.eclipse.jdt.core.IPackageFragmentRoot;
import org.eclipse.jdt.core.IType;
import org.eclipse.jdt.core.JavaCore;
import org.eclipse.jface.preference.IPreferenceStore;
import org.eclipse.jface.wizard.IWizard;
import org.eclipse.jface.wizard.WizardPage;
import org.eclipse.swt.SWT;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.widgets.Label;
import org.eclipse.swt.widgets.Text;

import com.qad.fin.plugin.activator.Activator;
import com.qad.fin.plugin.util.FileUtil;
import com.qad.fin.plugin.util.JarUtil;

import org.eclipse.swt.widgets.Button;
import org.eclipse.swt.widgets.Combo;
import org.eclipse.swt.widgets.List;
import org.eclipse.swt.events.SelectionAdapter;
import org.eclipse.swt.events.SelectionEvent;

public class CodeGenPage extends WizardPage {
	private Text jarFilePathText;
    ArrayList<String[]> methodsWithClassList;
    private Text returnTypeText;
    private Text entityNameText;
    private Text genMethodNameText;
	Combo apiMethodCombo ;
	List apiInterfacePreviewList;
    Combo serviceClassCombo;
	/**
	 * Create the wizard.
	 */
	public CodeGenPage() {
		super("wizardPage");
		setTitle("ServiceImpl Wizard");
		setDescription("Create API Calling Code for BLF API methods");
	}


	public boolean checkForm()
	{

		if(jarFilePathText.getText().trim().isEmpty() || returnTypeText.getText().trim().isEmpty() || entityNameText.getText().trim().isEmpty()
				|| apiMethodCombo.getText().trim().isEmpty() || entityNameText.getText().trim().isEmpty() || apiInterfacePreviewList.getItems().length==0)
		{
			return false;			
		}
		return true;	
		
	}
	
	public String getEntityName()
	{
		
		return entityNameText.getText();
	}
	
	public String getGenMethodName()
	{
		
		return genMethodNameText.getText();
	}
	
	public String getReturnDataType()
	{
		
		return returnTypeText.getText();
	}
	
	public String getAPIMethodName()
	{
		
		return apiMethodCombo.getText();
	}
	
	
	public String[] getAPIInterface()
	{
		
		return apiInterfacePreviewList.getItems();
	}
	
	public String getServiceClassName()
	{
		return serviceClassCombo.getText();
		
		
	}
	
	
	/**
	 * Create contents of the wizard.
	 * 
	 * @param parent
	 */
	public void createControl(Composite parent) {

		
		
		
		Composite container = new Composite(parent, SWT.NULL);

		setControl(container);

		Label lblNewLabel = new Label(container, SWT.NONE);
		lblNewLabel.setAlignment(SWT.RIGHT);
		lblNewLabel.setBounds(10, 7, 90, 15);
		lblNewLabel.setText("Jar File:");

		apiMethodCombo = new Combo(container, SWT.NONE);
	    serviceClassCombo = new Combo(container, SWT.NONE);
		
		serviceClassCombo.setBounds(109, 40, 343, 23);

		Label lblNewLabel_1 = new Label(container, SWT.NONE);
		lblNewLabel_1.setAlignment(SWT.RIGHT);
		lblNewLabel_1.setBounds(10, 43, 90, 15);
		lblNewLabel_1.setText("Service Class:");

		Label lblApiMethod = new Label(container, SWT.NONE);
		lblApiMethod.setAlignment(SWT.RIGHT);
		lblApiMethod.setText("API Method:");
		lblApiMethod.setBounds(10, 80, 90, 15);


		
		apiMethodCombo.setBounds(109, 77, 166, 23);

	    apiInterfacePreviewList = new List(container, SWT.BORDER | SWT.H_SCROLL | SWT.V_SCROLL);
		apiInterfacePreviewList.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				
				 if (apiInterfacePreviewList.getSelection()[0].contains("Container")) {
			            returnTypeText.setText(apiInterfacePreviewList.getSelection()[0].trim().split(" ")[0]);
			}
			}
		});
		apiInterfacePreviewList.setBounds(109, 154, 343, 141);

		Label lblInterfacePreview = new Label(container, SWT.NONE);
		lblInterfacePreview.setAlignment(SWT.RIGHT);
		lblInterfacePreview.setText("Interface Preview:");
		lblInterfacePreview.setBounds(10, 158, 93, 15);
		
		
		jarFilePathText = new Text(container, SWT.BORDER);
		jarFilePathText.setBounds(109, 4, 443, 21);
		IPreferenceStore store = new Activator().getPreferenceStore();
		String jarFile = store.getString("QAD_JAR");
		this.jarFilePathText.setText(jarFile);
		serviceClassCombo.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
                apiMethodCombo.removeAll();
		        for (String[] methodWithClass : methodsWithClassList) {
		            for (String theMethodClass : methodWithClass) {
		                if (theMethodClass.contains("$") && theMethodClass.contains("Service.class")
		                        && theMethodClass.startsWith(serviceClassCombo.getText())) {

		                    apiMethodCombo.add(theMethodClass.split("\\$")[1]);
		                   
		                    String[] bb = serviceClassCombo.getText().split("/");
		                    entityNameText.setText(bb[bb.length - 1].replace("Service.class", ""));
		                }
		            }
		        }

		
		      
			}
		});
		
		Button btnSearch = new Button(container, SWT.NONE);
		btnSearch.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				
				//Get Workspace
				IPreferenceStore store = new Activator().getPreferenceStore();
				String workDir = store.getString("QAD_WORK_DIR");
				FileUtil.decompress(jarFilePathText.getText().replace(".jar", "-src.jar") ,workDir + "\\src\\");
			
				
				serviceClassCombo.removeAll();
				String packageName = jarFilePathText.getText();
			
				ArrayList<String> className = new ArrayList<>();
				try {
					methodsWithClassList = new JarUtil().getJarMethod(packageName);
					for (String[] methodWithClass : methodsWithClassList) {
						for (String theMethodClass : methodWithClass) {
							if (theMethodClass.contains("$") & theMethodClass.contains("Service.class")) {
								if (!className.contains(theMethodClass.split("\\$")[0])) {
									className.add(theMethodClass.split("\\$")[0]);
								
									serviceClassCombo.add(theMethodClass.split("\\$")[0]);
								}
							}
						}
					}
				} catch (Exception ex) {
					ex.printStackTrace();
				}

			
			}
		});
		
		
		
		apiMethodCombo.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
			
				apiInterfacePreviewList.removeAll();
		        String className = serviceClassCombo.getText();
		        String methodName = apiMethodCombo.getText();
		        
		        IPreferenceStore store = new Activator().getPreferenceStore();
		        String workDir = store.getString("QAD_WORK_DIR");
		        String filePath =workDir + "\\src\\" + className.replace("/", "\\").replace(".class", ".java");
		        
		        ArrayList<String> lines = FileUtil.readFileByLines(filePath);
		        int startP = 0;
		        boolean inMethod = false;
		        
		        for (String line : lines) {
		            if (line.contains("void " + methodName + "(")) {
		                apiInterfacePreviewList.add(line);
		                inMethod = true;
		                if (line.endsWith(");")) {
		                    break;
		                } else {
		                    continue;
		                }
		            }
		            if (inMethod) {
		                apiInterfacePreviewList.add(line);
		                if (line.endsWith(");")) {
		                    break;
		                } else {
		                    continue;
		                }
		            }
		            if (inMethod && line.contains(");")) {
		                apiInterfacePreviewList.add(line);
		                inMethod = false;
		                break;

		            }

		        }
		       
		        apiInterfacePreviewList.setItem(0, apiInterfacePreviewList.getItem(0).trim());
		        apiInterfacePreviewList.setItem(apiInterfacePreviewList.getItemCount()-1, apiInterfacePreviewList.getItem(apiInterfacePreviewList.getItemCount()-1).trim());
			
			}
			
		});
		btnSearch.setBounds(558, 4, 60, 21);
		btnSearch.setText("Search");
		
		Label lblReturnType = new Label(container, SWT.NONE);
		lblReturnType.setText("Return Type:");
		lblReturnType.setAlignment(SWT.RIGHT);
		lblReturnType.setBounds(10, 318, 90, 15);
		
		returnTypeText = new Text(container, SWT.BORDER);
		returnTypeText.setBounds(109, 315, 166, 21);
		
		Label lblEntityName = new Label(container, SWT.NONE);
		lblEntityName.setText("Entity Name:");
		lblEntityName.setAlignment(SWT.RIGHT);
		lblEntityName.setBounds(10, 352, 90, 15);
		
		entityNameText = new Text(container, SWT.BORDER);
		entityNameText.setBounds(109, 349, 166, 21);
		
		Label lblMethodName = new Label(container, SWT.NONE);
		lblMethodName.setText("Method Name:");
		lblMethodName.setAlignment(SWT.RIGHT);
		lblMethodName.setBounds(10, 120, 93, 15);
		
		genMethodNameText = new Text(container, SWT.BORDER);
		genMethodNameText.setBounds(109, 117, 166, 21);
		

	    String serviceImplList = store.getString("QAD_ServiceImplHist");
	}
}
