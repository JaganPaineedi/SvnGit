/****** Object:  UserDefinedFunction [dbo].[GetErrortype]    Script Date: 06/19/2013 18:03:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetErrortype]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[GetErrortype]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetErrortype]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'






CREATE FUNCTION  [dbo].[GetErrortype]
( @ServiceId int)

RETURNS Varchar(5000)
AS  
BEGIN 

DECLARE @ErrorType varchar(5000), @delimiter char
SET @delimiter = '',''
SELECT @ErrorType = COALESCE(@ErrorType + @delimiter, '''') + Convert(varchar(10),ErrorType) 
FROM ServiceErrors where ServiceId=@ServiceId
--SELECT @title_ids AS [List of Title IDs]

return (@ErrorType)
END







' 
END
GO
