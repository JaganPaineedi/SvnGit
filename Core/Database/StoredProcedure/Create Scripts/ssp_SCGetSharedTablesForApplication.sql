IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetSharedTablesForApplication]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetSharedTablesForApplication]
GO
CREATE PROCEDURE [dbo].[ssp_SCGetSharedTablesForApplication]                                                                                                          
/******************************************************************************                                                                                                                                      
**File: SharedTables.cs                                                                                                                                      
**Name:SHS.DataServices                                                                                                                    
**Desc:Used to get all Shared Tables related to SC Application                                                                                                                      
**Return values:                                                                                                                                      
**                                                                                                                                                   
**  Parameters:                                                                                                                                      
**  Input       Output                                                                                                                                      
**                                                                                                                         
**                                                                                                                                
**                                                                                                                                  
**                                                                                                                                
**  Auth:  Sonia Dhamija                                                                                                                              
**  Date:  12th June                                                                                                                                     
*******************************************************************************                                                                                                                                      
**  Change History                                                                                                                                      
*******************************************************************************                                                                                                                                      
**  Date:         Author:                Description:                                                                                               
**  8 Dec 2009    Pradeep                 exec ssp_SCGetDataForGroupServicesStaff and ssp_PMGetDataFromGroup                                                                                              
**                                         for GroupServiceStaff                                                                                            
** 15 Dec 2009    Pradeep                  exec ssp_GetGroupNoteDocumentodes to get GroupNoteDocumentCode                                                                                                              
** 05 Jan 2010    Shiv                     exec ssp_PMScanGetStaffList and ssp_PMScanGetRecordList to get Scanned Staff List and Scanned Record Types                                                                                                          
  
** 19 Jan 2010    Vikas Vyas      exec ssp_SCGetStaffLocations                                                               
** 15 Feb 2010    Ashwani Kumar Angrish    exec ssp_SCGetRecommendedServices               
** 5th March 2010   Priya    ssp_SCGetinsurersTable                                     
** 20th March 2010  Vikas Vyas              exec ssp_SCEventTypes                                                                            
** 25 May 2010     Ashwani Kuamr Angrish      added ssp_SCGetCustomHRMNeeds                        
** 8th July 2010   Priya                     delete    ssp_SCGetDataFromPharmacies as it is used in medication Management with parameter 'ClientId'                            
            
**29Sept,2010  Shifali     added ssp_SCGetTPServiceAuthorisationCodes            
**s9Sept,2010  Shifali     added ssp_SCGetCustomLOCCategories            
**21April,2011 Damanpreet  added ssp_SCGetStaffClientAccessAuditLogTables                                                 
**2 August 2011  Minakshi  added ssp_SCGetServiceConfiguration       
**13 August 2011 Devi Dayal Added ssp_GetMemberLifeEvent      
**15 September 2011 MSuma Included by SHS Bangalore   
**03 Oct. 2011 Davinder Kumar Added ssp_SCGetDataFromClientSearchCustomConfigurations (For enable ClientSerach Custom Button)  
**31 Oct 2011   Girish  Added ssp_PMGetCoveragePlanRuleTypes  
**10 April 2012 Rakesh   Added ssp_SCGetBillingCodeModifiers used of filling billingcodemodifiers in shared tables for task 112    
** 17 May 2012  inculded the SP ssp_SCGetScreenControlsHelp for the For Ace Project SC Web 3.5 Bugs/Features #3    
** 06 June 2012 Veena included the SP ssp_PMGetApplicationMessages for implementing Custom Messages.   
** 26 June 2012 Bernard included the SP ssp_PMGetScreenLabels for implementing Label Replacement.                                                                                                                                             
** 3 Oct 2012 Chuck Blaine	included the SP ssp_SCGetNoteTags for Primary Care - Progress Notes
** 22 Oct 2012 Pradeep Included ssp_SCGetNoteTemplates for primary Care - Progress Notes
** 03 April 2013 Bernardin included SSP_GetSystemConfigurationKeyValues to added all Web.Config key values
** 03 April 2014	Rohith Uppin	included ssp_SCGetStaffListPermissions to get Staff permission in new table
** 22 May 2014	Bernardin	included ssp_SCGetDiagnosisICD10Mapping to get Staff permission in new table
** 26 May 2014	Bernardin	Commentted ssp_SCGetStaffListPermissions
** 12 Jun 2014	Rohith		included ssp_SCGetStaffListPermissions
** 12 Jun 2014 SuryaBalan included ssp_SCGetCMProviders to get distinct Providers list alone
** 01 Dec 2014 Bernardin  Removed ICD10 diagnosis master table form application shared table
** 24 Mar 2015  Veena       Added Financial Assignments table in the shared tables Valley Customization #950   
** 01 Sep 2015  Shankha		Added Flag Tyoe as part of Core Bugs# 1891
** 12-26-2017	Rajesh		Added ssp_GetScreenObjectCollections	 EII579- DFA Detail Page
** 07-10-2018	Swatika		Added ssp_SCGetUnits	Bradford - Enhancements: Task# 400.2
** 13 Sep 2017  Rahul		Added ssp_SCGetVerboseModeConfiguration sp to load the new Application Shared Table VerboseModeConfigurations
** 02-28-2018	Rahul		Removed system configuration check condition for calling ssp_SCGetVerboseModeConfiguration
** 26-03-2019   Jyothi      Added  ssp_SCGetSUDrug   As part of OASAS - Customization -#62000
*******************************************************************************/                                             
AS                                                     
 BEGIN                                                                                       
                                                                                      
  BEGIN TRY                                                                                            
                                                                                     
 exec ssp_SCGetDataFromGlobalCodes --Global Codes                                                                                                          
 exec ssp_SCGetDataFromGlobalSubCodes -- Global Sub Codes                                                                                               
 exec ssp_SCGetProcedureCodes --Procedure Codes                        
 --exec ssp_SCGetDataFromPharmacies --Pharmacies                                                              
 exec ssp_SCGetDataFromCounties --Counties                                                                                                          
 exec ssp_SCGetDataFromStates --States                                                                                                                   
 exec ssp_SCGetDataFromSystemConfigurations -- SystemConfigurations                                                                                                          
 exec ssp_SCGetDataFromPrograms --Programs                                                                                      
                                                                    
 exec ssp_SCGetDataFromLocations --Locations                                                                                                          
 exec ssp_SCDiagnosisDSMDescriptionsSelAll -- Diagnosis Descriptions                                                                                                          
 exec ssp_SCGetAuthorisationCodes --AuthorizationCodes   
 exec ssp_SCGetDrugTable --Drugs                                                                                                          
 exec ssp_SCGetDocumentBanners -- DocumentBanners                                                                                                          
 exec ssp_SCGetProviders --GetProviders                                                                                               
 exec ssp_SCGetDocumentCodes -- DocumentCodes                                                                                   
 exec ssp_SCGetStaffProcedures -- Staff Procedures                                                                                                        
 exec ssp_SCGetScreens -- Screens                                                                                                      
 exec ssp_SCGetStaffDetails -- Staff                                                                                                      
 exec csp_SCGetDiagnosisAxisICDcodesDSMDescriptionsAxisVRanges -- For Diagnosis ICDCodes and AxisV Ranges.  \                                                                           
 exec ssp_SCGetBanners -- Banners Data                   
 exec ssp_SCGetTabs --Tabs Data                                                                                                  
 exec ssp_SCGetDynamicFormTables --Dynamic Form Tables                     
 exec ssp_SCGetDataForGroupServicesStaff--only staff that belongs to groupService                                                                                              
 exec ssp_PMGetDataFromGroup--Groups                                                                                 
 exec ssp_SCGetDataForGroupProgram--GroupsProgram                                                                                          
 exec ssp_GetGroupNoteDocumentodes--GroupNoteDocumentCode                                                                                          
 exec ssp_SCGetStaffLocations     --Staff location                                                                                       
 exec ssp_SCGetRecommendedServices --Get Recommended Services                                                                                     
 exec ssp_SCGetCustomSUDrug-- CustomSUDrugs                                                                             
 exec ssp_SCGetCustomASAMLevelOfCares -- CustomASAMLevelOfCares                                                
 exec  ssp_SCGetCustomHRMNeeds---------Custom HRM NEEDs                            
 exec ssp_SCGetInsurers   ---Insurer Table                                                                     
 exec ssp_SCGetSites    --- Sites Table                                                                    
 exec ssp_SCEventTypes -- Get EventType                                                           
 exec ssp_SCGetDataFromSystemDataBases -- Get SystemDataBase                                           
 --exec ssp_GetCustomHRMActivities -- For Custom HRM Activities                                                      
 exec ssp_SCGetInsurerByProvider --Insurer Table join with Contracts table                                                                
                             
 exec ssp_PMScanGetStaffList --Scanned Staff List                                                                                          
 exec ssp_PMScanGetRecordList -- Scanned Record List                       
 exec ssp_SCGetDocumentBookMarks --Document BookMarks               
 Select * From ImageServers                                                                                     
 exec ssp_SCGetTaskConfiguration --OM Task                  
 exec ssp_SCGetTaskConfigurationReports  --OM Task ConfigurationReports              
 --exec ssp_SCGetTPServiceAuthorisationCodes -- TP Service AuthorizationCodes            
 exec ssp_SCGetCustomLOCCategories  -- Assessment CustomLOCCategories            
 exec ssp_SCWebGetDataForJavaScriptTemplates -- Added by ASG additions team(streamline)          
  exec ssp_SCGetFormCollections  -- Added by Shifali on 11Mar,2011          
 exec ssp_SCGetFormCollectionForms -- Added by shifali on 11March,2011          
 exec ssp_SCGetDataFromCustomConfigurations --- Custom COnfigurations          
 exec ssp_SCGetStaffClientAccessAuditLogTables -- Added by Damanpreet on 21April,2011    
  --******************Added By Davinder Kumar***************************************************  
  exec ssp_SCGetDataFromClientSearchCustomConfigurations  
  --******************End***********************************************************************       
        
 --********************Added by Bangalore Team *****************************************                                                                      
 exec ssp_PMGetCoveragePlans --CoveragePlans        
 exec ssp_PMGetReceptionViews --Reception Views        
 exec ssp_PMGetAllPayers --Payers        
 exec ssp_PMGetProgramViews --ProgramsViews                                                                          
 exec ssp_PMGetGlobalCodeCategories --Global Code Categories                                                     
 exec ssp_PMGetAccountingPeriods --Accounting Periods                                                                          
 exec ssp_PMGetAllServiceAreas --ServiceAreas                                                                    
 exec ssp_PMGetAllModifiers --Modifiers                        
        
 --********************End Addition by Bangalore Team *****************************************                                                                      
         
  exec ssp_SCGetServiceConfiguration -- for Servide Configuration         
  /* removed from shared tables*/  
  --exec ssp_GetMemberLifeEvent-- Added By Devi Dayal on 22 Aug2011, For Life Event#3 Threshold    
  --********************Added by Bangalore Team ************************************************  
  exec ssp_PMGetLicenseAndDegreeGroups --License and Degree Groups   
  exec ssp_PMGetERSenders --ERSenders  
  exec ssp_PMGetClaimFormats --ClaimFormats  
  exec ssp_PMGetCoveragePlanRuleTypes --Coverage Plan Rule Types  
