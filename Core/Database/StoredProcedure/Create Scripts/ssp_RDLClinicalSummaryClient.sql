/****** Object:  StoredProcedure [dbo].[ssp_RDLClinicalSummaryClient]    Script Date: 06/09/2015 04:09:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLClinicalSummaryClient]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[ssp_RDLClinicalSummaryClient] 
	@ServiceId INT = NULL
	,@ClientId INT
	,@DocumentVersionId INT = NULL
/******************************************************************************
**  File: ssp_RDLClinicalSummaryClient.sql
**  Name: ssp_RDLClinicalSummaryClient
**  Desc: Provides general client information for the Clinical Summary
**
**  Return values:
**
**  Called by:
**
**  Parameters:
**  Input   Output
**  ServiceId      -----------
**
**  Created By: Veena S Mani
**  Date:  Feb 20 2014
*******************************************************************************
**  Change History
*******************************************************************************
**  Date:		Author:			Description:
**  --------	--------		-------------------------------------------

	26/4/14		Veena S Mani		Added ShowClinicalSummaryCareTeam Section
	02/05/2014	Veena S Mani        Added parameters ClientId and EffectiveDate-Meaningful Use #18  
	19/05/2014	Veena S Mani        Added parameters DocumentId and removed EffectiveDate to make SP reusable for MeaningfulUse #7,#18 and #24.Also added the logic for the same.            
	03/09/2014	Revathi				what:check RecordDeleted , avoid Ambiguous column and call ssf_GetGlobalCodeNameById instead of csf_GetGlobalCodeNameById
									why:task#36 MeaningfulUse    
*******************************************************************************/

AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		DECLARE @ClientRace VARCHAR(510)

		SELECT @ClientRace = COALESCE(@ClientRace + '', '', '''') + gc.codename
		FROM dbo.clientraces AS cr
		INNER JOIN dbo.globalcodes AS gc ON gc.GlobalCodeId = cr.RaceId
		WHERE cr.ClientId = @ClientId AND ISNULL(cr.RecordDeleted,''N'')=''N''

		SELECT c.ClientId
			,c.lastname + '', '' + c.firstname AS ClientName
			,CONVERT(VARCHAR(10), c.dob, 101) AS DOB
			,CASE c.sex
				WHEN ''M''
					THEN ''Male''
				WHEN ''F''
					THEN ''Female''
				END AS Sex
			,dbo.ssf_GetGlobalCodeNameById(C.HispanicOrigin) AS Ethnicity
			,@ClientRace AS Race
			,gcPL.codename AS PrimaryLanguage
		FROM dbo.clients AS c
		LEFT JOIN dbo.globalcodes AS gcPL ON gcPL.globalcodeid = c.primarylanguage
		WHERE c.ClientId = @ClientId
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, Error_number()) + ''*****'' 
		+ CONVERT(VARCHAR(4000), Error_message()) + ''*****'' 
		+ Isnull(CONVERT(VARCHAR, Error_procedure()), ''ssp_RDLClinicalSummaryClient'') + ''*****'' 
		+ CONVERT(VARCHAR, Error_line()) + ''*****'' 
		+ CONVERT(VARCHAR, Error_severity()) + ''*****'' 
		+ CONVERT(VARCHAR, Error_state())

		RAISERROR (
				@Error
				,16
				,1
				);
	END CATCH
END' 
END
GO
