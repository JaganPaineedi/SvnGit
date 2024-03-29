/****** Object:  StoredProcedure [dbo].[csp_ReportGLCoveragePlanDropDownList]    Script Date: 06/19/2013 17:49:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportGLCoveragePlanDropDownList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportGLCoveragePlanDropDownList]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportGLCoveragePlanDropDownList]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
Create procedure [dbo].[csp_ReportGLCoveragePlanDropDownList] 
as

DECLARE @List TABLE
( CoveragePlanId INT, CoveragePlanName VARCHAR(250), Sort int )

INSERT INTO @List
        ( CoveragePlanId ,
          CoveragePlanName,
          Sort
        )
        
select cp.CoveragePlanId, 
cp.DisplayAs + CASE WHEN Active=''Y'' THEN '' (Active)'' ELSE '' (Inactive)'' END AS CoveragePlanName, 
ROW_NUMBER() over (order by CASE WHEN Active=''Y'' THEN 1 ELSE 2 END , DisplayAs) AS sort
FROM CoveragePlans cp
where ISNULL(RecordDeleted, ''N'') <> ''Y''
union
select null as CoveragePlanId, ''<None Selected>'' as CoveragePlanName, 0 AS Sort


SELECT CoveragePlanId, CoveragePlanName 
FROM @List
ORDER BY Sort, CoveragePlanName' 
END
GO
