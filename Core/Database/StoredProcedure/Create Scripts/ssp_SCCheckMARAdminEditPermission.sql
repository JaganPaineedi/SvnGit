/****** Object:  StoredProcedure [dbo].[ssp_SCCheckMARAdminEditPermission]    Script Date: 07/06/2015 10:28:01 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCCheckMARAdminEditPermission]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCCheckMARAdminEditPermission]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCCheckMARAdminEditPermission]    Script Date: 07/06/2015 10:28:01 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

  
/*********************************************************************/                        
/* Stored Procedure: dbo.ssp_SCCheckMARAdminEditPermission     */                        
/* Creation Date:  06/07/2015                                        */                        
/* Author: Chethan N                                                                  */                        
/* Purpose: To Check for MAR Admin Edit Permission  
                  */                       
/*                                                                   */                      
/* Input Parameters:             */                      
/*                                                                   */                        
/* Output Parameters:             */                        
/*                                                                   */                        
/*  Date                  Author                 Purpose             */                 
/*********************************************************************/   
CREATE Procedure [dbo].[ssp_SCCheckMARAdminEditPermission]  
 @StaffId INT
AS  
BEGIN  
BEGIN TRY  
  
	SELECT S.StaffId
		,S.LastName + ', ' + S.FirstName AS StaffName
	FROM ViewStaffPermissions vs
	INNER JOIN Staff S ON S.StaffId = vs.StaffId
	WHERE vs.PermissionItemId = 5735 -- STAFFLIST -- MAR Admin Edit
		AND ISNULL(S.RecordDeleted, 'N') = 'N'
		AND S.StaffId = @StaffId
   
   END TRY                
 BEGIN CATCH              
   RAISERROR  20006  'ssp_SCCheckMARAdminEditPermission: An Error Occured'                     
   Return                  
 END CATCH   
  
END  

GO


