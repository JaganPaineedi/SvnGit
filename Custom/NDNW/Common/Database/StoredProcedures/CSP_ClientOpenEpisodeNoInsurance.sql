/****** Object:  StoredProcedure [dbo].[CSP_ClientOpenEpisodeNoInsurance]    Script Date: 12/18/2015 17:33:20 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CSP_ClientOpenEpisodeNoInsurance]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[CSP_ClientOpenEpisodeNoInsurance]
GO

/****** Object:  StoredProcedure [dbo].[CSP_ClientOpenEpisodeNoInsurance]    Script Date: 12/18/2015 17:33:20 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[CSP_ClientOpenEpisodeNoInsurance]
	/* ********************************************************************/
	/* Stored Procedure: CSP_ClientOpenEpisodeNoInsurance       */
	/* Creation Date: 12/18/2015                                */
	/*                                                          */
	/* Purpose: Display Active Clients with No Coverage Plans   */
	/*                                                          */
	/* Input Parameters:  NA         */
	/*                                                          */
	/* Output Parameters:          */
	/*  12/18/2015      Prateek S. NDNW Support Go Live Task # 166  */
	/******************************************************************** */
AS
BEGIN
	BEGIN TRY
		CREATE TABLE #ClientWithNoInsurance (
			ClientId INT
			,CName VARCHAR(50)
			,ProgramId INT
			,ProgramName VARCHAR(250)
			,HasClientFee CHAR(1)
			)

		INSERT INTO #ClientWithNoInsurance
		SELECT ce.ClientId
			,c.LastName + ', ' + c.FirstName AS CName
			,prg.ProgramId
			,(
				SELECT ProgramName
				FROM programs
				WHERE ProgramId = prg.ProgramId
				) AS ProgramName
			,'N' AS HasClientFee
		FROM ClientEpisodes ce
		JOIN Clients c ON c.clientId = ce.CLientId
		INNER JOIN (
			SELECT DISTINCT cp.ClientId
				,cp.programid
			FROM ClientPrograms cp
			JOIN Programs p ON p.ProgramId = cp.ProgramId
			WHERE isnull(cp.RecordDeleted, 'N') = 'N'
				AND cp.STATUS IN (4)
			) AS prg ON prg.clientId = ce.clientId
		WHERE ce.DischargeDate IS NULL
			AND ISNULL(ce.RecordDeleted, 'N') <> 'Y'
			AND ce.STATUS <> 102
			AND ce.ClientId NOT IN (
				SELECT ccp.clientId
				FROM ClientCoveragePlans ccp
				JOIN COveragePlans cp ON cp.CoveragePlanID = ccp.CoveragePlanId
				JOIN (
					SELECT cch.ClientCoveragePlanId
						,MIN(cch.StartDate) AS dateBegin
						,MAX(cch.CreatedDate) AS crDate
					FROM ClientCoverageHistory cch
					WHERE ISNULL(cch.RecordDeleted, 'N') = 'N'
					GROUP BY cch.ClientCoveragePlanId
					) AS cchStart ON cchStart.ClientCoveragePlanId = ccp.CLientCoveragePlanId
				JOIN (
					SELECT cch.ClientCoveragePlanId
						,CASE 
							WHEN Max(ISNULL(cch.EndDate, '12/31/2399')) = '12/31/2399'
								THEN NULL
							ELSE Max(cch.EndDate)
							END AS EndDate
						,MAX(cch.createddate) AS CreatedDate
					FROM ClientCoverageHistory cch
					WHERE EndDate IS NULL
					GROUP BY cch.ClientCOveragePlanId
					) AS cchEnd ON cchEnd.ClientCoveragePlanId = cchStart.ClientCoveragePlanId
					AND cchEnd.CreatedDate = cchStart.crDate
				)
		ORDER BY prg.ProgramId
			,c.LastName
			,c.FirstName

		UPDATE tmp
		SET HasClientFee = 'Y'
		FROM #ClientWithNoInsurance AS tmp
		JOIN CustomClientFees cf ON cf.ClientId = tmp.ClientId
			AND cf.StartDate <= GETDATE()
			AND (
				cf.EndDate >= GETDATE()
				OR cf.EndDate IS NULL
				)

		SELECT ClientId
			,CName
			,ProgramId
			,ProgramName
			,HasClientFee
		FROM #ClientWithNoInsurance

		DROP TABLE #ClientWithNoInsurance
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'CSP_ClientOpenEpisodeNoInsurance') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,
				-- Message text.                                                                                              
				16
				,
				-- Severity.                                                                                              
				1
				-- State.                                                                                              
				);
	END CATCH
END

GO


