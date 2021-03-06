/****** Object:  StoredProcedure [dbo].[csp_DFADeleteFormsRecords]    Script Date: 06/19/2013 17:49:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_DFADeleteFormsRecords]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_DFADeleteFormsRecords]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_DFADeleteFormsRecords]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE procedure [dbo].[csp_DFADeleteFormsRecords]
	@FormId int,
	@deleteFormsRecord CHAR(1) = ''N''
as
/**********************************************************************/                                                                                        
 /* Stored Procedure: csp_DFACreateFormItem						      */                                                                               
 /* Creation Date:  28/May/2012				                          */                                                                                        
 /* Purpose: Delete records related to a Form.  The forms record is   */
 /*          is left in place unless @deleteFormsRecord is set to ''Y'' */
 /* Input Parameters:												  */                                                                                      
	--@FormId	int
	--@deleteFormsRecord char(1) default is ''N''
 /* Output Parameters:												  */                                                                                        
 /* Return:															  */                                                                                        
 /* Called By:Report For Release of information					      */                                                                              
 /* Calls:                                                            */                                                                                        
 /*                                                                   */                                                                                        
 /* Data Modifications:                                               */                                                                                        
 /* Updates:                                                          */                                                                                        
 /* Date              Author                  Purpose				  */       
  /* 28/May/2012       T.Remisoski	          Created	   		      */   
/*********************************************************************/    
begin try

begin tran

if not exists (select * from dbo.Forms where FormId = @FormId)
	raiserror(''FormId passed in parameter does not exist.'', 16, 1)
	
delete from fi
from dbo.FormItems as fi
join dbo.FormSectionGroups as fsg on fsg.FormSectionGroupId = fi.FormSectionGroupId
join dbo.FormSections as fs on fs.FormSectionId = fsg.FormSectionId
where fs.FormId = @FormId

delete from fi
from dbo.FormItems as fi
join dbo.FormSections as fs on fs.FormSectionId = fi.FormSectionId
where fs.FormId = @FormId

delete from fsg
from dbo.FormSectionGroups as fsg
join dbo.FormSections as fs on fs.FormSectionId = fsg.FormSectionId
where fs.FormId = @FormId

delete from fs
from dbo.FormSections as fs
where fs.FormId = @FormId

if @deleteFormsRecord = ''Y''
begin

	delete from dbo.FormCollectionForms where FormId = @FormId
	
	update dbo.DocumentCodes set MetadataFormId = null where MetadataFormId = @FormId
	update dbo.DocumentCodes set ReviewFormId = null where ReviewFormId = @FormId
	
	delete from dbo.Forms where FormId = @FormId
	
end


commit tran

end try
begin catch
if @@TRANCOUNT > 0 rollback tran
declare @error_message nvarchar(4000)
set @error_message = ERROR_MESSAGE()
raiserror (@error_message, 16, 1)
end catch
' 
END
GO
