<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">















<html>
<head>
<title>
  MATLAB Central File Exchange - Color Space Converter
</title>
<link rel="stylesheet"   href="/matlabcentral/css/site3.css" type="text/css">
<link rel="stylesheet"   href="/matlabcentral/css/cmnty1.css" type="text/css">
</head>
<body class="cmnty1">
<table id="header" width="752" border="0" cellspacing="0" cellpadding="0" summary="header table">
  <tr>
    <td width="387"> <a href="/matlabcentral/"><img src="/matlabcentral/images/topnav/mlc_logo.gif" alt="MATLAB Central" width="236" height="28" hspace="0" vspace="0" border="0" ></a>
		<div class="small">An open exchange for the MATLAB and Simulink user community</div></td>
    <td width="383" align="right">
<SCRIPT LANGUAGE="JavaScript">

function submitForm(query){

choice = document.forms['searchForm'].elements['search_submit'].value;

if (choice == "entire1" || choice == "entire2" || choice == "contest" || choice == "matlabcentral" || choice == "blogs"){

   var searchInputNames = new Array("db","prox","rorder","rprox","rdfreq","rwfreq","rlead","sufs","order","is_summary_on","ResultCount");
   var searchInputValues = new Array("MSS","page","750","750","500","500","250","0","r","1","10");

   for (var i=0; i<searchInputNames.length; i++){
      var newElem = document.createElement("input");
      newElem.type = "hidden";
      newElem.name = searchInputNames[i];
      newElem.value = searchInputValues[i];
      document.forms['searchForm'].appendChild(newElem);
   }

   submit_action = '/cgi-bin/texis/webinator/search/';
}

switch(choice){
   case "matlabcentral":
      var newElem = document.createElement("input");
      newElem.type = "hidden";
      newElem.name = "matlabcentral";
      newElem.value = "Matlabcentral";
      document.forms['searchForm'].appendChild(newElem);

      selected_index = 0;
      break
   case "fileexchange":
      noiselist = new Array("about","after","also","an","and","another","any","are","as","at","be","$","because",
      "been","before","being","between","both","but","by","came","can","come","could","did","do","each","from",
      "got","has","had","he","have","her","here","him","himself","his","how","if","in","into","is","it","like",
      "many","me","might","most","much","must","my","never","of","on","or","other","our","out","said","same",
      "see","should","since","some","still","such","than","that","the","their","them","then","there","these",
      "they","this","those","through","to","too","up","very","was","way","we","well","were","who","with",
      "would","you","your","a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t",
      "u","v","w","x","y","z");

      query_holder = query.value;

      for(i=0;i<noiselist.length;++i) {
            var mid = new RegExp(" " + noiselist[i] + " ","gi");
            query_holder = query_holder.replace(mid," ");
            mid = new RegExp("^" + noiselist[i] + " ","i");
            query_holder = query_holder.replace(mid," ");
            mid = new RegExp(" " + noiselist[i] + "$","i");
            query_holder = query_holder.replace(mid,"");
      }

      var newElem = document.createElement("input");
      newElem.type = "hidden";
      newElem.name = "objectType";
      newElem.value = "search";
      document.forms['searchForm'].appendChild(newElem);

      var newElem = document.createElement("input");
      newElem.type = "hidden";
      newElem.name = "criteria";
      newElem.value = query.value;
      document.forms['searchForm'].appendChild(newElem);

      submit_action = "/matlabcentral/fileexchange/loadFileList.do";
      selected_index = 1;
      break
   case "cssm":
      var newElem = document.createElement("input");
      newElem.type = "hidden";
      newElem.name = "search_string";
      newElem.value = query.value;
      newElem.classname = "formelem";
      document.forms['searchForm'].appendChild(newElem);

      submit_action = "/matlabcentral/newsreader/search_results";
      selected_index = 2;
      break
   case "linkexchange":
      submit_action = "/cgi-bin/matlab/search.cgi";
      selected_index = 3;
      break
   case "blogs":
      var newElem = document.createElement("input");
      newElem.type = "hidden";
      newElem.name = "blogs";
      newElem.value = "Blogs";
      document.forms['searchForm'].appendChild(newElem);

      selected_index = 4;
      break
   case "contest":
      var newElem = document.createElement("input");
      newElem.type = "hidden";
      newElem.name = "contest";
      newElem.value = "Contest";
      document.forms['searchForm'].appendChild(newElem);

      selected_index = 5;
      break
   case "entire1":
      selected_index = 6;
      break
   case "entire2":
      selected_index = 7;
      break
   default:
      selected_index = 7;
      break
}

document.forms['searchForm'].elements['search_submit'].selectedIndex = selected_index;
document.forms['searchForm'].elements['query'].value = query.value;
document.forms['searchForm'].action = submit_action;

}

</SCRIPT>

  <form name="searchForm" method="POST" action="" style="margin:0px; margin-top:5px; font-size:90%" onSubmit="submitForm(query)">
          <label for="search">Search:</label>
        <select name="search_submit" style="font-size:9px ">
          <option value = "matlabcentral">MATLAB Central</option>
          <option value = "fileexchange" selected>&nbsp;&nbsp;&nbsp;File Exchange</option>
          <option value = "cssm">&nbsp;&nbsp;&nbsp;MATLAB Newsgroup</option>
          <option value = "linkexchange">&nbsp;&nbsp;&nbsp;Link Exchange</option>
          <option value = "blogs">&nbsp;&nbsp;&nbsp;Blogs</option>
          <option value = "contest">&nbsp;&nbsp;&nbsp;Programming Contest</option>
          <option value = "entire1">MathWorks.com</option>
          <option value = "entire2">&nbsp;&nbsp;&nbsp;All of MathWorks.com</option>
        </select>
