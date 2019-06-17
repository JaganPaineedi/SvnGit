<%@ Control Language="C#" AutoEventWireup="true" CodeFile="RegistrationDocumentDemographics.ascx.cs"
    Inherits="RegistrationDocumentDemographics" %>
<%@ Register Src="~/CommonUserControls/DynamicForms.ascx" TagName="DynamicForms"
    TagPrefix="uc2" %>
<%@ Register Assembly="Streamline.DotNetDropDowns" Namespace="Streamline.DotNetDropDowns"
    TagPrefix="cc2" %>

<script src="<%=ResolveUrl("~")%>JScripts/ApplicationScripts/CrossBowser.js" type="text/javascript"></script>
<div id="DivCustomRegistrationsDFA">
    <table border="0" cellspacing="0" cellpadding="0" style="width: 99%">
        <tr>
            <td class="height2">
            </td>
        </tr>
        <tr>
            <td class="height2">
            </td>
        </tr>
        <tr>
            <td>
                <table border="0" cellspacing="0" cellpadding="0" width="100%">
                    <tr>
                        <td class="content_tab_left" align="left" nowrap='nowrap'>
                            Basic Demographics
                        </td>
                        <td width="17">
                            <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/content_tab_sep.gif"
                                width="17" height="26" alt="" />
                        </td>
                        <td class="content_tab_top" width="100%">
                        </td>
                        <td width="7">
                            <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/content_tab_right.gif"
                                width="7" height="26" alt="" />
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td class="content_tab_bg_padding">
                <table cellpadding="0" cellspacing="0" border="0" width="100%">
                    <tr>
                        <td>
                            <table cellpadding="0" cellspacing="0" border="0" width="98%">
                                <tr>
                                    <td align="left">
                                        <span>First Name</span>
                                        <input name="TextBox_CustomDocumentRegistrations_FirstName" class="form_textbox element"
                                            id="TextBox_CustomDocumentRegistrations_FirstName" style="width: 105px;" type="text"
                                            maxlength="20" >
                                    </td>
                                    <td  align="left">
                                        <span>Middle Name</span>
                                        <input name="TextBox_CustomDocumentRegistrations_MiddleName" class="form_textbox element"
                                            id="TextBox_CustomDocumentRegistrations_MiddleName" style="width: 100px;" type="text"
                                            maxlength="20">
                                    </td>
                                    <td  align="left">
                                        <span>Last Name</span>
                                        <input name="TextBox_CustomDocumentRegistrations_LastName" class="form_textbox element"
                                            id="TextBox_CustomDocumentRegistrations_LastName" style="width: 105px;" type="text"
                                            maxlength="30">
                                    </td>
                                    <td align="right" >
                                        <span style="padding-right:19px;">Suffix</span>
                                         <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentRegistrations_Suffix" CssClass="form_dropdown"  Width="100px" runat="server">
                                          </cc2:StreamlineDropDowns>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td class="height2">
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <table cellpadding="0" cellspacing="0" border="0" width="98%">
                                <tr>
                                    <td width="7%">
                                        <span>SSN</span>
                                    </td>
                                    <td align="left" class="checkbox_container" width="35%">
                                        
                                         <input name="TextBox_CustomDocumentRegistrations_SSN" class="ssn_text element"
                                            id="TextBox_CustomDocumentRegistrations_SSN" style="width: 70px;" type="text"
                                            maxlength="11" datatype="SSN">
                                        &nbsp;
                                        <input name="CheckBox_CustomDocumentRegistrations_SSNUnknown" class="element" id="CheckBox_CustomDocumentRegistrations_SSNUnknown"
                                            type="checkbox" onclick="EnableDisableSSN()"/>
                                        <label for="CheckBox_CustomDocumentRegistrations_SSNUnknown" class="form_label">
                                            SSN Unknown/Refused</label>
                                    </td>                                   
                                    <td width="30%">
                                        <span>DOB</span>&nbsp;
                                         <input name="TextBox_CustomDocumentRegistrations_DateOfBirth" class="date_text element"
                                            id="TextBox_CustomDocumentRegistrations_DateOfBirth" type="text" maxlength="10"
                                            datatype="Date" onchange="CalculateAge(this.value)">
                                        <img id="img_CustomDocumentRegistrations_DateOfBirth" src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif"
                                            style="vertical-align: text-bottom; cursor: default" onclick="return showCalendar('TextBox_CustomDocumentRegistrations_DateOfBirth', '%m/%d/%Y');"
                                            class="element" />
                                        &nbsp;&nbsp;<span id="span_CustomDocumentRegistrations_Age"></span>
                                    </td>
                                    
                                    <td   align="right" width="25%">
                                        <span style="padding-right:12px;">Gender</span>
                                        <cc2:StreamlineDropDowns ID="DownList_CustomDocumentRegistrations_Sex" Width="100px"
                                            runat="server" TabIndex="3" AddBlankRow="True" CssClass="form_dropdowns" BlankRowText=""
                                            BlankRowValue="" Height="16px">
                                        </cc2:StreamlineDropDowns>
                                    </td>                                                                 
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td class="height2">
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <table cellpadding="0" cellspacing="0" border="0" width="95%">
                                <tr>
                                    <td >
                                        <span>Primary Method of Communication</span>
                                    </td>
                                    <td>
                                        <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentRegistrations_PrimayMethodOfCommunication" Style="width: 180px;" runat="server"
                                            TabIndex="4" AddBlankRow="True" CssClass="form_dropdowns" BlankRowText="" BlankRowValue=""
                                            Height="16px">
                                        </cc2:StreamlineDropDowns>
                                    </td>
                                    <td >
                                        <span>Marital Status</span>
                                        </td>
                                            <td align="left">
                                        <cc2:StreamlineDropDowns ID="DownList_CustomDocumentRegistrations_MaritalStatus"
                                            Style="width: 180px;" runat="server" TabIndex="4" AddBlankRow="True" CssClass="form_dropdowns"
                                            BlankRowText="" BlankRowValue="" Height="16px">
                                        </cc2:StreamlineDropDowns>
                                    </td>
                                </tr>
                                 <tr>
                        <td class="height2">
                        </td>
                    </tr>
                                <tr>
                                    <td >
                                        <span>Primary Language </span>
                                        </td>
                                            <td>
                                        <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentRegistrations_PrimaryLanguage" Style="width: 180px;"
                                            runat="server" TabIndex="4" AddBlankRow="True" CssClass="form_dropdowns" BlankRowText=""
                                            BlankRowValue="" Height="16px" onChange="DisplayOtherTextBox()">
                                        </cc2:StreamlineDropDowns>
                                        <input name="TextBox_CustomDocumentRegistrations_OtherPrimaryLanguage" class="form_textbox element"
                                            id="TextBox_CustomDocumentRegistrations_OtherPrimaryLanguage" style="width: 80px;"
                                            type="text" maxlength="20"/>
                                    </td>
                                    <td>
                                        <span >Secondary Language </span>
                                        </td>
                                            <td align="left">
                                        <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentRegistrations_SecondaryLanguage"
                                            Style="width: 180px;" runat="server" TabIndex="4" AddBlankRow="True" CssClass="form_dropdowns"
                                            BlankRowText="" BlankRowValue="" Height="16px">
                                        </cc2:StreamlineDropDowns>
                                    </td>
                                </tr>
                                <tr>
                        <td class="height2">
                        </td>
                    </tr>
                                <tr>
                                    <td >
                                        <span >Ethnicity </span>
                                        </td>
                                            <td>
                                        <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentRegistrations_HispanicOrigin"
                                            Style="width: 180px;" runat="server" TabIndex="4" AddBlankRow="True" CssClass="form_dropdowns"
                                            BlankRowText="" BlankRowValue="" Height="16px">
                                        </cc2:StreamlineDropDowns>
                                    </td>
                                    <td >
                                        <span >Race </span>
                                        </td>
                                    <td align="left">
                                        <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentRegistrations_Race" Style="width: 180px;"
                                            runat="server" TabIndex="4" AddBlankRow="True" CssClass="form_dropdowns" BlankRowText=""
                                            BlankRowValue="" Height="16px">
                                        </cc2:StreamlineDropDowns>
                                    </td>
                                </tr>
                                <tr>
                        <td class="height2">
                        </td>
                    </tr>
                                 <tr>
                                    <td >                                        
                                        Tribal Affiliation
                                        </td>
                                     <td>
                                      <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentRegistrations_TribalAffiliation"
                                            Style="width: 180px;" runat="server" TabIndex="4" AddBlankRow="True" CssClass="form_dropdowns"
                                            BlankRowText="" BlankRowValue="" Height="16px">
                                        </cc2:StreamlineDropDowns>
                                    </td>
                                    <td>
                                        <span>Interpreter Needed</span>
                                        </td>
                                     <td align="left">
                                        <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentRegistrations_InterpreterNeeded"
                                            Style="width: 180px;" runat="server" TabIndex="4" AddBlankRow="True" CssClass="form_dropdowns"
                                            BlankRowText="" BlankRowValue="" Height="16px">
                                        </cc2:StreamlineDropDowns>
                                       <%-- <span style="padding-left: 40px; padding-right: 13%;">Patient Type</span>
                                        <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentRegistrations_PatientType"
                                            Style="width: 150px;" runat="server" TabIndex="4" AddBlankRow="True" CssClass="form_dropdowns"
                                            BlankRowText="" BlankRowValue="" Height="16px">
                                        </cc2:StreamlineDropDowns>--%>
                                    </td>
                                </tr>
                                <tr>
                                     <td class="height2">
                        </td>
                                </tr>
                                 <tr>

                                    <td >                                        
                                        <span >Medicaid ID</span>
                                        </td>
                                     <td>
                                      <input name="TextBox_CustomDocumentRegistrations_MedicaidId" class="form_textbox element"
                                            id="TextBox_CustomDocumentRegistrations_MedicaidId" style="width: 175px;" type="text"
                                            maxlength="9" datatype="Numeric" />
                                    </td>
                                    <td>
                                        &nbsp;</td>
                                     <td align="left">
                                       <%-- <span style="padding-left: 40px; padding-right: 13%;">Patient Type</span>
                                        <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentRegistrations_PatientType"
                                            Style="width: 150px;" runat="server" TabIndex="4" AddBlankRow="True" CssClass="form_dropdowns"
                                            BlankRowText="" BlankRowValue="" Height="16px">
                                        </cc2:StreamlineDropDowns>--%>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>                    
                    <tr>
                        <td style="padding-top:4px;">
                            <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                <tr>
                                    <td style="width: 21%;vertical-align:top;">
                                        Handicaps
                                    </td>
                                    <td style="width: 79%; padding-left:6px;" class="checkbox_container">
                                        <table width="100%" style="padding-left:4px;">
                                            <tr>
                                                <td class="checkbox_container">
                                                    <input name="CheckBox_CustomDocumentRegistrations_ClientDeaf" class="element" id="CheckBox_CustomDocumentRegistrations_ClientDeaf"
                                                        type="checkbox" />
                                                    <label for="CheckBox_CustomDocumentRegistrations_ClientDeaf" class="form_label">
                                                        Deaf</label>
                                                 </td>
                                                <td class="checkbox_container">
                                                    <input name="CheckBox_CustomDocumentRegistrations_ClientDevelopmentallyDisabled"
                                                        class="element" id="CheckBox_CustomDocumentRegistrations_ClientDevelopmentallyDisabled"
                                                         type="checkbox" />
                                                    <label for="CheckBox_CustomDocumentRegistrations_ClientDevelopmentallyDisabled">
                                                        Developmentally Disabled</label>
                                                </td>
                                                <td class="checkbox_container">
                                                    <input name="CheckBox_CustomDocumentRegistrations_ClientHasVisuallyImpairment" class="element"
                                                        id="CheckBox_CustomDocumentRegistrations_ClientHasVisuallyImpairment"  type="checkbox" />
                                                    <label for="CheckBox_CustomDocumentRegistrations_ClientHasVisuallyImpairment">
                                                        Blind/Severe Visual Impairment</label>
                                                </td>
                                                                                         
                                            </tr>
                                            <tr>
                                                <td class="checkbox_container" style="padding-top:6px">
                                                    <input name="CheckBox_CustomDocumentRegistrations_ClientHasNonAmbulation" class="element"
                                                        id="CheckBox_CustomDocumentRegistrations_ClientHasNonAmbulation"  type="checkbox" />
                                                    <label for="CheckBox_CustomDocumentRegistrations_ClientHasNonAmbulation">
                                                        Non-ambulation</label>
                                                 </td>
                                                <td class="checkbox_container" style="padding-top:6px">
                                                    <input name="CheckBox_CustomDocumentRegistrations_ClientHasSevereMedicalIssues" class="element"
                                                        id="CheckBox_CustomDocumentRegistrations_ClientHasSevereMedicalIssues"  type="checkbox" />
                                                    <label for="CheckBox_CustomDocumentRegistrations_ClientHasSevereMedicalIssues">
                                                        Severe Medical Issues</label> 
                                                 </td>  
                                                <td>
                                                    &nbsp;
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
        <tr>
            <td>
                <table border="0" cellspacing="0" cellpadding="0" width="100%">
                    <tr>
                        <td width="2" class="right_bottom_cont_bottom_bg">
                            <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/right_bottom_cont_bottom_left.gif"
                                height="7" alt="" />
                        </td>
                        <td class="right_bottom_cont_bottom_bg" width="100%">
                        </td>
                        <td width="2" class="right_bottom_cont_bottom_bg" align="right">
                            <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/right_bottom_cont_bottom_right.gif"
                                height="7" alt="" />
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
    <table border="0" cellpadding="0" cellspacing="0" width="99%">
        <tr>
            <td class="height2">
            </td>
        </tr>
        <tr>
            <td>
                <table border="0" cellspacing="0" cellpadding="0" width="100%">
                    <tr>
                        <td class="content_tab_left" align="left" nowrap='nowrap'>
                            Client Information
                        </td>
                        <td width="17">
                            <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/content_tab_sep.gif"
                                width="17" height="26" alt="" />
                        </td>
                        <td class="content_tab_top" width="100%">
                        </td>
                        <td width="7">
                            <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/content_tab_right.gif"
                                width="7" height="26" alt="" />
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td class="content_tab_bg">
                <table border="0" cellspacing="0" cellpadding="0" width="100%">
                    <tr>
                        <td class="padding_label1">
                            <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                <tr>
                                    <td style="width: 100%" class="style2" valign="top" colspan="4">
                                        <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                            <tr >
                                                <td width="80%" align="left">
                                                    <table width="60%">
                                                        <tr>
                                                            <td class="checkbox_container">
                                                                <input type="radio" id="RadioButton_CustomDocumentRegistrations_CurrentlyHomeless_N" name="RadioButton_CustomDocumentRegistrations_CurrentlyHomeless"
                                                                    value="Y" style="margin-right: 0px" />
                                                                <span class="form_label" id="Span9" style=" margin-right: 4px;">Client is not homeless</span>
                                                            </td >
                                                            <td align="left" class="checkbox_container">
                                                                <input type="radio" style="margin-right: 0px" id="RadioButton_CustomDocumentRegistrations_CurrentlyHomeless_Y" name="RadioButton_CustomDocumentRegistrations_CurrentlyHomeless"
                                                                    value="N" />
                                                                <span class="form_label" id="Span12" style="margin-right: 4px;">Client is homeless</span>
                                                            </td>
                                                            <td align="left" colspan="2" class="checkbox_container">
                                                                <input type="radio" style="margin-right: 0px" id="RadioButton_CustomDocumentRegistrations_CurrentlyHomeless_U" name="RadioButton_CustomDocumentRegistrations_CurrentlyHomeless"
                                                                    value="U" />
                                                                <span class="form_label" id="Span13" style="margin-right: 4px;">Client is chronically homeless</span>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2">
                                                </td>
                                            </tr>
                                        </table>                                   
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height1" colspan="2">
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <span class="form_label" id="Span4">Address 1</span>
                                    </td>
                                    <td style="padding-left:2px;">
                                        <input name="TextBox_CustomDocumentRegistrations_Address1" class="form_textbox element"
                                                        id="TextBox_CustomDocumentRegistrations_Address1" style="width: 315px;" type="text"
                                                        maxlength="100" />
                                    </td>
                                    <td>
                                        &nbsp;
                                    </td>
                                    <td>
                                        <table>
                                            <tr>
                                                <td style="width: 65px;">
                                        <span class="form_label" id="Span2">Address 2</span>
                                    </td>
                                            
                                                
                                                <td><input name="TextBox_CustomDocumentRegistrations_Address2" class="form_textbox element"
                                                        id="TextBox_CustomDocumentRegistrations_Address2" style="width: 285px;" type="text"
                                                        maxlength="100" /></td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height1" colspan="2">
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <span class="form_label" id="Span1">City</span>
                                    </td>                                    
                                    <td class="Secondtdwidth">
                                        <table  width="93%">
                                            <tr>
                                                <td>
                                                    <input name="TextBox_CustomDocumentRegistrations_City" class="form_textbox element"
                                                        id="TextBox_CustomDocumentRegistrations_City" style="width: 170px;" type="text"
                                                        maxlength="30" />
                                                </td>
                                                <td align="left" width="120px">
                                                    <span class="form_label" id="Span3">State</span>&nbsp;
                                                    <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentRegistrations_State" Width="90px"
                                                        runat="server" AddBlankRow="True" BlankRowText="" clientinstancename="DropDownList_CustomDocumentRegistrations_StateDevXInstance"
                                                        BlankRowValue="-1" valuetype="System.Int32">
                                                    </cc2:StreamlineDropDowns>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td>
                                        &nbsp;
                                    </td>
                                    <td>
                                        <table>
                                            <tr>
                                                 <td style="width: 65px;">
                                        <span class="form_label" id="Span6">ZIP Code</span>
                                    </td>  
                                               
                                                    <td><input name="TextBox_CustomDocumentRegistrations_ZipCode" id="TextBox_CustomDocumentRegistrations_ZipCode"
                                                        class="form_textbox element" style="width: 79px;" type="text" maxlength="12"
                                                        datatype="ZipCode" /></td>
                                             
                                                <td align="left" style="padding-left:25px">
                                                    County of Residence
                                                    </td>
                                                <td >
                                                    <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentRegistrations_ResidenceCounty" Width="80px"
                                                        name="DropDownList_CustomDocumentRegistrations_ResidenceCounty" runat="server" AddBlankRow="True"
                                                        BlankRowText="" valuetype="">
                                                    </cc2:StreamlineDropDowns>
                                                </td>
                                            </tr>
                                        </table>
                                        
                                        
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height1" colspan="2">
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <span class="form_label" id="Span5">Home phone</span>
                                    </td>
                                    <td class="Secondtdwidth">
                                        <table width="100%">
                                            <tr>
                                                <td width="150px">
                                                    <input name="TextBox_CustomDocumentRegistrations_HomePhone" id="TextBox_CustomDocumentRegistrations_HomePhone"
                                                        class="form_textbox element" id="Text1" style="width: 85px;" type="text" maxlength="35"
                                                        datatype="PhoneNumber" />
                                                </td>
                                                <td align="left" >
                                                    <span class="form_label" id="Span11">Home phone 2</span>
                                                    <input name="TextBox_CustomDocumentRegistrations_HomePhone2" id="TextBox_CustomDocumentRegistrations_HomePhone2"
                                                        class="form_textbox element" style="width: 85px;" type="text" maxlength="35"
                                                        datatype="PhoneNumber" />
                                                </td>
                                            </tr>
                                        </table>                                        
                                    </td>
                                    <td class="thirdtdwidth">
                                        &nbsp;
                                    </td>
                                    <td class="lasttdwidth">
                                        <table>
                                            <tr>
                                                <td style="width: 65px;">
                                        <span class="form_label" id="Span7">Work phone</span>
                                    </td>
                                                <td style="width:86px;">
                                                    <input name="TextBox_CustomDocumentRegistrations_WorkPhone" class="form_textbox element"
                                                        id="TextBox_CustomDocumentRegistrations_WorkPhone" style="width:80px;" type="text"
                                                        maxlength="35" datatype="PhoneNumber" />
                                                </td>
                                                <td align="left" style="width:98px;padding-left:25px">
                                                 Cell phone
                                                </td>
                                                <td>
                                                    <input name="TextBox_CustomDocumentRegistrations_CellPhone" class="form_textbox element"
                                                        id="TextBox_CustomDocumentRegistrations_CellPhone"  type="text"
                                                        maxlength="35" datatype="PhoneNumber"  style="width:74px;" />
                                                </td>
                                            </tr>
                                        </table>
                                       
                                        
                                        
                                        
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height1" colspan="2">
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <span class="form_label" id="Span8">Message phone</span>
                                    </td>
                                    <td class="Secondtdwidth" style="padding-left:2px;">
                                        <input name="TextBox_CustomDocumentRegistrations_MessagePhone" class="form_textbox element"
                                                        id="TextBox_CustomDocumentRegistrations_MessagePhone" style="width: 85px;" type="text"
                                                        maxlength="35" datatype="PhoneNumber" />
                                    </td>
                                    <td class="thirdtdwidth">
                                        &nbsp;
                                    </td>
                                    <td>
                                        <table width="100%">
                                            <tr>
                                                <td align="right" width="254px" style="padding-left:24px">
                                                   County of Financial Responsibility
                                                </td>
                                                <td>
                                                    <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentRegistrations_CountyOfTreatment" Width="80px"
                                                        name="DropDownList_CustomDocumentRegistrations_CountyOfTreatment" runat="server" AddBlankRow="True"
                                                        BlankRowText="" valuetype="">
                                                    </cc2:StreamlineDropDowns>
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
        <tr>
            <td>
                <table border="0" cellspacing="0" cellpadding="0" width="100%">
                    <tr>
                        <td width="2" class="right_bottom_cont_bottom_bg">
                            <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/right_bottom_cont_bottom_left.gif"
                                height="7" alt="" />
                        </td>
                        <td class="right_bottom_cont_bottom_bg" width="100%">
                        </td>
                        <td width="2" class="right_bottom_cont_bottom_bg" align="right">
                            <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/right_bottom_cont_bottom_right.gif"
                                height="7" alt="" />
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
    <input id="HiddenFieldCounties" runat="server" type="hidden" />
    <input id="HiddenFieldStates" runat="server" type="hidden" />
</div>
