//Add and clear a new output window tab
BrainStim.addOutputWindow("PiezoStim");
BrainStim.clearOutputWindow("PiezoStim");
//Construct a new Plugin object
var PiezoStimDeviceobject = new PiezoStimDevice();
var sLicenseCode = "";//Please fill-in your license code here!
var nCounter;
var nRetval;
var nInteger = 1;
var sString = "Test";
var dDouble = 1.87;
var activationArray = [];

//Create a custom dialog with only one exit button to exit the script when needed
function Dialog(parent)
{
	QDialog.call(this, parent);
	var frameStyle = QFrame.Sunken | QFrame.Panel;
	var layout = new QGridLayout;
	layout.setColumnStretch(1, 1);	
	layout.setColumnMinimumWidth(1, 500);
	/////////////////////////////////////////////////////
	
	this.btnConfigureStimulator = new QPushButton("Configure Stimulator");
	layout.addWidget(this.btnConfigureStimulator, 0, 0);
	this.btnProgramStimulator = new QPushButton("Program Stimulator");
	layout.addWidget(this.btnProgramStimulator, 1, 0);	
	this.btnStartStimulation = new QPushButton("Start Stimulatation");
	layout.addWidget(this.btnStartStimulation, 2, 0);	
	this.btnStopStimulation = new QPushButton("Stop Stimululation");
	layout.addWidget(this.btnStopStimulation, 3, 0);	
	this.btnResetStimulator = new QPushButton("Reset Stimulator");
	layout.addWidget(this.btnResetStimulator, 4, 0);	
	
	/////////////////////////////////////////////////////
	this.exitButton = new QPushButton("Exit");	
	layout.addWidget(this.exitButton, 99, 0);
	/////////////////////////////////////////////////////
	this.setLayout(layout);
	this.windowTitle = "Menu Dialog";
}

Dialog.prototype = new QDialog();

Dialog.prototype.keyPressEvent = function(e /*QKeyEvent e*/)
{
	if(e.key() == Qt.Key_Escape)
		this.close();
	else
		QDialog.keyPressEvent(e);
}

Dialog.prototype.closeEvent = function() 
{
	Log("Dialog closeEvent() detected!");
	CleanupScript();
}

function ConnectDisconnectScriptFunctions(Connect)
{
	if(Connect)
	{
		Log("... Connecting Signal/Slots");
		try
		{
			mainDialog.exitButton["clicked()"].connect(this, this.CleanupScript);		
			mainDialog.btnConfigureStimulator["clicked()"].connect(this, this.ConfigureStimulator);
			mainDialog.btnProgramStimulator["clicked()"].connect(this, this.ProgramStimulator);
			mainDialog.btnStartStimulation["clicked()"].connect(this, this.StartStimulation);
			mainDialog.btnStopStimulation["clicked()"].connect(this, this.StopStimulation);
			mainDialog.btnResetStimulator["clicked()"].connect(this, this.ResetStimulator);
		}
		catch (e)
		{
			Log(".*. Something went wrong connecting the Signal/Slots:" + e);
		}
	}
	else
	{
		Log("... Disconnecting Signal/Slots");
		try
		{
			mainDialog.exitButton["clicked()"].disconnect(this, this.CleanupScript);		
			mainDialog.btnConfigureStimulator["clicked()"].disconnect(this, this.ConfigureStimulator);
			mainDialog.btnProgramStimulator["clicked()"].disconnect(this, this.ProgramStimulator);
			mainDialog.btnStartStimulation["clicked()"].disconnect(this, this.StartStimulation);
			mainDialog.btnStopStimulation["clicked()"].disconnect(this, this.StopStimulation);
			mainDialog.btnResetStimulator["clicked()"].disconnect(this, this.ResetStimulator);
		}
		catch (e)
		{
			Log(".*. Something went wrong disconnecting the Signal/Slots:" + e);
		}
	}
}
	
