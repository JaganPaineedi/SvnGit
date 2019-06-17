
/****** Object:  StoredProcedure [dbo].[ssp_GetMedicationHistoryRequestConsent]    Script Date: 11/05/2015 12:37:23 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetMedicationHistoryRequestConsent]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetMedicationHistoryRequestConsent]
GO

/****** Object:  StoredProcedure [dbo].[ssp_GetMedicationHistoryRequestConsent]    Script Date: 11/05/2015 12:37:23 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_GetMedicationHistoryRequestConsent]
    (
      @DocumentVersionId AS INT                                  
    )
AS 
    BEGIN                                                                    
 /*********************************************************************/                            
 /* Stored Procedure: csp_InitCustomMedsOnlyTxPlan					  */                   
 /* Copyright: 2006 Streamline SmartCare							  */                            
 /* Creation Date:  07/02/2012										  */                            
 /*                                                                   */                            
 /* Purpose:														  */                           
 /*                                                                   */                          
 /* Input Parameters:												  */                          
 /*                                                                   */                             
 /* Output Parameters:												  */                            
 /*                                                                   */                            
 /* Return:															  */                            
 /*                                                                   */                            
 /* Called By:														  */                  
 /*                                                                   */                            
 /* Calls:                                                            */                            
 /*                                                                   */                            
 /* Data Modifications:                                               */                            
 /*                                                                   */                            
 /*   Updates:                                                        */                                               
 /*       Date              Author                  Purpose           */                            
 /*       07/02/2012        Wasif Butt              To Retrieve Data  */                            
 /*********************************************************************/                             
                         
        SELECT  DocumentVersionId
              , CreatedBy
              , CreatedDate
              , ModifiedBy
              , ModifiedDate
              , RecordDeleted
              , DeletedDate
              , DeletedBy
              , ClientId
              , StartDate
              , EndDate
        FROM    MedicationHistoryRequestConsents 
        WHERE   DocumentVersionId = @DocumentVersionId
    END      
    IF ( @@error != 0 ) 
        BEGIN                               
                              
            RAISERROR 20006 '[ssp_GetMedicationHistoryRequestConsent] : An Error Occured'                               
                              
            RETURN                               
                              
        END     



GO


