/****** Object:  StoredProcedure [dbo].[ssp_GetStaffRoleInformation]    Script Date: 11/18/2011 16:25:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetStaffRoleInformation]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetStaffRoleInformation]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_GetStaffRoleInformation]   
AS    
/******************************************************************************************/    
/* Stored Procedure: [ssp_GetStaffRoleInformation] 733666            */    
/*       Date   Author                  Purpose          */  
-------------------------------------------------------------------------------------------    
/*       26 Dec 2018 Venkatesh         What : Get the Roles and Staff information
										Why : Engineering Improvement Initiatives- NBL(I) 449.1 */   
/******************************************************************************************/      
BEGIN    
 BEGIN TRY    
	 select dbo.ssf_GetGlobalCodeNameById(SR.RoleId) as RoleName, (S.LastName + ', ' + S.FirstName) AS StaffName  from staffRoles SR  
	 Join Staff S ON SR.StaffId=S.StaffId  
	 Where ISNULL(SR.RecordDeleted,'N')='N' AND ISNULL(S.RecordDeleted,'N')='N' AND S.Active='Y'
	 order by RoleName  
 END TRY    
    
 BEGIN CATCH    
  DECLARE @Error VARCHAR(8000)    
    
  SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'csp_SCGetCustomAIMS') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())    
    
  RAISERROR (    
    @Error    
    ,-- Message text.    
    16    
    ,-- Severity.    
    1 -- State.    
    );    
 END CATCH    
END    
    