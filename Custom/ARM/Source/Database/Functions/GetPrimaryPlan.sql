/****** Object:  UserDefinedFunction [dbo].[GetPrimaryPlan]    Script Date: 06/19/2013 18:03:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetPrimaryPlan]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[GetPrimaryPlan]
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetPrimaryPlan]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'







CREATE FUNCTION [dbo].[GetPrimaryPlan](

	@CLIENTID  INT,
	@myDateTime datetime
)

RETURNS VARCHAR(200)
 AS  

BEGIN 
DECLARE @PRIMARYPLAN VARCHAR (200)

DECLARE @CURDATE DATETIME

--DECLARE @myDateTime DATETIME

 --SELECT @myDateTime = Date FROM CurrentDate



select @PRIMARYPLAN=  CoveragePlans.CoveragePlanName
			 from CoveragePlans,ClientCoverageHistory,ClientCoveragePlans
			 where ClientId = @CLIENTID
			 and ClientCoveragePlans.ClientCoveragePlanId = ClientCoverageHistory.ClienTcoveragePlanId
			 and ClientCoveragePlans.CoveragePlanId = CoveragePlans.CoveragePlanId
			 and COBorder = 1 
			 and  @myDateTime >=  startDate and (Enddate >= @myDateTime or Enddate is NULL )
RETURN @PRIMARYPLAN


END












' 
END
GO
