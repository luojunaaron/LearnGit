package com.qad.fin.plugin.preference;

import org.eclipse.jface.preference.*;
import org.eclipse.ui.IWorkbenchPreferencePage;

import com.qad.fin.plugin.activator.Activator;

import org.eclipse.ui.IWorkbench;


/**
 * This class represents a preference page that
 * is contributed to the Preferences dialog. By 
 * subclassing <samp>FieldEditorPreferencePage</samp>, we
 * can use the field support built into JFace that allows
 * us to create a page that is small and knows how to 
 * save, restore and apply itself.
 * <p>
 * This page is used to modify preferences only. They
 * are stored in the preference store that belongs to
 * the main plug-in class. That way, preferences can
 * be accessed directly via the preference store.
 */

public class QRAHelperPreferencePage
	extends FieldEditorPreferencePage
	implements IWorkbenchPreferencePage {

	public QRAHelperPreferencePage() {
		super(GRID);
		
		setPreferenceStore(new Activator().getDefault().getPreferenceStore());
	}
	
	/**
	 * Creates the field editors. Field editors are abstractions of
	 * the common GUI blocks needed to manipulate various types
	 * of preferences. Each field editor knows how to save and
	 * restore itself.
	 */
	public void createFieldEditors() {
		final String P_BOOLEAN = "booleanPreference";
		addField(
				new StringFieldEditor("QAD_HOSTNAME", "&Host Name:", getFieldEditorParent()));
		
		addField(
				new StringFieldEditor("QAD_PORT", "&Port:", getFieldEditorParent()));
		

		
		addField(new RadioGroupFieldEditor("QAD_PROTO_TRUNK",
		        "FIN Prototype/Trunk", 1,
		        new String[][] { { "&PROTO", "Prototype" },
		            { "&TRUNK", "Trunk" } }, getFieldEditorParent()));
		
		addField(new DirectoryFieldEditor("QAD_WORK_DIR", 
				"&Work Directory:", getFieldEditorParent()));
		
		addField(new DirectoryFieldEditor("QAD_TEMPLATE_FOLDER", 
				"&Template Folder:", getFieldEditorParent()));
		
		addField(new FileFieldEditor("QAD_JAR", 
				"&Default API JAR:", getFieldEditorParent()));
		
		addField(new DirectoryFieldEditor("QAD_TS_ENTITY", 
				"&TS(Model) Path:", getFieldEditorParent()));
		
		addField(new DirectoryFieldEditor("QAD_TS_HELPER", 
				"&TS(Widget Helper) Path:", getFieldEditorParent()));
		
		addField(new DirectoryFieldEditor("QAD_TS_OUTPUT_PARAMETER", 
				"&TS(Output Parameter) Path:", getFieldEditorParent()));
		
		addField(
			new BooleanFieldEditor(
				P_BOOLEAN,
				"&Auto Detect ServiceImpl/DataController",
				getFieldEditorParent()));

		addField(
				new BooleanFieldEditor(
					"QAD_OPEN_FILE",
					"&Open new generated TS file",
					getFieldEditorParent()));


	}

	/* (non-Javadoc)
	 * @see org.eclipse.ui.IWorkbenchPreferencePage#init(org.eclipse.ui.IWorkbench)
	 */
	public void init(IWorkbench workbench) {
	}
	
}