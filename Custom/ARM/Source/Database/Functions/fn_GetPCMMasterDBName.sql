/****** Object:  UserDefinedFunction [dbo].[fn_GetPCMMasterDBName]    Script Date: 06/19/2013 18:03:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fn_GetPCMMasterDBName]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[fn_GetPCMMasterDBName]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fn_GetPCMMasterDBName]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'-- =============================================
-- Author:		Pralyankar Kumar Singh
-- Create date: 12 Jan 2012
-- Description:	Return DB name of PCM Master Database.
-- =============================================
CREATE function [dbo].[fn_GetPCMMasterDBName]
(

)
RETURNS  Varchar(50)

BEGIN
		/*  >>--------> Get PCM Master DB Name <--------<< */
		DECLARE @ConnectionString VARCHAR(1000), @DBName VARCHAR(50)

		SELECT @ConnectionString = ConnectionString
		FROM systemdatabases 
		WHERE MasterDatabase = ''Y''

		SET @ConnectionString = substring(@ConnectionString, CHARINDEX('';'', @ConnectionString) +1 ,2000)
		SET @ConnectionString = left(@ConnectionString, CHARINDEX('';'', @ConnectionString)-1 )
		SET @DBName = substring(@ConnectionString, CHARINDEX(''='', @ConnectionString)+1, 50 )
		-- >>>>>>>------------------------------------------------------->

	-- Return the result of the function
	RETURN @DBName

END
' 
END
GO
