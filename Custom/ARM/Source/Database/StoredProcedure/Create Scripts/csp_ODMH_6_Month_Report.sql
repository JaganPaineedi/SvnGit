/****** Object:  StoredProcedure [dbo].[csp_ODMH_6_Month_Report]    Script Date: 06/19/2013 17:49:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ODMH_6_Month_Report]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ODMH_6_Month_Report]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ODMH_6_Month_Report]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[csp_ODMH_6_Month_Report]
@year int,
@half int
AS
--*/
-- =============================================
-- Author:		<Ryan Mapes>
-- Create date: <01/24/2013>
-- Description:	<ODMH 6 Month Report Status for Crisis Intervention and Part_Hosp.>
-- =============================================


DECLARE @month INT,

@BeginDate date,
@EndDate date

--@year INT,
--,@Half int
--select @Half=2
--,@year = 2012

If @half=1

BEGIN

SELECT @month = 1,

@BeginDate = CAST(@month AS VARCHAR) + ''-1-'' + CAST(@year AS VARCHAR),@EndDate = DATEADD(MONTH, 6, @BeginDate)
END

if @half =2
BEGIN
SELECT @month = 7,
@BeginDate = CAST(@month AS VARCHAR) + ''-1-'' + CAST(@year AS VARCHAR),
@EndDate = DATEADD(MONTH, 6, @BeginDate)
END

DECLARE @TempTable_B1 TABLE 
(
Mon varchar(10), 

People int,

Minutes float

)
INSERT INTO @TempTable_B1 (Mon, People, Minutes)

select MONTH(dateofservice),count(DISTINCT ClientId),SUM (datediff (MINUTE, DateofService, EndDateOfService))

From Services s
join ProcedureCodes p
on s.ProcedureCodeId = p.ProcedureCodeId
WHERE DateofService < @EndDate AND DateOfService >= @BeginDate
and s.Status = 75 --Completed
and s.ProcedureCodeId = 457 --Part_Hosp
AND ISNULL(s.RecordDeleted,''N'')<>''Y''
AND ISNULL(p.RecordDeleted,''N'')<>''Y''

GROUP BY Month(DateofService)

ORDER BY Month(DateofService)

------
DECLARE @TempTable_C1 TABLE 
(
Mon2 varchar(10), 

People2 int,

Minutes2 float
)

INSERT INTO @TempTable_C1 (Mon2, People2, Minutes2)
select MONTH(dateofservice),count(DISTINCT ClientId),SUM (datediff (MINUTE, DateofService, EndDateOfService))

From Services s
join ProcedureCodes p
on s.ProcedureCodeId = p.ProcedureCodeId
WHERE DateofService < @EndDate AND DateOfService >= @BeginDate
and s.Status = 75 --Completed
and s.ProcedureCodeId = 71 --Crisis Intervention
AND ISNULL(s.RecordDeleted,''N'')<>''Y''
AND ISNULL(p.RecordDeleted,''N'')<>''Y''

GROUP BY Month(DateofService)

ORDER BY Month(DateofService)

Select mon, People, Minutes/60 as ''Hours'',mon2,People2,Minutes2/60 as ''Hours2''
from @TempTable_B1 b

join @TempTable_C1 c

On b.Mon =c.Mon2' 
END
GO
