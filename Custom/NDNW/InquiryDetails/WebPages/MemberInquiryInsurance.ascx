<%@ Control Language="C#" AutoEventWireup="true" CodeFile="MemberInquiryInsurance.ascx.cs"
    Inherits="Custom_InquiryDetails_WebPages_MemberInquiryInsurance" %>
<%@ Register Assembly="Streamline.DotNetDropDownGlobalCodes" Namespace="Streamline.DotNetDropDownGlobalCodes"
    TagPrefix="DropDownGlobalCodes" %>
<%@ Register Assembly="Streamline.DotNetDropDowns" Namespace="Streamline.DotNetDropDowns"
    TagPrefix="DotNetDropDowns" %>
<%@ Register Src="~/CommonUserControls/VerifyEligibility.ascx" TagName="VerifyEligibility"
    TagPrefix="uc1" %>

<table cellspacing="0" cellpadding="0" border="0" style="width: 830px" id="tblInquiryOtherInfo">
    <tr>
        <td>
            <table cellspacing="0" cellpadding="0" border="0" width="99.5%">
                <tr>
                    <td>
                        <uc1:VerifyEligibility runat="server" ID="eev1" />
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td>
            <table cellspacing="0" cellpadding="0" border="0" width="100%">
                <tr>
                    <td class="content_tab_left" align="left" nowrap='nowrap'>Coverage Information
                    </td>
                    <td width="17">
                        <img style="vertical-align: top;" height="26" width="17" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_sep.gif" />
                    </td>
                    <td class="content_tab_top" width="100%" />
                    <td width="7">
                        <img style="vertical-align: top;" height="26" width="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_right.gif" />
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class="content_tab_bg">
            <table border="0" cellpadding="3" cellspacing="3" width="95%" Id="TableId">
                <tr>
                    <td style="white-space: nowrap; padding-left: 10px; width: 2%"></td>
                    <td style="white-space: nowrap; width: 20%;padding-left:2px;">
                        <b>Plan</b>
                    </td>
                    <td style="white-space: nowrap; width: 12%;padding-left:8px;">
                        <b>Insured ID</b>
                    </td>
                    <td style="white-space: nowrap; width: 12%;padding-left:4px;">
                        <b>Group ID</b>
                    </td>
                    <%--<td style="white-space: nowrap; width: 20%">
                        <b><u>Appointment Type</u></b>
                    </td>--%>
                    <td style="white-space: nowrap; width: 20%;padding-left:2px;">
                        <b>Comment</b>
                    </td>
                </tr>
            </table>
            <table id="appointmentContainer" border="0" cellpadding="3" cellspacing="3" width="100%">
            </table>
            <table border="0" cellpadding="3" cellspacing="3" width="100%">
                <tr>
                    <td align="right" style="white-space: nowrap; width: 100%; padding-right: 10px">
                        <span type="button" text="   Add   " onclick="return AddNewCoverageInformation();"></span>
                    </td>
                </tr>
            </table>
        </td>
    </tr>

    <tr>
        <td>
            <table cellspacing="0" cellpadding="0" border="0" width="100%">
                <tr>
                    <td class="right_bottom_cont_bottom_bg" width="2">
                        <img style="vertical-align: top;" height="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/right_bottom_cont_bottom_left.gif" />
                    </td>
                    <td class="right_bottom_cont_bottom_bg" width="100%"></td>
                    <td style="vertical-align: top;" class="right_bottom_cont_bottom_bg" align="right" width="2">
                        <img style="vertical-align: top;" height="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/right_bottom_cont_bottom_right.gif" />
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td style="padding-top: 10px">
            <table cellspacing="0" cellpadding="0" border="0">
                <tr>
                    <td class="content_tab_left" align="left" nowrap='nowrap'>
                        <span class="form_label" id="Span20">Income/Fee</span>
                    </td>
                    <td width="17px">
                        <img style="vertical-align: top;" height="26" width="17px" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_sep.gif" />
                    </td>
                    <td class="content_tab_top" width="100%"></td>
                    <td width="7">
                        <img style="vertical-align: top;" height="26" width="17px" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_right.gif" />
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class="content_tab_bg" style="padding-left: 8px">
            <table cellspacing="0" cellpadding="0" border="0" width="99%">
                <tr>
                    <td style="padding-top: 10px">
                        <table cellspacing="0" cellpadding="0" border="0">
                            <tr>
                                <td class="content_tab_left" align="left" nowrap='nowrap'>
                                    <span class="form_label" id="Span1">General</span>
                                </td>
                                <td width="17px">
                                    <img style="vertical-align: top;" height="26" width="17px" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_sep.gif" />
                                </td>
                                <td class="content_tab_top" width="100%"></td>
                                <td width="7">
                                    <img style="vertical-align: top;" height="26" width="17px" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_right.gif" />
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td class="content_tab_bg" style="padding-left: 8px">
                        <table cellspacing="0" cellpadding="0" border="0" width="100%">
                            <tr>
                                <td class="checkbox_container" colspan="4">
                                    <input type="checkbox" id="CheckBox_CustomInquiries_IncomeGeneralHeadHousehold" />
                                    <label for="CheckBox_CustomInquiries_IncomeGeneralHeadHousehold">
                                        Head of Household</label>
                                </td>
                            </tr>
                            <tr>
                                <td class="height2"></td>
                            </tr>
                            <tr>
                                <td style="width: 15%;">
                                    <span id="Span_EmergencyContact">Household Composition</span>
                                </td>
                                <td style="width: 30%;">
                                    <DropDownGlobalCodes:DropDownGlobalCodes ID="DropDownList_CustomInquiries_IncomeGeneralHouseholdComposition"
                                        runat="server" Category="XINQUIRYHOUSEHOLD" AddBlankRow="true" CssClass="form_dropdown">
                                    </DropDownGlobalCodes:DropDownGlobalCodes>                                   
                                </td>    
                                <td style="width: 3%;">
                                    &nbsp;
                                </td>                           
                                <td style="width: 15%;">
                                    <span id="Span2"># of Dependants</span>
                                </td>
                                <td style="width: 30%;padding-left:4px;" >
                                    <input id="TextBox_CustomInquiries_IncomeGeneralDependents" name="TextBox_CustomInquiries_IncomeGeneralDependents"
                                        type="text" class="form_textbox" style="width: 75px;" datatype="Numeric"/>
                                </td>
                            </tr>
                            <tr>
                                <td class="height2"></td>
                            </tr>
                            <tr>
                                <td>
                                    <span id="Span3"># in Household</span>
                                </td>
                                <td>
                                    <input id="TextBox_CustomInquiries_IncomeGeneralHousehold" name="TextBox_CustomInquiries_IncomeGeneralHousehold"
                                        type="text" class="form_textbox" style="width: 60px;" datatype="Numeric"/>
                                </td>
                                <td>
                                    &nbsp;
                                </td>  
                                <td>
                                    <span id="Span4">Household Annual Income</span>
                                </td>
                                <td style="padding-left:4px;">
                                    <input id="TextBox_CustomInquiries_IncomeGeneralHouseholdAnnualIncome" name="TextBox_CustomInquiries_IncomeGeneralHouseholdAnnualIncome"
                                        type="text" class="form_textbox" style="width: 100px;" datatype="Currency" maxlength="15"/>
                                </td>
                            </tr>
                            <tr>
                                <td class="height2"></td>
                            </tr>
                            <tr>
                                <td>
                                    <span id="Span5">Client Annual Income</span>
                                </td>
                                <td>
                                    <input id="TextBox_CustomInquiries_IncomeGeneralAnnualIncome" name="TextBox_CustomInquiries_IncomeGeneralAnnualIncome"
                                        type="text" class="form_textbox" style="width: 100px;"  datatype="Currency" maxlength="15" onblur="Calculation(id)"/>
                                </td>
                                <td>
                                    &nbsp;
                                </td>
                                <td>
                                    <span id="Span6">Primary Source</span>
                                </td>
                                <td style="padding-left:4px;">
                                    <DropDownGlobalCodes:DropDownGlobalCodes ID="DropDownList_CustomInquiries_IncomeGeneralPrimarySource"
                                        runat="server" Category="XINQUIRYPSOURCE" AddBlankRow="true" CssClass="form_dropdown">
                                    </DropDownGlobalCodes:DropDownGlobalCodes>                                    
                                </td>
                            </tr> 
                            <tr>
                                <td class="height2"></td>
                            </tr>
                            <tr>
                                <td>
                                    <span id="Span7">Client Monthly Income</span>
                                </td>
                                <td>
                                    <input id="TextBox_CustomInquiries_IncomeGeneralMonthlyIncome" name="TextBox_CustomInquiries_IncomeGeneralMonthlyIncome"
                                        type="text" class="form_textbox" style="width: 100px;" datatype="Currency" maxlength="15" onblur="Calculation(id)"/>
                                </td>
                                <td>
                                    &nbsp;
                                </td>
                                <td>
                                    <span id="Span8">Alternative Source</span>
                                </td>
                                <td style="padding-left:4px;">
                                    <DropDownGlobalCodes:DropDownGlobalCodes ID="DropDownList_CustomInquiries_IncomeGeneralAlternativeSource"
                                        runat="server" Category="XINQUIRYPSOURCE" AddBlankRow="true" CssClass="form_dropdown">
                                    </DropDownGlobalCodes:DropDownGlobalCodes>                                      
                                </td>
                            </tr>

                        </table>
                    </td>
                </tr>
                <tr>
                    <td>
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td width="1%" class="right_bottom_cont_bottom_bg">
                                    <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/right_bottom_cont_bottom_left.gif"
                                        height="7" alt="" />
                                </td>
                                <td class="right_bottom_cont_bottom_bg" width="98%"></td>
                                <td width="1%" class="right_bottom_cont_bottom_bg" align="right">
                                    <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/right_bottom_cont_bottom_right.gif"
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
        <td class="content_tab_bg" style="padding-left: 8px">
            <table cellspacing="0" cellpadding="0" border="0" width="99%">
                <tr>
                    <td style="padding-top: 10px">
                        <table cellspacing="0" cellpadding="0" border="0">
                            <tr>
                                <td class="content_tab_left" align="left" nowrap='nowrap'>
                                    <span class="form_label" id="Span9">Special Fee</span>
                                </td>
                                <td width="17px">
                                    <img style="vertical-align: top;" height="26" width="17px" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_sep.gif" />
                                </td>
                                <td class="content_tab_top" width="100%"></td>
                                <td width="7">
                                    <img style="vertical-align: top;" height="26" width="17px" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_right.gif" />
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td class="content_tab_bg" style="padding-left: 8px">
                        <table cellspacing="0" cellpadding="0" border="0" width="100%">
                            <tr>
                                <td align="left" style="width: 22%">
                                    <span class="form_label" id="Span10">Charge Client % of standard rate</span>
                                </td>
                                <td align="left" style="width: 10%">
                                    <input type="text" id="TextBox_CustomInquiries_IncomeSpecialFeeCharge" name="TextBox_CustomInquiries_IncomeSpecialFeeCharge"
                                        class="date_text" tabindex="1" datatype="Numeric"/>
                                </td>
                                <td align="left" style="width: 9%">
                                    <span class="form_label" id="Span11">Begin Date</span>
                                </td>
                                <td align="left" style="width: 10%">
                                    <input type="text" id="TextBox_CustomInquiries_IncomeSpecialFeeBeginDate" name="TextBox_CustomInquiries_IncomeSpecialFeeBeginDate"
                                        class="date_text" datatype="Date" tabindex="1" />
                                </td>
                                <td align="left" style="width: 5%">
                                    <img id="img2" src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif"
                                        onclick="return showCalendar('TextBox_CustomInquiries_IncomeSpecialFeeBeginDate', '%m/%d/%Y');"
                                        alt="" />
                                </td>
                                <td align="left" style="width: 9%">
                                    <span class="form_label" id="Span12">Comment</span>
                                </td>
                                <td align="left">
                                    <input id="TextBox_CustomInquiries_IncomeSpecialFeeComment" name="TextBox_CustomInquiries_IncomeSpecialFeeComment"
                                        type="text" class="form_textbox" style="width: 270px" />
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td>
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td width="1%" class="right_bottom_cont_bottom_bg">
                                    <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/right_bottom_cont_bottom_left.gif"
                                        height="7" alt="" />
                                </td>
                                <td class="right_bottom_cont_bottom_bg" width="98%"></td>
                                <td width="1%" class="right_bottom_cont_bottom_bg" align="right">
                                    <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/right_bottom_cont_bottom_right.gif"
                                        height="7" alt="" />
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>

                <tr>
                    <td style="padding-top: 10px">
                        <table cellspacing="0" cellpadding="0" border="0">
                            <tr>
                                <td class="content_tab_left" align="left" nowrap='nowrap'>
                                    <span class="form_label" id="Span13">Sliding Fee Determination</span>
                                </td>
                                <td width="17px">
                                    <img style="vertical-align: top;" height="26" width="17px" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_sep.gif" />
                                </td>
                                <td class="content_tab_top" width="100%"></td>
                                <td width="7">
                                    <img style="vertical-align: top;" height="26" width="17px" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_right.gif" />
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td class="content_tab_bg" style="padding-left: 8px">
                        <table cellspacing="0" cellpadding="0" border="0" width="100%">
                            <tr>
                                <td align="left" style="width: 7%">
                                    <span class="form_label" id="Span14">Start Date</span>
                                </td>
                                <td align="left" style="width: 16%">
                                    <input type="text" id="TextBox_CustomInquiries_IncomeSpecialFeeStartDate" name="TextBox_CustomInquiries_IncomeSpecialFeeStartDate"
                                        class="date_text" datatype="Date" tabindex="1" />
                                    <img id="img1" src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif"
                                        onclick="return showCalendar('TextBox_CustomInquiries_IncomeSpecialFeeStartDate', '%m/%d/%Y');"
                                        alt="" />
                                </td>
                                <td align="left" style="width: 7%">
                                    <span class="form_label" id="Span15">End Date</span>
                                </td>
                                <td align="left" style="width: 15%">
                                    <input type="text" id="TextBox_CustomInquiries_IncomeSpecialFeeEndDate" name="TextBox_CustomInquiries_IncomeSpecialFeeEndDate"
                                        class="date_text" datatype="Date" tabindex="1" />
                                    <img id="img3" src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif"
                                        onclick="return showCalendar('TextBox_CustomInquiries_IncomeSpecialFeeEndDate', '%m/%d/%Y');"
                                        alt="" />
                                </td>
                                <td class="checkbox_container" style="width: 15%">
                                    <input id="CheckBox_CustomInquiries_IncomeSpecialFeeIncomeVerified" type="checkbox" />
                                    <label for="CheckBox_CustomInquiries_IncomeSpecialFeeIncomeVerified">
                                        Income Verified</label>
                                </td>
                                <td>
                                    <table cellpadding="0" cellspacing="0" border="0">
                                        <tr>
                                            <td>
                                                <div class="glow_lt">
                                                    &nbsp;
                                                </div>
                                            </td>
                                            <td>
                                                <div class="glow_mid">
                                                   <input type="button" style="width: 100px;" id="Button_SetEndTime" value="Calculate Fee" onclick="return CalculationFee()"/>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="glow_rt">
                                                    &nbsp;
                                                </div>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                                <td>
                                    <span id="Span16">Per Session Fee</span>
                                </td>
                                <td>
                                    <input id="TextBox_CustomInquiries_IncomeSpecialFeePerSessionFee" name="TextBox_CustomInquiries_IncomeSpecialFeePerSessionFee"
                                        type="text" class="form_textbox" style="width: 100px;" datatype="Numeric"/>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td>
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td width="1%" class="right_bottom_cont_bottom_bg">
                                    <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/right_bottom_cont_bottom_left.gif"
                                        height="7" alt="" />
                                </td>
                                <td class="right_bottom_cont_bottom_bg" width="98%"></td>
                                <td width="1%" class="right_bottom_cont_bottom_bg" align="right">
                                    <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/right_bottom_cont_bottom_right.gif"
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
        <td>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td width="1%" class="right_bottom_cont_bottom_bg">
                        <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/right_bottom_cont_bottom_left.gif"
                            height="7" alt="" />
                    </td>
                    <td class="right_bottom_cont_bottom_bg" width="98%"></td>
                    <td width="1%" class="right_bottom_cont_bottom_bg" align="right">
                        <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/right_bottom_cont_bottom_right.gif"
                            height="7" alt="" />
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>

