DECLARE @CodeToInsert TABLE
(
ProcedureCodeId INT,
EMCode INT
)

INSERT INTO @CodeToInsert ( EMCode, ProcedureCodeId )
SELECT 99204, 216
UNION ALL
SELECT 
99203, 215
UNION ALL
SELECT 
99202, 214
UNION ALL
SELECT 
99201, 213
UNION ALL
SELECT 
99214, 219
UNION ALL
SELECT 
99213, 218
UNION ALL
SELECT 
99212, 217

INSERT INTO dbo.EMCodeProcedureCodes
        ( CreatedBy
        , CreatedDate
        , EMCode
        , ProcedureCodeId
        , Active
        , EffectiveFrom
        )
SELECT
'jcarlson',
'1/11/2016',
a.EmCode,
a.ProcedureCodeId,
'Y',
'5/16/2015'
FROM @CodeToInsert a
WHERE NOT EXISTS ( SELECT 1 FROM dbo.EMCodeProcedureCodes b WHERE a.EMCode = b.EMCode
				AND a.ProcedureCodeId = b.ProcedureCodeId
				AND ISNULL(b.RecordDeleted,'N')='N' 
			  )
			  
			  