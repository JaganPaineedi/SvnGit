/****** Object:  StoredProcedure [dbo].[csp_RDLCustomDisposition]    Script Date: 11/27/2013 15:41:29 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomDisposition]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLCustomDisposition]
GO

/****** Object:  StoredProcedure [dbo].[csp_RDLCustomDisposition]    Script Date: 11/27/2013 15:41:29 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

Create PROCEDURE  [dbo].[csp_RDLCustomDisposition]                        
(                              
 @DocumentVersionId  int                              
)                              
As   
begin                   
/**************************************************************  
Created By   : Sudhir Singh  
Created Date : 12th-JAN-2012  
Description  : Used to Bind The RDL for Disposition Control on any page  
Called From  : 'Disposition'  
**************************************************************/  
  
BEGIN TRY                      
Select
	CD.CustomDispositionId
	,CD.CreatedBy
	,CD.CreatedDate
	,CD.ModifiedBy
	,CD.ModifiedDate
	,CD.RecordDeleted
	,CD.DeletedBy
	,CD.DeletedDate
	,CD.InquiryId
	,CD.DocumentVersionId
	,GC.CodeName AS Disposition
  FROM CustomDispositions CD
  LEFT OUTER JOIN GlobalCodes GC ON CD.Disposition = GC.GlobalCodeId
  WHERE ISNull(CD.RecordDeleted,'N')='N' AND CD.[DocumentVersionId]=@DocumentVersionId    
  END TRY                                                                        
BEGIN CATCH                            
DECLARE @Error varchar(8000)                                                                         
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                   
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'csp_RDLCustomDisposition')                                                                                                       
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


