/****** Object:  StoredProcedure [dbo].[csp_SCGetCustomPersonalCareAssessment]    Script Date: 06/19/2013 17:49:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetCustomPersonalCareAssessment]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCGetCustomPersonalCareAssessment]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetCustomPersonalCareAssessment]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/****************************************************************************/                                                        
 /* Stored Procedure:csp_SCGetCustomPersonalCareAssessment               */                                               
 /* Copyright: 2006 Streamlin Healthcare Solutions                           */             
 /* Author: Pradeep                                                          */                                                       
 /* Creation Date:  Aug 27,2009                                              */                                                        
 /* Purpose: Gets Data for Custom Personal Care Assessment  Document         */                                                       
 /* Input Parameters: @DocumentId, @DocumentVersionId                        */                                                      
 /* Output Parameters:None                                                   */                                                        
 /* Return:                                                                  */                                                        
 /* Calls:                                                                   */            
 /* Called From:                                                             */                                                        
 /* Data Modifications:                                                      */                                                        
  /*-------------Modification History--------------------------               */      
 /*-------Date----Author-------Purpose---------------------------------------*/       
 /* 11 Sept,2009  Pradeep      Made changes as per dataModel Venture3.0      */
 /* 28 Sept 2009  Pradeep      Comented selection from SystemConfigurations as it is not in use  */                                                        
 /* 03/04/2010 Vikas Monga             */  
/* -- Remove [Documents] and [DocumentVersions]        */                        
 /****************************************************************************/ 
CREATE PROCEDURE  [dbo].[csp_SCGetCustomPersonalCareAssessment]                                        
  @DocumentVersionId INT                                           
AS                                          
BEGIN                            
  BEGIN TRY            
   --For CustomPersonalCareAssessment Table                                                               
	SELECT     DocumentVersionId, DateOfNotice, PersonalCareHouseKeeping, PersonalCareEatingOrFeeding, PersonalCareToileting, PersonalCareBathing, PersonalCareDressing, 
					  PersonalCareGrooming, PersonalCareTransferring, PersonalCareAmbulation, PersonalCareMedication, AveragePersonalCareHoursPerDay, 
					  PersonalCarePerDiemRate, CLSMealPreperation, CLSLaundry, CLSHouseholdMaintenance, CLSDailyLiving, CLSShopping, CLSMoneyManagement, CLSSocializing, 
					  CLSTransportation, CLSLeisureChoice, CLSMedicalAppointments, CLSMonitoringAndProtection, CLSMonitoringSelfAdministration, AverageCLSHoursPerDay, 
					  CLSPerDiemRate, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, RecordDeleted, DeletedDate, DeletedBy
	FROM         CustomPersonalCareAssessment
	WHERE     (ISNULL(RecordDeleted, ''N'') = ''N'') AND (DocumentVersionId = @DocumentVersionId)      
   --For SystemConfigurations Table
           
  -- SELECT [OrganizationName]      
  --    ,[ClientBannerDocument1]      
  --    ,[ClientBannerDocument2]      
  --    ,[ClientBannerDocument3]      
  --    ,[ClientBannerDocument4]      
  --    ,[ClientBannerDocument5]      
  --    ,[ClientBannerDocument6]      
  --    ,[StateFIPS]      
  --    ,[LastUserName]      
  --    ,[FiscalMonth]      
  --    ,[DatabaseVersion]      
  --    ,[CustomDatabaseVersion]      
  --    ,[SmartCareVersionMinimum]      
  --    ,[SmartCareVersionMaximum]      
  --    ,[PracticeManagementVersionMinimum]      
  --    ,[PracticeManagementVersionMaximum]      
  --    ,[CareManagementVersionMinimum]      
  --    ,[CareManagementVersionMaximum]      
  --    ,[ProviderAccessVersionMinimum]      
  --    ,[ProviderAccessVersionMaximum]      
  --    ,[CareManagementServer]      
  --    ,[CareManagementDatabase]      
  --    ,[AutoCreateDiagnosisFromAssessment]      
  --    ,[CareManagementInsurerId]      
  --    ,[IntializeAssessmentDiagnosis]      
  --    ,[CareManagementInsurerName]      
  --    ,[CareManagementComment]      
  --    ,[ClientStatementSort1]      
  --    ,[ClientStatementSort2]      
  --    ,[SCDefaultDoNotComplete]      
  --    ,[PMDefaultDoNotComplete]      
  --    ,[MedicationDaysDefault]      
  --    ,[MedicationDatabaseVersion]      
  --    ,[RecurringAppointmentsExpandedFromDays]      
  --    ,[RecurringAppointmentsExpandedToDays]      
  --    ,[RecurringAppointmentsExpandedFrom]      
  --    ,[RecurringAppointmentsExpandedTo]      
  --    ,[ProgramsBannerText]      
  --    ,[ShowGroupsBanner]      
  --    ,[ShowBedCensusBanner]      
  --    ,[FilterTPAuthorizationCodesByAssigned]      
  --    ,[ShowTPProceduresViewMode]      
  --    ,[DisableNoShowNotes]      
  --    ,[DisableCancelNotes]      
  --    ,[CredentialingExpirationMonths]      
  --    ,[CredentialingApproachingExpirationDays]      
  --    ,[ImageDatabaseConfigurationName]      
  --    ,[MedicationPatientOverviewTemplate]      
  --    ,[ScannedMedicalRecordAuthorId]      
  --    ,[AssessmentBannerId]      
  --    ,[TreatmentPlanBannerId]      
  --    ,[PeriodicReviewBannerId]      
  --    ,[GeneralDocumentsBannerId]      
  --    ,[DiagnosisBannerId]      
  --    ,[CreatedBy]      
  --    ,[CreatedDate]      
  --    ,[ModifiedBy]      
  --    ,[ModifiedDate]        
  --FROM SystemConfigurations        
           
 END TRY                            
 BEGIN CATCH                            
  DECLARE @Error varchar(8000)                                                               
  SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                
  + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''[csp_SCGetCustomPersonalCareAssessment]'')                                                               
  + ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****ERROR_SEVERITY='' + Convert(varchar,ERROR_SEVERITY())                                                              
  + ''*****ERROR_STATE='' + Convert(varchar,ERROR_STATE())                                                              
  
  RAISERROR ( @Error, /* Message text.*/16, /* Severity.*/ 1 /*State.*/ );                                                  
                      
 END CATCH                                          
End
' 
END
GO
