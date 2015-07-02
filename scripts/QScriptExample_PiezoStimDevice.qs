Include("JavaScript/underscore.js");
Include("QtScript/MainControlDialog.qs");
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

mainDialog = new Dialog();
mainDialog.show();

//Set the dialogs title
mainDialog.windowTitle = "PiezoStim Device example";
//Create and configure Layout
var customLayout = new QGridLayout;
customLayout.setColumnStretch(1, 1);	
customLayout.setColumnMinimumWidth(1, 500);
//Create and configure some new labels
mainDialog.customLabel1 = new QLabel;
mainDialog.customLabel1.setFrameStyle(QFrame.Sunken | QFrame.Panel);
mainDialog.customLabel2 = new QLabel;
mainDialog.customLabel2.setFrameStyle(QFrame.Sunken | QFrame.Panel);
mainDialog.customLabel3 = new QLabel;
mainDialog.customLabel3.setFrameStyle(QFrame.Sunken | QFrame.Panel);
mainDialog.customLabel4 = new QLabel;
mainDialog.customLabel4.setFrameStyle(QFrame.Sunken | QFrame.Panel);
mainDialog.customLabel5 = new QLabel;
mainDialog.customLabel5.setFrameStyle(QFrame.Sunken | QFrame.Panel);
//Create and configure some new buttons
mainDialog.customButton1 = new QPushButton("Button #1");
mainDialog.customButton2 = new QPushButton("Button #2");
mainDialog.customButton3 = new QPushButton("Button #3");
mainDialog.customButton4 = new QPushButton("Button #4");
mainDialog.customButton5 = new QPushButton("Button #5");
//Add created controls to layout and set the new layout
customLayout.addWidget(mainDialog.customButton1, 0, 0);
customLayout.addWidget(mainDialog.customLabel1, 0, 1);
customLayout.addWidget(mainDialog.customButton2, 1, 0);
customLayout.addWidget(mainDialog.customLabel2, 1, 1);
customLayout.addWidget(mainDialog.customButton3, 2, 0);
customLayout.addWidget(mainDialog.customLabel3, 2, 1);
customLayout.addWidget(mainDialog.customButton4, 3, 0);
customLayout.addWidget(mainDialog.customLabel4, 3, 1);
customLayout.addWidget(mainDialog.customButton5, 4, 0);
customLayout.addWidget(mainDialog.customLabel5, 4, 1);

mainDialog.setLayout(customLayout);
ConnectDisconnectScriptFunctions(true);

//*!The below wrapper function can use the compose method because the original function has one or no parameters
Dialog.prototype.closeEvent = _.compose(mainDialog.closeEvent, function()//this function is first called, afterwards the original function
{
	Log("Dialog closeEvent() (wrapped) called");
	ScriptCleanupFunction();
	//*!Return the first argument if there is one defined
	return;
})

function ConnectDisconnectScriptFunctions(Connect)
//This function can connect or disconnect all signal/slot connections defined by the boolean parameter 
{
	if(Connect) //This parameter defines whether we should connect or disconnect the signal/slots.
	{
		Log("... Connecting Signal/Slots");
		try 
		{	
			mainDialog.customButton1["clicked()"].connect(this, this.customButton1Pressed);
			mainDialog.customButton2["clicked()"].connect(this, this.customButton2Pressed);
			mainDialog.customButton3["clicked()"].connect(this, this.customButton3Pressed);
			mainDialog.customButton4["clicked()"].connect(this, this.customButton4Pressed);
			mainDialog.customButton5["clicked()"].connect(this, this.customButton5Pressed);
		} 
		catch (e) 
		{
			Log(".*. Something went wrong connecting the Signal/Slots:" + e); //If a connection fails warn the user!
		}
	}
	else
	{
		Log("... Disconnecting Signal/Slots");
		try 
		{	
			mainDialog.customButton1["clicked()"].disconnect(this, this.customButton1Pressed);
			mainDialog.customButton2["clicked()"].disconnect(this, this.customButton2Pressed);
			mainDialog.customButton3["clicked()"].disconnect(this, this.customButton3Pressed);
			mainDialog.customButton4["clicked()"].disconnect(this, this.customButton4Pressed);
			mainDialog.customButton5["clicked()"].disconnect(this, this.customButton5Pressed);			
		} 
		catch (e) 
		{
			Log(".*. Something went wrong disconnecting the Signal/Slots:" + e); //If a disconnection fails warn the user!
		}		
	}	
}

