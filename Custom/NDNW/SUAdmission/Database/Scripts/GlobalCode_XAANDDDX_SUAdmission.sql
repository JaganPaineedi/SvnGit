IF NOT EXISTS(SELECT CategoryCode from RecodeCategories WHERE CategoryCode='XAANDDDX')
BEGIN
INSERT INTO RecodeCategories(CategoryCode,CategoryName,Description)
VALUES( 'XAANDDDX','XAANDDDX','New Directions-Customizations #5')
END

DECLARE @RecodeCategoryId int  
SELECT @RecodeCategoryId = RecodeCategoryId from RecodeCategories where CategoryCode = 'XAANDDDX'

INSERT INTO Recodes(CharacterCodeId,RecodeCategoryId) 
select ICD10Code,@RecodeCategoryId from DiagnosisICD10Codes where ICDDescription like '%drugs%' OR ICDDescription like '%alcohol%'