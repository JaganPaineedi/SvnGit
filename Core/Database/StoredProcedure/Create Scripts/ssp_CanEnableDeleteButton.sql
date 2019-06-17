IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_CanEnableDeleteButton]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_CanEnableDeleteButton] --550
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_CanEnableDeleteButton] 
@StaffId INT
AS
/*
Created By Deej on 7/9/2018 for to verify if the user has delete permission even after signing a document.
ETT#693
*/
BEGIN
    BEGIN TRY
	    IF EXISTS( 
		SELECT 1 FROM Staff AS sf  
		INNER JOIN ViewStaffPermissions AS vsp ON sf.StaffId = vsp.StaffId  
		WHERE PermissionTemplateType = 5704  
		 AND Exists(select globalcodeId from GlobalCodes where vsp.PermissionItemId = globalcodeId and Code='EnableDeleteButtonAfterSign' and Category='STAFFLIST')
		 AND sf.StaffId= @StaffId
		 )
		 BEGIN
		   SELECT 'Y'
		 END
	   ELSE
		  BEGIN
			 SELECT 'N'
		  END 
    END TRY
    BEGIN CATCH
	   DECLARE @Error varchar(8000)                                                                                                                                 
	   SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                          
                  
	    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'[ssp_CanEnableDeleteButton]')                                                                                                                 
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