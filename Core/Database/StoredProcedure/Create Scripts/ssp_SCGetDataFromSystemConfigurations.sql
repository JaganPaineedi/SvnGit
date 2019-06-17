/****** Object:  StoredProcedure [dbo].[ssp_SCGetDataFromSystemConfigurations]    Script Date: 6/28/2013 9:29:31 AM ******/
IF OBJECT_ID('dbo.ssp_SCGetDataFromSystemConfigurations') IS NOT NULL 
    DROP PROCEDURE [dbo].[ssp_SCGetDataFromSystemConfigurations]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetDataFromSystemConfigurations]    Script Date: 6/28/2013 9:29:31 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[ssp_SCGetDataFromSystemConfigurations]
AS 
    BEGIN                                                  
/*********************************************************************/                                                    
/* Stored Procedure: dbo.ssp_SCGetDataFromSystemConfigurations                */                                           
                                          
/* Copyright: 2005 Provider Claim Management System             */                                                    
                                          
/* Creation Date:  30/10/2006                                    */                                                    
/*                                                                   */                                                    
/* Purpose: Gets Data From SystemConfigurations Table  */                                                   
/*                                                                   */                                                  
/* Input Parameters: None */                                                  
/*                                                                   */                                                     
/* Output Parameters:                                */                                                    
/*                                                                   */                                                    
/* Return:   */                                                    
/*                                                                   */                                                    
/* Called By: getSystemConfigurations() Method in MSDE Class Of DataService  in "Always Online Application"  */                                          
/*      */                                          
                                          
/*                                                                   */                                                    
/* Calls:                                                            */                                                    
/*                                                                   */                                                    
/* Data Modifications:                                               */                                                    
/*                                                                   */                                                    
/*   Updates:                                                          */                                                    
                                          
/*       Date              Author                  Purpose                                    */                                                    
/*  30/10/2006    Piyush Gajrani                   Created       */                                    
/*  25th Nov ,2008 Vikas Vyas                      Prupose:Add New Field CssCustomWebDocuments       */                                                    
/*  11th May ,2009 Anuj                      Prupose:Add New Field TreatmentPlanBannerId ,AssessmentBannerId ,PeriodicReviewBannerId ,DiagnosisBannerId ,GeneralDocumentsBannerId        */                                      
/*  18th May ,2009 Rohit                     Prupose:Added New Field ScannedMedicalRecordAuthorId */                           
                        
