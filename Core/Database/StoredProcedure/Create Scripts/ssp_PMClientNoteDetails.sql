IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_PMClientNoteDetails]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_PMClientNoteDetails]
GO

--sp_helptext ssp_PMClientNoteDetails 1222
--sp_helptext ssp_PMClientNoteDetails  
CREATE PROCEDURE [dbo].[ssp_PMClientNoteDetails] @ClientId INT
	/*********************************************************************/
	/* Stored Procedure: dbo.ssp_PMClientNoteDetails                         */
	/* Creation Date:    12/18/06                                         */
	/*                                                                   */
	/* Purpose:           */
	/*                                                                   */
	/* Input Parameters:           */
	/*                                                                   */
	/* Output Parameters:                                                */
	/*                                                                   */
	/* Return Status:                                                    */
	/*                                                                   */
	/* Called By:       */
	/*                                                                   */
	/* Calls:                                                            */
	/*                                                                   */
	/* Data Modifications:                                               */
	/*                                                                   */
	/* Updates:                                                          */
	/*   Date			Author      Purpose                                    */
	/*  12/18/06		Vikrant   Created                                    */
	/*  16 Jan 2015		Avi Goyal	What : Changed NoteType Join to FlagTypes    */
	/*								Why : Task # 600 Securiry Alerts ; Project : Network-180 Customizations   */
	/* 19 Oct 2015		Revathi 	what:Changed code to display Clients LastName and FirstName when ClientType=''I'' else  OrganizationName.  
									why:task #609, Network180 Customization  */
	/*********************************************************************/
AS
SELECT '' AS DeleteButton
	,'N' AS RadioButton
	,
	--A.bitmap as Bitmap			-- Commented by Avi Goyal, on 16 Jan 2015 
	FT.Bitmap -- Added by Avi Goyal, on 16 Jan 2015  
	,CASE 
		WHEN ISNULL(Clients.ClientType, 'I') = 'I'--Added by Revathi 19 Oct 2015
			THEN ISNULL(Clients.LastName, '') + ', ' + ISNULL(Clients.FirstName, '')
		ELSE ISNULL(Clients.OrganizationName, '')
		END AS ClientName
	,ClientNotes.*
	,
	--A.CodeName as NoteTypeCodeName,		-- Commented by Avi Goyal, on 16 Jan 2015 
	FT.FlagType AS NoteTypeCodeName
	,-- Added by Avi Goyal, on 16 Jan 2015  
	B.CodeName AS NoteLevelCodeName
FROM ClientNotes
INNER JOIN Clients ON clients.Clientid = clientNotes.clientId
	AND (
		Clients.RecordDeleted IS NULL
		OR Clients.RecordDeleted = 'N'
		)
--left join GlobalCodes A on A.GlobalCodeId=ClientNotes.NoteType   -- Commented by Avi Goyal, on 16 Jan 2015
LEFT JOIN FlagTypes FT ON ClientNotes.NoteType = FT.FlagTypeId -- Added by Avi Goyal, on 16 Jan 2015    
LEFT JOIN GlobalCodes B ON B.GlobalCodeId = ClientNotes.NoteLevel
WHERE ClientNotes.ClientId = @ClientId
	AND (
		ClientNotes.RecordDeleted IS NULL
		OR ClientNotes.RecordDeleted = 'N'
		)

IF (@@Error <> 0)
BEGIN
	RAISERROR 50000 'Error while ssp_PMClientNoteDetails'

	RETURN - 1
END
GO

