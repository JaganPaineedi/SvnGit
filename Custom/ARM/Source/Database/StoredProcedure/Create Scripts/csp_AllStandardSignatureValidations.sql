/****** Object:  StoredProcedure [dbo].[csp_AllStandardSignatureValidations]    Script Date: 06/19/2013 17:49:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_AllStandardSignatureValidations]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_AllStandardSignatureValidations]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_AllStandardSignatureValidations]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
 CREATE PROCEDURE [dbo].[csp_AllStandardSignatureValidations]
@DocumentVersionId	INT,
@ServiceId	INT
AS

--
-- Do not allow signature if locationId has not been set.
--
If exists (Select * From Services s
			JOIN documents d ON s.Serviceid = d.ServiceId
				Where d.CurrentDocumentVersionId = @DocumentVersionId
				AND s.LocationId is NULL
				and isnull(d.RecordDeleted, ''N'') = ''N''
				and isnull(s.RecordDeleted, ''N'') = ''N''
			) 
	BEGIN  
	--	Insert into CustomBugTracking
	--	(DocumentVersionId, ServiceId, Description, CreatedDate)
	--	Values
	--	(@DocumentVersionId, @ServiceId, ''Service missing location.'', GETDATE())

		Insert into #validationReturnTable
		(TableName,
		ColumnName,
		ErrorMessage
		)
		Select ''AllServices'', ''DeletedBy'', ''Service - Location must be specified.''  
	END


 
 

' 
END
GO
