/****** Object:  StoredProcedure [dbo].[csp_ReportModifyScannedFormStatus]    Script Date: 06/19/2013 17:49:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportModifyScannedFormStatus]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportModifyScannedFormStatus]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportModifyScannedFormStatus]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'


CREATE procedure [dbo].[csp_ReportModifyScannedFormStatus]

@OriginalDocumentCodeId int, @Status char(1)


as 

/*
Declare @ScannedFormName varchar(100)
set @ScannedFormName = ''ateaeradf''

exec csp_ReportCreateScannedFormName @ScannedFormName, null

*/

declare @Message varchar(max)






begin 
	begin tran

	declare @DocumentCodeId int
	declare @ScreenId int


	Update DocumentCodes 
	Set Active = @Status,
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
	 
	 
	 
	 if @@ERROR <> 0 goto Error

	 
		 
	set @Message = ''Status has been updated''
	commit tran
	
	select @Message as Message, @Status as ScannedFormName
end


--else if ISNULL(@ScannedFormName,'''')  = '''' 
--begin
--	select ''New form name has not been specified.  No form has been created'' as Message, ''NONE SPECIFIED!'' as ScannedFormName
--end
--else if exists ( select * from DocumentCodes dc where DocumentType = 17 and DocumentName = @ScannedFormName )  
--begin
--	select ''A new form name has not been created because an existing document with specified name is already a scanned form name.  No form has been created'' as Message, @ScannedFormName as ScannedFormName
--end
--else if ( ISNULL(@ScannedFormName,'''') <> ''''  
--and isnull(@ScannedFormNameConfirm,'''') <> @ScannedFormName )
--begin
--	select ''Scanned form name and scanned form name confirmation do not match.  Please review the scanned form names'' as Message, @ScannedFormName as ScannedFormName
--end



return 


error: Rollback tran 
set @Message = ''Error: '' + @Status + '' has not been modified''
select @Message as Message, @Status as ScannedFormName
return


' 
END
GO