/*  15 Jan ,2010 Vikas Monga                     Prupose:Added New Fields (AutoSaveTimeDuration,AutoSaveEnabled) */                           
/* 21 jun 2011 Priya              Added new field AllowMessageToBePartOfClientRecord,  DefaultMessageToBePartOfClientRecord */                   
/* 13/10/2011   Maninder			Added field AllowStaffAuthorizations */
/* 18 Oct 2011 Devi Dayal			Added The COlumn ScreenCustomTabExceptions for the Custom Tab Added on the CUstom Detail Screen #ref 15 Sc Honey Badger*/
/* 22 Nov 2011 Rohit Katoch Added New Column DocumentsDefaultCurrentEffectiveDate,Task#21 in Harbor Development */
/*			Devi Dyal		Added Column UseKeyPhrases */
/* 09 Dec 2011  Karan Garg    Added column DocumentLockCheckProcessFrequency*/ 
/* 12 Dec 2011 Maninder Added New Column HideCustomAuthorizationControls,Task#68,task#69 in Harbor Development */
/* 03 Jan 2012	Shifali		  Modified - Added Fields DocumentsDefaultCurrentEffectiveDate,HideCustomAuthorizationControls while merging Threshold Phase I with PhaseII*/
/* 04 Jan 2012	Shifali	Modified - Added Columns DocumentsInProgressShowWatermark, DocumentsInProgressWatermarkImageLocation*/
/* 23 Jan 2012  Karan Garg    Added column DocumentSignaturesNoPassword*/ 
/* 3 April 2012 Amit Kumar Srivastava    Added column DiagnosisHideAxisIIISpecify,DiagnosisAxisIVShowNone, #17, Diagnosis Document Changes (Development Phase III (Offshore))(THRESHOLDSOFF3),*/ 
/* 18 April 2012 Devi Dayal		Added Column ShowTPGoalsOnServiceTab,ServiceOutTimeNotRequiredOnSave #ref 8 Threshold Phase 3 Service Note CHanges*/
/* 24 April 2012 Vikas Kashyap		Added Column ReleaseReminderDay w.r.t.Task#14 Threshold Phase 3 Client Information*/
/* 29 April 2012 Shifali		Added Column ServiceNoteDoNotDefaultDate*/
/* 2May2012		 Shifali		Replaced ReleaseReminderDay with ReleaseReminderDays*/
/* 11 Dec 2012   Raghum         Added new column name HelpURL in order to get the url for redirecting the page on click of HelpIcon on Application Page as per task#12 in Development Phase IV(Offshore)*/
/* 12Dec2012     Rahul Aneja	Added Column DefaultAppointmentDurationWhenNotSpecified **************************/
/* 14 Jan 2013   Vishant Garg   Added column FlowSheetSpecificToClient     */
/* 12 Jan 2013	 Pradeep			Added UseSignaturePad column */
/* 22 March 2013 Sudhir Singh		Added ScannedDocumentDefaultAssociation column  as per task #746 in SC Web Phase II Bugs/feautres*/
/* 03 April 2013 Rakesh Garg 	 Get Newly added field in Data Model 12.72 in 3.5xMerge "ServiceInTimeNotRequiredOnSave" in Select Statement Ref. to task 274
 in 3.5x Issues*/
 /* 27 October 2013 SuryaBalan Added DeductiblesNeverMetMonthsFromToday Column in Datamodel in 13.02-13.03*/
 /* 15 November 2013    Gautam     Added DataModelVersion column -- Required for Automated DB upgrade process */
 -- 04 July 2014		Malathi Shiva	Included existing column "ClaimPopulationDropDown" in the select query
 -- 17 July 2014		Prasan	Included existing column "NumberOfSecurityQuestions" in the select query
 -- 29 October 2014		Varun	Included  column "DisableAuditLog" in the select query
/*********************************************************************/                     
                                                
        SELECT  OrganizationName ,
                ClientBannerDocument1 ,
                ClientBannerDocument2 ,
                ClientBannerDocument3 ,
                ClientBannerDocument4 ,
                ClientBannerDocument5 ,
                ClientBannerDocument6 ,
                StateFIPS ,
                LastUserName ,
                FiscalMonth ,
                DatabaseVersion ,
                SmartCareVersionMinimum ,
                SmartCareVersionMaximum ,
                PracticeManagementVersionMinimum ,
                PracticeManagementVersionMaximum ,
                CareManagementVersionMinimum ,
                CareManagementVersionMaximum ,
                ProviderAccessVersionMinimum ,
                ProviderAccessVersionMaximum ,
                CareManagementServer ,
                CareManagementDatabase ,
                AutoCreateDiagnosisFromAssessment ,
                CareManagementInsurerId ,
                IntializeAssessmentDiagnosis ,
                CareManagementInsurerName ,
                CareManagementComment ,
                ClientStatementSort1 ,
                ClientStatementSort2 ,
                SCDefaultDoNotComplete ,
                PMDefaultDoNotComplete ,
                MedicationDaysDefault ,
                MedicationDatabaseVersion ,
                RecurringAppointmentsExpandedFromDays ,
                RecurringAppointmentsExpandedToDays ,
                RecurringAppointmentsExpandedFrom ,
                RecurringAppointmentsExpandedTo ,
                ProgramsBannerText ,
                ShowGroupsBanner ,
                ShowBedCensusBanner ,
                FilterTPAuthorizationCodesByAssigned ,
                ShowTPProceduresViewMode ,
                UPPER(DisableNoShowNotes) AS DisableNoShowNotes ,
                UPPER(DisableCancelNotes) AS DisableCancelNotes ,
                CredentialingExpirationMonths ,
                CredentialingApproachingExpirationDays ,
                ScannedMedicalRecordAuthorId ,                                    
