
GO

/****** Object:  StoredProcedure [dbo].[csp_GetMemberContactsReleasedToReceiveFrom]    Script Date: 01/23/2013 19:42:06 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_GetMemberContactsReleasedToReceiveFrom]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_GetMemberContactsReleasedToReceiveFrom]
GO


GO

/****** Object:  StoredProcedure [dbo].[csp_GetMemberContactsReleasedToReceiveFrom]    Script Date: 01/23/2013 19:42:06 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

  
CREATE Procedure [dbo].[csp_GetMemberContactsReleasedToReceiveFrom]  
 @ClientID INT  
AS  
 /*********************************************************************/                                                                                        
 /* Stored Procedure: csp_GetMemberContactsReleasedToReceiveFrom      */                                                                               
 /* Creation Date:  06/Dec/2013                                     */                                                                                        
 /* Purpose: To Get Member Contact           */  
 /* Input Parameters: @ClientId            */                                                                                      
 /* Output Parameters:              */                                                                                        
 /* Return:                 */                                                                                        
 /* Called By:Document Screen              */                                                                              
 /* Calls:                                                            */                                                                                        
 /*                                                                   */                                                                                        
 /* Data Modifications:                                               */                                                                                        
 /* Updates:                                                          */                                                                                        
 /* Date              Author                  Purpose      */       
 /* 06/Dec/2013   Md Hussain Khusro			  Created      */   
 /*********************************************************************/     
    
Begin                              
Begin TRY   
  
 SELECT DISTINCT  CC.ClientContactId  
     ,CC.ListAs  
     ,COALESCE(CC.LastName,'') + ', ' + COALESCE(CC.FirstName,'') AS Name      
     FROM   
  ClientContacts AS CC              
  WHERE CC.ClientId=@ClientId AND ISNULL(CC.RecordDeleted,'N')='N'  
    
END TRY                                                                          
BEGIN CATCH                              
DECLARE @Error varchar(8000)                                                                           
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                     
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'csp_GetMemberContactsReleasedToReceiveFrom')                                                                                                         
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


