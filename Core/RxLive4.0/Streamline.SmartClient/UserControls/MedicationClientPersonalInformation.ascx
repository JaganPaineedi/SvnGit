<%@ Control Language="C#" AutoEventWireup="true" CodeFile="MedicationClientPersonalInformation.ascx.cs"
    Inherits="UserControls_MedicationClientPersonalInformation" %>
<%@ Register TagPrefix="UI" TagName="Heading" Src="~/BasePages/UI/Heading.ascx" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Register TagPrefix="UI" TagName="HealthData" Src="~/UserControls/HealthDataList.ascx" %>
<%@ Register TagPrefix="UI" TagName="HealthGraph" Src="~/UserControls/HealthGraph.ascx" %>
<%@ Register TagPrefix="UI" TagName="ReconciliationData" Src="~/UserControls/ReconciliationDataList.ascx" %>
<%@ Register TagPrefix="UI" TagName="Eligibility" Src="~/UserControls/EligibilityViewer.ascx" %>
<%@ Register TagPrefix="UI" TagName="GrowthChart" Src="~/UserControls/GrowthChart.ascx" %>
<%@ Register TagPrefix="UI" TagName="MedHistory" Src="~/UserControls/MedicationHistoryViewer.ascx" %>

<meta http-equiv="CACHE-CONTROL" content="NO-CACHE" />
<meta http-equiv="PRAGMA" content="NO-CACHE" />
<asp:ScriptManagerProxy runat="server" ID="SMP2">
    <Scripts>
        <asp:ScriptReference Path="~/App_Themes/Includes/JS/ClientSearch.js?rel=3_5_x_4_1" NotifyScriptLoaded="true" />
    </Scripts>
</asp:ScriptManagerProxy>

<script type="text/javascript">
    $(document).ready(function() {

        //On Click Event
        $("ul.tabs li").click(function() {
            $("ul.tabs li").removeClass("active"); //Remove any "active" class
            $(this).addClass("active"); //Add "active" class to selected tab
            $(".tab_content").hide(); //Hide all tab content
            var activeTab = $(this).find("a").attr("href"); //Find the href attribute value to identify the active tab + content
            $(activeTab).fadeIn(); //Fade in the active ID content
            var heihtToSet = 0;
            var windowWidth = $(window).width();
            if (activeTab == "#tab7") {
                $("#tab7").height(190);
                $("#tab7").width(windowWidth - 305);
                heihtToSet = ($("#tab7").innerHeight()) - ($("[id$=TRMedicationTypeId]").innerHeight() + ($("#tableAddAllergy").innerHeight()) + $('[id$=TDInactiveAllergyButton]').innerHeight() + $("#NoKNownAllergiesTable").innerHeight());
                $("#DIVAllergiesList").height(heihtToSet);
                //MedicationMgt.AutoResizeMedicationList();
            } else if (activeTab == "#tab6") {
                $("#tab6").height(190);
                $("#tab6").width(windowWidth - 305);
                heihtToSet = ($("#tab6").innerHeight()) - ($("[id$=TRMedicationTypeId]").innerHeight() + ($("#tableAddAllergy").innerHeight()) + $('[id$=TDInactiveAllergyButton]').innerHeight() + $("#NoKNownAllergiesTable").innerHeight());
                $("#DIVAllergiesList").height(heihtToSet);
                //MedicationMgt.AutoResizeMedicationList();
            } else if (activeTab == "#tab5") {
                $("#tab5").height(190);
                heihtToSet = ($("#tab5").innerHeight()) - ($("[id$=TRMedicationTypeId]").innerHeight() + ($("#tableAddAllergy").innerHeight()) + $('[id$=TDInactiveAllergyButton]').innerHeight() + $("#NoKNownAllergiesTable").innerHeight());
                $("#DIVAllergiesList").height(heihtToSet);
                refreshGrowthChart();
                //MedicationMgt.AutoResizeMedicationList();
            } else if (activeTab == "#tab4") {
                $("#tab4").height(190);
                heihtToSet = ($("#tab4").innerHeight()) - ($("[id$=TRMedicationTypeId]").innerHeight() + ($("#tableAddAllergy").innerHeight()) + $('[id$=TDInactiveAllergyButton]').innerHeight() + $("#NoKNownAllergiesTable").innerHeight());
                $("#DIVAllergiesList").height(heihtToSet);
                refreshReconciliation();
                //MedicationMgt.AutoResizeMedicationList();
            } else if (activeTab == "#tab3") {
                ResetDates();
                $("#tab3").height(190);
                heihtToSet = ($("#tab3").innerHeight()) - ($("[id$=TRMedicationTypeId]").innerHeight() + ($("#tableAddAllergy").innerHeight()) + $('[id$=TDInactiveAllergyButton]').innerHeight() + $("#NoKNownAllergiesTable").innerHeight());
                $("#DIVAllergiesList").height(heihtToSet);
                refreshGraph();
                //MedicationMgt.AutoResizeMedicationList();
            }
            else if (activeTab == "#tab2") {
                $("#tab2").height(190);
                heihtToSet = ($("#tab2").innerHeight()) - ($("[id$=TRMedicationTypeId]").innerHeight() + ($("#tableAddAllergy").innerHeight()) + $('[id$=TDInactiveAllergyButton]').innerHeight() + $("#NoKNownAllergiesTable").innerHeight());
                $("#DIVAllergiesList").height(heihtToSet);
                refreshGraphList();
                //MedicationMgt.AutoResizeMedicationList();
            }
            else if (activeTab == "#tab1") {
                $("#tab1").height(190);
                heihtToSet = ($("#tab1").innerHeight()) - ($("[id$=TRMedicationTypeId]").innerHeight() + ($("#tableAddAllergy").innerHeight()) + $('[id$=TDInactiveAllergyButton]').innerHeight() + $("#NoKNownAllergiesTable").innerHeight());
                $("#DIVAllergiesList").height(heihtToSet);
                $("#DivHolderMain")[0].style.height = "100%";
                //MedicationMgt.AutoResizeMedicationList();
            }
            return false;
        });
        //When page loads...
        $(".tab_content").hide(); //Hide all content
        $('ul.tabs li:eq(<%= ActiveTab %>)').addClass("active").show(); //Activate first tab
        $(".tab_content:eq(<%= ActiveTab %>)").show(); //Show first tab content
        $('ul.tabs li:eq(<%= ActiveTab %>)').trigger("click");

    });
    
