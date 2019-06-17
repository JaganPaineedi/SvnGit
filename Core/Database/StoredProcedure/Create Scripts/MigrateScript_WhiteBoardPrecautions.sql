DECLARE @Falls INT,@Bleeding INT,@Seizures INT,@UI INT,@I INT,@O INT, @BP INT


SELECT @Falls = a.GlobalCodeId
FROM GlobalCodes AS a
WHERE ISNULL(a.RecordDeleted,'N')='N'
AND a.Category = 'WBPrecautions'
AND a.Code = 'F'

SELECT @Bleeding = a.GlobalCodeId
FROM GlobalCodes AS a
WHERE ISNULL(a.RecordDeleted,'N')='N'
AND a.Category = 'WBPrecautions'
AND a.Code = 'B'

SELECT @Seizures = a.GlobalCodeId
FROM GlobalCodes AS a
WHERE ISNULL(a.RecordDeleted,'N')='N'
AND a.Category = 'WBPrecautions'
AND a.Code = 'S'

SELECT @UI = a.GlobalCodeId
FROM GlobalCodes AS a
WHERE ISNULL(a.RecordDeleted,'N')='N'
AND a.Category = 'WBPrecautions'
AND a.Code = 'UI'

SELECT @I = a.GlobalCodeId
FROM GlobalCodes AS a
WHERE ISNULL(a.RecordDeleted,'N')='N'
AND a.Category = 'WBPrecautions'
AND a.Code = 'I'

SELECT @O = a.GlobalCodeId
FROM GlobalCodes AS a
WHERE ISNULL(a.RecordDeleted,'N')='N'
AND a.Category = 'WBPrecautions'
AND a.Code = 'O'

SELECT @BP = a.GlobalCodeId
FROM GlobalCodes AS a
WHERE ISNULL(a.RecordDeleted,'N')='N'
AND a.Category = 'WBPrecautions'
AND a.Code = 'BP'

CREATE TABLE #Migrate (
WhiteBoardInfoId INT,
GlobalCodeId INT,
PrecautionText VARCHAR(500)
)

INSERT INTO #Migrate ( WhiteBoardInfoId,  PrecautionText,GlobalCodeId )
SELECT WhiteBoardInfoId,FallsPrecautionText,@Falls
FROM dbo.WhiteBoard AS a
WHERE ISNULL(a.RecordDeleted,'N')='N'
AND ISNULL(a.FallsPrecaution,'N') = 'Y'
UNION ALL
SELECT WhiteBoardInfoId,a.BleedingPrecautionText ,@Bleeding
FROM dbo.WhiteBoard AS a
WHERE ISNULL(a.RecordDeleted,'N')='N'
AND ISNULL(a.BleedingPrecaution,'N') = 'Y'
UNION ALL
SELECT WhiteBoardInfoId,a.SeizuresPrecautionText ,@Seizures
FROM dbo.WhiteBoard AS a
WHERE ISNULL(a.RecordDeleted,'N')='N'
AND ISNULL(a.SeizuresPrecaution,'N') = 'Y'
UNION ALL
SELECT WhiteBoardInfoId,a.BulimiaProtocolPrecautionText , @BP
FROM dbo.WhiteBoard AS a
WHERE ISNULL(a.RecordDeleted,'N')='N'
AND ISNULL(a.BulimiaProtocolPrecaution,'N') = 'Y'
UNION ALL
SELECT WhiteBoardInfoId,a.UrinaryIncontinencePrecautionText , @UI
FROM dbo.WhiteBoard AS a
WHERE ISNULL(a.RecordDeleted,'N')='N'
AND ISNULL(a.UrinaryIncontinencePrecaution,'N') = 'Y'
UNION ALL
SELECT WhiteBoardInfoId,a.InfectionPrecautionText , @I
FROM dbo.WhiteBoard AS a
WHERE ISNULL(a.RecordDeleted,'N')='N'
AND ISNULL(a.InfectionPrecaution,'N') = 'Y'
UNION ALL
SELECT WhiteBoardInfoId,a.OtherPrecautionText , @O
FROM dbo.WhiteBoard AS a
WHERE ISNULL(a.RecordDeleted,'N')='N'
AND ISNULL(a.OtherPrecaution,'N') = 'Y'

INSERT INTO dbo.WhiteBoardPrecautions ( PrecautionId,PrecautionComment, WhiteBoardInfoId)
SELECT GlobalCodeId,PrecautionText,WhiteBoardInfoId
FROM #Migrate

DROP TABLE #Migrate