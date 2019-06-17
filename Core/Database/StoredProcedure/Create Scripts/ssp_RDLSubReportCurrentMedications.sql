/****** Object:  StoredProcedure [dbo].[ssp_RDLSubReportCurrentMedications]    Script Date: 07/25/2016 19:01:07 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLSubReportCurrentMedications]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_RDLSubReportCurrentMedications]
GO

/****** Object:  StoredProcedure [dbo].[ssp_RDLSubReportCurrentMedications]    Script Date: 07/25/2016 19:01:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_RDLSubReportCurrentMedications] (@DocumentVersionId INT)
AS
BEGIN

/********************************************************************************                                                           
--          
-- Copyright: Streamline Healthcare Solutions          
-- "CurrentMedications"        
-- Purpose: Script for CCC-Customizations task#12  (copied from Key Pointe – #604 made it core )      
--          
-- Author:  Ravichandra        
-- Date:    05-21-2018        
-- *****History****          

*********************************************************************************/
	DECLARE @ClientId INT
	DECLARE @DateOfService DATETIME
	DECLARE @ServiceId INT

	SELECT @ClientId = d.ClientId
	FROM Documents d
	WHERE d.InProgressDocumentVersionId = @DocumentVersionId

	SELECT @ServiceId = d.ServiceId
	FROM Documents d
	WHERE d.InProgressDocumentVersionId = @DocumentVersionId

	SELECT @DateOfService = s.DateOfService
	FROM services s
	LEFT JOIN Documents d ON d.ServiceId = s.ServiceId
	WHERE s.ServiceId = @ServiceId

	DECLARE @Effectivedate DATETIME

	SET @Effectivedate = (
			SELECT D.Effectivedate
			FROM Documents D
			JOIN DocumentVersions DV ON D.documentid = DV.documentId
			WHERE DV.DocumentVersionId = @DocumentVersionId
			)
	SET @EffectiveDate = CONVERT(VARCHAR, @EffectiveDate, 101)

	DECLARE @LastScriptIdTable TABLE (
		ClientmedicationInstructionid INT
		,ClientMedicationScriptId INT
		)

	INSERT INTO @LastScriptIdTable (
		ClientmedicationInstructionid
		,ClientMedicationScriptId
		)
	SELECT ClientmedicationInstructionid
		,ClientMedicationScriptId
	FROM (
		SELECT cmsd.ClientmedicationInstructionid
			,cmsd.ClientMedicationScriptId
			,cms.OrderDate
			,ROW_NUMBER() OVER (
				PARTITION BY cmsd.ClientmedicationInstructionid ORDER BY cms.OrderDate DESC
					,cmsd.ClientMedicationScriptId DESC
				) AS rownum
		FROM clientmedicationscriptdrugs cmsd
		JOIN clientmedicationscripts cms ON (cmsd.ClientMedicationScriptId = cms.ClientMedicationScriptId)
		WHERE ClientMedicationInstructionId IN (
				SELECT ClientMedicationInstructionId
				FROM clientmedications a
				JOIN dbo.ClientMedicationInstructions b ON (a.ClientMedicationId = b.ClientMedicationId)
				WHERE a.ClientId = @ClientId
					AND ISNULL(a.RecordDeleted, 'N') = 'N'
					AND ISNULL(b.Active, 'Y') = 'Y'
					AND ISNULL(b.RecordDeleted, 'N') = 'N'
				)
			AND ISNULL(cmsd.RecordDeleted, 'N') = 'N'
			AND ISNULL(cms.RecordDeleted, 'N') = 'N'
			AND ISNULL(cms.Voided, 'N') = 'N'
		) AS a
	WHERE rownum = 1

	SET @DateOfService = CONVERT(VARCHAR, @DateOfService, 101)

	CREATE TABLE #MedTest (
		MedicationName VARCHAR(100)
		,StrengthDescription VARCHAR(250)
		,Direction VARCHAR(250)
		,Quantity VARCHAR(250)
		,RXStartDate DATETIME
		,RXEndDate DATETIME
		,Refills VARCHAR(50)
		,PrescriberName VARCHAR(100)
		,Rowrank INT
		);

	WITH CTE
	AS (
		SELECT DISTINCT MDM.MedicationName AS MedicationName
			,ISNULL(CAST(MD.StrengthDescription AS VARCHAR(max)), '') AS StrengthDescription
			,CM.MedicationStartDate
			,CASE 
				WHEN dbo.ssf_GetGlobalCodeNameById(ISNULL(CAST(CMI.Schedule AS VARCHAR(50)), '')) = ''
					THEN ''
				ELSE dbo.ssf_GetGlobalCodeNameById(ISNULL(CAST(CMI.Schedule AS VARCHAR(50)), ''))
				END AS Direction
			--,CASE 
			--	WHEN CMSD.PharmacyText IS NULL
			--		THEN CAST(CMSD.Pharmacy AS VARCHAR(30))
			--	ELSE CMSD.PharmacyText
			--	END AS Quantity
			--, ISNULL(CAST(CMI.Quantity AS VARCHAR(50)), '') AS Quantity  
			,CAST(CMI.Quantity AS VARCHAR(50)) + ' ' + ISNULL(CAST(GC.CodeName AS VARCHAR(50)), '') AS Quantity
			,Convert(VARCHAR(10), CMSD.[StartDate], 101) AS RXStartDate
			,Convert(VARCHAR(10), CMSD.[EndDate], 101) AS RXEndDate
			,ISNULL(CAST(CMSD.Refills AS VARCHAR(50)), '') AS Refills
			,CM.PrescriberName
			,ROW_NUMBER() OVER (
				PARTITION BY CM.clientMedicationid
				,CMI.Schedule
				,MD.StrengthDescription ORDER BY CMSD.StartDate DESC
				) AS RowNum
		FROM ClientMedicationInstructions CMI
		JOIN ClientMedications CM ON (
				CMI.clientmedicationId = CM.clientMedicationid
				AND (
					ISNULL(cm.discontinued, 'N') <> 'Y'
					OR (
						ISNULL(cm.discontinued, 'N') = 'Y'
						AND cast(CM.DiscontinueDate AS DATE) > CAST(@EffectiveDate AS DATE)
						)
					)
				AND ISNULL(cm.RecordDeleted, 'N') <> 'Y'
				)
			AND cast(CM.CreatedDate AS DATE) <= CAST(@EffectiveDate AS DATE)
		LEFT JOIN GlobalCodes GC ON (GC.GlobalCodeID = CMI.Unit)
			AND ISNULL(gc.RecordDeleted, 'N') <> 'Y'
		LEFT JOIN GlobalCodes GC1 ON (GC1.GlobalCodeId = CMI.Schedule)
			AND ISNULL(gc1.RecordDeleted, 'N') <> 'Y'
		JOIN MDMedicationNames MDM ON (
				CM.MedicationNameId = MDM.MedicationNameId
				AND ISNULL(mdm.RecordDeleted, 'N') <> 'Y'
				)
		JOIN MDMedications MD ON (
				MD.MedicationID = CMI.StrengthId
				AND ISNULL(md.RecordDeleted, 'N') <> 'Y'
				)
		JOIN ClientMedicationScriptDrugs CMSD ON (
				CMI.ClientMedicationInstructionId = CMSD.ClientMedicationInstructionId
				AND ISNULL(CMSD.RecordDeleted, 'N') <> 'Y'
				AND cast(CMSD.CreatedDate AS DATE) <= CAST(@EffectiveDate AS DATE)
				)
		JOIN ClientMedicationScriptDrugStrengths CMSDS ON (
				CM.clientMedicationid = CMSDS.clientMedicationid
				AND ISNULL(CMSDS.RecordDeleted, 'N') <> 'Y'
				)
		LEFT JOIN @LastScriptIdTable LSId ON (
				cmi.ClientMedicationInstructionId = LSId.ClientMedicationInstructionId
				AND cmsd.ClientMedicationScriptId = LSId.ClientMedicationScriptId
				)
			AND (
				CMSD.ClientMedicationScriptId IS NULL
				OR CMSD.ClientMedicationScriptId = LSId.ClientMedicationScriptId
				)
		LEFT JOIN dbo.ClientMedicationScripts AS cms ON cms.ClientMedicationScriptId = LSId.ClientMedicationScriptId
		WHERE cm.ClientId = @ClientId
			AND ISNULL(CM.Ordered, 'N') = 'Y'
			AND ISNULL(cmi.Active, 'Y') = 'Y' --Uncommented By Sanjay On 30-Jan-2017
			AND ISNULL(cmi.RecordDeleted, 'N') <> 'Y'
			--AND ISNULL(cast(CMS.OrderDate as date) , cast(CM.MedicationStartDate as date)) <=CAST( @EffectiveDate as DATE) -- 25-07-2016  Bibhudatta   
			--AND ISNULL(CAST(CMSD.StartDate as DAte),cast(CM.MedicationStartDate as date))<=CAST( @EffectiveDate as DATE)--commented By Sanjay On 20-feb-2017
		)
	INSERT INTO #MedTest (
		MedicationName
		,StrengthDescription
		,Direction
		,Quantity
		,RXStartDate
		,RXEndDate
		,Refills
		,PrescriberName
		,Rowrank
		)
	SELECT DISTINCT MedicationName
		,StrengthDescription
		,Direction
		,Quantity
		,RXStartDate
		,RXEndDate
		,Refills
		,PrescriberName
		,ROW_NUMBER() OVER (
			PARTITION BY MedicationName ORDER BY MedicationName
			) AS RRank
	FROM CTE
	WHERE RowNum = 1
	ORDER BY MedicationName ASC

	SELECT DISTINCT MedicationName
		,ISNULL(STUFF((
					SELECT ' <br/>' + CHAR(13) + ISNULL(CAST(MD.StrengthDescription AS VARCHAR(max)), '')
					FROM #MedTest MD
					WHERE M.MedicationName = MD.MedicationName
					FOR XML PATH('')
						,type
					).value('.', 'nvarchar(max)'), 1, 1, ' '), '') AS StrengthDescription
		,ISNULL(STUFF((
					SELECT ' <br/>' + CHAR(13) + ISNULL(CAST(MD.Direction AS VARCHAR(max)), '')
					FROM #MedTest MD
					WHERE M.MedicationName = MD.MedicationName
					FOR XML PATH('')
						,type
					).value('.', 'nvarchar(max)'), 1, 1, ' '), '') AS Direction
		,ISNULL(STUFF((
					SELECT ' <br/>' + CHAR(13) + ISNULL(CAST(MD.Quantity AS VARCHAR(max)), '')
					FROM #MedTest MD
					WHERE M.MedicationName = MD.MedicationName
					FOR XML PATH('')
						,type
					).value('.', 'nvarchar(max)'), 1, 1, ' '), '') AS Quantity
		,ISNULL(STUFF((
					SELECT ' <br/>' + CHAR(13) + ISNULL(CONVERT(VARCHAR, MD.RXStartDate, 101), '')
					FROM #MedTest MD
					WHERE M.MedicationName = MD.MedicationName
					FOR XML PATH('')
						,type
					).value('.', 'nvarchar(max)'), 1, 1, ' '), '') AS RXStartDate
		,ISNULL(STUFF((
					SELECT ' <br/>' + CHAR(13) + ISNULL(CONVERT(VARCHAR, MD.RXEndDate, 101), '')
					FROM #MedTest MD
					WHERE M.MedicationName = MD.MedicationName
					FOR XML PATH('')
						,type
					).value('.', 'nvarchar(max)'), 1, 1, ' '), '') AS RXEndDate
		,Refills
		,ISNULL(STUFF((
					SELECT ' <br/>' + CHAR(13) + ISNULL(MD.PrescriberName, '')
					FROM #MedTest MD
					WHERE M.MedicationName = MD.MedicationName
					FOR XML PATH('')
						,type
					).value('.', 'nvarchar(max)'), 1, 1, ' '), '') AS PrescriberName
	FROM #MedTest M

	DROP TABLE #MedTest
END

--Checking For Errors                     
IF (@@error != 0)
BEGIN
	DECLARE @Error VARCHAR(8000)

	SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_RDLSubReportCurrentMedications') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

	RAISERROR (
			@Error
			,-- Message text.           
			16
			,-- Severity.           
			1 -- State.                                                             
			);

	RETURN
END
GO


