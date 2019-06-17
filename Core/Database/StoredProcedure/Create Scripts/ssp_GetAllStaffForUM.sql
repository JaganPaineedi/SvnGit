IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetAllStaffForUM]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetAllStaffForUM]
GO

/****** Object:  StoredProcedure [dbo].[ssp_GetAllStaffForUM]    Script Date: 10/26/2017 15:24:10 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_GetAllStaffForUM] --1 
 @OrganizationId int                        
/*********************************************************************/                                                        
/* Stored Procedure: dbo.ssp_GetAllStaffForUM               */                                               
                                              
                                              
/* Creation Date:  02/23/2011                                  */                                                        
/*                                                                   */                                                        
/* Purpose: Get All Staff From The Multiple Database           */                                                       
/*                                                                          */                                               
/* Input Parameters:    @OrganizationId  */                                                      
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
                                              
/* Author Maninder*/                      
/*          */ 
/*   31 May 2012		Amit Kumar Srivastava		#1627, PM Web Bugs, Authorization Details: Staff and Auth Code Dropdowns sorting */      
/*   26 October 2017	Jess (Harbor)				Added exclusion for Non-Staff	*/      
                                           
/*********************************************************************/                                                         
AS                  
          
BEGIN TRY                      
                    
                             
      SELECT  StaffId  
      ,LastName + ' '+ FirstName +',' + (select OrganizationName from SystemDatabases where SystemDatabaseId=@OrganizationId) as staffName  
      from Staff where  ISNULL(Staff.RecordDeleted,'N')<>'Y'   and Staff.Active='Y'  
      AND	  ISNULL(Staff.NonStaffUser, 'N') <> 'Y'	-- Added by Jess (Harbor) 10/26/2017   
      order by   staffName       
                            
END TRY              
BEGIN CATCH                      
    DECLARE @Error varchar(8000)                                                                     
         SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                 
         + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_GetAllStaffForUM')                                                                                 
         + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                        
         + '*****' + Convert(varchar,ERROR_STATE())                                                                                
 RAISERROR                      
   (                                                                                 @Error, -- Message text.                                    
     16, -- Severity.                                                                                
     1 -- State.                                                                                
    );                                 
END CATCH 

GO

