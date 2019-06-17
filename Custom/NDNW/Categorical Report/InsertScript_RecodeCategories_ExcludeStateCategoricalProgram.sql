---create 'ExcludeStateCategoricalProgram' recode category

DECLARE @RecodeCategoryId INT

SELECT @RecodeCategoryId = RecodeCategoryId
FROM dbo.RecodeCategories
WHERE CategoryCode = 'ExcludeStateCategoricalProgram'
AND ISNULL(RecordDeleted,'N')='N'

IF @RecodeCategoryId IS NULL 
BEGIN
INSERT INTO dbo.RecodeCategories
        ( CategoryCode, CategoryName, [Description], MappingEntity, RecodeType, RangeType )
VALUES  ( 'ExcludeStateCategoricalProgram','ExcludeStateCategoricalProgram','Programs to exclude from Categorical State Report','Programs.ProgramId',8401,8410)
SET @RecodeCategoryId = SCOPE_IDENTITY()
END 

DECLARE @Values TABLE
(
 IntegerCodeId int,
 CodeName varchar(MAX)
)

INSERT INTO @Values ( IntegerCodeId, CodeName )
select ProgramId, ProgramName
FROM programs 
WHERE programname IN (
'Baker House - Detox'
,'Baker House - Residentail SUD Treatment'
,'Baker House - Residential Co-Occurring'
,'BHW - Crisis Respite'
,'BHW - ICTS'
,'BHW - Jail Contract - MH'
,'BHW - Jail Diversion'
,'BHW - Juvenile Probation'
,'BHW - PE&O'
,'BHW - Prevention'
,'BHW - School Based Health Services'
,'BHW- EASA'
,'DD - Brokerage'
,'DD - Case Management Only'
,'DD - Children'
,'DD - Foster Home'
,'DD - Group Home'
,'DD - In Home Comprehensive'
,'DD - Out of County'
,'DD - Supported Living'
,'DD - Transition Age'
,'DD - Vocational'
,'EATC - Residential SUD Treatment'
,'EATC - Youth Day Treatment'
,'EATC- Residential Co-Occurring Treatment'
,'Powder River AIP'
,'RV - Residential Co-Occurring SUD Treamtment'
,'RV - Residential SUD Treatment'
,'RV - Youth MH Outpatient'
,'Test Program'
)
AND ISNULL(RecordDeleted,'N') ='N'


INSERT INTO dbo.Recodes ( RecodeCategoryId,IntegerCodeId,CodeName )
SELECT @RecodeCategoryId, a.IntegerCodeId, a.CodeName
FROM @Values a
WHERE NOT EXISTS ( SELECT 1 FROM Recodes WHERE RecodeCategoryId = @RecodeCategoryId AND a.IntegerCodeId = IntegerCodeId AND ISNULL(RecordDeleted,'N')='N' )


DECLARE @ApplicationStoredProcedureId INT
INSERT INTO dbo.ApplicationStoredProcedures
        ( 
         StoredProcedureName
        , CustomStoredProcedure
        , [Description]
        )
SELECT  'csp_RDLCategoricalReport', 'Y','Used in ND State Reporting' 
WHERE NOT EXISTS ( SELECT 1 FROM dbo.ApplicationStoredProcedures WHERE StoredProcedureName = 'csp_RDLCategoricalReport' AND ISNULL(RecordDeleted,'N')='N' )

SET @ApplicationStoredProcedureId = SCOPE_IDENTITY()

IF @ApplicationStoredProcedureId IS NULL
BEGIN

SELECT @ApplicationStoredProcedureId = ApplicationStoredProcedureId
FROM dbo.ApplicationStoredProcedures WHERE StoredProcedureName = 'csp_RDLCategoricalReport' AND ISNULL(RecordDeleted,'N')='N'
END 

INSERT INTO dbo.ApplicationStoredProcedureRecodeCategories
        ( 
        ApplicationStoredProcedureId
        , RecodeCategoryId
        )
SELECT @ApplicationStoredProcedureId , @RecodeCategoryId
WHERE NOT EXISTS ( SELECT 1 FROM dbo.ApplicationStoredProcedureRecodeCategories 
				WHERE ApplicationStoredProcedureId = @ApplicationStoredProcedureId AND RecodeCategoryId = @RecodeCategoryId AND ISNULL(RecordDeleted,'N')='N' )


