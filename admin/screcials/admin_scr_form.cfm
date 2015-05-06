<!--WYSIWYG Editor-->
   <script type="text/javascript" src="../../backoffice/js/tiny_mce/tiny_mce.js"></script>
   <link rel="stylesheet" media="all" type="text/css" href="../../backoffice/css/tinymce.css" />
<!--END WYSIWYG-->
<cfscript>
   //WriteDump(var=QScrecial, abort=true);
   
</cfscript>

<cfoutput>
<!---We are going to put the Majority of our Hidden Fields at the Top of the Form--->
<cfif task is "Edit">
   <cfset PreviewDesc = "#rereplace(QScrecial.sco_description, '"', "'", "ALL")#">
</cfif>
<cfif task is "Edit" and qScrecial.sco_DescIMG NEQ "">
   <input type="hidden" name="sco_DescIMGOrig" id="sco_DescIMGOrig" value="#QScrecial.sco_DescIMG#">
</cfif>

<input type="hidden" name="sco_active" id="sco_active" value="#QScrecial.sco_active#">
<input type="hidden" name="sco_holiday" id="sco_holiday" value="#QScrecial.sco_holiday#">

<div class="wrapper">
      <div class="row">
        <div class="pull-left column6">
         <strong>Screcial Mall:</strong><br>
         
               
        </div>
        <div class="pull-right column6">
         <!---input type="text" name="sco_title" id="sco_title" value="#QScrecial.sco_title#" maxlength="50"--->
         
         <select name ="mall_ID" id="mall_ID">
          <option value="0" <cfif qScrecial.mall_id EQ 0>selected="selected"</cfif>>All Malls</option>
			     <cfloop query="Malls">
                 <option value="#id#" <cfif qScrecial.mall_id EQ Malls.id>selected="selected"</cfif> >#mallName# (Company: #Company#)</option> 
               </cfloop>
         </select>
         
        </div>
        
      </div> 
       <cfif #task# is "Add">
    <div class="row">
        <div class="pull-left column6">
         <strong>Screcial Merchant:</strong><br>
         <a href="##" id="NoMerch">This Screcial Will not have a Merchant</a>
         <a href="##" id="MerchAsn" style="display:none;">Assign a Merchant</a>
               
        </div>
        <div class="pull-right column6">
         
        
         <select name ="merchantid" id="merchantid">
			    <option value="0">Select Merchant</option>
			    <cfloop query="Merchants">
             <option value="#mmr_ID#" rel="#linkurl#" <cfif qScrecial.mmr_id EQ mmr_id>selected="selected"</cfif>>#MerchantName#</option>
			    </cfloop>		
         </select>
         <input type="hidden" name="mmr_id" id="mmr_id" <cfif isdefined('merchID')>value="#merchID#"</cfif>>
           
        </div>
        
    </div> 
    <cfelse>
         <input type="hidden" name="mmr_id" id="mmr_id" value="#qScrecial.mmr_id#">   
         </cfif> 
    
    <cfif isdefined('url.merchID') and url.merchID NEQ "" and isdefined('url.promoID') and URL.PromoID NEQ "" and QScrecial.sco_type_id is "2">
    <div class="row">
        <div class="pull-left column6">
         <strong>Screcial Promo:</strong>
               
        </div>
        <div class="pull-right column6">
         
        
         <select name ="PromoList" id="PromoList" size="10" style="height: 260px;">
			    <option value="0">Select Promo</option>
			    	
         </select>
         <input type="hidden" name="mpm_id" id="mpm_id" <cfif task is "add" and isdefined('url.promoID')>value="#url.promoID#" <cfelseif task is "edit">value="#Qscrecial.mpm_id#"</cfif>>
         </div>
        
    </div>
     
    <cfelseif task is "edit">
    <input type="hidden" name="mpm_id" id="mpm_id" value="#Qscrecial.mpm_id#">
    <cfelse>
    <input type="hidden" name="mpm_id" value="#Qscrecial.mpm_id#">
    </cfif>
    
    <div class="row">
        <div class="pull-left column6">
         <strong>Screcial Title:</strong>        
        </div>
        <div class="pull-right column6">
         <input type="text" name="sco_title" id="sco_title" value="#QScrecial.sco_title#" maxlength="50"> 
         <span class="help-block">The title shown within the Screcial</span>  
        </div>
        
    </div> 
    
    <div class="row">
        <div class="pull-left column6">
         <strong>Screcial Description:</strong>        
        </div>
        <div class="pull-right column6">
         <textarea name="sco_description" class="mceEditor" id="sco_description">#QScrecial.sco_description#</textarea>
         <span class="help-block">The Description of the Screcial, including Codes or other pertinent information</span>   
        </div>
        
    </div>  
    
    <cfif task is "Add" and qScrecial.sco_type_id is "2">
    <div class="row">
        <div class="pull-left column6">
            <strong>Screcial Value Fixed</strong>
        </div>
        <div class="pull-right column6">
            <select name="sco_fixed" id="sco_fixed">
            <option value="0" <cfif #QScrecial.sco_fixed# is "0">selected="selected"</cfif> >No (Percentage %)</option>
            <option value="1" <cfif #QScrecial.sco_fixed# is "1">selected="selected"</cfif>>Yes (Flat-Rate -)</option>
            </select>
            <span class="help-block">Is the value of the Screcial a Fixed-Rate or Percentage?</span> 
        </div>
        
    </div>
    
    <div class="row" style="display: none;" id="valRow">
        <div class="pull-left column6">
            <strong>Screcial Value Type</strong>
        </div>
        <div class="pull-right column6">
            <select name="sco_value_type" id="sco_value_type">
            <option value="0" <cfif #QScrecial.sco_value_type# is "0">selected="selected"</cfif> >Points</option>
            <option value="1" <cfif #QScrecial.sco_value_type# is "1">selected="selected"</cfif>>Dollars</option>
            </select>
            <span class="help-block">Is the value of the Screcial redeemable as Points or Dollars?</span> 
        </div>
        
    </div>
    
     <div class="row">
        <div class="pull-left column6">
            <strong>Screcial Value</strong>
        </div>
        <div class="pull-right column6">
            <input type="text" name="sco_value" id="sco_value" value="#QScrecial.sco_value#">
            <span class="help-block">Numbers only, decimals permitted (i.e., .5-1.5)</span> 
        </div>
        
    </div>
    </cfif>
        
    <div class="row">
        <div class="pull-left column6">
            <strong>Screcial Link Text</strong>
        </div>
        <div class="pull-right column6">
            <input type="text" maxlength="150" <cfif #task# is "Add">placeholder="Click Here to Redeem"<cfelse>value="#QScrecial.sco_link_text#"</cfif> name="sco_link_text" id="sco_link_text">
            <span class="help-block">The call to action text for the Link</span> 
        </div>
        
    </div>
    
    
    <div class="row">
        <div class="pull-left column6">
            <strong>Screcial Link </strong>
        </div>
        <div class="pull-right column6">
            <input type="text" maxlength="150" <cfif #task# is "Add">placeholder="http://"<cfelse>value="#QScrecial.sco_link_href#"</cfif> name="sco_link_href" id="sco_link_href">
            <span class="help-block">The URL or Link that the Screcial Will goto</span> 
            <div id="validateLink" style="display:none;">
                <a id="testLink" class="btn btn-primary">Test the Link</a><br>
                <div id="viewResult"><a id="closeResult" class="pull-right btn btn-danger" style="display:none;position: absolute; left: 84.2%; z-index: 50;">&times;</a>
                <iframe id="testLinkResult" name="testLinkResult" frameborder="0"></iframe>
                
                </div>
            </div>
        </div>
        
    </div>
    
    <div class="row">
        <div class="pull-left column6">
            <strong>Holiday Screcial?</strong>
        </div>
        <div class="pull-right column6">
           <select name="Holiday" id="Holiday">
               <option value="0">No, Not a Holiday Screcial</option>
               <option value="1">Yes, Holiday Only Screcial </option>
           </select>
           <span class="help-block">Will This Screcial be a Holiday only Screcial?</span> 
        </div>
        
    </div>
    
     <div class="row" id="HolidayRow" style="display: none;">
        <div class="pull-left column6">
            <strong>Select the Holiday:</strong>
        </div>
        <div class="pull-right column6">
           
            <cfloop index="name" array="#sorted#">
            <cfset DateValid ="1">
            <cfset HoliDate = #DateFormat(Holidays[name], "MM/DD/YYYY")#>
             <cfif #HoliDate# LTE #dateFormat(now(), "MM/DD/YYYY")#>
                <cfset DateValid = "0">
             </cfif>
            <span style="font-size: 0.625em;" class="column6 <cfif sorted.indexOf(name) mod 2>pull-right<cfelse>pull-left</cfif>">
               <input <cfif DateValid is "0">disabled="disabled"</cfif>type="radio" name="holidayDate" id="holidayDate#sorted.indexOf(name)#" value="#DateFormat(Holidays[name], "MM/DD/YYYY")#">
            <cfif DateValid is "0">
            <s>#name# #HoliDate#</s><br/>
            <cfelse>
            <strong>#name#</strong> #HoliDate#<br>
            </cfif>
            </span>
            </cfloop>
        </div>
     </div>
    
    <div class="row" >
        <div class="pull-left column6">
            <strong>Screcial Start Date/Time:</strong>
        </div>
        <div class="pull-right column6">
            <input type="text" maxlength="150" <cfif #task# is "Add">value="#DateFormat(now(), "MM/DD/YYYY")#"<cfelse>value="#DateFormat(QScrecial.sco_start, "MM/DD/YYYY")#"</cfif> name="sco_start" id="sco_start">
            <span class="help-block">The Start Date of the Screcial. <span class="req">This is required.</span></span> 
        </div>
        
    </div>
    
    <div class="row">
        <div class="pull-left column6">
            <strong>Screcial End Date/Time:</strong>
        </div>
        <div class="pull-right column6">
            <input type="text" maxlength="150" value="#DateFormat(QScrecial.sco_end, "MM/DD/YYYY")#" name="sco_end" id="sco_end">
            <span class="help-block">The End Date of the Screcial. <span class="req">This is required.</span></span> 
        </div>
        
    </div>
    
    
    <div class="row">
        <div class="pull-left column6">
           <strong>Screcial Active:</strong> 
        </div>
        <div class="pull-right column6">
            <div class="onoffswitch">
               <input type="checkbox" name="onoffswitch" class="onoffswitch-checkbox" id="myonoffswitch" <cfif #QScrecial.sco_active# is "1">checked </cfif>>
               <label class="onoffswitch-label" for="myonoffswitch">
               <div class="onoffswitch-inner"></div>
               <div class="onoffswitch-switch"></div>
               </label>
               
            </div>


        </div>
        
    </div>
    
     <div class="row">
        <button type="submit" form="screcialMaint" value="Submit" class="btn btn-info pull-right"><cfif #task# is "Edit">UPDATE <cfelse>ADD </cfif>SCRECIAL</button>
     
     </div>
     
     
    
