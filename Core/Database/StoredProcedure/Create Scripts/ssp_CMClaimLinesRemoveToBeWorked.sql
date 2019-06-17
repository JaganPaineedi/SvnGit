IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_CMClaimLinesRemoveToBeWorked]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_CMClaimLinesRemoveToBeWorked]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create PROCEDURE [dbo].[ssp_CMClaimLinesRemoveToBeWorked]
    @ClaimLineId VARCHAR(MAX),
    @UserId INT,
    @UserCode VARCHAR(30)        
/*********************************************************************                          
-- Stored Procedure: dbo.ssp_CMClaimLinesRemoveToBeWorked                               
-- Creation Date:  07/June/2017                                                                                                  
-- Purpose: it will update the "Needs To Be Worked" for selected Claim Lines in Claim Lines list page.                 
--                                                                                                  
-- Input Parameters:   
-- @ClaimLineId
--                                 
-- Updates                                                                   
-- Modified Date    Modified By       Purpose  
-- 07/06/2017		Suneel N		For Task #1067 SWMBH - Support      
-- 01/22/2018		jcarlson		Heartland SGL 12: Added call to ssp_CMManageOpenClaims to manage OpenClaims table     
****************************************************************************/
AS 
    
    BEGIN TRY     
        DECLARE @locClaimLineId INT;
/****** Updating Needs To Be worked Of Individual Claim Line */        
        UPDATE  C
        SET     NeedsToBeWorked = 'N',
                ModifiedBy = @UserCode,
                ModifiedDate = GETDATE()
        FROM ClaimLines C
        JOIN [dbo].fnSplit(@ClaimLineId, ',') T ON T.Item = C.ClaimLineId 
        WHERE C.NeedsToBeWorked = 'Y'
        AND ISNULL(C.RecordDeleted,'N')='N'

        DECLARE cur_OpenClaims CURSOR
        FOR
            SELECT  CONVERT(INT,item)
            FROM    dbo.fnSplit(@ClaimLineId, ',');

        OPEN cur_OpenClaims;
        FETCH NEXT FROM cur_OpenClaims INTO @locClaimLineId;
        WHILE @@FETCH_STATUS = 0
            BEGIN
        
                EXEC dbo.ssp_CMManageOpenClaims @ClaimLineId = @locClaimLineId, @UserCode = @UserCode;
	    
                FETCH NEXT FROM cur_OpenClaims INTO @locClaimLineId;  
            END; 

        CLOSE cur_OpenClaims;
        DEALLOCATE cur_OpenClaims;

    END TRY        
                
    
    BEGIN CATCH                                 
        DECLARE @Error VARCHAR(8000)                                  
        SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****'
            + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****'
            + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()),
                     '[ssp_CMClaimLinesRemoveToBeWorked]') + '*****'
            + CONVERT(VARCHAR, ERROR_LINE()) + '*****'
            + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****'
            + CONVERT(VARCHAR, ERROR_STATE())                                                                                   
                              
			RAISERROR                                   
			 (                                  
			  @Error, -- Message text.                                  
			  16, -- Severity.                                  
			  1 -- State.                                  
			 ) ;                                  
                                  
    END CATCH      
    
     
              
GO


