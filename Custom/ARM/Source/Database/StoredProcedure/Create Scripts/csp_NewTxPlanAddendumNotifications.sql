/****** Object:  StoredProcedure [dbo].[csp_NewTxPlanAddendumNotifications]    Script Date: 06/19/2013 17:49:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_NewTxPlanAddendumNotifications]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_NewTxPlanAddendumNotifications]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_NewTxPlanAddendumNotifications]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'      
CREATE PROCEDURE  [dbo].[csp_NewTxPlanAddendumNotifications]                           
As                              
/*********************************************************************/                    
/* Stored Procedure: dbo.csp_NewTxPlanAddendumNotifications          */                    
-- Copyright: Streamline Healthcate Solutions                                                                                                                                    
-- Purpose: Used for getting Notification message in case of Intialization of Treatment     
-- Plan Addendum Ref to task 182 in UM Part II                                                                                                                                 
-- Updates:                                                                                                                           
-- Date             Author      Purpose                                                                    
-- 22nd-April-2011  Rakesh      Created.                    
/*********************************************************************/                     
                
Begin                
     
 BEGIN TRY       
        
    --Begin Unit Test Code    
    --Final Code to be written by Streamline Healthcare Solutions   Ref to task 182      
     Select ''Test'' as Notifications , ''AddendumNotifications'' as TableName   
           
 END TRY      
 BEGIN CATCH                                                                  
                                           
  DECLARE @Error varchar(8000)                                                             
                                            
  SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                    
  + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''[csp_NewTxPlanAddendumNotifications]'')                                                                                                     
  + ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****ERROR_SEVERITY='' + Convert(varchar,ERROR_SEVERITY())                                                           
  + ''*****ERROR_STATE='' + Convert(varchar,ERROR_STATE())                                                                                                    
                                            
  RAISERROR ( @Error, /* Message text.*/16, /* Severity.*/ 1 /*State.*/ );                                                                                            
                                                                 
 END CATCH                     
                  
End                  
                  
              
              ' 
END
GO
