/****** Object:  UserDefinedFunction [dbo].[GetFlaggedCharges]    Script Date: 06/19/2013 18:03:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetFlaggedCharges]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[GetFlaggedCharges]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetFlaggedCharges]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'






CREATE FUNCTION  [dbo].[GetFlaggedCharges]
( @ChargeId int)


RETURNS Varchar(5000)
AS  
BEGIN 

DECLARE @ChargeIds varchar(5000), @delimiter char
SET @delimiter = '',''
SELECT @ChargeIds = COALESCE(@ChargeIds + @delimiter, '''') + Convert(varchar(10),ChargeId) 
FROM FinancialActivityLines where ChargeId=@ChargeId and Flagged=''Y''
--SELECT @title_ids AS [List of Title IDs]

return (@ChargeIds)
END







' 
END
GO
