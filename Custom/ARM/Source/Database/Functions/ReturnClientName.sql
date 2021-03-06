/****** Object:  UserDefinedFunction [dbo].[ReturnClientName]    Script Date: 06/19/2013 18:03:42 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ReturnClientName]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[ReturnClientName]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ReturnClientName]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [dbo].[ReturnClientName]  
(  
@serviceId bigint  
)  
RETURNS varchar(100)  
AS  
BEGIN  
 Declare @ClientId bigint  
 Declare @ClientName varchar(100)  
 select @ClientId=clientid from services where serviceid=@serviceId  
   --Corrected ClientName to LastName+'', ''+FirstName - DJH - 10/2/2010
 Select @ClientName=LastName+'', ''+Firstname from clients where clientid=@ClientId  
return cast(@ClientId as varchar(20))+'',''''''+@ClientName+''''''''  
END  
' 
END
GO
