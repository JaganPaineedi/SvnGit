<%@ Control Language="C#" AutoEventWireup="true" CodeFile="DLAScalePopup.ascx.cs" Inherits="Custom_MentalHealthAssessment_WebPages_DLAScalePopup" %>
<input type="hidden" runat = "server" id="hiddenScores" />
<script type="text/javascript">
    $(function() {
    if (parent.SCDLAY.DLAYouthClicked == true) {
        $("#divScores").hide();
        $("#divYouthDLAScores").show();
    }
    else {
        $("#divYouthDLAScores").hide();
        $("#divScores").show();
    }
   // $('#tableScores')[0].innerHTML = $('input[type=hidden][id$=hiddenScores]').val();
});
var selectedscore = 0;
if (parent.SCDLAY.DLAYouthClicked == true) {
    $("#divScores").hide();
    $("#divYouthDLAScores").show();
}
else {
    $("#divYouthDLAScores").hide();
    $("#divScores").show();
}
function setScore(score,row) {
    $('input[id$=hiddenScores]').val(score);
    row.style.backgroundColor = '#f0f6f9';
    selectedscore = score;
}
function SetScoreAndClose() {
    if (parent.SCDLAY.DLAYouthClicked == true && parent.SCDLAY.SetScoreValueAndClose != "undefined" && typeof parent.SCDLAY.SetScoreValueAndClose == "function") {
        parent.SCDLAY.SetScoreValueAndClose(selectedscore);
    } else {
        parent.SetScoreValueAndClose(selectedscore)
    }
    parent.CloaseModalPopupWindow();
}
function changebgcolor(row, color, score) {
    if (score != selectedscore) {
        row.style.backgroundColor = color;
    }

    $("#tableScores tr[score!=" + score + "]").each(function() {
        var scorevalue = $(this).attr("score");
        if (scorevalue != selectedscore) {
            if (((parseInt(scorevalue)) % 2) > 0)
                this.style.backgroundColor = '#F0F0F0';
            else
                this.style.backgroundColor = '#E0E0E0';
        }
    });
}
</script>
<% if (HttpContext.Current == null)
   { %>
<link href="<%= RelativePath%>App_Themes/Styles/smartcare_styles.css" rel="stylesheet"
    type="text/css" />
<link href="<%= RelativePath%>App_Themes/Styles/SmartCare_Styles.css" rel="stylesheet" type="text/css" />

<%} %>


<style type="text/css">
   .header
    {
        background-image: url(../App_Themes/Vista/Grid/bg.gif);
        background-repeat: no-repeat;
        background-position: center right;
        cursor: pointer;
    }
    .GridClass th
    {
        padding: 0px 0px 0px 5px;
        height: 24px;
    }
    .GridClass td
    {
        padding: 0px 0px 0px 0px;
    }
    .theader, .tcontent
    {
        color: black;
    }
    table.tblSort.even
    {
        background-color: red;
    }
    .NormRow
    {
        background-color: RGB(240,246,249);
    }
    .AltRow
    {
        background-color: #FFFFFF;
    }
    
