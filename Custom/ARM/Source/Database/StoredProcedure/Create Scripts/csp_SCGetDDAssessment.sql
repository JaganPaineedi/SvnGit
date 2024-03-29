/****** Object:  StoredProcedure [dbo].[csp_SCGetDDAssessment]    Script Date: 06/19/2013 17:49:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetDDAssessment]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCGetDDAssessment]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetDDAssessment]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*********************************************************************/              
/* Stored Procedure: dbo.csp_SCGetDDAssessment                */     
/* Copyright: 2006 Streamline SmartCare*/              
/* Creation Date:  31/10/2006                                    */              
/* Purpose: Gets Data for DDAssessment*/             
/* Input Parameters: DocumentID,Version */            
/* Output Parameters:                                */              
/* Return:   */              
/* Called By: FillDocumentsWithStoredProcedure(int _DocumentCodeId,int _ClientId,int _DocumentId,int _AuthorId) Method in documents Class Of DataService  in "Always Online Application"  */    
/* Calls:                                                            */              
/* Data Modifications:                                               */              
/*   Updates:                                                          */              
/*    Date              Author                  Purpose                                    */              
/*  30/10/2006            Piyush Gajrani           Created              */              
/*  03/09/2009            Vikas Monga              Updated(Update as per the new data model document version id )              */              
/*  28/09/2009            Vikas Monga              Updated(Comment systemconfiguration table selection )              */              
/* 03/04/2010 Vikas Monga             */  
/* -- Remove [Documents] and [DocumentVersions]        */                        
/*********************************************************************/               

CREATE PROCEDURE  [dbo].[csp_SCGetDDAssessment]    
	@DocumentVersionId INT  
AS    
BEGIN            
	SELECT     DocumentVersionId, CommunicationStyle, SupportNature, SupportStatus, LevelVision, LevelHearing, LevelOther, LevelBehavior, AssistanceMobility, 
						  AssistanceMedication, AssistancePersonal, AssistanceHousehold, AssistanceCommunity, HealthHistory, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, 
						  RecordDeleted, DeletedDate, DeletedBy
	FROM         CustomDDAssessment
	WHERE     (ISNULL(RecordDeleted, ''N'') = ''N'') AND (DocumentVersionId = @DocumentVersionId)    
  
  --Checking For Errors    
	If (@@error!=0)    
	BEGIN    
		RAISERROR  20006   ''csp_SCGetDDAssessment: An Error Occured''     
		Return    
	END            
END
' 
END
GO
