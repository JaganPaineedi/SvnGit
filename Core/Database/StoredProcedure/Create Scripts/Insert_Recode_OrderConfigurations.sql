DECLARE @RecodeCategoryId INT;
DECLARE @PriorityId INT;
DECLARE @ScheduleId INT;
DECLARE @OrderTemplateFrequencyId INT;

IF NOT EXISTS ( SELECT  *
                FROM    RecodeCategories
                WHERE   CategoryCode = 'ORDERPRIORITIES' )
    BEGIN
        INSERT  INTO [dbo].[RecodeCategories]
                ( [CategoryCode] ,
                  [CategoryName] ,
                  [Description] ,
                  [MappingEntity]
		        )
        VALUES  ( 'ORDERPRIORITIES' ,
                  'Order Priorities' ,
                  'This category is used within Order setup for the weekly Order Update from LabSoft' ,
                  'GlobalCodes'
		        );
    END;
ELSE
    BEGIN
        SELECT  @RecodeCategoryId = RecodeCategoryId
        FROM    RecodeCategories
        WHERE   CategoryCode = 'ORDERPRIORITIES';

        UPDATE  [dbo].[RecodeCategories]
        SET     [CategoryCode] = 'ORDERPRIORITIES' ,
                [CategoryName] = 'Order Priorities' ,
                [Description] = 'This category is used within Order setup for the weekly Order Refresh from LabSoft' ,
                [MappingEntity] = 'GlobalCodes'
        WHERE   RecodeCategoryId = @RecodeCategoryId;
    END;

SELECT  @RecodeCategoryId = RecodeCategoryId
FROM    RecodeCategories
WHERE   CategoryCode = 'ORDERPRIORITIES';

SET @PriorityId = 8548;

IF NOT EXISTS ( SELECT  1
                FROM    dbo.Recodes
                WHERE   RecodeCategoryId = @RecodeCategoryId
                        AND IntegerCodeId = @PriorityId )
    BEGIN
        INSERT  INTO dbo.Recodes
                ( IntegerCodeId ,
                  FromDate ,
                  ToDate ,
                  RecodeCategoryId
		        )
        VALUES  ( @PriorityId ,
                  GETDATE() ,
                  NULL ,
                  @RecodeCategoryId
		        );
    END;

SET @PriorityId = 8510;

IF NOT EXISTS ( SELECT  1
                FROM    dbo.Recodes
                WHERE   RecodeCategoryId = @RecodeCategoryId
                        AND IntegerCodeId = @PriorityId )
    BEGIN
        INSERT  INTO dbo.Recodes
                ( IntegerCodeId ,
                  FromDate ,
                  ToDate ,
                  RecodeCategoryId
		        )
        VALUES  ( @PriorityId ,
                  GETDATE() ,
                  NULL ,
                  @RecodeCategoryId
		        );
    END;

IF NOT EXISTS ( SELECT  1
                FROM    RecodeCategories
                WHERE   CategoryCode = 'ORDERSCHEDULES' )
    BEGIN
        INSERT  INTO [dbo].[RecodeCategories]
                ( [CategoryCode] ,
                  [CategoryName] ,
                  [Description] ,
                  [MappingEntity]
		        )
        VALUES  ( 'ORDERSCHEDULES' ,
                  'OrderSchedules' ,
                  'This category is used within Order setup for the weekly Order Update from LabSoft' ,
                  'GlobalCodes'
		        );
    END;
ELSE
    BEGIN
        SELECT  @RecodeCategoryId = RecodeCategoryId
        FROM    RecodeCategories
        WHERE   CategoryCode = 'ORDERSCHEDULES';

        UPDATE  [dbo].[RecodeCategories]
        SET     [CategoryCode] = 'ORDERSCHEDULES' ,
                [CategoryName] = 'Order Schedules' ,
                [Description] = 'This category is used within Order setup for the weekly Order Refresh from LabSoft' ,
                [MappingEntity] = 'GlobalCodes'
        WHERE   RecodeCategoryId = @RecodeCategoryId;
    END;