<input type="text" name="query" size="10" class="formelem" value="">
<input type="submit" name="search" value=" Go " class="formelem" style="background-color:#1E3F74; color:#FFFFFF; font-size:90% ">
</form>

    </td>
  </tr>
</table>





<div style="width:752px; margin:-10px 0px 15px 0px; text-align:right;">
  
    <a href="/accesslogin/index_fe.do?uri=%2Fmatlabcentral%2Ffileexchange%2FloadFile.do%3FobjectId%3D7744%26ref%3Drssfeed%26id%3DmostDownloadedFiles">Login</a>
  
</div>


<table id="topnav" width="752" border="0" cellspacing="0" cellpadding="0" summary="top navigation">
  <tr id="topnavitems">
    <td id="tcell1" class="activebg" align="center" onMouseOver="this.className='hover'" onMouseOut="this.className='activebg'" onClick="document.location='/matlabcentral/fileexchange/'"><div style="border-right:1px solid gray"> <a id="tmenu1" href="/matlabcentral/fileexchange/">File Exchange</a> </div></td>
    <td id="tcell2" align="center" onMouseOver="this.className='hover'" onMouseOut="this.className=';'" onClick="document.location='/matlabcentral/newsreader/'"><div style="border-right:1px solid gray"> <a id="tmenu2" href="/matlabcentral/newsreader/">MATLAB Newsgroup</a> </div></td>
    <td id="tcell3" align="center" onMouseOver="this.className='hover'" onMouseOut="this.className=';'" onClick="document.location='/matlabcentral/link_exchange/'"><div style="border-right:1px solid gray"> <a id="tmenu3" href="/matlabcentral/link_exchange/">Link Exchange</a> </div></td>
    <td id="tcell4" align="center" onMouseOver="this.className='hover'" onMouseOut="this.className=';'" onClick="document.location='http://blogs.mathworks.com/'"><div style="border-right:1px solid gray"> <a id="tmenu4" href="http://blogs.mathworks.com/">&nbsp;&nbsp;Blogs&nbsp;&nbsp;</a> </div></td>
    <td id="tcell4" align="center" onMouseOver="this.className='hover'" onMouseOut="this.className=';'" onClick="document.location='/contest/'"><div style="border-right:1px solid gray"> <a id="tmenu4" href="/contest/">Contest</a>  </div></td>
    <!--<td id="tcell5" align="center" onMouseOver="this.className='hover'" onMouseOut="this.className=';'" onClick="document.location='/contest/'"><div style="border-right:1px solid gray"> <a id="tmenu5" href="/matlabcentral/wiki.html">&nbsp;&nbsp;Wiki&nbsp;&nbsp;</a></div></td>-->
    <td id="tcell6"  align="center" onMouseOver="this.className='hover'" onMouseOut="this.className=';'" onClick="document.location='/'"><a id="tmenu6" href="/">MathWorks.com</a> </td>
  </tr>
</table>

<br>


<div class="type1">
<table width="752" border="0" cellspacing="0" cellpadding="0">
 <tr>
   <td>

    








