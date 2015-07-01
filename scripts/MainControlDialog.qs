Log("MainControlDialog.qs included...");

function Dialog(parent)
{
	QDialog.call(this, parent);

	//var frameStyle = QFrame.Sunken | QFrame.Panel;
	//var layout = new QGridLayout;

	//layout.setColumnStretch(1, 1);	
	//layout.setColumnMinimumWidth(1, 500);
/*	
	this.openEngineLabel = new QLabel;
	this.openEngineLabel.setFrameStyle(frameStyle);
	this.openEngineButton = new QPushButton("Open Matlab Engine");	
	layout.addWidget(this.openEngineButton, 0, 0);
	layout.addWidget(this.openEngineLabel, 0, 1);
	/////////////////////////////////////////////////////
	this.evaluateStringLineEdit = new QLineEdit;
	this.evaluateStringButton = new QPushButton("Evaluate(matlab script)");
	layout.addWidget(this.evaluateStringButton, 1, 0);
	layout.addWidget(this.evaluateStringLineEdit, 1, 1);
	this.evaluateStringLineEdit.text = "x=[12, 62, 93, -8, 22; 16, 2, 87, 43, 91; -4, 17, -72, 95, 6]";
	//Examples:
	//	whos x
	/////////////////////////////////////////////////////
	this.getVariableLineEdit = new QLineEdit;
	this.getVariableButton = new QPushButton("Get Variabele");	
	layout.addWidget(this.getVariableButton, 2, 0);
	layout.addWidget(this.getVariableLineEdit, 2, 1);
	this.getVariableLineEdit.text = "x";
	/*
	/////////////////////////////////////////////////////
	this.showNodeLabel = new QLabel;
	this.showNodeLabel.setFrameStyle(frameStyle);
	this.showGraphEditorButton = new QPushButton(tr("Show Experiment(graph editor)"));	
	layout.addWidget(this.showGraphEditorButton, 3, 0);
	layout.addWidget(this.showNodeLabel, 3, 1);
	/////////////////////////////////////////////////////
	this.showTreeLabel = new QLabel;
	this.showTreeLabel.setFrameStyle(frameStyle);
	this.showTreeEditorButton = new QPushButton(tr("Show Experiment(table editor)"));	
	layout.addWidget(this.showTreeEditorButton, 4, 0);
	layout.addWidget(this.showTreeLabel, 4, 1);
	/////////////////////////////////////////////////////	
	this.runLabel = new QLabel;
	this.runLabel.setFrameStyle(frameStyle);
	this.runButton = new QPushButton(tr("Run Experiment"));	
	layout.addWidget(this.runButton, 5, 0);
	layout.addWidget(this.runLabel, 5, 1);
	/////////////////////////////////////////////////////
	this.saveLabel = new QLabel;
	this.saveLabel.setFrameStyle(frameStyle);
	this.saveButton = new QPushButton(tr("Save Experiment"));	
	layout.addWidget(this.saveButton, 6, 0);
	layout.addWidget(this.saveLabel, 6, 1);

	/////////////////////////////////////////////////////
	this.exitLabel = new QLabel;
	this.exitLabel.setFrameStyle(frameStyle);
	this.exitButton = new QPushButton("Exit");	
	layout.addWidget(this.exitButton, 7, 0);
	layout.addWidget(this.exitLabel, 7, 1);
*/
	//this.setLayout(layout);
	//this.windowTitle = "Menu Dialog";
}

//Extend the prototype...
Dialog.prototype = new QDialog();

//Dialog.prototype.addWidget = function(pWidget) 
//{
//	var layout = new QGridLayout;
//	layout.setColumnStretch(1, 1);	
//	layout.setColumnMinimumWidth(1, 500);
	
//	//this.layout.addWidget(pWidget, 0, 1);
//	this.setLayout(layout);
//	Log("Dialog addWidget() called");
//}

Dialog.prototype.keyPressEvent = function(e /*QKeyEvent e*/)
{
	if(e.key() == Qt.Key_Escape)
	{
		this.close();
	}
	else
	{
		QDialog.keyPressEvent(e);
	}
}

Dialog.prototype.closeEvent = function() 
{
	Log("Dialog closeEvent() detected!");
	_MainControlDialogCleanup();
}

function _MainControlDialogCleanup() 
{
	Log("Dialog cleanup() called(begin)");
	//Cleanup the Dialog prototype
	//Dialog.prototype.addWidget = null;
	Dialog.prototype.keyPressEvent = null;
	Dialog.prototype.closeEvent = null;
	Dialog.prototype = null;
	Dialog = null;
	//Cleanup local functions
	_MainControlDialogCleanup = null;
	//Finally call the Brainstim cleanupScript() method to force a garbage collection
	BrainStim.cleanupScript();
	Log("Dialog cleanup() called(end)");
}

/*
//example usage...
mainDialog = new Dialog();
mainDialog.show();

//Set the dialogs title
mainDialog.windowTitle = "Custom Menu Dialog Title";
//Create and configure Layout
var customLayout = new QGridLayout;
customLayout.setColumnStretch(1, 1);	
customLayout.setColumnMinimumWidth(1, 500);
//Create and configure new label
var customLabel1 = new QLabel;
customLabel1.setFrameStyle(QFrame.Sunken | QFrame.Panel);
//Create and configure new button
var customButton1 = new QPushButton("Button #1");
//Add created controls to layout and set the new layout
customLayout.addWidget(customButton1, 0, 0);
customLayout.addWidget(customLabel1, 0, 1);
mainDialog.setLayout(customLayout);

Pause(3000);

mainDialog.close();
mainDialog = null;
*/