function customButton1Pressed()
{
	customButtonPressed(1);
}

function customButton2Pressed()
{
	customButtonPressed(2);
}

function customButton3Pressed()
{
	customButtonPressed(3);
}

function customButton4Pressed()
{
	customButtonPressed(4);
}

function customButton5Pressed()
{
	customButtonPressed(5);
}

function customButtonPressed(nIndex)
{
	Log("Button #" + nIndex + " was pressed.");
	if(nIndex==1)
	{
		Log("- Configure Stimulator....");
		nRetval = PiezoStimDeviceobject.closeStimulator();
		Log("\t" + PiezoStimDeviceobject.ReturnCodeToString(nRetval) + " - closeStimulator()");
		if(nRetval==0)
		{
			nRetval = PiezoStimDeviceobject.setProperty("local_buffer_size" , 5000000 );		//PC buffer in bytes (default 50 000). This property must be set before initStimulator
			Log("\t" + PiezoStimDeviceobject.ReturnCodeToString(nRetval) + " - setProperty()");
			if(nRetval==0)
			{		
				nRetval = PiezoStimDeviceobject.initStimulator(sLicenseCode);
				Log("\t" + PiezoStimDeviceobject.ReturnCodeToString(nRetval) + " - initStimulator()");
				Log(nRetval);
				if(nRetval==0)
				{
					nRetval = PiezoStimDeviceobject.setTriggerMode(16, 1, 1); 					//slot (address of controller), port (0=in, 1=out), mode(1=rising edge, 0=falling)
					Log("\t" + PiezoStimDeviceobject.ReturnCodeToString(nRetval) + " - setTriggerMode()");
					nRetval = PiezoStimDeviceobject.setTriggerLength(16, 1, 50);					//slot, port, duration of trigger (multiples of 0.5ms)
					Log("\t" + PiezoStimDeviceobject.ReturnCodeToString(nRetval) + " - setTriggerLength()");
					//nRetval = PiezoStimDeviceobject.setDAC(1 , 4095);
					//Log("	 +PiezoStimDeviceobject.ReturnCodeToString(nRetval) + " - ");
					nRetval = PiezoStimDeviceobject.setPinBlock10(0, 1, 1, 1, 1, 1, 1 ,1 ,1 ,1 ,1 ,1);		
					Log("\t" + PiezoStimDeviceobject.ReturnCodeToString(nRetval) + " - setPinBlock10()");
				}
			}
		}
	}
	else if(nIndex==2)
	{
		Log("- Programming....");
		PiezoStimulation(1);	
	}
	else if(nIndex==3)
	{
		Log("- Start Stimulation....");
		nRetval = PiezoStimDeviceobject.startStimulation();
		Log("\t" + PiezoStimDeviceobject.ReturnCodeToString(nRetval) + " - startStimulation()");
	}
	else if(nIndex==4)
	{
		Log("- Stop Stimulation....");
		nRetval = PiezoStimDeviceobject.stopStimulation();
		Log("\t" + PiezoStimDeviceobject.ReturnCodeToString(nRetval) + " - stopStimulation()");		
	}
	else if(nIndex==5)
	{
		Log("- Resetting....");
		nRetval = PiezoStimDeviceobject.resetStimulator();
		Log("\t" + PiezoStimDeviceobject.ReturnCodeToString(nRetval) + " - resetStimulator()");
	}	
}

//This function makes sure that everything gets nicely cleaned before the script ends
function ScriptCleanupFunction()//Cleanup
{
	ConnectDisconnectScriptFunctions(false);
	//Set all constructed objects to null 
	PiezoStimDeviceobject = null;
	activationArray = null;
	//Set all functions to null
	PiezoStimulation = null;
	ConnectDisconnectScriptFunctions = null;
	customButton1Pressed = null;
	customButton2Pressed = null;
	customButton3Pressed = null;
	customButton4Pressed = null;
	customButton5Pressed = null;
	customButtonPressed = null;
	//Close the dialog
	if(mainDialog)
	{
		mainDialog.close();
		mainDialog = null;
	}
	ScriptCleanupFunction = null;
	//Write something to the Log Output Pane so we know that this Function executed successfully.
	Log("\nFinished script Cleanup!");
	BrainStim.cleanupScript();
}

