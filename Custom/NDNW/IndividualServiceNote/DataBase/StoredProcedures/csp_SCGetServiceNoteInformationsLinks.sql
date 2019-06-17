/****** Object:  StoredProcedure [dbo].[csp_SCGetServiceNoteInformationsLinks]     ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetServiceNoteInformationsLinks]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCGetServiceNoteInformationsLinks]
GO

/****** Object:  StoredProcedure [dbo].[csp_SCGetServiceNoteInformationsLinks]   ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

  
  
CREATE Procedure [dbo].[csp_SCGetServiceNoteInformationsLinks]  
@DocumentCodeId INT  
AS  
 /*********************************************************************/                                                                                        
 /* Stored Procedure: csp_InitSCGetServiceNoteInformationsLinks               */                                                                               
 /* Creation Date:  26/Mar/2012                                    */                                                                                        
 /* Purpose: To Get The Service Note  Information Links on Get Individual Service Notes*/                                                                                       
 /* Input Parameters: @DocumentVersionId */                                                                                      
 /* Output Parameters:                                */                                                                                        
 /* Return:   */                                                                                        
 /* Called By:Initialization of Screen   */                                                                              
 /* Calls:                                                            */                                                                                        
 /*                                                                   */                                                                                        
 /* Data Modifications:                                               */                                                                                        
 /*   Updates:                                                          */                                                                                        
 /*  Date              Author                  Purpose    */       
 /* 26/Mar/2012   Devi Dayal   To Get The Service Note  Information Links on Get Individual Service Notes*/   
/*********************************************************************/     
    
  Begin                              
Begin try   
  SELECT TOP 10 CNI.[CustomInformationId]    
      ,CNI.[CreatedBy]    
      ,CNI.[CreatedDate]    
      ,CNI.[ModifiedBy]    
      ,CNI.[ModifiedDate]    
      ,CNI.[RecordDeleted]    
      ,CNI.[DeletedBy]    
      ,CNI.[DeletedDate]    
      ,CNI.[InformationText]    
      ,CNI.[InformationToolTipStoredProcedure]    
      ,CNI.[DocumentCodeId]    
  FROM [CustomNoteInformations] CNI     
  WHERE  CNI.DocumentCodeId=@DocumentCodeId AND  ISNULL(CNI.RecordDeleted,'N')<>'Y'    
    
    
  
END TRY                                                                          
BEGIN CATCH                              
DECLARE @Error varchar(8000)                                                                           
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                     
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'csp_SCGetServiceNoteInformationsLinks')                                                                                                         
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


