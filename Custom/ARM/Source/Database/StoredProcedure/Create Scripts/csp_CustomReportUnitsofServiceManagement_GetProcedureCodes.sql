/****** Object:  StoredProcedure [dbo].[csp_CustomReportUnitsofServiceManagement_GetProcedureCodes]    Script Date: 06/19/2013 17:49:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_CustomReportUnitsofServiceManagement_GetProcedureCodes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_CustomReportUnitsofServiceManagement_GetProcedureCodes]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_CustomReportUnitsofServiceManagement_GetProcedureCodes]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'


create procedure [dbo].[csp_CustomReportUnitsofServiceManagement_GetProcedureCodes]
--
-- used by the custom units of service management report to list the procedure codes applicable to a given action type.
--
-- Change log:
--		2013.03.18 - T. Remisoski - added some comments.  corrected/improved logic for both main selection blocks.
	@Action int
as 
begin tran

if @Action in (4, 6) 
	-- for Remove or Modify Procedure, list all procedures that have already been assigned to a category
    select  ID = pc.ProcedureCodeId,
            CodeName = gc.CodeName + '' - '' + pc.DisplayAs
    from    CustomUnitsOfServiceProcedureCategories cat
    join    ProcedureCodes pc on pc.ProcedureCodeId = cat.ProcedureCodeId
                                 and ISNULL(pc.RecordDeleted, ''N'') <> ''Y''
    join    GlobalCodes gc on gc.GlobalCodeId = cat.ProcedureCategory
                              and ISNULL(gc.RecordDeleted, ''N'') <> ''Y''
    where   ISNULL(cat.RecordDeleted, ''N'') <> ''Y''
    union
    select  -1,
            '' None''
    order by CodeName

else 
	-- for list (default action) and Add Procedure, list all procedure codes not already assigned to a category
    if @Action in (0, 5) 
        select  ID = pc.ProcedureCodeId,
                CodeName = pc.DisplayAs
        from    ProcedureCodes pc
        where   ISNULL(pc.RecordDeleted, ''N'') <> ''Y''
                and not exists (
                select  *
                from    CustomUnitsOfServiceProcedureCategories as c
                join dbo.GlobalCodes as gc on gc.GlobalCodeId = c.ProcedureCategory
                where c.ProcedureCodeId = pc.ProcedureCodeId
                and ISNULL(c.RecordDeleted, ''N'') <> ''Y''
                and ISNULL(gc.RecordDeleted, ''N'') <> ''Y''
                )
        union all
        select  ID = -1,
                CodeName = ''''
        order by CodeName

    else 
        select  ID = -1,
                CodeName = ''N/A''

if @@error = 0 
    commit tran
else 
    rollback

' 
END
GO
