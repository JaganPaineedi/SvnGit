-- Created By : Himmat Jamdade
-- Created On : 19 Oct 2016
-- Purpose    : Update script for  Changing ICD10 Code As per Core Bug#643.
--- UPDATE ICD10Code ---------
 
update dbo.DiagnosisICD10Codes set  RecordDeleted='Y' 
where  ICD10Code = 'F40.00'
and    ICDDescription <> 'Agoraphobia, unspecified'