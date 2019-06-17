-- =============================================  
-- Author - Govind
-- Description - Set UserDefinedCategory = 'N' for GlobalCodeCategory 'TREATMENTTEAMROLE'
-- Task - Network 180 Support Go Live Task#162
-- =============================================  

IF EXISTS ( SELECT  GlobalCodeCategoryId
            FROM    dbo.GlobalCodeCategories
            WHERE   category = 'TREATMENTTEAMROLE' ) 
    BEGIN
        DECLARE @GLobalCodeCategoryId INT = ( SELECT    GlobalCodeCategoryId
                                              FROM      dbo.GlobalCodeCategories
                                              WHERE     category = 'TREATMENTTEAMROLE'
                                                        AND ISNULL(RecordDeleted,'N') <> 'Y'
                                                        AND UserDefinedCategory = 'Y' )
        UPDATE  GlobalCodeCategories
        SET     UserDefinedCategory = 'N' ,
                ModifiedBy = 'sa' ,
                ModifiedDate = GETDATE()
        WHERE   GlobalCodeCategoryId = @GLobalCodeCategoryId
    END
