IF object_id('ssp_RDLICD10MappingByPrimaryClinician', 'P') IS NOT NULL
	DROP PROCEDURE ssp_RDLICD10MappingByPrimaryClinician
GO

CREATE PROCEDURE ssp_RDLICD10MappingByPrimaryClinician
	/*
	Procedure: ssp_RDLICD10MappingByPrimaryClinician
	Purpose: Query database for all clients assigned to a primary clinician and display ICD9 / ICD10 mapping.  Used by the RDLICD10MappingByPrimaryClinician report.

	Change Log:

	Name          Date         Comment
	==================================
	T.Remisoski   07/30/2015   Created
	T.Remisoski	  08/10/2015   Incorporated changes requested by Sandy Hall.
*/
	@PrimaryClinicianStaffIds VARCHAR(max)
	,@EnrolledProgramIds VARCHAR(max)
	,@PrimaryProgramAssignmentOnly CHAR(1)
	,@ActiveOnly CHAR(1)
	,@UnmappedOnly CHAR(1)
	,@IncludeClientsWithDSM5Documents CHAR(1)
AS
;with cteClients as (
	SELECT c.ClientId
		,c.LastName AS ClientLastName
		,c.FirstName AS ClientFirstName
		,st.LastName AS StaffLastName
		,st.FirstName AS StaffFirstName
		,icd10.ICD10Code + CASE 
			WHEN icd10.DSMVCode = 'Y'
				THEN '*'
			ELSE ''
			END AS ICD10Code
		,icd10.ICDDescription
		,isnull(dsmc.ICDCode, dsmc.DSMCode) AS ICD9Code
		,dsc.DSMDescription
		,c.Active AS ClientActive
		,d.EffectiveDate AS DxEffective
		,pg.ProgramCode AS ProgramName
	FROM Documents AS d
	JOIN DiagnosesIandII AS dx4 ON dx4.DocumentVersionId = d.CurrentDocumentVersionId
	JOIN DiagnosisDSMDescriptions AS dsc ON dsc.DSMCode = dx4.DSMCode
		AND dsc.DSMNumber = dx4.DSMNumber
	JOIN DiagnosisDSMCodes AS dsmc ON dsmc.DSMCode = dsc.DSMCode
	JOIN Clients AS c ON c.ClientId = d.ClientId
	LEFT JOIN dbo.fnSplit(@PrimaryClinicianStaffIds, ',') AS pcs ON cast(pcs.Item AS INT) = isnull(c.PrimaryClinicianId, - 1)
	LEFT JOIN DiagnosisICD10ICD9Mapping AS map ON map.ICD9Code = isnull(dsmc.ICDCode, dsmc.DSMCode)
		AND isnull(map.RecordDeleted, 'N') = 'N'
	LEFT JOIN DiagnosisICD10Codes AS icd10 ON icd10.ICD10CodeId = map.ICD10CodeId
		AND isnull(icd10.IncludeInSearch, 'Y') = 'Y'
		AND isnull(icd10.RecordDeleted, 'N') = 'N'
	LEFT JOIN Staff AS st ON st.StaffId = c.PrimaryClinicianId
	LEFT JOIN ClientPrograms AS cpg ON cpg.ClientId = d.ClientId
		AND cpg.STATUS <> 5
		AND isnull(cpg.RecordDeleted, 'N') = 'N'
	LEFT JOIN Programs AS pg ON pg.ProgramId = cpg.ProgramId
		AND isnull(pg.RecordDeleted, 'N') = 'N'
	LEFT JOIN dbo.fnSplit(@EnrolledProgramIds, ',') AS pgs ON cast(pgs.Item AS INT) = isnull(pg.ProgramId, - 1)
	WHERE d.DocumentCodeid = 5 --and d.ClientId = 17830
		AND (
			(cast(pgs.Item AS INT) = - 1)
			OR (
				(
					(
						@PrimaryProgramAssignmentOnly = 'Y'
						AND cpg.PrimaryAssignment = 'Y'
						)
					OR (@PrimaryProgramAssignmentOnly = 'N')
					)
				AND (pgs.Item IS NOT NULL)
				)
			)
		AND (
			(cast(pcs.Item AS INT) = - 1)
			OR (pcs.Item IS NOT NULL)
			)
		AND (
			(@ActiveOnly = 'N')
			OR (c.Active = 'Y')
			)
		AND (
			(@UnmappedOnly = 'N')
			OR (icd10.ICD10CodeId IS NULL)
			)
		AND d.STATUS = 22
		AND isnull(d.RecordDeleted, 'N') = 'N'
		AND isnull(dx4.RecordDeleted, 'N') = 'N'
		AND isnull(c.RecordDeleted, 'N') = 'N'
		AND NOT EXISTS (
			SELECT *
			FROM Documents AS d2
			WHERE d2.ClientId = d.ClientId
				AND d2.DocumentCodeId = d.DocumentCodeId
				AND d2.STATUS = 22
				AND datediff(day, d2.EffectiveDate, d.EffectiveDate) < 0
				AND isnull(d2.RecordDeleted, 'N') = 'N'
			)
	),
	cteNewDiags as (
			SELECT dxDoc.ClientId
			FROM Documents AS dxdoc
			JOIN DocumentCodes AS dc ON dc.DocumentCodeId = dxdoc.DocumentCodeId
			JOIN DocumentDiagnosisCodes AS dx ON dx.DocumentVersionId = dxdoc.CurrentDocumentVersionId
			WHERE dxdoc.STATUS = 22
				AND dc.DiagnosisDocument = 'Y'
				AND isnull(dxdoc.RecordDeleted, 'N') = 'N'
				AND isnull(dc.RecordDeleted, 'N') = 'N'
				AND isnull(dx.RecordDeleted, 'N') = 'N'
			group by dxDoc.ClientId
	),
	cteExternalAuths as (
		select ccp.ClientId
		from Authorizations as a
		join AuthorizationDocuments as ad on ad.AuthorizationDocumentId = a.AuthorizationDocumentId
		join ClientCoveragePlans as ccp on ccp.ClientCoveragePlanId = ad.ClientCoveragePlanId
		where a.ProviderId is not null
		and datediff(day, a.EndDate, '10/1/2015') <= 0
		and isnull(a.RecordDeleted, 'N') = 'N'
		and isnull(ad.RecordDeleted, 'N') = 'N'
		and isnull(ccp.RecordDeleted, 'N') = 'N'
		group by ccp.ClientId
	)
	select a.ClientId
		,a.ClientLastName
		,a.ClientFirstName
		,a.StaffLastName
		,a.StaffFirstName
		,a.ICD10Code
		,a.ICDDescription
		,a.ICD9Code
		,a.DSMDescription
		,a.ClientActive
		,a.DxEffective
		,a.ProgramName
		,case when b.ClientId is not null then 'Y' else '' end as HasDSM5Dx
		,case when c.ClientId is not null then 'Y' else '' end as HasExternalAuthsPostOctOne
	from cteClients as a
	left join cteNewDiags as b on b.ClientId = a.ClientId
	left join cteExternalAuths as c on c.ClientId = a.ClientId
	where ((@IncludeClientsWithDSM5Documents = 'Y') or (b.ClientId is null))

GO

