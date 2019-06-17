/****** Object:  StoredProcedure [dbo].[ssp_GetOrderingPhysician]    Script Date: 02/03/2015 01:57:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetOrderingPhysician]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetOrderingPhysician]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
/*********************************************************************/                        
/* Stored Procedure: dbo.ssp_GetOrderingPhysician     */                        
/* Creation Date:  23/05/2015                                        */                        
/* Author: Chethan N                                                                  */                        
/* Purpose: To Bind Ordering Physician Dropdown  
                  */                       
/*                                                                   */                      
/* Input Parameters:             */                      
/*                                                                   */                        
/* Output Parameters:             */                        
/*                                                                   */                        
/*  Date                  Author                 Purpose             */  
/* 01/03/2018			 MSood			What: Added Staff.Active Condition to display Active Staff only, corrected Raise Error Syntax and prefix table alias to column permissionitemid
										Why: KCMHSAS - Support Task #870   */               
/*********************************************************************/   
CREATE Procedure [dbo].[ssp_GetOrderingPhysician]  
   
AS  
BEGIN  
BEGIN TRY  
   
 DECLARE @PermissionTemplateId INT  
 select  @PermissionTemplateId = GLobalCodeID from GlobalCodes Where Code = 'Ordering Physician' and Category = 'STAFFLIST'  
 select S.StaffId,S.LastName +', '+S.FirstName as StaffName from ViewStaffPermissions vs JOIN Staff S   
 On S.StaffId = vs.StaffId  
 where vs.permissionitemid = @PermissionTemplateId AND  ISNULL(S.RecordDeleted,'N') ='N'
--msood 01/03/2018
 AND S.Active='Y' 
 Order by StaffName 
   
   END TRY                
 BEGIN CATCH     
--msood 01/03/2018  
   RAISERROR ('ssp_GetOrderingPhysician: An Error Occured',16,1)                     
   Return                  
 END CATCH   
  
END  
GO
