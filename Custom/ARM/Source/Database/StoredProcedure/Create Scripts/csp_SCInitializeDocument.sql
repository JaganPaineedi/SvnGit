/****** Object:  StoredProcedure [dbo].[csp_SCInitializeDocument]    Script Date: 06/19/2013 17:49:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCInitializeDocument]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCInitializeDocument]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCInitializeDocument]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE  PROCEDURE [dbo].[csp_SCInitializeDocument]                                                                                                                                
(                                                                                                                                    
  @DocumentCodeId as int,                                                                                                
  @varclientid as int,      
  @BlankForm varchar(1) = null                                                                                                   
)                                                                                                                                    
AS                                                  
/*********************************************************************/                                                                                                                                      
/* Stored Procedure: dbo.csp_SCInitializeDocument                */                                                                                                                                      
/* Copyright: 2006 Streamline Healthcare Solutions,  LLC             */                                                                                                                                      
/* Creation Date:    26/11/08                                         */                                                                                                                                      
/*                                                                   */                                                                                                                                      
/* Purpose:   This procedure is used to Delete the documents for the passed DocumentId and DocumentCodeId */                                                                                                                                    
/*                                                                   */                                                                                                                                    
/* Input Parameters: @DocumentId,@DocumentCodeId              */                                                                                                                                    
/*                                                                   */                                                                                                                                      
/* Output Parameters:        */                                                                                                                                      
/*                                                                   */                                                                                                                                      
/* Return:  0=success, otherwise an error number                     */                                                                                                                                      
/*                                                                   */                                                                                                                                      
/* Called By:                                                        */                                                                                                                                      
/*                                                                   */                                                                                                                                      
/* Calls:                                                            */                  
/*                           */                                    
/* Data Modifications:      */      
/*                         */                           
/* Updates:                                */                                 
/* Date        Author       Purpose                   
/* 6th April  Sonia Dhamija Modification Initialization of Custom Documents Reference Task #691*/                                  
/**********************************************************************/                                                                                   
*/        
                                                                    
            
Begin                                                                        
            
Declare @InitializationStroredProcedureName varchar(100)        
declare @execString varchar(2000)        
                                                                                 
        
Begin Try        
        
--Fetch the @InitializationStroredProcedureName        
--from DocumentCodes Table and execute the same by passing ClientId as paramter name        
        
Select @InitializationStroredProcedureName=InitializationStoredProcedure           
 from DocumentCodes        
 where DocumentCodeId=@DocumentCodeId           
 set @execString=''exec  '' + @InitializationStroredProcedureName + '' '' + cast(@varclientid as varchar)   + '' ,'' + cast(@DocumentCodeId as varchar)      
 exec(@execString)        
        
end try        
        
Begin Catch        
        
DECLARE @Error varchar(8000)                                    
 SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                     
    + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_SCInitializeDocument'')                                     
    + ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****'' + Convert(varchar,ERROR_SEVERITY())                                      
    + ''*****'' + Convert(varchar,ERROR_STATE())                                    
        
                                                   
                                
 RAISERROR                                     
 (                                    
  @Error, -- Message text.                                    
  16, -- Severity.                                    
  1 -- State.                                    
 );                          
end Catch        
        
end
' 
END
GO