function PiezoStimulation(TriggerValue)
{	
	Log("\tPiezoStimulation()");
	for(nCounter=0;nCounter<50;nCounter++)
	{
		activationArray[nCounter] = nCounter*80;
	}
	for(nCounter=0;nCounter<activationArray.length;nCounter++)
	{	
		nRetval = PiezoStimDeviceobject.setDAC(1 , activationArray[nCounter]);
		//Log("\t" + PiezoStimDeviceobject.ReturnCodeToString(nRetval) + " - setDAC()");	
		//Pause(10);
		nRetval = PiezoStimDeviceobject.wait(TriggerValue, 80);
		//Log("\t" + PiezoStimDeviceobject.ReturnCodeToString(nRetval) + " - wait()");		
	}
	nRetval = PiezoStimDeviceobject.setDAC(1 , 0);
	Log("\t" + PiezoStimDeviceobject.ReturnCodeToString(nRetval) + " - setDAC()");
}

//nRetval = PiezoStimDeviceobject.setProperty(sString , nInteger );
//Log("	 +PiezoStimDeviceobject.ReturnCodeToString(nRetval) + " - ");
//nRetval = PiezoStimDeviceobject.getProperty(sString );
//Log("	 +PiezoStimDeviceobject.ReturnCodeToString(nRetval) + " - ");
//nRetval = PiezoStimDeviceobject.startStimulation();
//Log("	 +PiezoStimDeviceobject.ReturnCodeToString(nRetval) + " - ");
//nRetval = PiezoStimDeviceobject.stopStimulation();
//Log("	 +PiezoStimDeviceobject.ReturnCodeToString(nRetval) + " - ");
//nRetval = PiezoStimDeviceobject.setDAC(nInteger , nInteger );
//Log("	 +PiezoStimDeviceobject.ReturnCodeToString(nRetval) + " - ");
//nRetval = PiezoStimDeviceobject.setPinBlock8(nInteger , nInteger , nInteger , nInteger , nInteger , nInteger , nInteger , nInteger , nInteger , nInteger );
//Log("	 +PiezoStimDeviceobject.ReturnCodeToString(nRetval) + " - ");
//nRetval = PiezoStimDeviceobject.setPinBlock(nInteger , nInteger , nInteger , nInteger , nInteger , nInteger , nInteger , nInteger , nInteger , nInteger );		
//Log("	 +PiezoStimDeviceobject.ReturnCodeToString(nRetval) + " - ");
//nRetval = PiezoStimDeviceobject.setPinBlock10(nInteger , nInteger , nInteger , nInteger , nInteger , nInteger , nInteger , nInteger , nInteger , nInteger , nInteger , nInteger );		
//Log("	 +PiezoStimDeviceobject.ReturnCodeToString(nRetval) + " - ");
//nRetval = PiezoStimDeviceobject.wait(nInteger , nInteger );
//Log("	 +PiezoStimDeviceobject.ReturnCodeToString(nRetval) + " - ");
//nRetval = PiezoStimDeviceobject.setVar(nInteger , nInteger );
//Log("	 +PiezoStimDeviceobject.ReturnCodeToString(nRetval) + " - ");
//nRetval = PiezoStimDeviceobject.setVarImmediate(nInteger , nInteger );
//Log("	 +PiezoStimDeviceobject.ReturnCodeToString(nRetval) + " - ");
//nRetval = PiezoStimDeviceobject.getVarImmediate(nInteger );
//Log("	 +PiezoStimDeviceobject.ReturnCodeToString(nRetval) + " - ");
//nRetval = PiezoStimDeviceobject.incVar(nInteger );
//Log("	 +PiezoStimDeviceobject.ReturnCodeToString(nRetval) + " - ");
//nRetval = PiezoStimDeviceobject.decVar(nInteger );
//Log("	 +PiezoStimDeviceobject.ReturnCodeToString(nRetval) + " - ");
//nRetval = PiezoStimDeviceobject.outPort8(nInteger , nInteger , nInteger );
//Log("	 +PiezoStimDeviceobject.ReturnCodeToString(nRetval) + " - ");
//nRetval = PiezoStimDeviceobject.outPort16(nInteger , nInteger , nInteger , nInteger );
//Log("	 +PiezoStimDeviceobject.ReturnCodeToString(nRetval) + " - ");
//nRetval = PiezoStimDeviceobject.outPortVar16(nInteger , nInteger , nInteger , nInteger );
//Log("	 +PiezoStimDeviceobject.ReturnCodeToString(nRetval) + " - ");
//nRetval = PiezoStimDeviceobject.inPortVar16(nInteger , nInteger , nInteger , nInteger );
//Log("	 +PiezoStimDeviceobject.ReturnCodeToString(nRetval) + " - ");
//nRetval = PiezoStimDeviceobject.setTriggerMode(nInteger , nInteger , nInteger );
//Log("	 +PiezoStimDeviceobject.ReturnCodeToString(nRetval) + " - ");
//nRetval = PiezoStimDeviceobject.setTriggerLength(nInteger , nInteger , nInteger );
//Log("	 +PiezoStimDeviceobject.ReturnCodeToString(nRetval) + " - ");
//nRetval = PiezoStimDeviceobject.waitForTrigger(nInteger , nInteger );
//Log("	 +PiezoStimDeviceobject.ReturnCodeToString(nRetval) + " - ");
//nRetval = PiezoStimDeviceobject.triggerOut(nInteger , nInteger );
//Log("	 +PiezoStimDeviceobject.ReturnCodeToString(nRetval) + " - ");
//nRetval = PiezoStimDeviceobject.set2PDProperties(nInteger , nInteger , nInteger , nInteger , nInteger , nInteger );
//Log("	 +PiezoStimDeviceobject.ReturnCodeToString(nRetval) + " - ");
//nRetval = PiezoStimDeviceobject.set2PDCalibrationX(nInteger , nInteger , dDouble , dDouble , dDouble , dDouble , dDouble , dDouble , dDouble , dDouble , dDouble , dDouble );
//Log("	 +PiezoStimDeviceobject.ReturnCodeToString(nRetval) + " - ");
//nRetval = PiezoStimDeviceobject.set2PDCalibrationZ(nInteger , dDouble , dDouble , dDouble , dDouble );
//Log("	 +PiezoStimDeviceobject.ReturnCodeToString(nRetval) + " - ");
//nRetval = PiezoStimDeviceobject.set2PDDistance(nInteger , dDouble );
//Log("	 +PiezoStimDeviceobject.ReturnCodeToString(nRetval) + " - ");
//nRetval = PiezoStimDeviceobject.set2PDHeight(nInteger , nInteger , nInteger );
//Log("	 +PiezoStimDeviceobject.ReturnCodeToString(nRetval) + " - ");


