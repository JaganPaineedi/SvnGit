/****** Object:  StoredProcedure [dbo].[csp_validateCustomServicesTab]    Script Date: 06/19/2013 17:49:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateCustomServicesTab]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_validateCustomServicesTab]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateCustomServicesTab]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE      PROCEDURE [dbo].[csp_validateCustomServicesTab]  
@DocumentVersionId INT  
as  
  
--Optimized by removing multiple references to the Documents table - DJH - 10/28/2010
DECLARE @DocumentCodeId INT, @ServiceId int
SELECT @DocumentCodeId = DocumentCodeId 
	, @ServiceId = ServiceId
	From Documents Where CurrentDocumentVersionId = @DocumentVersionId  
--DECLARE @DocumentCodeId INT  
--SET @DocumentCodeId = (Select DocumentCodeId From Documents Where CurrentDocumentVersionId = @DocumentVersionId)  
  
  
/* SUMMIT ONLY
--  
--OP Mini Team Custom Field  
--  
If exists (Select 1 From Services s
   Join CustomMiniTeamValidatePrograms vp on vp.ProgramId = s.ProgramId 
   Where s.ServiceId = @ServiceId   
   and isnull(s.RecordDeleted, ''N'')= ''N''  
   )  
and not exists (Select 1 From CustomFieldsData cfd
    Where cfd.PrimaryKey1 = @ServiceId
    and cfd.ColumnGlobalCode2 is not null  
    and isnull(cfd.RecordDeleted, ''N'')= ''N''     
    ) 
/*
If exists (Select d.DocumentId from Documents d  
   Join Services s on s.ServiceId = d.ServiceId  
   Join CustomMiniTeamValidatePrograms vp on vp.ProgramId = s.ProgramId  
   Where d.CurrentDocumentVersionId = @DocumentVersionId  
   and isnull(d.RecordDeleted, ''N'')= ''N''  
   and isnull(s.RecordDeleted, ''N'')= ''N''  
   )  
and not exists (Select d.DocumentId from Documents d  
    Join Services s on s.ServiceId = d.ServiceId  
    Join CustomFieldsData cfd on cfd.PrimaryKey1 = s.ServiceId and cfd.DocumentType = 4943  
    Where d.CurrentDocumentVersionId = @DocumentVersionId  
    and cfd.ColumnGlobalCode2 is not null  
    and isnull(cfd.RecordDeleted, ''N'')= ''N''     
    and isnull(d.RecordDeleted, ''N'')= ''N''  
    and isnull(s.RecordDeleted, ''N'')= ''N''  
    )  
*/

Insert into #validationReturnTable  
(TableName,  
ColumnName,  
ErrorMessage  
)  
Select ''CustomHRMServiceNotes'', ''DeletedBy'', ''Service - Outpatient Mini Team must be specified.''  
  
 
--  
--DBT Group Assistant  
--  
If @DocumentCodeId = 111  
and not exists (Select 1 From CustomFieldsData cfd
    Where cfd.PrimaryKey1 = @ServiceId  
    and cfd.ColumnGlobalCode3 is not null  
    and isnull(cfd.RecordDeleted, ''N'')= ''N''        
    ) 
/*
If @DocumentCodeId = 111  
and not exists (Select d.DocumentId from Documents d  
    Join Services s on s.ServiceId = d.ServiceId  
    Join CustomFieldsData cfd on cfd.PrimaryKey1 = s.ServiceId and cfd.DocumentType = 4943  
    Where d.CurrentDocumentVersionId = @DocumentVersionId  
    and cfd.ColumnGlobalCode3 is not null  
    and isnull(cfd.RecordDeleted, ''N'')= ''N''     
    and isnull(d.RecordDeleted, ''N'')= ''N''  
    and isnull(s.RecordDeleted, ''N'')= ''N''  
    )  
 */
Insert into #validationReturnTable  
(TableName,  
ColumnName,  
ErrorMessage  
)  
Select ''CustomHRMServiceNotes'', ''DeletedBy'', ''Service - DBT Group Assistant must be specified.''  
*/
  
  
return  
  
error:  
raiserror 50000 ''csp_validateCustomServicesTab failed.  Please contact your system administrator. We apologize for the inconvenience.''
' 
END
GO
