/****** Object:  StoredProcedure [dbo].[csp_CustomReportUnitsofServiceManagement]    Script Date: 06/19/2013 17:49:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_CustomReportUnitsofServiceManagement]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_CustomReportUnitsofServiceManagement]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_CustomReportUnitsofServiceManagement]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'



create procedure [dbo].[csp_CustomReportUnitsofServiceManagement] (
     --@ShowDeleted bit = 0,
     @Search varchar(50) = null,
     @Action int = 0,
     @CategoryId int = null,
     @NewCategoryId int = null,
     @NewName varchar(250),
     @ProcedureCodeId int = null,
     @IsBonus int = null,	
	--@CategoryToDelete int = -1,
	--@UnDelete int = NULL,
	--@NewCategory bit = 0,
	--@NewCategoryName varchar(50) = NULL,
	--@AlterCategoryID int = -1,
	--@AlterCategoryName varchar(50) = NULL,
	--@RemoveProcedureCode int = NULL,
	--@UnRemoveProcedureCode int = NULL,
	--@AddProcedureCode int = NULL,
	--@AddProcedureCodeTo int = NULL,
	--@MoveProcedureCode int = NULL,
	--@MoveProcedureCodeTo int = NULL,
     @CurrentUser varchar(50) = null
	)
as /*--------------------------------------------------------------*/
/*	csp_UnitsofServiceManagement								*/
/*	Created By:  JJN											*/
/*																*/
/*	@Action:													*/
/*		0 = ShowReportOnly										*/
/*		1 = Merge Category										*/
/*		2 = Add Category										*/
/*		3 = Modify Category										*/
/*		4 = Remove ProcedureCode								*/
/*		5 = Add Procedurecode									*/
/*		6 = Modify ProcedureCode								*/
/*--------------------------------------------------------------*/


begin tran

declare @message varchar(250) = ''Current values listed.''

if @CurrentUser is null 
    set @CurrentUser = ''UOSMGMT''

set @Search = ''%'' + @Search + ''%''

if @Action = 1 --Merge Category
    begin
        update  CustomUnitsOfServiceProcedureCategories
        set     ProcedureCategory = @NewCategoryId
        where   ProcedureCategory = @CategoryId
	
        update  GlobalCodes
        set     RecordDeleted = ''Y'',
                Deletedby = @CurrentUser,
                DeletedDate = GETDATE()
        where   GlobalCodeId = @CategoryId
	
        set @message = ''Category merged.''
    end

if @Action = 2
    and ISNULL(@NewName, '''') <> ''''--Add Category
    begin
        if exists ( select  *
                    from    dbo.GlobalCodes as gc
                    where   gc.Category = ''XUNITSOFSERVICECAT''
                            and LTRIM(RTRIM(gc.CodeName)) = LTRIM(RTRIM(@NewName))
                            and ISNULL(gc.RecordDeleted, ''N'') <> ''Y'' ) 
            set @message = ''Category with that name ("'' + LTRIM(RTRIM(@NewName))
                + ''") already exists.''
        else 
            insert  into GlobalCodes
                    (CodeName, Category)
            values  (@NewName, ''XUNITSOFSERVICECAT'')
    end

if @Action = 3
    and ISNULL(@NewName, '''') <> ''''--Modify Category
    begin
        update  GlobalCodes
        set     CodeName = @NewName,
                ModifiedBy = @CurrentUser,
                ModifiedDate = GETDATE()
        where   GlobalCodeId = @CategoryId
                and ISNULL(RecordDeleted, ''N'') <> ''Y''
		
        set @message = ''Category modified.''
    end

if @Action = 4 --Remove Procedure Code
    begin
        update  CustomUnitsOfServiceProcedureCategories
        set     RecordDeleted = ''Y'',
                Deletedby = @CurrentUser,
                DeletedDate = GETDATE()
        where   ProcedureCodeId = @ProcedureCodeId

        set @message = ''Procedure code removed.''
    end

if @Action = 5 --Add Procedure Code
    begin
        insert  into CustomUnitsOfServiceProcedureCategories
                (
                 ProcedureCodeId,
                 ProcedureCategory,
                 CategoryOrder,
                 ProcedureSubcategory,
                 IsBonus
                )
                select  @ProcedureCodeId,
                        @NewCategoryId,
                        null,
                        LEFT(ProcedureCodeName, 100),
                        CASE when @IsBonus = 0 then ''N''
                             else ''Y''
                        end
                from    dbo.ProcedureCodes
                where   ProcedureCodeId = @ProcedureCodeId
                        and ISNULL(RecordDeleted, ''N'') <> ''Y''
	
        set @message = ''Procedure code added.''
    end

if @Action = 6 --Modify ProcedureCode
    begin
        update  CustomUnitsOfServiceProcedureCategories
        set     ProcedureCategory = CASE when @NewCategoryId = -1
                                         then ProcedureCategory
                                         else @NewCategoryId
                                    end,
                Modifiedby = @CurrentUser,
                ModifiedDate = GETDATE(),
                IsBonus = CASE when @IsBonus = 0 then ''N''
                               else ''Y''
                          end
        where   ProcedureCodeId = @ProcedureCodeId

        set @message = ''Procedure code modified.''
    end

select  CategoryID = gc.GlobalCodeId,
        CategoryName = gc.CodeName,
        ProcedureCode = pc.DisplayAs,
        IsBonus = ISNULL(cat.IsBonus, ''N''),
        Billable = CASE ISNULL(pc.NotBillable, ''N'')
                     when ''N'' then ''Y''
                     when ''Y'' then ''N''
                     else null
                   end,
        @message as Message
from    CustomUnitsOfServiceProcedureCategories cat
left join GlobalCodes gc on cat.ProcedureCategory = gc.GlobalCodeId
                            and ISNULL(gc.RecordDeleted, ''N'') <> ''Y''
left join ProcedureCodes pc on pc.ProcedureCodeId = cat.ProcedureCodeId
                               and ISNULL(pc.RecordDeleted, ''N'') <> ''Y''
where   gc.Category = ''XUNITSOFSERVICECAT''
        and ISNULL(cat.RecordDeleted, ''N'') <> ''Y''
        and (
             @Search is null
             or gc.CodeName like @Search
             or pc.DisplayAs like @Search
            )
union
select  CategoryID = GlobalCodeId,
        CategoryName = CodeName,
        ProcedureCode = null,
        null,
        null,
        @message as Message
from    GlobalCodes
where   Category = ''XUNITSOFSERVICECAT''
        and GlobalCodeId not in (
        select  ProcedureCategory
        from    CustomUnitsOfServiceProcedureCategories)
        and ISNULL(RecordDeleted, ''N'') <> ''Y''
        and (
             @Search is null
             or CodeName like @Search
            )
order by CategoryName

if @@error = 0 
    commit tran
else 
    rollback



' 
END
GO