<div class="type2">
<table width="180" border="0" align="right" cellpadding="0" cellspacing="0">
  <tr>
    <td class="npad"><img src="/matlabcentral/images/dots_rnav_top.gif" width="180" height="9" vspace="0" hspace="0" alt=""></td>
  </tr>
  <tr>
    <td valign="top" class="npad">
     <table width="180" border="0" cellspacing="0" cellpadding="0" align="right" style="background-color:#356A9F" class="navcell">

      
      
      
      
      

        <tr>
          <td class="npad"><img src="/matlabcentral/images/nav/ltblue_top_nav_trans.gif" width="180" height="6" vspace="0" alt=""></td>
        </tr>
        

        <!--links will not work from here on only in LOCAL environment because of path -->

        <tr>
          <td width="164">
            <a href="/matlabcentral/fileexchange/loadFile.do"><img src="/matlabcentral/images/submitfile.gif" width="11" height="11" hspace="0" border="0" alt="">
              <strong>Submit a File</strong></a><br/>

              <a href="codepad.jsp" onClick="window.open(this.href,'small','location=no,toolbar=no,resizable=yes,status=yes,menu=no,scrollbars=yes,width=800,height=830');return false;" class="undrln">Now accepting MATLAB<br/>Published M-files</a>.
              </td>
        </tr>





        <tr>
            <td class="npad"><img src="/matlabcentral/images/nav/ltblue_top_nav_trans.gif" width="180" height="6" vspace="0" alt=""></td>
        </tr>
        <tr>
            <td width="164"> <a href="/matlabcentral/fileexchange/loadAuthorIndex.do"><img src="/matlabcentral/images/bullet.gif" width="5" height="7" hspace="0" border="0" alt="">
              Author Index</a> <br>
              <a href="/matlabcentral/fileexchange/loadFileList.do?objectType=fileexchange&orderBy=date&srt3=0"><img src="/matlabcentral/images/bullet.gif" width="5" height="7" hspace="0" border="0" alt="">
              Most Recent Files</a>
              <a href="/company/rss/feeds/mostRecentFiles.rss "><img src="/company/rss/xmlicon_30x12.gif" border="0" align="bottom" alt=""></a>
              <br>
              <a href="/matlabcentral/fileexchange/loadFileList.do?objectType=fileexchange&orderBy=totalDown&srt4=0"><img src="/matlabcentral/images/bullet.gif" width="5" height="7" hspace="0" border="0" align="bottom" alt="">
              Most Downloaded</a>
              <a href="/company/rss/feeds/mostDownloadedFiles.rss"><img src="/company/rss/xmlicon_30x12.gif" border="0" alt=""></a>
              <br>
              <a href="/matlabcentral/fileexchange/loadThumbIndex.do"><img src="/matlabcentral/images/bullet.gif" width="5" height="7" hspace="0" border="0" alt="">
              Screenshot Index</a> <br>
              <a href="/matlabcentral/reports/fileexchange/ratingsAndComments/"><img src="/matlabcentral/images/bullet.gif" width="5" height="7" hspace="0" border="0" alt="">
              Most Recent Comments</a> <br>
              <a href="/matlabcentral/fileexchange/filesByProduct.do"><img src="/matlabcentral/images/bullet.gif" width="5" height="7" hspace="0" border="0" alt="">
              Files By Product</a> <br>
              <a href="/matlabcentral/reports/fileexchange/"><img src="/matlabcentral/images/bullet.gif" width="5" height="7" hspace="0" border="0" alt="">
              Metrics and Reports</a> <br>

              </td>

        </tr>
        <tr>
          <td class="npad"><img src="/matlabcentral/images/nav/ltblue_top_nav_trans.gif" width="180" height="6" vspace="0" alt=""></td>
        </tr>

        
        <tr>
          <td>
            <img src="/matlabcentral/images/bullet.gif" width="5" height="7" hspace="0" border="0" alt="">&nbsp;<a href="download.do?objectId=7744&fn=colorspace&fe=.zip&cid=1094126">Download this File</a><br>
            
            </td>
        </tr>
        <tr>
          <td class="npad"><img src="/matlabcentral/images/nav/ltblue_top_nav_trans.gif" width="180" height="6" vspace="0" alt=""></td>
        </tr>
        



       
          <tr>
            <td><span style="color:white">Notify me when changes are made to this file</span><br>
                <form name="uForm" method="post" action="/matlabcentral/fileexchange/util.do"><input type="hidden" name="org.apache.struts.taglib.html.TOKEN" value="38e900ad5559be71649ecdb0a6714472">
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td><span style="color:white">E-mail:</span></td>
                    <td> <input type="text" name="emailAddress" size="10" value="" class="formelem"> </td>
                  </tr>
                  <tr>
                    <td><img src="/matlabcentral/images/spacer.gif" width="1" height="6" alt=""></td>
                    <td><img src="/matlabcentral/images/spacer.gif" width="1" height="6" alt=""></td>
                  </tr>
                  <tr>
                    <td></td>
                    <td>
                      <input type="submit" name="subscribe" value="Notify Me" class="formelem">
                    </td>
                  </tr>
                  <tr>
                    <td><img src="/matlabcentral/images/spacer.gif" width="1" height="6" alt=""></td>
                    <td><img src="/matlabcentral/images/spacer.gif" width="1" height="6" alt=""></td>
                  </tr>
                  <tr>
                    <td colspan="2"><a href="unsubscribe.jsp" onClick="window.open(this.href,'small','toolbar=no,resizable=yes,status=yes,menu=no,scrollbars=yes,width=544,height=300');return false;"><img src="/matlabcentral/images/question.gif" width="11" height="11" border="0" alt="">&nbsp;How
                      do I unsubscribe?</a> </td>
                  </tr>

                </table>
                <input type="hidden" name="objectId" value=7744 >
                <input type="hidden" name="objectType" value=FILE >
                <input type="hidden" name="catId" value=128>
                </form> </td>
          </tr>
          <tr>
            <td class="npad"><img src="/matlabcentral/images/nav/ltblue_top_nav_trans.gif" width="180" height="6" vspace="0" alt=""></td>
          </tr>
          
          <tr>
            <td colspan=2>
              <a href="javascript:PopUp('/cgi-bin/page_mail_mlc.cgi?language=en&host=www.mathworks.com&document=www.mathworks.com/matlabcentral/fileexchange/loadFile.do?ref=rssfeed%26objectId=7744%26id=mostDownloadedFiles','page_mail',true)"><img src="/matlabcentral/images/mail_brdr.gif" width="16" height="12" border="0" alt="email">
              E-mail this page to <br>
              <span style="padding-left:18px">a colleague</span></a>

            </td>
          </tr>
         <tr>
           <td valign="top" class="npad"><img src="/matlabcentral/images/nav/dots_rnav.gif" width="180" height="5" vspace="0" alt=""></td>
         </tr>


  </table>

 </td>
 </tr>
</table>

