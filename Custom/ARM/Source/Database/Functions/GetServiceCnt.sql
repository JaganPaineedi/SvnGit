/****** Object:  UserDefinedFunction [dbo].[GetServiceCnt]    Script Date: 06/19/2013 18:03:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetServiceCnt]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[GetServiceCnt]
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetServiceCnt]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'







CREATE FUNCTION [dbo].[GetServiceCnt](

	@CLIENTID  INT
	
)

RETURNS INT
 AS  

BEGIN 
DECLARE @SERVICECNT INT

--DECLARE @CURDATE DATETIME

--DECLARE @myDateTime DATETIME

 --SELECT @myDateTime = Date FROM CurrentDate



select @SERVICECNT=   Count(ServiceId) from Services ,Clients
where Status in (71,75)and Clients.InformationComplete = ''N''
and Clients.ClientId = @CLIENTID
and  Clients.ClientId = services.ClientId


RETURN @SERVICECNT


END











' 
END
GO
