/****** Object:  UserDefinedFunction [dbo].[fn_Staff_Full_Name]    Script Date: 06/19/2013 18:03:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fn_Staff_Full_Name]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[fn_Staff_Full_Name]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fn_Staff_Full_Name]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'--/*
CREATE FUNCTION [dbo].[fn_Staff_Full_Name]()
RETURNS @Staff_Full_Name TABLE
(
	StaffID		char(7),
	StaffName	Varchar(50)
)
AS
--*/
-- =============================================
-- Author:		<Michael R.>
-- Create date: <10/08/2012>
-- Description:	<Description,,>
-- =============================================
/*
DECLARE @Staff_Full_Name TABLE
(
	StaffID		char(7),
	StaffName	Varchar(50)
)
--*/
BEGIN
	INSERT INTO @Staff_Full_Name (StaffID, StaffName)
	VALUES (''000'', ''All Staff'')


	BEGIN
		INSERT INTO @Staff_Full_Name(StaffID, StaffName)
		SELECT s.StaffId, s.LastName + '', '' + s.FirstName
		FROM dbo.Staff s
		WHERE s.Active = ''Y''
		AND s.Clinician = ''Y''
		AND ISNULL(s.RecordDeleted, ''N'') <> ''Y''
		ORDER BY s.LastName
	--SELECT * FROM @Staff_Full_Name 
	END
	RETURN 
END
' 
END
GO
