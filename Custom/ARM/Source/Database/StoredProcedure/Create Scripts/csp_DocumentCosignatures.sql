/****** Object:  StoredProcedure [dbo].[csp_DocumentCosignatures]    Script Date: 06/19/2013 17:49:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_DocumentCosignatures]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_DocumentCosignatures]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_DocumentCosignatures]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE       PROCEDURE  [dbo].[csp_DocumentCosignatures]         
(         
 @CurrentUserId int,           
 @DocumentVersionId int        
)          
          
As          
                                 
/*********************************************************************/                    
/* Stored Procedure: csp_DocumentCosignatures               */           
          
/* Copyright: 2006 Streamlin Healthcare Solutions           */                    
          
/* Creation Date:  4/11/2006                                    */                    
/*                                                                   */                    
/* Purpose: Create Co signature*/                   
/*                                                                   */                  
/* Input Parameters: None*/                  
/*                                                                   */                     
/* Output Parameters:                                */                    
/*                                                                   */                    
/* Return:   */                    
/*                                                                   */                    
/* Called By:          */                    
          
/*                                                                   */                    
/* Calls:                                                            */                    
/*                                                                   */                    
/* Data Modifications:                                               */                    
/*                                                                   */                    
/*   Updates:                                                          */                    
          
/*       Date              Author                  Purpose                                    */                    
/*  1/28/2007 		SFERENZ		              Created         
	08.08.2012			avoss					remove non harbor cusotmizations
*/                    
/*********************************************************************/                     
                
   
--Cosignature Rule

	Declare @StaffId int,
		@DocumentId int,
		@DocumentCodeId int,
		@Degree int,
		@ClientId int,
		@Cosigner int,
		@SignatureOrder int,
		@ProcedureCodeId int
		
	SELECT @Staffid = s.StaffId,
		@DocumentId = d.DocumentId,
		@DocumentCodeId = d.DocumentCodeId,
		@Degree = s.Degree,
		@ClientId = d.ClientId,
--		@ProcedureCodeId = ser.ProcedureCodeId,
		@Cosigner = s.CoSignerId
	FROM Documents d
	JOIN Staff s on s.StaffId = D.AuthorId
	Join documentcodes dc on dc.documentcodeid = d.documentcodeid
	JOIN Clients c on c.clientid = d.clientid
	left JOIN Services ser on ser.ServiceId = d.ServiceId AND isnull(ser.RecordDeleted, ''N'') = ''N''
	WHERE d.CurrentDocumentVersionId = @DocumentVersionId
	AND (
		(isnull(dc.servicenote, ''N'') = ''Y'' and ser.Billable = ''Y'' and ser.status in (71, 75) and ser.ServiceId is not null)
			OR
		(isnull(dc.servicenote, ''N'') = ''N'')
		--	OR
		--(isnull(dc.servicenote, ''N'') = ''Y'' and @StaffId in ( 738, 683 ) and ser.status in (71, 75) and ser.ServiceId is not null)
		)
	AND s.CosignerId is not null
	AND isnull(d.RecordDeleted, ''N'') = ''N''
	AND isnull(s.RecordDeleted, ''N'') = ''N''
	AND isnull(c.RecordDeleted, ''N'') = ''N''
	AND isnull(dc.RecordDeleted, ''N'') = ''N''
--	
--select * from staff s where staffid in ( 738,683)



	IF @@error <> 0 GOTO error




IF @Cosigner IS NOT NULL AND NOT EXISTS (SELECT StaffId
			FROM DocumentSignatures ds
			WHERE ds.StaffId = @Cosigner
			AND ds.SignedDocumentVersionId = @DocumentVersionId
			AND isnull(ds.RecordDeleted, ''N'') = ''N'')
BEGIN

	--Set Signature Order
	SELECT @SignatureOrder = isnull(MAX(SignatureOrder), 0) + 1
	FROM DocumentSignatures ds
	WHERE ds.SignedDocumentVersionId = @DocumentVersionId
	AND isnull(ds.RecordDeleted, ''N'') <> ''Y''


	--Insert Into Document Signatures Table
	INSERT INTO DocumentSignatures
	(DocumentId, SignedDocumentVersionId, StaffId, SignatureOrder)
	VALUES (@DocumentId, @DocumentVersionId, @Cosigner, @SignatureOrder)

	    
END          


	IF @@error <> 0 GOTO error

Return

Error:
RAISERROR  20006   ''scsp_SCDocumentPostSignatureUpdates: An Error Occured''           
  
Return
' 
END
GO
