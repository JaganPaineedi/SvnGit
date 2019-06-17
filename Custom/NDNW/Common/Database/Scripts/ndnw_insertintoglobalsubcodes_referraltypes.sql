BEGIN TRAN

CREATE TABLE #TempSubCodes (
	[Value] VARCHAR(250)
	)

INSERT INTO #TempSubCodes
        ( Value )
VALUES  ( 'Probation/Parole'  -- Value - varchar(250)
          )

INSERT INTO #TempSubCodes
        ( Value )
VALUES  ( 'Court'  -- Value - varchar(250)
          )

INSERT INTO #TempSubCodes
        ( Value )
VALUES  ( 'Attorney'  -- Value - varchar(250)
          )

INSERT INTO #TempSubCodes
        ( Value )
VALUES  ( 'Jail/Police'  -- Value - varchar(250)
          )

INSERT INTO #TempSubCodes
        ( Value )
VALUES  ( 'School District/School'  -- Value - varchar(250)
          )

INSERT INTO #TempSubCodes
        ( Value )
VALUES  ( 'Social Service Agency'  -- Value - varchar(250)
          )

INSERT INTO #TempSubCodes
        ( Value )
VALUES  ( 'Nursing Home Ext Care'  -- Value - varchar(250)
          )

INSERT INTO #TempSubCodes
        ( Value )
VALUES  ( 'Emergency Room'  -- Value - varchar(250)
          )

INSERT INTO #TempSubCodes
        ( Value )
VALUES  ( 'Other Physician'  -- Value - varchar(250)
          )

INSERT INTO #TempSubCodes
        ( Value )
VALUES  ( 'Psychiatric Hospital'  -- Value - varchar(250)
          )

INSERT INTO #TempSubCodes
        ( Value )
VALUES  ( 'Outpt Psych Clinic'  -- Value - varchar(250)
          )

INSERT INTO #TempSubCodes
        ( Value )
VALUES  ( 'Private Psychiatrist'  -- Value - varchar(250)
          )
          
INSERT INTO #TempSubCodes
        ( Value )
VALUES  ( 'Other Private MH Practitioner'  -- Value - varchar(250)
          )

INSERT INTO #TempSubCodes
        ( Value )
VALUES  ( 'Other CMHC'  -- Value - varchar(250)
          )

INSERT INTO #TempSubCodes
        ( Value )
VALUES  ( 'Community Residential'  -- Value - varchar(250)
          )

INSERT INTO #TempSubCodes
        ( Value )
VALUES  ( 'Other Inpt Residential'  -- Value - varchar(250)
          )

INSERT INTO #TempSubCodes
        ( Value )
VALUES  ( 'Substance Use Inpt Tx'  -- Value - varchar(250)
          )

INSERT INTO #TempSubCodes
        ( Value )
VALUES  ( 'Substance Use Outpt Tx'  -- Value - varchar(250)
          )

INSERT INTO #TempSubCodes
        ( Value )
VALUES  ( 'Assisted Living'  -- Value - varchar(250)
          )
      
INSERT INTO #TempSubCodes
        ( Value )
VALUES  ( 'Nursing Facility'  -- Value - varchar(250)
          )    

--SELECT * FROM #TempSubcodes

CREATE TABLE #TempSubAndGlobalCodes (
		GlobalCodeId INT,
		SubCodeValue VARCHAR(250)
		)

INSERT INTO #TempSubAndGlobalCodes
        ( GlobalCodeId, SubCodeValue )
SELECT gc.GlobalCodeId,
		tsc.Value
FROM GlobalCodes gc
CROSS JOIN #TempSubCodes tsc
WHERE gc.Category =  'REFERRALTYPE        '
ORDER BY GlobalCodeId

--SELECT * FROM #TempSubAndGlobalCodes

DROP TABLE #TempSubcodes

IF NOT EXISTS (
				SELECT * FROM dbo.GlobalSubCodes gsc
				JOIN dbo.GlobalCodes gc ON gc.GlobalCodeId = gsc.GlobalCodeId
				WHERE gc.Category =  'REFERRALTYPE        '
				)

BEGIN

INSERT INTO dbo.GlobalSubCodes
        ( GlobalCodeId ,
          SubCodeName ,
          Active ,
          CannotModifyNameOrDelete
        )
SELECT GlobalCodeId,
		SubCodeValue,
		'Y',
		'N'      
FROM #TempSubAndGlobalCodes

END

DROP TABLE #TempSubAndGlobalCodes

--SELECT * FROM dbo.GlobalSubCodes gsc
--JOIN dbo.GlobalCodes gc ON gc.GlobalCodeId = gsc.GlobalCodeId
--WHERE gc.Category =  'REFERRALTYPE        '

SELECT * FROM dbo.GlobalSubCodes

COMMIT TRAN

