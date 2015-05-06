component name="ScratchOff" hint="I am the ScratchOff BackOfffice Component" persistent="true" accessors="true" output="false"{
//ScratchOff TYPES:
// 1 = StandAlone
// 2 = Promo
// 3 = Product
//This may of maynot Apply to the BackOffice:

   //Properties for Image Functions:
   property name ="imgwidth" default="60";
   property name ="imgheight" default="130";

   property name ="type" default="resize";
   property name ="descriptions" default="assets/images/screcials/descriptions/";
   property name ="scratchoffs" default="assets/images/screcials/scratchoffs/";
   property name ="backgrounds" default="assets/images/screcials/backgrounds/";
   
   
   //Global Properties:
   property name ="mallID" default="1";
   property name ="sitewide_datasource" default="DEV";
   
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

   public any function init(required numeric MallID){
      setMallID('#arguments.mallID#');
      
      
      
      
     return this; 
   }
   
   public any function getBOStyles(){
      
     savecontent variable="local.css"{
        WriteOutput('
        <style>
    .editButton {
    font-size: 14px;
    font-family: Arial;
    font-weight: normal;
    border-radius: 10px;
    border: 0px solid ##83C41A;
    padding: 2px 18px;
    text-decoration: none;
    background: -moz-linear-gradient(center top , ##79AB05 25%, ##73A605 80%) repeat scroll 0% 0% ##79AB05;
    color: ##FFF;
    text-shadow: 1px 1px 2px ##86AE47;
    box-shadow: 1px 1px 4px 0px ##193305;
    cursor: pointer;
}

   
   ##container {width: 1170px; margin-right: auto; margin-left: auto; padding-left: 15px; padding-right: 15px;}
   
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
            margin-left: 15px;
            
         }

         .pull-right {
            float: right !important;
            margin-bottom: 7px;
            margin-right: 15px;
           
  
         }
         .column9 {
         width: 66.66666666%;
         }
         
         /*Two Column*/
         .column6 {
         width: 45%;
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
         
         .btn-sm {
            padding: 5px 10px;
            font-size: 10px;
            line-height: 1.5;
            border-radius: 3px;
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
            height: 25px;
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
            width: 350px;
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
            border-top-left-radius: 20px;
            border-bottom-left-radius: 20px;
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
            border-top-left-radius: 20px;
            border-bottom-left-radius: 20px;
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
     
     return WriteOutput(local.css);
   }
   
   public any function getBODependancies(){
      savecontent variable="local.Dependancies"{
         WriteOutput('<script type="text/javascript" src="../sitetemplate/js/jquery/jquery-1.11.0.min.js"></script>
         <script type="text/javascript" src="../sitetemplate/js/bootstrap/3.0.2/bootstrap.min.js"></script>
         <script type="text/javascript" src="../sitetemplate/js/jquery/jnasybootstrap.js"></script>
         <script type="text/javascript" src="../sitetemplate/js/jquery/jquery-ui.min.js"></script>
         <script type="text/javascript" src="../sitetemplate/js/jquery/dataTables.js"></script>
         <link rel="stylesheet" media="all" type="text/css" href="../sitetemplate/style/bootstrap/3.0.2/bootstrap.min.css" />
         <link rel="stylesheet" media="all" type="text/css" href="../sitetemplate/style/jnasybootstrap.css" />
         <link rel="stylesheet" media="all" type="text/css" href="../sitetemplate/style/jquery-ui.min.css" />
         <link rel="stylesheet" media="all" type="text/css" href="../sitetemplate/style/dataTables.css">
         ');
         
      }
      
      
      return WriteOutput(local.Dependancies);
   }

   public any function getMallScratchOff(){
      
      
      MallSQL= 'Select sco_id, sco_title, sco_description, sco_DescIMG, sco_holiday, sco_start, sco_end, sco_active from MallMerchantScratchOff where mall_ID=#getMallID()#';
      MallScratchOff = new Query(sql=MallSQL).execute().getResult();
             //WriteDump(var=MallScratchOff);
            //return this;
           // abort;
            saveContent variable="local.list"{
            WriteOutput('<table id="ScratchOffList" class="display" cellspacing="0" width="100%">
         <thead>
            <tr>
                <th></th>
                <th>Title</th>
                <th>Description</th>
                <th>Image</th>
                <th>Holiday</th>
                <th>Starts</th>
                <th>Ends</th>
                <th width="125">&nbsp;</th>
            </tr>
        </thead>
        <tbody>');  
            //The Loop will go here:
            for(MS = 1; MS LTE MallScratchOff.recordcount; MS = MS + 1){
               WriteOutput('<tr>
         <td><a href="bo_screcials.cfm?task=edit&sco_id=#MallScratchOff['sco_id'][MS]#&type=1" class="btn btn-sm btn-info">Edit</a></td>
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
         <td style="text-align: right;">
         <a href="bo_screcials.cfm?task=delete&screcialID=#MallScratchOff['sco_id'][MS]#" class="btn btn-sm btn-danger">&times;</a>
         ');
         if(MallScratchOff['sco_active'][MS] is "1"){
            Writeoutput('<a href="bo_screcials.cfm?task=deactivate&ScrecialID=#MallScratchOff['sco_id'][MS]#" class="btn btn-sm btn-success">Turn Off</a>');
         } else {
            Writeoutput('<a href="bo_screcials.cfm?task=activate&ScrecialID=#MallScratchOff['sco_id'][MS]#" class="btn btn-sm btn-warning">Turn On</a>');
         }

         Writeoutput('</td></tr>');
            }
            //End Loop:
            WriteOutput('</tbody>
            </table>');               
         }
        
        return WriteOutput(local.list); 
   }
   
   public any function ShowScrecialForm(required string view)
   {
      //The ScratchOff Add/Edit Form:
      variables.view = arguments.view;
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
      //End Holdiday & Date Stuff:
      
      if(variables.view is "Edit") {
         variables.method = "UpdateScratchOff";
         //Editting a Screcial:
         SQL = "Select  mall_id,mmr_id,mpm_id,sco_type_id,sco_title,sco_description,sco_defaultImg,sco_defaultBg,sco_descImg,sco_border,sco_descDisplay,sco_buttons,sco_link_href
            ,sco_link_text,sco_value,sco_fixed,sco_value_type,sco_holiday,sco_created,sco_start,sco_end,sco_active FROM MallMerchantScratchOff where sco_id=#arguments.scoID#";

         QScrecial = new Query(sql = SQL, datasource = getsitewide_datasource()).execute().getResult();
      } else if(variables.view is "Add") {
         variables.method = "SaveScratchOff";
         QScrecial = {sco_id = '',  mall_id='#getMallID()#', mpm_id ='0', mmr_id='0', sco_type_id='#variables.type#', sco_title='', sco_description='', sco_link_href='', sco_link_text='Click Here to Redeem'
               , sco_value='', sco_holiday='0', sco_fixed='0', sco_value_type='1', sco_border='1', sco_descDisplay='1', sco_buttons='1', sco_created='#DateFormat(now(), "YYYY/MM/DD HH:mm:ss")#', sco_start='#DateFormat(now(), "YYYY/MM/DD HH:mm:ss")#',
                sco_end='#DateFormat(EndofMonth, "YYYY/MM/DD HH:mm:ss")#', sco_active='1'};
      }
      
      saveContent variable="local.Form"{
         WriteOutput('<input type="hidden" name="Method" value="#variables.method#">
                      <input type="hidden" name="sco_type_id" value="#variables.type#">');
                      
                      include "../BackOffice/screcials/bo_scr_form.cfm";
                      
                      
         WriteOutput('</form>');
      }
      
       return local.form;
       
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
         $("##PreBor, ##Buttons").val("1");
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
         //Text Only:
            $("##PreDescrIMG").fadeOut("slow");
            $("##PreDescr").css({"font-size": "0.750em","width":"190px", "height":"150px", "overflow":"auto","border": "1px solid rgb(238, 238, 238)", "margin-left": "auto", "margin-right": "auto"});
            $("##PreLink").css({"font-size": "0.688em", "z-index": "10", "position": "relative", "max-width": "215px","bottom": "-15px"});
            
                    
         } else if (DisplayType == "1"){
         //Text and Image on Left:
            $("##PreDescrIMG").fadeIn("slow").removeClass("pull-right").addClass("pull-left").css({"width":"60px", "margin-left":"-25px;"});
            $("##PreDescr").css({"font-size": "0.750em", "z-index": "10","overflow": "auto","height": "150px","border": "1px solid rgb(238, 238, 238)","width": "150px","margin-left": "-2px"});
            $("##PreLink").css({"font-size": "0.750em", "font-size": "0.688em", "z-index": "10", "position": "relative", "max-width": "215px","bottom": "90px"});
            $("##IMGSelect").css({"margin-top": "80px", "z-index":"25", "width": "230px"});
            
         } else if (DisplayType == "2"){
         //Text and Image on Right:
            $("##PreDescrIMG").fadeIn("slow").removeClass("pull-left").addClass("pull-right").css({"width":"60px", "margin-right":"-25px;"});
            $("##PreDescr").css({"font-size": "0.750em", "z-index": "10","overflow": "auto","height": "150px","border": "1px solid rgb(238, 238, 238)","width": "150px","margin-left": "-2px"});
            $("##PreLink").css({"font-size": "0.688em", "z-index": "10", "position": "relative", "max-width": "215px","bottom": "90px"});
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
      
      location(url='bo_screcials.cfm?msg=#message#', addtoken='false');
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
      
      message = "Screcial Successfully Deleted from your Mall";
      location(url='bo_screcials.cfm?msg=#message#', addtoken='false');
   }
   
   remote any function SaveScratchOff(){
      //Saves a New Screcial::
     
      
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
      
      
         ScrecialSQL = "INSERT INTO MallMerchantScratchOff (mall_id,mmr_id,mpm_id,sco_type_id,sco_title,sco_description,sco_defaultImg
                     ,sco_defaultBg,sco_descImg,sco_border,sco_descDisplay,sco_buttons,sco_link_href
                     ,sco_link_text, sco_value,sco_fixed, sco_value_type, sco_holiday,sco_created,sco_start,sco_end,sco_active)
                     VALUES (:mall_id, :mmr_id, :mpm_id, :sco_type_id, :sco_title, :sco_description, :sco_defaultImg, 
                     :sco_defaultBg,:sco_descImg, :sco_border, :sco_descDisplay, :sco_buttons, :sco_link_href, 
                     :sco_link_text, :sco_value, :sco_fixed, :sco_value_type, :sco_holiday, :sco_created, 
                     :sco_start, :sco_end, :sco_active)";
              queryObj = new query();             
              queryObj.setDatasource(getsitewide_datasource());
              
              
              //queryObj.addParam(name="scoID",value="#scoID#",cfsqltype="NUMERIC");
              queryObj.addParam(name="mall_id",value="#arguments.mall_id#",cfsqltype="NUMERIC");
              queryObj.addParam(name="mmr_id",value="0",cfsqltype="NUMERIC");
              queryObj.addParam(name="mpm_id",value="0",cfsqltype="NUMERIC");
              queryObj.addParam(name="sco_type_id",value="1",cfsqltype="NUMERIC");
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
         message = "Screcial Successfully Added to your Mall";
         location(url="../backoffice/bo_screcials.cfm?msg=#message#", addtoken='False');
   }
   
   remote any function UpdateScratchOff(){
   
   
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
         
         if(isdefined('arguments.sco_descIMGOrig') and #arguments.sco_descIMGOrig# NEQ ""){
             //The Screcial Has and Image already Defined, We Are Not Assigning A New One:
            arguments.sco_descImg = '#arguments.sco_descIMGOrig#';
         } else {
            arguments.sco_descImg = '';
         }
         
      }
      
      
      
      ScrecialSQL = "Update MallMerchantScratchOff set mall_id=:mall_id, mmr_id=:mmr_id, mpm_id=:mpm_id, sco_type_id=:sco_type_id, sco_title=:sco_title, 
      sco_description=:sco_description, sco_defaultIMG=:sco_defaultImg, sco_defaultBG=:sco_defaultBg,sco_descIMG=:sco_descImg, 
      sco_border=:sco_border, sco_descDisplay=:sco_descDisplay, sco_buttons=:sco_buttons, sco_link_href=:sco_link_href, 
      sco_link_text=:sco_link_text, sco_value=:sco_value, sco_fixed=:sco_fixed, sco_value_type=:sco_value_type, 
      sco_holiday=:sco_holiday, sco_start=:sco_start, sco_end=:sco_end, 
      sco_active=:sco_active where sco_id=:sco_id";
      
      queryObj = new query();             
              queryObj.setDatasource(getsitewide_datasource());
                            
              queryObj.addParam(name="sco_ID",value="#arguments.sco_ID#",cfsqltype="NUMERIC");
              queryObj.addParam(name="mall_id",value="#arguments.mall_id#",cfsqltype="NUMERIC");
              queryObj.addParam(name="mmr_id",value="0",cfsqltype="NUMERIC");
              queryObj.addParam(name="mpm_id",value="0",cfsqltype="NUMERIC");
              queryObj.addParam(name="sco_type_id",value="1",cfsqltype="NUMERIC");
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
      
         
      
         message = "Screcial Successfully Updated";
         location(url="../backoffice/bo_screcials.cfm?msg=#message#", addtoken='False');
   
   
   }
   
   
}