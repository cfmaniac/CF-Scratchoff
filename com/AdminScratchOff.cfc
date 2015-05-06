component name="ScratchOff" hint="I am the ScratchOff Administration Component" persistent="true" accessors="true" output="false"{
   /*ScratchOff TYPES:
   // 1 = StandAlone
   // 2 = Promo
   // 3 = Product
   */
   
   //Properties for Image Functions:
   property name="sitewide_datasource" default="";
   property name="environment" default="Production";
   property name="width" default="60";
	property name="height" default="130";
	property name="type" default="resize"; 
   property name="descriptions" default="../SITETEMPLATE/images/screcials/descriptions/";
   
   //Some Special functions that Aren't Native to CF9:
   function DateTimeFormat(time) {
       var str = "";
       var dateFormat = "mmmm d, yyyy";
       var timeFormat = "h:mm tt";
       var joinStr = " ";
    
      if(ArrayLen(Arguments) gte 2) dateFormat = Arguments2;
      if(ArrayLen(Arguments) gte 3) timeFormat = Arguments3;
      if(ArrayLen(Arguments) gte 4) joinStr = Arguments4;

      return DateFormat(time, dateFormat) & joinStr & TimeFormat(time, timeFormat);
   }
   //End Patches for CF9
   
   //Some Date & Time Functions:
   function LastDayOfMonth(strMonth) {
       var strYear=Year(Now());
         if (ArrayLen(Arguments) gt 1)
         strYear=Arguments[2];
         return DateAdd("d", -1, DateAdd("m", 1, CreateDate(strYear, strMonth, 1)));
   }
   
   function GetLastOccOfDayInMonth(TheDayOfWeek,TheMonth,TheYear) {
      //Find The Number of Days in Month
      Var TheDaysInMonth=DaysInMonth(CreateDate(TheYear,TheMonth,1));
      //find the day of week of Last Day
      Var DayOfWeekOfLastDay=DayOfWeek(CreateDate(TheYear,TheMonth,TheDaysInMonth));
      //subtract DayOfWeek
      Var DaysDifference=DayOfWeekOfLastDay - TheDayOfWeek;
      //Add a week if it is negative
      if(DaysDifference lt 0){
         DaysDifference=DaysDifference + 7;
      }
      return TheDaysInMonth-DaysDifference;
   }

    function GetNthOccOfDayInMonth(NthOccurrence,TheDayOfWeek,TheMonth,TheYear){
      Var TheDayInMonth=0;
         if(TheDayOfWeek lt DayOfWeek(CreateDate(TheYear,TheMonth,1))){
            TheDayInMonth= 1 + NthOccurrence*7  + (TheDayOfWeek - DayOfWeek(CreateDate(TheYear,TheMonth,1))) MOD 7;
         }else{
            TheDayInMonth= 1 + (NthOccurrence-1)*7  + (TheDayOfWeek - DayOfWeek(CreateDate(TheYear,TheMonth,1))) MOD 7;
         }
  
      //If the result is greater than days in month or less than 1, return -1
         if(TheDayInMonth gt DaysInMonth(CreateDate(TheYear,TheMonth,1)) OR   TheDayInMonth lt 1){
            return -1;
         } else{
         return TheDayInMonth;
         }
    }
    
    //Image Utility Functions:
    function resizeImage(width, height, source) {
	   var img = getBufferedImage(arguments.source);
	   var dest = arguments.source;
	   if (ArrayLen(arguments) EQ 4) {
   		dest = arguments[4];
   	}
	     scaleBufferedImage(img, dest, arguments.width/img.getWidth(), arguments.height/img.getHeight());
    }
    
    function resizeIf(maxWidth, maxHeight, source) {
	   var img = getBufferedImage(arguments.source);
	   var scale = 0;
	   var result = StructNew();
	   var dest = arguments.source;
	   if (img.getWidth() GT arguments.maxWidth) {
		scale = arguments.maxWidth/img.getWidth();
		if ( (img.getHeight() * scale) GT arguments.maxHeight ) {
			scale = arguments.maxHeight/img.getHeight();
		}
	   } else if (img.getHeight() GT arguments.maxHeight) {
		scale = arguments.maxHeight/img.getHeight();
	   }
	
	   if (scale) {
		if (ArrayLen(arguments) EQ 4) {
			dest = arguments[4];
		}
		scaleBufferedImage(img, dest, scale, scale);
		result.height = Ceiling(img.getHeight() * scale);
		result.width = Ceiling(img.getWidth() * scale);
	   } else {
		result.height = img.getHeight();
		result.width = img.getWidth();
	   }
	   return result;
    }
    
    function getImageDimensions(imgFile) {
	    var result = StructNew();
	    var img = getBufferedImage(imgFile);
	      result.height = img.getHeight();
	      result.width = img.getWidth();
	    return result;
    }
    
    //getBufferedImage - returns a java.awt.image.BufferedImage given an image file path
 
   function getBufferedImage(imgPath) {
	   var imageIO = CreateObject("java", "javax.imageio.ImageIO");
	   var sourceFile = CreateObject("java", "java.io.File");
	   var imgInputStream = CreateObject("java", "javax.imageio.stream.FileImageInputStream");
	   sourceFile.init(JavaCast("string", arguments.imgPath));
	   imgInputStream.init(sourceFile);
	   return imageIO.read(imgInputStream);
   }


   // scales an image, and
 
   function scaleBufferedImage(img, destPath, xscale, yscale) {
	   var imageIO = CreateObject("java", "javax.imageio.ImageIO");
	   var transform = CreateObject("java", "java.awt.geom.AffineTransform");
	   var transformOp = CreateObject("java", "java.awt.image.AffineTransformOp");
	   var renderingHints = CreateObject("java", "java.awt.RenderingHints");
	   var destFile = CreateObject("java", "java.io.File");
	   var destImg = "";
	   var graphics = "";
	   transform.init();
	   transform.scale(JavaCast("double", xscale), JavaCast("double", yscale));
	   renderingHints.init(renderingHints.KEY_INTERPOLATION, renderingHints.VALUE_INTERPOLATION_BICUBIC);
	   transformOp.init(transform, renderingHints);
	   destImg = transformOp.createCompatibleDestImage(img, img.getColorModel());
	   graphics = destImg.createGraphics();
	   graphics.drawImage(img, transform, CreateObject("java", "java.awt.Container").init());
	   //DEMO
	   //graphics.setFont( CreateObject("java", "java.awt.Font").init("Arial", graphics.getFont().BOLD, 24) );
	   //graphics.drawString("DEMO", JavaCast("int", 3), JavaCast("int", 20));
	
	   graphics.dispose();
	   destFile.init(arguments.destPath);
	   imageIO.write(destImg, getFormatFromFileName(arguments.destPath), destFile);
   }


   //returns a image format type for ImageIO based on the file name
   function getFormatFromFileName(fileName) {
	   var format = "jpeg";
	   var destExt = ReReplace(arguments.fileName, ".*\.([^.]+$)", "\1");
	   switch (LCase(destExt)) {
		   case "png":
			   return "png";
			break;
		   
		   default:
			return "jpeg";
			break;
	   }	
   }
   //End Image Utility Functions
   
   
   
   //Utility Functions:
      function httpGet(URLstr){
	//documentation: http://help.cj.com/en/web_services/web_services.htm
	//authorizationCode="0085dd72c64aa940978e5cafd1193be9a5f893125b7ddc2b0bbecd9428831ebcb9be28259d5bd612b85435ea1455fb4e40604486e109e07d1a4082ee48e48d3121/3fbd2a9a3a108edddafe4d04cdf416135de1815b28f97d51915f478d66a96b087d56bca1b48f2593a1601971342a09e6723edcf943148655a1a2a52d0477b065";

	//documentation:http://cjsupport.custhelp.com/app/answers/detail/a_id/1170/kw/API/related/1
	authorizationCode="00c5872c8dc387263d5e17983ad3c13cd4cd17d3f98f13773e32e03db815ad1365cdbef5e70230a1ee0b39b4831ba220a110398e97054e8e6fa6872f12176d5aa5/658e7532c1e7d79a4fa933e47300f424b8f9da4b81eb51309279c661c20b455ff6c671b8dbe9475d02108e165f26263b6234a759d57f269d7ec01bb253900c01";
	httpService = new http(); httpService.setMethod("get");	httpService.setUrl(URLstr);
	httpService.addParam(type="header",name="Authorization",value=authorizationCode);
	return httpService.send().getPrefix();
}

   function parseXML(myXML){
	struct = StructNew();
	for (i=1;i LTE ArrayLen(myXML);i++) {
		x = xmlparse(myXML[i]);
		for(key in x.product) {	struct[i][key]=x.product[key].XmlText;}
	}
	return struct;
   }
   
   function ReplaceAmps(string){
	s=Replace(#string#, "&amp;", "&","All");	 // to prevent the output of '&amp;amp;'
	s=Replace(#s#, "&", "&amp;","All");
	return s;
   }
   //End Utility Functions
   
   public any function init(){
         /*variables.datasource = arguments.datasource;
         setSitewide_Datasource(variables.datasource);*/
         
         
         if(isdefined('arguments.environment') and arguments.environment NEQ ""){
            setEnvironment('#arguments.environment#');
         }       
        
        
        
      return this;
   }
   
   public any function getAdminStyles(){
      savecontent variable = "local.css"{
         WriteOutput('<!---The ScratchOff Admin Styles--->
         <style>
         .menu td{font-weight:bold; font-size:14px; text-align:center; padding:10px;}
         .lbl{font-weight:bold; font-size:14px; text-align:right; padding-right:5px;}
         body{margin:50px; background-color:##333; font-family:Tahoma, Geneva, sans-serif;}
         ##container {width: 1170px; margin-right: auto; margin-left: auto; padding-left: 15px; padding-right: 15px;}
         ##whiteBox{width: 100%; border-radius:10px; padding:40px; background: ##fff; display:inline-block;}
         
         .button{font-size:16px !important; font-weight:bold;}
         ##topbar{text-align:right; margin-bottom:20px; padding:3px;}
         ##topbar a {text-decoration:none; border-radius: 5px; font-size:11px; padding: 2px 5px 2px 5px; margin:4px; color:black; border: 1px solid ##aaa; box-shadow: 1px 1px 1px ##eee;
                     background-image: linear-gradient(bottom, rgb(240,237,240) 7%, rgb(247,247,247) 54%);
                     background-image: -o-linear-gradient(bottom, rgb(240,237,240) 7%, rgb(247,247,247) 54%);
                     background-image: -moz-linear-gradient(bottom, rgb(240,237,240) 7%, rgb(247,247,247) 54%);
                     background-image: -webkit-linear-gradient(bottom, rgb(240,237,240) 7%, rgb(247,247,247) 54%);
                     background-image: -ms-linear-gradient(bottom, rgb(240,237,240) 7%, rgb(247,247,247) 54%);
                     background-image: -webkit-gradient(
	                  linear,
	                  left bottom,
	                  left top,
	                  color-stop(0.07, rgb(240,237,240)),
	                  color-stop(0.54, rgb(247,247,247))
         );

         }

         ##bottombar{text-align:right; margin-top:50px; padding:3px;}
         ##bottombar a, .but {text-decoration:none; border-radius: 5px; font-size:11px; padding: 2px 5px 2px 5px; background-color:##333; margin:4px; color:white;}
         
         .but{cursor: pointer;}
         ##topbar a:hover, ##bottombar a:hover, .but:hover, .button.hover{color: ##333; background-color:##ccc; margin:3	px; box-shadow: 0px 0px 4px ##999; border: thin solid ##777;}


	      .but2 {color:##333; background-color:##ccc; border: thin solid ##777; font-size:13px; padding: 2px 7px; text-decoration:none;  border-radius: 15px; white-space:nowrap;}
         .but2:hover{color:##fff; background-color:##333; border: thin solid ##333;}
         ##responsebar{text-align:center; font-size:24px; font-weight:bold; margin-bottom:10px; color:##999;}
         
         
         .results_table td{padding:5px 10px; font-size:12px;}
	      .rowheader{text-align:left; font-weight:bold;background-color: ##555; color:##fff;white-space:nowrap;}
	      .row_0 {background-color: ##e9f5f4; }
	      .row_1{background-color:##f3f2f2;}
	      
	      .row {
            margin-left: -15px;
            margin-right: -15px;
            text-align: left;
            clear:both;
         }

         .pull-left {
            float: left !important;
            margin-bottom: 7px;
         }

         .pull-right {
            float: right !important;
            margin-bottom: 7px;
  
         }
         .column9 {
         width: 66.66666666%;
         }
         
         /*Two Column*/
         .column6 {
         width: 50%;
         }

         /*Three Columns*/
         .column3{
         width: 33.33333333%;
         }
         
         .alert {
                     padding: 15px;
                     margin-bottom: 20px;
                     border: 1px solid transparent;
                     border-radius: 4px;
         }
         
         .alert-success {
                   background-color: ##dff0d8;
                   border-color: ##d6e9c6;
                   color: ##3c763d;
         }
                   

         /*Buttons*/
         .btn {
         display: inline-block;
         margin-bottom: 0;
         font-weight: 400;
         text-align: center;
         vertical-align: middle;
         cursor: pointer;
         background-image: none;
         border: 1px solid transparent;
         white-space: nowrap;
         padding: 6px 12px;
         font-size: 14px;
         line-height: 1.42857143;
         border-radius: 4px;
         -webkit-user-select: none;
         -moz-user-select: none;
         -ms-user-select: none;
         user-select: none;
         }
         
         /*Green*/
         .btn-success {
         color: ##fff;
         background-color: ##5cb85c;
         border-color: ##4cae4c;
         }
         /*Light Blue*/
         .btn-info {
         color: ##fff;
         background-color: ##5bc0de;
         border-color: ##46b8da;
         }
         /*Dark Blue*/
         .btn-primary {
         color: ##fff;
         background-color: ##428bca;
         border-color: ##357ebd;
         }

         /*White*/
         .btn-default {
         color: ##333;
         background-color: ##fff;
         border-color: ##ccc;
         }
         /*Yellow/Gold*/
         .btn-warning {
         color: ##fff;
         background-color: ##f0ad4e;
         border-color: ##eea236;
         }
         /*Red*/
         .btn-danger {
         color: ##fff;
         background-color: ##d9534f;
         border-color: ##d43f3a;
         }

         .hidden{
         display: none;
         }
         
         tr.odd, tr.even{
         font-size: 0.875em;
         }
         
         
         
         .odd {
         background-color: ##f5f5f5;
         border-spacing: 2px;
         border-color: gray;
         width: auto;
         }

         .even {
         background-color: ##fff;
         border-spacing: 2px;
         border-color: gray;
         width:auto;
         
         }
	      
         .onoffswitch {
            position: relative; width: 120px;
            -webkit-user-select:none; -moz-user-select:none; -ms-user-select: none;
         }

         .onoffswitch-checkbox {
            display: none;
         }

         .onoffswitch-label {
            display: block; overflow: hidden; cursor: pointer;
            border: 2px solid ##999999; border-radius: 20px;
         }

         .onoffswitch-inner {
            width: 200%; margin-left: -100%;
            -moz-transition: margin 0.3s ease-in 0s; -webkit-transition: margin 0.3s ease-in 0s;
            -o-transition: margin 0.3s ease-in 0s; transition: margin 0.3s ease-in 0s;
         }

         .onoffswitch-inner:before, .onoffswitch-inner:after {
            float: left; width: 50%; height: 30px; padding: 0; line-height: 30px;
            font-size: 16px; color: white; font-family: Trebuchet, Arial, sans-serif; font-weight: bold;
            -moz-box-sizing: border-box; -webkit-box-sizing: border-box; box-sizing: border-box;
         }

         .onoffswitch-inner:before {
           content: "Active";
           padding-left: 14px;
           background-color: ##0A8F15; color: ##FFFFFF;
         }

         .onoffswitch-inner:after {
           content: "Inactive";
           padding-right: 14px;
           background-color: ##EEEEEE; color: ##999999;
           text-align: right;
         }

         .onoffswitch-switch {
            width: 20px; margin: 5px;
            background: ##FFFFFF;
            border: 2px solid ##999999; border-radius: 20px;
            position: absolute; top: 0; bottom: 0; right: 86px;
            -moz-transition: all 0.3s ease-in 0s; -webkit-transition: all 0.3s ease-in 0s;
            -o-transition: all 0.3s ease-in 0s; transition: all 0.3s ease-in 0s; 
         }

         .onoffswitch-checkbox:checked + .onoffswitch-label .onoffswitch-inner {
            margin-left: 0;
         }

         .onoffswitch-checkbox:checked + .onoffswitch-label .onoffswitch-switch {
            right: 0px; 
         }
         
         .req {
            color: ##8B0000;
         }
         
         textarea, input[type="text"], select {
            width: 100%;
            border: 1px solid ##dddddd;
            border-radius: 4px;
            color: ##000;
         }

         textarea {
            height: 150px;
         }
      
         input[type="text"], select{
            height: 20px;
         }

         .help-block {
            display: block;
            margin-bottom: 10px;
            color: ##595959;
            font-size: 0.625em;
         }

         ##sco_start, ##sco_end{
            width: 85%;
            border: 1px solid ##dddddd;
            border-radius: 4px;
            color: ##000;
            height: 20px;
         }

         .panel {
            position: absolute;
            top: 0;
            height: 100%;
            border-width: 0;
            margin: 0;
         }

         .panel inactive{
            display: none;
         }

         .panel active {
            display: block;
            right: 0;
            width: 100%;
            height: 100%;
         }

         .panel {
            position: fixed;
            top: 150px;
            right: 0;
            display: none;
            background: ##fff;
            border:1px solid ##f5f5f5;
            -moz-border-radius-topleft: 20px;
            -webkit-border-top-left-radius: 20px;
            -moz-border-radius-bottomleft: 20px;
            -webkit-border-bottom-left-radius: 20px;
            width: 200px;
            height: auto;
            padding-left: 30px;
            padding-right: 60px;
            padding-bottom: 30px;
            filter: alpha(opacity=85);
            opacity: 1.0;
         }

         .panel p{
            margin: 0 0 15px 0;
            padding: 0;
            color: ##2e2e2e;
            font-size: 0.625em;
         }

         .panel a, .panel a:visited{
            margin: 0;
            padding: 0;
            color: ##428bca;
            text-decoration: none;
            border-bottom: 1px solid ##8A2BE2;
         }

         .panel a:hover, .panel a:visited:hover{
            margin: 0;
            padding: 0;
            color: ##428bca;
            text-decoration: none;
            border-bottom: 1px solid ##8A2BE2;
         }

         a.trigger{
            position: fixed;
            text-decoration: none;
            top: 80px; 
            right: 0;
            font-size: 16px;
            letter-spacing:-1px;
            font-family: verdana, helvetica, arial, sans-serif;
            color:##fff;
            padding: 20px 40px 20px 15px;
            font-weight: 700;
            background:##428bca;
            border:1px solid ##444444;
            -moz-border-radius-topleft: 20px;
            -webkit-border-top-left-radius: 20px;
            -moz-border-radius-bottomleft: 20px;
            -webkit-border-bottom-left-radius: 20px;
            -moz-border-radius-bottomleft: 20px;
            -webkit-border-bottom-left-radius: 20px;
            display: block;
         }

         a.trigger:hover{
            position: fixed;
            text-decoration: none;
            top: 80px; 
            right: 0;
            font-size: 16px;
            letter-spacing:-1px;
            font-family: verdana, helvetica, arial, sans-serif;
            color:##fff;
            padding: 20px 40px 20px 20px;
            font-weight: 700;
            background:##428bca;
            border:1px solid ##444444;
            -moz-border-radius-topleft: 20px;
            -webkit-border-top-left-radius: 20px;
            -moz-border-radius-bottomleft: 20px;
            -webkit-border-bottom-left-radius: 20px;
            -moz-border-radius-bottomleft: 20px;
            -webkit-border-bottom-left-radius: 20px;
            display: block;
         }

         a.active.trigger {
            background:##428bca;
         }

         .inactive{
            background-color: ##f2dede;
            border-color: ##ebccd1;
         }
         
         ##footer{
         width: 1170px;
         margin-left: auto;
         margin-right: auto;
         text-align: right;
         
         }
         
         ##footer ul {
		   list-style: none;
		   padding: 0;
		   margin: 0;
	      }
	
	      ##footer li {
		   float: right;
		   border: 1px solid;
		   border-top-width: 0;
		   margin: 0 0.5em 0 0;
		   background-color: ##fff;
	      }
	
	      ##footer a {
		   display: block;
		   padding: 0 1em;
		   color: ##000;
	      }
	      
	      ##footer a:visited {
		   display: block;
		   padding: 0 1em;
		   color: ##000;
	      }
	      
	      .tabs input[type=radio] {
	          position: absolute;
	          top: -9999px;
	          left: -9999px;
	      }
	      .tabs {
	        width: auto;
	        height: 525px;
	        float: none;
	        list-style: none;
	        position: relative;
	        padding: 0;
	        margin: 75px auto;
	        
	      }
	      .tabs li{
	        float: left;
	        border-top: 1px solid ##ddd;
	         border-left: 1px solid ##ddd;
	        border-right 1px solid ##ddd;
	        border-radius: 4px;
	      }
	      .tabs label {
	          display: block;
	          padding: 10px 20px;
	          border-radius: 2px 2px 0 0;
	          font-size: 1.0em;
	          font-weight: normal;
	          cursor: pointer;
	          position: relative;
	          top: 3px;
	          -webkit-transition: all 0.2s ease-in-out;
	          -moz-transition: all 0.2s ease-in-out;
	          -o-transition: all 0.2s ease-in-out;
	          transition: all 0.2s ease-in-out;
	      }
	      
	      
	      [id^=tab]:checked + label {
	        color: black;
	        font-weight: bold;
	        top: 0;
	      }
	      
	      [id^=tab]:checked ~ [id^=tab-content] {
	          display: block;
	      }
	      .tab-content{
	        z-index: 2;
	        font-size: 0.875em;
	        display: none;
	        text-align: left;
	        width: 100%;
	        padding-top: 10px;
	        padding: 15px;
	        position: absolute;
	        left: 0;
	        border: 1px solid ##ddd;
	        border-radius: 4px;
	        box-sizing: border-box;
	        -webkit-animation-duration: 0.5s;
	        -o-animation-duration: 0.5s;
	        -moz-animation-duration: 0.5s;
	        animation-duration: 0.5s;
	      }
         </style>');
      }
      return local.css;
      
   }
   
    public any function getAdminFooter(required string task){
      savecontent variable="local.Footer"{
      WriteOutput('<div id="footer">
		               <ul>
			            <li><a href="admin_superstore.cfm">Menu</a></li>');
			            
			           
                        WriteOutput('<li><a href="index.cfm?task=ClearScratchOff">Clear ScratchOff Winners</a></li>');
                    
			            
	      if(arguments.task NEQ "default"){
           Writeoutput('<li><a href="index.cfm">ScratchOff Main</a></li>');
	      } else if (arguments.task NEQ "list"){
           WriteOutput('<li><a href="index.cfm?task=list">ScratchOff List</a></li>');
   
	      }
	      Writeoutput('<li><a href="index.cfm?task=winners">ScratchOff Winners</a></li>');
	      /*WriteOutput('<li>DataSource from Component:');
	      WriteDump(var=#getSitewide_Datasource()#, label="DataSource sent to Component"); 
	      WriteOutput('</li>');*/
	      
	      WriteOutput('</ul>
	                  </div>');
	                  
	                 
      }
      return local.footer;
   }
   
   public any function getAdminDependancies(){
      savecontent variable="local.Dependancies"{
         WriteOutput('<script type="text/javascript" src="../sitetemplate/js/jquery/jquery-1.11.0.min.js"></script>
         <script type="text/javascript" src="../sitetemplate/js/jquery/jnasybootstrap.js"></script>
         <script type="text/javascript" src="../sitetemplate/js/jquery/jquery-ui.min.js"></script>
         <script type="text/javascript" src="../sitetemplate/js/jquery/dataTables.js"></script>
         
         <link rel="stylesheet" media="all" type="text/css" href="../sitetemplate/style/jnasybootstrap.css" />
         <link rel="stylesheet" media="all" type="text/css" href="../sitetemplate/style/jquery-ui.min.css" />
         <link rel="stylesheet" media="all" type="text/css" href="../sitetemplate/style/dataTables.css">
         ');
         
      }
      return local.Dependancies;
      
   }
   public any function GetScratchOffDefault(){
   //The Total ScratchOff Count:
   SCOASQL = "Select Count(sco_id) as Total from MallMerchantScratchOff where sco_active=1";
   SCOISQL = "Select Count(sco_id) as Total from MallMerchantScratchOff where sco_active=0";
   ActiveScratchOff = new Query(sql=SCOASQL).execute().getResult();
   InActiveScratchOff = new Query(sql=SCOISQL).execute().getResult();
   //Categories:
   CTSQL="SELECT ID, Name from MallCategories where active=1";
   Categories= new Query(sql=CTSQL).execute().getResult(); 
   
   //Malls:
   MLSQL="SELECT MST.id, MST.company, MST.mallname
            FROM MallSites MST WHERE MST.inactive IS NULL ORDER BY MallName";
   Malls = new Query(sql=MLSQL).execute().GetResult();  
   
   //Merchants:
   MRSQL="SELECT ID as mmr_id, link as LinkURL, merchant as MerchantName from MallMerchants MMR Where inactive is NULL ORDER BY Merchant";
   Merchants = new Query(sql=MRSQL).execute().getResult();
   
   
      savecontent variable="local.default"{
         writeOutput('<div class="row">');
         if(ActiveScratchOff.Total EQ "0"){
         WriteOutput('<p class="alert alert-success" style="text-align: center;">There are not any active ScratchOff. ScratchOff aren''t being displayed on the front-end.</p>');
         }
      WriteOutput('<p>How would you Like to Start your Screcial?</p>
      <div class="column3 pull-left" style="text-align: center;">
          <a href="?task=add&type=1" class="btn btn-success" style="text-decoration: none; font-weight: bold;">I would like to Start with an Empty Screcial</a>
          <p style="font-size: 0.625em;">This Screcial will not be associated with any Promotion or Special currently running, and will be a stand-alone (independant) Screcial.</p>
      </div>
      
      <div class="column3 pull-left" style="text-align: center;">
          <a href="##" id="ShowProdSearch" class="btn btn-success" style="text-decoration: none; font-weight: bold;">I would like to Create one from a Product</a>
           <p style="font-size: 0.625em;">This Screcial will be based upon a Product from a Specific Merchant</p>
      </div>   
      
      <div class="column3 pull-right" style="text-align: center;">
          <a href="##" id="ShowPromoSearch" class="btn btn-success" style="text-decoration: none; font-weight: bold;">I would like to Create one from a Promo</a>
           <p style="font-size: 0.625em;">This Screcial will be based upon a Promotion from a specific Merchant</p>
      </div>     
      </div>
      
      <!---//Display Options: for Product Search//--->
      <div class="row hidden" id="StartFromProd" style="margin-top: 15px;">
         <div class="column6 pull-left">
         <strong>Search Products for:</strong>
         </div>
         <div class="column6 pull-right">
            <input type="text" style="width: 350px;" name="prodText" id="prodText"><br/>
	         <select style="width:350px" name="searchMall" id="searchMall">
               <option value="0" selected="selected">All Malls</option>');
               for(ML=1;ML LTE Malls.recordcount;ML=ML+1){
                  WriteOutput('<option value="#Malls.id[ML]#">#Malls.mallName[ML]# (Company: #Malls.Company[ML]#)</option>');
               }
              
            Writeoutput('</select><br/>
	                 
	          <div class="row">
              <input type="submit" id="ClearProds" value="Clear Results" class="btn btn-info"/>  <input class="btn btn-primary" type="submit" id="SearchProdScratchOff" value="Search for SCRECIALS" />
             </div> 
         </div>   
         
       <div id="ResultsProds" style="margin-top: 15px; float:left; clear: both; display:none; height: 385px; width:100%;overflow: auto;"></div>
         
        
      </div>
      
      <!---//Display Options: for Promo Search//--->
      <div class="row hidden" id="StartFromPromo" style="margin-top: 15px;">
         <div class="column6 pull-left">
         <strong>Search Promos for:</strong>
         </div>
         <div class="column6 pull-right">
            <input type="text" style="width: 350px;" name="promoText" id="promoText"><br/>
	         <select style="width:350px" name="searchType" id="searchType">
               <option value="0" selected="selected">All Areas</option>
               <option value="1">Promo Headline</option>
               <option value="2">Promo Text</option>
               <option value="3">Merchant Name</option>
	         </select><br/>
	         <select style="width:350px" name="searchCat" id="searchCat">
               <option value="0" selected="selected">All Categories</option>');
               for(CT=1;CT LTE Categories.recordcount;CT=CT+1){
                  WriteOutput('<option value="#Categories.id[CT]#">#Categories.name[CT]#</option>');
               }
            Writeoutput('</select>
	         
	          <div class="row">
              <input type="submit" id="ClearPromos" value="Clear Results" class="btn btn-info"/>  <input class="btn btn-primary" type="submit" id="SearchScratchOff" value="Search for SCRECIALS" />
             </div> 
         </div>   
         
       <div id="ResultsPromos" style="margin-top: 15px; float:left; clear: both; display:none; height: 385px; width:100%;overflow: auto;"></div>
         
        
      </div>
      
      <div class="row">
         <div class="column6 pull-right" style="border: 2px solid ##f5f5f5; background: rgb(238,238,238); /* Old browsers */
         background: -moz-linear-gradient(top, rgba(238,238,238,1) 0%, rgba(204,204,204,1) 100%); /* FF3.6+ */
         background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,rgba(238,238,238,1)), color-stop(100%,rgba(204,204,204,1))); /* Chrome,Safari4+ */
         background: -webkit-linear-gradient(top, rgba(238,238,238,1) 0%,rgba(204,204,204,1) 100%); /* Chrome10+,Safari5.1+ */
         background: -o-linear-gradient(top, rgba(238,238,238,1) 0%,rgba(204,204,204,1) 100%); /* Opera 11.10+ */
         background: -ms-linear-gradient(top, rgba(238,238,238,1) 0%,rgba(204,204,204,1) 100%); /* IE10+ */
         background: linear-gradient(to bottom, rgba(238,238,238,1) 0%,rgba(204,204,204,1) 100%); /* W3C */
         border-radius: 4px;">
         <p style="text-align: center;">ScratchOff&##8480; Statistics:</p>');
         
         
         
         
         WriteOutput('<p class="column6 pull-left">Active ScratchOff: #NumberFormat(ActiveScratchOff.Total)#</p>
         <p class="column6 pull-right">InActive ScratchOff: #NumberFormat(InActiveScratchOff.Total)#</p>      
         
        </div>
      </div>
      
   </div>
   
   ');
         
      }
      return local.default;
   }
   
  
   public any function getScratchOffListLink(){
      saveContent variable="local.ListLink"{
      WriteOutput('<a href="index.cfm?task=list" style="margin-top:-150px; color:##060;">List ScratchOff</a>');
      }
      
      
   }
   
   public any function ShowScrecialWinners(){
      savecontent variable="local.Winners"{
         SQL="SELECT MSW.msw_id,MSW.mmb_id,MSW.sco_id,MSW.msw_scratched,MSW.msw_win_date,MSW.msw_redeem_date,
              SCO.sco_title, SCO.sco_type_id, MMB.FirstName, MMB.LastName, MMB.SiteID, MMS.MallName
              FROM MallScratchOffWinners MSW 
              INNER JOIN MallMerchantScratchOff SCO on sco.sco_id = msw.sco_id
              INNER JOIN MallMembers MMB on mmb.id = MSW.mmb_id
              INNER JOIN MallSites MMS on MMB.SiteID = MMS.id
              ORDER BY MMS.MallName, MSW.msw_redeem_date DESC";
             
         ListScratchOff = new Query(sql=SQL).execute().getResult();     
         
         WriteOutput('<table id="ScratchOffWinners" class="display" cellspacing="0" width="100%">
         <thead>
            <tr>
                <th></th>
                <th>Screcial</th>
                <th>Member Name</th>
                <th></th>
                <th>Mall</th>
                <th>Win Date</th>
                <th>Redeem Date</th>
                <th>&nbsp;</th>
            </tr>
        </thead>
        <tbody>');
        
        for(LS = 1; LS LTE ListScratchOff.recordcount; LS = LS + 1){
         MemberName = ListScratchOff['firstname'][LS] &' '& ListScratchOff['lastname'][LS];
         WriteOutput('<tr>
         <td></td>
         <td><a href="index.cfm?task=edit&sco_id=#listScratchOff['sco_id'][LS]#&type=#ListScratchOff['sco_type_id'][LS]#">#ListScratchOff['sco_title'][LS]#</a></td>
         <td>#memberName#</td>
         <td></td>
         <td><strong>#listScratchOff['MallName'][LS]#</strong></td>
         <td>#DateFormat(ListScratchOff['msw_win_date'][LS], "MM/DD/YYYY")#</td>
         <td>#DateFormat(ListScratchOff['msw_redeem_date'][LS], "MM/DD/YYYY")#</td>
         <td></td>
         </tr>');
         }
        
        Writeoutput('</tbody>
                     </table>');
        
         WriteOutput("<script>
                     $(document).ready(function(){
                        //Global ScratchOff Table Results:
                        var GTable = $('##ScratchOffWinners').dataTable({
                        'lengthMenu': [[10, 25, 50, 100, -1], [10, 25, 50, 100, 'All']],
                        'pageLength': 50,
                        'width': '1170px',
                        'scrollY': '375px',
                        'language': {
                           'infoEmpty': 'No ScratchOff&##8480; Winners to show',
                           'emptyTable': 'No ScratchOff&##8480; Winners to show',
                           'lengthMenu': '_MENU_ Items'
                           },
                        'columnDefs': [
                              { 'orderable': false, 'targets': 0 }
                        ]
                        });
                        
                     });
                     </script>");
      }
      return local.Winners;
      
   }
   
   
   public any function getScratchOff(){
      SQL = "SELECT sco_id,mall_id,mmr_id,mpm_id,sco_type_id,sco_title,sco_description,sco_defaultImg,sco_defaultBg,sco_descImg
      ,sco_border,sco_descDisplay,sco_buttons,sco_link_href,sco_link_text,sco_value,sco_fixed,sco_value_type,sco_holiday
      ,sco_created,sco_start,sco_end,sco_active FROM MallMerchantScratchOff where mall_id=0 order By sco_start DESC";
      ListScratchOff = new Query(sql=SQL).execute().getResult();
      
      PromoSQL = "SELECT MMS.sco_id, MMS.mmr_id, MMS.sco_start, MMS.sco_end, MMS.mpm_id, MMS.sco_active, MPM.id, MPM.text, MPM.link, MPM.startdate, MPM.enddate, MPM.headline, MPM.inactive,MPM.PROMOCODE,
                  MMR.merchant, MMR.id AS mID, MMR.link, MMR.logo FROM MallMerchantScratchOff MMS 
                  INNER JOIN MallPromos MPM on MMS.mpm_id = MPM.id
                  INNER JOIN MallMerchants MMR ON MPM.merchantid=MMR.id";
      PromoScratchOff = new Query(sql=PromoSQL).execute().getResult();
      
      saveContent variable='local.list'{
         //Returns a List of ScratchOff:
         WriteOutput('
        <ul class="tabs">
			        <li>
			          <input type="radio" checked name="tabs" id="tab1">
			          <label for="tab1">Global ScratchOff</label>
			          <div id="tab-content1" class="tab-content animated fadeIn">'& 
			           getGlobalScratchOff()
			          &'</div>
			        </li>
			        <li>
			          <input type="radio"  name="tabs" id="tab2">
			          <label for="tab2">Mall-Based ScratchOff</label>
			          <div id="tab-content2" class="tab-content animated fadeIn">'&
			            getMallBasedScratchOff()
			          &'</div>
			        </li>
			        <li>
			          <input type="radio"  name="tabs" id="tab3">
			          <label for="tab3">Product-Based ScratchOff</label>
			          <div id="tab-content3" class="tab-content animated fadeIn">'&
			            getProdScratchOff()
			          &'</div>
			        </li>
			        <li>
			          <input type="radio"  name="tabs" id="tab4">
			          <label for="tab4">Promo-Based ScratchOff</label>
			          <div id="tab-content4" class="tab-content animated fadeIn">'&
			            getPromoBasedScratchOff()
			          &'</div>
			        </li>
			        </ul>
			        
			        <a class="btn btn-success pull-right" href="index.cfm">Add Screcial</a>
			        
			        ');
         
         
         /*WriteOutput( getGlobalScratchOff());
         WriteOutput( getMallBasedScratchOff());
         WriteOutput( getPromoBasedScratchOff());*/
         
                              
         WriteOutput("<script>
                     $(document).ready(function(){
                        //Global ScratchOff Table Results:
                        var GTable = $('##ScratchOffList').dataTable({
                        'lengthMenu': [[10, 25, 50, 100, -1], [10, 25, 50, 100, 'All']],
                        'pageLength': 50,
                        'stateSave': true,
                        'width': '1170px',
                        'scrollY': '375px',
                        'language': {
                           'infoEmpty': 'No ScratchOff&##8480; to show',
                           'emptyTable': 'No ScratchOff&##8480; to show',
                           'lengthMenu': '_MENU_ Items'
                           },
                        'columnDefs': [
                              { 'orderable': false, 'targets': 0 }
                        ]
                        });
                        
                        $('##tab1').click(function()
                        {
                           GTable.fnDraw();
                        });  
                        
                        //Mall-based ScratchOff:
                        var MTable = $('##ScratchOffMallsList').dataTable({
                        'lengthMenu': [[10, 25, 50, 100, -1], [10, 25, 50, 100, 'All']],
                        'pageLength': 50,
                         'stateSave': true,
                        'width': '1170px',
                        'scrollY': '375px',
                        'language': {
                           'infoEmpty': 'No ScratchOff&##8480; to show',
                           'emptyTable': 'No ScratchOff&##8480; to show',
                           'lengthMenu': '_MENU_ Items'
                           },
                        'columnDefs': [
                              { 'orderable': false, 'targets': 0 }
                        ]
                                               
                        });
                        
                        $('##tab2').click(function()
                        {
                           MTable.fnDraw();
                        });
                        
                        //Product-based ScratchOff:
                        var PRTable = $('##ScratchOffProdsList').dataTable({
                        'lengthMenu': [[10, 25, 50, 100, -1], [10, 25, 50, 100, 'All']],
                        'pageLength': 50,
                         'stateSave': true,
                        'width': '1170px',
                        'scrollY': '375px',
                        'language': {
                           'infoEmpty': 'No ScratchOff&##8480; to show',
                           'emptyTable': 'No ScratchOff&##8480; to show',
                           'lengthMenu': '_MENU_ Items'
                           },
                        'columnDefs': [
                              { 'orderable': false, 'targets': 0 }
                        ]
                        });
                        
                        $('##tab3').click(function()
                        {
                           PRTable.fnDraw();
                        });
                        
                        //Promo-based ScratchOff:
                        var PTable = $('##ScratchOffPromosList').dataTable({
                        'lengthMenu': [[10, 25, 50, 100, -1], [10, 25, 50, 100, 'All']],
                        'pageLength': 50,
                         'stateSave': true,
                        'width': '1170px',
                        'scrollY': '375px',
                        'language': {
                           'infoEmpty': 'No ScratchOff&##8480; to show',
                           'emptyTable': 'No ScratchOff&##8480; to show',
                           'lengthMenu': '_MENU_ Items'
                           },
                        'columnDefs': [
                              { 'orderable': false, 'targets': 0 }
                        ]
                        });
                        
                        $('##tab4').click(function()
                        {
                           PTable.fnDraw();
                        });
                        
                     });
                     </script>");
      }
      return local.list;
   }
   
   public any function getGlobalScratchOff(){
   saveContent variable='local.GlobalScratchOff'{
          WriteOutput('<table id="ScratchOffList" class="display" cellspacing="0" width="100%">
         <thead>
            <tr>
                <th></th>
                <th>Title</th>
                <th>Description</th>
                <th>Image</th>
                <th>Holiday</th>
                <th style="width: 125px;">Promo based</th>
                
                <th>Starts</th>
                <th>Ends</th>
                <th>&nbsp;</th>
            </tr>
        </thead>
        <tbody>');

      for(LS = 1; LS LTE ListScratchOff.recordcount; LS = LS + 1){
         WriteOutput('<tr>
         <td><a href="index.cfm?task=edit&sco_id=#listScratchOff['sco_id'][LS]#&type=1" class="btn btn-info">Edit</a></td>
         <td>#ListScratchOff['sco_title'][LS]#</td>
         <td>#left(ListScratchOff['sco_description'][LS], 150)#...</td>');
            if(ListScratchOff['sco_descImg'][LS] EQ ""){
            WriteOutput('<td><strong>No</strong></td>');
            } else {
            WriteOutput('<td><strong>Yes</strong></td>');
            }
         
         WriteOutput('
         <td>#YesNoFormat(ListScratchOff['sco_holiday'][LS])#</td>');
         
         if (ListScratchOff['mpm_id'][LS] NEQ "0"){
         WriteOutput('<td style="width: 125px;"><strong>Yes</strong></td>');
         } else {
         WriteOutput('<td style="width: 125px;">No</td>');
         }
         
         
         
         WriteOutput('<td>#dateformat(ListScratchOff['sco_start'][LS], "MM/DD/YYYY")#</td>
         <td>#dateformat(ListScratchOff['sco_end'][LS], "MM/DD/YYYY")#</td>
         <td>
         <a href="index.cfm?task=delete&screcialID=#listScratchOff['sco_id'][LS]#" class="btn btn-danger">&times;</a>
         ');
          if (ListScratchOff['mpm_id'][LS] NEQ "0"){
               WriteOutput('<a href="admin_promos_edit.cfm?id=#PromoScratchOff['mpm_id'][LS]#" class="btn btn-primary">Edit Promo</a>');
          } 
          if(ListScratchOff['sco_active'][LS] is "1"){
            Writeoutput('<a href="index.cfm?task=deactivate&ScrecialID=#ListScratchOff['sco_id'][LS]#" class="btn btn-success">Turn Off</a>');
         } else {
            Writeoutput('<a href="index.cfm?task=activate&ScrecialID=#ListScratchOff['sco_id'][LS]#" class="btn btn-warning">Turn On</a>');
         }
               

         Writeoutput('</td></tr>');
      }
         Writeoutput('</tbody>
                     </table>');
   }
   return local.GlobalScratchOff;
   }
   
   public any function getMallBasedScratchOff(){
      SQL = "SELECT SCO.sco_id,SCO.mall_id,SCO.mmr_id,SCO.mpm_id,SCO.sco_type_id,SCO.sco_title,SCO.sco_description,SCO.sco_defaultImg,SCO.sco_defaultBg,SCO.sco_descImg
      ,SCO.sco_border,SCO.sco_descDisplay,SCO.sco_buttons,SCO.sco_link_href,SCO.sco_link_text,SCO.sco_value,SCO.sco_fixed,SCO.sco_value_type,SCO.sco_holiday
      ,SCO.sco_created,SCO.sco_start,SCO.sco_end,SCO.sco_active, MST.id, MST.company, MST.mallname
      FROM MallMerchantScratchOff SCO 
      INNER JOIN MallSites MST on MST.id = SCO.mall_id
      where SCO.Mall_id !=0 and MST.inactive IS NULL order By SCO.Mall_ID, SCO.sco_start";
      MallScratchOff = new Query(sql=SQL).execute().getResult();
      
      
      
      saveContent variable='local.MallScratchOff'{
         //Returns a List of ScratchOff:
         WriteOutput('
         <table id="ScratchOffMallsList" class="display" cellspacing="0" width="100%">
         <thead>
            <tr>
                <th> </th>
                <th>Mall</th>
                <th>Title</th>
                <th>Description</th>
                <th>Image</th>
                <th>Holiday</th>
                <th>Starts</th>
                <th>Ends</th>
                <th>&nbsp;</th>
            </tr>
        </thead>
        <tbody>');

      for(MS = 1; MS LTE MallScratchOff.recordcount; MS = MS + 1){
         WriteOutput('<tr>
         <td><a href="index.cfm?task=edit&sco_id=#MallScratchOff['sco_id'][MS]#&type=1" class="btn btn-info">Edit</a></td>
         <td>#MallScratchOff['mallname'][MS]#</td>
         <td>#MallScratchOff['sco_title'][MS]#</td>
         <td>#left(MallScratchOff['sco_description'][MS], 150)#...</td>');
            if(MallScratchOff['sco_descImg'][MS] EQ ""){
            WriteOutput('<td><strong>No</strong></td>');
            } else {
            WriteOutput('<td><strong>Yes</strong></td>');
            }
         
         WriteOutput('
         <td>#YesNoFormat(MallScratchOff['sco_holiday'][MS])#</td>
         <td>#dateformat(MallScratchOff['sco_start'][MS], "MM/DD/YYYY")#</td>
         <td>#dateformat(MallScratchOff['sco_end'][MS], "MM/DD/YYYY")#</td>
         <td><a href="index.cfm?task=edit&sco_id=#MallScratchOff['sco_id'][MS]#&type=1" class="btn btn-info">Edit</a>
         <a href="index.cfm?task=delete&screcialID=#MallScratchOff['sco_id'][MS]#" class="btn btn-danger">&times;</a>
         ');
         if(ListScratchOff['sco_active'][MS] is "1"){
            Writeoutput('<a href="index.cfm?task=deactivate&ScrecialID=#MallScratchOff['sco_id'][MS]#" class="btn btn-success">Turn Off</a>');
         } else {
            Writeoutput('<a href="index.cfm?task=activate&ScrecialID=#MallScratchOff['sco_id'][MS]#" class="btn btn-warning">Turn On</a>');
         }

         Writeoutput('</td></tr>');
      }
         Writeoutput('</tbody>
                     </table><hr>');
         
         
         
                              
         
      }
      return local.MallScratchOff;
   }
   
   public any function getProdScratchOff(){
      SQL = "SELECT sco_id,mall_id,mmr_id,mpm_id,sco_type_id,sco_title,sco_description,sco_defaultImg,sco_defaultBg,sco_descImg
      ,sco_border,sco_descDisplay,sco_buttons,sco_link_href,sco_link_text,sco_value,sco_fixed,sco_value_type,sco_holiday
      ,sco_created,sco_start,sco_end,sco_active FROM MallMerchantScratchOff where mpm_id=0 and mall_id=0 and sco_type_id=3 order By sco_start";
      ProdScratchOff = new Query(sql=SQL).execute().getResult();
      
   
   saveContent variable='local.ProductScratchOff'{
          WriteOutput('<table id="ScratchOffProdsList" class="display" cellspacing="0" width="100%">
         <thead>
            <tr>
                <th></th>
                <th>Title</th>
                <th>Description</th>
                <th>Image</th>
                <th>Holiday</th>
                <th>Starts</th>
                <th>Ends</th>
                <th>&nbsp;</th>
            </tr>
        </thead>
        <tbody>');

      for(PRS = 1; PRS LTE ProdScratchOff.recordcount; PRS = PRS + 1){
         WriteOutput('<tr>
         <td><a href="index.cfm?task=edit&sco_id=#ProdScratchOff['sco_id'][PRS]#&type=3" class="btn btn-info">Edit</a></td>
         <td>#ProdScratchOff['sco_title'][PRS]#</td>
         <td>#left(ProdScratchOff['sco_description'][PRS], 150)#...</td>');
            if(ProdScratchOff['sco_descImg'][PRS] EQ ""){
            WriteOutput('<td><strong>No</strong></td>');
            } else {
            WriteOutput('<td><strong>Yes</strong></td>');
            }
         
         WriteOutput('
         <td>#YesNoFormat(ProdScratchOff['sco_holiday'][PRS])#</td>
         <td>#dateformat(ProdScratchOff['sco_start'][PRS], "MM/DD/YYYY")#</td>
         <td>#dateformat(ProdScratchOff['sco_end'][PRS], "MM/DD/YYYY")#</td>
         <td>
         <a href="index.cfm?task=delete&screcialID=#ProdScratchOff['sco_id'][PRS]#" class="btn btn-danger">&times;</a>
         ');
         if(ProdScratchOff['sco_active'][PRS] is "1"){
            Writeoutput('<a href="index.cfm?task=deactivate&ScrecialID=#ProdScratchOff['sco_id'][PRS]#" class="btn btn-success">Turn Off</a>');
         } else {
            Writeoutput('<a href="index.cfm?task=activate&ScrecialID=#ProdScratchOff['sco_id'][PRS]#" class="btn btn-warning">Turn On</a>');
         }

         Writeoutput('</td></tr>');
      }
         Writeoutput('</tbody>
                     </table>');
   }
   return local.ProductScratchOff;
   }
   
   public any function getPromoBasedScratchOff(){
      PromoSQL = "SELECT SCO.sco_id,SCO.mall_id,SCO.mmr_id,SCO.mpm_id,SCO.sco_type_id,SCO.sco_title,SCO.sco_description,SCO.sco_defaultImg,SCO.sco_defaultBg,SCO.sco_descImg
      ,SCO.sco_border,SCO.sco_descDisplay,SCO.sco_buttons,SCO.sco_link_href,SCO.sco_link_text,SCO.sco_value,SCO.sco_fixed,SCO.sco_value_type,SCO.sco_holiday
      ,SCO.sco_created,SCO.sco_start,SCO.sco_end,SCO.sco_active, MPM.id, MPM.text, MPM.link, MPM.startdate, MPM.enddate, MPM.headline, MPM.inactive, MPM.PROMOCODE,
      MMR.merchant, MMR.id AS mID
      FROM MallMerchantScratchOff SCO
      INNER JOIN MallPromos MPM on SCO.mpm_id = MPM.id
      INNER JOIN MallMerchants MMR ON MPM.merchantid=MMR.id
      Where SCO.MPM_id !=0 ";
      PromoScratchOff = new Query(sql=PromoSQL).execute().getResult();
      
      saveContent variable="local.PromoScratchOff"{

      WriteOutput('
         <table id="ScratchOffPromosList" class="display" cellspacing="0" width="100%">
         <thead>
            <tr>
                <th></th>
                <th>Merchant</th>
                <th>Title</th>
                <th>Description</th>
                <th>Image</th>
                <th>Holiday</th>
                <th>Starts</th>
                <th>Ends</th>
                <th>&nbsp;</th>
            </tr>
        </thead>
        <tbody>');
        
        for(PS = 1; PS LTE PromoScratchOff.recordcount; PS = PS + 1){
         WriteOutput('
         <td><a href="index.cfm?task=edit&sco_id=#promoScratchOff['sco_id'][PS]#&type=2" class="btn btn-info">Edit</a></td>
         <td>#promoScratchOff['merchant'][PS]#</td>
         <td style="text-align:left;">#PromoScratchOff['sco_title'][PS]#</td>
         <td style="text-align:left;">#left(PromoScratchOff['sco_description'][PS], 300)#...</td>');
            if(promoScratchOff['sco_descImg'][PS] EQ ""){
            WriteOutput('<td><strong>No</strong></td>');
            } else {
            WriteOutput('<td><strong>Yes</strong></td>');
            }
         
         WriteOutput('
         <td>#YesNoFormat(PromoScratchOff['sco_holiday'][PS])#</td>
         <td style="text-align:left;">#DateFormat(PromoScratchOff['sco_start'][PS],"mm/dd/yyyy")#</td>
		   <td style="text-align:left;">#DateFormat(PromoScratchOff['sco_end'][PS],"mm/dd/yyyy")#</td>
		   <td>
		   <a href="index.cfm?task=delete&screcialID=#PromoScratchOff['sco_id'][PS]#" class="btn btn-danger">&times;</a>
		   <a href="admin_promos_edit.cfm?id=#PromoScratchOff['mpm_id'][PS]#" class="btn btn-primary">Edit Promo</a>
		   ');
            if(PromoScratchOff['sco_active'][PS] is "1"){
               Writeoutput('<a href="index.cfm?task=deactivate&ScrecialID=#PromoScratchOff['sco_id'][PS]#" class="btn btn-success">Turn Off</a>');
            } else {
               Writeoutput('<a href="index.cfm?task=activate&ScrecialID=#PromoScratchOff['sco_id'][PS]#" class="btn btn-warning">Turn On</a>');
            }
         Writeoutput('</td></tr>');
         }
        

      WriteOutput('</tbody></table>');
      }
      return local.PromoScratchOff;
   }
   
   public any function ShowScrecialForm(required string view, required numeric type){
      //The ScratchOff Add/Edit Form:
      variables.view = arguments.view;
      variables.type = arguments.type;
      //Malls:
      MLSQL="SELECT MST.id, MST.company, MST.mallname
            FROM MallSites MST WHERE MST.inactive IS NULL ORDER BY MallName";
      Malls = new Query(sql=MLSQL).execute().GetResult();  
   
      //Merchants:
      MRSQL="SELECT ID as mmr_id, link as LinkURL, merchant as MerchantName from MallMerchants MMR Where inactive is NULL ORDER BY Merchant";
      Merchants = new Query(sql=MRSQL).execute().getResult();
   
      //Holidays Structure:
      currentYear = Year(now());

	   Holidays = {
	      "New Year's Day" = createDate(currentYear,1,1),
	      "President's Day" = CreateDate(currentYear,2,GetNthOccOfDayInMonth(3,2,2,currentYear)),
	      "Valnetine's Day" = createDate(currentYear,2,14),
	      "St. Patrick's Day" = createDate(currentYear,3,17),
	      "Mother's Day" = CreateDate(currentYear,5,GetNthOccOfDayInMonth(2,1,5,currentYear)),
	      "Memorial Day" =  createDate(currentYear,5,(DaysInMonth(createDate(2012,5,1))) - (DayOfWeek(createDate(2012,5,DaysInMonth(createDate(2012,5,1)))) - 2)),
	      "Father's Day" = CreateDate(currentYear,6,GetNthOccOfDayInMonth(3,1,6,currentYear)),
	      "Independance Day" = createDate(currentYear,7,4),
	      "Labor Day" = createDate(currentYear,9,GetNthOccOfDayInMonth(1,2,9,currentYear)),
	      "Columbus Day" = createDate(currentYear,10,GetNthOccOfDayInMonth(2,2,10,currentYear)),
	      "Veteran's Day" = createDate(currentYear,11,11),
	      "Halloween" = createDate(currentYear,10,31),
	      "Thanksgiving" = createDate(currentYear,11,GetNthOccOfDayInMonth(4,5,11,currentYear)),
	      "Black-Friday" = createDate(currentYear,11,GetNthOccOfDayInMonth(4,6,11,currentYear)),
	      "Small Business Saturday" = createDate(currentYear,11,GetNthOccOfDayInMonth(5,7,11,currentYear)),
	      "Christmas" = createDate(currentYear,12,25),
	      "New Year's Eve" = createDate(currentYear,12,31)
	   };
	
	   sorted = structSort(Holidays, "numeric");
	
      OneMonthFromNow = DateAdd('d', 30, Now());
      EndofMonth = Dateformat(LastDayOfMonth(Dateformat(Now(), "MM"), DateFormat(Now(), "YYYY")), "YYYY-MM-DD");
      
      if(variables.view is "Edit"){
         variables.method = "UpdateScratchOff";
            //Editting a Screcial:
            SQL = "Select  mall_id,mmr_id,mpm_id,sco_type_id,sco_title,sco_description,sco_defaultImg,sco_defaultBg,sco_descImg,sco_border,sco_descDisplay,sco_buttons,sco_link_href
            ,sco_link_text,sco_value,sco_fixed,sco_value_type,sco_holiday,sco_created,sco_start,sco_end,sco_active FROM MallMerchantScratchOff where sco_id=#arguments.scoID#";
            QScrecial = new Query(sql=SQL).execute().getResult();
      
         
      } else if(variables.view is "Add"){
      variables.method = "SaveScratchOff";
      //Adding a NEW Screcial:
        if(isDefined('arguments.merchID') and arguments.MerchID NEQ ""){
         variables.merchID = arguments.merchID;
         
         MerchID = #variables.merchID#;
         QScrecial = {sco_id = '', mall_id='0', mpm_id ='0', mmr_id='#merchID#', sco_type_id='#variables.type#', sco_title='', sco_description='', sco_link_href='', sco_link_text='Click Here to Redeem'
               , sco_value='', sco_holiday='0', sco_fixed='0', sco_value_type='1', sco_defaultBG='Winner_4.png', sco_border='1', sco_default='screcial17.gif', sco_buttons='1', sco_descDisplay='1', sco_created='#DateFormat(now(), "YYYY/MM/DD HH:mm:ss")#', sco_start='#DateFormat(now(), "YYYY/MM/DD HH:mm:ss")#',
                sco_end='#DateFormat(EndofMonth, "YYYY/MM/DD HH:mm:ss")#', sco_active='1'};      
                  
         } else {
          
          MerchID = '0';  
          QScrecial = {sco_id = '',  mall_id='0', mpm_id ='0', mmr_id='0', sco_type_id='#variables.type#', sco_title='', sco_description='', sco_link_href='', sco_link_text='Click Here to Redeem'
               , sco_value='', sco_holiday='0', sco_fixed='0', sco_value_type='1', sco_defaultBG='Winner_4.png', sco_border='1', sco_default='screcial17.gif', sco_buttons='1', sco_descDisplay='1', sco_created='#DateFormat(now(), "YYYY/MM/DD HH:mm:ss")#', sco_start='#DateFormat(now(), "YYYY/MM/DD HH:mm:ss")#',
                sco_end='#DateFormat(EndofMonth, "YYYY/MM/DD HH:mm:ss")#', sco_active='1'};  
   
         }
   
      }
      saveContent variable="local.Form"{
         WriteOutput('<input type="hidden" name="Method" value="#variables.method#">
                      <input type="hidden" name="sco_type_id" value="#variables.type#">');
                      include "../admin/screcials/admin_scr_form.cfm";
                      //WriteOutput(GetCustomizeScratchOff());
                      WriteOutput(GetScratchOffPanelJS());
         WriteOutput('</form>');
      }
      
       return local.form;
   
   }
   
   public any function GetCustomizeScratchOff(){
         saveContent variable="local.panel"{
         //Writeoutput('');
     
         }
         return local.panel;
   
   }
   
   public any function GetScratchOffPanelJS(){
      savecontent variable="local.PanelJS"{
         WriteOutput('<script>
      $(function () {
      
      $("##CloseCust").on("click", function(){
         $("##CustScrec").slideUp();
         return false;
      });
         //Shows the Screcial Customization Panel:
      $("##CustomizeScrecial").on("click", function(){
         $("##CustScrec").slideDown();
         return false;
      });
      
      //ScratchOff Customizations Defaults:
         $("##PreBor, ##Buttons").val("1");');
         /*if(QScrecial.sco_type_id NEQ "3"){
            Writeoutput('$("##Display").val("0");');
         }*/
         
         if(task is "edit"){
            WriteOutput('$("##Display").val("#qscrecial.sco_descDisplay#");
            if (DisplayType == "1"){
            $("##AddIMG").fadeIn();
            $("##PreDescrIMG").fadeIn("slow").removeClass("pull-right").addClass("pull-left").css({"width":"60px", "margin-left":"-25px;"});
            $("##PreDescr").css({"font-size": "0.750em", "z-index": "10","overflow": "auto","height": "150px","border": "1px solid rgb(238, 238, 238)","width": "150px","margin-left": "-2px"});
            $("##IMGSelect").css({"margin-top": "80px", "z-index":"25", "width": "230px"});
            } else if (DisplayType == "2"){
         //Text and Image on Right:
            $("##AddIMG").fadeIn();
            $("##PreDescrIMG").fadeIn("slow").removeClass("pull-left").addClass("pull-right").css({"width":"60px", "margin-right":"-25px;"});
            $("##PreDescr").css({"font-size": "0.750em", "z-index": "10","overflow": "auto","height": "150px","border": "1px solid rgb(238, 238, 238)","width": "150px","margin-left": "-2px"});
            $("##IMGSelect").css({"margin-left":"-175px", "margin-top": "80px", "z-index":"25", "width": "230px"});
         } 
            ');
            
         } else {
            Writeoutput('$("##Display").val("0");
            $("##AddIMG").fadeOut();');
         }
         
         WriteOutput('
         $("##BGIMG").val("../sitetemplate/images/screcials/backgrounds/Winner_4.png");
      
      $("##PreBor").on("change", function(){
         var BorDisplay = $("##PreBor option:selected").val();
         if (BorDisplay == "0"){
            $("##ScrePre").css({"border": "none"});
         } else if(BorDisplay == "1"){
            $("##ScrePre").css({"border": "2px dashed ##000", "border-radius": "4px"});
         }
         
      
      });
      
      $("##BGIMG").on("change", function(){
         var BGDisplay = $("##BGIMG option:selected").val();
         
         $("##ScrePre").css({"background-image": "url("+BGDisplay+")"});
               console.log("BackGround Image Selected: "+BGDisplay);
                 
               
      });
      
      $("##Display").on("change", function(){
         var DisplayType = $("##Display option:selected").val();
         
         if(DisplayType == "0"){
         $("##AddIMG").fadeOut();
         //Text Only:
            $("##PreDescrIMG").fadeOut("slow");
            $("##PreDescr").css({"font-size": "0.750em","width":"190px", "height":"150px", "overflow":"auto","border": "1px solid rgb(238, 238, 238)", "margin-left": "auto", "margin-right": "auto"});
            
                    
         } else if (DisplayType == "1"){
         //Text and Image on Left:
            $("##AddIMG").fadeIn();
            $("##PreDescrIMG").fadeIn("slow").removeClass("pull-right").addClass("pull-left").css({"width":"60px", "margin-left":"-25px;"});
            $("##PreDescr").css({"font-size": "0.750em", "z-index": "10","overflow": "auto","height": "150px","border": "1px solid rgb(238, 238, 238)","width": "150px","margin-left": "-2px"});
            $("##IMGSelect").css({"margin-top": "80px", "z-index":"25", "width": "230px"});
            
         } else if (DisplayType == "2"){
         $("##AddIMG").fadeIn();
         //Text and Image on Right:
            $("##PreDescrIMG").fadeIn("slow").removeClass("pull-left").addClass("pull-right").css({"width":"60px", "margin-right":"-25px;"});
            $("##PreDescr").css({"font-size": "0.750em", "z-index": "10","overflow": "auto","height": "150px","border": "1px solid rgb(238, 238, 238)","width": "150px","margin-left": "-2px"});
            $("##IMGSelect").css({"margin-left":"-175px", "margin-top": "80px", "z-index":"25", "width": "230px"});
         } 
               
      });
      
      $("##Buttons").on("change", function(){
         var ButtonCol = $("##Buttons option:selected").val();
         
         if(ButtonCol == "1"){
            $("##PreLink").removeClass("btn-primary").removeClass("btn-danger").addClass("btn-success");
         } else if(ButtonCol == "2"){
            $("##PreLink").removeClass("btn-success").removeClass("btn-danger").addClass("btn-primary");
         } else if(ButtonCol == "3"){
            $("##PreLink").removeClass("btn-primary").removeClass("btn-success").addClass("btn-danger");
         }
         
      });
      
      $("##PreLink").on("click", function(){
      return false;
      });
      
      //Populates the Description in the Preview:
      $("##sco_link_text").keyup(
         function(){
         $("##PreLink").html($(this).val());
      });
         
     });
     </script>');
      }
      return local.PanelJS;
   }
   
   remote any function SaveScratchOff(){
      
      //Saves a New Screcial::
      //WriteDump(var=getSitewide_datasource(), abort=true);
      
      if(not isDefined('arguments.sco_value')){
         arguments.sco_value = '0';
         arguments.sco_fixed = '0';
         arguments.sco_value_type = '0';
      }
      
      
      if(isdefined('arguments.sco_descIMG') and #arguments.sco_descIMG# NEQ ""){
         //Upload the Screcial Description Image:
         ScrecialImage = fileUpload(expandPath(getdescriptions()),"sco_descIMG","image/jpeg,image/gif,image/png,image/jpg,image/pjpeg","makeUnique");
         //Resize the Image:
         if (gettype() IS "resize"){
            resizeImage(getwidth(), getheight(), ExpandPath(getdescriptions() & ScrecialImage.serverFile));   
         } else {
            resizeIf(width(), getheight(), ExpandPath(getdescriptions() & ScrecialImage.serverFileName & ".jpg"));
         }
         
         arguments.sco_DefaultIMG = 'Screcial17.gif';
         arguments.sco_DEfaultBG = rereplace(arguments.sco_defaultBG, '../sitetemplate/images/screcials/backgrounds/', '', 'ALL');
         arguments.sco_descImg = '#ScrecialImage.serverFile#';
         
      
      } else {
         // No Image Upload:
         arguments.sco_DefaultIMG = 'Screcial17.gif';
         arguments.sco_defaultBG = rereplace(arguments.sco_defaultBG, '../sitetemplate/images/screcials/backgrounds/', '', 'ALL');
         arguments.sco_descImg = '';
         
      }
      
      /*ScrecialSQL = "INSERT INTO MallMerchantScratchOff (mall_id,mmr_id,mpm_id,sco_type_id,sco_title,sco_description,sco_defaultImg
                     ,sco_defaultBg,sco_descImg,sco_border,sco_descDisplay,sco_buttons,sco_link_href
                     ,sco_link_text, sco_value,sco_fixed, sco_value_type, sco_holiday,sco_created,sco_start,sco_end,sco_active)
                     VALUES (#arguments.mall_id#, #arguments.mmr_id#, #arguments.mpm_id#, #arguments.sco_type_id#, '#arguments.sco_title#', '#arguments.sco_description#', '#arguments.sco_defaultImg#', 
                     '#arguments.sco_defaultBg#','#arguments.sco_descImg#', #arguments.sco_border#, #arguments.sco_descDisplay#, #arguments.sco_buttons#, '#arguments.sco_link_href#', 
                     '#arguments.sco_link_text#', #arguments.sco_value#, #arguments.sco_fixed#, #arguments.sco_value_type#, #arguments.sco_holiday#, '#Dateformat(now(), "YYYY-MM-DD")#', 
                     '#Dateformat(arguments.sco_start, "YYYY-MM-DD")#', '#Dateformat(arguments.sco_end, "YYYY-MM-DD")#', #arguments.sco_active#)";*/
         ScrecialSQL = "INSERT INTO MallMerchantScratchOff (mall_id,mmr_id,mpm_id,sco_type_id,sco_title,sco_description,sco_defaultImg
                     ,sco_defaultBg,sco_descImg,sco_border,sco_descDisplay,sco_buttons,sco_link_href
                     ,sco_link_text, sco_value,sco_fixed, sco_value_type, sco_holiday,sco_created,sco_start,sco_end,sco_active)
                     VALUES (:mall_id, :mmr_id, :mpm_id, :sco_type_id, :sco_title, :sco_description, :sco_defaultImg, 
                     :sco_defaultBg,:sco_descImg, :sco_border, :sco_descDisplay, :sco_buttons, :sco_link_href, 
                     :sco_link_text, :sco_value, :sco_fixed, :sco_value_type, :sco_holiday, :sco_created, 
                     :sco_start, :sco_end, :sco_active)";
              queryObj = new query();             
             
              
              
              //queryObj.addParam(name="scoID",value="#scoID#",cfsqltype="NUMERIC");
              queryObj.addParam(name="mall_id",value="#arguments.mall_id#",cfsqltype="NUMERIC");
              queryObj.addParam(name="mmr_id",value="#arguments.mmr_id#",cfsqltype="NUMERIC");
              queryObj.addParam(name="mpm_id",value="#arguments.mpm_id#",cfsqltype="NUMERIC");
              queryObj.addParam(name="sco_type_id",value="#arguments.sco_type_id#",cfsqltype="NUMERIC");
              queryObj.addParam(name="sco_title",value="#arguments.sco_title#",cfsqltype='cf_sql_varchar');
              queryObj.addParam(name="sco_description",value="#arguments.sco_description#",cfsqltype='cf_sql_varchar');
              queryObj.addParam(name="sco_defaultIMG",value="#arguments.sco_defaultIMG#",cfsqltype='cf_sql_varchar');
              queryObj.addParam(name="sco_defaultBG",value="#arguments.sco_defaultBG#",cfsqltype='cf_sql_varchar');
              queryObj.addParam(name="sco_descIMG",value="#arguments.sco_descIMG#",cfsqltype='cf_sql_varchar');
              queryObj.addParam(name="sco_border",value="#arguments.sco_border#",cfsqltype="BOOLEAN");
              queryObj.addParam(name="sco_descDisplay",value="#arguments.sco_descDisplay#",cfsqltype="NUMERIC");
              queryObj.addParam(name="sco_buttons",value="#arguments.sco_buttons#",cfsqltype="NUMERIC");
              queryObj.addParam(name="sco_link_href",value="#arguments.sco_link_href#",cfsqltype="cf_sql_varchar");
              queryObj.addParam(name="sco_link_text",value="#arguments.sco_link_text#",cfsqltype="cf_sql_varchar");
              queryObj.addParam(name="sco_value",value="#arguments.sco_value#",cfsqltype="Numeric");
              queryObj.addParam(name="sco_fixed",value="#arguments.sco_fixed#",cfsqltype="BOOLEAN");
              queryObj.addParam(name="sco_value_type",value="#arguments.sco_value_type#",cfsqltype="Numeric");
              queryObj.addParam(name="sco_holiday",value="#arguments.sco_holiday#",cfsqltype="BOOLEAN");
              queryObj.addParam(name="sco_created",value="#dateformat(now(), "YYYY-MM-DD")#",cfsqltype='DateTime');
              queryObj.addParam(name="sco_start",value="#dateformat(arguments.sco_start, "YYYY-MM-DD")#",cfsqltype='DateTime');
              queryObj.addParam(name="sco_end",value="#dateformat(arguments.sco_end, "YYYY-MM-DD")#",cfsqltype='DateTime');
              queryObj.addParam(name="sco_active",value="#arguments.sco_active#",cfsqltype="BOOLEAN");
                             
         AddScrecialData = queryObj.execute(sql=ScrecialSQL).getResult();
         ScrecialID = new Query(sql="Select max(sco_id) as ScrecialID from MallMerchantScratchOff").execute().getResult();  
         
         //We Locate to the List :
         //location(url='../admin/index.cfm?task=edit&sco_id=#ScrecialID.ScrecialID#&type=#arguments.sco_type_id#', addtoken='False');
         location(url="../admin/index.cfm?task=list", addtoken='False');
   }
  
   //Update a Screcial:   
   remote any function UpdateScratchOff(){
      
     
      if(not isDefined('arguments.sco_value')){
         arguments.sco_value = '0';
         arguments.sco_fixed = '0';
         arguments.sco_value_type = '0';
      }
      
            
      /*if(isdefined('arguments.sco_descIMG') and #arguments.sco_descIMG# NEQ ""){
         //Upload the Screcial Description Image:
         ScrecialImage = fileUpload(expandPath(getdescriptions()),"sco_descIMG","image/jpeg,image/gif,image/png,image/jpg,image/pjpeg","makeUnique");
         //Resize the Image:
         if (gettype() IS "resize"){
            resizeImage(getwidth(), getheight(), ExpandPath(getdescriptions() & ScrecialImage.serverFile));   
         } else {
            resizeIf(width(), getheight(), ExpandPath(getdescriptions() & ScrecialImage.serverFileName & ".jpg"));
         }
         
         arguments.sco_DefaultIMG = 'Screcial17.gif';
         arguments.sco_DEfaultBG = rereplace(arguments.sco_defaultBG, '../sitetemplate/images/screcials/backgrounds/', '', 'ALL');
         arguments.sco_descImg = '#ScrecialImage.serverFile#';
         
      
      } else {
         // No Image Upload:
         arguments.sco_DefaultIMG = 'Screcial17.gif';
         arguments.sco_defaultBG = rereplace(arguments.sco_defaultBG, '../sitetemplate/images/screcials/backgrounds/', '', 'ALL');
         
         if(isdefined('arguments.sco_descIMGOrig') and #arguments.sco_descIMGOrig# NEQ "" and sco_descDisplay NEQ "1"){
             //The Screcial Has and Image already Defined, We Are Not Assigning A New One:
            arguments.sco_descImg = '#arguments.sco_descIMGOrig#';
         } else {
            
            arguments.sco_descImg = '';
         }
         
      }*/
      if(arguments.sco_DescDisplay NEQ "0"){
         arguments.sco_DefaultIMG = 'Screcial17.gif';
         arguments.sco_DEfaultBG = rereplace(arguments.sco_defaultBG, '../sitetemplate/images/screcials/backgrounds/', '', 'ALL');
      //The Descrition has an image:
         if(isdefined('arguments.sco_descIMG') and #arguments.sco_descIMG# NEQ ""){
            ScrecialImage = fileUpload(expandPath(getdescriptions()),"sco_descIMG","image/jpeg,image/gif,image/png,image/jpg,image/pjpeg","makeUnique");
            if (gettype() IS "resize"){
               resizeImage(getwidth(), getheight(), ExpandPath(getdescriptions() & ScrecialImage.serverFile));   
            } else {
               resizeIf(width(), getheight(), ExpandPath(getdescriptions() & ScrecialImage.serverFileName & ".jpg"));
            }
            arguments.sco_descImg = '#ScrecialImage.serverFile#';
            
         }
      } else {
          arguments.sco_DefaultIMG = 'Screcial17.gif';
          arguments.sco_DEfaultBG = rereplace(arguments.sco_defaultBG, '../sitetemplate/images/screcials/backgrounds/', '', 'ALL');
      //The Description does't Have an image:
       arguments.sco_descImg = '';
      }
      
      
      
      ScrecialSQL = "Update MallMerchantScratchOff set mall_id=:mall_id, mmr_id=:mmr_id, mpm_id=:mpm_id, sco_type_id=:sco_type_id, sco_title=:sco_title, 
      sco_description=:sco_description, sco_defaultIMG=:sco_defaultImg, sco_defaultBG=:sco_defaultBg,sco_descIMG=:sco_descImg, 
      sco_border=:sco_border, sco_descDisplay=:sco_descDisplay, sco_buttons=:sco_buttons, sco_link_href=:sco_link_href, 
      sco_link_text=:sco_link_text, sco_value=:sco_value, sco_fixed=:sco_fixed, sco_value_type=:sco_value_type, 
      sco_holiday=:sco_holiday, sco_start=:sco_start, sco_end=:sco_end, 
      sco_active=:sco_active where sco_id=:sco_id";
      
      queryObj = new query();             
              
                            
              queryObj.addParam(name="sco_ID",value="#arguments.sco_ID#",cfsqltype="NUMERIC");
              queryObj.addParam(name="mall_id",value="#arguments.mall_id#",cfsqltype="NUMERIC");
              queryObj.addParam(name="mmr_id",value="#arguments.mmr_id#",cfsqltype="NUMERIC");
              queryObj.addParam(name="mpm_id",value="#arguments.mpm_id#",cfsqltype="NUMERIC");
              queryObj.addParam(name="sco_type_id",value="#arguments.sco_type_id#",cfsqltype="NUMERIC");
              queryObj.addParam(name="sco_title",value="#arguments.sco_title#",cfsqltype='cf_sql_varchar');
              queryObj.addParam(name="sco_description",value="#arguments.sco_description#",cfsqltype='cf_sql_varchar');
              queryObj.addParam(name="sco_defaultIMG",value="#arguments.sco_defaultIMG#",cfsqltype='cf_sql_varchar');
              queryObj.addParam(name="sco_defaultBG",value="#arguments.sco_defaultBG#",cfsqltype='cf_sql_varchar');
              queryObj.addParam(name="sco_descIMG",value="#arguments.sco_descIMG#",cfsqltype='cf_sql_varchar');
              queryObj.addParam(name="sco_border",value="#arguments.sco_border#",cfsqltype="BOOLEAN");
              queryObj.addParam(name="sco_descDisplay",value="#arguments.sco_descDisplay#",cfsqltype="NUMERIC");
              queryObj.addParam(name="sco_buttons",value="#arguments.sco_buttons#",cfsqltype="NUMERIC");
              queryObj.addParam(name="sco_link_href",value="#arguments.sco_link_href#",cfsqltype="cf_sql_varchar");
              queryObj.addParam(name="sco_link_text",value="#arguments.sco_link_text#",cfsqltype="cf_sql_varchar");
              queryObj.addParam(name="sco_value",value="#arguments.sco_value#",cfsqltype="Numeric");
              queryObj.addParam(name="sco_fixed",value="#arguments.sco_fixed#",cfsqltype="BOOLEAN");
              queryObj.addParam(name="sco_value_type",value="#arguments.sco_value_type#",cfsqltype="Numeric");
              queryObj.addParam(name="sco_holiday",value="#arguments.sco_holiday#",cfsqltype="BOOLEAN");
              queryObj.addParam(name="sco_created",value="#dateformat(now(), "YYYY-MM-DD")#",cfsqltype='DateTime');
              queryObj.addParam(name="sco_start",value="#dateformat(arguments.sco_start, "YYYY-MM-DD")#",cfsqltype='DateTime');
              queryObj.addParam(name="sco_end",value="#dateformat(arguments.sco_end, "YYYY-MM-DD")#",cfsqltype='DateTime');
              queryObj.addParam(name="sco_active",value="#arguments.sco_active#",cfsqltype="BOOLEAN");
      
              UpdateScrecialData = queryObj.execute(sql=ScrecialSQL).getResult(); 
      
      location(url='../admin/index.cfm?task=list', addtoken='False');
   
   
   }
   
   //Management Functions:
   public any function ClearScratchOff (){
      SQL = "Truncate Table MallScratchOffWinners";
      ClearTable = new Query(sql=SQL).execute();   
      
      location(url="index.cfm", addtoken='false');
      return this;
   }
   
   public any function ToggleScratchOff(required string ToggleType, required numeric ScrecialID){
           
      if(arguments.toggleType is "Enable"){
         SQL = "Update MallMerchantScratchOff set sco_Active=1 where sco_ID=#arguments.ScrecialID#";
         Activate = new Query(sql=SQL).execute().getResult();
         
         message = "Successfully Activated Screcial";
         
         
      } else if(arguments.toggleType is "Disable"){
         SQL = "Update MallMerchantScratchOff set sco_Active=0 where sco_ID=#arguments.ScrecialID#";
         DeActivate = new Query(sql=SQL).execute().getResult();
         
         message = "Successfully Deactivated Screcial";
        
      }
      
      location(url='index.cfm?task=list&msg=#message#', addtoken='false');
   }
   
   public any function DeleteScratchOff(required numeric ScrecialID){
      //Checks the screcial First to See if it has a Description Image:
      CSQL = "Select sco_DescIMG from MallMerchantScratchOff where sco_id=#arguments.ScrecialID#";
      CheckIMG = new Query(sql=CSQL).execute().getResult();
      
      if(CheckIMG.sco_DescIMG NEQ "" and FileExists(#expandPath(getDescriptions()&#CheckIMG.sco_DescIMG#)#)){
         FileDelete(#expandPath(getDescriptions()&#CheckIMG.sco_DescIMG#)#);
                   
      }
      
      
      SQL = "Delete from MallMerchantScratchOff where sco_ID=#arguments.ScrecialID#";
      DeleteSCO = new Query(sql=SQL).execute().getResult();
      
      message = "Screcial Successfully Deleted from the System";
      location(url='index.cfm?task=list&msg=#message#', addtoken='false');
   }
   
   
   public any function ToggleScrecialMallActive(required string ToggleType, required numeric MallID){
      WriteOutput('<style>
                   .alert {
                     padding: 15px;
                     margin-bottom: 20px;
                     border: 1px solid transparent;
                     border-radius: 4px;
                   }
                   .alert-success {
                   background-color: ##dff0d8;
                   border-color: ##d6e9c6;
                   color: ##3c763d;
                   
                   </style>
                   ');
      
      
      if(arguments.toggleType is "Enable"){
         SQL = "Update MallScrecialSettings set ScrecialActive=1 where MallID=#arguments.mallID#";
         Activate = new Query(sql=SQL).execute().getResult();
         
         WriteOutput('<p class="alert alert-success">ScratchOff For Mall #arguments.MallID# successfully Enabled</p>');
         
      } else if(arguments.toggleType is "Disable"){
         SQL = "Update MallScrecialSettings set ScrecialActive=0 where MallID=#arguments.mallID#";
         DeActivate = new Query(sql=SQL).execute().getResult();
         
         WriteOutput('<p class="alert alert-success">ScratchOff For Mall #arguments.MallID# successfully Disabled</p>');
      }
      
      return this;
   }
   //End Management Functions
   

   
   //REMOTE and AJAX FUNCTIONS:
   
   
   remote function GetScratchOffProdResults(required string scoSearch, required numeric MallID) {
      cjurl='https://product-search.api.cj.com/v2/product-search?website-id=5469563';
      
      variables.Terms = arguments.scoSearch;
      variables.MallID = arguments.MallID;
      
      q_all="'"& trim(variables.Terms)&"'";
	   q_all=Replace(q_all, "&", " ", "all"); //ampersands crash xml parse
      Qstr = {'advertiser-ids'='joined','keywords'=q_all,'serviceable-area'='US','isbn'='','upc'='','manufacturer-name'='','manufacturer-sku'='','advertiser-sku'='','low-price'='1','high-price'='','low-sale-price'='','high-sale-price'='','currency'='','sort-by'='','sort-order'='asc','page-number'=1,'records-per-page'='300'};

           
      SQL = "SELECT DISTINCT TOP(300) MMR.foreignid, MMR.id as MerchID
	          FROM MallMerchants MMR
	          INNER JOIN MallKeywords2Merchants MK2 ON MMR.id=MK2.merchantID
	          INNER JOIN MallKeywords MKW ON MK2.keywordID=MKW.id
	          WHERE MKW.keyword LIKE '%"&variables.Terms&"%'
	          AND MMR.foreignid > 0				
	          AND MMR.program = 'CJ'";
	          if(variables.MallID NEQ "0") {
                SQL = SQL & " AND MMR.id NOT IN ( SELECT merchantid FROM MallMerchantEx WHERE MALLID=" & variables.MallID & ")";
             }	else {
                SQL = SQL & " AND MMR.id NOT IN ( SELECT merchantid FROM MallMerchantEx WHERE MALLID !=0)";
             }
	          SQL= SQL & " ORDER BY MMR.foreignid";
      ProductResults = new Query(sql=SQL).execute().getResult(); 
      if(ProductResults.recordcount){ Qstr['advertiser-ids'] = ValueList(ProductResults.foreignid); }
      
      myURL=cjurl;
	   for(key in Qstr) {if(Qstr[key]!=''){myURL&='&'&KEY&'='&Qstr[key];}}
	
	   APIresults=httpGet(myURL);									//Pull data from Commission Junction
	   fullXML = xmlParse(APIresults.FileContent);			//Primary parse of XML received from CJ
      
      products=parseXML(xmlSearch(fullXML, '/cj-api/products/product'));
      
      savecontent variable="local.results"{
      WriteOutput("<h4>Your Search Results: "& numberformat(ProductResults.Recordcount) &"</h4>");
      WriteOutput('<ul style="list-style: none; text-align: left;">');
      for (key in products) {
         //get our id for this merchant
         Q2 = new Query(sql ="SELECT TOP 1 [ID] as MerchID, [logo] FROM MallMerchants WHERE [foreignid]=" & products[key]['advertiser-id']).execute().getResult();

         //swap out empty image paths with our 'no-image' icon
         img = products[key]['image-url'];
         if(img == ""){img = '../sitetemplate/images/no-image.png'; }

         //purge out html from info
			productInfo=trim(REReplaceNoCase(products[key]['description'], '<(.|\n)*?>', '', 'ALL'));
			productInfo=REReplaceNoCase(productInfo, '<', '', 'ALL');
			productInfo=REReplaceNoCase(productInfo, '>', '', 'ALL');
		   
		   /*WriteOutput('<li>
				          <div class="pull-left"><img style="max-width:100px; max-height:100px;" src="'&img&'" alt="" /></div>' & '
				          <div class="row column6"><strong>'& ReplaceAmps(products[key]['name']) &'</strong>
					       <div class="row column6">'& ReplaceAmps(productInfo) &'</div>
				          <div class="row column6 pull-right"> 
					       <div> Price: '& DollarFormat(products[key]['price']) & '</div>
					       <div> <a class="btn btn-default">Add as Screcial</a></div>
				          <div class="scroll-to-fit" style="height:60px; padding:0;">Merchant: '& ReplaceAmps(products[key]['advertiser-name'])&'</div>
				          </div>
				          </div>
				          <br style="clear:both;"/>
			             </div>');*/
			WriteOutput('<li style="margin-botton: 10px;"><div class="row">
			<div class="column3 pull-left"><img style="max-width:100px; max-height:100px;" src="'&img&'" alt="" /></div>
			<div class="column3 pull-left"><strong>'& ReplaceAmps(products[key]['name']) &'</strong>
			<br>Merchant: '& ReplaceAmps(products[key]['advertiser-name'])&'
			<br>'& ReplaceAmps(productInfo) &'</div>
			<div class="column3 pull-right">Price: '& DollarFormat(products[key]['price']) & '<br>
			<a class="btn btn-default" href="index.cfm?task=add&type=3&prodname='& urlEncodedFormat(ReplaceAmps(products[key]['name'])) &'&prodDesc='& urlEncodedFormat(ReplaceAmps(productInfo)) &'&prodIMG='&urlEncodedFormat(img)&'&merchID='& Q2.MerchID &'">Add as Screcial</a></div>
			</div>						          
			</li>');
        

      }     
      WriteOutput('</ul>');
           
      }
      return WriteOutput(local.results);
    }
   
   remote function GetScratchOffResults(required string scoSearch, required numeric type, required numeric cat) {
   //This is the AJAX Function that Returns out Search Results:
   variables.Terms = arguments.scoSearch;
   variables.type = arguments.type;
   variables.cat = arguments.cat;
   
   SQL = "SELECT MPM.id as PromoID, MPM.headline, MPM.text, MPM.startdate, MPM.enddate, MPM.inactive, MPM.merchantid, MMR.id as MerchID, MMR.merchant FROM 
          MallPromos MPM 
          INNER JOIN MallMerchants MMR on MMR.id = MPM.merchantID";
   //Search By a Partiular Area:
   if(variables.type is "0"){
   //Search both the Headline and Text of Promo
   SQL = SQL & " WHERE MPM.headline like '%#variables.Terms#%' or MPM.text Like '%#variables.Terms#%' or MMR.merchant like '%#variables.Terms#%'";   
   } else if (variables.type is "1"){
   //Search the Promo Headline
   SQL = SQL & " WHERE MPM.headline like '%#variables.Terms#%'";   
   } else if (variables.type is "2"){
    //Search the Promo Text
   SQL = SQL & " WHERE MPM.text Like '%#variables.Terms#%'";    
   } else if (variables.type is "3"){
    //Search the Merchant Name
   SQL = SQL & " WHERE MMR.merchant Like '%#variables.Terms#%'";    
   }
   //Search By a Specific Category:
   if(variables.cat NEQ "0"){
   SQL= SQL & " AND MMR.category = #cat#";   
   }
   
   SQL= SQL & " ORDER By Merchant";
   SearchResults = new Query(sql=SQL).execute().getResult();
   
   savecontent variable="local.results"{
      WriteOutput("<h4>Your Search Results: "& numberformat(SearchResults.Recordcount) &"</h4>");
      WriteOutput('<ul style="list-style: none; text-align: left;">');
      for(SR=1;SR LTE SearchResults.recordcount;SR=SR+1){
         CompSQL = "Select sco.mpm_id as SCOPID, sco.sco_id as SCOID from MallMerchantScratchOff SCO";
         ComparePromoScratchOff = new Query(sql=CompSQL).execute().getResult();
         if(SearchResults.PromoID[SR] EQ ComparePromoScratchOff.SCOPID){
            WriteOutput('<li style="background-color: ##dff0d8; border-color: ##d6e9c6;">');
         } else {
            WriteOutput('<li>');
         }
         WriteOutput('<strong>#SearchResults.merchant[SR]#</strong> :: #SearchResults.headline[SR]# <br><small>#SearchResults.text[SR]#</small><br>');
         WriteOutput('<div style="float:right; width:50%; text-align:right; ">');
         if (SearchResults.PromoID[SR] NEQ ComparePromoScratchOff.SCOPID){
      WriteOutput('<a class="btn btn-default" href="index.cfm?task=add&type=2&merchID=#SearchResults.merchId[SR]#&promoID=#SearchResults.PromoID[SR]#">Add Promo as Screcial</a>');
         }else{
      WriteOutput('<a class="btn btn-success" style="background-color:  ##006400;" href="index.cfm?task=edit&id=#ComparePromoScratchOff.SCOID#">Edit Screcial</a>');
      }
         
         WriteOutput('</div><br/><hr></li>');
      }
      WriteOutput("</ul>");
      
   }
   
   return WriteOutput(local.results);
   }
   
   remote function GetScrecialPromos(required numeric merchID ) {
       variables.MerchID = arguments.merchID;
       if (isdefined('arguments.promoID') and arguments.promoID NEQ ""){
         variables.PromoID = arguments.PromoID;
       }
       
       
      PromoSQL = "SELECT MPM.id, MPM.headline, MPM.text, MPM.link, MPM.startdate, MPM.enddate, MPM.inactive FROM 
                  MallPromos MPM WHERE MPM.merchantid=#variables.merchID#";
      ScrecialPromos = new Query(sql=PromoSQL).execute().getResult();
      savecontent variable="local.results"{

         for(SP = 1; SP LTE ScrecialPromos.recordcount; SP = SP + 1){
            
            WriteOutput('<option value="#ScrecialPromos.id[SP]#" data-title="#ScrecialPromos.Headline[SP]#" data-description="#ScrecialPromos.text[SP]#"
            data-link="#ScrecialPromos.link[SP]#" data-start="#dateformat(ScrecialPromos.startdate[SP], "MM/DD/YYYY")#" data-end="#dateformat(ScrecialPromos.enddate[SP], "MM/DD/YYYY")#"'); 
               if (isdefined('variables.PromoID')){
                  if(variables.promoID EQ ScrecialPromos.id[SP]){
                     Writeoutput('selected="selected"');
                  }
               }
            WriteOutput('>#ScrecialPromos.Headline[SP]#</option>');

         }
         
      }
   
   return WriteOutput(local.results);
   }
   
   
   
}