/****** Object:  StoredProcedure [dbo].[ssp_SCGetDocumentCodesViewPermission]    Script Date: 06/23/2015 09:46:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetDocumentCodesViewPermission]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetDocumentCodesViewPermission]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetDocumentCodesViewPermission]    Script Date: 06/23/2015 09:46:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 CREATE procedure [dbo].[ssp_SCGetDocumentCodesViewPermission]
 @StaffId int  
/********************************************************************************      
-- Stored Procedure: dbo.ssp_SCGetStaffScreenPermissions        
--      
-- Copyright: Streamline Healthcate Solutions      
--      
-- Purpose: returns Document Codes that staff have view permissions.      
-- Updates:                                                             
-- Date			Author			Purpose      
--23 Jun 2015   Chethan N		Created. Why : Macon Desing task#60    
*********************************************************************************/      
AS

BEGIN
	BEGIN TRY
		SELECT DocumentCodeId
		FROM DocumentCodes DC
		WHERE isnull(DC.RecordDeleted, 'N') = 'N'
			AND EXISTS (
				SELECT *
				FROM ViewStaffPermissions p
				WHERE p.StaffId = @StaffId
					AND p.PermissionItemId = DC.DocumentCodeId
					AND p.PermissionTemplateType = 5924 -- Document Codes (Edit)
				)
			AND NOT EXISTS (
				SELECT *
				FROM ViewStaffPermissions p
				WHERE p.StaffId = @StaffId
					AND p.PermissionItemId = DC.DocumentCodeId
					AND p.PermissionTemplateType = 5702 -- Document Codes (View)
				)
	END TRY

	BEGIN CATCH
		DECLARE @Error AS VARCHAR(8000);

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCGetDocumentCodesViewPermission') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE());

		RAISERROR (
				@Error
				,16
				,1
				);-- Message text. Severity.   State.                                                                                                            
	END CATCH
END


