
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[scsp_ListPageCombinedCMAuthorizations]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[scsp_ListPageCombinedCMAuthorizations]
GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[scsp_ListPageCombinedCMAuthorizations]
(
@StaffId				INT, 
@Status					INT,
@FromDate				DATETIME,
@ToDate					DATETIME,
@AuthorizationNumber	VARCHAR(35),   
@ReviewTypes			INT,  
@InsurerId				INT, 
@CoveragePlanId			INT,
@BillingCodeId			INT, 
@ProviderId				INT,
@SiteId					INT, 
@AuthorizationCode		INT,
@ClientId				INT, 
@DueStartDate			DATETIME,   
@DueEndDate				DATETIME,
@ClinicianId			INT,
@UrgentRequests			INT  
)
AS
/********************************************************************************    
-- Stored Procedure: dbo.scsp_ListPageCombinedSCAuthorizations      
--  
-- Copyright: Streamline Healthcate Solutions 
--    
-- Created:                                                           
-- Date			 Author				Purpose    
       
22-July-2015	Revathi				what:Called in ssp_ListPageCombinedCMAuthorizations
									why:task #662 Network 180 - Customizations

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
    '[scsp_ListPageCombinedCMAuthorizations]')
    + '*****' + CONVERT(varchar, ERROR_LINE())
    + '*****' + CONVERT(varchar, ERROR_SEVERITY())
    + '*****' + CONVERT(varchar, ERROR_STATE())

    RAISERROR (@error,-- Message text.
    16,-- Severity.
    1 -- State.
    );
  END CATCH
END		
