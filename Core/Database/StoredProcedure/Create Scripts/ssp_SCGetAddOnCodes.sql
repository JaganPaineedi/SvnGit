/****** Object:  StoredProcedure [dbo].[ssp_SCGetAddOnCodes]    Script Date: 03/02/2016 09:23:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[ssp_SCGetAddOnCodes] @ProcedureCodeId INT
AS /*********************************************************************/                                                                                                
 /* Stored Procedure: ssp_SCGetAddOnCodes      */                                                                                       
 /* Creation Date:  25/April/2012                                     */                                                                                                
 /* Purpose: To Get Add-On Codes           */          
 /* Input Parameters: @ClientId            */                                                                                              
 /* Output Parameters:              */                                                                                                
 /* Return:                 */                                                                                                
 /* Called By:Document Screen              */                                                                                      
 /* Calls:                                                            */                                                                                                
 /*                                                                   */                                                                                                
 /* Data Modifications:                                               */                                                                                                
 /* Updates:                                                          */                                                                                                
 /* Date              Author                  Purpose      */                    
 /* 26/08/2013     Md Hussain Khusro    created */     
 /* 10/02/2016  Pavani                         Woods - Environment Issues Tracking, Task #112
                                               Added   DisplayAs column */   
/*  03/02/2016	NJain							Added Order by DisplayAs */                                                 
 /*********************************************************************/             
            
    BEGIN                                      
        BEGIN TRY           
 --10/02/2016  Pavani
            SELECT  ProcedureCodeId ,
                    ProcedureCodeName ,
                    DisplayAs
            FROM    ProcedureCodes PC   
--End
            WHERE   ProcedureCodeId IN ( SELECT AddOnProcedureCodeId
                                         FROM   ProcedureAddOnCodes
                                         WHERE  ProcedureCodeId = @ProcedureCodeId
                                                AND ISNULL(RecordDeleted, 'N') = 'N' )
                    AND ISNULL(RecordDeleted, 'N') = 'N'
                    AND ISNULL(Active, 'N') = 'Y'
            ORDER BY DisplayAs                
       
            
        END TRY                                                                                  
        BEGIN CATCH                                      
            DECLARE @Error VARCHAR(8000)                                                                                   
            SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCGetAddOnCodes') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())                                  
            RAISERROR                                                                                                                 
 (                                                                                   
  @Error, -- Message text.                                                                                                                
  16, -- Severity.                                                                                                                
  1 -- State.                                                                                                                
 );                        
        END CATCH              
    END 
GO
