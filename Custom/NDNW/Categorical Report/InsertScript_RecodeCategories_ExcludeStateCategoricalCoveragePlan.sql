---create 'ExcludeStateCategoricalCoveragePlan' recode category

DECLARE @RecodeCategoryId INT

SELECT @RecodeCategoryId = RecodeCategoryId
FROM dbo.RecodeCategories
WHERE CategoryCode = 'ExcludeStateCategoricalCoveragePlan'
AND ISNULL(RecordDeleted,'N')='N'

IF @RecodeCategoryId IS NULL 
BEGIN
INSERT INTO dbo.RecodeCategories
        ( CategoryCode, CategoryName, [Description], MappingEntity, RecodeType, RangeType )
VALUES  ( 'ExcludeStateCategoricalCoveragePlan','ExcludeStateCategoricalCoveragePlan','CoveragePlans to exclude from Categorical State Report','CoveragePlans.CoveragePlanId',8401,8410)
SET @RecodeCategoryId = SCOPE_IDENTITY()
END 

DECLARE @Values TABLE
(
 IntegerCodeId int,
 CodeName varchar(MAX)
)

INSERT INTO @Values ( IntegerCodeId, CodeName )
SELECT CoveragePlanId, DisplayAs
FROM dbo.CoveragePlans 
WHERE DisplayAs IN (
'AllCare'
,'Cascade Health Allia'
,'Columbia Pacific CCO'
,'DMAP - AOD'
,'DMAP - MH'
,'DOC'
,'EAP'
,'EOCCO - GOBHI MH'
,'EOCCO - MODA SUD'
,'EOHSC Adult Wraparou'
,'EOHSC Peer to Peer'
,'Family Care CCO'
,'Federal Probation Co'
,'Health Share Oregon'
,'IHN'
,'Indigent Tx Bed'
,'Jackson Care CCO'
,'Jail'
,'PacificSource Commun'
,'PrimaryHealth of Jos'
,'SBHC Grant'
,'Trillium'
,'Umpqua Health Allian'
,'Willamette Valley He'
,'Yamhill CCO'
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
