/****** Object:  StoredProcedure [dbo].[ssp_SCGetHistoryInfomation]    Script Date: 06/26/2012 11:48:09 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetHistoryInfomation]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_SCGetHistoryInfomation]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetHistoryInfomation]    Script Date: 06/26/2012 11:48:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SCGetHistoryInfomation]                 
	@AuthorizationId INT
	,@ClientId INT
AS
BEGIN
	/********************************************************************************************/
	/* Stored Procedure: ssp_SCGetHistoryInfomation            */
	/* Copyright: 2009 Streamline Healthcare Solutions           */
	/* Creation Date:  6 Jan 2011                 */
	/* Purpose: Gets History Information corressponding to AuthorizationdocumentId    */
	/* Input Parameters: @AuthorizationId,@ClientId                       */
	/* Output Parameters:                  */
	/* Return:                     */
	/* Called By: GetUMAuthorizationHistoryDetail() Method in AuthorizationDetail Class Of DataService */
	/* Calls:                     */
	/* Data Modifications:                  */
	/*       Date              Author                  Purpose         */
	/*   6 Jan 2011          Maninder                Created          */
	/*   14 Dec 2011          Maninder                Modified          */
	/*   20 june 2012          Rohitk                Modified     #1799 Authorization :history Not displayed(Harbor Go Live Issues)     */
	/*   24 june 2012          Maninder              Modified     #1799 Authorization :history Not displayed(Harbor Go Live Issues) Corrected columns to be displayed from AuthorizationHistory table     */
	/*   26 june 2012          Maninder              Modified     #1799 Authorization :history Not displayed(Harbor Go Live Issues) Added left outer join on staff table     */
	/*   8 Oct 2012            Maninder              Modified     Displayed Reviewer Correctly: Added Staff_Reviewer   */
	/*  20 Oct 2015				Revathi 			what:Changed code to display Clients LastName and FirstName when ClientType=''I'' else  OrganizationName.  
													why:task #609, Network180 Customization        */
	/********************************************************************************************/
	BEGIN TRY
		DECLARE @ClientName AS NVARCHAR(100)
		DECLARE @AgencyName AS NVARCHAR(200)

		SELECT TOP 1 @AgencyName = AgencyName
		FROM Agency

		--Modified by Revathi  20 Oct 2015
		SELECT @ClientName = CASE 
				WHEN ISNULL(dbo.Clients.ClientType, 'I') = 'I'
					THEN ISNULL(dbo.Clients.LastName, '') + ', ' + ISNULL(dbo.Clients.FirstName, '')
				ELSE ISNULL(dbo.Clients.OrganizationName, '')
				END
		FROM dbo.Clients
		WHERE dbo.Clients.ClientId = @ClientId

		SELECT CASE CONVERT(NUMERIC(18, 0), ISNULL(AuthHist.TotalUnitsRequested, '0'))
				WHEN 0
					THEN NULL
				ELSE CONVERT(NUMERIC(18, 0), ISNULL(AuthHist.TotalUnitsRequested, '0'))
				END AS Requested
			,CASE 
				WHEN Auth.STATUS = 4245
					THEN NULL
				ELSE ISNULL(AuthHist.TotalUnits, '0')
				END AS Approved
			,CONVERT(NUMERIC(18, 0), CASE 
					WHEN ISNULL(AuthHist.TotalUnitsRequested, 0) - ISNULL(AuthHist.TotalUnits, 0) > 0
						THEN ISNULL(AuthHist.TotalUnitsRequested, 0) - ISNULL(AuthHist.TotalUnits, 0)
					ELSE NULL
					END) AS Pended
			,GC.CodeName AS HistoryStatus
			,@ClientName AS ClientName
			,AuthHist.AuthorizationHistoryId
			,Auth.AuthorizationId
			,dbo.GetAuthorizationHistoryString(AuthHist.AuthorizationHistoryId) AS Reasons
			,AuthHist.CreatedDate
			,CASE 
				WHEN AuthHist.ReviewerId IS NULL
					THEN AuthHist.ReviewerOther
				ELSE isnull(Staff_Reviewer.LastName, '') + ', ' + isnull(Staff_Reviewer.FirstName, '')
				END AS UMReviewer
			,AuthHist.CreatedBy
			,AuthHist.StaffId
			,AuthHist.StaffIdRequested
			,Auth.AuthorizationDocumentId
			,Auth.AuthorizationCodeId
			,Auth.ProviderId
			,P.ProviderName
			,Sites.SiteName
			,convert(NVARCHAR, Auth.DateRequested, 101) AS DateRequested
			,convert(NVARCHAR, Auth.DateReceived, 101) AS DateReceived
			,Auth.StartDateUsed
			,Auth.EndDateUsed
			,Auth.UnitsScheduled
			,isnull(dbo.Staff.LastName + ', ', '') + isnull(dbo.Staff.FirstName, '') AS StaffName
			,--ISNULL(Staff_2.LastName,'')+', '+ISNULL(Staff_2.FirstName,'') as StaffName,
			AuthHist.Units AS Units
			,isnull(GC_Frequency.CodeName, '') AS Frequency
			,convert(NVARCHAR, AuthHist.StartDate, 101) AS StaratDate
			,convert(NVARCHAR, AuthHist.EndDate, 101) AS EndDate
			,AuthHist.TotalUnits AS Totalunit
			,AC.DisplayAs AS AuthCodeName
			,CASE 
				WHEN P.ProviderId IS NULL
					THEN @AgencyName
				ELSE P.ProviderName
				END AS ProviderName
			,CASE 
				WHEN Sites.SiteId IS NULL
					THEN @AgencyName
				ELSE Sites.SiteName
				END AS SiteName
		FROM AuthorizationHistory AS AuthHist
		INNER JOIN.Authorizations AS Auth ON AuthHist.AuthorizationId = Auth.AuthorizationId
		INNER JOIN GlobalCodes GC ON AuthHist.STATUS = GC.GlobalCodeId
		LEFT JOIN Staff ON AuthHist.StaffId = dbo.Staff.StaffId
		LEFT JOIN GlobalCodes GC_Frequency ON AuthHist.Frequency = GC_Frequency.GlobalCodeId
		LEFT JOIN AuthorizationCodes AC ON Auth.AuthorizationCodeId = AC.AuthorizationCodeId
		LEFT JOIN Staff AS Staff_2 ON Auth.StaffId = Staff_2.StaffId
		LEFT JOIN Sites ON Auth.SiteId = Sites.SiteId
		LEFT JOIN Providers P ON Auth.ProviderId = P.ProviderId
		LEFT JOIN Staff AS Staff_Reviewer ON AuthHist.ReviewerId = Staff_Reviewer.StaffId
		WHERE AuthHist.AuthorizationId = @AuthorizationId
			AND Isnull(Auth.RecordDeleted, 'N') = 'N'
		ORDER BY AuthHist.CreatedDate DESC
			,AuthHist.AuthorizationHistoryId DESC
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****'
		 + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' 
		 + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), '[ssp_SCGetHistoryInfomation]') 
		 + '*****' + Convert(VARCHAR, ERROR_LINE()) + 
		 '*****' + Convert(VARCHAR, ERROR_SEVERITY()) 
		 + '*****' + Convert(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,16
				,1
				);
	END CATCH
END
GO

