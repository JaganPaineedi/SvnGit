
IF NOT EXISTS(SELECT CategoryCode from RecodeCategories WHERE CategoryCode='XPSYCDIGNOSISMAPPING')
BEGIN
	INSERT INTO dbo.RecodeCategories (CategoryCode,CategoryName,Description,MappingEntity)
	VALUES  ('XPSYCDIGNOSISMAPPING','XPSYCDIGNOSISMAPPING',
			'This recode category is used to map diagnosis with the substance use check boxes',
			 'Diagnosiscodes.ICD10Code')
END

--SELECT * FROM DiagnosisICD10Codes where ICD10Code like '%F10.10%'
--Select RecodeCategoryId  From RecodeCategories WHERE CategoryCode='XPSYCDIGNOSISMAPPING'
--SELECT * FROM  recodes where   RecodeCategoryId=12172
--delete from  recodes where   RecodeCategoryId=12185
--DocumentDiagnosisCodes

Declare @RecoedeCategoryId INT
Select @RecoedeCategoryId= RecodeCategoryId  From RecodeCategories WHERE CategoryCode='XPSYCDIGNOSISMAPPING'
--SELECT * FROM  recodes where RecodeCategoryId=@RecoedeCategoryId
IF NOT EXISTS(SELECT 1 FROM Recodes WHERE RecodeCategoryId=@RecoedeCategoryId)
BEGIN

