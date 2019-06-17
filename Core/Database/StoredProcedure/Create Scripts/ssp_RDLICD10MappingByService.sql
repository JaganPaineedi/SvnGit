IF object_id('ssp_RDLICD10MappingByService', 'P') IS NOT NULL
	DROP PROCEDURE ssp_RDLICD10MappingByService
GO

CREATE PROCEDURE ssp_RDLICD10MappingByService
	/*
	Procedure: ssp_RDLICD10MappingByService
	Purpose: Query database for all services provided by a clinician and display ICD9 / ICD10 mapping from the Service Diagnoses.  Used by the ssp_RDLICD10MappingByService report.

	Change Log:

	Name          Date         Comment
	==================================
	T.Remisoski   07/30/2015   Created
	T.Remisoski	  08/10/2015   Incorporated changes requested by Sandy Hall.
	T.Remisoski	  08/21/2015   Incorporated *more* changes requested by Sandy Hall.
*/
	@ClinicianStaffIds VARCHAR(max)
	,@ServiceProgramIds VARCHAR(max)
	,@ServiceStatuses VARCHAR(max)
	,@OnOrAfterDate DATETIME
	,@IncludeClientsWithDSM5Documents CHAR(1)
AS
	;

WITH cteServices
AS (
	SELECT c.ClientId
		,c.LastName AS ClientLastName
		,c.FirstName AS ClientFirstName
		,stsv.LastName AS StaffLastName
		,stsv.FirstName AS StaffFirstName
		,pc.DisplayAs
		,sv.DateOfService
		,icd10.ICD10Code + CASE 
			WHEN icd10.DSMVCode = 'Y'
				THEN '*'
			ELSE ''
			END AS ICD10Code
		,icd10.ICDDescription
		,isnull(dsmc.ICDCode, dsmc.DSMCode) AS ICD9Code
		,dsc.DSMDescription
		,c.Active AS ClientActive
		,st.LastName AS PrimaryClinicianLastName
		,st.FirstName AS PrimaryClinicianFirstName
		,dbo.GetGlobalCodeName(sv.STATUS) AS ServcieStatus
		,pg.ProgramCode
	FROM ServiceDiagnosis AS dx4
	JOIN Services AS sv ON sv.ServiceId = dx4.ServiceId
	JOIN dbo.fnSplit(@ClinicianStaffIds, ',') AS psc ON cast(psc.Item AS INT) = sv.ClinicianId
	JOIN dbo.fnSplit(@ServiceProgramIds, ',') AS psp ON cast(psp.Item AS INT) = sv.ProgramId
	JOIN dbo.fnSplit(@ServiceStatuses, ',') AS pss ON cast(pss.Item AS INT) = sv.STATUS
	JOIN Programs AS pg ON pg.ProgramId = sv.ProgramId
	JOIN ProcedureCodes AS pc ON pc.ProcedureCodeId = sv.ProcedureCodeId
	JOIN DiagnosisDSMDescriptions AS dsc ON dsc.DSMCode = dx4.DSMCode
		AND dsc.DSMNumber = dx4.DSMNumber
	JOIN DiagnosisDSMCodes AS dsmc ON dsmc.DSMCode = dsc.DSMCode
	JOIN Clients AS c ON c.ClientId = sv.ClientId
	LEFT JOIN DiagnosisICD10ICD9Mapping AS map ON map.ICD9Code = isnull(dsmc.ICDCode, dsmc.DSMCode)
		AND isnull(map.RecordDeleted, 'N') = 'N'
	LEFT JOIN DiagnosisICD10Codes AS icd10 ON icd10.ICD10CodeId = map.ICD10CodeId
		AND isnull(icd10.IncludeInSearch, 'Y') = 'Y'
		AND isnull(icd10.RecordDeleted, 'N') = 'N'
	LEFT JOIN Staff AS st ON st.StaffId = c.PrimaryClinicianId
		AND isnull(st.RecordDeleted, 'N') = 'N'
	LEFT JOIN Staff AS stsv ON stsv.StaffId = sv.ClinicianId
		AND isnull(stsv.RecordDeleted, 'N') = 'N'
	WHERE dx4.ICD10Code IS NULL
		AND sv.Billable = 'Y'
		AND datediff(day, @OnOrAfterDate, sv.DateOfService) >= 0
		AND isnull(sv.RecordDeleted, 'N') = 'N'
		AND isnull(dx4.RecordDeleted, 'N') = 'N'
		AND isnull(c.RecordDeleted, 'N') = 'N'
		-- unbilled
		AND NOT EXISTS (
			SELECT *
			FROM Charges AS chg
			JOIN ClaimBatchCharges AS cbc ON cbc.ChargeId = chg.ChargeId
			WHERE chg.ServiceId = sv.ServiceId
				AND isnull(chg.RecordDeleted, 'N') = 'N'
				AND isnull(cbc.RecordDeleted, 'N') = 'N'
			)
	)
	,cteNewDiags
AS (
	SELECT dxDoc.ClientId
	FROM Documents AS dxdoc
	JOIN DocumentCodes AS dc ON dc.DocumentCodeId = dxdoc.DocumentCodeId
	JOIN DocumentDiagnosisCodes AS dx ON dx.DocumentVersionId = dxdoc.CurrentDocumentVersionId
	WHERE dxdoc.STATUS = 22
		AND dc.DiagnosisDocument = 'Y'
		AND isnull(dxdoc.RecordDeleted, 'N') = 'N'
		AND isnull(dc.RecordDeleted, 'N') = 'N'
		AND isnull(dx.RecordDeleted, 'N') = 'N'
	GROUP BY dxDoc.ClientId
	)
SELECT a.ClientId
	,a.ClientLastName
	,a.ClientFirstName
	,a.StaffLastName
	,a.StaffFirstName
	,a.DisplayAs
	,a.DateOfService
	,a.ICD10Code
	,a.ICDDescription
	,a.ICD9Code
	,a.DSMDescription
	,a.ClientActive
	,a.PrimaryClinicianLastName
	,a.PrimaryClinicianFirstName
	,a.ServcieStatus
	,a.ProgramCode
	,CASE 
		WHEN b.ClientId IS NOT NULL
			THEN 'Y'
		ELSE ''
		END AS HasDSM5Dx
FROM cteServices AS a
LEFT JOIN cteNewDiags AS b ON b.ClientId = a.ClientId
WHERE (
		(@IncludeClientsWithDSM5Documents = 'Y')
		OR (b.ClientId IS NULL)
		)
GO

