/****** Object:  UserDefinedFunction [dbo].[fnConvertXMLToTable]    Script Date: 06/19/2013 18:03:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fnConvertXMLToTable]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[fnConvertXMLToTable]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fnConvertXMLToTable]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
CREATE FUNCTION [dbo].[fnConvertXMLToTable](
@x XML
)
RETURNS TABLE
AS RETURN
/*----------------------------------------------------------------------
This INLINE TVF uses a recursive CTE that processes each element and
attribute of the XML document passed in.
----------------------------------------------------------------------*/
WITH cte AS 
	(
		SELECT
			1 AS lvl
			, x.value(''local-name(.)'',''VARCHAR(MAX)'') AS Name
			, CAST(NULL AS VARCHAR(MAX)) AS ParentName
			, CAST(1 AS INT) AS ParentPosition
			, CAST(''Element'' AS VARCHAR(20)) AS NodeType
			, x.value(''local-name(.)'',''VARCHAR(MAX)'') AS FullPath
			, x.value(''local-name(.)'',''VARCHAR(MAX)'')
				+ ''[''
				+ CAST(ROW_NUMBER() OVER(ORDER BY (SELECT 1)) AS VARCHAR)
				+ '']'' AS XPath
			, ROW_NUMBER() OVER(ORDER BY (SELECT 1)) AS Position
			, x.value(''local-name(.)'',''VARCHAR(MAX)'') AS Tree
			, x.value(''text()[1]'',''VARCHAR(MAX)'') AS Value
			, x.query(''.'') AS this
			, x.query(''*'') AS t
			, CAST(CAST(1 AS VARBINARY(4)) AS VARBINARY(MAX)) AS Sort
			, CAST(1 AS INT) AS ID
		FROM @x.nodes(''/*'') a(x)
		UNION ALL
	--
	-- Start recursion. Retrieve each child element of the parent node
	--
		SELECT
			p.lvl + 1 AS lvl
			, c.value(''local-name(.)'',''VARCHAR(MAX)'') AS Name
			, CAST(p.Name AS VARCHAR(MAX)) AS ParentName
			, CAST(p.position AS INT) AS ParentPosition
			, CAST(''Element'' AS VARCHAR(20)) AS NodeType
			, CAST(p.FullPath + ''/'' + c.value(''local-name(.)'',''VARCHAR(MAX)'') AS VARCHAR(MAX)) AS FullPath
			, CAST( p.XPath + ''/'' + c.value(''local-name(.)'',''VARCHAR(MAX)'')
				+ ''['' + CAST(ROW_NUMBER() OVER(PARTITION BY c.value(''local-name(.)'',''VARCHAR(MAX)'') ORDER BY (SELECT 1)) AS VARCHAR )
				+ '']'' AS VARCHAR(MAX)
				) AS XPath
			, ROW_NUMBER() OVER(PARTITION BY c.value(''local-name(.)'',''VARCHAR(MAX)'') ORDER BY (SELECT 1)) AS Position
			, CAST( SPACE(2 * p.lvl - 1) + ''|'' + REPLICATE(''-'', 1)
				+ c.value(''local-name(.)'',''VARCHAR(MAX)'') AS VARCHAR(MAX)
				) AS Tree
			, CAST( c.value(''text()[1]'',''VARCHAR(MAX)'') AS VARCHAR(MAX) ) AS Value
			, c.query(''.'') AS this
			, c.query(''*'') AS t
			, CAST(p.Sort + CAST( (lvl + 1) * 1024 + (ROW_NUMBER() OVER(ORDER BY (SELECT 1)) * 2) AS VARBINARY(4)
				) AS VARBINARY(MAX) ) AS Sort
			, CAST( (lvl + 1) * 1024 + (ROW_NUMBER() OVER(ORDER BY (SELECT 1)) * 2) AS INT ) 
		FROM cte p
		CROSS APPLY p.t.nodes(''*'') b(c)
	)

, cte2 AS 
	(
		SELECT 
			lvl AS Depth
			, Name AS NodeName
			, ParentName
			, ParentPosition
			, NodeType
			, FullPath
			, XPath
			, Position
			, Tree AS TreeView
			, Value
			, this AS XMLData
			, Sort
			, ID
		FROM cte 
		UNION ALL
	--
	-- Attributes do not need recursive calls. So add the attributes to the query output at the end.
	--
		SELECT 
			p.lvl
			, x.value(''local-name(.)'',''VARCHAR(MAX)'')
			, p.Name
			, p.Position
			, CAST(''Attribute'' AS VARCHAR(20))
			, p.FullPath + ''/@'' + x.value(''local-name(.)'',''VARCHAR(MAX)'')
			, p.XPath + ''/@'' + x.value(''local-name(.)'',''VARCHAR(MAX)'')
			, 1
			, SPACE(2 * p.lvl - 1) + ''|'' + REPLICATE(''-'', 1) + ''@'' + x.value(''local-name(.)'',''VARCHAR(MAX)'')
			, x.value(''.'',''VARCHAR(MAX)'')
			, NULL
			, p.Sort
			, p.ID + 1
		FROM cte p
		CROSS APPLY this.nodes(''/*/@*'') a(x) 
	)


--
-- Final Select
--
SELECT 
	ROW_NUMBER() OVER(ORDER BY Sort, ID) AS ID
	, ParentName
	, ParentPosition
	, Depth
	, NodeName
	, Position
	, NodeType
	, FullPath
	, XPath
	, TreeView
	, Value
	, XmlData 
FROM cte2' 
END
GO