</div>
<script type="text/javascript" language="javascript">
<!--
function PopUp(page,title,which)
{
  if (which==true) {
   OpenWin = this.open('/cgi-bin/page_mail_mlc.cgi?language=en&host=www.mathworks.com&document=www.mathworks.com/matlabcentral/fileexchange/loadFile.do?ref=rssfeed%26objectId=7744%26id=mostDownloadedFiles', title, "toolbar=no,menubar=no,location=no,scrollbars=yes,resize=yes,height=385,width=440");
  } else {
   OpenWin = this.open('/cgi-bin/page_mail_mlc.cgi?language=en&host=www.mathworks.com&document=www.mathworks.com/matlabcentral/fileexchange/loadFile.do?ref=rssfeed%26objectId=7744%26id=mostDownloadedFiles', title, "toolbar=no,menubar=no,location=no,scrollbars=yes,resize=no,height=150,width=300");
  }
}
//-->
</script>

    




      <table width="572" border="0" cellspacing="0" cellpadding="0" id="breadcrmb">
         <tr>
            <td class="brdcrmbcell" height="20">
            <a href="/matlabcentral/">MATLAB Central</a> &gt;&nbsp;
            <a href="loadCategory.do">File Exchange</a> > <a href="loadCategory.do?objectId=26&objectType=Category">Image Processing</a> > <a href="loadCategory.do?objectId=128&objectType=Category">Color</a> > Color Space Converter 
            </td>
         </tr>
      </table>



    <div class="mainbody">
    <table width="536" border="0" cellspacing="0" cellpadding="0" style="background-color:#FFFFFF">
     <tr>
      <td>
        <table width="514" border="0" cellspacing="0" cellpadding="0">
          <tr>
             <td colspan="2"><table width=514 border=0 cellspacing=0 cellpadding=0 bgcolor=#FFFFFF>
<tr><td width=70% class=headercell height=20>&nbsp;Color Space Converter&nbsp;
</td><td align=right width=30% class=headercell>&nbsp;</td></tr>
<tr><td colspan=2>
<img src="/matlabcentral/images/blue_band_536x5.gif" width=536 height=5></td>
</tr></table>
</td>
          </tr>
        </table>
      </td>
      </tr>
    </table>
    <form name="dnlForm" method="post" action="/matlabcentral/fileexchange/download.do" style="margin-top:0"><input type="hidden" name="org.apache.struts.taglib.html.TOKEN" value="38e900ad5559be71649ecdb0a6714472">
    <table width="536" border="0" cellspacing="0" cellpadding="0" class="filetable">
      
            <tr>
             <td colspan=4>
               <table width="160" align="right" border="0" cellspacing="0" cellpadding="0">
                   <tr>
                      <td id="scrnshot" valign="top">
                      <div align="center"><a href="util.do?objectId=7744&imgName=colorspace.jpg" onClick="window.open(this.href,'small','toolbar=no,resizable=yes,status=yes,menu=no,scrollbars=yes,width=700,height=600');return false;">
                       <img src=http://www.mathworks.com/matlabcentral/files/7744/preview.jpg vspace="10" border="0" alt=""><br>
                       View fullsize image</font></a></div>
                       </td>
                  </tr>
              </table>
              <table width="376" border="0" cellspacing="0" cellpadding="0">

         
          
          <tr>
            <td width="10" valign="top">&nbsp;</td>
            <td><div style="padding-right:10px"><b>Download Now:</b></div></td>
            <td><input type="submit" name="Submit" value=" .zip " class="small"></td>

          </tr>
          
          <tr>
          <td width="10" valign="top">&nbsp;</td>
            <td valign="top"><b>Rating:</b>
              
            </td>
            <td>

              
              
              

              
		
                 <img src="/matlabcentral/images/fullstar.gif" width="12" height="12" hspace="1" alt=""
                ><img src="/matlabcentral/images/fullstar.gif" width="12" height="12" hspace="1" alt=""
                ><img src="/matlabcentral/images/fullstar.gif" width="12" height="12" hspace="1" alt=""
                ><img src="/matlabcentral/images/fullstar.gif" width="12" height="12" hspace="1" alt=""
                ><img src="/matlabcentral/images/halfstar.gif" width="12" height="12" hspace="1" alt=""
                >
                

                   <div style="margin-left:20px; display:inline ">
                   	<a href="loadRatings.do?objectId=7744&objectType=file&all" class="small">
                             
                             	17 reviews</a>
                             
                  &nbsp;&nbsp;<b><a href="loadFile.do?objectId=7744&objectType=file#review_submission" class="small">Review this file</a></b>
            	   </div>
               

            </td>
          </tr>

          


          
          <tr>
            <td width="10" valign="top">&nbsp;</td>
            <td width="89" valign="top"><b>Author:</b></td>
            <td colspan="2"><a href="loadAuthor.do?objectType=author&objectId=1094126">Pascal&nbsp;Getreuer</a></td>
          </tr>
          <tr>
            <td width="10" valign="top" height="15">&nbsp;</td>
            <td width="89" valign="top" height="15"><b>Summary:</b></td>
            <td height="15" colspan="2">Convert color images between RGB, YCbCr, HSV, HSL, CIE Lab, CIE Luv, CIE Lch, and more.</td>
          </tr>
          <tr>
            <td width="10" valign="top" height="15">&nbsp;</td>
            <td width="125" valign="top" height="15"><b>MATLAB Release:</b></td>
            <td height="15" valign="bottom" colspan="2">R11</td>
          </tr>

          

          

          
          <tr><td colspan="3"></td></tr>
          <tr>
            <td width="10" valign="top" height="15">&nbsp;</td>
            <td width="135" valign="top"></td>
            <td>

              <table width="95%" border="0" cellpadding="0" cellspacing="0" style="background-color:#FFFFCC; border:1px solid black; ">
              	<tr valign="top">
		  <td width="87%" style="padding:10px; background-color:#FEFEE2"><b>Editor's Notes:</b><br>
                    <br>This is a <b>File Exchange Select</b> file.