</script>

<table width="100%" height="100%" cellpadding="0" cellspacing="0" border="0" class="TablePatientSummary">
    <tr>
        <td valign="top">
            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                <tr>
                    <td style="width: 140px">
                      
                        <input id="ButtonEdit" style="font-size:12px;" type="button" value="Preferred Pharmacy..." onclick="return ShowPreferredPharmaciesDiv();"
                             <%=enableDisabled(Streamline.BaseLayer.Permissions.EditPreferredPharmacy)%> class="btnimglarge" />
                    </td>
                </tr>
            </table>
        </td>
        <td>&nbsp;
        </td>
        <td valign="bottom">
            <div id="tdKnownAllergiesHeading" runat="server">
                <UI:Heading ID="H1" runat="server" HeadingText="Allergies/Intolerances/Failed Trials" />
            </div>
        </td>
    </tr>
    <tr>
        <td id="tdHealthData" height="95%" valign="top" rowspan="2" style="border-bottom: 1px solid #ccccff;">
            <div style="height: 25px; width: 100%;" class="divHealthData">
                <ul class="tabs" style="height: 100%;">
                    <li style="left: 0px; top: 0px"><a href="#tab1"><span>Patient Overview</span></a>&nbsp;&nbsp;</li>
                    <li style="display: none;"><a href="#tab2"><span>Health Data</span></a>&nbsp;&nbsp;</li>
                    <li style="display: none;"><a href="#tab3"><span>Graph</span></a>&nbsp;&nbsp;</li>
                    <li style="left: 0px; top: 0px" <%= enableDisabled(Streamline.BaseLayer.Permissions.Reconciliation) == "Disabled" ? "style='display:none;'" : "" %>><a href="#tab4"><span>Reconciliation</span></a></li>
                    <%--<li <%= enableDisabled(Streamline.BaseLayer.Permissions.GrowthChart) == "Disabled" ? "style='display:none;'" : "" %>><a href="#tab5">Growth Chart</a></li>--%>
                    <li style="display: none;"><a href="#tab5">Growth Chart</a></li>
                    <li style="left: 0px; top: 0px" <%= enableDisabled(Streamline.BaseLayer.Permissions.Eligibility) == "Disabled" ? "style='display:none;'" : "" %>><a href="#tab6"><span>Eligibility</span></a></li>
                    <li style="left: 0px; top: 0px" <%= enableDisabled(Streamline.BaseLayer.Permissions.MedicationHistory) == "Disabled" ? "style='display:none;'" : "" %>><a href="#tab7"><span>Medication History</span></a></li>
                </ul>
            </div>
            <div style="width: 100%; height: 100%;">
                <div id="tab1" class="tab_content" style="height: 100%;">
                    <asp:Label ID="lableClientInformation" runat="server"></asp:Label>
                </div>
                <div id="tab2" class="tab_content" style="overflow-x: hidden; overflow-y: auto; height: 100%;">
                    <UI:HealthData ID="HealthData" runat="server" />
                </div>
                <div id="tab3" class="tab_content" style="height: 100%;">
                    <UI:HealthGraph ID="HealthGraph" runat="server" />
                </div>
                <div id="tab4" class="tab_content" style='height: 100%; <%= enableDisabled(Streamline.BaseLayer.Permissions.Reconciliation) == "Disabled" ? "display:none;": "" %>'>
                    <UI:ReconciliationData ID="ReconciliationData" runat="server" />
                </div>
                <div id="tab5" class="tab_content" style='height: 100%; <%= enableDisabled(Streamline.BaseLayer.Permissions.GrowthChart) == "Disabled" ? "display:none;": "" %>'>
                    <UI:GrowthChart ID="GrowthChart1" runat="server" />
                </div>
                <div id="tab6" class="tab_content" style='position: absolute; overflow: auto; height: 100%; <%= enableDisabled(Streamline.BaseLayer.Permissions.Eligibility) == "Disabled" ? "display:none;": "" %>'>
                    <UI:Eligibility ID="EligibilityView" runat="server" />
                </div>
                <div id="tab7" class="tab_content" style='position: absolute; overflow: auto; height: 100%; <%= enableDisabled(Streamline.BaseLayer.Permissions.MedicationHistory) == "Disabled" ? "display:none;": "" %>'>
                    <UI:MedHistory ID="MedHistoryView" runat="server" />
                </div>
            </div>
        </td>
        <td style="width: 10px">&nbsp;
        </td>
        <td style="width: 265px; border-top: #dee7ef 3px solid; border-right: #dee7ef 3px solid; border-left: #dee7ef 3px solid; border-bottom: #dee7ef 3px solid;"
            valign="top"
            rowspan="2">
            <table id="TableKnownallergies" width="100%" runat="server">
                <tr id="TRMedicationTypeId">
                    <td id="Td1" runat="server">
                        <asp:DropDownList ID="DropdownMedicationType" runat="server" Width="90%" onChange="FilterAllergy('N');">
                            <asp:ListItem Text="Show All" Value="All" Selected="True">           
                            </asp:ListItem>
                            <asp:ListItem Text="Allergies" Value="A"></asp:ListItem>
                            <asp:ListItem Text="Intolerances" Value="I"></asp:ListItem>
                            <asp:ListItem Text="Failed Trials" Value="F"></asp:ListItem>
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td valign="top" id="TDInactiveAllergyButton">
                        <span class="ButtonWeb">Show:</span>
                        <input type="radio" id="ClientAllergiesInactiveActiveRButton_All" name="ClientAllergiesInactiveActiveRButton"
                            onclick="ShowInactiveActiveButtonClickCall(this);" /><span class="radiobtntext">All</span>
                        <input type="radio" checked="checked" id="ClientAllergiesInactiveActiveRButton_Active"
                            name="ClientAllergiesInactiveActiveRButton" onclick="ShowInactiveActiveButtonClickCall(this);" /><span
                                class="radiobtntext">Active Only</span>
                    </td>
                </tr>
                <tr>
                    <td valign="top" id="TDKnownAllergiesId" runat="server">
                        <div id="DIVAllergiesList">
                        </div>
                    </td>
                </tr>
            </table>
            <table id="NoKNownAllergiesTable" width="100%">
                <tr>
                    <td>
                        <span class="ButtonWeb">
                            <input type="checkbox" id="CheckBoxNoKnownAllergies" onclick="ChangeNoKnownAllergiesCheckbox(this);" /><span
                                style="vertical-align:middle;"> No Known Allergies </span></span>
                    </td>
                </tr>
            </table>
            <table id="tableAddAllergy" border="0">
                <tr style="height: 10%">
                    <td valign="bottom">
                        <asp:TextBox ID="TextBoxAddAllergy" runat="server" Style="visibility: hidden; width: 100px;"
                            Enabled="true" TabIndex="1"></asp:TextBox>
                    </td>
                    <td valign="bottom">
                         
                        <input type="button" id="LinkButtonAddAllergy" style="visibility: hidden;" name="LinkButtonAddAllergy"
                            onclick="return ShowAllergySearchPage(); return false;" value="Add Allergy..." class="btnimgsmall"
                            runat="server" tabindex="2" />
                                                                                                             
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td colspan="3">
            <input id="HiddenSelectedAllergyId" type="hidden" runat="server" />
            <asp:LinkButton ID="LinkButtonSetAllergy" runat="server"></asp:LinkButton>
            <asp:Label ID="LabelClientScript" runat="server" Text="Label" Visible="false"></asp:Label>
        </td>
    </tr>
    <tr>
        <td colspan="3">
            <input type="hidden" id="HiddenClientAllergiesActiveInActiveType" value="active" />
            <input type="hidden" id="HiddenComments" />
            <input type="hidden" id="HiddenClientAllergiesAllergyType" />
            <input type="hidden" id="HiddenClientAllergiesActive" />
            <input type="hidden" id="HiddenClientAllergiesComments" />
        </td>
    </tr>
