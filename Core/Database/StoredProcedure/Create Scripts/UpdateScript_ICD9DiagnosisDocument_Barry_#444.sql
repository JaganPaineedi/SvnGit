
-- Task: Barry - Support #444
-- Date: 7/12/2017

IF EXISTS (SELECT 1 FROM DocumentCodes WHERE  DocumentCodeId=5)
BEGIN
	UPDATE DocumentCodes SET DiagnosisDocument=NULL WHERE DocumentCodeId=5
END