<br><br>
Select files are submissions that have been peer-reviewed and approved as meeting a high standard of utility and quality.
                 </td>
               </tr>
             </table>

            </td>
          </tr>
          <tr><td colspan="3">&nbsp;</td></tr>
          

         
               </table>
             </td>
            </tr>
         

          <tr>
            <td width="10" valign="top">&nbsp;</td>
            <td width="135" valign="top"><b>Description:</b></td>
            <td width="456" class="lnwrp">
            The M-file colorspace included in this package is a self-contained MATLAB function that converts color images between R'G'B', Y'PbPr, Y'CbCr, Y'UV, Y'IQ, Y'DbDr, JPEG-Y'CbCr, HSV, HSL, XYZ, CIE L*a*b* (CIELAB), CIE L*u*v* (CIELUV), and CIE L*ch (CIELCH).<br>
<br>
B = colorspace('dest&lt;-src', A) converts image A from color space 'src' to color space 'dest'.<br>
<br>
Example:<br>
B = colorspace('HSV&lt;-RGB',A); % Convert image A from R'G'B' to HSV<br>
C = colorspace('YCbCr&lt;-HSV',B); % Convert HSV to Y'CbCr<br>
D = colorspace('RGB&lt;-YCbCr',C); % Convert Y'CbCr back to R'G'B'<br>
<br>
See the HTML file for more information.  <br>
            </td>
         </tr>

        
              <tr>
                 <td width="10" valign="top">&nbsp;</td>
                 <td colspan="3" valign="top">&nbsp; </td>
             </tr>
             <tr>
                <td width="10" valign="top" height="15">&nbsp;</td>
                <td width="89" valign="top" height="15">
                    <b>HTML Files:</b></td>
                <td height="15" colspan="2"><a href=# onClick="var w=window.open('http://www.mathworks.com/matlabcentral/files/7744/content/colorspace/doc/colorspace.html','small','toolbar=no,location=yes,resizable=yes,status=yes,menu=no,scrollbars=yes,width=700,height=600');w.focus();">colorspace.html</a><br/></td>
            </tr>
          

           <tr>
               <td width="10" valign="top">&nbsp;</td>
               <td colspan="3" valign="top">&nbsp; </td>
           </tr>
     </table>

     <input type=hidden name="fileId" value="7744">
     <input type=hidden name="fileName" value="colorspace">
     <input type=hidden name="fileExt" value=".zip">
     <input type=hidden name="contributorId" value="1094126">
     </form>
     <br>
     <table width="536" border="0" cellspacing="0" cellpadding="0" style="background-color:#FFFFFF">
       <tr>
         <td>
          <table width="514" border="0" cellspacing="0" cellpadding="0">
            <tr>
              <td width="286"> <b class="feh4blk"> File Details</b></td>
              <td width="228">&nbsp;</td>
            </tr>
            <tr>
              <td colspan="2"><img src="/matlabcentral/images/blue_band_536x5.gif" width="536" height="5" alt=""></td>
            </tr>
          </table>
          </td>
          </tr>
      </table>
      <table width="536" border="0" cellspacing="0" cellpadding="0">
          <tr bgcolor="#F4F4F4">
            <td colspan=5 valign="top">&nbsp;</td>

          </tr>
          <tr bgcolor="#F4F4F4">
            <td width="1%" valign="top">&nbsp;</td>
            <td width="25%" valign="top"><b>File Id:</b></td>
            <td width="20%">7744</td>
            <td width="25%" valign="top"><b>Average rating:</b></td>
            <td width="29%">4.47</td>
          </tr>
          <tr bgcolor="#F4F4F4">
            <td valign="top">&nbsp;</td>
            <td valign="top"><b>Size:</b></td>
            <td>46 KB</td>
            <td valign="top"><b># of reviews:</b></td>
            <td>17</td>
          </tr>

          <tr bgcolor="#F4F4F4">
            <td valign="top">&nbsp;</td>
            <td valign="top"><b>Submitted:</b></td>
            <td>2005-05-28</td>
            <td valign="top"><b>Downloads:</b></td>
            <td>6682</td>
          </tr>

          <tr bgcolor="#F4F4F4">
            <td valign="top">&nbsp;</td>
            <td valign="top"><b>Subscribers:</b></td>
            <td>5</td>
            <td colspan="2">&nbsp;</td>
          </tr>

          <tr bgcolor="#F4F4F4">
            <td>&nbsp;</td>
            <td valign="top"><b>Keywords:</b></td>
            <td colspan="3" valign="top">color, rgb, ycbcr, hsv, hsl, cie</td>
          </tr>

          
          <tr bgcolor="#F4F4F4">
             <td width="10" valign="top">&nbsp;</td>
             <td colspan="4" valign="top">&nbsp;</td>
         </tr>
         
             <tr bgcolor="#F4F4F4">
                <td>&nbsp;</td>
                <td valign="top"><b>Zip file contents:</b></td>
                <td colspan="3" valign="top">colorspace.m,  colorspace_ciedemo.m,  colorspace_demo.m,  colorspace.html,  colorspace_01.jpg,  colorspace_02.jpg,  colorspace_03.jpg,  test_main.m</td>
             </tr>
         
     </table>
    <br>
    <!--Acknowledgements -->
    
       <table width="536" border="0" cellspacing="0" cellpadding="0" style="background-color:#FFFFFF">
        <tr>
          <td>
            <table width="514" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td width="286"> <b class="feh4blk"> Acknowledgements</b></td>
                <td width="228">&nbsp;</td>
              </tr>
              <tr>
                <td colspan="2"><img src="/matlabcentral/images/blue_band_536x5.gif" width="536" height="5" alt=""></td>
              </tr>
            </table>
            </td>
         </tr>
       </table>
       <table width="536" border="0" cellspacing="0" cellpadding="0">

      
        <tr bgcolor="#F4F4F4">
            <td width="10" rowspan="3" valign="top">&nbsp;</td>
            <td valign="top">&nbsp;</td>
          </tr>
        <tr bgcolor="#F4F4F4">
         <td colspan="2">This submission has inspired the following:</td>
        </tr>
        <tr bgcolor="#F4F4F4">
          <td colspan="2">
            
                  <a href="loadFile.do?objectId=12191&objectType=FILE">Bilateral Filtering</a><br>
            
          </td>
        </tr>

      

      <tr bgcolor="#F4F4F4">
        <td></td>
      </tr>
      </table>
      
     <!--Acknowledgements -->

      