</table>

<script type="text/javascript" language="javascript">
    $(document).bind('allergyupdate', function() {
        AllergySearch.GetNoKnownAllergyFlag("CheckBoxNoKnownAllergies", "");
    });

    function ChangeNoKnownAllergiesCheckbox(obj) {
        var flag = $(obj)[0].checked == true ? 'Y' : 'N';
        AllergySearch.GetNoKnownAllergyFlag("CheckBoxNoKnownAllergies", flag);
    };

    function SaveAllergyData(flag, KeyValue, AllergyType, comments, active, AllergyReaction, AllergySeverity) {
        try {
            SaveClientAllergyData(flag, KeyValue, 'DIVAllergiesList', AllergyType, '<%=TextBoxAddAllergy.ClientID %>', '<%=HiddenSelectedAllergyId.ClientID %>', comments, active, AllergyReaction, AllergySeverity);
        }
        catch (ex) {
            alert('Error in Saving Allergy Data');
        }
    }

    //Function added by Loveena in Ref to Task#92 on 26-Dec-2008 to refresh the view of patient overview information.
    function RefreshPatientOverview(flag) {
        try {
            RefreshPatientOverviewArea(flag, '<%=lableClientInformation.ClientID %>');

        }
        catch (ex) {
            alert('Error in Refreshing Patient Overview Area');
        }
    }

    function DeleteAllergy(AllergyId, objRow, objTable) {
        DeleteClientAllergy(AllergyId, objRow, objTable, 'DIVAllergiesList');
    }
    //------------Modification History---------------------
    //----Date----Author-----Purpose------------------------
    //28 Oct,2009 Pradeep    Made changes as per task#9
    function FillAllergyControlofClientInformation(Editable) {
        try {
            var objectAllergyGrid;
            objectAllergyGrid = 'DIVAllergiesList';

            var showInactiveActive = document.getElementById("HiddenClientAllergiesActiveInActiveType").value || "active";
            var objectDropDown;
            var dropDownListId = document.getElementById('<%=DropdownMedicationType.ClientID %>');
            var FilterCriteria = dropDownListId.options[dropDownListId.selectedIndex].value + "," + showInactiveActive;
            //---Start Followingg line is added by Pradeep as per task#9
            FillAllergyControl(objectAllergyGrid, Editable, FilterCriteria);
            //---End line is added by Pradeep as per task#9
            //Start Code Comented By Pradeep as per task#9 
            HideAllergyControl('<%=TableKnownallergies.ClientID %>', '<%=TextBoxAddAllergy.ClientID %>', '<%=LinkButtonAddAllergy.ClientID %>', '<%=tdKnownAllergiesHeading.ClientID %>', 'N');

            HideDisplayAddAllergy('<%=TextBoxAddAllergy.ClientID %>', '<%=LinkButtonAddAllergy.ClientID %>', Editable);
        }
        catch (e) {

        }
    }

    function HideAllergyControlofClientInformation() {
        try {
            HideAllergyControl('<%=TableKnownallergies.ClientID %>', '<%=TextBoxAddAllergy.ClientID %>', '<%=LinkButtonAddAllergy.ClientID %>', '<%=tdKnownAllergiesHeading.ClientID %>', 'Y');
        }
        catch (e) {

        }
    }

    function ShowAllergySearchPage() {
        try {
            //MedicationMgt.ShowAllergySearchDiv('<%=TextBoxAddAllergy.ClientID %>');
            ShowAllergySearchDiv('<%=TextBoxAddAllergy.ClientID %>');
        }
        catch (e) {

        }

    }
    //Function Added by Loveena to Show/Hide EditPreferredPharmacy button on 26-Dec-2008

    function ShowEditPreferredPharmacy(Editable) {
        try {
            if (Editable == 'N') {
                document.getElementById('ButtonEdit').style.visibility = 'hidden';
            }
            else {
                document.getElementById('ButtonEdit').style.visibility = 'visible';
            }
        }
        catch (ex) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_USER_DEFINED, ex);
        }
    }
    //Function added by Pradeep as per task#9
    function FilterAllergy(Editable) {
        try {
            var objectAllergyGrid;
            objectAllergyGrid = 'DIVAllergiesList';
            var showInactiveActive = document.getElementById("HiddenClientAllergiesActiveInActiveType").value || "active";
            var dropDownListId = document.getElementById('<%=DropdownMedicationType.ClientID %>');
            var FilterCriteria = dropDownListId.options[dropDownListId.selectedIndex].value + "," + showInactiveActive;
            if (objectAllergyGrid == 'DIVAllergiesList') {
                Editable = 'Y';
            }
            //---Start Followingg line is added by Pradeep as per task#9
            FillAllergyControl(objectAllergyGrid, Editable, FilterCriteria);
            //---End line is added by Pradeep as per task#9

        }
        catch (ex) {
        }
    }

    function ShowInactiveActiveButtonClickCall(obj) {
        setTimeout(function() { ShowInactiveActiveButtonClick(obj) }, 100);
        return true;
    }

    function ShowInactiveActiveButtonClick(obj) {
        if ($(obj).attr('id') == 'ClientAllergiesInactiveActiveRButton_Active') {
            document.getElementById("HiddenClientAllergiesActiveInActiveType").value = "active";
        } else {
            document.getElementById("HiddenClientAllergiesActiveInActiveType").value = "inactive";
        }
        FilterAllergy('N');
    }

    //Added by Loveena in ref to Task#86
    function OpenAllergyComment(ClientAllergyId, AllergyType, Comments) {
        //Added By Priya Ref:Task no:2829
        $("input[id*=HiddenComments]").val(document.getElementById(Comments).value.toString().replace(/\^&/g, "'"));
        OpenComment(ClientAllergyId, AllergyType)
    }

    function OpenAllergyCommentDetails(ClientAllergyId, allergyType, active, comments) {
        var FilterList = (document.getElementById('<%=DropdownMedicationType.ClientID %>').value || "All") + "," +
                                        (document.getElementById("HiddenClientAllergiesActiveInActiveType").value || "active");
        AllergySearch.OpenCommentDetails(ClientAllergyId, allergyType, active, comments, FilterList);
    } 
</script>