<script id="appointmentHTML" type="text/x-jsrender">    
        <tr id="trhtml">
            <td valign="top" style="white-space: nowrap; padding-left: 8px; width: 3%">
                <img style="vertical-align: top; cursor: pointer" alt="" src="<%=RelativePath%>App_Themes/Includes/images/deleteIcon.gif" onclick="removeCoverageInfo(this,{{:InquiriesCoverageInformationId}});" />
            </td>
            <td valign="top" style="white-space: nowrap; width: 24%">                
                {{*     
                        var txtid= "DropDownList_CustomInquiriesCoverageInformations_CoveragePlanId_" + view.data.InquiriesCoverageInformationId;    
                        view.data.textid=txtid;    
                }}                  
                <select   style="width: 95%;" class="form_dropdown form_dropdown_wo_width element"  bindautosaveevents="False" id={{:textid}} onchange="CustomInquiriesCoverageInformations(this,'CoveragePlanId',{{:InquiriesCoverageInformationId}})" >
    debugger;
                             <option  text=""  value="-1"></option>
                             {{for plansdropdownarray}}
                                <option  text="{{:PlanName}}"  value="{{:CoveragePlanId}}" {{if IsSelected=='Y'}}selected{{/if}}>{{:PlanName}}</option>
                             {{/for}}
                </select>
     
            </td>
            <td valign="top" align="left" style="white-space: nowrap; width: 14%">   
                {{*     
                        var txinsuretid= "TextBox_CustomInquiriesCoverageInformations_InsuredId_" + view.data.InquiriesCoverageInformationId;    
                        view.data.textinsureid=txinsuretid;    
                }}             
                <input class="form_textbox GetIds" type="text" style="width: 85%"  maxlength="25" bindautosaveevents="False" id={{:textinsureid}} value="{{:InsuredId}}" onchange="CustomInquiriesCoverageInformations(this,'InsuredId',{{:InquiriesCoverageInformationId}})" />
            </td>
            <td valign="top" style="white-space: nowrap; width: 10%">
                    <input class="form_textbox" type="text" maxlength="35" value="{{:GroupId}}" onchange="CustomInquiriesCoverageInformations(this,'GroupId',{{:InquiriesCoverageInformationId}})" />
            </td>            
            <td valign="top" style="white-space: nowrap; width: 29%">                
                <input class="form_textbox" type="text"  style="width: 90%;margin-left:15px;" value="{{:Comment}}" onchange="CustomInquiriesCoverageInformations(this,'Comment',{{:InquiriesCoverageInformationId}})" />
            </td>
        </tr>
</script>