<br>
<table width="536" border="0" cellspacing="0" cellpadding="0" style="background-color:#FFFFFF">
    <tr>
      <td>
      <table width="514" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td width="286"> <b class="feh4blk"> User Reviews</b></td>
            <td width="228"> <div align="right" class="small">Number
                of Reviews: 17</div></td>
          </tr>
          <tr>
            <td colspan="2"><img src="/matlabcentral/images/blue_band_536x5.gif" width="536" height="5" alt=""></td>
          </tr>
        </table></td>
    </tr>
 </table>

 
   <table width="536" border="0" cellspacing="0" cellpadding="3">

  
      <tr>
        <td width="9" bgcolor="#DCDFE4"></td>
        <td bgcolor="#DCDFE4"><b>Date</b>: 2007-09-09<br>
          <strong>From</strong>: alireza&nbsp;kashanipour (alireza.kashanipour@yahoo.com) <br>
          <strong>Rating</strong>:
          
              <img src="/matlabcentral/images/fullstar.gif" width="12" height="12" hspace="1" alt=""
             ><img src="/matlabcentral/images/fullstar.gif" width="12" height="12" hspace="1" alt=""
             ><img src="/matlabcentral/images/fullstar.gif" width="12" height="12" hspace="1" alt=""
             ><img src="/matlabcentral/images/fullstar.gif" width="12" height="12" hspace="1" alt=""
             ><img src="/matlabcentral/images/fullstar.gif" width="12" height="12" hspace="1" alt=""
             >
	  
          <br>
          
                <strong>Comments</strong>: oh sorry,right with you,so sorry again and tanx alot for sharing,  
          
        </td>
      </tr>
      <tr>
        <td width="10" bgcolor="#DCDFE4"></td>

      </tr>
 
      <tr>
        <td width="9" bgcolor="#DCDFE4"></td>
        <td bgcolor="#DCDFE4"><b>Date</b>: 2007-09-08<br>
          <strong>From</strong>: alireza&nbsp;kashanipour (alireza.kashanipour@yahoo.com) <br>
          <strong>Rating</strong>:
          
              <img src="/matlabcentral/images/fullstar.gif" width="12" height="12" hspace="1" alt=""
             ><img src="/matlabcentral/images/fullstar.gif" width="12" height="12" hspace="1" alt=""
             ><img src="/matlabcentral/images/fullstar_grey.gif" width="12" height="12" hspace="1" alt=""
             ><img src="/matlabcentral/images/fullstar_grey.gif" width="12" height="12" hspace="1" alt=""
             ><img src="/matlabcentral/images/fullstar_grey.gif" width="12" height="12" hspace="1" alt=""
             >
	  
          <br>
          
                <strong>Comments</strong>: the range of H in HSL space is [0,255] but your rgb2hsl function ('hsl&lt;-rgb') get value in [0,360]!!!!  
          
        </td>
      </tr>
      <tr>
        <td width="10" bgcolor="#DCDFE4"></td>

      </tr>
 
      <tr>
        <td width="9" bgcolor="#DCDFE4"></td>
        <td bgcolor="#DCDFE4"><b>Date</b>: 2007-09-06<br>
          <strong>From</strong>: ali&nbsp;fotouhi  <br>
          <strong>Rating</strong>:
          
              <img src="/matlabcentral/images/fullstar.gif" width="12" height="12" hspace="1" alt=""
             ><img src="/matlabcentral/images/fullstar.gif" width="12" height="12" hspace="1" alt=""
             ><img src="/matlabcentral/images/fullstar.gif" width="12" height="12" hspace="1" alt=""
             ><img src="/matlabcentral/images/fullstar.gif" width="12" height="12" hspace="1" alt=""
             ><img src="/matlabcentral/images/fullstar.gif" width="12" height="12" hspace="1" alt=""
             >
	  
          <br>
          
                <strong>Comments</strong>:   
          
        </td>
      </tr>
      <tr>
        <td width="10" bgcolor="#DCDFE4"></td>

      </tr>
 
  </table>
  <BR>

  
        <img src="/matlabcentral/images/submitfile.gif" width="9" height="11" border="0" alt="">
        <a href= "loadRatings.do?objectId=7744&objectType=file&all=true">See more reviews</a>
  

 


