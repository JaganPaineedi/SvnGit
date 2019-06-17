/****** Object:  StoredProcedure [dbo].[csp_GetStaff]   Script Date: 03/26/2014******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[csp_GetStaff]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[csp_GetStaff]
GO

/****** Object:  StoredProcedure [dbo].[csp_GetStaff]    Script Date: 03/26/2014******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[csp_GetStaff]
AS
BEGIN TRY
	/********************************************************************************                                                     
--    
-- Copyright: Streamline Healthcare Solutions    
-- "Psychiatric Service"  
-- Purpose: Script for Task #818 - Woods Customizations  
--    
-- Author:  Vamsi  
-- Date:    4-29-2015 
-- *****History****    
-- Date              Author                  Purpose*/
-- 02/FEB/2016       Akwinass                Modified the Recodes logic to support more than one value.(Woods - Environment Issues Tracking)*/ 
--*********************************************************************************/
	SELECT DISTINCT S.StaffId
		,S.LastName + ', ' + S.FirstName AS DisplayAs
	FROM Staff S
	WHERE ISNULL(S.RecordDeleted, 'N') = 'N'
		AND S.Active = 'Y'
	ORDER BY DisplayAs

	SELECT DISTINCT S.StaffId
		,S.LastName + ', ' + S.FirstName AS DisplayAs
	FROM Staff S
	JOIN StaffRoles SR ON SR.StaffId = S.StaffId
	--LEFT JOIN GlobalCodes G ON G.GlobalCodeId = SR.RoleId  
	LEFT JOIN Recodes R ON R.IntegerCodeId = SR.RoleId
	WHERE ISNULL(S.RecordDeleted, 'N') = 'N'
		AND S.Active = 'Y'
		AND (S.Supervisor = 'Y' OR R.IntegerCodeId IN (SELECT IntegerCodeId	FROM Recodes WHERE RecodeCategoryId IN (SELECT RecodeCategoryId FROM RecodeCategories WHERE CategoryCode = 'XSUPERVISORFLAGGED')))
	ORDER BY DisplayAs

	SELECT DISTINCT S.StaffId
		,S.LastName + ', ' + S.FirstName AS DisplayAs
	FROM Staff S
	JOIN StaffRoles SR ON SR.StaffId = S.StaffId
	LEFT JOIN Recodes R ON R.IntegerCodeId = SR.RoleId
	WHERE ISNULL(S.RecordDeleted, 'N') = 'N'
		AND S.Active = 'Y'
		AND (S.Administrator = 'Y' OR R.IntegerCodeId IN (SELECT IntegerCodeId FROM Recodes WHERE RecodeCategoryId IN (SELECT RecodeCategoryId FROM RecodeCategories WHERE CategoryCode = 'XAdministratorNotified')))
	ORDER BY DisplayAs

	SELECT DISTINCT S.StaffId
		,S.LastName + ', ' + S.FirstName AS DisplayAs
	FROM Staff S
	JOIN StaffRoles SR ON SR.StaffId = S.StaffId
	--LEFT JOIN GlobalCodes G ON G.GlobalCodeId = SR.RoleId  
	LEFT JOIN Recodes R ON R.IntegerCodeId = SR.RoleId
	WHERE ISNULL(S.RecordDeleted, 'N') = 'N'
		AND S.Active = 'Y'
		AND R.IntegerCodeId IN (SELECT IntegerCodeId FROM Recodes WHERE RecodeCategoryId IN (SELECT RecodeCategoryId FROM RecodeCategories WHERE CategoryCode = 'XNURSESTAFF'))
	ORDER BY DisplayAs
END TRY

BEGIN CATCH
	DECLARE @Error VARCHAR(8000)

	SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'csp_GetStaff') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

	RAISERROR (
			@Error
			,-- Message text.                      
			16
			,-- Severity.                      
			1 -- State.                      
			);
END CATCH
