/****** Object:  UserDefinedFunction [dbo].[fn_GetGlobalCode]    Script Date: 06/19/2013 18:03:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fn_GetGlobalCode]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[fn_GetGlobalCode]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fn_GetGlobalCode]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
create function [dbo].[fn_GetGlobalCode]
(
	@Category char(20),
	@code varchar(100)
)
/******************************************************************************                                          
**  File:                                           
**  Name: fn_GetGlobalCode                                          
**  Desc: This function will return globalcode from pcm 
**
**  Parameters: 
**  Input  	@Category char(20),
			@code varchar(100)
**  Output    globalcode
**  
**  Auth:  Sudhir Singh
**  Date:  Feb 3, 2012
******************************************************************************* 
**  Change History  
******************************************************************************* 
**  Date:  Author:    Description: 
**  --------  --------    ------------------------------------------- 
**  
*******************************************************************************/
returns VARCHAR(50)
begin
	declare @Globalcodeid int
	select @Globalcodeid = GlobalCodeId from GlobalCodes where Category = @Category and Code = @code
	return cast(ISNULL(@Globalcodeid,0) as varchar)
end
' 
END
GO
