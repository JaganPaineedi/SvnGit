/****** Object:  UserDefinedFunction [dbo].[TotalLastYear]    Script Date: 06/19/2013 18:03:42 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TotalLastYear]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[TotalLastYear]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TotalLastYear]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'































CREATE function [dbo].[TotalLastYear](@varClinicianId int,@varYear int,@varMonth int)
returns int
As
Begin
	Declare @varCount int
	set @varCount=(select TotalCaseload as "Total Last Year" from StaffReports where  ReportYear=@varYear and staffid=@varClinicianId and ReportMonth=@varMonth and IsNull(RecordDeleted,''N'')<>''Y'')
	return(@varCount) 
End



































' 
END
GO
