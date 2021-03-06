/****** Object:  UserDefinedFunction [dbo].[fn_ReplaceParametersDocumentLetters]    Script Date: 06/19/2013 18:03:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fn_ReplaceParametersDocumentLetters]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[fn_ReplaceParametersDocumentLetters]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fn_ReplaceParametersDocumentLetters]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'  
CREATE FUNCTION [dbo].[fn_ReplaceParametersDocumentLetters]  
(  
@TemplateText varchar(max),  
@Parameter varchar(100),  
@ParameterValue varchar(100)  
)  
RETURNS varchar(max)  
AS  
BEGIN  
declare @Index int  
set @Index= CHARINDEX(@Parameter,@TemplateText)  
if(@Index>0)  
set @TemplateText=SUBSTRING(@TemplateText,0,@Index)+@ParameterValue+SUBSTRING(@TemplateText,@Index+LEN(@Parameter),LEN(@TemplateText))  
return @TemplateText  
END  ' 
END
GO