--exec ssp_PMGetApplicationMessages --Application Messages  
  
--********************End Addition by Bangalore Team *****************************************  
--Added by Rakesh for filling BillingCodeModifiers in Shared table     
 exec ssp_SCGetBillingCodeModifiers  --BillingCodeModifiers  
 exec ssp_SCGetScreenControlsHelp -- Controls Help Text  
     
 exec ssp_PMGetApplicationMessages --Application Messages  
 exec ssp_PMGetScreenLabels --Label Replacement  
 EXEC ssp_SCGetNoteTags --Note Tags
 EXEC ssp_SCGetNoteTemplates -- NoteTemplates
 exec SSP_GetSystemConfigurationKeyValues -- Web.Config key values

 --********** Task#05 - CM to SC Rohith uppin **********************************--
 --EXEC ssp_SCGetStaffListPermissions   -- To get Staff permission in seperate table
 --**************** End of Task#05 change *****************************--
 
 --EXEC ssp_SCGetDiagnosisICD10Mapping -- DiagnosisICD10Mapping (System Improvements Task# 2)
 --********** Task#05 - CM to SC Rohith uppin **********************************--
 EXEC ssp_SCGetStaffListPermissions   -- To get Staff permission in seperate table
 --**************** End of Task#05 change *****************************--
 EXEC ssp_SCGetCMProviders --To get Providers list alone and not in combination of Sites Name
   --Added by Veena on 24/03/2015 Valley Customization #950 Added Financial Assignment table in shared table.
 exec SSP_SCGetFinancialAssignments --Financial Assignments

--Added by Shankha on 09/01/2015 Core Bugs# 1891 to include Flag Types
 exec ssp_SCGetFlagTypes --Financial Assignments
 
 exec SSP_SCUpdateForms -- Update FormHTML as null
 
 exec ssp_GetScreenObjectCollections -- Added By Rajesh - EII579- DFA Detail Page
 
  --Added by Swatika on 07/10/2018 Bradford - Enhancements: Task# 400.2
 exec ssp_SCGetUnits
 
--Added by Rahul on 09/13/2017 EI#564 - To Implement Verbose Mode Logging in SmartCare Application
 --11 Nov 2017  Rahul
 exec ssp_SCGetVerboseModeConfiguration
 
 --  Added by Jyothi 0n 26/03/2019 OASAS- Customization - #62000
 exec ssp_SCGetSUDrug
 
  END TRY                                                                                                          
  BEGIN CATCH                                                                                            
   DECLARE @Error varchar(8000)                                                                                                                                    
         SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                                                                     
         + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_SCGetSharedTablesForSCApplication')                                                                                                                                     
         + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                                                                                     
         + '*****' + Convert(varchar,ERROR_STATE())                                                                                                                   
        RAISERROR                                                      
   (                                                                              
     @Error, -- Message text.                                                                                                  
     16, -- Severity.                       
     1 -- State.                                                              
    );                                                                                                                                    
  END CATCH                         
 END   
  
  