<form name="rForm" method="post" action="/matlabcentral/fileexchange/saveRating.do"><input type="hidden" name="org.apache.struts.taglib.html.TOKEN" value="38e900ad5559be71649ecdb0a6714472">
<input type=hidden name=objectType value=>
<input type=hidden name=objectId value=7744>

<br>
  <table width="536" border="0" cellspacing="0" cellpadding="0" style="background-color:#FFFFFF">
    <tr>
      <td> <table width="514" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td width="286"> <b class="feh4blk"><a name="review_submission"> Review this Submission</a></b></td>
            <td width="240"> <div align="right"> <img src="/matlabcentral/images/doc.gif" width="9" height="11" border="0" alt="">
              <a href="ratingGuidelines.jsp" onClick="window.open(this.href,'small','toolbar=no,resizable=yes,status=yes,menu=no,scrollbars=yes,width=536,height=320');return false;">Guidelines for Reviewing a Submission</a></div></td>
          </tr>
          <tr>
            <td colspan="2"><img src="/matlabcentral/images/blue_band_536x5.gif" width="536" height="5" alt=""></td>
          </tr>
        </table></td>
    </tr>
  </table>
  <table width=536 cellpadding="2" cellspacing="2" bgcolor="#DCDFE4" border="0">
    <tr valign="top">
      <td colspan="3"><b><img src="/matlabcentral/images/exclamation.gif" alt="" width="12" height="11">
        Bold Indicates Required Information</b> </td>
    </tr>
    <tr valign="top">
      <td width="89"> Overall Rating: </td>
    </tr>
    <tr>
      <td align="left">
         <table width="272" cellspacing="2" cellpadding="2" bgcolor="#DCDFE4" border="0">
            <tr align="left" class="small">
               <td colspan="3"><input type="radio" name="numericRating" value="0" checked="checked">&nbsp;<span class="small">General Comments</span>&nbsp;&nbsp;</td>
            </tr>
            <tr align="left" class="small">
               <td colspan="3"><input type="radio" name="numericRating" value="1">&nbsp;1&nbsp;&nbsp;<span class="small">Poor</span></td>
            </tr>
            <tr align="left" class="small">
               <td colspan="3"><input type="radio" name="numericRating" value="2">&nbsp;2&nbsp;&nbsp;<span class="small">Needs Improvement</span></td>
            </tr>
            <tr align="left" class="small">
               <td colspan="3"><input type="radio" name="numericRating" value="3">&nbsp;3&nbsp;&nbsp;<span class="small">Fair</span></td>
            </tr>
            <tr align="left" class="small">
               <td colspan="3"><input type="radio" name="numericRating" value="4">&nbsp;4&nbsp;&nbsp;<span class="small">Good</span></td>
            </tr>
            <tr align="left" class="small">
               <td colspan="3"><input type="radio" name="numericRating" value="5">&nbsp;5&nbsp;&nbsp;<span class="small">Excellent</span></td>
            </tr>
            <tr>
              <td colspan="3">&nbsp;</td>
            </tr>
            <tr>
               <td>Comments:</td>
               <td width="175">&nbsp;</td>
               <td width="248">&nbsp;</td>
            </tr>
            <tr>
               <td colspan="3">
                  <textarea name="comment" cols="45" rows="5"></textarea>
               </td>
            </tr>
            <tr>
               <td><b>First Name:</b></td>
               <td><input type="text" name="firstName" size="25" value=""></td>
               <td align="right">&nbsp;</td>
            </tr>
            <tr>
               <td><b>Last Name:</b></td>
               <td><input type="text" name="lastName" size="25" value=""></td>
               <td align="right">&nbsp;</td>
            </tr>
            <tr>
               <td>E-mail:</td>
               <td><input type="text" name="email" size="25" value=""></td>
               <td align="right">&nbsp;</td>
            </tr>
            <tr>
               <td>Organization:</td>
               <td><input type="text" name="organization" size="25" value=""></td>
               <td align="right">&nbsp;</td>
            </tr>

            <tr>
               <td></td>
               <td><img src="Captcha.jpg"></td>
               <td align="right">&nbsp;</td>
            </tr>
            <tr>
               <td><b>Spam Prevention:</b></td>
               <td><input type="text" name="spamPrevention" size="25" value=""/></td>
               <td align="right">&nbsp;</td>
            </tr>
            <tr>
               <td colspan="2">Please type the characters you see in the picture above.</td>
               <td align="right">&nbsp;</td>
            </tr>

            <tr>
               <td width="10" align="right">&nbsp; </td>
               <td align="right"><input type="submit" name="SubmitRating" value="Submit Rating" class="small"></td>
               <td align="right">&nbsp;</td>
            </tr>
            <tr>
               <td colspan="3">&nbsp; </td>
            </tr>
        </table>
      </td>
    </tr>
  </table>

 </form>






  <!--Modification Comments -->
    
       <table width="536" border="0" cellspacing="0" cellpadding="0" style="background-color:#FFFFFF">
        <tr>
          <td>
            <table width="514" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td width="286"> <b class="feh4blk"> Changes</b></td>
                <td width="228">&nbsp;</td>
              </tr>
              <tr>
                <td colspan="2"><img src="/matlabcentral/images/blue_band_536x5.gif" width="536" height="5" alt=""></td>
              </tr>
            </table>
            </td>
         </tr>
       </table>
       <table width="536" border="0" cellspacing="0" cellpadding="0">
          <tr bgcolor="#F4F4F4">
            <td colspan="2">&nbsp;</td>
          </tr>
          
                  <tr bgcolor="#F4F4F4">
                    <td width=100 valign="top">2006-08-13</td>
                    <td>Created Select structure, added support for CIE color spaces</td>
                  </tr>
            

          <tr bgcolor="#F4F4F4">
            <td colspan="2">&nbsp;</td>
          </tr>
      </table>
      

  <br>
   <table width="536" border="0" cellspacing="0" cellpadding="0" style="background-color:#FFFFFF">
        <tr>
          <td>
            <table width="514" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td width="286"> <b class="feh4blk"></b></td>
                <td width="228">&nbsp;</td>
              </tr>
              <tr>
                <td colspan="2"><img src="/matlabcentral/images/blue_band_536x5.gif" width="536" height="5" alt=""></td>
              </tr>
            </table>
            </td>
         </tr>
       </table>

      <form name="dnlForm" method="post" action="/matlabcentral/fileexchange/download.do" style="margin-top:0"><input type="hidden" name="org.apache.struts.taglib.html.TOKEN" value="38e900ad5559be71649ecdb0a6714472">
      <table width="536" border="0" cellspacing="0" cellpadding="0" >
          <tr bgcolor="#F4F4F4">
            <td width="10" valign="top" bgcolor="#DCDFE4">&nbsp;</td>
            <td width="456" colspan="2" bgcolor="#DCDFE4"><strong>Download Now:</strong>
                <input type="submit" name="Submit" value=" .zip " class="small">
            </td>
          </tr>

      </table>

      <input type=hidden name="fileId" value="7744">
     <input type=hidden name="fileName" value="colorspace">
     <input type=hidden name="fileExt" value=".zip">
     <input type=hidden name="contributorId" value="1094126">
     </form>
      </div>
     </td>
   </tr>
 </table>
 </div>
 <br><br>
