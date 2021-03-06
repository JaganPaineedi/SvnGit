/****** Object:  StoredProcedure [dbo].[csp_InitCustomDocumentJobDeveloperCoachNote]    Script Date: 06/19/2013 17:49:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomDocumentJobDeveloperCoachNote]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_InitCustomDocumentJobDeveloperCoachNote]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomDocumentJobDeveloperCoachNote]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE	PROCEDURE  [dbo].[csp_InitCustomDocumentJobDeveloperCoachNote]
(
 @ClientID int,
 @StaffID int,
 @CustomParameters xml
)
AS

--Following option is reqd for xml operations                              
SET ARITHABORT ON                                 
                              
DECLARE @ServiceId INT
SET @ServiceId = @CustomParameters.value(''(/Root/Parameters/@ServiceId)[1]'', ''int'' )                               

SELECT	TOP 1 ''CustomDocumentJobDeveloperCoachNote'' AS TableName,
		-1 AS ''DocumentVersionId'',
		'''' as CreatedBy,
		getdate() as CreatedDate,
		'''' as ModifiedBy,
		getdate() as ModifiedDate
/*
		A.AuthorizationId as ''AuthorizationNumber'',
		A.TotalUnits / 15 as ''HoursAuthorized'',
		A.UnitsUsed / 15 as ''HoursBilled''
FROM	Authorizations A
JOIN	ServiceAuthorizations SA
ON		A.AuthorizationId = SA.AuthorizationId
WHERE	SA.ServiceId = @ServiceId
--*/
' 
END
GO
