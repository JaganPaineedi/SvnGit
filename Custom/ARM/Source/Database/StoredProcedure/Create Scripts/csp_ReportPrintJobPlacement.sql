/****** Object:  StoredProcedure [dbo].[csp_ReportPrintJobPlacement]    Script Date: 06/19/2013 17:49:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportPrintJobPlacement]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportPrintJobPlacement]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportPrintJobPlacement]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'




CREATE PROCEDURE [dbo].[csp_ReportPrintJobPlacement](
	@ClientId int = NULL,
	@JobPlacementDate datetime = NULL)
AS
BEGIN

IF @ClientId IS NULL
	Return

IF @JobPlacementDate IS NULL
	SELECT @JobPlacementDate = MIN(JobPlacementDate)
	FROM CustomVocationalJobPlacements
	WHERE ClientId = @ClientId 

SELECT a.*,
	placed.LastName + Coalesce('', '' + placed.FirstName,'''') + Coalesce(LEFT(placed.MiddleName,1) + ''.'','''') as PlacedByName,
	referred.CodeName as referredByName,
	ISNULL(dbo.Clients.FirstName, '''') + '' '' + ISNULL(SUBSTRING(dbo.Clients.MiddleName, 1, 1) + ''.'', '''') + '' '' + ISNULL(dbo.Clients.LastName, '''') AS ClientName,
	AuthorizationNumber
FROM CustomVocationalJobPlacements a
LEFT JOIN Staff placed ON placed.StaffId = a.PlacedBy
LEFT JOIN dbo.GlobalCodes referred ON referred.GlobalCodeId = a.ReferredBy
LEFT JOIN dbo.Clients ON (dbo.Clients.ClientId = a.ClientId)
WHERE a.ClientId = @ClientId
AND JobPlacementDate = @JobPlacementDate

END

' 
END
GO