</div>

<!---Screcial Preview pane--->
     <div class="panel" style="border: 1px solid ##DDD;">
	      <h3>Screcial Preview</h3>
	      <p>This is a preview of what the Screcial will look like after it has been scratched.</p>
	      <div style="clear:both;"></div>
        
         
         <div >
            <!---Screcial Preview--->
             <div>
               <div id="ScrePre" style="z-index: -10; width: 230px; height:230px; background-color: ##fff; background-image: url('../sitetemplate/images/screcials/backgrounds/Winner_4.png'); border: 2px dashed ##000;">
                  <div id="PreTitle" style="z-index: 10; margin-top: 5px; font-weight: bold;">Screcial Title</div>
                  <!---Image Preview id="PreDescrIMG"--->
                  <div id="PreDescrIMG">
                  <input type="hidden" name="sco_descIMG" id="sco_descIMG">
                  <cfif task is "add">
                      
                      <img alt="..." id="scrIMG" style="width: 60px; height: 130px;">
                      <div class="fileinput-preview fileinput-exists thumbnail" style="max-width: 60px; max-height: 130px;">
                      
                        </div>
                        <div id="IMGSelect">
                        <span class="btn btn-default btn-file">
                           <span class="fileinput-new">Select image</span>
                           <span class="fileinput-exists">Change</span>
                           <input type="file" name="sco_descIMG" id="sco_descIMG">
                        </span>
                        <span class="fileinput-exists btn btn-default fileinput-exists" data-dismiss="fileinput">Remove</span>
                        </div>
                     
                     
                  <cfelseif task is "edit">
                     <cfif QScrecial.sco_descIMG NEQ "">
                     <!---Display the Screcial Image--->
                        <cfif #QScrecial.sco_descDisplay# is "1">
                        <img alt="..." id="scrIMG" src="../sitetemplate/images/screcials/descriptions/#QScrecial.sco_DescIMG#" style="width: 60px; height: 130px; float:left;">
                        <cfelseif #QScrecial.sco_descDisplay# is "2">   
                        <img alt="..." id="scrIMG" src="../sitetemplate/images/screcials/descriptions/#QScrecial.sco_DescIMG#" style="width: 60px; height: 130px; float:right;">
                        </cfif>
                     
                     </cfif>
                     
                     <!---Add an Image to a Preexisiting Screcial--->
                     <div id="AddNewImg" style="display: none;">
                        <img alt="..." id="scrIMG" style="width: 60px; height: 130px;">
                        <div class="fileinput-preview fileinput-exists thumbnail" style="max-width: 60px; max-height: 130px;">
                      
                        </div>
                        <div id="IMGSelect">
                        <span class="btn btn-default btn-file">
                           <span class="fileinput-new">Select image</span>
                           <span class="fileinput-exists">Change</span>
                           <input type="file" name="sco_descIMG" id="sco_descIMG">
                        </span>
                        <span class="fileinput-exists btn btn-default fileinput-exists" data-dismiss="fileinput">Remove</span>
                        </div>
                     </div> 
                  </cfif>
                  </div>
                  <!---End Image--->
                 
                   <cfif task is "add">
                    <div id="PreDescr" style="z-index: 10; width: 190px; overflow:auto; min-height: 130px; height: 150px; border: 1px solid ##eee; font-size: 0.750em;">
                      The Screcial Description
                    </div>
                   <cfelseif task is "edit">
                    <cfif #QScrecial.sco_descDisplay# is "1">
                     <div id="PreDescr" style="z-index: 10; width: 130px; min-height: 130px;max-height: 130px; overflow:auto; height: 150px; border: 1px solid ##eee; font-size: 0.750em; float:left;">
                     #QScrecial.sco_description#
                     </div>
                    <cfelseif #QScrecial.sco_descDisplay# is "2">
                     <div id="PreDescr" style="z-index: 10; width: 130px; min-height: 130px; max-height: 130px;overflow:auto; height: 150px; border: 1px solid ##eee; font-size: 0.750em; float:right;">
                     #QScrecial.sco_description#
                     </div>
                     <cfelse>
                     <div id="PreDescr" style="z-index: 10; width: 190px; min-height: 130px; overflow:auto; height: 150px; border: 1px solid ##eee; font-size: 0.750em;">
                      The Screcial Description
                    </div>
                     </cfif>
                   </cfif>
                 
                  <button id="PreLink" class="btn btn-success" style="font-size: 0.688em; z-index:10; max-width: 215px;">Click Here to Redeem Screcial</button>
               </div>
               
               <div class="row">
               <button href="##" class="btn btn-warning" id="CustomizeScrecial">Customize Me</button>
               </div>
               
               <div class="row" style="display: none; clear:both;" id="CustScrec">
               
                <br>
               <div class="row" style="font-size:0.688em;">
               To remove an image from a Screcial, Select "Text Only" Under Screcial Layout. 
               </div>
                <div class="row">
                <span class="pull-left" style="font-size:0.688em;">Border:</span>
                 <select name="sco_border" id="PreBor">
                     <option>Screcial Border</option>
                     <option value="0" <cfif #QScrecial.sco_border# is "0">selected="selected"</cfif>>Hide Border</option>
                     <option value="1" <cfif #QScrecial.sco_border# is "1">selected="selected"</cfif>>Show Border</option>
                 </select>
                </div>
                <div class="row">
                <span class="pull-left" style="font-size:0.688em;">Screcial Layout:</span>
                 <select name="sco_descDisplay" id="Display">
                     <option>Screcial Content</option>
                     <option value="0" <cfif #QScrecial.sco_descDisplay# is "0">selected="selected"</cfif>>Text Only</option>
                     <option value="1" <cfif #QScrecial.sco_descDisplay# is "1">selected="selected"</cfif>>Text & Image on Left</option>
                     <option value="2" <cfif #QScrecial.sco_descDisplay# is "2">selected="selected"</cfif>>Text & Image on Right</option>
                    
                    
                 </select>
                 <cfif task is "edit" and #qscrecial.sco_descimg# EQ "">
                 <a id="AddIMG" style="display: none; cursor: pointer; font-size: 0.75em;">Add Image to this Screcial</a>            
                 </cfif>
                </div>
                 <div class="row">
                 <span class="pull-left" style="font-size:0.688em;">Background Image:</span>
                 <select name="sco_defaultBG" id="BGIMG">
                 
                     <option>Screcial Background</option>
                     <option value="../sitetemplate/images/screcials/backgrounds/Winner_4.png" <cfif #QScrecial.sco_defaultBG# is "Winner_4.png">selected="selected"</cfif>>Gold StarBurst</option>
                     <option value="../sitetemplate/images/screcials/backgrounds/Winner_5.png" <cfif #QScrecial.sco_defaultBG# is "Winner_5.png">selected="selected"</cfif>>Silver StarBurst</option>
                 </select>
                </div>
                <div class="row">
                <span class="pull-left" style="font-size:0.688em;">Button Color:</span>
                 <select name="sco_buttons" id="Buttons">
                     <option>Screcial Button Color</option>
                     <option value="1" <cfif #QScrecial.sco_buttons# is "1">selected="selected"</cfif>>Green</option>
                     <option value="2" <cfif #QScrecial.sco_buttons# is "2">selected="selected"</cfif>>Blue</option>
                     <option value="3" <cfif #QScrecial.sco_buttons# is "3">selected="selected"</cfif>>Red</option>
                 </select>
                </div>
               <div class="row"><br>
                 <button id="CloseCust" class="btn btn-success">Done</button>
               </div>
             </div>
             
         </div>
            
             
         </div>
         
         <div style="clear:both;"></div>
     </div>
     <a class="trigger" href="##">Preview Screcial</a>