<br/>
<table width="543" border="0" cellpadding="0" cellspacing="0">
  <tr>
    <td colspan="2" style="padding-left:10px">
                <div class="smallgrey">
		<strong>Public Submission Policy</strong><br>
		NOTICE: Any content you submit to MATLAB Central, including personal information, is not subject to the protections which may be afforded information collected under other sections of The MathWorks, Inc. Web site. You are entirely responsible for
		all content that you upload, post, e-mail, transmit or otherwise make available via MATLAB Central. The MathWorks does not control the content posted by visitors to MATLAB Central and, does not guarantee the accuracy, integrity, or quality of such content.
		Under no circumstances will The MathWorks be liable in any way for any content not authored by The MathWorks, or any loss or damage of any kind incurred as a result of the use of any content posted, e-mailed, transmitted or otherwise made available
		via MATLAB Central. <a href="/matlabcentral/disclaimer.html" class="small">Read the complete Disclaimer prior to use.</a>
              </div>
  </td>
 </tr>
 </table>
<br/>

<table width="543" border="0" cellpadding="0" cellspacing="0" id="relatedtopics">
		<tr>
				<td><strong>Related Topics </strong></td>
		</tr>
		<tr>
				<td id="topicslinks"> <a href="/products/new_products/index.html">New Products</a>&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;<a href="/support/">Support</a>&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;<a href="/access/helpdesk/help/helpdesk.html">Documentation</a>&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;<a href="/services/training/">Training</a>&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;<a href="/company/events/">Webinars</a>&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;<a href="/company/jobs/">Careers</a>&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;<a href="/company/newsletters/">Newsletters</a>&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;<a href="/company/rss">RSS</a></td>
		</tr>
</table>
<table width="752" border="0" id="footer">
		<tr>
			<td class="small">Problems? Suggestions? Contact us at <a href="mailto:files@mathworks.com">files@mathworks.com</a> </td>
				<td align="right" class="small"> &copy;  1994-2007 The MathWorks, Inc.    <a href="/company/aboutus/policies_statements/trademarks.html">Trademarks</a>&nbsp;&nbsp;&nbsp;&nbsp;<a href="/company/aboutus/policies_statements/">Privacy Policy</a></td>
		</tr>
</table>

<!-- Begin The MathWorks Omniture SiteCatalyst code version: H.4. --> <script language="JavaScript" type="text/javascript" src="http://www.mathworks.com/includes_content/jscript/omniture/s_code.js"></script>
<script language="JavaScript" type="text/javascript"><!-- s.pageName=""
s.server=""
s.channel=""
s.pageType=""
s.prop1=""
s.prop2=""
s.prop3=""
s.prop4=""
s.prop5=""
s.prop6=""
s.prop7=""
s.prop8=""
s.prop9=""
s.prop10=""
s.campaign=""
s.state=""
s.zip=""
s.events=""
s.products=""
s.purchaseID=""
s.eVar1=""
s.eVar2=""
s.eVar3=""
s.eVar4=""
s.eVar5=""
/************* DO NOT ALTER ANYTHING BELOW THIS LINE ! **************/ var s_code=s.t();if(s_code)document.write(s_code)//--></script>

<script language="JavaScript" type="text/javascript"><!--
if(navigator.appVersion.indexOf('MSIE')>=0)document.write(unescape('%3C')+'\!-'+'-')
//--></script><!--/DO NOT REMOVE/-->
<!-- End The MathWorks Omniture SiteCatalyst code version: H.4. -->


</body>
</html>
