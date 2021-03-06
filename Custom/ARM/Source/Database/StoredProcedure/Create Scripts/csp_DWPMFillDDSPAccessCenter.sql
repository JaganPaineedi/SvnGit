/****** Object:  StoredProcedure [dbo].[csp_DWPMFillDDSPAccessCenter]    Script Date: 06/19/2013 17:49:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_DWPMFillDDSPAccessCenter]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_DWPMFillDDSPAccessCenter]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_DWPMFillDDSPAccessCenter]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/********************************************************************  */                
/* Stored Procedure: dbo.csp_DWPMFillDDSPAccessCenter      */                
/* Copyright: 2007 Provider Access Application        */                
/* Creation Date: 24th-Aug-2007            */                
/*                   */                
/* Purpose: This Stored procedure is used to get CountyFIPS,CountyName    
                */               
/*                    */              
/* Input Parameters: @ControlType,@SelectedValue       
/*                      */                
/* Output Parameters:              */                
/*                   */                
/* Return:                 */                
/*                      */                
/* Called By:                */                
/*                      */                
/* Calls:                    */                
/* Created By :Pramod Prakash Mishra                      */                
/* Data Modifications:                                                      */                
/*                      */                
/* Updates:                    */                
/*  Date           Author       Purpose                                    */                
/*                 Created                                    */                
/*********************************************************************/  */                
      
CREATE PROCEDURE [dbo].[csp_DWPMFillDDSPAccessCenter]      
(      
 @ControlType varchar(100),    
 @SelectedValue varchar(100)    
     
)      
AS      
BEGIN TRY    
  IF(@ControlType=''State'')    
   BEGIN    
    SELECT ''0'' as CountyFIPS,'''' as CountyName
     
	UNION ALL  
	
    SELECT CountyFIPS,CountyName FROM Counties    
    WHERE StateFIPS = Cast(@SelectedValue as INT)
     
   END     
    
    
END TRY    
BEGIN CATCH    
    
 declare @Error varchar(8000)  
 set @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())   
    + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_DWPMFillDDSPAccessCenter'')   
    + ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****'' + Convert(varchar,ERROR_SEVERITY())    
    + ''*****'' + Convert(varchar,ERROR_STATE())  
    
 RAISERROR   
 (  
  @Error, -- Message text.  
  16, -- Severity.  
  1 -- State.  
 );      
END CATCH
' 
END
GO
