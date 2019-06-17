<%@ Control Language="C#" AutoEventWireup="true" CodeFile="DiagnosticDLA.ascx.cs" Inherits="ActivityPages_Harbor_Client_Detail_Documents_DiagnosticAssessment_DiagnosticDLA" %>
<input type="hidden" id="hiddenReletivePath" value='<%=RelativePath%>' />
<div>
<table border="0"  cellpadding="0" cellspacing="0" class="DocumentScreen">
 <tr>
   <td>
   
<table border="0"  cellpadding="0" cellspacing="0" width="99%">
    <tr>
        <td class="padding_label1">
            <table border="0" cellspacing="0" cellpadding="0" width="99%">
                <tr>
                    <td class="height3">
                     </td>
                </tr>
                <tr>
                    <td>
                        <table border="0" cellspacing="0" cellpadding="0" width="100%">
                            <tr>
                                <td class="content_tab_left" align="left" nowrap='nowrap'>
                                    Instructions
                                </td>
                                <td width="17">
                                    <img style="vertical-align: top" src="<%=WebsiteSettings.BaseUrl %>App_Themes/Includes/Images/content_tab_sep.gif"
                                        width="17" height="26" alt="" />
                                </td>
                                <td class="content_tab_top" width="100%">
                                </td>
                                <td width="7">
                                    <img style="vertical-align: top" src="<%=WebsiteSettings.BaseUrl %>App_Themes/Includes/Images/content_tab_right.gif"
                                        width="7" height="26" alt="" />
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td class="content_tab_bg">
                        <table border="0" cellspacing="0" cellpadding="0" width="99%">
                            <tr>
                               <td style="width:1%">
                               </td>
                                <td  style="width:99%">
                                   <span class="form_label">Use the scales below to determine how often or how well daily living activities
                                    were performed or managed independently during the 
                                    </span>
                                </td>
                            </tr>
                            <tr>
                               <td style="width:1%">
                               </td>
                                <td  style="width:99%">
                                   <span class="form_label">last 30 days. Enter N/A if the
                                    activity was not assessed due to inadequate information.
                                    </span>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td>
                        <table border="0" cellspacing="0"  cellpadding="0" width="100%">
                            <tr>
                                <td width="2" class="right_bottom_cont_bottom_bg">
                                    <img style="vertical-align: top" src="<%=WebsiteSettings.BaseUrl %>App_Themes/Includes/Images/right_bottom_cont_bottom_left.gif"
                                        height="7" alt="" />
                                </td>
                                <td class="right_bottom_cont_bottom_bg" width="100%">
                                </td>
                                <td width="2" class="right_bottom_cont_bottom_bg" align="right">
                                    <img style="vertical-align: top" src="<%=WebsiteSettings.BaseUrl %>App_Themes/Includes/Images/right_bottom_cont_bottom_right.gif"
                                        height="7" alt="" />
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    
    <tr>
        <td class="padding_label1">
            <table border="0" cellspacing="0" cellpadding="0" width="99%">
                <tr>
                    <td class="height3">
                    </td>
                </tr>
                <tr>
                    <td>
                        <table border="0" cellspacing="0" cellpadding="0" width="100%">
                            <tr>
                                <td class="content_tab_left" align="left" nowrap='nowrap'>
                                    Activities
                                </td>
                                <td width="17">
                                    <img style="vertical-align: top" src="<%=WebsiteSettings.BaseUrl %>App_Themes/Includes/Images/content_tab_sep.gif"
                                        width="17" height="26" alt="" />
                                </td>
                                <td class="content_tab_top" width="100%">
                                </td>
                                <td width="7">
                                    <img style="vertical-align: top" src="<%=WebsiteSettings.BaseUrl %>App_Themes/Includes/Images/content_tab_right.gif"
                                        width="7" height="26" alt="" />
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td class="content_tab_bg">
                        <div id="DivActivityContent">
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <table border="0" cellspacing="0" cellpadding="0" width="100%">
                            <tr>
                                <td width="2" class="right_bottom_cont_bottom_bg">
                                    <img style="vertical-align: top" src="<%=WebsiteSettings.BaseUrl %>App_Themes/Includes/Images/right_bottom_cont_bottom_left.gif"
                                        height="7" alt="" />
                                </td>
                                <td class="right_bottom_cont_bottom_bg" width="100%">
                                </td>
                                <td width="2" class="right_bottom_cont_bottom_bg" align="right">
                                    <img style="vertical-align: top" src="<%=WebsiteSettings.BaseUrl %>App_Themes/Includes/Images/right_bottom_cont_bottom_right.gif"
                                        height="7" alt="" />
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>
</td>
 </tr>
</table>
<div id="DivScaleMessage" style="display: none; background-color: white; outline:1px; top: 80px; border: 3px #1C5B94 solid; 
    height: 150px; width: 730px; z-index: 1000; position: absolute;">
    <table border="0" width="100%" cellpadding="0" cellspacing="0">
    
        <tr>
            <td align="center">
                <table class="PopUpTitleBar" border="0" cellpadding="0" cellspacing="0" width="99%">
                    <tr>
                        <td id="topborder" class="TitleBarText LPadd5">
                            Streamline SmartCare
                        </td>
                        <td align="left" width="10px">
                            <a href="#">
                                <img id="ImgCross" src=" <%=Page.ResolveUrl("~")%>App_Themes/Includes/Images/cross.jpg"
                                    title="Close" onclick="DivScaleMessageHide()" alt="Close" />
                            </a>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        
        <tr>
            <td>
               <span class="form_label">  1 – None of the time; extremely severe impairment or problems in functioning; pervasive
                level of continuous paid supports needed.<br />
                2 – A little of the time; severe impairment or problems in functioning; extensive
                level of continuous paid supports needed.
                <br />
                3 – Occasionally; moderately severe impairment or problems in functioning; moderate
                level of continuous paid supports needed.<br />
                4 – Some of the time; moderate impairment or problems in functioning; moderate level
                of continuous paid supports needed.<br />
                5 – A good bit of the time; mild impairment or problems in functioning; moderate
                level of intermittent paid supports needed.<br />
                6 – Most of the time; very mild impairment or problems in functioning; low level
                of intermittent paid supports needed.<br />
                7 – All of the time; no significant impairment or problems in functioning requiring
                paid supports.<br /></span>
            </td>
        </tr>
        
     </table>
</div>
</div>