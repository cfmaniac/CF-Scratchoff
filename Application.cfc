component output="false" {

	THIS.NAME='session';
	THIS.clientManagement = false;
	THIS.sessionManagement = true;
	THIS.setClientCookies = true;	
	THIS.sessionTimeout = createTimeSpan(0, 0, 45, 0);
	THIS.applicationTimeout = createTimeSpan(0,0,45,0);

	THIS.datasource='ScratchOffs';

	
	THIS.mappings[ "/com"] = environment.root_path & "com/";
	

	function onApplicationStart() {
	     //Create the ScratchOff Admin Component:
		ScratchOffAdmin =  ScratchOff = CreateObject('component', 'com.AdminScratchOff');
		//Create the ScratchOff Back-Off Component:
		BOScratchOff = BOScratchOff = CreateObject('component', 'com.BOScratchOff'); 
		//Creates the ScratchOff Front-End Component:
		ScratchOff = CreateObject('component', 'com.ScratchOff');    
        return true;
	}


	function onApplicationEnd(required  applicationScope) {
	}


	function onRequestStart(required string thePage) {
		
        
        // The following is not required
        if (isDefined('URL.reinit') && URL.reinit){
            onSessionEnd(SESSION,APPLICATION);
            onApplicationEnd(APPLICATION);
            onApplicationStart();
            onSessionStart();
            location(url='index.cfm', addtoken='false');
        }
        return true;
	}
   

	function onRequest(required string thePage) {
        include ARGUMENTS.thePage; // When using this method, you must include the requested page
	}


	function onRequestEnd(required string thePage) {
	}
  

	function onError(required  exception,required string eventname) {
        writeDump({var=ARGUMENTS.exception,label=ARGUMENTS.eventname}); // not required
	}


	function onSessionStart() {
	}
    

	function onSessionEnd(required struct sessionScope,required struct appScope) {
	}


}
