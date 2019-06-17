  /****** Object:  StoredProcedure [dbo].[csp_RDLReleaseOfInformation]    Script Date: 21-07-2015 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_InitDocumentReleaseOfInformations]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_InitDocumentReleaseOfInformations]
GO

/****** Object:  StoredProcedure [dbo].[ssp_InitDocumentReleaseOfInformations]    Script Date: 21-07-2015 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO  
    
 CREATE Procedure [dbo].[ssp_InitDocumentReleaseOfInformations]            
 @ClientID INT,                                              
 @StaffID INT,                                            
 @CustomParameters XML                
AS                
 /*********************************************************************/                                                                                                      
 /* Stored Procedure: ssp_InitDocumentReleaseOfInformations    */                                                                                             
 /* Creation Date:  16/Nov/2017                                     */                                                                                                      
 /* Purpose: To Initialized The Release Of Information      */                
 /* Input Parameters: @DocumentVersionId         */                                                                                                    
 /* Output Parameters:              */                                                                                                      
 /* Return:                 */                                                                                                      
 /* Called By:Initialization of Screen          */                                                                                            
 /* Calls:                                                            */                                                                                                      
 /*                                                                   */                                                                                                      
 /* Data Modifications:                                               */                                                                                                      
 /* Updates:                                                          */                                                                                                                     
 /*********************************************************************/                   
                  
Begin                                            
Begin TRY           

	DECLARE @usercode VARCHAR(100);

		SELECT @usercode = usercode
		FROM Staff
		WHERE StaffId = @StaffID
      
                     
SELECT 'DocumentReleaseOfInformations' AS TableName
			,- 1 AS 'DocumentVersionId'
			,@usercode as [CreatedBy]    
			,GETDATE() as [CreatedDate]    
			,@usercode as [ModifiedBy]    
			,GETDATE() as [ModifiedDate] 
			,GETDATE() as ExpirationStartDate
			,(SELECT TOP 1 GlobalCodeId FROM GlobalCodes where category = 'ROITYPE' and Code = 'General' and Active='Y' and IsNull(DROI.RecordDeleted, 'N') = 'N' ) as ROIType
			FROM systemconfigurations SC
		LEFT JOIN DocumentReleaseOfInformations DROI ON SC.DatabaseVersion = - 1                    
                
END TRY                                                                                        
BEGIN CATCH                                            
DECLARE @Error varchar(8000)                                                                                         
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                   
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_InitDocumentReleaseOfInformations')                                                                                                                       
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