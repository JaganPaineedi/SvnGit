/****** Object:  StoredProcedure [dbo].[csp_HarborInsertCustomTPNeeds]    Script Date: 06/19/2013 17:49:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_HarborInsertCustomTPNeeds]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_HarborInsertCustomTPNeeds]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_HarborInsertCustomTPNeeds]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
create PROCEDURE [dbo].[csp_HarborInsertCustomTPNeeds]   
 -- Add the parameters for the stored procedure here  
  @ClientId int,  
  @NeedText varchar(max),
  @LoggedInUser varchar(50)  
AS  
BEGIN 
/*********************************************************************/                                                                        
 /* Stored Procedure: [InsertCustomTPNeeds]                          */                                                               
 /* Creation Date:  30/May/2011                                      */                                                                        
 /* Purpose: To Insert The Data In The CustomTPNeeds Table           */                                                                      
 /* Input Parameters:@ClientId,@NeedText                             */  
  /* Output Parameters:   Returns The Table of CustomTPNeeds         */                                                                        
 /* Called By:                                                       */                                                              
 /* Data Modifications:                                              */                                                                        
 /*   Updates:                                                       */                                                                        
 /*   Date              Author                                       */                                                                        
 /*   30/May/2011       Rohit Katoch                                 */                                                                        
 /********************************************************************/     
BEGIN TRY  
BEGIN  
 INSERT INTO CustomTPNeeds  
   (ClientId,  
    NeedText,
    ModifiedBy,
    CreatedBy)  
 VALUES (@ClientId,@NeedText,@LoggedInUser,@LoggedInUser)  
END  
SELECT * FROM CustomTPNeeds WHERE ClientId=@ClientId and ISNULL(RecordDeleted ,''N'')<>''Y''  
END TRY  
BEGIN CATCH                                                                             
      
DECLARE @Error varchar(8000)                                                 
SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                                               
    + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_SCDeleteTPNeeds'')                                                                               
    + ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****'' + Convert(varchar,ERROR_SEVERITY())                                                                                
    + ''*****'' + Convert(varchar,ERROR_STATE())                                                                              
                                                                                            
                                                                          
 RAISERROR                                                                               
 (                                                 
  @Error, -- Message text.                                                                              
  16, -- Severity.                                                                              
  1 -- State.                                                                              
 );                                                                              
                                                                              
END CATCH    
END  ' 
END
GO