INSERT INTO [Recodes] ([IntegerCodeId],[CharacterCodeId],[CodeName],[RecodeCategoryId],[TranslationValue1],[TranslationValue2])VALUES(69627,'SUAlcohol','F10.10 - Alcohol use disorder, Mild',@RecoedeCategoryId,'150','Low')
INSERT INTO [Recodes] ([IntegerCodeId],[CharacterCodeId],[CodeName],[RecodeCategoryId],[TranslationValue1],[TranslationValue2])VALUES(69636,'SUAlcohol','F10.20 - Alcohol use disorder, Moderate',@RecoedeCategoryId,'151','Medium')
INSERT INTO [Recodes] ([IntegerCodeId],[CharacterCodeId],[CodeName],[RecodeCategoryId],[TranslationValue1],[TranslationValue2])VALUES(69637,'SUAlcohol','F10.20 - Alcohol use disorder, Severe',@RecoedeCategoryId,'152','High')
INSERT INTO [Recodes] ([IntegerCodeId],[CharacterCodeId],[CodeName],[RecodeCategoryId],[TranslationValue1],[TranslationValue2])VALUES(69787,'SUAmphetamines','F15.10 - Amphetamine-type substance use disorder, Mild',@RecoedeCategoryId,'150','Low')
INSERT INTO [Recodes] ([IntegerCodeId],[CharacterCodeId],[CodeName],[RecodeCategoryId],[TranslationValue1],[TranslationValue2])VALUES(69801,'SUAmphetamines','F15.20 - Amphetamine-type substance use disorder, Moderate',@RecoedeCategoryId,'151','Medium')
INSERT INTO [Recodes] ([IntegerCodeId],[CharacterCodeId],[CodeName],[RecodeCategoryId],[TranslationValue1],[TranslationValue2])VALUES(69802,'SUAmphetamines','F15.20 - Amphetamine-type substance use disorder, Severe',@RecoedeCategoryId,'152','High')
INSERT INTO [Recodes] ([IntegerCodeId],[CharacterCodeId],[CodeName],[RecodeCategoryId],[TranslationValue1],[TranslationValue2])VALUES(69753,'SUCocaine','F14.10 - Cocaine use disorder, Mild, Severe',@RecoedeCategoryId,'150','Low')
INSERT INTO [Recodes] ([IntegerCodeId],[CharacterCodeId],[CodeName],[RecodeCategoryId],[TranslationValue1],[TranslationValue2])VALUES(69764,'SUCocaine','F14.20 - Cocaine use disorder, Moderate',@RecoedeCategoryId,'151','Medium')
INSERT INTO [Recodes] ([IntegerCodeId],[CharacterCodeId],[CodeName],[RecodeCategoryId],[TranslationValue1],[TranslationValue2])VALUES(69765,'SUCocaine','F14.20 - Cocaine use disorder, Severe',@RecoedeCategoryId,'152','High')
INSERT INTO [Recodes] ([IntegerCodeId],[CharacterCodeId],[CodeName],[RecodeCategoryId],[TranslationValue1],[TranslationValue2])VALUES(69765,'SUMarijuana','F12.10 - Cannabis use disorder, Mild',@RecoedeCategoryId,'150','Low')
INSERT INTO [Recodes] ([IntegerCodeId],[CharacterCodeId],[CodeName],[RecodeCategoryId],[TranslationValue1],[TranslationValue2])VALUES(69699,'SUMarijuana','F12.20 - Cannabis use disorder, Moderate',@RecoedeCategoryId,'151','Medium')
INSERT INTO [Recodes] ([IntegerCodeId],[CharacterCodeId],[CodeName],[RecodeCategoryId],[TranslationValue1],[TranslationValue2])VALUES(69700,'SUMarijuana','F12.20 - Cannabis use disorder, Severe',@RecoedeCategoryId,'152','High')
INSERT INTO [Recodes] ([IntegerCodeId],[CharacterCodeId],[CodeName],[RecodeCategoryId],[TranslationValue1],[TranslationValue2])VALUES(69664,'SUOpiates','F11.10 - Opioid use disorder, Mild',@RecoedeCategoryId,'150','Low')
INSERT INTO [Recodes] ([IntegerCodeId],[CharacterCodeId],[CodeName],[RecodeCategoryId],[TranslationValue1],[TranslationValue2])VALUES(69672,'SUOpiates','F11.20 - Opioid use disorder, Moderate',@RecoedeCategoryId,'151','Medium')
INSERT INTO [Recodes] ([IntegerCodeId],[CharacterCodeId],[CodeName],[RecodeCategoryId],[TranslationValue1],[TranslationValue2])VALUES(69673,'SUOpiates','F11.20 - Opioid use disorder, Severe',@RecoedeCategoryId,'152','High')
INSERT INTO [Recodes] ([IntegerCodeId],[CharacterCodeId],[CodeName],[RecodeCategoryId],[TranslationValue1],[TranslationValue2])VALUES(69949,'SUOthers','F19.99 - Unspecified other (or unknown) substance-related disorder',@RecoedeCategoryId,'150','Low')
INSERT INTO [Recodes] ([IntegerCodeId],[CharacterCodeId],[CodeName],[RecodeCategoryId],[TranslationValue1],[TranslationValue2])VALUES(69835,'SUHallucinogen','F16.10 - Other hallucinogen use disorder, Mild',@RecoedeCategoryId,'150','Low')
INSERT INTO [Recodes] ([IntegerCodeId],[CharacterCodeId],[CodeName],[RecodeCategoryId],[TranslationValue1],[TranslationValue2])VALUES(69849,'SUHallucinogen','F16.20 - Other hallucinogen use disorder, Moderate',@RecoedeCategoryId,'151','Medium')
INSERT INTO [Recodes] ([IntegerCodeId],[CharacterCodeId],[CodeName],[RecodeCategoryId],[TranslationValue1],[TranslationValue2])VALUES(69850,'SUHallucinogen','F16.20 - Other hallucinogen use disorder, Severe',@RecoedeCategoryId,'152','High')
INSERT INTO [Recodes] ([IntegerCodeId],[CharacterCodeId],[CodeName],[RecodeCategoryId],[TranslationValue1],[TranslationValue2])VALUES(69885,'SUInhalant','F18.10 - Inhalant use disorder, Mild',@RecoedeCategoryId,'150','Low')
INSERT INTO [Recodes] ([IntegerCodeId],[CharacterCodeId],[CodeName],[RecodeCategoryId],[TranslationValue1],[TranslationValue2])VALUES(69893,'SUInhalant','F18.20 - Inhalant use disorder, Moderate',@RecoedeCategoryId,'151','Medium')
INSERT INTO [Recodes] ([IntegerCodeId],[CharacterCodeId],[CodeName],[RecodeCategoryId],[TranslationValue1],[TranslationValue2])VALUES(69894,'SUInhalant','F18.20 - Inhalant use disorder, Severe',@RecoedeCategoryId,'152','High')
INSERT INTO [Recodes] ([IntegerCodeId],[CharacterCodeId],[CodeName],[RecodeCategoryId],[TranslationValue1],[TranslationValue2])VALUES(69717,'SUBenzos','F13.10 - Sedative, hypnotic, or anxiolytic use disorder, Mild',@RecoedeCategoryId,'150','Low')
INSERT INTO [Recodes] ([IntegerCodeId],[CharacterCodeId],[CodeName],[RecodeCategoryId],[TranslationValue1],[TranslationValue2])VALUES(69726,'SUBenzos','F13.20 - Sedative, hypnotic, or anxiolytic use disorder, Moderate',@RecoedeCategoryId,'151','Medium')
INSERT INTO [Recodes] ([IntegerCodeId],[CharacterCodeId],[CodeName],[RecodeCategoryId],[TranslationValue1],[TranslationValue2])VALUES(69723,'SUBenzos','F13.20 - Sedative, hypnotic, or anxiolytic use disorder, Severe',@RecoedeCategoryId,'152','High')

END