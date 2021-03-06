/****** Object:  UserDefinedFunction [dbo].[fn_Active_Client_Table]    Script Date: 06/19/2013 18:03:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fn_Active_Client_Table]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[fn_Active_Client_Table]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fn_Active_Client_Table]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'--/*
CREATE FUNCTION [dbo].[fn_Active_Client_Table]()
RETURNS @ClientTable TABLE 
(	
	-- Add the parameters for the function here
	ClientId	Int,
	ClientName	Varchar(50)
)
AS
--*/
-- =============================================
-- Author:		<Michael S Rowley>
-- Create date: <01/15/2013>
-- Description:	<Return a table of all active ClientId and Client Lastname, Firstname>
-- =============================================
/*
DECLARE @ClientTable TABLE
(
	ClientId	Int,
	ClientName	Varchar(50)
)
--*/
BEGIN
	INSERT INTO @ClientTable (ClientId, ClientName)
	VALUES (''0'', ''All Clients'')

	BEGIN
		INSERT INTO @ClientTable(ClientId, ClientName)
		SELECT c.ClientId , c.LastName + '', '' + c.FirstName 
		FROM dbo.clients c
		WHERE c.Active = ''Y''
		AND ISNULL(c.RecordDeleted, ''N'') <> ''Y''
		ORDER BY c.ClientId 
		--SELECT * FROM @ClientTable
	END
	RETURN 

END
' 
END
GO
