/****** Object:  StoredProcedure [dbo].[csp_AutoCreateDisclosureRecordOffOfServiceNote]    Script Date: 06/19/2013 17:49:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_AutoCreateDisclosureRecordOffOfServiceNote]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_AutoCreateDisclosureRecordOffOfServiceNote]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_AutoCreateDisclosureRecordOffOfServiceNote]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE procedure [dbo].[csp_AutoCreateDisclosureRecordOffOfServiceNote]  
/*******************************************************************************        
**  Change History        
*******************************************************************************        
**  Date:  Author:    Description:        
**  --------  --------    ----------------------------------------------------        
   
*******************************************************************************/      
  
 @DocumentVersionId int
as  

Declare @DisclosureStatus int
Declare @DisclosureType int

set @DisclosureStatus = (Select top 1 GlobalCodeId
						From GlobalCodes gc
						Where Category = ''DISCLOSURESTATUS''
						and CodeName = ''Completed''
						and ISNULL(gc.RecordDeleted, ''N'')= ''N''
						)


set @DisclosureType = (Select top 1 GlobalCodeId
						From GlobalCodes gc
						Where Category = ''DISCLOSURETYPE''
						and CodeName = ''Part Of Intervention''
						and ISNULL(gc.RecordDeleted, ''N'')= ''N''
						)

  
Declare @NewClientDisclosureId int  


Insert Into ClientDisclosures
(ClientId, DisclosureStatus, DisclosureDate, DisclosedBy, DisclosureType, Comments, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
Select 
ClientId, @DisclosureStatus, d.EffectiveDate, d.AuthorId, @DisclosureType, ''A disclosure took place as a part of the interverion for the service specified below.  Please see the associated document for details of the disclosure.'' , s.UserCode, GETDATE(), s.UserCode, GETDATE()
From Documents d
Join Staff s on s.StaffId = d.AuthorId
Where d.CurrentDocumentVersionId = @DocumentVersionId
and ISNULL(d.RecordDeleted, ''N'')= ''N''

--select * from ClientDisclosures
Set @NewClientDisclosureId = @@IDENTITY


Insert Into ClientDisclosedRecords
(ClientDisclosureId, DocumentId, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
Select 
@NewClientDisclosureId, d.DocumentId, s.UserCode, GETDATE(), s.UserCode, GETDATE()
From Documents d
Join Staff s on s.StaffId = d.AuthorId
Where d.CurrentDocumentVersionId = @DocumentVersionId
and ISNULL(d.RecordDeleted, ''N'')= ''N''
' 
END
GO
