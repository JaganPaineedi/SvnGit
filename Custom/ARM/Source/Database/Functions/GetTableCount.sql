/****** Object:  UserDefinedFunction [dbo].[GetTableCount]    Script Date: 06/19/2013 18:03:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetTableCount]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[GetTableCount]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetTableCount]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'







Create FUNCTION [dbo].[GetTableCount] (

@sTableName sysname -- Table to retrieve Row Count
)

RETURNS INT -- Row count of the table, NULL if not found.

/*
* Returns the row count for a table by examining sysindexes.
* This function must be run in the same database as the table.
*
* Common Usage: 
SELECT dbo.GetTableCount ('''')

* Test 
PRINT ''Test 1 Bad table '' + CASE WHEN SELECT 
dbo.GetTableCount(''foobar'') is NULL
THEN ''Worked'' ELSE ''Error'' END
***************************************************************/

AS BEGIN

DECLARE @nRowCount INT -- the rows
DECLARE @nObjectID int -- Object ID

SET @nObjectID = OBJECT_ID(@sTableName)

-- Object might not be found
IF @nObjectID is null RETURN NULL

SELECT TOP 1 @nRowCount = rows 
FROM sysindexes 
WHERE id = @nObjectID AND indid < 2

RETURN @nRowCount
END 








' 
END
GO
