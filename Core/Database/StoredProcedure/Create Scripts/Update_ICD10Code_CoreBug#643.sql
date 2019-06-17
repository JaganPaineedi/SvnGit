-- Created By : Himmat Jamdade
-- Created On : 13 Oct 2016
-- Purpose    : Update script for  Changing ICD10 Code As per Core Bug#643.

--- UPDATE ICD10Code ---------
 
UPDATE D
SET D.ICD10Code = 'F40.0',
D.ModifiedBy='Admin',
D.ModifiedDate=GETDATE()
FROM DiagnosisICD10Codes D
WHERE ICD10Code = 'F40.00'
AND ICDDescription = 'Agoraphobia' 
					  
