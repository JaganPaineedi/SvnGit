

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetProgramsBasedOnLoggedInStaff]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetProgramsBasedOnLoggedInStaff]
GO


/****** Object:  StoredProcedure [dbo].[ssp_SCGetProgramsBasedOnLoggedInStaff]    Script Date: 02/12/2016 13:30:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [DBO].[ssp_SCGetProgramsBasedOnLoggedInStaff]  
@LoggedInStaffId int = null    
/********************************************************************************              
-- Stored Procedure: dbo.ssp_SCGetProgramsBasedOnLoggedInStaff                
--              
-- Copyright: Streamline Healthcate Solutions              
--              
-- Purpose: gets data from Programs table based on LoggedInStaffId  
-- Updates:                                                                     
-- Date        Author         Purpose              
-- 8/2/2018	 Deej		  To select Programs based on LoggedInStaffAccess
*********************************************************************************/        
as    
BEGIN
 BEGIN TRY
    SELECT *   
    FROM Programs p  
  WHERE isnull(p.RecordDeleted, 'N') = 'N'  
  AND EXISTS(SELECT *  
                    FROM StaffPrograms sp  
                   WHERE sp.StaffId = @LoggedInStaffId   
                     AND sp.ProgramId = p.ProgramId  
                     AND isnull(sp.RecordDeleted, 'N') = 'N') AND ISNULL(p.Active,'Y')='Y'
 END TRY
 BEGIN CATCH
    DECLARE @Error varchar(8000)                                                                        
	SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                     
	+ '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_SCGetProgramsBasedOnLoggedInStaff')                                                                                                         
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