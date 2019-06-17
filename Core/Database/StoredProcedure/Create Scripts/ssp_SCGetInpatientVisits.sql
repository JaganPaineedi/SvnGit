IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetInpatientVisits]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_SCGetInpatientVisits] --'2015/04/29',223
GO

/*********************************************************************/
/* Stored Procedure: [ssp_SCGetInpatientVisits]              */
/* Date              Author                  Purpose                 */
/* 4/17/2015         Hemant kumar            what:This sp will get the inpatient visit information why:Inpatient Coding Document #228                          */
/*********************************************************************/
/**  Change History **/                                                                         
/********************************************************************************/                                                                           
/**  Date:    Author:     Description: **/                                                                         
/**  --------  --------    ------------------------------------------- */  

CREATE PROCEDURE [dbo].[ssp_SCGetInpatientVisits] @effectiveDate VARCHAR(10)
	,@ClientId INT
AS
BEGIN
	BEGIN TRY
		DECLARE @admitdate DATETIME
		DECLARE @effectivedatepara DATETIME

		SET @effectivedatepara = (
				SELECT CONVERT(DATETIME, @effectiveDate)
				)

		DECLARE @dischargedate DATETIME

		CREATE TABLE #ClientInpatientVisitTempTable (
			ClientInpatientVisitId INT
			,Inpatientvisits VARCHAR(max)
			,AdmissionType INT
			,DischargeType INT
			,AdmissionSource INT
			,ClientAdmitDate VARCHAR(12)
			,ClientDischargedDate VARCHAR(12)
			,ClientInpatientStatus VARCHAR(12)
			,AdmitDate DATETIME
			,DischargedDate DATETIME
			)

		INSERT INTO #ClientInpatientVisitTempTable (
			ClientInpatientVisitId
			,Inpatientvisits
			,AdmissionType
			,DischargeType
			,AdmissionSource
			,ClientAdmitDate
			,ClientDischargedDate
			,ClientInpatientStatus
			,AdmitDate
			,DischargedDate
			)
		SELECT ClientInpatientVisitId
			,(
				ISNULL(CONVERT(VARCHAR(12), AdmitDate, 101), '') + CASE 
					WHEN CONVERT(VARCHAR(12), AdmitDate, 101) <> ''
						THEN '  -  '
					ELSE ''
					END + ISNULL(CONVERT(VARCHAR(12), DischargedDate, 101), '') + CASE 
					WHEN CONVERT(VARCHAR(12), DischargedDate, 101) <> ''
						THEN '  -  '
					ELSE ''
					END + ISNULL(CONVERT(VARCHAR(12), G.CodeName, 101), '')
				) AS Inpatientvisits
			,AdmissionType
			,DischargeType
			,AdmissionSource
			,ISNULL(CONVERT(VARCHAR(12), AdmitDate, 101), '') AS ClientAdmitDate
			,ISNULL(CONVERT(VARCHAR(12), DischargedDate, 101), '') AS ClientDischargedDate
			,ISNULL(CONVERT(VARCHAR(12), G.CodeName, 101), '') AS ClientInpatientStatus
			,CONVERT(DATETIME, CONVERT(VARCHAR(10), AdmitDate, 111))
			,CONVERT(DATETIME, CONVERT(VARCHAR(10), DischargedDate, 111))
		FROM ClientInpatientVisits CIV
		LEFT JOIN GlobalCodes G ON CIV.[Status] = G.GlobalCodeId
		WHERE ClientId = @ClientId
			AND ISNULL(CIV.RecordDeleted, 'N') <> 'Y'

		SELECT ClientInpatientVisitId
			,Inpatientvisits
			,AdmissionType
			,DischargeType
			,AdmissionSource
			,ClientAdmitDate
			,ClientDischargedDate
			,ClientInpatientStatus
		FROM #ClientInpatientVisitTempTable
		WHERE AdmitDate <= @effectivedatepara
			AND (
				DischargedDate >= @effectivedatepara
				OR DischargedDate IS NULL
				)
		ORDER BY 1 DESC
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCGetInpatientVisits') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****ERROR_SEVERITY=' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****ERROR_STATE=' + Convert(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error /* Message text*/
				,16 /*Severity*/
				,1 /*State*/
				)
	END CATCH
END
GO

