IF EXISTS (SELECT *  FROM   SYS.objects  WHERE  object_id = OBJECT_ID(N'[dbo].[scsp_ListPageSCAuthorizationDefaults]') AND type IN ( N'P', N'PC' )) 
  DROP PROCEDURE [dbo].[scsp_ListPageSCAuthorizationDefaults] 

GO 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[scsp_ListPageSCAuthorizationDefaults]
(

	 @StartDate DATETIME
	,@EndDate DATETIME
	,@Active CHAR(1)
	,@InternalExternal CHAR(1)
	,@OtherFilter INT
	,@BillingCodeId INT
	,@AuthorizationCodeId INT
	,@ProviderId INT
	,@SiteId INT
)
AS
/********************************************************************************    
-- Stored Procedure: dbo.scsp_ListPageSCAuthorizationDefaults      
--  
-- Copyright: Streamline Healthcate Solutions 
--    
-- Created:           
-- Date			Author				Purpose 
  17-Aug-2015   SuryaBalan				What:Used in Authorizations Default List Page
									Why:task Network 180 - Customizations #602 - Authorization process - ability to set defaults based on auth code  
*********************************************************************************/ 
BEGIN
  BEGIN TRY 
	SELECT - 1 AS ProviderAuthorizationDefaultId 
END TRY
  BEGIN CATCH
    DECLARE @error varchar(8000)

    SET @error = CONVERT(varchar, ERROR_NUMBER()) + '*****'
    + CONVERT(varchar(4000), ERROR_MESSAGE())
    + '*****'
    + ISNULL(CONVERT(varchar, ERROR_PROCEDURE()),
    'scsp_ListPageSCAuthorizationDefaults')
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