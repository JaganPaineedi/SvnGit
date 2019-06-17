/****** Object:  StoredProcedure [dbo].[ssp_GetCarePlanPrescribedServicesAuthorizationCodes]    Script Date: 12/31/2014 15:02:56 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetCarePlanPrescribedServicesAuthorizationCodes]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_GetCarePlanPrescribedServicesAuthorizationCodes] --5,323,'G'
GO

/****** Object:  StoredProcedure [dbo].[ssp_GetCarePlanPrescribedServicesAuthorizationCodes]    Script Date: 12/31/2014 15:02:56 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_GetCarePlanPrescribedServicesAuthorizationCodes] (
	@ClientID INT
	,@DocumentVersionId INT
	,@FlagInitGet CHAR(1)
	)
AS
/*******************************************************************************
* Author:		Pradeep.A
* Create date: 01/19/2015
* Description:	Get Authorization Codes for CarePlanPrescribedServices
*      
*	Date		Author			Reason      
*	04/16/2015	Pradeep.A		ProgramType configurations has been moved to Recodes
*	08/08/2016	Lakshmi kanth   Inteventions altered by alphabatical order for pathway support go live #12.21
*	04/20/2017	jcarlson		Keystone Customizations - 55 Updated logic to handle ProgramProcedures updates
*   07/02/2017  Lakshmi			Added condition Allow All Programs ((ISNULL(Pro.AllowAllPrograms,'N') ='Y')) to pull intervention into the									Care Plan>Interventions tab when the procedure code is set up in Authorization Codes. as per the task 
								PEP-Environmental Issues Tracking 29
*   18/04/2018  Lakshmi         Changed  @DocumentStatus <> 22 to @DocumentStatus = 22 it means, ON initialisation the interventions will
								pull based on the current date. As part of 	Spring River-Support Go Live #82
*	08/20/2018	Msood			What: Added SCSP to implement custom logic
								Why: Boundless - Support Task #281			
*  01/30/2109	Ponnin			What: Initializing InterventionDetails of CarePlanPrescribedServices table. 	Why: HighPlains - Environment Issues Tracking - Task #8 
*  03/22/2019 Vishnu Narayanan  What: Reverted Ponnin's changes.   Why: HighPlains - Environment Issues Tracking - Task #8				
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
-- Msood 08/20/2018
	IF EXISTS (	SELECT *
				FROM sys.objects
				WHERE object_id = OBJECT_ID(N'[dbo].[scsp_GetCarePlanPrescribedServicesAuthorizationCodes]')
				AND type IN (N'P',N'PC'))
  BEGIN      
   EXEC scsp_GetCarePlanPrescribedServicesAuthorizationCodes @ClientId,@DocumentVersionId,@FlagInitGet
  END      
  ELSE
  BEGIN    
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
			AND AC.Internal = 'Y'
		ORDER BY LTRIM(RTRIM(AC.DisplayAs)) ASC
	END	
      	
		IF @FlagInitGet='I' AND ISNULL(@DocumentVersionId,0)<=0
			Update #TempAuthorizationCodes SET [PersonResponsible]=NULL
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_GetCarePlanPrescribedServicesAuthorizationCodes') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

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

