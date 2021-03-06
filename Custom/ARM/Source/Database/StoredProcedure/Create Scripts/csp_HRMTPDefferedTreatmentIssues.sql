/****** Object:  StoredProcedure [dbo].[csp_HRMTPDefferedTreatmentIssues]    Script Date: 06/19/2013 17:49:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_HRMTPDefferedTreatmentIssues]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_HRMTPDefferedTreatmentIssues]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_HRMTPDefferedTreatmentIssues]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[csp_HRMTPDefferedTreatmentIssues]           
         
      
@ClientId int,        
@result varchar(8000) output              
AS          
/******************************************************************************                
**  File:                 
**  Name: [csp_HRMTPDefferedTreatmentIssues]                
**  Desc:        
**                
**  This template can be customized:                
**                              
**  Return values:                
**                 
**  Called by: called by SP csp_InitializeHRMTreatmentPlanStandardInitialization                       
**                              
**  Parameters:                
**  Input    Output                
**  @ClientId      @result               
**           
**          
**  Auth:  Sonia Dhamija               
**  Date:  15/07/2008               
*******************************************************************************                
**  Change History                
*******************************************************************************                
**  Date:  Author:    Description:                
**  --------  --------    ----------------------------------------------------                
           
*******************************************************************************/              
BEGIN          
BEGIN TRY          
        
      set @result=''ok''    
--select ''Deffered Initialized''        
    
          
        
          
END TRY            
          
BEGIN CATCH             
DECLARE @Error varchar(8000)              
 SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())               
    + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_InitializeHRMTreatmentPlanStandardInitialization'')               
    + ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****'' + Convert(varchar,ERROR_SEVERITY())                
    + ''*****'' + Convert(varchar,ERROR_STATE())              
                
 RAISERROR               
 (              
  @Error, -- Message text.              
  16, -- Severity.              
  1 -- State.              
 );              
              
END CATCH           
END
' 
END
GO
