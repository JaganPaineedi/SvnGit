/****** Object:  StoredProcedure [dbo].[ssp_PMGetSendMessageDetails]    Script Date: 11/18/2011 16:25:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_PMGetSendMessageDetails]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_PMGetSendMessageDetails]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_PMGetSendMessageDetails]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[ssp_PMGetSendMessageDetails] (@fromstaffid INT)
	/*********************************************************************/
	/* Stored Procedure: ssp_GetSendMessageDetails           */
	/* Copyright: 2006 Practice Management System   */
	/* Creation Date:    10/26/06                                        */
	/*                                                                   */
	/* Purpose:  It is used to display the records from the messages table to the send message  grid   */
	/*                                                                   */
	/* Input Parameters:@fromstaffid          */
	/*                                                                   */
	/* Output Parameters:   None                               */
	/*                                                                   */
	/* Return:  0=success, otherwise an error number                     */
	/*                                                                   */
	/* Called By:                                                        */
	/*                                                                   */
	/* Calls:                                                            */
	/*                                                                   */
	/* Data Modifications:                                               */
	/*                                                                   */
	/* Updates:                                                          */
	/*  Date     Author       Purpose                                    */
	/* 10/26/06   Rajesh	Created                                    */
	/* 20 Oct 2015 Revathi   what:Changed code to display Clients LastName and FirstName when ClientType=''I'' else  OrganizationName.      
							 why:task #609, Network180 Customization */
	/*********************************************************************/
AS
SELECT ''0'' AS Checkbox
	,''N'' AS RadioButton
	,dbo.Messages.MessageId
	,dbo.Messages.FromStaffId
	,dbo.Messages.FromSystemDatabaseId
	,dbo.Messages.FromSystemStaffId
	,dbo.Messages.FromSystemStaffName
	,dbo.Messages.ToStaffId
	,dbo.Messages.ToSystemDatabaseId
	,dbo.Messages.ToSystemStaffId
	,dbo.Messages.ToSystemStaffName
	,dbo.Messages.ClientId
	,dbo.Messages.Unread
	,u1.LastName + '',  '' + u1.FirstName AS FromName
	,u2.LastName + '', '' + u2.FirstName AS ToName
	,dbo.Messages.DateReceived
	,CASE --Added by Revathi 20 Oct 2015
		WHEN ISNULL(dbo.Clients.ClientType, ''I'') = ''I''
			THEN ISNULL(dbo.Clients.LastName,'''') + '', '' + ISNULL(dbo.Clients.FirstName,'''')
		ELSE ISNULL(dbo.Clients.OrganizationName,'''')
		END AS client
	,dbo.Messages.Subject
	,dbo.GlobalCodes.CodeName
	,dbo.Messages.OtherRecipients
	,dbo.Messages.Priority
	,CASE priority
		WHEN 60
			THEN ''Normal''
		WHEN 61
			THEN ''Caution/Alert''
		ELSE ''Urgent''
		END priorityText
	,dbo.Messages.Message
	,dbo.Messages.DeletedBySender
	,dbo.Messages.Reference
	,dbo.Messages.ReferenceSystemDatabaseId
	,dbo.Messages.ReferenceType
	,dbo.Messages.ReferenceId
	,dbo.Messages.ReferenceLink
	,dbo.Messages.DocumentId --, dbo.Messages.Version commented by Sahil in ref of Task #11          
	,dbo.Messages.TabId
	,dbo.Messages.CreatedBy
	,dbo.Messages.CreatedDate
	,dbo.Messages.ModifiedBy
	,dbo.Messages.ModifiedDate
	,dbo.Messages.RecordDeleted
	,dbo.Messages.DeletedDate
	,dbo.Messages.DeletedBy
	,Messages.SenderCopy
	,Messages.ReceiverCopy
FROM dbo.Messages
LEFT JOIN dbo.staff u1 ON u1.staffid = dbo.Messages.FromStaffId
LEFT JOIN dbo.staff u2 ON u2.staffid = dbo.Messages.ToStaffId
LEFT JOIN dbo.GlobalCodes ON dbo.GlobalCodes.GlobalCodeId = dbo.Messages.Priority
LEFT JOIN dbo.Clients ON dbo.Clients.ClientId = dbo.Messages.ClientId
WHERE (
		isnull(messages.deletedbysender, ''N'') = ''N''
		AND dbo.Messages.FromStaffId = @fromstaffid
		)
	AND isnull(Messages.RecordDeleted, ''N'') = ''N''
	AND isnull(u1.RecordDeleted, ''N'') = ''N''
	AND isnull(GlobalCodes.RecordDeleted, ''N'') = ''N''
	AND isnull(u2.RecordDeleted, ''N'') = ''N''
	AND isnull(Clients.RecordDeleted, ''N'') = ''N''

IF (@@error != 0)
BEGIN
	RAISERROR 20002 ''ssp_PMGetSendMessageDetails: An Error Occured''

	RETURN
END
' 
END
GO
