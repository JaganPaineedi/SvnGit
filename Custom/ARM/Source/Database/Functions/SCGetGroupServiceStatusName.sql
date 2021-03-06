/****** Object:  UserDefinedFunction [dbo].[SCGetGroupServiceStatusName]    Script Date: 06/19/2013 18:03:42 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SCGetGroupServiceStatusName]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[SCGetGroupServiceStatusName]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SCGetGroupServiceStatusName]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'  
CREATE function [dbo].[SCGetGroupServiceStatusName] (@GroupServiceId int) returns varchar(250)
/********************************************************************************                                      
-- Stored Procedure: SCGetGroupServiceStatusName                                        
--                                      
-- Copyright: Streamline Healthcate Solutions                                      
--                                      
-- Purpose: ge
--                                      
-- Updates:                                                                                             
-- Date        Author      Purpose                                      
-- 04.24.2011  SFarber     Created.                                            
*********************************************************************************/                                      
begin      

declare @Status int
declare @StatusName varchar(250)
     
select @StatusName = gc.CodeName
  from GlobalCodes gc
 where gc.GlobalCodeId = dbo.SCGetGroupServiceStatus(@GroupServiceId)
  
return @StatusName

end

 
' 
END
GO
