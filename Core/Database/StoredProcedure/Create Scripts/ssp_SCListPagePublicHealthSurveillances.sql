/****** Object:  StoredProcedure [dbo].[ssp_SCListPagePublicHealthSurveillances]    Script Date: 07/05/2016 14:35:29 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCListPagePublicHealthSurveillances]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_SCListPagePublicHealthSurveillances]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCListPagePublicHealthSurveillances]    Script Date: 07/05/2016 14:35:29 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SCListPagePublicHealthSurveillances] @SessionId VARCHAR(30)
	,@InstanceId INT
	,@PageNumber INT
	,@PageSize INT
	,@SortExpression VARCHAR(100)
	,@ICDCode VARCHAR(100)
	,@StartDate DATETIME
	,@EndDate DATETIME
	,@StaffId INT
	,@LoggedInUserId INT
AS
-- =============================================          
-- Stored Procedure: dbo.ListPageSCPublicHealthSurveillances                                                
-- Copyright: Streamline Healthcate Solutions                                              
-- Purpose: used by Public Health Surveillance list page                                              
-- Updates:                                                                                                     
-- Date        Author            Purpose                                              
-- 05.16.2011  Ashwani    Created.     
-- 07.24.2012  Rohit katoch   changes table name  "ListPagePublicHealthSurveillance" to ListPageSCPublicHealthSurveillances                                                    
-- 09.10.2012  Vikas Kashyap  Made Changes With (SessionId, InstanceId, RowNumber) Set Unique Key ,w.r.t. Task#430 TH3.5xMerge Bugs    
-- 07.JAN.2014 Revathi    what:Added join with staffclients table to display associated clients for login staff    
--       why:Engineering Improvement Initiatives- NBL(I) task #77 My office List Pages should always have StaffID as an input parameter     
-- 20 OCT 2014 Gautam            Added code related to ClientOrders and ClientOrdersDiagnosisIIICodes , Ref. task #19,    
--         Syndrome Surveillance Data, Meaningful Use    
--31-DEC-2015 Basudev Sahu   Modified For Task #609 Network180 Customization to  Get Organisation  As ClientName    
-- 5 July 2016 Varun - modifications done for Meaningful Use Stage 3
-- 17 May 2017 Varun - modifications done for Meaningful Use Stage 3 - #22.3
-- =============================================           
BEGIN
	BEGIN TRY
		CREATE TABLE #SyndromicSurveillanceData (
			ClientId INT
			,ClientName VARCHAR(150)
			,ICD10Code VARCHAR(50)
			,DocumentId INT
			,DiagnosisDate DATETIME
			,DiagnosisEvent VARCHAR(250)
			,LastDownload DATETIME
			);
		
		WITH Syndromic_CTE
		AS (
			SELECT DISTINCT C.ClientId
				,CASE 
					WHEN ISNULL(C.ClientType, 'I') = 'I'
						THEN ISNULL(C.LastName, '') + ', ' + ISNULL(C.FirstName, '')
					ELSE ISNULL(C.OrganizationName, '')
					END AS ClientName
				,DDC.ICD10Code AS ICD10Code
				,D.DocumentId AS DocumentId
				,D.EffectiveDate AS DiagnosisDate
				,GC.CodeName AS DiagnosisEvent
			FROM DocumentSyndromicSurveillances DSS
			LEFT JOIN DocumentDiagnosisCodes DDC ON DDC.DocumentVersionId = DSS.DocumentVersionId
				AND Isnull(DDC.RecordDeleted, 'N') = 'N'
			INNER JOIN Documents D ON D.CurrentDocumentVersionId = DSS.DocumentVersionId
				AND D.[Status] = 22
				AND Isnull(D.RecordDeleted, 'N') = 'N'
			INNER JOIN Clients C ON C.ClientId = D.ClientId
				AND C.Active = 'Y'
			INNER JOIN StaffClients sc ON sc.ClientId = c.ClientId
				AND sc.StaffId = @StaffId
			INNER JOIN GlobalCodes GC ON GC.GlobalCodeId = DSS.GeneralType
				AND Isnull(GC.RecordDeleted, 'N') = 'N'

			WHERE Cast(D.EffectiveDate AS DATE) >= Cast(@StartDate AS DATE)
				AND Cast(D.EffectiveDate AS DATE) <= Cast(@EndDate AS DATE)
			)

		INSERT INTO #SyndromicSurveillanceData (
			DocumentId
			,ClientId
			,ClientName
			,DiagnosisDate
			,DiagnosisEvent
			)
		SELECT DISTINCT a.DocumentId
			,ClientId
			,ClientName
			,DiagnosisDate
			,DiagnosisEvent
		FROM Syndromic_CTE a
		--WHERE (
		--		EXISTS (
		--			SELECT 1
		--			FROM Syndromic_CTE b
		--			WHERE ISNULL(b.ICD10Code, '') = @ICDCode
		--				AND b.ClientId = a.ClientId
		--			)
		--		OR (
		--			a.ICD10Code IS NULL
		--			AND NOT EXISTS (
		--				SELECT 1
		--				FROM Syndromic_CTE c
		--				WHERE c.ICD10Code IS NOT NULL
		--					AND c.ClientId = a.ClientId
		--				)
		--			)
		--		)
		ORDER BY ClientName ASC
			,DiagnosisDate ASC;
	
		update #SyndromicSurveillanceData set LastDownload= (select top 1 LastDownload from SurveillanceDownloadHistory SDH where #SyndromicSurveillanceData.DocumentId=SDH.DocumentId order by LastDownload desc);
		WITH Counts
		AS (
			SELECT Count(*) AS TotalRows
			FROM #SyndromicSurveillanceData
			)
			,rankresultset
		AS (
			SELECT ClientId
				,ClientName
				,DiagnosisDate
				,DiagnosisEvent
				,ICD10Code
				,DocumentId
				,LastDownload
				,Count(*) OVER () AS TotalCount
				,Rank() OVER (
					ORDER BY CASE 
							WHEN @SortExpression = 'ClientId'
								THEN ClientId
							END
						,CASE 
							WHEN @SortExpression = 'ClientId DESC'
								THEN ClientId
							END DESC
						,CASE 
							WHEN @SortExpression = 'ClientName'
								THEN ClientName
							END
						,CASE 
							WHEN @SortExpression = 'ClientName DESC'
								THEN ClientName
							END DESC
						--  ,CASE           
						-- WHEN @SortExpression = 'DiagnosisDate'          
						--  THEN DiagnosisDate          
						-- END          
						--,CASE           
						-- WHEN @SortExpression = 'DiagnosisDate DESC'          
						--  THEN DiagnosisDate          
						-- END DESC          
						--  ,CASE           
						-- WHEN @SortExpression = 'DiagnosisEvent'          
						--  THEN DiagnosisEvent          
						-- END          
						--,CASE           
						-- WHEN @SortExpression = 'DiagnosisEvent DESC'          
						--  THEN DiagnosisEvent          
						-- END DESC          
						,ClientId
					) AS RowNumber
			FROM #SyndromicSurveillanceData
			)
		SELECT TOP (
				CASE 
					WHEN (@PageNumber = - 1)
						THEN (
								SELECT Isnull(totalrows, 0)
								FROM counts
								)
					ELSE (@PageSize)
					END
				) ClientId
			,ClientName
			,DiagnosisDate
			,DiagnosisEvent
			,ICD10Code
			,DocumentId
			,LastDownload
			,totalcount
			,rownumber
		INTO #finalresultset
		FROM rankresultset
		WHERE rownumber > ((@PageNumber - 1) * @PageSize)

		IF (
				SELECT Isnull(Count(*), 0)
				FROM #finalresultset
				) < 1
		BEGIN
			SELECT 0 AS PageNumber
				,0 AS NumberOfPages
				,0 NumberOfRows
		END
		ELSE
		BEGIN
			SELECT TOP 1 @PageNumber AS PageNumber
				,CASE (totalcount % @PageSize)
					WHEN 0
						THEN Isnull((totalcount / @PageSize), 0)
					ELSE Isnull((totalcount / @PageSize), 0) + 1
					END AS NumberOfPages
				,Isnull(totalcount, 0) AS NumberOfRows
			FROM #finalresultset
		END

		SELECT ClientId
			,ClientName
			,CONVERT(VARCHAR(20), DiagnosisDate, 101) + ' ' + RIGHT(CONVERT(VARCHAR, DiagnosisDate, 0), 7) AS DiagnosisDate
			,DiagnosisEvent
			,ICD10Code
			,DocumentId
			,CONVERT(VARCHAR(20), LastDownload, 101) + ' ' + RIGHT(CONVERT(VARCHAR, LastDownload, 0), 7) AS LastDownload
		FROM #finalresultset
		ORDER BY rownumber
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, Error_number()) + '*****' + CONVERT(VARCHAR(4000), Error_message()) + '*****' + Isnull(CONVERT(VARCHAR, Error_procedure()), '[ssp_SCListPagePublicHealthSurveillances]') + '*****' + CONVERT(VARCHAR, Error_line()) + '*****' + CONVERT(VARCHAR, Error_severity()) + '*****' + CONVERT(VARCHAR, Error_state())

		RAISERROR (
				@Error
				,-- Message text.                    
				16
				,-- Severity.                    
				1 -- State.                    
				);
	END CATCH
END
GO

