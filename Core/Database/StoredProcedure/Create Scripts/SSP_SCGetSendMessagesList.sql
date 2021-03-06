/****** Object:  StoredProcedure [dbo].[SSP_SCGetSendMessagesList]    Script Date: 11/18/2011 16:25:56 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SSP_SCGetSendMessagesList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SSP_SCGetSendMessagesList]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SSP_SCGetSendMessagesList]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SSP_SCGetSendMessagesList] @StaffId INT
AS
/*********************************************************************/
/* Stored Procedure: dbo.SSP_getSendMessagesList                */
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */
/* Creation Date:    7/24/05                                         */
/*                                                                   */
/* Purpose:  Get the list of The message for the specific clients*/
/*                                                                   */
/* Input Parameters: @varStaffId             */
/*                                                                   */
/* Output Parameters:   None                   */
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
/*   Date     Author       Purpose                                    */
/*  7/24/05   Vikas    Created                                    */
/* 15/Jan/2009 Rohit Verma Modified against ticket #2753          */
/* 20 Oct 2015    Revathi  what:Changed code to display Clients LastName and FirstName when ClientType=''I'' else  OrganizationName.  */
/*        why:task #609, Network180 Customization   */
/*********************************************************************/
BEGIN
	--Declare @varStaffId as int          
	--set @varStaffId=(Select StaffId from Staff where RowIdentifier=@StaffRowIdentifier)          
	SELECT a.*
		,CASE 
			WHEN a.Unread = ''Y''
				THEN ''Not Read''
			WHEN a.Unread = ''N''
				THEN ''Read''
			END AS codename
		,rtrim(c.LastName) + '', '' + rtrim(c.FirstName) AS FromName
		,/*rtrim(d.LastName) as ToLastName, rtrim(d.FirstName) as ToFirstName,*/
		rtrim(d.LastName) + '', '' + rtrim(d.FirstName) AS ToName
		,
		-- Modified by   Revathi   20 Oct 2015  
		CASE 
			WHEN ISNULL(e.ClientType, ''I'') = ''I''
				THEN rtrim(ISNULL(e.LastName, '''')) + '', '' + rtrim(ISNULL(e.FirstName, ''''))
			ELSE ISNULL(e.OrganizationName, '''')
			END AS ClientName
		,f.CodeName AS PriorityCodeName /*,doc.documenttype,doc.documentCodeId*/
	FROM Messages a
	-- join GlobalCodes b on a.Status = b.GlobalCodeId            
	--  join Documents dc on a.documentId=dc.documentid and IsNull(dc.RecordDeleted,''N'')= ''N''       
	--  join DocumentCodes doc on doc.documentCodeId=dc.documentCodeId and IsNull(doc.RecordDeleted,''N'')= ''N''       
	INNER JOIN Staff c ON a.FromStaffId = c.StaffId
	INNER JOIN Staff d ON a.ToStaffId = d.StaffId
	LEFT JOIN Clients e ON a.ClientId = e.ClientId
	LEFT JOIN GlobalCodes f ON a.Priority = f.GlobalCodeId
	WHERE a.fromstaffid = @StaffId
	ORDER BY DateReceived DESC

	IF (@@error != 0)
	BEGIN
		RAISERROR 20002 ''SSP_SCGetSendMessagesList: An Error Occured''

		RETURN (1)
	END

	RETURN (0)
END
' 
END
GO
