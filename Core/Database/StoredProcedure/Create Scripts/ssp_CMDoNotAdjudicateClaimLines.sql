

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_CMDoNotAdjudicateClaimLines]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_CMDoNotAdjudicateClaimLines]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create PROCEDURE [dbo].[ssp_CMDoNotAdjudicateClaimLines]
    @ClaimLineId INT ,
    @UserId INT,
    @UserCode VARCHAR(30) ,
    @CurrentStatus INT         
/*********************************************************************                          
-- Stored Procedure: dbo.ssp_CMReAdjudicateClaimLines                
-- Copyright: 2005 Provider Claim Management System                
-- Creation Date:  18/June/20014                                      
--                                                                 
-- Purpose: it will ReAdjudicate the Claim Line                 
--                                                                                                  
-- Input Parameters:   
--                                 
-- Updates                                                                   
-- Modified Date    Modified By       Purpose    
-- 01/22/2018		jcarlson		Heartland SGL 12: Added call to ssp_CMManageOpenClaims to manage OpenClaims table        
****************************************************************************/
AS 
    DECLARE @Status INT
    
    BEGIN TRY     
      
        /***** Checking Change in the status of claim line if any change Rase Custom Error For Concurrency*/       
        SELECT  @Status = [Status] 
        FROM    ClaimLines
        WHERE   ClaimLineId = @ClaimLineId        
      
        IF @CurrentStatus <> @Status 
            BEGIN      
                RAISERROR ('Claim line has been modified by another user'    ,16,1)
            END 
            
/****** Updating Status Of Individual Claim Line */        
        UPDATE  ClaimLines
        SET     DoNotAdjudicate = 'Y',
                ModifiedBy = @UserCode ,
                ModifiedDate = GETDATE()
        WHERE   ClaimLineId = @ClaimLineId        
		
	EXEC dbo.ssp_CMManageOpenClaims @ClaimLineId = @ClaimLineId, @UserCode = @UserCode
             
    END TRY        
    BEGIN CATCH                                 
        DECLARE @Error VARCHAR(8000)                                  
        SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****'
            + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****'
            + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()),
                     '[ssp_CMDoNotAdjudicateClaimLines]') + '*****'
            + CONVERT(VARCHAR, ERROR_LINE()) + '*****'
            + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****'
            + CONVERT(VARCHAR, ERROR_STATE())                                               
        RAISERROR ( @Error, -- Message text.                                  
					16, -- Severity.                                  
					1 -- State.                                  
				  );                                  
                                  
    END CATCH             
GO