</style>
<div style="overflow:auto;height:200px" id="divScores">
  <table id="tableScores"  style="height:200px; padding-left:10px;"  border="0" cellspacing="0" cellpadding="0" class="ListPageContainer">
   <tr style="background-color: #F0F0F0;" score = "1" onclick="setScore(1,this)" onmouseout ="changebgcolor(this,'#F0F0F0',1)">
   <td><label>1 – None of the time; extremely severe impairment or problems in functioning; pervasive level of continuous paid supports needed.</label></td>
   </tr> 
   <tr  style="background-color: #E0E0E0;" score = "2"  onclick="setScore(2,this);" onmouseout ="changebgcolor(this,'#E0E0E0',2)">
   <td><label>2 – A little of the time; severe impairment or problems in functioning; extensive level of continuous paid supports needed.</label></td>
   </tr> 
   <tr style="background-color: #F0F0F0;" score = "3"  onclick="setScore(3,this);" onmouseout ="changebgcolor(this,'#F0F0F0',3)">
   <td ><label>
   3 – Occasionally; moderately severe impairment or problems in functioning; moderate level of continuous paid supports needed.</label>
   </td>
   </tr>
   <tr  style="background-color: #E0E0E0;" score = "4"  onclick="setScore(4,this);"  onmouseout ="changebgcolor(this,'#E0E0E0',4)">
     <td><label>4 – Some of the time; moderate impairment or problems in functioning; moderate level of continuous paid supports needed.</label></td>
   </tr>
   <tr style="background-color: #F0F0F0;" score = "5"  onclick="setScore(5,this);" onmouseout ="changebgcolor(this,'#F0F0F0',5)">
   <td>
   <label>5 – A good bit of the time; mild impairment or problems in functioning; moderate level of intermittent paid supports needed.</label>
   </td>
   </tr>
   <tr  style="background-color: #E0E0E0;" score = "6"  onclick="setScore(6,this);"  onmouseout ="changebgcolor(this,'#E0E0E0',6)">
   <td>
   <label>6 – Most of the time; very mild impairment or problems in functioning; low level of intermittent paid supports needed.</label>
   </td>
   </tr>
   <tr style="background-color: #F0F0F0;" score = "7"  onclick="setScore(7,this);"  onmouseout ="changebgcolor(this,'#F0F0F0',7)">
   <td>
   <label>7 – All of the time; no significant impairment or problems in functioning requiring paid supports.</label>
   </td>
   </tr>
    <tr> 
    <td  style="padding-left:280px">
       <span   type="button" text="OK" id="Button_OK" name="Button_OK" onclick="return SetScoreAndClose();">
                            </span>
    </td>
    </tr>
  </table>
</div>
<div style="overflow:auto;height:200px" id="divYouthDLAScores">
  <table id="table1"  style="height:200px; padding-left:10px;"  border="0" cellspacing="0" cellpadding="0" class="ListPageContainer">
   <tr style="background-color: #F0F0F0;" score = "1" onclick="setScore(1,this)" onmouseout ="changebgcolor(this,'#F0F0F0',1)">
   <td><label>1 – None of the time; Pervasive, continuous intervention required- Dysfunctional; Extremely severe disabling impairment.</label></td>
   </tr> 
   <tr  style="background-color: #E0E0E0;" score = "2"  onclick="setScore(2,this);" onmouseout ="changebgcolor(this,'#E0E0E0',2)">
   <td><label>2 – Almost never; Not functional; Dependent; Severe Impairments.</label></td>
   </tr> 
   <tr style="background-color: #F0F0F0;" score = "3"  onclick="setScore(3,this);" onmouseout ="changebgcolor(this,'#F0F0F0',3)">
   <td ><label>
   3 – Occasionally; Functioning depends on continuous support; Serious substantial Impairment.</label>
   </td>
   </tr>
   <tr  style="background-color: #E0E0E0;" score = "4"  onclick="setScore(4,this);"  onmouseout ="changebgcolor(this,'#E0E0E0',4)">
     <td><label>4 – Some of the time; marginal independence Low Level of continuous support; Moderate Impairment.</label></td>
   </tr>
   <tr style="background-color: #F0F0F0;" score = "5"  onclick="setScore(5,this);" onmouseout ="changebgcolor(this,'#F0F0F0',5)">
   <td>
   <label>5 – A good bit of the time (WNL); Independent with moderate, routine support; Mild problems; social, job.</label>
   </td>
   </tr>
   <tr  style="background-color: #E0E0E0;" score = "6"  onclick="setScore(6,this);"  onmouseout ="changebgcolor(this,'#E0E0E0',6)">
   <td>
   <label>6 – Most of the time (WNL); Independent with intermittent support or follow-up; Intermittent problem.</label>
   </td>
   </tr>
   <tr style="background-color: #F0F0F0;" score = "7"  onclick="setScore(7,this);"  onmouseout ="changebgcolor(this,'#F0F0F0',7)">
   <td>
   <label>7 – All of the time (WNL); Optimal & independent asset; no problem.</label>
   </td>
   </tr>
    <tr> 
    <td  style="padding-left:280px">
       <span   type="button" text="OK" id="Span1" name="Button_OK" onclick="return SetScoreAndClose();">
                            </span>
    </td>
    </tr>
  </table>
</div>