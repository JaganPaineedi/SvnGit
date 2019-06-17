IF NOT EXISTS (
  SELECT * 
  FROM   sys.columns 
  WHERE  object_id = OBJECT_ID(N'[dbo].[ClientMedicationScriptsPreview]') 
         AND name = 'SureScriptsChangeRequestId'
)
BEGIN
ALTER TABLE dbo.ClientMedicationScriptsPreview ADD SureScriptsChangeRequestId int NULL

end