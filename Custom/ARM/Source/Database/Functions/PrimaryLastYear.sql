/****** Object:  UserDefinedFunction [dbo].[PrimaryLastYear]    Script Date: 06/19/2013 18:03:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PrimaryLastYear]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[PrimaryLastYear]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PrimaryLastYear]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
























CREATE function [dbo].[PrimaryLastYear](@varClinicianId int,@varYear int,@varMonth int)
returns int
As
Begin
	Declare @varCount int
	set @varCount=(select PrimaryCaseload as "Primary Last Year" from StaffReports where  ReportYear=@varYear and staffid=@varClinicianId and ReportMonth=@varMonth and IsNull(RecordDeleted,''N'')<>''Y'')
	return(@varCount) 
End
































' 
END
GO
