/****** Object:  UserDefinedFunction [dbo].[GetMinDOSInGroupServiceStaff]    Script Date: 06/19/2013 18:03:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetMinDOSInGroupServiceStaff]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[GetMinDOSInGroupServiceStaff]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetMinDOSInGroupServiceStaff]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'-- =============================================
-- Author:		<Author,Shifali>
-- Create date: <Create Date, 14Dec,2010>
-- Description:	<Description, To Get Minimum DateOfService for a Group Service>
-- This function will be invoked by Group Services list page under Scheduled tab
-- =============================================
Create FUNCTION [dbo].[GetMinDOSInGroupServiceStaff] 
(
	@GroupService int
)
RETURNS datetime 
AS
BEGIN
	
	DECLARE @MinDateOfService datetime
	Select @MinDateOfService = MIN(DateOfService) from GroupServiceStaff where GroupServiceId=@GroupService
	RETURN @MinDateOfService
END
' 
END
GO
