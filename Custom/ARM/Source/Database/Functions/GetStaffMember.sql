/****** Object:  UserDefinedFunction [dbo].[GetStaffMember]    Script Date: 06/19/2013 18:03:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetStaffMember]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[GetStaffMember]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetStaffMember]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'                  
CREATE FUNCTION [dbo].[GetStaffMember]    
(    
@StaffId int    
)  RETURNS varchar(15) AS      
BEGIN     
Declare @StaffName as varchar(100)    
set @StaffName=(SELECT LastName+'',''+firstname as UserCode FROM Staff WHERE (StaffId = @StaffId))     
return @StaffName    
    
END    ' 
END
GO
