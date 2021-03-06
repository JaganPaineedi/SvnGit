
IF not EXISTS (
  SELECT * 
  FROM   sys.columns 
  WHERE  object_id = OBJECT_ID(N'[dbo].[CustomDocumentDiagnosticAssessments]') 
         AND name = 'LevelofCare'
)
Begin
	ALTER TABLE CustomDocumentDiagnosticAssessments  ADD LevelofCare [dbo].[type_GlobalCode] NULL
End

IF not EXISTS (
  SELECT * 
  FROM   sys.columns 
  WHERE  object_id = OBJECT_ID(N'[dbo].[CustomDocumentDischarges]') 
         AND name = 'DASTScore'
)
Begin
ALTER TABLE CustomDocumentDischarges ADD DASTScore int NULL
End

IF not EXISTS (
  SELECT * 
  FROM   sys.columns 
  WHERE  object_id = OBJECT_ID(N'[dbo].[CustomDocumentDischarges]') 
         AND name = 'MASTScore'
)
Begin
ALTER TABLE CustomDocumentDischarges ADD MASTScore  int NULL
End

IF not EXISTS (
  SELECT * 
  FROM   sys.columns 
  WHERE  object_id = OBJECT_ID(N'[dbo].[CustomDocumentDischarges]') 
         AND name = 'InitialLevelofCare'
)
Begin
ALTER TABLE CustomDocumentDischarges ADD InitialLevelofCare [dbo].[type_GlobalCode] NULL
End
IF not EXISTS (
  SELECT * 
  FROM   sys.columns 
  WHERE  object_id = OBJECT_ID(N'[dbo].[CustomDocumentDischarges]') 
         AND name = 'DischargeLevelofCare'
)
Begin
ALTER TABLE CustomDocumentDischarges ADD DischargeLevelofCare [dbo].[type_GlobalCode] NULL
End

IF not EXISTS (
  SELECT * 
  FROM   sys.columns 
  WHERE  object_id = OBJECT_ID(N'[dbo].[CustomDocumentTransfers]') 
         AND name = 'LevelofCare'
)
Begin
ALTER TABLE CustomDocumentTransfers  ADD LevelofCare [dbo].[type_GlobalCode] NULL
End