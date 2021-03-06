/****** Object:  StoredProcedure [dbo].[csp_SCGetCustomDateTracking]    Script Date: 06/19/2013 17:49:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetCustomDateTracking]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCGetCustomDateTracking]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetCustomDateTracking]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/****************************************************************************/                                                    
 /* Stored Procedure:csp_SCGetCustomDateTracking                             */                                           
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
 /* 03/04/2010 Vikas Monga             */  
 /* -- Remove [Documents] and [DocumentVersions]        */                        
 /****************************************************************************/  
CREATE PROCEDURE  [dbo].[csp_SCGetCustomDateTracking]                                    
  @DocumentVersionId INT                                       
AS                                        
BEGIN                        
   BEGIN TRY     
	   --For CustomAdvanceAdequateNotices Table                     
		SELECT     DocumentVersionId, DocumentationHealthHistoryDate, DocumentationAnnualCustomerInformation, DocumentationNext3803DueOn, 
						  DocumentationPrivacyNoticeGivenOn, DocumentationPcpLetter, DocumentationPcpRelease, DocumentationBasis32, MedicationConsentMedication1, 
						  MedicationConsentMedicationDate1, MedicationConsentMedication2, MedicationConsentMedicationDate2, MedicationConsentMedication3, 
						  MedicationConsentMedicationDate3, MedicationConsentMedication4, MedicationConsentMedicationDate4, MedicationConsentMedication5, 
						  MedicationConsentMedicationDate5, MedicationConsentMedication6, MedicationConsentMedicationDate6, MedicationConsentMedication7, 
						  MedicationConsentMedicationDate7, MedicationConsentMedication8, MedicationConsentMedicationDate8, CustomerSatisfactionSurvey, CreatedBy, CreatedDate, 
						  ModifiedBy, ModifiedDate, RecordDeleted, DeletedDate, DeletedBy
		FROM         CustomDateTracking
		WHERE     (ISNULL(RecordDeleted, ''N'') = ''N'') AND (DocumentVersionId = @DocumentVersionId)                                                     
	END TRY                        
	BEGIN CATCH                        
		DECLARE @Error varchar(8000)                                                           
		SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                          
		+ ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''[csp_SCGetCustomDateTracking]'')                                                           
		+ ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****ERROR_SEVERITY='' + Convert(varchar,ERROR_SEVERITY())                                                          
		+ ''*****ERROR_STATE='' + Convert(varchar,ERROR_STATE())                                                          
		RAISERROR ( @Error, /* Message text.*/16, /* Severity.*/ 1 /*State.*/ );                                                  
	END CATCH                                      
End
' 
END
GO
