/****** Object:  UserDefinedFunction [dbo].[GetPreviousAuthorizationStatus]    Script Date: 06/19/2013 18:03:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetPreviousAuthorizationStatus]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[GetPreviousAuthorizationStatus]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetPreviousAuthorizationStatus]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'  Create FUNCTION [dbo].[GetPreviousAuthorizationStatus](  
 @AuthorizationId int   
)  
  
RETURNS int  
 AS    
BEGIN   
  
DECLARE @Status  int  
  
--select top 1 @Status = [Status] from AuthorizationHistory where   
--AuthorizationId = @AuthorizationId  
--and IsNull(AuthorizationHistory.RecordDeleted,''N'')=''N''    
--order by AuthorizationHistoryId desc  
  
--if(@Status = 6045)  
--begin  
select top 1 @Status = [Status] from AuthorizationHistory   
where [Status] Not in (6045)   
and AuthorizationId = @AuthorizationId  
and IsNull(AuthorizationHistory.RecordDeleted,''N'')=''N''    
order by AuthorizationHistoryId desc  
  
--end  
return @Status  
END  
  
  
  
  
  ' 
END
GO
