IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetDFATableData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetDFATableData]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_GetDFATableData] (
	@AuthorizationRequestId int=null,
	@ProviderAuthorizationId int=null,
    @TableName varchar(max)
) 
/************************************************************************************************/
/* Author : Arjun K R                                                                           */
/* Date   : 23-Feb-2016                                                                         */
/* Purpose: Task #604.6 Network180 Customizations.                                              */
/************************************************************************************************/   
AS    
BEGIN    
	DECLARE @str NVARCHAR(4000)
	IF(@AuthorizationRequestId is not null)
		BEGIN
		  	set @str='SELECT * FROM '+ CAST(@TableName AS VARCHAR(max))+' WHERE AuthorizationRequestId='+CAST(@AuthorizationRequestId AS VARCHAR)	
		END
	ELSE IF(@ProviderAuthorizationId is not null)
		BEGIN
		   set @str='SELECT * FROM '+ CAST(@TableName AS VARCHAR(max))+' WHERE ProviderAuthorizationId='+CAST(@ProviderAuthorizationId AS VARCHAR)	
		END
			
	EXECUTE SP_EXECUTESQL @str 
	
END 
GO


