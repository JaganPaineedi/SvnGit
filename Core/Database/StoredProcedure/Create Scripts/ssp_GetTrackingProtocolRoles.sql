/****** Object:  StoredProcedure [dbo].[ssp_GetTrackingProtocolRoles]    Script Date: 02/01/2018 16:59:16 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetTrackingProtocolRoles]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetTrackingProtocolRoles]
GO


/****** Object:  StoredProcedure [dbo].[ssp_GetTrackingProtocolRoles]    Script Date: 02/01/2018 16:59:16 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE  Procedure [dbo].[ssp_GetTrackingProtocolRoles]
(@roleToSearch VARCHAR(Max) )            
As    
/********************************************************************************    
-- Stored Procedure: dbo.[ssp_GetTrackingProtocolRoles]  
-- Copyright: Streamline Healthcate Solutions 
--    
-- Created:           
-- Date			Author		Purpose 
  05-02-2018    Vijay		What:This task is for searchable roles textbox
							Why:Engineering Improvement Initiatives- NBL(I) - Task#590
  02-13-2018    Vijay		What:Instead of Roles from Role Definition, we will list the Roles i.e. Global Codes under  “TreatmentTeamRole” category, while creating the protocol.
							Why:Engineering Improvement Initiatives- NBL(I) - Task#590.1							
*********************************************************************************/         
BEGIN   
 BEGIN TRY
   
  IF (@roleToSearch <> '')  
  BEGIN  
   SELECT DISTINCT GC.GlobalCodeId as RoleId
   ,GC.CodeName as RoleName
   FROM GlobalCodes GC
   WHERE GC.CATEGORY = 'TREATMENTTEAMROLE'
   AND GC.CodeName LIKE ('%' + @roleToSearch + '%') 
   AND ISNULL(GC.RecordDeleted, 'N') = 'N'
   ORDER BY GC.CodeName  
  END  
	
--Checking For Errors            
END TRY                                                                            
BEGIN CATCH                                
DECLARE @Error varchar(8000)                                                                             
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                       
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_GetTrackingProtocolRoles')                                                                                                           
    + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                                                            
    + '*****' + Convert(varchar,ERROR_STATE())                                                        
 RAISERROR                                                                                                           
 (                                                                             
  @Error, -- Message text.                                                                                                          
  16, -- Severity.                                                                                                          
  1 -- State.                                                                                                          
 );                                                                                                        
END CATCH                                                       
END   

GO


