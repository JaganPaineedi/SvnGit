/****** Object:  StoredProcedure [dbo].[csp_Report_Active_Location]    Script Date: 06/19/2013 17:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_Active_Location]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_Report_Active_Location]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_Active_Location]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'--/*
CREATE PROCEDURE [dbo].[csp_Report_Active_Location]
AS
--*/
-- =============================================
-- Author:		<Michael R.>
-- Create date: <10/08/2012>
-- Description:	<Creates table of Staff Full Name ordered by Last Name to use in reports.>
-- =============================================

DECLARE @Active_Locations TABLE
(
	LocationID		Char(7),
	LocationName	Varchar(50)
)

BEGIN
	INSERT INTO @Active_Locations (LocationID, LocationName)
	VALUES (''00'', ''All Locations'')

	INSERT INTO @Active_Locations (LocationID, LocationName)
	SELECT l.LocationId, l.LocationName
	FROM dbo.Locations l
	WHERE l.Active = ''Y''
	ORDER BY l.LocationName
END

SELECT * FROM @Active_Locations
' 
END
GO
