/****** Object:  StoredProcedure [dbo].[csp_RDLAdmissionRecordSubreportRelations]    Script Date: 06/19/2013 17:49:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLAdmissionRecordSubreportRelations]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLAdmissionRecordSubreportRelations]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLAdmissionRecordSubreportRelations]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'--csp_RDLAdmissionRecord 112896
create procedure [dbo].[csp_RDLAdmissionRecordSubreportRelations]
	@ClientId int
as

select gc.CodeName as Relation, cc.LastName + '', '' + cc.FirstName as RelationName, cc.DOB
from dbo.ClientContacts as cc
LEFT join dbo.GlobalCodes as gc on gc.GlobalCodeId = cc.Relationship
where cc.ClientId = @ClientId
and ISNULL(cc.RecordDeleted, ''N'') <> ''Y''
order by gc.CodeName, cc.LastName, cc.FirstName, cc.DOB

' 
END
GO
