<%@ Control Language="C#" AutoEventWireup="true" CodeFile="HRMDxDD.ascx.cs" Inherits="SHS.SmartCare.ActivityPages_Client_Detail_Assessment_HRMDxDD" %>
<%--<%@ Register src="../Documents/Diagnosis.ascx" tagname="Diagnosis" tagprefix="uc1" %>--%>
<%@ Register src="~/ActivityPages/Client/Detail/Documents/Diagnosis.ascx" tagname="Diagnosis" tagprefix="uc1" %>
<% if (HttpContext.Current == null)
   { %>
<link href="../../../../../App_Themes/Styles/smartcare_styles.css" rel="stylesheet"
    type="text/css" />
<%} %>

<div  style="overflow-x:hidden">
    <table border="0" cellpadding="0" cellspacing="0" class="DocumentScreen">
        <tr>
       
            <td  id="TdDxDDSection" visible="false"  style="display:none"  >
             <div id="DivDisabilityEligibility">
                <table id="TableDevelopment" border="0" cellpadding="0" cellspacing="0" width="100%" Group="Development">
                    <tr>
                        <td class="height2">
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                <tr>
                                    <td class="content_tab_left" align="left" nowrap='nowrap'>
                                        Developmental Disability Eligibility Criteria <span id="Group_Development"></span>
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
                                            <tr class="RadioText">
                                                <td align="left" width="30%">
                                                    <span>Attributable to a mental/physical limitation?</span>
                                                </td>
                                                <td class="RadioText" width="5%">
                                                    <input type="radio" id="RadioButton_CustomHRMAssessments_DDAttributableMentalPhysicalLimitation_Y"
                                                        name="RadioButton_CustomHRMAssessments_DDAttributableMentalPhysicalLimitation"
                                                        value="Y" />
                                                    <label for="RadioButton_CustomHRMAssessments_DDAttributableMentalPhysicalLimitation_Y">
                                                        Yes</label>
                                                </td>
                                                <td width="1%">
                                                </td>
                                                <td class="RadioText" width="5%">
                                                    <input type="radio" id="RadioButton_CustomHRMAssessments_DDAttributableMentalPhysicalLimitation_N"
                                                        name="RadioButton_CustomHRMAssessments_DDAttributableMentalPhysicalLimitation"
                                                        value="N" />
                                                    <label for="RadioButton_CustomHRMAssessments_DDAttributableMentalPhysicalLimitation_N">
                                                        No</label>
                                                </td>
                                                <td width="1%">
                                                    &nbsp;
                                                </td>
                                                <td width="15%">
                                                </td>
                                                <td width="1%">
                                                    &nbsp;
                                                </td>
                                                <td>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="8" class="height1">
                                                </td>
                                            </tr>
                                            <tr class="RadioText">
                                                <td align="left" width="30%">
                                                    <span>Manifested before age 22?</span>
                                                </td>
                                                <td class="RadioText" width="5%">
                                                    <input type="radio" id="RadioButton_CustomHRMAssessments_DDManifestBeforeAge22_Y"
                                                        name="RadioButton_CustomHRMAssessments_DDManifestBeforeAge22" value="Y" />
                                                    <label for="RadioButton_CustomHRMAssessments_DDManifestBeforeAge22_Y">
                                                        Yes</label>
                                                </td>
                                                <td width="1%">
                                                    &nbsp;
                                                </td>
                                                <td class="RadioText" width="5%">
                                                    <input type="radio" id="RadioButton_CustomHRMAssessments_DDManifestBeforeAge22_N"
                                                        name="RadioButton_CustomHRMAssessments_DDManifestBeforeAge22" value="N" />
                                                    <label for="RadioButton_CustomHRMAssessments_DDManifestBeforeAge22_N">
                                                        No</label>
                                                </td>
                                                <td width="1%">
                                                    &nbsp;
                                                </td>
                                                <td width="15%">
                                                </td>
                                                <td width="1%">
                                                    &nbsp;
                                                </td>
                                                <td>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="8" class="height1">
                                                </td>
                                            </tr>
                                            <tr class="RadioText">
                                                <td align="left" width="30%">
                                                    <span>Testing reports reviewed and verified?</span>
                                                </td>
                                                <td class="RadioText" width="5%">
                                                    <input type="radio" id="RadioButton_CustomHRMAssessments_TestingReportsReviewed_Y"
                                                        name="RadioButton_CustomHRMAssessments_TestingReportsReviewed" value="Y" />
                                                    <label for="RadioButton_CustomHRMAssessments_TestingReportsReviewed_Y">
                                                        Yes</label>
                                                </td>
                                                <td width="1%">
                                                </td>
                                                <td class="RadioText" width="5%">
                                                    <input type="radio" id="RadioButton_CustomHRMAssessments_TestingReportsReviewed_N"
                                                        name="RadioButton_CustomHRMAssessments_TestingReportsReviewed" value="N" />
                                                    <label for="RadioButton_CustomHRMAssessments_TestingReportsReviewed_N">
                                                        No</label>
                                                </td>
                                                <td width="1%">
                                                    &nbsp;
                                                </td>
                                                <td class="RadioText" width="15%">
                                                    <input type="radio" id="RadioButton_CustomHRMAssessments_TestingReportsReviewed_R"
                                                        name="RadioButton_CustomHRMAssessments_TestingReportsReviewed" value="R" />
                                                    <label for="RadioButton_CustomHRMAssessments_TestingReportsReviewed_R">
                                                        Reports Requested</label>
                                                </td>
                                                <td width="1%">
                                                    &nbsp;
                                                </td>
                                                <td class="RadioText">
                                                    <input type="radio" id="RadioButton_CustomHRMAssessments_TestingReportsReviewed_NA"
                                                        name="RadioButton_CustomHRMAssessments_TestingReportsReviewed" value="NA" />
                                                    <label for="RadioButton_CustomHRMAssessments_TestingReportsReviewed_NA">
                                                        N/A</label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="8" class="height1">
                                                </td>
                                            </tr>
                                            <tr class="RadioText">
                                                <td align="left" width="30%">
                                                    <span>Likely to continue indefinitely?</span>
                                                </td>
                                                <td class="RadioText" width="5%">
                                                    <input type="radio" id="RadioButton_CustomHRMAssessments_DDContinueIndefinitely_Y"
                                                        name="RadioButton_CustomHRMAssessments_DDContinueIndefinitely" value="Y" />
                                                    <label for="RadioButton_CustomHRMAssessments_DDContinueIndefinitely_Y">
                                                        Yes</label>
                                                </td>
                                                <td width="1%">
                                                    &nbsp;
                                                </td>
                                                <td class="RadioText" width="5%">
                                                    <input type="radio" id="RadioButton_CustomHRMAssessments_DDContinueIndefinitely_N"
                                                        name="RadioButton_CustomHRMAssessments_DDContinueIndefinitely" value="N" />
                                                    <label for="RadioButton_CustomHRMAssessments_DDContinueIndefinitely_N">
                                                        No</label>
                                                </td>
                                                <td width="1%">
                                                    &nbsp;
                                                </td>
                                                <td width="15%">
                                                </td>
                                                <td width="1%">
                                                    &nbsp;
                                                </td>
                                                <td>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="8" class="height1">
                                                </td>
                                            </tr>
                                            <tr class="RadioText" colspan="8">
                                                <td align="left" width="55%" colspan="8">
                                                    <span>Results in substantial functional limitations in the following areas:</span>
                                                    &nbsp; &nbsp; &nbsp;
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="8" class="height2">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td width="100%" colspan="8" >
                                                    <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                                        <tr>
                                                            <td class="checkbox_container" style="padding-left:2px">
                                                                <input type="checkbox" id="CheckBox_CustomHRMAssessments_DDLimitSelfCare" name="CheckBox_CustomHRMAssessments_DDLimitSelfCare" />
                                                                <label for="CheckBox_CustomHRMAssessments_DDLimitSelfCare">
                                                                    Self Care</label>
                                                            </td>
                                                            <td class="checkbox_container">
                                                                <input type="checkbox" id="CheckBox_CustomHRMAssessments_DDLimitLanguage" name="CheckBox_CustomHRMAssessments_DDLimitLanguage" />
                                                                <label for="CheckBox_CustomHRMAssessments_DDLimitLanguage">
                                                                    Receptive/expressive language</label>
                                                            </td>
                                                            <td class="checkbox_container">
                                                                <input type="checkbox" id="CheckBox_CustomHRMAssessments_DDLimitLearning" name="CheckBox_CustomHRMAssessments_DDLimitLearning" />
                                                                <label for="CheckBox_CustomHRMAssessments_DDLimitLearning">
                                                                    Learning</label>
                                                            </td>
                                                            <td class="checkbox_container">
                                                                <input type="checkbox" id="CheckBox_CustomHRMAssessments_DDLimitMobility" name="CheckBox_CustomHRMAssessments_DDLimitMobility" />
                                                                <label for="CheckBox_CustomHRMAssessments_DDLimitMobility">
                                                                    Mobility</label>
                                                            </td>
                                                            <td class="checkbox_container">
                                                                <input type="checkbox" id="CheckBox_CustomHRMAssessments_DDLimitSelfDirection" name="CheckBox_CustomHRMAssessments_DDLimitSelfDirection" />
                                                                <label for="CheckBox_CustomHRMAssessments_DDLimitSelfDirection">
                                                                    Self-direction</label>
                                                            </td>
                                                            <td class="checkbox_container">
                                                                <input type="checkbox" id="CheckBox_CustomHRMAssessments_DDLimitEconomic" name="CheckBox_CustomHRMAssessments_DDLimitEconomic" />
                                                                <label for="CheckBox_CustomHRMAssessments_DDLimitEconomic">
                                                                    Economic self-sufficiency</label>
                                                            </td>
                                                            <td class="checkbox_container">
                                                                <input type="checkbox" id="CheckBox_CustomHRMAssessments_DDLimitIndependentLiving"
                                                                    name="CheckBox_CustomHRMAssessments_DDLimitIndependentLiving" />
                                                                <label for="CheckBox_CustomHRMAssessments_DDLimitIndependentLiving">
                                                                    Capability for independent living</label>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="8" class="height1">
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
                </div>
            </td>
            
        </tr>
        <tr>
            <td  id="TdDxDDBottomSection" visible="false"  style="display:none"      >
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
        <tr>
            <td>
            <div id="DivDisableDX">
                <table border="0" cellspacing="0" cellpadding="0" >
                    <tr>
                        <td style=" width:98%" >
                        <uc1:Diagnosis ID="UserControl_UCDiagnosis" runat="server" />
                        </td>
                    </tr>
                </table>
                </div>
            </td>
        </tr>
    </table>
</div>


