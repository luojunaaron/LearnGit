package com.qad.fin.plugin.ui;

import java.util.ArrayList;

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
import org.eclipse.jface.dialogs.MessageDialog;
import org.eclipse.jface.preference.IPreferenceStore;
import org.eclipse.jface.wizard.WizardPage;
import org.eclipse.swt.SWT;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.widgets.Combo;
import org.eclipse.swt.widgets.List;
import org.eclipse.swt.widgets.Shell;
import org.eclipse.swt.events.SelectionAdapter;
import org.eclipse.swt.events.SelectionEvent;
import org.eclipse.swt.widgets.Text;
import org.eclipse.swt.widgets.Label;

import com.qad.fin.plugin.activator.Activator;

public class DCCodeGenPage extends WizardPage {
	List parameterList;

	Combo serviceImplClassCombo;
	Combo methodCombo;
    Text entityNameText;
    Label label_1;
    Text dcMethodNameText;
    String packageStr = "com.qad.erp.financials.service.impl";

	/**
	 * Create the wizard.
	 */
	public DCCodeGenPage() {
		super("wizardPage");
		setTitle("DataController Wizard");
		setDescription("Genreate ServiceImpl wrapper in DataController Layer");
		IPreferenceStore store = new Activator().getPreferenceStore();
		String envType = store.getString("QAD_PROTO_TRUNK");
		if(envType!=null &&  envType.equals("Prototype"))
		{
			packageStr = "com.qad.finproto.service.impl";
		}

		
	}

