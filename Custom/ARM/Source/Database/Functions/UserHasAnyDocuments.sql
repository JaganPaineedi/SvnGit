/****** Object:  UserDefinedFunction [dbo].[UserHasAnyDocuments]    Script Date: 06/19/2013 18:03:42 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UserHasAnyDocuments]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[UserHasAnyDocuments]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UserHasAnyDocuments]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'




























CREATE FUNCTION [dbo].[UserHasAnyDocuments](@ClientID int,@CurrentDate DateTime)  
returns char(3)  
as  
BEGIN  
DECLARE @YesNo char(3)  
IF EXISTS(select DocumentID from Documents where ClientID=@ClientID and (Status=21 or Status=22) and isnull(Duedate,''01-01-1900'')<@CurrentDate+7)  
 SET @YesNo=''Yes''  
else  
 SET @YesNo=''No''  
return @YesNo  
END  





























' 
END
GO
