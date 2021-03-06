/****** Object:  StoredProcedure [dbo].[csp_SCGetCustomAdvanceAdequateNotices]    Script Date: 06/19/2013 17:49:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetCustomAdvanceAdequateNotices]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCGetCustomAdvanceAdequateNotices]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetCustomAdvanceAdequateNotices]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/****************************************************************************/                                                    
 /* Stored Procedure:csp_SCGetCustomAdvanceAdequateNotices                   */                                           
 /* Copyright: 2006 Streamlin Healthcare Solutions                           */         
 /* Author: Pradeep                                                          */                                                   
 /* Creation Date:  Sept11,2009                                              */                                                    
 /* Purpose: Gets Data for PrePlanning CheckList Document                    */                                                   
 /* Input Parameters: @DocumentId, @DocumentVersionId                        */                                                  
 /* Output Parameters:None                                                   */                                                    
 /* Return:                                                                  */                                                    
 /* Calls:                                                                   */        
 /* Called From:                                                             */                                                    
 /* Data Modifications:                                                      */                                                    
 /*                                                                          */    
 /*-------------Modification History--------------------------               */
 /* 03/04/2010 Vikas Monga													 */  
 /* -- Remove [Documents] and [DocumentVersions]							 */                           
 /****************************************************************************/ 
CREATE PROCEDURE  [dbo].[csp_SCGetCustomAdvanceAdequateNotices]                                     
(                                          
  @DocumentVersionId int                                       
)                                          
As                                          
BEGIN                        
   BEGIN TRY     
   --For CustomAdvanceAdequateNotices Table                     
	SELECT     DocumentVersionId, MedicaidCustomer, GuardianName, DateOfNotice, StaffId, ActionRequestedServices, ActionRequestedServicesSpecifier, 
						  ActionRequestedServicesType, ActionRequestedServicesRevisionComment, ActionRequestedServicesOtherComment, ActionRequestedServicesEffectiveDate, 
						  ActionRequestedServicesNameOfServices, ActionCurrentServices, ActionCurrentServicesType, ActionCurrentServicesEffectiveDate, 
						  ActionCurrentServicesNameOfServices, ReasonEligibility, ReasonEligibilityClinical, ReasonEligibilityClinicalMedicaid, ReasonEligibilityClinicalMedicaidPlan, 
						  ReasonEligibilityClinicalMedicaidPhone, ReasonEligibilityOther, ReasonEligibilityOtherInsurance, ReasonEligibilityOtherPrimaryCareDoctor, 
						  ReasonEligibilityOtherProviderAgency, ReasonEligibilityResidency, ReasonEligibilityInInstitution, ReasonMedicalNecessity, ReasonMedicalNecessityDocumentation, 
						  ReasonMedicalNecessityIndividualPlan, ReasonMedicalNecessityAttendance, MedicalNecessityReasonAttendanceDate, ReasonOther, ReasonOtherCoverage, 
						  ReasonOtherCoverageContact, ReasonOtherTermination, NoticeProvidedVia, NoticeProvidedDate, RowIdentifier, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, 
						  RecordDeleted, DeletedDate, DeletedBy
	FROM         CustomAdvanceAdequateNotices
	WHERE     (ISNULL(RecordDeleted, ''N'') = ''N'') AND (DocumentVersionId = @DocumentVersionId)                                                     
 END TRY                        
 BEGIN CATCH                        
   DECLARE @Error VARCHAR(8000)                                                           
   SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                          
   + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''[csp_SCGetCustomAdvanceAdequateNotices]'')                                                           
   + ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****ERROR_SEVERITY='' + Convert(varchar,ERROR_SEVERITY())                                                          
   + ''*****ERROR_STATE='' + Convert(varchar,ERROR_STATE())                                                          
   
   RAISERROR ( @Error, /* Message text.*/16, /* Severity.*/ 1 /*State.*/ );                                                  
                       
 END CATCH                                      
End
' 
END
GO
