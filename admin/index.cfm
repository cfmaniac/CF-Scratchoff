<cfscript>
   ScratchOffAdmin.init(environment='#environment.area#');
</cfscript>

<html lang="en">
<meta charset="utf-8">
<head>
	<title>Scratch-Off Administration</title>
	
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
   
   <cfscript>
   WriteOutput( ScratchOffAdmin.getAdminStyles() );  
   WriteOutput( ScratchOffAdmin.getAdminDependancies() ); 
   </cfscript>

</head>
<body>
<div id="container" align="center">
 	   
<cfscript>
   //Categories:
   CTSQL="SELECT ID, Name from MallCategories where active=1";
   Categories= new Query(sql=CTSQL, datasource=environment.datasource).execute().getResult(); 
   
   //Malls:
   MLSQL="SELECT MST.id, MST.company, MST.mallname
            FROM MallSites MST WHERE MST.inactive IS NULL ORDER BY MallName";
   Malls = new Query(sql=MLSQL, datasource=environment.datasource).execute().GetResult();  
   
   //Merchants:
   MRSQL="SELECT ID as mmr_id, link as LinkURL, merchant as MerchantName from MallMerchants MMR Where inactive is NULL ORDER BY Merchant";
   Merchants = new Query(sql=MRSQL, datasource=environment.datasource).execute().getResult();
   
   if (isDefined('url.task') and url.task NEQ ""){
      task = #url.task#;
   } else {
      task = 'default';
   }
   
   switch(task) {
    case "list":
         smHeader="LoyaltySuperStore&trade;";
         lgHeader="ScratchOff&##8480; Administration :: List ScratchOff";
         WriteOutput('<div style="font-size:20px; color:white; font-weight:bold;">#smHeader#</div>
		                <div style="font-size:40px; color:white; font-weight:bold;">#lgHeader#</div>
		                <div id="whiteBox">');
		   if(isdefined('url.msg') and url.msg NEQ ""){
         WriteOutput('<p class="alert alert-success">'&url.msg&'</p>');
         }
   
		                
		                
         WriteOutput("ScratchOff List");
         WriteOutput( ScratchOffAdmin.GetScratchOff());
         WriteOutput('</div>');
         break;
         
    /*case "save":
         ScratchOffAdmin.SaveScratchOff();
    break;
    
    case "update":
         ScratchOffAdmin.UpdateScratchOff();
    break;*/
         
    case "activate":
         WriteOutput( ScratchOffAdmin.ToggleScratchOff(ToggleType="Enable", ScrecialID='#url.ScrecialID#'));
         break;     
         
    case "deactivate":
         WriteOutput( ScratchOffAdmin.ToggleScratchOff(ToggleType="Disable", ScrecialID='#url.ScrecialID#'));
         break; 
           
    case "ClearScratchOff":
         ScratchOffAdmin.ClearScratchOff();
         break; 
             
    case "delete":
         WriteOutput( ScratchOffAdmin.DeleteScratchOff(ScrecialID='#url.ScrecialID#'));
         break;     
        
    case "edit":
         scoID = #url.sco_id#;
         type = #url.type#;        
         smHeader="LoyaltySuperStore&trade;";
         lgHeader="Edit Screcial&##8480; : ";
         WriteOutput('<div style="font-size:20px; color:white; font-weight:bold;">#smHeader#</div>
		                <div style="font-size:40px; color:white; font-weight:bold;">#lgHeader#</div>
		                <div id="whiteBox">');
         WriteOutput('
         <form name="screcialMaint" id="screcialMaint" method="post" action="../com/AdminScratchOff.cfc" enctype="multipart/form-data">
         <input type="hidden" name="sco_id" value="#scoID#">'); 
            
         WriteOutput( ScratchOffAdmin.ShowScrecialForm(view='#url.task#', type='#url.type#', scoID=#scoID#) );
         WriteOutput('</div>');
                 
         break;
    
    case "add":
         smHeader="LoyaltySuperStore&trade;";
         lgHeader="Add New Screcial&##8480;";
         WriteOutput('<div style="font-size:20px; color:white; font-weight:bold;">#smHeader#</div>
		                <div style="font-size:40px; color:white; font-weight:bold;">#lgHeader#</div>
		                <div id="whiteBox">');
         WriteOutput('
         <form name="screcialMaint" id="screcialMaint" method="post" action="../com/AdminScratchOff.cfc" enctype="multipart/form-data">');       
         WriteOutput( ScratchOffAdmin.ShowScrecialForm(view='#url.task#', type='#url.type#') );
         WriteOutput('</div>');
         break;
    
    case "winners":
               
         smHeader="LoyaltySuperStore&trade;";
         lgHeader="Screcial&##8480; : Winner Redemptions";
         WriteOutput('<div style="font-size:20px; color:white; font-weight:bold;">#smHeader#</div>
		                <div style="font-size:40px; color:white; font-weight:bold;">#lgHeader#</div>
		                <div id="whiteBox">');
                       
         WriteOutput( ScratchOffAdmin.ShowScrecialWinners() );
         
         WriteOutput('</div>');
         break;
         
    default: 
      
      smHeader="LoyaltySuperStore&trade;";
      lgHeader="ScratchOff&##8480; Administration";
            
       WriteOutput('<div style="font-size:20px; color:white; font-weight:bold;">#smHeader#</div>
		<div style="font-size:40px; color:white; font-weight:bold;">#lgHeader#</div>');
		
		writeOutput('<div id="whiteBox">');
		
		writeOutput( ScratchOffAdmin.getScratchOffDefault() );
		
		WriteOutput('</div>');
		         
}
   
   
</cfscript>
<cfoutput>
<cfif #task# is "default">
   <script>   
    $(function() {
      // Show the Prod Search Form:
      $('##ShowProdSearch').on('click', function(){
         $('##StartFromProd').slideDown();
         $('##StartFromPromo').slideUp();
         return false;
      });
      $('##SearchProdScratchOff').on('click', function(){
               $('##SearchProdScratchOff').val('Searching Products API...').attr('disabled', 'disabled');
               
               var searchTerms= $('##prodText').val();
               var MallID = $('##searchMall option:selected').val();
               $.ajax({
               url: "http://<cfoutput>#cgi.http_host#</cfoutput>/com/AdminScratchOff.cfc?method=GetScratchOffProdResults",
               global: false,
               type: "POST",
               async: false,
               dataType: "html",
               data: "SCOSearch="+searchTerms+"&mallID="+MallID, //the name of the $_POST variable and its value
               success: function (response) //'response' is the output provided
                           {
                           $("##ResultsProds").html(response).fadeIn();
                           $('##SearchProdScratchOff').val('Search for SCRECIALS').removeAttr('disabled');
                           }
              });

              return false;
    
    
      });
      $('##ClearProds').on('click', function() {
         $("##ResultsProds").html('').fadeOut();
         $('##prodText, ##searchMall').val('');
      
      });
      
      
      // Show the Promo Search Form:
      $('##ShowPromoSearch').on('click', function(){
         $('##StartFromPromo').slideDown();
         $('##StartFromProd').slideUp();
         return false;
      });
      
      //Search Promo functions:
      $('##promoText, ##prodText').prop('placeholder', 'Text to Search For');
      
      $('##ClearPromos').on('click', function() {
         $("##ResultsPromos").html('').fadeOut();
         $('##promoText, ##searchType, ##searchCat').val('');
      
      });
      $('##SearchScratchOff').on('click', function(){
               $('##SearchScratchOff').val('Searching Promos...').attr('disabled', 'disabled');
               var searchTerms= $('##promoText').val();
               var searchtype = $('##searchType option:selected').val();
               var searchcat = $('##searchCat option:selected').val();
               $.ajax({
               url: "http://<cfoutput>#cgi.http_host#</cfoutput>/com/AdminScratchOff.cfc?method=GetScratchOffResults",
               global: false,
               type: "POST",
               async: false,
               dataType: "html",
               data: "SCOSearch="+searchTerms+'&type='+searchtype+'&cat='+searchcat, //the name of the $_POST variable and its value
               success: function (response) //'response' is the output provided
                           {
                           $("##ResultsPromos").html(response).fadeIn();
                           $('##SearchScratchOff').val('Search for SCRECIALS').removeAttr('disabled');
                           }
              });

              return false;
    
    
      });
      
    });
  </script>  
</cfif>
</cfoutput>

	<cfscript>
	   WriteOutput( ScratchOffAdmin.getAdminFooter(task=#task#) ); 
	</cfscript>
		
</div>
</body>
</html>
