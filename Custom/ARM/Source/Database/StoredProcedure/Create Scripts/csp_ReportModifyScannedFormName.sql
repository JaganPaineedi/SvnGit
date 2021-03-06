/****** Object:  StoredProcedure [dbo].[csp_ReportModifyScannedFormName]    Script Date: 06/19/2013 17:49:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportModifyScannedFormName]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportModifyScannedFormName]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportModifyScannedFormName]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'


CREATE procedure [dbo].[csp_ReportModifyScannedFormName]

@OriginalDocumentCodeId int, @ScannedFormName varchar(100), @ScannedFormNameConfirm varchar(100)--, @Status char(1)


as 

/*
Declare @ScannedFormName varchar(100)
set @ScannedFormName = ''ateaeradf''

exec csp_ReportCreateScannedFormName @ScannedFormName, null

*/

declare @Message varchar(max)





if ISNULL(@ScannedFormName,'''') <> '''' 
and ISNULL(@ScannedFormNameConfirm,'''') <> '''' 
and @ScannedFormNameConfirm = @ScannedFormName
and not  exists ( select * from DocumentCodes dc where DocumentType = 17 and DocumentName = @ScannedFormName )  

begin 
	begin tran

	declare @DocumentCodeId int
	declare @ScreenId int


	Update DocumentCodes 
	Set DocumentName = @ScannedFormName,
	ModifiedBy = ''ScanReport'',
	ModifiedDate = GETDATE()
	Where DocumentCodeId = @OriginalDocumentCodeId
	 and ISNULL(RecordDeleted, ''N'')= ''N''

	--Insert into DocumentCodes
	--(DocumentName, DocumentDescription, DocumentType, Active, ServiceNote, OnlyAvailableOnline, ViewDocumentURL, ViewDocumentRDL,
	-- RequiresSignature)
	 
	-- Values
	-- (@ScannedFormName, @ScannedFormName, 17, ''Y'', ''N'', ''N'', ''RDLScannedForms'', ''RDLScannedForms'', ''N'')
	 
	-- Set @DocumentCodeId = @@IDENTITY
	 
	 if @@ERROR <> 0 goto Error
	 
	 
	 Update Screens
	 set ScreenName = @ScannedFormName,
	ModifiedBy = ''ScanReport'',
	ModifiedDate = GETDATE()
	 Where DocumentCodeId = @OriginalDocumentCodeId
	 and ISNULL(RecordDeleted, ''N'')= ''N''
	 --Insert into Screens @ScannedFormName
	 --(ScreenName, ScreenType, ScreenURL, TabId, DocumentCodeId)
	 --values
	 --(@ScannedFormName, 5763, ''/ActivityPages/Client/Detail/Documents/ScannedMedicalRecord.ascx'', 2, @DocumentCodeId)
	 
	 --Set @ScreenId = @@IDENTITY
	 
	 if @@ERROR <> 0 goto Error

	Update dn
	Set dn.NavigationName = @ScannedFormName,
	dn.DisplayAs = @ScannedFormName,
	dn.ModifiedBy = ''ScanReport'',
	dn.ModifiedDate = GETDATE()
	From DocumentNavigations dn
	Join Screens s on s.ScreenId = dn.ScreenId
	where s.DocumentCodeId = @OriginalDocumentCodeId
	and ISNULL(s.RecordDeleted, ''N'')= ''N''
	and ISNULL(dn.RecordDeleted, ''N'')= ''N''
	 --insert into DocumentNavigations
	 --(NavigationName, DisplayAs, Active, ParentDocumentNavigationId, ScreenId)
	 --values
	 --(@ScannedFormName, @ScannedFormName, ''Y'', 56, @ScreenId)
	 
	 if @@ERROR <> 0 goto Error
	 
	 --Set permissions
	 --insert into PermissionTemplateItems
	 --(PermissionTemplateId, PermissionItemId)

	 
	 --select PermissionTemplateId, @DocumentCodeId from 
	 --dbo.PermissionTemplates t
	 --join GlobalCodes gc on gc.GlobalCodeId = t.PermissionTemplateType
	 --where GlobalCodeId = 5702 --Document Codes
	 
	 --if @@ERROR <> 0 goto Error
	 
	set @Message = @ScannedFormName + '' has been updated''
	commit tran
	
	select @Message as Message, @ScannedFormName as ScannedFormName
end


else if ISNULL(@ScannedFormName,'''')  = '''' 
begin
	select ''New form name has not been specified.  No form has been created'' as Message, ''NONE SPECIFIED!'' as ScannedFormName
end
else if exists ( select * from DocumentCodes dc where DocumentType = 17 and DocumentName = @ScannedFormName )  
begin
	select ''A new form name has not been created because an existing document with specified name is already a scanned form name.  No form has been created'' as Message, @ScannedFormName as ScannedFormName
end
else if ( ISNULL(@ScannedFormName,'''') <> ''''  
and isnull(@ScannedFormNameConfirm,'''') <> @ScannedFormName )
begin
	select ''Scanned form name and scanned form name confirmation do not match.  Please review the scanned form names'' as Message, @ScannedFormName as ScannedFormName
end



return 


error: Rollback tran 
set @Message = ''Error: '' + @ScannedFormName + '' has not been modified''
select @Message as Message, @ScannedFormName as ScannedFormName
return


' 
END
GO
