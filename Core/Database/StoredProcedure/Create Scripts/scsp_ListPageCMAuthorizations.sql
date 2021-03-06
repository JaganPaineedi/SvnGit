IF EXISTS (SELECT *  FROM   SYS.objects  WHERE  object_id = OBJECT_ID(N'[dbo].[scsp_ListPageCMAuthorizations]') AND type IN ( N'P', N'PC' )) 
  DROP PROCEDURE [dbo].[scsp_ListPageCMAuthorizations] 

GO 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[scsp_ListPageCMAuthorizations]
(
@StaffId				INT, 
@AuthorizationStatus	INT, 
@StartDate				DATETIME, 
@EndDate				DATETIME, 
@AuthorizationNumber	VARCHAR(35), 
@ReviewTypes			INT, 
@InsurerId				INT, 
@PopulationId			INT, 
@BillingCodeModifierId			INT, 
@ProvidersId			INT, 
@SiteId					INT, 
@OtherFilter			INT, 
@ClientId				INT, 
@DueStartDate			DATETIME, 
@DueEndDate				DATETIME, 
@UrgentRequests			INT
)
AS
/********************************************************************************    
-- Stored Procedure: dbo.scsp_ListPageCMAuthorizations      
--  
-- Copyright: Streamline Healthcate Solutions 
--    
-- Created:           
-- Date			Author				Purpose 
  15-Jul-2014   Revathi				What:Used in CM	Authorizations List Page
									Why:task #15 CM to SC
  31-JAN-2018   Neelima				What:Passing parameter as @BillingCodeModifierId instead of BillingCodeId
									Why:task #15 CM to SC
*********************************************************************************/ 
BEGIN
  BEGIN TRY 
	SELECT - 1 AS ProviderAuthorizationId 
END TRY
  BEGIN CATCH
    DECLARE @error varchar(8000)

    SET @error = CONVERT(varchar, ERROR_NUMBER()) + '*****'
    + CONVERT(varchar(4000), ERROR_MESSAGE())
    + '*****'
    + ISNULL(CONVERT(varchar, ERROR_PROCEDURE()),
    'scsp_ListPageCMAuthorizations')
    + '*****' + CONVERT(varchar, ERROR_LINE())
    + '*****' + CONVERT(varchar, ERROR_SEVERITY())
    + '*****' + CONVERT(varchar, ERROR_STATE())

    RAISERROR (@error,-- Message text.
    16,-- Severity.
    1 -- State.
    );
  END CATCH
END		
GO 