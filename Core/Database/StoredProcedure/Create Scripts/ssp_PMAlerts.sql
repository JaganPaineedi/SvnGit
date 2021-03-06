/****** Object:  StoredProcedure [dbo].[ssp_PMAlerts]    Script Date: 11/18/2011 16:25:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_PMAlerts]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_PMAlerts]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_PMAlerts]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[ssp_PMAlerts] @ToStaffId INT
	,@ToDate DATETIME
	,@FromDate DATETIME
AS
/*********************************************************************/
/* Stored Procedure: ssp_Alerts                */
/* Copyright: 2006 Practice Management System     */
/* Creation Date: 19/10/2006                                 */
/*                                                                   */
/* Purpose: Used in the Alerts  screen        */
/*                                                                   */
/* Input Parameters:               */
/*                                                                   */
/* Output Parameters:                                */
/*                                                                   */
/* Return:Member   */
/*                                                                   */
/* Called By:                                                        */
/*                                                                   */
/* Calls:                                                            */
/*                                                                   */
/* Data Modifications:                                               */
/*                                                                   */
/* Updates:                                                          */
/*  Date          Author            Purpose                          */
/* 19/10/2006    Rajesh Kumar  Created                               */
/* 05/03/2008    Vindu Puri    modified, to get filtered data        */
/* 19/Jun/2008   Rohit  Verma  Added  alerts.DeletedBy Field        */
/* 16 Oct 2015  Revathi		what:Changed code to display Clients LastName and FirstName when ClientType=''I'' else  OrganizationName.         
							why:task #609, Network180 Customization */
/*********************************************************************/
BEGIN TRY
	--GolbalCodes                          
	SELECT dbo.GlobalCodes.GlobalCodeId
		,dbo.GlobalCodes.CodeName
		,dbo.GlobalCodes.category
		,CASE 
			WHEN GlobalCodes.SortOrder IS NULL
				THEN 9999
			ELSE GlobalCodes.SortOrder
			END AS SortOrder
	FROM dbo.GlobalCodes
	WHERE dbo.GlobalCodes.category = ''ALERTTYPE''
		AND isnull(GlobalCodes.recorddeleted, ''N'') = ''N''
	ORDER BY SortOrder
		,dbo.GlobalCodes.codename

	SELECT ''0'' AS ''CheckBox''
		,''N'' AS ''RadioButton''
		,a.Unread
		,a.RowIdentifier
		,a.alertid
		,a.CreatedBy
		,a.CreatedDate
		,b.clientid
		,c.staffid
		,d.CodeName AS ''Type''
		,a.Message
		,a.DateReceived AS ''Received''
		,a.Subject
		,a.FollowUp
		,a.Reference
		,a.ToStaffId
		,a.AlertId
		,a.ModifiedBy
		,a.ModifiedDate
		,a.RecordDeleted
		,a.DeletedDate
		,a.DeletedBy
		,CASE --Added by Revathi 16 Oct 2015
			WHEN ISNULL(b.ClientType, ''I'') = ''I''
				THEN ISNULL(b.LastName,'''') + '',  '' + ISNULL(b.FirstName,'''')
			ELSE b.OrganizationName
			END AS ''Clients''
		,rtrim(b.lastname) AS FromLastName
		,rtrim(b.firstname) AS FromFirstName
		,rtrim(c.lastname) AS StaffLastName
		,rtrim(c.firstname) AS StaffFirstName
		,a.AlertType
		,a.RecordDeleted
		,d.GlobalCodeId
		,d.category
		,dc.DocumentName
		,dc.DocumentCodeId
	FROM alerts a
	LEFT JOIN clients b ON a.clientid = b.clientid
		AND b.active = ''Y''
	INNER JOIN staff c ON a.tostaffid = c.staffid
	LEFT JOIN GlobalCodes d ON a.alerttype = d.GlobalCodeId
	LEFT JOIN documents do ON do.documentid = a.reference
	LEFT JOIN documentcodes dc ON do.documentcodeid = dc.documentcodeid
	/*left join documents do on do.documentid=substring(a.reference,0,charindex('','',a.reference)) left join documentcodes dc on do.documentcodeid=dc.documentcodeid  */
	WHERE a.ToStaffId = @ToStaffId
		AND isnull(a.recorddeleted, ''N'') <> ''Y''
		AND isnull(b.recorddeleted, ''N'') <> ''Y''
		AND cast(convert(VARCHAR, a.DateReceived, 101) AS DATETIME) >= cast(convert(VARCHAR, @ToDate, 101) AS DATETIME)
		AND cast(convert(VARCHAR, a.DateReceived, 101) AS DATETIME) <= @FromDate
END TRY

BEGIN CATCH
END CATCH
' 
END
GO
