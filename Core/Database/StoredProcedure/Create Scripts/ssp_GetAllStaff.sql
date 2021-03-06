/****** Object:  StoredProcedure [dbo].[ssp_GetAllStaff]    Script Date: 11/18/2011 16:25:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetAllStaff]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetAllStaff]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetAllStaff]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'  
CREATE  PROCEDURE  [dbo].[ssp_GetAllStaff]    
 @OrganizationId int                    
/*********************************************************************/                                                    
/* Stored Procedure: dbo.ssp_GetAllStaff               */                                           
                                          
                                          
/* Creation Date:  05/05/2010                                  */                                                    
/*                                                                   */                                                    
/* Purpose: Get All SecondOpinions From The Database           */                                                   
/*                                                                          */                                           
/* Input Parameters:      */                                                  
/*                                                                   */                                                     
/* Output Parameters:                                    */                                                    
/*                                                                   */                                                    
/* Return:   */                                                    
/*                                                                   */                                                    
/* Called By:         */                                        
/*                                                                   */                                                    
/* Calls:                                                            */                                                    
/*                                                                   */                                                    
/* Data Modifications:                                               */                                                    
/*                                                                   */                                                    
/* Updates:                                                          */                                                    
                                          
/* Author Vikas Vyas */                  
/*          */              
/* History */                        
/* Vamsi        08/18/2015     what: Added condition to select acitive staff(staff.Active=''Y'') */  
/*                             why: Valley Client Acceptance Testing Issues: # 316
 */  
/*********************************************************************/                                                     
AS              
      
BEGIN TRY                  
                
  --Grievance InforMation--                        
      SELECT  StaffId  
      ,FirstName  
      ,LastName  
      ,@OrganizationId as SystemDataBaseId  
      ,(select OrganizationName from SystemDatabases where SystemDatabaseId=@OrganizationId) as OrganizationName  
      ,(select ConnectionString from SystemDatabases where SystemDatabaseId=@OrganizationId)as ConnectionString  
       from Staff where  ISNULL(Staff.RecordDeleted,''N'')<>''Y'' and staff.Active=''Y''   
                        
END TRY          
BEGIN CATCH                  
    DECLARE @Error varchar(8000)                                                                 
         SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                                             
         + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''ssp_GetAllStaff'')                                                                             
         + ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****'' + Convert(varchar,ERROR_SEVERITY())                                    
         + ''*****'' + Convert(varchar,ERROR_STATE())                                                                            
 RAISERROR                                                                             
   (                                                                                 @Error, -- Message text.                                                                            
     16, -- Severity.                                                                            
     1 -- State.                                                                            
    );                             
END CATCH   ' 
END
GO
