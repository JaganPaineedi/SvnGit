/****** Object:  StoredProcedure [dbo].[csp_SCDocumentAcknowledgementsPostUpdate]    Script Date: 06/19/2013 17:49:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCDocumentAcknowledgementsPostUpdate]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCDocumentAcknowledgementsPostUpdate]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCDocumentAcknowledgementsPostUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE proc [dbo].[csp_SCDocumentAcknowledgementsPostUpdate]          
(                        
  @ScreenKeyId int,                                                        
  @StaffId int,                                                        
  @CurrentUser varchar(30),                        
  @CustomParameters xml                                         
)                        
as                    
/******************************************************************************                          
**  File:                           
**  Name: csp_SCDocumentAcknowledgementsPostUpdate                          
**  Desc:                           
**  This template can be customized:                          
**  Return values:                          
**  Called by:                             
**  Parameters:                          
**  Input       Output                          
**     ----------       -----------                          
**  Auth:                           
**  Date:                           
*******************************************************************************                          
**  Change Histor6y                          
*******************************************************************************                          
**  Date:      Author:     Description:                          
**  ---------  --------    -------------------------------------------                          
**  6/8/2011  Damanpreet Kaur    Created Procedure to call After signed documents                  
*******************************************************************************/                        
begin                       
                  
begin try                   
  
 if(@StaffId = 92)  
  set @StaffId = 897  
 else if(@StaffId = 897)  
  set @StaffId = 92  
 else  
  set @StaffId = 92    
    
    
 Update DocumentsAcknowledgements set RecordDeleted=''Y'', DeletedBy = @CurrentUser, DeletedDate = GETDATE()    
 where DocumentId = @ScreenKeyId    
   
  
       
 INSERT INTO DocumentsAcknowledgements         
 (        
  AcknowledgedByStaffId,      
  AcknowledgedDocumentVersionId,      
  DocumentId,      
  CreatedBy,        
  ModifiedBy         
 )        
 SELECT       
 @StaffId,      
 d.CurrentDocumentVersionId,      
 @ScreenKeyId,      
 @CurrentUser,      
 @CurrentUser      
 FROM Documents d       
 where d.DocumentId = @ScreenKeyId   
 
 --select ''CustomBasis32'',''Psychosis'',''Error'','''' 
    
 end try                                                                                      
                                                                                                                               
BEGIN CATCH                                          
DECLARE @Error varchar(8000)                                                                                     
SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                   
+ ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_SCDocumentAcknowledgementsPostUpdate'')                                                                                                                     
+ ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****'' + Convert(varchar,ERROR_SEVERITY())                                                                                                                      
+ ''*****'' + Convert(varchar,ERROR_STATE())                                                                  
 RAISERROR                                                                                         
 (                                                                                       
  @Error, -- Message text.                                                                                                         
  16, -- Severity.                                                                                                                    
  1 -- State.                                             
 );                                                                             
END CATCH                    
                    
end
' 
END
GO
