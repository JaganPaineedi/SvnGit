IF OBJECT_ID('tempdb..#ClientInpatientVisits') IS NOT NULL
	DROP TABLE #ClientInpatientVisits

CREATE TABLE #ClientInpatientVisits (
	ClientInpatientVisitId INT
	,BedProcedureCodeId INT
	,LeaveProcedureCodeId INT
	)

INSERT INTO #ClientInpatientVisits (ClientInpatientVisitId)
SELECT DISTINCT CIV.ClientInpatientVisitId
FROM ClientInpatientVisits CIV
JOIN BedAssignments BA ON CIV.ClientInpatientVisitId = BA.ClientInpatientVisitId
	AND ISNULL(CIV.RecordDeleted, 'N') = 'N'
	AND ISNULL(BA.RecordDeleted, 'N') = 'N'
	AND BA.[Status] <> 5001
WHERE (CIV.BedProcedureCodeId IS NULL OR CIV.LeaveProcedureCodeId IS NULL)

--BedProcedureCodeId
UPDATE TCIV
SET TCIV.BedProcedureCodeId = BA.ProcedureCodeId
FROM #ClientInpatientVisits TCIV
JOIN BedAssignments BA ON TCIV.ClientInpatientVisitId = BA.ClientInpatientVisitId
WHERE ISNULL(BA.RecordDeleted, 'N') = 'N'
	AND BA.[Status] = 5002
	AND BA.Disposition IS NULL
	AND TCIV.BedProcedureCodeId IS NULL
	
UPDATE TCIV
SET TCIV.BedProcedureCodeId = (SELECT TOP 1 BAH.ProcedureCodeId FROM dbo.BedAvailabilityHistory BAH JOIN dbo.Programs P ON (P.ProgramId = BAH.ProgramId) JOIN dbo.Beds B ON (B.BedId = BAH.BedId) WHERE BAH.BedId = BA.BedId AND (ISNULL(BAH.RecordDeleted, 'N') = 'N') AND (BAH.EndDate IS NULL OR BAH.EndDate > GETDATE()) ORDER BY BAH.BedAvailabilityHistoryId DESC)	
FROM #ClientInpatientVisits TCIV
JOIN BedAssignments BA ON TCIV.ClientInpatientVisitId = BA.ClientInpatientVisitId
WHERE ISNULL(BA.RecordDeleted, 'N') = 'N'
	AND BA.[Status] = 5002
	AND BA.Disposition IS NULL
	AND TCIV.BedProcedureCodeId IS NULL

UPDATE TCIV
SET TCIV.BedProcedureCodeId =(SELECT TOP 1 BA.ProcedureCodeId FROM BedAssignments BA WHERE BA.ClientInpatientVisitId = TCIV.ClientInpatientVisitId AND ISNULL(BA.RecordDeleted, 'N') = 'N' AND BA.[Status] = 5002 AND BA.Disposition IS NOT NULL ORDER BY BA.BedAssignmentId DESC)
FROM #ClientInpatientVisits TCIV
WHERE TCIV.BedProcedureCodeId IS NULL

UPDATE TCIV
SET TCIV.BedProcedureCodeId = (SELECT TOP 1 BAH.ProcedureCodeId FROM dbo.BedAvailabilityHistory BAH JOIN dbo.Programs P ON (P.ProgramId = BAH.ProgramId) JOIN dbo.Beds B ON (B.BedId = BAH.BedId) WHERE BAH.BedId = BA.BedId AND (ISNULL(BAH.RecordDeleted, 'N') = 'N') AND (BAH.EndDate IS NULL OR BAH.EndDate > GETDATE()) ORDER BY BAH.BedAvailabilityHistoryId DESC)	
FROM #ClientInpatientVisits TCIV
JOIN BedAssignments BA ON TCIV.ClientInpatientVisitId = BA.ClientInpatientVisitId
WHERE ISNULL(BA.RecordDeleted, 'N') = 'N'
	AND BA.[Status] = 5002
	AND TCIV.BedProcedureCodeId IS NULL
	
--LeaveProcedureCodeId
UPDATE TCIV
SET TCIV.LeaveProcedureCodeId = BA.ProcedureCodeId
FROM #ClientInpatientVisits TCIV
JOIN BedAssignments BA ON TCIV.ClientInpatientVisitId = BA.ClientInpatientVisitId
WHERE ISNULL(BA.RecordDeleted, 'N') = 'N'
	AND BA.[Status] = 5006
	AND BA.Disposition IS NULL
	AND TCIV.LeaveProcedureCodeId IS NULL
	
