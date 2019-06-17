
/****** Object:  StoredProcedure [dbo].[ssp_InitMedicationHistoryRequestConsent]    Script Date: 11/05/2015 14:02:15 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_InitMedicationHistoryRequestConsent]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_InitMedicationHistoryRequestConsent]
GO



/****** Object:  StoredProcedure [dbo].[ssp_InitMedicationHistoryRequestConsent]    Script Date: 11/05/2015 14:02:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_InitMedicationHistoryRequestConsent]
    (
      @StaffId INT ,
      @ClientID INT ,
      @CustomParameters XML                                  
    )
AS 
    BEGIN                                                                    
 /*********************************************************************/                            
 /* Stored Procedure: ssp_InitMedicationHistoryRequestConsent		  */                   
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
                         
        SELECT  'MedicationHistoryRequestConsents' AS TableName ,
                -1 AS DocumentVersionId ,
                @ClientID AS ClientId ,
                '' AS CreatedBy ,
                GETDATE() AS CreatedDate ,
                '' AS ModifiedBy ,
                GETDATE() AS ModifiedDate
        FROM    systemconfigurations s
                LEFT OUTER JOIN dbo.MedicationHistoryRequestConsents ON s.Databaseversion = -1            

    END      
    IF ( @@error != 0 ) 
        BEGIN                               
                              
            RAISERROR 20006 '[ssp_InitMedicationHistoryRequestConsent] : An Error Occured'                               
                              
            RETURN                               
                              
        END     



GO


