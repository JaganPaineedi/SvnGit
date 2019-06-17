


DECLARE @StoredProcedure VARCHAR(MAX) = 'csp_ERCreateChargesForCrossOver'

DECLARE @Recodes TABLE
        (
         CategoryCode VARCHAR(100)
        ,CategoryName VARCHAR(100)
        ,[Description] VARCHAR(MAX)
        )

INSERT  INTO @Recodes
        ( CategoryCode, CategoryName, Description )
VALUES  ( 'CROSSOVERCLAIMSOURCE' -- CategoryCode - varchar(100)
         , 'Cross Over Claims Sources'-- CategoryName - varchar(100)
         , 'Coverage plans that may cross over claims.'-- Description - varchar(max)
         ),
        ( 'CROSSOVERCLAIMDESTINATION', 'Cross Over Claim Destinations',
         'Coverage plans that may receive cross over claims.' )


INSERT  INTO dbo.RecodeCategories
        ( 
         CategoryCode
        ,CategoryName
        ,Description
        ,MappingEntity
        ,RecodeType
        ,RangeType
        )
        SELECT  r.CategoryCode-- CategoryCode - varchar(100)
               ,r.CategoryName-- CategoryName - varchar(100)
               ,r.Description-- Description - type_Comment2
               ,'CoveragePlans'-- MappingEntity - varchar(100)
               ,8401-- RecodeType - type_GlobalCode
               ,NULL-- RangeType - type_GlobalCode
        FROM    @Recodes r
        WHERE   NOT EXISTS ( SELECT 1
                             FROM   dbo.RecodeCategories rc
                             WHERE  rc.CategoryCode = r.CategoryCode
                                    AND ISNULL(rc.RecordDeleted, 'N') <> 'Y' )

INSERT  INTO dbo.ApplicationStoredProcedures
        ( 
         StoredProcedureName
        ,CustomStoredProcedure
        ,Description
        )
        SELECT  @StoredProcedure-- StoredProcedureName - varchar(500)
               ,'Y'-- CustomStoredProcedure - type_YOrN
               ,'Generates 0$ charges for cross over claims.'-- Description - type_Comment2
        WHERE   NOT EXISTS ( SELECT 1
                             FROM   dbo.ApplicationStoredProcedures asp
                             WHERE  asp.StoredProcedureName = @StoredProcedure
                                    AND ISNULL(asp.RecordDeleted, 'N') <> 'Y' )

INSERT  INTO dbo.ApplicationStoredProcedureRecodeCategories
        ( 
         ApplicationStoredProcedureId
        ,RecodeCategoryId
        )
        SELECT  asp.ApplicationStoredProcedureId-- ApplicationStoredProcedureId - int
               ,rc.RecodeCategoryId-- RecodeCategoryId - int
        FROM    dbo.ApplicationStoredProcedures asp
                CROSS JOIN @Recodes r
                JOIN dbo.RecodeCategories rc
                    ON r.CategoryCode = rc.CategoryCode
                       AND ISNULL(rc.RecordDeleted, 'N') <> 'Y'
        WHERE   asp.StoredProcedureName = @StoredProcedure
                AND ISNULL(asp.RecordDeleted, 'N') <> 'Y'
                AND NOT EXISTS ( SELECT 1
                                 FROM   dbo.ApplicationStoredProcedureRecodeCategories asprc
                                 WHERE  asprc.ApplicationStoredProcedureId = asp.ApplicationStoredProcedureId
                                        AND asprc.RecodeCategoryId = rc.RecodeCategoryId )
      


INSERT  INTO dbo.Recodes
        ( IntegerCodeId
        ,CharacterCodeId
        ,CodeName
        ,FromDate
        ,ToDate
        ,RecodeCategoryId
        )
        SELECT  cp.CoveragePlanId-- IntegerCodeId - int
               ,NULL-- CharacterCodeId - varchar(100)
               ,cp.CoveragePlanName-- CodeName - varchar(100)
               ,'2015-1-1'-- FromDate - date
               ,NULL-- ToDate - date
               ,rc.RecodeCategoryId-- RecodeCategoryId - int
        FROM    dbo.RecodeCategories rc
                JOIN dbo.CoveragePlans cp
                    ON ISNULL(cp.MedicarePlan, 'N') = 'Y'
        WHERE   rc.CategoryCode = 'CROSSOVERCLAIMSOURCE'
                AND NOT EXISTS ( SELECT 1
                                 FROM   dbo.Recodes r
                                 WHERE  r.RecodeCategoryId = rc.RecodeCategoryId
                                        AND IntegerCodeId = cp.CoveragePlanId
                                        AND ISNULL(r.RecordDeleted, 'N') <> 'Y' )

INSERT  INTO dbo.Recodes
        ( IntegerCodeId
        ,CharacterCodeId
        ,CodeName
        ,FromDate
        ,ToDate
        ,RecodeCategoryId
        )
        SELECT  cp.CoveragePlanId-- IntegerCodeId - int
               ,NULL-- CharacterCodeId - varchar(100)
               ,cp.CoveragePlanName-- CodeName - varchar(100)
               ,'2015-1-1'-- FromDate - date
               ,NULL-- ToDate - date
               ,rc.RecodeCategoryId-- RecodeCategoryId - int
        FROM    dbo.RecodeCategories rc
                JOIN dbo.CoveragePlans cp
                    ON ISNULL(cp.MedicarePlan, 'N') = 'N'
        WHERE   rc.CategoryCode = 'CROSSOVERCLAIMDESTINATION'
                AND NOT EXISTS ( SELECT 1
                                 FROM   dbo.Recodes r
                                 WHERE  r.RecodeCategoryId = rc.RecodeCategoryId
                                        AND IntegerCodeId = cp.CoveragePlanId
                                        AND ISNULL(r.RecordDeleted, 'N') <> 'Y' )