UPDATE TCIV
SET TCIV.LeaveProcedureCodeId = (SELECT TOP 1 BAH.LeaveProcedureCodeId FROM dbo.BedAvailabilityHistory BAH JOIN dbo.Programs P ON (P.ProgramId = BAH.ProgramId) JOIN dbo.Beds B ON (B.BedId = BAH.BedId) WHERE BAH.BedId = BA.BedId AND (ISNULL(BAH.RecordDeleted, 'N') = 'N') AND (BAH.EndDate IS NULL OR BAH.EndDate > GETDATE()) ORDER BY BAH.BedAvailabilityHistoryId DESC)	
FROM #ClientInpatientVisits TCIV
JOIN BedAssignments BA ON TCIV.ClientInpatientVisitId = BA.ClientInpatientVisitId
WHERE ISNULL(BA.RecordDeleted, 'N') = 'N'
	AND BA.[Status] = 5006
	AND BA.Disposition IS NULL
	AND TCIV.LeaveProcedureCodeId IS NULL
	
UPDATE TCIV
SET TCIV.LeaveProcedureCodeId =(SELECT TOP 1 BA.ProcedureCodeId FROM BedAssignments BA WHERE BA.ClientInpatientVisitId = TCIV.ClientInpatientVisitId AND ISNULL(BA.RecordDeleted, 'N') = 'N' AND BA.[Status] = 5006 AND BA.Disposition IS NOT NULL ORDER BY BA.BedAssignmentId DESC)
FROM #ClientInpatientVisits TCIV
WHERE TCIV.LeaveProcedureCodeId IS NULL

UPDATE TCIV
SET TCIV.LeaveProcedureCodeId = (SELECT TOP 1 BAH.LeaveProcedureCodeId FROM dbo.BedAvailabilityHistory BAH JOIN dbo.Programs P ON (P.ProgramId = BAH.ProgramId) JOIN dbo.Beds B ON (B.BedId = BAH.BedId) WHERE BAH.BedId = BA.BedId AND (ISNULL(BAH.RecordDeleted, 'N') = 'N') AND (BAH.EndDate IS NULL OR BAH.EndDate > GETDATE()) ORDER BY BAH.BedAvailabilityHistoryId DESC)	
FROM #ClientInpatientVisits TCIV
JOIN BedAssignments BA ON TCIV.ClientInpatientVisitId = BA.ClientInpatientVisitId
WHERE ISNULL(BA.RecordDeleted, 'N') = 'N'
	AND BA.[Status] = 5006
	AND TCIV.LeaveProcedureCodeId IS NULL
	
UPDATE TCIV
SET TCIV.LeaveProcedureCodeId = (SELECT TOP 1 BAH.LeaveProcedureCodeId FROM dbo.BedAvailabilityHistory BAH JOIN dbo.Programs P ON (P.ProgramId = BAH.ProgramId) JOIN dbo.Beds B ON (B.BedId = BAH.BedId) WHERE BAH.BedId = BA.BedId AND (ISNULL(BAH.RecordDeleted, 'N') = 'N') AND (BAH.EndDate IS NULL OR BAH.EndDate > GETDATE()) ORDER BY BAH.BedAvailabilityHistoryId DESC)	
FROM #ClientInpatientVisits TCIV
JOIN BedAssignments BA ON TCIV.ClientInpatientVisitId = BA.ClientInpatientVisitId
WHERE ISNULL(BA.RecordDeleted, 'N') = 'N'
	AND BA.[Status] = 5002
	AND BA.Disposition IS NULL
	AND TCIV.LeaveProcedureCodeId IS NULL
	
UPDATE TCIV
SET TCIV.LeaveProcedureCodeId = (SELECT TOP 1 BAH.LeaveProcedureCodeId FROM dbo.BedAvailabilityHistory BAH JOIN dbo.Programs P ON (P.ProgramId = BAH.ProgramId) JOIN dbo.Beds B ON (B.BedId = BAH.BedId) WHERE BAH.BedId = BA.BedId AND (ISNULL(BAH.RecordDeleted, 'N') = 'N') AND (BAH.EndDate IS NULL OR BAH.EndDate > GETDATE()) ORDER BY BAH.BedAvailabilityHistoryId DESC)	
FROM #ClientInpatientVisits TCIV
JOIN BedAssignments BA ON TCIV.ClientInpatientVisitId = BA.ClientInpatientVisitId
WHERE ISNULL(BA.RecordDeleted, 'N') = 'N'
	AND BA.[Status] = 5002
	AND TCIV.LeaveProcedureCodeId IS NULL
	
UPDATE CIV
SET CIV.BedProcedureCodeId = TCIV.BedProcedureCodeId
	,CIV.LeaveProcedureCodeId = TCIV.LeaveProcedureCodeId
	,CIV.ModifiedBy = 'UPDATE_43_WSGL'
	,CIV.ModifiedDate = GETDATE()
FROM ClientInpatientVisits CIV
JOIN #ClientInpatientVisits TCIV ON CIV.ClientInpatientVisitId = TCIV.ClientInpatientVisitId