<!---END ScratchOff Customization Form--->
<script>
   $('##testLinkResult').hide();
   $(function () {
   //Initializes the TinyMCE WYSIWYG EDITOR:
   tinyMCE.init({
        mode : "specific_textareas",
        editor_selector : "mceEditor",
        theme_advanced_buttons1 : ",justifyleft,justifycenter,justifyright,justifyfull,bold,italic,underline,removeformat,sizeselect,fontsizeselect,code",
        theme_advanced_font_sizes: "10px,12px,13px,14px,16px,18px,20px",
        font_size_style_values: "12px,13px,14px,16px,18px,20px",
        setup : function (ed) {
               ed.onKeyPress.add(
               function (ed, evt) {
               var Content = tinyMCE.get('sco_description').getContent();
               $('##PreDescr').html(Content);
               //Should Alert on KeyUp 
               //alert("Editor-ID: "+ed.id+"\nEvent: "+evt);
               });
               
               ed.onChange.add(
               function (ed, evt) {
               var Content = tinyMCE.get('sco_description').getContent();
               $('##PreDescr').html(Content);
               //Should Alert on KeyUp 
               //alert("Editor-ID: "+ed.id+"\nEvent: "+evt);
               });
        }
        
   });
       
     //extends jQuery to add function hasAttr() :: J Harvey Custom Mod:
    $.fn.hasAttr = function(name) {  
      return this.attr(name) !== undefined;
   };   
   <cfif QScrecial.sco_active is "0">
      $('##whiteBox').css({'background-color': '##f2dede', 'border': '2px solid ##ebccd1'});
   </cfif>
   
   <cfif #task# EQ "Edit" and QScrecial.sco_type_id is "1" or qScrecial.sco_type_id is "2">
      <!---Some Editing Custom Screcial Funcs: --->
      $('##PreTitle').html("#QScrecial.sco_title#");
      $('##validateLink').show();
      
      $('##testLink').on('click', function(){
                
         $('##testLinkResult').css({'width': '594px', 'height': '350px'}).attr('src', $('##sco_link_href').val()).show();
         $('##viewResult').show();  
      });
      
      $('##closeResult').on('click', function(){
         
         $('##testLinkResult,##viewResult').hide();
        
      });
      
      
      $("##Display").on("change", function(){
         var DisplayType = $("##Display option:selected").val();
         
         if(DisplayType == "0"){
         $('##AddIMG').fadeOut();
         //Text Only:
            $("##PreDescrIMG").fadeOut("slow");
            $("##PreDescr").css({"font-size": "0.750em","width":"190px", "height":"150px", "overflow":"auto","border": "1px solid rgb(238, 238, 238)", "margin-left": "auto", "margin-right": "auto"});
           
            
                    
         } else if (DisplayType == "1"){
         $('##AddIMG').fadeIn();
         //Text and Image on Left:
            $("##PreDescrIMG").fadeIn("slow").removeClass("pull-right").addClass("pull-left").css({"width":"60px", "margin-left":"-25px;"});
            $("##PreDescr").css({"font-size": "0.750em", "z-index": "10","overflow": "auto","height": "150px","border": "1px solid rgb(238, 238, 238)","width": "150px","margin-left": "-2px"});
            
            $("##IMGSelect").css({"margin-top": "80px", "z-index":"25", "width": "230px"});
            
         } else if (DisplayType == "2"){
         $('##AddIMG').fadeIn();
         //Text and Image on Right:
            $("##PreDescrIMG").fadeIn("slow").removeClass("pull-left").addClass("pull-right").css({"width":"60px", "margin-right":"-25px;"});
            $("##PreDescr").css({"font-size": "0.750em", "z-index": "10","overflow": "auto","height": "150px","border": "1px solid rgb(238, 238, 238)","width": "150px","margin-left": "-2px"});
            
            $("##IMGSelect").css({"margin-left":"-175px", "margin-top": "80px", "z-index":"25", "width": "230px"});
         } 
               
      });
      
      $('##AddIMG').on('click', function(){
         $('##AddNewImg').fadeIn();
         $(this).fadeOut();
      });
      <!---cfif QScrecial.sco_descIMG NEQ "">
      alert('Screcial Description Display:#QScrecial.sco_DescDisplay#');
      $('##Display').val('#QScrecial.sco_DescDisplay#').change();
      $('##scrIMG').attr('src', '../SiteTemplate/images/screcials/descriptions/#QScrecial.sco_descIMG#');
      </cfif---> 
       
      
   </cfif>
   
   
      //Selects whether a Merchant ID Should be Assigned:
       $('##NoMerch').on('click', function(){
         $('##merchantid').hide();
         $('##sco_link_href').val('');
         $('##mmr_id').val('0');
         $(this).hide();  
         $('##MerchAsn').show();  
         return false;  
      });
      
      $('##MerchAsn').on('click', function(){
         $('##merchantid').show();
         var MerchURL = $("##merchantid option:selected").attr('rel');
         $('##sco_link_href').val(MerchURL);
         $('##mmr_id').val($("##merchantid option:selected").val());
         $(this).hide(); 
         $('##NoMerch').show();   
         return false;  
      });
      
      //Sets the MerchantID if Selected:
      $('##merchantid').change(function(){
        var merchID = $("##merchantid").val();
        var MerchURL = $("##merchantid option:selected").attr('rel');
        $('##mmr_id').val(merchID);
        
        $('##sco_link_href').val(MerchURL);
      });
      
      <cfif isdefined('url.merchID') and url.merchID NEQ "" and isdefined('url.promoID') and URL.PromoID NEQ "" and QScrecial.sco_type_id is "2">
         //This is Being Added from A Promo:
         var merchID = '#url.merchID#';
         var promoID = '#url.PromoID#';
         
         function LoadPromoData(){
               var MerchID = $('##merchantid option:selected').val();
               $.ajax({
               url: "http://#cgi.http_host#/com/AdminScratchOff.cfc?method=GetScrecialPromos",
               global: false,
               type: "POST",
               async: false,
               dataType: "html",
               data: "merchID="+merchID+"&promoID="+promoID, //the name of the $_POST variable and its value
               success: function (response) //'response' is the output provided
                           {
                           $("##PromoList").html(response);
                           //$("##PromoID option:first").attr('selected','selected').click();
                           
                           }
              });
                      
              //alert('Ran the Load Promo Data Function');
         }
         LoadPromoData();
         
         
         $('##NoMerch').hide();
         
         $("##merchantid").val(merchID).change();
         $('##mmr_id').val(merchID);
         $('##mpm_id').val(promoID);
         
         //Calls the Load Promo Data When Building from a Promo:
         
         
         //Otherwise this runs when you change a Merchant
         $('##merchantid').change(function(){
               var merchantID = $('##merchantid option:selected').val();
               //alert('Updated Merchant ID: ' +merchantID)
               $.ajax({
               url: "http://#cgi.http_host#/com/AdminScratchOff.cfc?method=GetScrecialPromos",
               global: false,
               type: "POST",
               async: false,
               dataType: "html",
               data: "merchID="+merchantID, //the name of the $_POST variable and its value
               success: function (response) //'response' is the output provided
                           {
                           $("##PromoList").html(response);
                           //$("##PromoID option:first").attr('selected','selected').click();
                           
                           }
              });
              return false
         });
         
         
         $("##PromoList option:selected").on('click', function(){
            var Title = $(this).attr('data-title');
            var Description = $(this).attr('data-description');
            var StartDate = $(this).attr('data-start');
            var EndDate = $(this).attr('data-end');
            
            $('##sco_title, ##sco_link_text').val(Title);
            $('##PreTitle').html(Title);
            $('##sco_description').val(Description);
            $('##PreDescr').html(Description);
            $('##sco_start').val(StartDate);
            $('##sco_end').val(EndDate);
            
         }).click();
      
         $('##PromoList').on('click', function(){
         var PromoID = $("##PromoList").val();
          var Title = $('##PromoList option:selected').attr('data-title');
          var Description = $('##PromoList option:selected').attr('data-description');
          var StartDate = $('##PromoList option:selected').attr('data-start');
          var EndDate = $('##PromoList option:selected').attr('data-end');
            
            $('##sco_title, ##sco_link_text').val(Title);
            $('##PreTitle').html(Title);
            $('##sco_description').val(Description);
            $('##PreDescr').html(Description);
            $('##sco_start').val(StartDate);
            $('##sco_end').val(EndDate);
         
      });   
         
         
        //End Loading from a Promo
      </cfif>
      
      <cfif QScrecial.sco_type_id is "3">
         <cfif isdefined('url.prodName')>
         //Loading a Screcial from a Product:
         var Title = '#url.prodName#';
         var Description = '#url.prodDesc#';
         var Image = '#url.prodIMG#';
         var MerchID = '#url.MerchID#';
         
         $('##NoMerch').hide();
      
      $('##sco_title, ##sco_link_text').val(Title).keyup();
      $('##sco_description').val(Description).keyup();
      $('##merchantid').val(MerchID);
      $('##sco_descIMG').val(Image);
      $('##scrIMG').attr('src',Image);
      $('##Display').val('1').change();
      $('##PreTitle').html(Title);
      $('##PreDescrIMG').addClass("pull-left").css({"width":"60px", "margin-left":"-25px;"});
      $("##PreDescr").html(Description).css({"font-size": "0.750em", "z-index": "10","overflow": "auto","height": "150px","border": "1px solid rgb(238, 238, 238)","width": "150px","margin-left": "-2px"});
      
            
            
      
      <cfelse>
         
      $('##sco_title, ##sco_link_text').keyup();
      $('##sco_description').keyup();
      $('##PreDescrIMG').addClass("pull-left").css({"width":"60px", "margin-left":"-25px;"});
      $("##PreDescr").css({"font-size": "0.750em", "z-index": "10","overflow": "auto","height": "150px","border": "1px solid rgb(238, 238, 238)","width": "150px","margin-left": "-2px"});
      
         
      </cfif>
      //End Loading a Screcial from a Product:
      </cfif>
      
      //Populates the Title in the Preview:
      $('##sco_title').keyup(
         function(){
         TitleText = $(this).val();
         TitleTextCaps = TitleText.toUpperCase();
         $('##PreTitle').html(TitleTextCaps);
         
      });
      
      <cfif task is "Add">
         $('##sco_link_href').keyup(function(){
          $('##validateLink').show();
         });
         
          $('##sco_link_href').change(function(){
          $('##validateLink').show();
         });
        
      
         
      
      $('##PreDescrIMG').hide();
      </cfif>
        
        $('##testLink').on('click', function(){
                
         $('##testLinkResult').css({'width': '594px', 'height': '350px'}).attr('src', $('##sco_link_href').val()).show();
         $('##viewResult, ##closeResult').show();  
         });
      
      $('##closeResult').on('click', function(){
         
         $('##testLinkResult,##viewResult').hide();
        
      });
         
      //Populates the Description in the Preview:
      //This has been moved into the Editor Init Setting Function
      //I left this here for Archival / and or restorative backups
      /*$('##sco_description').keyup(function(){
             $('##PreDescr').html($(this).val());
      });*/
      
      
      //Toggles the Value Type:
      $('##sco_fixed').change(function(){
         var FixedRate = $("##sco_fixed").val();
         if(FixedRate == "1"){
            $('##valRow').slideDown();
         } else{ 
            $('##valRow').slideUp();
         }

      });
      
      //Toggles the Holiday:
      $('##Holiday').change(function(){
         var Holiday = $("##Holiday").val();
         
         if(Holiday == "1"){
            $('##HolidayRow').slideDown();
            
            $('##sco_holiday').val('1');
         } else{ 
            $('##HolidayRow').slideUp();
           
            $('##sco_holiday').val('0');
         }

      });
      
      
      $('input[name="holidayDate"]').on('change', function() {
         var SCODate = $(this).val();
        
         //alert('Selected Start and End date is:'+SCODate);
         $('##sco_start, ##sco_end').val(SCODate);
         
        
         
      });
     
       
      //changes the Value of the Screcial Status:
      $('##myonoffswitch').on('click', function(){
         if( $('##myonoffswitch').is(':checked') ){
            $('##sco_active').val('1');
            $('##whiteBox').css({'background-color': '##fff', 'border': 'none'}); 
            
         } else {
            $('##sco_active').val('0');
            $('##whiteBox').css({'background-color': '##f2dede', 'border': '4px solid ##a94442', 'border-radius': '20px'}); 
           
         }
      });
      
      //The Screcial Start and End Dates:
    
      $( "##sco_start" ).datepicker({
      changeMonth: true,
      changeYear: true,
      showOn: "button",
      buttonImage: "images/calendar.gif",
      buttonImageOnly: true
      });
    
      $( "##sco_end" ).datepicker({
      changeMonth: true,
      changeYear: true,
      showOn: "button",
      buttonImage: "images/calendar.gif",
      buttonImageOnly: true
		});
      
      //Screcial Preview Pane:
      $(".trigger").click(function(){
           $(".panel").toggle("fast");
           $(this).toggleClass("active");
           return false;
      });

      


      //Submits the Form:
      $('##submit').on('click', function(){
        $( "##screcialMaint" ).submit();

      });
   });
</script>
</cfoutput>