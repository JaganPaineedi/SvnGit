/****** Object:  UserDefinedFunction [dbo].[fn_FetchAxisI_IIValue]    Script Date: 06/19/2013 18:03:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fn_FetchAxisI_IIValue]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[fn_FetchAxisI_IIValue]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fn_FetchAxisI_IIValue]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'

CREATE FUNCTION [dbo].[fn_FetchAxisI_IIValue]--302076
(
	
	@DocumentVersionId int
)
RETURNS varchar(max)
AS
BEGIN
DECLARE @AxisI_IIValue varchar(max)
set @AxisI_IIValue=''''
select top 3 
	 @AxisI_IIValue= @AxisI_IIValue + case when @AxisI_IIValue ='''' then '''' else '' ,'' end +
	 D1.DSMCode + ''_''+ ds.DSMDescription 
from DiagnosesIAndII as D1 left outer join DiagnosisDSMDescriptions as ds  
on ds.DSMCode= D1.DSMCode and  D1.DSMNumber=Ds.DSMNumber  where  D1.DocumentVersionId=@DocumentVersionId

return @AxisI_IIValue
end' 
END
GO
