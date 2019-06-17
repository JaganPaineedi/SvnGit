IF EXISTS (SELECT * FROM sys.objects
			WHERE object_id = OBJECT_ID(N'[dbo].[csp_GetCarePlanPrescribedServicesAuthorizationCodes]')AND type IN (N'P',N'PC'))

DROP PROCEDURE [dbo].csp_GetCarePlanPrescribedServicesAuthorizationCodes
GO

/****** Object:  StoredProcedure [dbo].[csp_GetCarePlanPrescribedServicesAuthorizationCodes]    Script Date: 08/20/2018 11:56:06 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[csp_GetCarePlanPrescribedServicesAuthorizationCodes] (
	@ClientID INT
	,@DocumentVersionId INT
	,@FlagInitGet CHAR(1)
	)
AS
/*******************************************************************************
* Author:		Neelima
* Create date: 03/22/2019
* Description:	Initializing InterventionDetails of CarePlanPrescribedServices table. 	
* Why: New Directions - Support Go Live #932	   
*	Date		Author			Reason     
																
*******************************************************************************/
BEGIN
	BEGIN TRY
		DECLARE @EffectiveDate DATE
		DECLARE @DocumentStatus INT
		DECLARE @LatestConvCarePlanVersionId INT
		DECLARE @ConvCarePlanEffectiveDate DATE

		-- If the document is signed, use the effective date otherwise use the current date to get data.      
		SELECT @EffectiveDate = b.EffectiveDate
			,@DocumentStatus = b.STATUS
		FROM DocumentVersions a
		INNER JOIN Documents b ON (a.DocumentId = b.DocumentId)
		WHERE a.DocumentVersionId = @DocumentVersionId

		IF isnull(@DocumentStatus, 0) = 22
			SET @EffectiveDate = convert(DATE, getdate(), 101)

		-- List of Authorization Codes based on    
		INSERT INTO #TempAuthorizationCodes (
			AuthorizationCodeId
			,AuthorizationCodeName
			,CarePlanPrescribedServiceId
			,DocumentVersionId
			,NumberOfSessions
			,[Units]
			,[UnitType]
			,[FrequencyType]
			,[PersonResponsible]
			,[IsChecked]
			,[InterventionDetails]
			,TableName
			)
		SELECT AC.AuthorizationCodeId
		,LTRIM(RTRIM(AC.DisplayAs)) AS AuthorizationCodeName -- Added Ltrim and trim by Lakshmi, 08-08-2016, pathway support go live #12.21 
			,ISNULL(CarePlanPrescribedServiceId, CONVERT(INT, '-' + CONVERT(VARCHAR(50), row_number() OVER (
							ORDER BY AC.AuthorizationCodeId
							)))) AS PrescribedServiceId
			,@DocumentVersionId AS DocumentVersionId
			,CDCP.NumberOfSessions
			,CDCP.Units
			,CDCP.UnitType
			,CDCP.FrequencyType
			,CDCP.PersonResponsible
		
			,CASE 
				WHEN CDCP.AuthorizationCodeId IS NULL
					THEN 'N'
				WHEN ISNULL(CDCP.RecordDeleted, 'N') = 'Y'
					THEN 'N'
				ELSE 'Y'
				END AS IsChecked
				,CDCP.InterventionDetails
			,'CarePlanPrescribedServices' AS TableName
		FROM AuthorizationCodes AC
		LEFT JOIN CarePlanPrescribedServices CDCP ON AC.AuthorizationCodeId = CDCP.AuthorizationCodeId
			AND CDCP.DocumentVersionId = @DocumentVersionId
		INNER JOIN (
			SELECT DISTINCT ACPC.AuthorizationCodeId
			FROM AuthorizationCodeProcedureCodes ACPC
			INNER JOIN ProcedureCodes pro on pro.ProcedureCodeId=ACPC.ProcedureCodeId
			WHERE ISNULL(ACPC.RecordDeleted, 'N') <> 'Y'
			AND (ISNULL(Pro.AllowAllPrograms,'N') ='Y' OR EXISTS(SELECT 1 FROM ProgramProcedures pp 
				LEFT JOIN ClientPrograms CP ON CP.ProgramId = pp.ProgramId
				AND  CP.ClientId = @ClientID 
				AND ISNULL(CP.RecordDeleted, 'N') <> 'Y'
				AND CP.STATUS IN (
					1
					,4
					) /*GloablCodeId - 1-'Requested',4-'Enrolled' Status*/
			LEFT JOIN Programs P ON CP.ProgramId = P.ProgramId
				WHERE pp.ProcedureCodeId = ACPC.ProcedureCodeId
				AND ISNULL(pp.RecordDeleted, 'N') <> 'Y'
				AND ( pp.StartDate <= CONVERT(DATE,@EffectiveDate) OR pp.StartDate IS NULL )
				AND ( pp.EndDate >= CONVERT(DATE,@EffectiveDate) OR pp.EndDate IS NULL )
				AND (
					Convert(DATE, CP.EnrolledDate) <= @EffectiveDate
					OR Convert(DATE, CP.RequestedDate) <= @EffectiveDate
					)
				AND (
					CP.DischargedDate IS NULL
					OR Convert(DATE, CP.DischargedDate) >= @EffectiveDate
					)
				AND EXISTS (
						SELECT *
						FROM dbo.ssf_RecodeValuesCurrent('CAREPLANPROGRAMTYPE') AS CD
						WHERE CD.IntegerCodeId = P.ProgramType
						)))		
			) AS ACID ON AC.AuthorizationCodeId = ACID.AuthorizationCodeId
		WHERE ISNULL(AC.RecordDeleted, 'N') <> 'Y'
			AND AC.Active = 'Y'
			AND AC.Internal IN('Y','N')
		ORDER BY LTRIM(RTRIM(AC.DisplayAs)) ASC
		
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'csp_GetCarePlanPrescribedServicesAuthorizationCodes') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

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

