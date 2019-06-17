IF OBJECT_ID('tempdb..#StaffPrograms') IS NOT NULL
	DROP TABLE #StaffPrograms
CREATE TABLE #StaffPrograms (StaffProgramId INT)


INSERT INTO #StaffPrograms(StaffProgramId)
SELECT StaffProgramId FROM (
SELECT ROW_NUMBER() OVER (PARTITION BY StaffId,ProgramId ORDER BY StaffProgramId) AS RowNum,StaffProgramId FROM StaffPrograms WHERE ISNULL(RecordDeleted, 'N') = 'N'
) AS SP
WHERE RowNum >= 2

UPDATE SP
SET SP.RecordDeleted = 'Y',
	SP.DeletedBy = 'Allendale - EITracking #24',
	SP.DeletedDate = GETDATE()
FROM StaffPrograms SP
JOIN #StaffPrograms TSP ON SP.StaffProgramId = TSP.StaffProgramId
WHERE ISNULL(SP.RecordDeleted, 'N') = 'N'


IF OBJECT_ID('tempdb..#StaffLocations') IS NOT NULL
	DROP TABLE #StaffLocations
CREATE TABLE #StaffLocations (StaffLocationsId INT)


INSERT INTO #StaffLocations(StaffLocationsId)
SELECT StaffLocationsId FROM (
SELECT ROW_NUMBER() OVER (PARTITION BY StaffId,LocationId ORDER BY StaffLocationsId) AS RowNum,StaffLocationsId FROM StaffLocations WHERE ISNULL(RecordDeleted, 'N') = 'N'
) AS SL
WHERE RowNum >= 2

UPDATE SL
SET SL.RecordDeleted = 'Y',
	SL.DeletedBy = 'Allendale - EITracking #24',
	SL.DeletedDate = GETDATE()
FROM StaffLocations SL
JOIN #StaffLocations TSP ON SL.StaffLocationsId = TSP.StaffLocationsId
WHERE ISNULL(SL.RecordDeleted, 'N') = 'N'