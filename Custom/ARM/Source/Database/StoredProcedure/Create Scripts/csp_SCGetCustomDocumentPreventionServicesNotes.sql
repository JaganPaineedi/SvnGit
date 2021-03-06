/****** Object:  StoredProcedure [dbo].[csp_SCGetCustomDocumentPreventionServicesNotes]    Script Date: 06/19/2013 17:49:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetCustomDocumentPreventionServicesNotes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCGetCustomDocumentPreventionServicesNotes]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetCustomDocumentPreventionServicesNotes]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*********************************************************************/                    
/* Stored Procedure: dbo.csp_SCGetCustomDocumentPreventionServicesNotes                */           
/* Copyright: 2011 Streamline SmartCare*/                    
/* Creation Date:  29/04/2011                                    */                    
/* Purpose: Gets Data for CustomDocumentPreventionServicesNotes*/                   
/* Input Parameters: DocumentVersionID */                  
/* Output Parameters:                                */                    
/* Return:   */                    
/* Called By: FillDocumentsWithStoredProcedure(int _DocumentCodeId,int _ClientId,int _DocumentId,int _AuthorId) Method in documents Class Of DataService  in "Always Online Application"  */          
/* Calls:                                                            */                    
/* Data Modifications:                                               */                    
/*   Updates:                                                          */                    
/*    Date              Author                  Purpose                                    */                    
/*  29/04/2011          Pradeep                 Created              */                    
/*********************************************************************/                     
      
CREATE PROCEDURE  [dbo].[csp_SCGetCustomDocumentPreventionServicesNotes]
@DocumentVersionId INT        
AS          
BEGIN                  
 SELECT     [DocumentVersionId],
			[CreatedBy],
			[CreatedDate], 
			[ModifiedBy], 
			[ModifiedDate],
			[RecordDeleted],
			[DeletedBy],
			[DeletedDate],
			[NumberOfParticipants],
			[DescriptionOfPreventionActivity]
			FROM [CustomDocumentPreventionServicesNotes]
 WHERE     (isnull(RecordDeleted,''N'')=''N'') AND (DocumentVersionId = @DocumentVersionId)          
        
  --Checking For Errors          
 If (@@error!=0)          
 BEGIN          
  RAISERROR  20006   ''csp_SCGetCustomDocumentPreventionServicesNotes: An Error Occured''           
  Return          
 END                  
END ' 
END
GO
