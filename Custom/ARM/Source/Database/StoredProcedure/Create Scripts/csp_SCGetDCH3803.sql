/****** Object:  StoredProcedure [dbo].[csp_SCGetDCH3803]    Script Date: 06/19/2013 17:49:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetDCH3803]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCGetDCH3803]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetDCH3803]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/****************************************************************************/                                                    
 /* Stored Procedure:csp_SCGetDCH3803Test                                    */                                           
 /* Copyright: 2006 Streamlin Healthcare Solutions                           */         
 /* Author: Pradeep                                                          */                                                   
 /* Creation Date:  Aug 20,2009                                              */                                                    
 /* Purpose: Gets Data for DCH3803 Document                                  */                                                   
 /* Input Parameters: @DocumentId, @DocumentVersionId                        */                                                  
 /* Output Parameters:None                                                   */                                                    
 /* Return:                                                                  */                                                    
 /* Calls:                                                                   */        
 /* Called From:                                                             */                                                    
 /* Data Modifications:                                                      */                                                    
 /*                                                                          */
 /*-------------Modification History--------------------------               */
 /*-------Date----Author-------Purpose---------------------------------------*/ 
 /* 11 Sept,2009  Pradeep      Made changes as per dataModel Venture3.0      */
 /* 03/04/2010 Vikas Monga													 */  
 /* -- Remove [Documents] and [DocumentVersions]							 */                        
 /****************************************************************************/
CREATE PROCEDURE  [dbo].[csp_SCGetDCH3803]                                    
  @DocumentVersionId int                                       
AS                                     
BEGIN                        
 BEGIN TRY                            
   -- For CustomDCH3803 table                     
	SELECT     DocumentVersionId, InitialOrReview, MoveInDate, FIACaseNumber, MedicaidRecipientId, CurrentDiagnosis, GuardianshipType, CountyOfResidence, FacilityName, 
					  FacilityPhone, FacilityAddress, FacilityCity, FacilityState, FacilityZip, FacilityMedicaidProviderId, CurrentGAF, EndDateReason, GuardianName, GuardianPhone, 
					  GuardianAddress, GuardianCity, GuardianState, GuardianZip, TreatmentType, DesignationMI, DesignationDD, DesignationAISMR, FacilityType, ChildLicenseType, 
					  AdultLicenseType, PersonalCareLevelEating, PersonalCareLevelToileting, PersonalCareLevelBathing, PersonalCareLevelGrooming, PersonalCareLevelDressing, 
					  PersonalCareLevelTransferring, PersonalCareLevelAmbulation, PersonalCareLevelTakingMedication, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, 
					  RecordDeleted, DeletedDate, DeletedBy
	FROM         CustomDCH3803
	WHERE     (ISNULL(RecordDeleted, ''N'') = ''N'') AND (DocumentVersionId = @DocumentVersionId)                                                   
 END TRY                        
 BEGIN CATCH                        
   DECLARE @Error varchar(8000)                                                           
   SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                          
   + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''[csp_SCGetDCH3803Test]'')                                                           
   + ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****ERROR_SEVERITY='' + Convert(varchar,ERROR_SEVERITY())                                                          
   + ''*****ERROR_STATE='' + Convert(varchar,ERROR_STATE())                                                          
   RAISERROR ( @Error, /* Message text.*/16, /* Severity.*/ 1 /*State.*/ );                                                  
                      
 END CATCH                                      
END
' 
END
GO
