package com.qad.fin.plugin.handler;

import org.eclipse.core.commands.AbstractHandler;
import org.eclipse.core.commands.ExecutionEvent;
import org.eclipse.core.commands.ExecutionException;
import org.eclipse.ui.IEditorPart;
import org.eclipse.ui.IWorkbenchPage;
import org.eclipse.ui.IWorkbenchWindow;
import org.eclipse.ui.PlatformUI;
import org.eclipse.ui.handlers.HandlerUtil;
import org.eclipse.ui.texteditor.ITextEditor;

import com.qad.fin.plugin.ui.CodeGenDialog;
import com.qad.fin.plugin.ui.CodeGenWizard;
import com.qad.fin.plugin.ui.DCCodeGenWizard;
import com.qad.fin.plugin.ui.TypeScriptWizard;
import com.qad.fin.plugin.ui.CodeGenPage;

import org.eclipse.jface.dialogs.MessageDialog;
import org.eclipse.jface.wizard.IWizard;
import org.eclipse.jface.wizard.WizardDialog;
import org.eclipse.swt.widgets.*;

/**
 * Our sample handler extends AbstractHandler, an IHandler base class.
 * 
 * @see org.eclipse.core.commands.IHandler
 * @see org.eclipse.core.commands.AbstractHandler
 */
public class PluginHandler extends AbstractHandler {

	@Override
	public Object execute(ExecutionEvent event) throws ExecutionException {
		IWorkbenchWindow window = HandlerUtil.getActiveWorkbenchWindowChecked(event);

		IWorkbenchPage wbpage = PlatformUI.getWorkbench().getActiveWorkbenchWindow().getActivePage();
		IEditorPart part = wbpage.getActiveEditor();
		ITextEditor editor = (ITextEditor) part;

		if (editor.getTitle().contains("ServiceImpl")) {
			WizardDialog dialog = new WizardDialog(window.getShell(), (IWizard) new CodeGenWizard());
			dialog.open();
		} else if(editor.getTitle().contains("DataContro")) {
			WizardDialog dialog = new WizardDialog(window.getShell(), (IWizard) new DCCodeGenWizard());
			dialog.open();
		}
		return null;
	}
}