	public boolean checkForm()
	{

		if(serviceImplClassCombo.getText().trim().isEmpty() || methodCombo.getText().trim().isEmpty() || entityNameText.getText().trim().isEmpty()
				|| entityNameText.getText().trim().isEmpty() || dcMethodNameText.getText().trim().isEmpty() || parameterList.getItems().length==0)
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

		serviceImplClassCombo = new Combo(container, SWT.NONE);
		serviceImplClassCombo.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {

				ArrayList<String> methodList = new ArrayList<String>();
				IJavaProject targetProject = null;
				IWorkspaceRoot root = ResourcesPlugin.getWorkspace().getRoot();
				for (IProject project : root.getProjects()) {
					try {

						if (project.hasNature(JavaCore.NATURE_ID) ) {
							targetProject = JavaCore.create(project);
						}

						IPackageFragment[] packages = targetProject.getPackageFragments();
						// parse(JavaCore.create(project));
						for (IPackageFragment mypackage : packages) {
							if (mypackage.getKind() == IPackageFragmentRoot.K_SOURCE
									&& mypackage.getElementName().startsWith(packageStr)) {
								for (ICompilationUnit unit : mypackage.getCompilationUnits()) {
									IType[] types = unit.getTypes();
									for (int i = 0; i < types.length; i++) {
										IType type = types[i];
										if (type.getFullyQualifiedName().equals(serviceImplClassCombo.getText())) {
											entityNameText.setText(type.getElementName().replace("ServiceImpl", ""));
											IMethod[] methods = type.getMethods();
											for (int ii = 0; ii < methods.length; ii++) {
												if(!methodList.contains(methods[ii].getElementName()))
												{
												    methodList.add(methods[ii].getElementName());
												}
											}
										}
									}
								}
							}
						}
						methodCombo.setItems(methodList.toArray(new String[methodList.size()]));
						
					}

					catch (Exception ex) {
						ex.printStackTrace();
					}
				}

			}
		});
		serviceImplClassCombo.setBounds(125, 13, 293, 23);

		parameterList = new List(container, SWT.BORDER | SWT.V_SCROLL);
		parameterList.setBounds(125, 89, 293, 201);

		methodCombo = new Combo(container, SWT.NONE);
		methodCombo.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {

				ArrayList<String> paraList = new ArrayList<String>();
				IJavaProject targetProject = null;
				IWorkspaceRoot root = ResourcesPlugin.getWorkspace().getRoot();
				
				for (IProject project : root.getProjects()) {
					try {

						if (project.hasNature(JavaCore.NATURE_ID)) {
							targetProject = JavaCore.create(project);
						}

						IPackageFragment[] packages = targetProject.getPackageFragments();
						// parse(JavaCore.create(project));
						for (IPackageFragment mypackage : packages) {
							if (mypackage.getKind() == IPackageFragmentRoot.K_SOURCE
									&& mypackage.getElementName().startsWith(packageStr)) {
								for (ICompilationUnit unit : mypackage.getCompilationUnits()) {
									IType[] types = unit.getTypes();
									for (int i = 0; i < types.length; i++) {
										IType type = types[i];
										if (type.getFullyQualifiedName().equals(serviceImplClassCombo.getText())) {
											IMethod[] methods = type.getMethods();
											for (int ii = 0; ii < methods.length; ii++) {
												if (methods[ii].getElementName().equals(methodCombo.getText())) {

													for (int k = 0; k < methods[ii].getParameters().length; k++) {
														String paramType ="("
																+ ConvertType(methods[ii].getParameters()[k].getTypeSignature()	)														
																+ ")";
													
														String paramStr = "";
														if(methods[ii].getParameters()[k].getTypeSignature().length()==1)
														{
														    paramStr = paramType + " "
														              + methods[ii].getParameters()[k].getElementName() + ",";
														}
														else
														{
														    paramStr = paramType.replace("(Q", "").replace("<Q", "<").replace(";", "").replace(")", "") + " "
														              + methods[ii].getParameters()[k].getElementName() + ",";
														}
														if(!paraList.contains(paramStr))
														{
														    paraList.add(paramStr);
													}}
													

												}
											}
										}
									}
								}

							}
						}
						parameterList.setItems(paraList.toArray(new String[paraList.size()]));
					}

					catch (Exception ex) {
						ex.printStackTrace();
					}
				}

			}
		});
		methodCombo.setBounds(125, 48, 293, 23);
		
		entityNameText = new Text(container, SWT.BORDER);
		entityNameText.setBounds(123, 312, 166, 21);
		
		Label label = new Label(container, SWT.NONE);
		label.setText("Entity Name:");
		label.setAlignment(SWT.RIGHT);
		label.setBounds(48, 312, 69, 15);
		
		label_1 = new Label(container, SWT.NONE);
		label_1.setText("Method Name:");
		label_1.setAlignment(SWT.RIGHT);
		label_1.setBounds(10, 348, 107, 15);
		
		dcMethodNameText = new Text(container, SWT.BORDER);
		dcMethodNameText.setBounds(123, 348, 166, 21);
		
		Label lblServiceimplClass = new Label(container, SWT.NONE);
		lblServiceimplClass.setText("ServiceImpl Class:");
		lblServiceimplClass.setAlignment(SWT.RIGHT);
		lblServiceimplClass.setBounds(10, 13, 107, 15);
		
		Label lblMethodsInServiceimpl = new Label(container, SWT.NONE);
		lblMethodsInServiceimpl.setText("Method");
		lblMethodsInServiceimpl.setAlignment(SWT.RIGHT);
		lblMethodsInServiceimpl.setBounds(12, 51, 107, 15);
		
		Label lblParameters = new Label(container, SWT.NONE);
		lblParameters.setText("Parameters");
		lblParameters.setAlignment(SWT.RIGHT);
		lblParameters.setBounds(12, 89, 107, 15);
		
		Label lblNewLabel = new Label(container, SWT.NONE);
		lblNewLabel.setBounds(22, 68, 484, 15);
		this.initControlData();

	}

	
	
	private String ConvertType(String sigType)
	{
		if(sigType.equals("I"))
			return "int";
		
		if(sigType.equals("C"))
			return "char";
		
		if(sigType.equals("F"))
			return "float";
		
		if(sigType.equals("J"))
			return "long";
		
		if(sigType.equals("Z"))
			return "boolean";
		
		if(sigType.equals("D"))
			return "double";
		
		if(sigType.equals("S"))
			return "short";
		
		if(sigType.trim().length()==1)
		{
		    return "unknow";
		}
		else
			return sigType;
		/*
		 "B"  // byte
		   | "C"  // char
		   | "D"  // double
		   | "F"  // float
		   | "I"  // int
		   | "J"  // long
		   | "S"  // short
		   | "V"  // void
		   | "Z"  // boolean
		*/
	}
	
	private void initControlData() {
		ArrayList<String> classList = new ArrayList<String>();
		IJavaProject targetProject = null;
		IWorkspaceRoot root = ResourcesPlugin.getWorkspace().getRoot();
		for (IProject project : root.getProjects()) {
			try {
				

				if (project.hasNature(JavaCore.NATURE_ID)) {
					targetProject = JavaCore.create(project);
					//MessageDialog.openInformation(new Shell(), "project name", targetProject.getElementName()); 
			
					IPackageFragment[] packages = targetProject.getPackageFragments();
					// parse(JavaCore.create(project));
					for (IPackageFragment mypackage : packages) {
						//if(mypackage.getElementName().startsWith("com.qad.finproto.service.impl"))
						//MessageDialog.openInformation(new Shell(), "package name", mypackage.getElementName()); 
						if (mypackage.getKind() == IPackageFragmentRoot.K_SOURCE
								&& mypackage.getElementName().startsWith(packageStr)) {
							for (ICompilationUnit unit : mypackage.getCompilationUnits()) {
								IType[] types = unit.getTypes();
								for (int i = 0; i < types.length; i++) {
									IType type = types[i];
									if(!classList.contains(type.getFullyQualifiedName()))
									{
									    classList.add(type.getFullyQualifiedName());
									}
								}
							}
						}
					}
					this.serviceImplClassCombo.setItems(classList.toArray(new String[classList.size()]));
				}
				
				
			}

			catch (Exception ex) {
				ex.printStackTrace();
			}
		}

	}
}
