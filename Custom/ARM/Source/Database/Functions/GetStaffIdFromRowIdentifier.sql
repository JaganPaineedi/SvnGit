/****** Object:  UserDefinedFunction [dbo].[GetStaffIdFromRowIdentifier]    Script Date: 06/19/2013 18:03:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetStaffIdFromRowIdentifier]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[GetStaffIdFromRowIdentifier]
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetStaffIdFromRowIdentifier]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'


CREATE FUNCTION [dbo].[GetStaffIdFromRowIdentifier] (@RowIdentifier as type_GUID)  
RETURNS int AS  
BEGIN 

Declare @StaffID as int
Select @StaffID= StaffId from Staff where RowIdentifier = @RowIdentifier
return @StaffID 
END


' 
END
GO