//	QString ReturnCodeToString(const int &nRetval);
//	int initStimulator(const QString &sLicense);
//	int closeStimulator();
//	int resetStimulator();
//	int setProperty(QString property, int value);
//	int getProperty(QString property);
//	int startStimulation();
//	int stopStimulation();
//	int setDAC(int dac, int wert);
//	int setPinBlock8(int slot, int int_trigger, int pin0, int pin1, int pin2, int pin3, int pin4, int pin5, int pin6, int pin7);
//	int setPinBlock(int slot, int int_trigger, int pin0, int pin1, int pin2, int pin3, int pin4, int pin5, int pin6, int pin7);		
//	int setPinBlock10(int slot, int int_trigger, int pin0, int pin1, int pin2, int pin3, int pin4, int pin5, int pin6, int pin7, int pin8, int pin9);		
//	int wait(int int_trigger, int time);
//	int setVar(int var, int value);
//	int setVarImmediate(int var, int value);
//	int getVarImmediate(int var);
//	int incVar(int var);
//	int decVar(int var);
//	int outPort8(int slot, int port, int value);
//	int outPort16(int slot, int portH, int portL, int value);
//	int outPortVar16(int slot, int portH, int portL, int var);
//	int inPortVar16(int slot, int portH, int portL, int var);
//	int setTriggerMode(int slot, int port, int mode);
//	int setTriggerLength(int slot, int port, int length);
//	int waitForTrigger(int slot, int port);
//	int triggerOut(int slot, int port);
//	int set2PDProperties(int module, int slot, int subslot, int dac_x, int dac_z0, int dac_z1);
//	int set2PDCalibrationX(int module, int homeDACPos, double co0, double co1, double co2, double co3, double co4, double co5, double co6, double co7, double co8, double co9);
//	int set2PDCalibrationZ(int module, double Z0_co0, double Z0_co1, double Z1_co0, double Z1_co1);
//	int set2PDDistance(int module, double distance);
//	int set2PDHeight(int module, int promille_Z0, int promille_Z1);