SELECT  @RecodeCategoryId = RecodeCategoryId
FROM    RecodeCategories
WHERE   CategoryCode = 'ORDERSCHEDULES';

SET @ScheduleId = 8512;

IF NOT EXISTS ( SELECT  1
                FROM    dbo.Recodes
                WHERE   RecodeCategoryId = @RecodeCategoryId
                        AND IntegerCodeId = @ScheduleId )
    BEGIN
        INSERT  INTO dbo.Recodes
                ( IntegerCodeId ,
                  FromDate ,
                  ToDate ,
                  RecodeCategoryId
		        )
        VALUES  ( @ScheduleId ,
                  GETDATE() ,
                  NULL ,
                  @RecodeCategoryId
		        );
    END;

SET @ScheduleId = 8522;

IF NOT EXISTS ( SELECT  1
                FROM    dbo.Recodes
                WHERE   RecodeCategoryId = @RecodeCategoryId
                        AND IntegerCodeId = @ScheduleId )
    BEGIN
        INSERT  INTO dbo.Recodes
                ( IntegerCodeId ,
                  FromDate ,
                  ToDate ,
                  RecodeCategoryId
		        )
        VALUES  ( @ScheduleId ,
                  GETDATE() ,
                  NULL ,
                  @RecodeCategoryId
		        );
    END;

IF NOT EXISTS ( SELECT  1
                FROM    RecodeCategories
                WHERE   CategoryCode = 'ORDERFREQUENCIES' )
    BEGIN
        INSERT  INTO [dbo].[RecodeCategories]
                ( [CategoryCode] ,
                  [CategoryName] ,
                  [Description] ,
                  [MappingEntity]
		        )
        VALUES  ( 'ORDERFREQUENCIES' ,
                  'Order Frequencies' ,
                  'This category is used within Order setup for the weekly Order Update from LabSoft' ,
                  'OrderTemplateFrequencies'
		        );
    END;
ELSE
    BEGIN
        SELECT  @RecodeCategoryId = RecodeCategoryId
        FROM    RecodeCategories
        WHERE   CategoryCode = 'ORDERFREQUENCIES';

        UPDATE  [dbo].[RecodeCategories]
        SET     [CategoryCode] = 'ORDERFREQUENCIES' ,
                [CategoryName] = 'Order Frequencies' ,
                [Description] = 'This category is used within Order setup for the weekly Order Update from LabSoft' ,
                [MappingEntity] = 'OrderTemplateFrequencies'
        WHERE   RecodeCategoryId = @RecodeCategoryId;
    END;

SELECT  @RecodeCategoryId = RecodeCategoryId
FROM    RecodeCategories
WHERE   CategoryCode = 'ORDERFREQUENCIES';

SET @OrderTemplateFrequencyId = 9;

IF NOT EXISTS ( SELECT  1
                FROM    dbo.Recodes
                WHERE   RecodeCategoryId = @RecodeCategoryId
                        AND IntegerCodeId = @OrderTemplateFrequencyId )
    BEGIN
        INSERT  INTO dbo.Recodes
                ( IntegerCodeId ,
                  FromDate ,
                  ToDate ,
                  RecodeCategoryId
		        )
        VALUES  ( @OrderTemplateFrequencyId ,
                  GETDATE() ,
                  NULL ,
                  @RecodeCategoryId
		        );
    END;


SET @OrderTemplateFrequencyId = 10;

IF NOT EXISTS ( SELECT  1
                FROM    dbo.Recodes
                WHERE   RecodeCategoryId = @RecodeCategoryId
                        AND IntegerCodeId = @OrderTemplateFrequencyId )
    BEGIN
        INSERT  INTO dbo.Recodes
                ( IntegerCodeId ,
                  FromDate ,
                  ToDate ,
                  RecodeCategoryId
		        )
        VALUES  ( @OrderTemplateFrequencyId ,
                  GETDATE() ,
                  NULL ,
                  @RecodeCategoryId
		        );
    END;