--CssCustomWebDocuments,                                      
                CreatedBy ,
                CreatedDate ,
                ModifiedBy ,
                ModifiedDate ,
                TreatmentPlanBannerId ,
                AssessmentBannerId ,
                PeriodicReviewBannerId ,
                GeneralDocumentsBannerId ,
                DiagnosisBannerId                          
--DocumentListPageDefaultDocumentBannerId,ServicesBannerId  //commented by sonia as per DataModel changes these fields were not found                          
                ,
                AutoSaveTimeDuration ,
                AutoSaveEnabled ,
                SystemDatabaseId ,
                ProxyVerificationMessage ,
                ConsentDurationMonths ,
                MedConsentsRequireClientSignature ,
                ReleaseListPageDefaultDocumentBannerId ,
                NumberOfPrescriberSecurityQuestions ,
                ListPageRowsPerPage ,
                EmergencyAccessMinutes ,
                AllowMessageToBePartOfClientRecord ,
                DefaultMessageToBePartOfClientRecord ,
                ClientEducationHealthDataMonths ,
                AllowStaffAuthorizations ,
                ServiceDetailsServicePagePath ,
                ServiceNoteServicePagePath ,
                ScreenCustomTabExceptions ,
                UseKeyPhrases ,
                ISNULL(DocumentLockCheckProcessFrequency, 0) AS DocumentLockCheckProcessFrequency ,
                DocumentsDefaultCurrentEffectiveDate ,
                HideCustomAuthorizationControls ,
                DocumentsInProgressShowWatermark ,
                DocumentsInProgressWatermarkImageLocation ,
                DocumentSignaturesNoPassword ,
                ShareDocumentOnSave ,
                ISNULL(DiagnosisHideAxisIIISpecify, 'N') AS 'DiagnosisHideAxisIIISpecify' ,
                ISNULL(DiagnosisAxisIVShowNone, 'N') AS 'DiagnosisAxisIVShowNone' ,
                ISNULL(ShowTPGoalsOnServiceTab, 'N') AS 'ShowTPGoalsOnServiceTab' ,
                ISNULL(ServiceOutTimeNotRequiredOnSave, 'N') AS 'ServiceOutTimeNotRequiredOnSave' ,
                ReleaseReminderDays ,
                ServiceNoteDoNotDefaultDate ,
                PopulationTracking ,
                HelpURL ,
                DefaultAppointmentDurationWhenNotSpecified ,
                FlowSheetSpecificToClient ,
                UseSignaturePad ,
                ScannedDocumentDefaultAssociation ,
                ServiceInTimeNotRequiredOnSave , -- Added by Rakesh Added new field in 3.5x Merge in Data Model 12.72
                AllowedResourceCount----Added by jagan, added two new fields which were overriding Chuck changes
				,UseResourceForService---corrected incorrect syntax, changes made by jagan--
				,DeductiblesNeverMetMonthsFromToday --Added by SuryaBalan, added new fields in 3.5x Merge in Data Model in 13.02-13.03    
				,DataModelVersion -- Added by Gautam -- Required for Automated DB upgrade process   
				,ClaimPopulationDropDown   
				,NumberOfSecurityQuestions
				,DisableAuditLog    
        FROM    SystemConfigurations                                          
                                          
                                    
                                    
  --Checking For Errors                                  
        IF ( @@error != 0 ) 
            BEGIN                                          
                RAISERROR  20006   'ssp_SCGetDataFromSystemConfigurations: An Error Occured'                                         
                RETURN                                          
            END                                                   
                                                  
         
    END 


GO


