component name="ScratchOff" hint="I am the ScratchOff Component" persistent="true" accessors="true" output="false"{
    //We Set Some Default Properties so we can use Getters and Setters for Global Variables!
    //Welcome to Object Oriented Development!
   property name="Sitewide_Datasource" default="DEV";
   property name="currentbuild" default="2.0.3.1";
   property name="moduleAuthor" default="J Harvey";
   property name="moduleAuthorEmail" default="jchharvey@webdevsourcerer.com";
  
   property name="ScrecialID" default = '0' ; //will later be set from sco_id
   property name="MemberID" default = '0' ; //will later be set from session var
   property name="MallID" default='1' ; //will later be set from session var
   property name="PromoID" default='0' ; //will later be set from mpm_id 
   property name="TypeID" default="0" ; //will later be set from sco_type_id
   property name="MerchID" default="0" ; 
   
   //Display Properties:
   property name="width" default="230" ;
   property name="height" default="230" ;
   property name="coin" default = 'assets/images/screcials/cursor_coin.png';
   property name="radius" default = '50' ;
   property name="showFireWorks" default='0';
   property name="ShowBorder" default="0"; //Will later be set from sco_border
   property name="Buttons" default="1"; //will later be set from sco_buttons, however default is '1'(Green)
   property name="ScrecialGIF" default="0";
   property name="descriptionDisplay" default="1"; //Will be defined by sco_descDisplay;
   
   //The Value & Links Properties:
   property name="Title" default="Screcial&##8480; Redeemed";
   property name="Description" default="You've redeemed your Daily Screcial&##8480;.<br>Come back Tomorrow to Redeem another one!";
   property name="LinkText" default="Click Here to Redeem" type="string";
   property name="LinkHREF" default="" type="string";
   property name="ProgramURL" default=""; //Will be defined if a PromoID
   property name="AffiliateProgram" default=""; //Will be defined if a PromoID
   property name="ScrecialRedemption" default="http://www.loyaltysuperstore.com/com/ScratchOff.cfc?method=RedeemWinner"; //This is for an Ajax Call; All Malls, Regardless of accessed from
                                                                                                                        //Sub Folder or Custom Domain - It has been tested and Works;
   property name="ClickJump" default="click_jump.cfm";
   property name="Scratched" default="0";
   
   //Images Properties:
   property name="backgrounds" default="assets/images/screcials/backgrounds/"; //The Path to the Backgrounds Folder:
   property name="background" default="Winner_4.png"; //Will Later be defined by SCO_defaultBG
   property name="scratchoffs" default="assets/images/screcials/scratchoffs/"; //the Path to the ScratchOff Images
   property name="scratchoff" default="screcial18.gif"; //Current Set as Default;
   property name="descriptions" default="assets/images/screcials/descriptions/"; //The Path to the Description Images Folder
   property name="descIMG" default=""; //Will be defined by a Query Result;
   //Date Properties:   
   property name="startofMonth" default=""; //Defined by a Custom Function
   property name="endofMonth" default=""; //Defined by a Custom Function
   property name="ScrecialStart" default=""; //Will be defined by a Query Result
   property name="ScrecialEnd" default=""; //Will be Defined by a Query Result
   property name="Holiday" default="0"; //is this a Holiday Screcial?
   
   
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
    //End Patches for CF9
   
   public string function getWebPath(){
      arguments.url = "#getPageContext().getRequest().getRequestURI()#";
      arguments.ext = "\.(cfml?.*|html?.*|[^.]+)";
      
      var sPath = trim(arguments.url);
      var sEndDir = reFind("/[^/]+#arguments.ext#$", sPath);
      return left(sPath, sEndDir);
   }
   
      
   //Get Holidays Functions:  
   //Holiday Functions have been moved into the INIT Function:   
   
   
   //SpecialFunction for Getting the Affiliate URL: (This will be updated to a DataBase Query in the Near Future:
   Affilate_URL_parameters={URL='', CJ='?sid=',SAS='&afftrack=', LS='&u1=', FO='&fobs=', AF='', EB='?sid=', WG=''};
     
   //End Special Functions
     
   function getBuildInformation(){
     //Returns the Build Information for the Module:    
     WriteOutput("Screcial&##8480; Module version: <strong>" & getcurrentbuild()&" </strong><br>
                  Screcial&##8480; Module Author: " & getModuleAuthor() &"<br> 
     ");
     
     Writeoutput("<h4>Information on Current Build: #getcurrentbuild()# Update: #dateformat(now(), "MM/DD/YYYY")#</h4>
                  <ul>
                  <li>Applied UI Update from #getModuleEditor()#</li>
                  <li>Fixed ScratchOffs not registering with Malls other than Loyalty SuperStore (#getmoduleauthor()#) via Ajax Call<br>
                      Property for Ajax Call has been set in Component Properties.
                  </li>
                  <li>Updated Administration:
                     <ul>
                     <li>Applied fix for removing Image from Screcial</li>
                     <li>Added Function to Add Image to Pre-Exisiting Screcial</li>
                     <li>Added MallName to ScratchOff Winners Listings</li>
                     <li>Added 'Add Screcial' to ScratchOff List Page</li>
                     </ul>
                  </li>
                  </ul>");
                  
                  
                  
                  
                  
                  
                  
                  
     WriteOutput("<h4>Build 2.0.3 Updates:</h4>
                  <ul>
                  <li>Re-instituted Front-End Randomization of ScratchOff</li>
                  <li>BackOffice Functionality added (<em>com/BOScratchOff.cfc</em>)</li>
                  <li>Rebuilt ScratchOff Front-End so that if ScratchOff Init has no Results, It does not show a place-holder Image</li>
                  <li>Added Floating div to Place Holder, stating 'Please Login to Redeem Screcial'</li>
                  <li>Removed all instances of getsitewide_datasource() in Query Functions</li>
                  <li>Streamlined Code - less code - more powerful</li>
                  <li>Fixed Broken Redemption Logic. Now if a Screcial is Scratched off or Redeemed the Redemption Method Fires</li>
                  </ul>");
            
            
     WriteOutput("<h4>Build 2.0.2 Updates:
     <ul>
            <li>Created ScratchOff PlaceHolder if Mall is set up for ScratchOff and Memeber is not Logged in.</li>
            <li>Placed PlaceHolder Code into /com/ScratchOff.cfc</li>
            <li>Added <em>sitewide_datasource</em> Property to both the <em>AdminScratchOff.cfc & ScratchOff.cfc</em> to be backwards-compatible
                with current Variables in Legacy Application Structs
            </li>
            
            </ul>
     ");
     
     
     WriteOutput("<h4>Build 2.0.1 Updates:</h4> 
     <ul>
     <li>Holiday Screcial&##8480; Determinations
                     <ul>
                     <li>ScratchOff Customization (Administration)<br>
                        <ul>
                        <li>Changing the Screcial Background Image<li>
                        <li>Enabling/Disabling the Screcial Border</li>
                        <li>Changing the Layout of the Screcial Description</li>
                        </ul>
                     </li>
                     <li>Current Holiday Functions in Place:</li>
                     <li>New Year's Day</li>
                     <li>Valnetine's Day</li>
                     <li>St. Patrick's Day</li>
                     <li>President's Day</li>
                     <li>Mother's Day </li>
                    <li>Memorial Day </li>
                    <li>Father's Day </li>
                    <li>Independance Day </li>
                    <li>Labor Day </li>
                    <li>Columbus Day </li>
                    <li>Halloween </li>
                    <li>Veteran's Day </li>
                    <li>Thanksgiving </li>
                    <li>Black-Friday </li>
                    <li>Small Business Saturday </li>
                    <li>Christmas </li>
                    <li>New Year's Eve </li>
                     </ul>
               </li>
               <li>Products Search to Create ScratchOff From (Updated: 05-28-2014)</li>
               <li>Componentized the ScratchOff&##8480; Administration Module into a ColdFusion CFC</li>
               <li><em>Screcial Types:</em> <br>
               <ul>
               <li>Type 1 = StandAlone</li>
               <li>Type 2 = Promo-Based</li>
               <li>Type 3 = Product-Based</li>
               </ul></li>
               <li><em>Slated for 2.0.2</em> (Updated: 05-28-2014)<br>
               <ul>
               <li>ScratchOff &##8480; Points Systems</li>
               
               </ul>
            <li><em>Back-Office:</em> -PENDING-</li>
               </ul>");
         
         
     WriteOutput("<h4>Build 2.0.0 Updates:</h4>
        <ul>
            <li>Componentized the ScratchOff&##8480; Module into a ColdFusion CFC</li>
            <li>Update Certain Deficiencies discovered in old Code-base and fixed them</li>
            <li>Updated ScratchOff&##8480; Display Query to resolve ""Daily Screcial&##8480; Display""</li>
            <li>Updated ScratchOff&##8480; Display to also Check Configuration based upon a passed MallID</li>
            <li>Integrated and Consolidated the Scratchoff Redemption Methods into CFC Component<br>
                (The Create versus Update Methods after the user has Scratched)</li>
            <li>Miscellaneous Tweaks, Creaks and Fixes</li>
            <li>Built-In function to clear ScratchOff&##8480; (add ?ClearScratchOff) to the URL</li>
            <li>Built-in function to reinitialize the ScratchOff&##8480; (add ?reinit=true) to the URL</li>
            <li>Built Database Table <em><strong>MallScrecialSettings</strong></em> to define whether ScratchOff&##8480; are enabled for a particular MallID<br>
                 (If Passed MallID is '0' - it is Considered a 'Global' Screcial&##8480;)</li>
            <li>Built Function that if Number of ScratchOff is Returned is '0' for a Given Mall, if will then check for 'Global ScratchOff&##8480;' and display them </li>
            <li>New Build and information Display System (add ?info) to the URL [THIS FUNCTION]</li>
            <li>Updated: 05-28-2014 <strong>Administration Updates:</strong>
            <ul>
            <li>Assign Background Image to Screcial&##8480; </li>
            <li>Assign ScratchOff Image to Screcial&##8480; </li>
            <li>Built Function to Enable / Disable ScratchOff&##8480; on a per-mall Basis</li>
            </ul>
            </li>
            
           
         </ul>
         <hr>
     "); 
     WriteOutput("<h4>Build 1.3.1.6 Updates:</h4>
         <ul>
            <li>Support for Animated GIF</li>
            <li>The Animated GIF is loaded on top of the Screcial<li>
            <li>If the Screcial isn't clicked he animation resumes</li>
            <li>If the Screcial is Clicked the animation is removed</li>
            <li>Added Support for Displaying / Hiding The Screcial ""Cutline"" Border</li>
            <li>Updated Screcial</li>
         </ul>
         <hr>
     ");
     WriteOutput("<h4>Build 1.3.1.5 Updates:</h4>
         <ul>
            <li>Revised Query for ScratchOff Fetching using Embedded Select Statement</li>
            <li>Updated the FrontEnd to Check for an Exisiting Screcial ID so that the Screcial doesn't reappear (for 
      multiple ScratchOff within a Given Time Frame)<li>
            
         </ul>
         <hr>
     ");
     WriteOutput("<h4>Build 1.3.1.4 Updates:</h4>
         <ul>
            <li>Miscellaneous and Various Bug fixes</li>
            <li>Fireworks Animation via jQuery<li>
            <li>Clicking the redeem Link (ID: redemption) now toggles the content Dynamically</li>
            <li>Added Background for Post-Scratch Functions</li>
            <li>Added Support for Displaying / Hiding The Screcial ""Cutline"" Border</li>
            <li>Added ""auto"" attribute to cursor CSS rendering</li>
            <li>Updated Text Output Div to use AutoScrolling</li>
         </ul>
         <hr>
     ");
     WriteOutput("<h4>Build 1.3.1.3 Updates:</h4>
         <ul>
            <li>Updates and fixes to Code Base</li>
            <li>Fixed Cross-Browser Issues<li>
            
         </ul>
         <hr>
     ");
     WriteOutput("<h4>Build 1.3.1.2 Updates:</h4>
         <ul>
            <li>Updated Query to Grab Daily Screcial</li>
            <li>Parameterized the Neccessary Fields and Variables for the ScratchOff<li>
            
         </ul>
         <hr>
     ");
     WriteOutput("<h4>Build 1.3.1.1 Updates:</h4>
         <ul>
            <li>Initial Build</li>
                      
         </ul>
         <hr>
     ");
     

     
   } 
      
    
   //ScratchOff Initialization:
   public function init(required numeric MallID, required numeric MemberID){
      arguments.scratched = '0';
      arguments.screcialID ='0';
      setMallID(arguments.mallID);
      setMemberID(arguments.memberID);
      
     
      /*if(isdefined(arguments.Scratched) and arguments.scratched GT "0"){
         //This is the already Redeemed Function:
         setScratched('1');
         setScrecialID(arguments.screcialID);
         
         SQL = "Select * from MallMerchantScratchOff where sco_id=#getScrecialID()#";
         Redemption = new Query(sql=SQL).execute().getResult();
         
         //
                               
                               
                               
                               
                               
                                 
      }*/
      
      today = now();
      
      setStartofMonth('#dateformat(CreateDate(DatePart("yyyy", now()), DatePart("m", Now()), 1), "YYYY-MM-DD")#');
      setEndofMonth('#Dateformat(LastDayOfMonth(Dateformat(Now(), "MM"), DateFormat(Now(), "YYYY")), "YYYY-MM-DD")#');
             
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
	   OneMonthFromNow = #DateAdd('d', 30, Now())#;
	   
	      //Checking to see if Today is a Holiday, We have to Loop through the Holiday Dates:
         for(name in sorted){
            holidate = dateformat(holidays[name], "MM/DD/YYYY");
            //WriteOutput('#name# - #holidate#<br>');
            if(dateformat(now(), "MM/DD/YYYY") EQ #holidate#){
               setholiday('1');
            } 
         }
         
         if(getHoliday() is "0") {
            //Not a Holiday Screcial            
            SQL = "SELECT TOP(1) sco_id, mpm_id, mmr_id, sco_start ,sco_end ,sco_active FROM MallMerchantScratchOff where sco_active=1 and (mall_id=#getMallID()#) AND 
            sco_start <= '#dateformat(today, "YYYY-MM-DD")#' and sco_end >= '#dateformat(today, "YYYY-MM-DD")#' ORDER BY NEWID()";

         } else if(getHoliday() is "1"){
            //Yay - Holiday Screcial
            SQL = "SELECT TOP(1) sco_id, mpm_id, mmr_id, sco_start ,sco_end ,sco_active FROM MallMerchantScratchOff where sco_holiday=1 and sco_active=1 and (mall_id=#getMallID()#) AND 
            sco_start <= '#dateformat(today, "YYYY-MM-DD")#' and sco_end >= '#dateformat(today, "YYYY-MM-DD")#' ORDER BY NEWID()";
         }
         //Grabs ScratchOff for a Mall:
          SQL = "SELECT TOP(1) sco_id, mpm_id, mmr_id, sco_start ,sco_end ,sco_active FROM MallMerchantScratchOff where sco_active=1 and (mall_id=#getMallID()#) AND 
            sco_start <= '#dateformat(today, "YYYY-MM-DD")#' and sco_end >= '#dateformat(today, "YYYY-MM-DD")#' ORDER BY NEWID()";
         ScrecialInit = new Query(sql=SQL).execute().getResult();
         
         if(ScrecialInit.RecordCount EQ "0") {
            //We Don't Have a Screcial for this Mall so we grab some global ones:
            GlobalSQL = "SELECT TOP(1) sco_id, mpm_id, mmr_id, sco_start ,sco_end ,sco_active FROM MallMerchantScratchOff where sco_active=1 and (mall_id=0) AND 
            sco_start <= '#dateformat(today, "YYYY-MM-DD")#' and sco_end >= '#dateformat(today, "YYYY-MM-DD")#' ORDER BY NEWID()";

            ScrecialInitGlobal = new Query(sql = GlobalSQL).execute().getResult();
         }
         
         if(ScrecialInit.RecordCount is "0" AND ScrecialInitGlobal.RecordCount is "0"){
            //We've changed the Logic Before the ScratchOff are Grabbed and Defined to See if any are Available:
            //If not - We display Nothing
         } else {
            //Now We Check to See if the Member is Logged in:
            if(getMemberID() GT "0"){
               //There is a Member going on:
                                            
               //We Grab a Screcial for the Individual Mall:
               if(ScrecialInit.RecordCount EQ "1") {
                  setScrecialID(ScrecialInit.sco_ID);
                  setPromoID(ScrecialInit.mpm_id);
                  setMerchID(ScrecialInit.mmr_id);
                  //We will then Get the ScratchOff CSS:
                  WriteOutput(GetScrecialCSS());

                  //We include the Screcial Plugin:
                  WriteOutput(GetScrecialDependancies());

                  //We need to check if this has been redeemed:
                  //We Check to See if the Member has Redeemed Previously:
                  SQL = "Select mmb_id, sco_id, msw_win_date from MallScratchOffWinners where mmb_id=#getMemberID()# and msw_win_date='#dateformat(now(), "YYYY-MM-DD")#'";
                  GetRedeemed = new Query(sql = SQL).execute().getResult();

                  if (GetRedeemed.recordcount GT "0") {
                     //We will then Get the ScratchOff CSS:
                        WriteOutput(GetScrecialCSS());
                     //We include the Screcial Plugin:
                        WriteOutput(GetScrecialDependancies());
         
                     getscrecialredeemed();
                      
                      
                  } else {
                  //We will Render the Screcial:
                  GetScrecial(ScrecialID = getScrecialID(), MemberID = getMemberID());
                  }
               } else{ 
               
                     if(ScrecialInitGlobal.RecordCount EQ "1") {
                        setScrecialID(ScrecialInitGlobal.sco_ID);
                        setPromoID(ScrecialInitGlobal.mpm_id);
                        setMerchID(ScrecialInitGlobal.mmr_id);

                        //We will then Get the ScratchOff CSS:
                        WriteOutput(GetScrecialCSS());

                        //We include the Screcial Plugin:
                        WriteOutput(GetScrecialDependancies());

                        //We need to check if this has been redeemed:
                  //We Check to See if the Member has Redeemed Previously:
                  SQL = "Select mmb_id, sco_id, msw_win_date, msw_redeem_date from MallScratchOffWinners where mmb_id=#getMemberID()# and (msw_win_date='#dateformat(now(), "YYYY-MM-DD")#' or msw_redeem_date='#dateformat(now(), "YYYY-MM-DD")#')";
                  GetRedeemed = new Query(sql = SQL).execute().getResult();

                  if (GetRedeemed.recordcount GT "0") {
                     //We will then Get the ScratchOff CSS:
                        WriteOutput(GetScrecialCSS());
                     //We include the Screcial Plugin:
                        WriteOutput(GetScrecialDependancies());
         
                        GetScrecialRedeemed();
                      
                      
                  } else {
                  //We will Render the Screcial:
                  GetScrecial(ScrecialID = getScrecialID(), MemberID = getMemberID());
                  }
                     } else {
                        //No SCRECIALS AVAILABLE ANYWHERE: We Haven't DETERMINED WHAT WE're GOING TO TO YET, IF ANYTHING
                           
                     }
                  
               }
               
            } else {
               //There isn't a Member Logged on, show the PlaceHolder:
               GetScrecialHolder();
            }
            
            
            
         }
                  
           
         
	      return this;
   }
   
     
   public any function GetScrecialCSS (){
      savecontent variable="local.css"{
      writeOutput("<!---The ScratchOff StyleSheet--->
      <style>
         


         ##Scratchbox-Fixed{ postion:relative; overflow: hidden; 
          ");
         if (getshowborder() is '1') {
            WriteOutput("border:dashed black 2px;border-radius: 4px;");
         }
         WriteOutput("
         }
         
         ##Scratchbox-Fixed {
         width:#getWidth()#px; height:#getHeight()#px;text-align: center;

         }

         ##scrDescription {position:absolute; display:none; overflow:scroll; width:230px; overflow-x: hidden; overflow-y: auto;}
         
         ##jScratchOff div {
         /*cursor: url(#getCoin()#),auto;*/
         }

         ##jScratchOff canvas{
         position: relative;
         cursor: url(#getCoin()#),auto;
         }
         
         
         

         ##scText{
         padding: 0 12px 0 12px 0;
         font-size: 0.750em;
         text-align:left;
         }

         ##scRedeem {
         z-index: 25;
         width:#getWidth()#px;
         position: absolute;
         text-align:center;
         bottom:25px;
         }
         
         ##redeemValid {
         z-index: 25;
         width:#getWidth()#px;
         position: absolute;
         text-align:center;
         bottom:5px;
         font-weight:bold;
         color: ##8c0000;
         font-size: 1.5em;
         }



         .rdmd {
         position: relative;
         color: ##8c0000;
         font-size: 1.5em;
         width: 190px;
         padding-left: 12px;
         padding-right: 12px;
         margin-right: 5px;
         margin-left: 5px;
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
         line-height: 1.42857143;
         border-radius: 4px;
         -webkit-user-select: none;
         -moz-user-select: none;
         -ms-user-select: none;
         user-select: none;
         font-size: 0.688em; 
         z-index:10; 
         position: relative; 
         bottom: -15px; 
         max-width: 215px;
         }
         /*Green Button*/
         .btn-success {
         color: ##fff;
         background-color: ##5cb85c;
         border-color: ##4cae4c;
         }
         /*Blue Button*/
         .btn-primary {
         color: ##fff;
         background-color: ##428bca;
         border-color: ##357ebd;
         }
         /*Red Button*/
         .btn-danger {
         color: ##fff;
         background-color: ##d9534f;
         border-color: ##d43f3a;
         }
         
         ##ScrecialHldr{
            width:#getWidth()#px; 
            height:#getHeight()#px;
            cursor: url(#getCoin()#),auto;
         }
         
         ##ScrecialLogin{
            z-index: 100; 
            position:relative; 
            bottom: 118px; 
            max-width: #getWidth()#px;
            background: rgba(0, 0, 0, .5);
            font-weight: bold; 
            color: ##fff;
            text-shadow: 0px 2px 3px ##555; 
            font-size:1.250em; 
            text-align: center;
         }
         
         ##ScratchOffRDMD{
            z-index: 100; 
            position:relative; 
            top: 85px;
            left: -20px; 
            width: 280px;
            background: rgba(0, 0, 0, .5);
            font-weight: bold; 
            color: ##fff;
            text-shadow: 0px 2px 3px ##555; 
            font-size:1.250em; 
            text-align: center;
            -moz-transform:rotate(-40deg);
            -webkit-transform:rotate(-40deg);
            -o-transform:rotate(-40deg);
            -ms-transform:rotate(-40deg);
            transform:rotate(-40deg);
         }
         </style>");
   
      }
      return local.css;
   }
   
   public any function GetScrecialHolder(){
      savecontent variable="local.Holder"{
         //We Get the ScratchOff CSS:
         WriteOutput(GetScrecialCSS());
         //We Right Out the Screcial PlaceHolder:
         WriteOutput('<div id="ScrecialHldr">
                     <img src="#Getscratchoffs()##getScratchoff()#">
                     <div id="ScrecialLogin">
                        Login to Redeem Today''s Screcial&##8480;
                     </div>
                     </div>');
                  
         WriteOutput("<script>
                  $('##ScrecialHldr').on('click', function(){
                     $('##login-box').dialog('open');
                  });
                  </script>
                  ");

      }
      return WriteOutput(local.holder);
      
   }
   
   public any function GetScrecialRedeemed(){
      savecontent variable="local.Redeemed"{
         //We Get the ScratchOff CSS:
         WriteOutput(GetScrecialCSS());
         //We Right Out the Screcial PlaceHolder:
         writeOutput('<div style="background: url(''assets/images/screcials/backgrounds/#getBackground()#'');" id="ScrecialHldr">
                      <div id="ScratchOffRDMD">#getDescription()#</div>
                      </div>');
         
         

      }
      return WriteOutput(local.Redeemed);
      
   }
   
      
   
   
   public any function GetScrecial(required numeric ScrecialID, required numeric MemberID){
          
      //Before We Display the Screcial We have a Few Checks to do:
         SQL = "select mmb_id, SCO_ID, msw_scratched ,msw_redeem_date from MallScratchOffWinners 
             where mmb_id=#getMemberID()# and msw_win_date = '#dateFormat(now(), "YYYY-MM-DD")#' and msw_redeem_date ='#dateFormat(now(), "YYYY-MM-DD")#' and sco_id=#getScrecialID()#";
         QGetScrecialRedemption = new Query(sql=SQL).execute().getResult();
         
                  
         if(QGetScrecialRedemption.RecordCount EQ "0") {
             setScratched('0');
             setScrecialID('#arguments.ScrecialID#');
             ScrecialSQL = "select sco_title, sco_description, sco_defaultBG, sco_defaultIMG, sco_buttons, sco_descDisplay, sco_descIMG, sco_type_id, sco_link_text, sco_link_href from MallMerchantScratchOff where sco_id=#getScrecialID()#";
             ScrecialProps = new Query(sql=ScrecialSQL).execute().getResult();
             //Sets the Background if not null in ScrecialProps
             if(screcialProps.sco_defaultBG NEQ ""){
             setBackground('../sitetemplate/images/screcials/backgrounds/#screcialProps.sco_defaultBG#');
             writeOutput("<style>
                          .ScratchBoxBG {
                          background-image: url('#getbackground()#');
                          width: #getWidth()#px; 
                          height:#getHeight()#px;
                          }
                          </style>");
             }
             //Sets the Scratchoff if not null in ScrecialProps
             if(screcialProps.sco_defaultIMG NEQ ""){
             setScratchoff('../sitetemplate/images/screcials/scratchoffs/#screcialProps.sco_defaultIMG#');
               //We Check to see if the Scratchoff is a GIF:
               if(getScratchoff() contains ".gif"){
               //it's a GIF:
               setScrecialGIF('1');
               }
             }
             //Set the Button Color:
             setButtons('#ScrecialProps.sco_buttons#');
             //Set the Description Display:
             setdescriptionDisplay('#ScrecialProps.sco_descDisplay#');
               if(getdescriptionDisplay() NEQ "1"){
                  //The Display ISNOT TEXT ONLY:
                  setDescIMG('#screcialProps.sco_DescIMG#');
               }
             
             //Sets the Link Text if not null in ScrecialProps
             if(screcialProps.sco_link_text NEQ ""){
             setLinkText('#screcialProps.sco_link_text#');
             }
             //Sets the HREF if not null in ScrecialProps
             if(screcialProps.sco_link_href NEQ ""){
             setLinkhref('#ScrecialProps.sco_link_href#');
             }
             //Sets the Title if not null in ScrecialProps
             if(screcialProps.sco_title NEQ ""){
             setTitle('#screcialProps.sco_title#');
             }
             //Sets the Description if not null in ScrecialProps
             if(screcialProps.sco_description NEQ ""){
             setDescription('#screcialProps.sco_description#');
             }
             
             //Set the ProgramURL and Affiliate Program if a PromoID is Defined:
             if( getPromoID() is "" or getPromoID() is "0" ){
             //No PromoID - So We use the one Listed within the Screcial DataTable:
                 setClickJump('#getclickjump()#?screcial_mmb_id=#getMemberID()#&screcial_sco_id=#getScrecialID()#&screcial_redirect=#getLinkhref()#');
                 
             } else {
                SQL = "SELECT MPM.merchantid, mpm.link as LinkRef, MMC.program
              From MallPromos MPM
	           Inner JOIN MallMerchants MMC on MMC.id = mpm.merchantid
	           where MPM.id='#getPromoID()#'";
	           
	           ScrecialPromoLinks = new Query(sql=SQL).execute().getResult();
              setProgramURL('#ScrecialPromoLinks.LinkREF#');
              setAffiliateProgram('#ScrecialPromoLinks.Program#');
              
              //setScrecialRedemption('#getclickjump()#?screcial_mmb_id=#getMemberID()#&screcial_sco_id=#getScrecialID()#&screcial_redirect=#getProgramURL()#&#getMemberID()#');
              setClickJump('#getclickjump()#?screcial_mmb_id=#getMemberID()#&screcial_sco_id=#getScrecialID()#&screcial_redirect=#getProgramURL()#');
             }
             
             
             
             //We Render out the Screcial:
               savecontent variable="local.Screcial"{
                /*
               if(getScrecialGIF() is "1"){
                 Writeoutput('<img id="gifIMG" src="#GetScratchOff()#" style="display:none;"/>');
               }
               */
            
               WriteOutput('
                <div id="Scratchbox-Fixed" class="ScratchBoxBG" style="position:relative;">' &

                  (getScrecialGIF() == "1"?'<img id="gifIMG" src="#GetScratchOff()#" style="display:none; position: absolute; left:0; top:0;"/>':'')& '

                    
                    <div id="scrDescription">
                      <div id="scrTitle" style="display:inline-block">#UCase(getTitle())#</div>');

                       //<div id="text">#getDescription()#</div>
                       if (getDescriptionDisplay() is "2"){
                          //We have an Image on the Left: (60x130):
                          WriteOutput('<div id="text"><img src="#getDescriptions()##getDescIMG()#" width="60" height="130" style="float:left; margin-right: 5px">#getDescription()#</div>');
                       } else if(getDescriptionDisplay() is "3"){
                          WriteOutput('<div id="text"><img src="#getDescriptions()##getDescIMG()#" width="60" height="130" style="float:right; margin-left: 5px">#getDescription()#</div>');
                       } else {
                          WriteOutput('<div id="text">#getDescription()#</div>');
                       }
                               

                    WriteOutput('
                    </div><!-- close scrDescription -->

                    <div id="scRedeem">');
                         //<a class="btn" id="redemption" href="#getClickJump()#" target="_blank">');
                        if(getButtons() is "1"){
                           WriteOutput('<a id="redemption" href="#getClickJump()#" target="_blank" class="btn btn-success">');
                        } else if (getButtons() is "2"){
                           WriteOutput('<a id="redemption"  href="#getClickJump()#" target="_blank" class="btn btn-primary">');
                        } else if (getButtons() is "3"){
                           WriteOutput('<a id="redemption" href="#getClickJump()#" target="_blank" class="btn btn-danger">');
                        }
                                 
                        if (isNull(getLinkText()) ){
                          WriteOutput('Redeem your Screcial!');
                        }else {
                          Writeoutput("#getLinkText()#");
                        }
                               
                      WriteoutPut('
                        </a><br/>
                    </div>
          
                    <div id="redeemValid"></div>
                    <div id="jScratchOff" style="position:absolute;"></div>
                    
       
                  </div><!-- Scratchbox-Fixed -->
                  

               
                <div id="keepScratching"></div>
                
                ');



                            
                               Writeoutput("<script>

                                $(function() { //document ready


                                  //increase title up to just fit ScratchOff Box
                                  maxTitleWidth=($('##Scratchbox-Fixed').width()-25);
                                  while($('##scrTitle').width() < maxTitleWidth) {
                                    size = parseInt($('##scrTitle').css('font-size'));
                                    $('##scrTitle').css('font-size', size + 1);
                                  }

                                  //center description
                                  maxDescHeight=($('##Scratchbox-Fixed').height()-45);
                                  myDescHeight=$('##scrDescription').height();
                                  if(myDescHeight>maxDescHeight){
                                    $('##scrDescription').css({'height':'180px'});
                                  }else{
                                    nudge= ($('##Scratchbox-Fixed').height() - myDescHeight)/2;
                                    $('##scrDescription').css({'top':nudge+'px'});
                                  }



                                });
                                
                               $('##scrDescription').show();
                               $('##scRedeem').hide();



                              ");

                               
                               Writeoutput("
                               $('##redemption').on('click', function(){
                                    $('##scRedeem').fadeOut();
                                    $('##redeemValid').html('Congratulations!!!<br><small style=""font-size: 0.675em; color: ##000;"">Come back tomorrow for a new Screcial&##8480;</small>').fadeIn(); 
                               });
        
                               var sp = $('##jScratchOff').wScratchPad({
                                    cursor: '#getCoin()#',
                                    width: '#getWidth()#',
                                    height: '#getHeight()#',
                                    size: #getRadius()#,
                                    image2: '#getScratchoff()#',
                                    realtimePercent : true,
                                    scrathDown: function(e, percent){");
                                    if(getScrecialGIF() is "1"){
                                          WriteOutput("$('##gifIMG').remove();");
                                    }
                                    
                                    WriteOutput("},
                                    scratchMove: function(e, percent){");
                                    if(getScrecialGIF() is "1"){
                                          WriteOutput("$('##gifIMG').remove();");
                                    }
                                    WriteOutput("},
                                    scratchUp: function(e, percent){
                                          if(percent >= 50){
                                          
                                          $.ajax({
                                             url: '#getScrecialRedemption()#',
                                             global: false,
                                             type: 'POST',
                                             async: false,
                                             dataType: 'html',
                                             data: 'memberID=#getMemberID()#&screcialID=#getScrecialID()#', 
                                             success: function (response) //'response' is the output provided
                                             {                            
                                                     
                                             }
                                          });
                                          
                                          $('##scRedeem').fadeIn();
                                          $('##jScratchOff canvas, ##jScratchOff div, ##gifIMG').remove();
                                          ScrecialWorks.fireworkShow('##Scratchbox-Fixed', 100).css({'z-index': '-500'});
                                                     
                      
                                    return false
      
                                    } else if(percent < 50) {
                 
                                    }
               
                                    }
            
                                 });");
                              
                               if(getScrecialGIF() is "1"){
                               WriteOutput("$('##gifIMG').css({'height':'230px;', 'width':'230px;', 'display':'inline-block', 'postion':'absolute',  'z-index': '100000'}).show();
            
                                             $('##jScratchOff').click(function () {
                                                $('##gifIMG').remove();
                                             });
            
                                             $('##gifIMG').mouseover(function(){
                                                $(this).hide();
                                             });
            
                                             $('##jScratchOff').mouseout(function () {
                                                //alert('This should have animated again');
                                                $('##gifIMG').show();
                                             });");
                               }
                               
                               WriteOutput("</script>");
               }
            
            
            return WriteOutput(local.screcial);
         }  else {
            //This is Where the Redeemed Screcial Will Show:
            setScratched('1');
             savecontent variable="local.Screcial"{
             Writeoutput("");   
             }
             return WriteOutput(local.screcial);        
            
         }           
            
         
         
         
      
   }
   
   public any function GetScrecialDependancies (){
      //This Loads the Dependancies Needed to Build and Run the ScratchOff:
      savecontent variable="local.Dependancies"{
      WriteOutput("<!--The ScratchOff JavaScripts-->
                   <!---script src='../sitetemplate/js/jquery/jquery-1.11.0.min.js'></script--->
                   <script src='../sitetemplate/js/ScratchOff.js'></script>");
      }
            
      return local.Dependancies;
   }
   
   public any function GetScrecialJS (){
      //This Loads the Dependancies Needed to Build and Run the ScratchOff:
      savecontent variable="local.ScrecialJS"{
   
      }
      return local.ScrecialJS;
   }
   
   
   remote any function RedeemWinner(required numeric memberID, required numeric ScrecialID){
   //This is the Ajax function that Redeems the Winner:
   variables.MemberID = arguments.memberID;
   variables.ScrecialID = arguments.ScrecialID;
   setScratched(1);
   setScrecialID(variables.ScrecialID);
     
   SQL = "select * from MallScratchOffWinners where mmb_id=#variables.memberID# and sco_id=#variables.ScrecialID# and 
          msw_redeem_date='#dateFormat(now(), "YYYY-MM-DD")#'";
   
   CheckScrecialRedeem = new Query(sql=SQL).execute().getResult();

      if (CheckScrecialRedeem.RecordCount EQ "0") {
         SQL = "insert into MallScratchOffWinners (mmb_id, sco_id, msw_scratched, msw_win_date) VALUES (#variables.memberID#, 
            #variables.ScrecialID#, 1, '#dateFormat(now(), "YYYY-MM-DD")#')";
         Q_MemberScrecialRedeem = new Query(sql=SQL).execute().getResult();
         
         init(mallID=#getMallID()#, memberid=#variables.MemberID#, scratched=1, screcialID=#getScrecialID()#);
      }
   

   }
   //return SQL;
   
   
}
