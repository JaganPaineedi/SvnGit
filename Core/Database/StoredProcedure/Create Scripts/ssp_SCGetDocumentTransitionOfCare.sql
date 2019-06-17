
/****** Object:  StoredProcedure [dbo].[ssp_SCGetDocumentTransitionOfCare]    Script Date: 06/09/2015 05:25:18 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetDocumentTransitionOfCare]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetDocumentTransitionOfCare]
GO


/****** Object:  StoredProcedure [dbo].[ssp_SCGetDocumentTransitionOfCare]    Script Date: 06/09/2015 05:25:18 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


Create PROCEDURE  [dbo].[ssp_SCGetDocumentTransitionOfCare]                      
(                            
 @DocumentVersionId  int                            
)                            
As       
begin 
/**************************************************************
Created By   : Sudhir Singh
Created Date : 29th-NOV-2011
Description  : Used to Get Data for DFA Parentings page
Called From  : DFA Screen 'Parentings'

 Updates:																  
 Date				Author				Purpose							
 14-Aug-17			Alok Kumar			Added 4 more columns(i.e. FromDate,ToDate,TransitionType,ConfidentialityCode).	Ref#25.1 Meaningful Use - Stage 3
 
**************************************************************/            
BEGIN TRY                    
Select 		
		CPD.[DocumentVersionId]
		,CPD.[CreatedBy]
		,CPD.[CreatedDate]
		,CPD.[ModifiedBy]
		,CPD.[ModifiedDate]
		,CPD.[RecordDeleted]
		,CPD.[DeletedDate]
		,CPD.[DeletedBy]
		,CPD.[ProviderId]
		,CPD.[ExportedDate]
		,CPD.[FromDate]			--14-Aug-17			Alok Kumar
		,CPD.[ToDate]
		,CPD.[TransitionType]
		,CPD.[ConfidentialityCode]
		,CPD.LocationId 
		
  FROM TransitionOfCareDocuments CPD     
  WHERE Isnull(RecordDeleted,'N') <> 'Y' AND [DocumentVersionId]=@DocumentVersionId    
  END TRY                                                                      
BEGIN CATCH                          
DECLARE @Error varchar(8000)                                                                       
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                 
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_SCGetDocumentTransitionOfCare')                                                                                                     
    + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                                                      
    + '*****' + Convert(varchar,ERROR_STATE())                                                  
 RAISERROR                                                                                                     
 (                                                                       
  @Error, -- Message text.                                                                                                    
  16, -- Severity.                                                                                                    
  1 -- State.                                                                                                    
 );                                                                                                  
END CATCH                                                 
END           
GO