function ConfigureStimulator()
{
	BrainStim.write2OutputWindow("- ConfigureStimulator() called", "PiezoStim");
	
	nRetval = PiezoStimDeviceobject.closeStimulator();
	BrainStim.write2OutputWindow("\t" + "closeStimulator() returned: " + PiezoStimDeviceobject.ReturnCodeToString(nRetval), "PiezoStim");
	if(nRetval==0)
	{
		nRetval = PiezoStimDeviceobject.setProperty("local_buffer_size" , 5000000 );		//PC buffer in bytes (default 50 000). This property must be set before initStimulator
		BrainStim.write2OutputWindow("\t" + "setProperty() returned: " + PiezoStimDeviceobject.ReturnCodeToString(nRetval), "PiezoStim");
		if(nRetval==0)
		{		
			nRetval = PiezoStimDeviceobject.initStimulator(sLicenseCode);
			BrainStim.write2OutputWindow("\t" + "initStimulator() returned: " + PiezoStimDeviceobject.ReturnCodeToString(nRetval), "PiezoStim");
			if(nRetval==0)
			{
				nRetval = PiezoStimDeviceobject.setTriggerMode(16, 1, 1); 					//slot (address of controller), port (0=in, 1=out), mode(1=rising edge, 0=falling)
				BrainStim.write2OutputWindow("\t" + "setTriggerMode() returned: " + PiezoStimDeviceobject.ReturnCodeToString(nRetval), "PiezoStim");
				nRetval = PiezoStimDeviceobject.setTriggerLength(16, 1, 50);					//slot, port, duration of trigger (multiples of 0.5ms)
				BrainStim.write2OutputWindow("\t" + "setTriggerLenght() returned: " + PiezoStimDeviceobject.ReturnCodeToString(nRetval), "PiezoStim");
				nRetval = PiezoStimDeviceobject.setPinBlock10(0, 1, 1, 1, 1, 1, 1 ,1 ,1 ,1 ,1 ,1);		
				BrainStim.write2OutputWindow("\t" + "setpPinBlock10() returned: " + PiezoStimDeviceobject.ReturnCodeToString(nRetval), "PiezoStim");
			}
		}
	}	
}

function ProgramStimulator()
{
	BrainStim.write2OutputWindow("- ProgramStimulator() called", "PiezoStim");
	activationArray = [];
	for(var nCounter=0;nCounter<50;nCounter++)
	{
		activationArray[nCounter] = nCounter*80;
	}
	for(nCounter=0;nCounter<activationArray.length;nCounter++)
	{	
		nRetval = PiezoStimDeviceobject.setDAC(1 , activationArray[nCounter]);
		//BrainStim.write2OutputWindow("\t" + "setDAC() returned: " + PiezoStimDeviceobject.ReturnCodeToString(nRetval), "PiezoStim");	
		//Pause(10);
		nRetval = PiezoStimDeviceobject.wait(TriggerValue, 80);
		//BrainStim.write2OutputWindow("\t" + "wait() returned: " + PiezoStimDeviceobject.ReturnCodeToString(nRetval), "PiezoStim");		
	}
	nRetval = PiezoStimDeviceobject.setDAC(1 , 0);
	//BrainStim.write2OutputWindow("\t" + "setDAC() returned: " + PiezoStimDeviceobject.ReturnCodeToString(nRetval), "PiezoStim");
}

function StartStimulation()
{
	BrainStim.write2OutputWindow("- StartStimulation() called", "PiezoStim");
	var nRetval = PiezoStimDeviceobject.startStimulation();
	BrainStim.write2OutputWindow("\t" + "startStimulation() returned: " + PiezoStimDeviceobject.ReturnCodeToString(nRetval), "PiezoStim");
}

function StopStimulation()
{
	BrainStim.write2OutputWindow("- StopStimulation() called", "PiezoStim");
	nRetval = PiezoStimDeviceobject.stopStimulation();
	BrainStim.write2OutputWindow("\t" + "stopStimulation() returned: " + PiezoStimDeviceobject.ReturnCodeToString(nRetval), "PiezoStim");
}

function ResetStimulator()
{
	BrainStim.write2OutputWindow("- ResetStimulator() called", "PiezoStim");
	nRetval = PiezoStimDeviceobject.resetStimulator();
	BrainStim.write2OutputWindow("\t" + "resetStimulator() returned: " + PiezoStimDeviceobject.ReturnCodeToString(nRetval), "PiezoStim");
}

//This function makes sure that everything gets nicely cleaned before the script ends
function CleanupScript()//Cleanup
{
	//Close dialog
	mainDialog.close();
	//Disconnect the signal/slots
	ConnectDisconnectScriptFunctions(false);
	//Set all functions and constructed objects to null
	ConnectDisconnectScriptFunctions = null;
	CleanupScript = null;
	//Piezo functions
	ConfigureStimulator = null;
	ProgramStimulator = null;
	StartStimulation = null;
	StopStimulation = null;
	ResetStimulator = null;
	//Dialog
	Dialog.prototype.keyPressEvent = null;
	Dialog.prototype.closeEvent = null;	
	Dialog.prototype.testFunction = null;
	Dialog.prototype = null;
	Dialog = null;
	//Objects
	mainDialog = null;
	PiezoStimDeviceobject = null;
	//Post
	Log("Finished script cleanup, ready for garbage collection!");
	BrainStim.cleanupScript();	
}

var mainDialog = new Dialog();
mainDialog.windowTitle = "PiezoStimulator Example";
mainDialog.show();
ConnectDisconnectScriptFunctions(true);