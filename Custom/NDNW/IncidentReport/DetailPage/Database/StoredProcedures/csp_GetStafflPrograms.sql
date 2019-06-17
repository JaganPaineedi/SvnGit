/****** Object:  StoredProcedure [dbo].[csp_GetStafflPrograms]   Script Date: 03/26/2014******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[csp_GetStafflPrograms]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[csp_GetStafflPrograms]
GO

/****** Object:  StoredProcedure [dbo].[csp_GetStafflPrograms]    Script Date: 03/26/2014******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[csp_GetStafflPrograms] (@ProgramId BIGINT)
AS
BEGIN TRY
	/********************************************************************************                                                     
--    
-- Copyright: Streamline Healthcare Solutions    
-- "Incident Report"  
-- Purpose: Script for Task #818 - Woods Customizations  
--    
-- Author:  Vamsi  
-- Date:    4-29-2015 
-- *****History****    
  
*********************************************************************************/
	-- All Staff
	SELECT DISTINCT S.StaffId
		,S.LastName + ', ' + S.FirstName AS DisplayAs
	FROM Staff S
	LEFT JOIN StaffPrograms SP ON SP.StaffId = S.StaffId
	LEFT JOIN StaffRoles SR ON SR.StaffId = s.StaffId
	--LEFT JOIN GlobalCodes G ON G.GlobalCodeId = SR.RoleId
	LEFT JOIN Recodes R ON R.IntegerCodeId = SR.RoleId
	WHERE ISNULL(S.RecordDeleted, 'N') = 'N'
		AND ISNULL(SP.RecordDeleted, 'N') = 'N'
		AND S.Active = 'Y'
		AND SP.ProgramId = @ProgramId
		AND R.IntegerCodeId IN (
			SELECT IntegerCodeId
			FROM Recodes
			WHERE RecodeCategoryId IN (
					SELECT RecodeCategoryId
					FROM RecodeCategories
					WHERE CategoryCode = 'XNOTIFIEDINJURY'
					)
			)
		AND ISNULL(S.RecordDeleted, 'N') <> 'Y'
		AND ISNULL(SP.RecordDeleted, 'N') <> 'Y'
		AND ISNULL(SR.RecordDeleted, 'N') <> 'Y'
	ORDER BY DisplayAs

	-- Supervisors
	SELECT DISTINCT S.StaffId
		,S.LastName + ', ' + S.FirstName AS DisplayAs
	FROM Staff S
	JOIN StaffRoles SR ON SR.StaffId = S.StaffId
	LEFT JOIN StaffPrograms SP ON SP.StaffId = S.StaffId
	--LEFT JOIN GlobalCodes G ON G.GlobalCodeId = SR.RoleId
	LEFT JOIN Recodes R ON R.IntegerCodeId = SR.RoleId
	WHERE ISNULL(S.RecordDeleted, 'N') = 'N'
		AND ISNULL(SP.RecordDeleted, 'N') = 'N'
		AND S.Active = 'Y'
		AND (
			(
				S.Supervisor = 'Y'
				OR R.IntegerCodeId IN (
					SELECT IntegerCodeId
					FROM Recodes
					WHERE RecodeCategoryId IN (
							SELECT RecodeCategoryId
							FROM RecodeCategories
							WHERE CategoryCode = 'XSUPERVISORFLAGGED'
							)
					)
				)
			)
		AND SP.ProgramId = @ProgramId
		AND ISNULL(S.RecordDeleted, 'N') <> 'Y'
		AND ISNULL(SP.RecordDeleted, 'N') <> 'Y'
		AND ISNULL(SR.RecordDeleted, 'N') <> 'Y'
	ORDER BY DisplayAs

	--Nurse
	SELECT DISTINCT S.StaffId
		,S.LastName + ', ' + S.FirstName AS DisplayAs
	FROM Staff S
	JOIN StaffRoles SR ON SR.StaffId = S.StaffId
	LEFT JOIN StaffPrograms SP ON SP.StaffId = S.StaffId
	--LEFT JOIN GlobalCodes G ON G.GlobalCodeId = SR.RoleId
	LEFT JOIN Recodes R ON R.IntegerCodeId = SR.RoleId
	WHERE ISNULL(S.RecordDeleted, 'N') = 'N'
		AND ISNULL(SP.RecordDeleted, 'N') = 'N'
		AND S.Active = 'Y'
		AND R.IntegerCodeId IN (
			SELECT IntegerCodeId
			FROM Recodes
			WHERE RecodeCategoryId IN (
					SELECT RecodeCategoryId
					FROM RecodeCategories
					WHERE CategoryCode = 'XNURSESTAFF'
					)
			)
		AND SP.ProgramId = @ProgramId
		AND ISNULL(S.RecordDeleted, 'N') <> 'Y'
		AND ISNULL(SP.RecordDeleted, 'N') <> 'Y'
		AND ISNULL(SR.RecordDeleted, 'N') <> 'Y'
	ORDER BY DisplayAs

	-- Behaviourist
	SELECT DISTINCT S.StaffId
		,S.LastName + ', ' + S.FirstName AS DisplayAs
	FROM Staff S
	JOIN StaffRoles SR ON SR.StaffId = S.StaffId
	LEFT JOIN StaffPrograms SP ON SP.StaffId = S.StaffId
	--LEFT JOIN GlobalCodes G ON G.GlobalCodeId = SR.RoleId
	LEFT JOIN Recodes R ON R.IntegerCodeId = SR.RoleId
	WHERE ISNULL(S.RecordDeleted, 'N') = 'N'
		AND ISNULL(SP.RecordDeleted, 'N') = 'N'
		AND S.Active = 'Y'
		AND R.IntegerCodeId IN (
			SELECT IntegerCodeId
			FROM Recodes
			WHERE RecodeCategoryId IN (
					SELECT RecodeCategoryId
					FROM RecodeCategories
					WHERE CategoryCode = 'XBEHAVIORISTSTAFF'
					)
			)
		AND SP.ProgramId = @ProgramId
		AND ISNULL(S.RecordDeleted, 'N') <> 'Y'
		AND ISNULL(SP.RecordDeleted, 'N') <> 'Y'
		AND ISNULL(SR.RecordDeleted, 'N') <> 'Y'
	ORDER BY DisplayAs

	SELECT DISTINCT S.StaffId
		,S.LastName + ', ' + S.FirstName AS DisplayAs
	FROM Staff S
	LEFT JOIN StaffPrograms SP ON SP.StaffId = S.StaffId
	LEFT JOIN StaffRoles SR ON SR.StaffId = s.StaffId
	LEFT JOIN GlobalCodes G ON G.GlobalCodeId = SR.RoleId
	WHERE ISNULL(S.RecordDeleted, 'N') = 'N'
		AND ISNULL(SP.RecordDeleted, 'N') = 'N'
		AND S.Active = 'Y'
		AND SP.ProgramId = @ProgramId
		AND ISNULL(S.RecordDeleted, 'N') <> 'Y'
		AND ISNULL(SP.RecordDeleted, 'N') <> 'Y'
		AND ISNULL(SR.RecordDeleted, 'N') <> 'Y'
	ORDER BY DisplayAs
	
	SELECT DISTINCT S.StaffId
		,S.LastName + ', ' + S.FirstName AS DisplayAs
	FROM Staff S
	LEFT JOIN StaffPrograms SP ON SP.StaffId = S.StaffId
	JOIN StaffRoles SR ON SR.StaffId = S.StaffId
	LEFT JOIN GlobalCodes G ON G.GlobalCodeId = SR.RoleId  
	LEFT JOIN Recodes R ON R.IntegerCodeId = SR.RoleId
	WHERE ISNULL(S.RecordDeleted, 'N') = 'N'
		AND S.Active = 'Y'
		AND SP.ProgramId = @ProgramId
		AND ISNULL(SP.RecordDeleted, 'N') <> 'Y'
		AND R.IntegerCodeId IN (SELECT IntegerCodeId FROM Recodes WHERE RecodeCategoryId IN (SELECT RecodeCategoryId FROM RecodeCategories WHERE CategoryCode = 'XMANAGER'))
	ORDER BY DisplayAs
END TRY

BEGIN CATCH
	DECLARE @Error VARCHAR(8000)

	SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'csp_GetStafflPrograms') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

	RAISERROR (
			@Error
			,-- Message text.                      
			16
			,-- Severity.                      
			1 -- State.                      
			);
END CATCH
