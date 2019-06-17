/****** Object:  UserDefinedFunction [dbo].[ssf_GetNoteTypeWithPermission]    Script Date: 08/31/2016 14:01:49 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssf_GetNoteTypeWithPermission]')
			AND type IN (
				N'FN'
				,N'IF'
				,N'TF'
				,N'FS'
				,N'FT'
				)
		)
	DROP FUNCTION [dbo].[ssf_GetNoteTypeWithPermission]
GO

/****** Object:  UserDefinedFunction [dbo].[ssf_GetNoteTypeWithPermission]    Script Date: 08/31/2016 14:01:49 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--select dbo.ssf_GetNoteTypeWithPermission(200)  
CREATE FUNCTION [dbo].[ssf_GetNoteTypeWithPermission] (
	@ClientId INT
	,@StaffId INT
	)
RETURNS VARCHAR(max)
AS  
/*********************************************************************/
/* Stored Procedure: [ssf_GetNoteTypeWithPermission]   */
/*       Date              Author                  Purpose                   */
/*       23/SEP/2016      Vamsi               To Retrieve Flags which have permission           */
/*********************************************************************/
BEGIN
	DECLARE @ReturnNoteId NVARCHAR(max)

	SELECT TOP 10 @ReturnNoteId = coalesce(@ReturnNoteId + '|||', '') + str(Cn.notetype) + '^^^' + convert(VARCHAR(max), Note)
	FROM ClientNotes CN
	INNER JOIN FlagTypes FT ON FT.FlagTypeId = CN.NoteType
		AND ISNULL(FT.RecordDeleted, 'N') = 'N'
		AND ISNULL(FT.DoNotDisplayFlag, 'N') = 'N'
		AND (
			ISNULL(FT.PermissionedFlag, 'N') = 'N'
			OR (
				ISNULL(FT.PermissionedFlag, 'N') = 'Y'
				AND (
					(
						EXISTS (
							SELECT 1
							FROM PermissionTemplateItems PTI
							INNER JOIN PermissionTemplates PT ON PT.PermissionTemplateId = PTI.PermissionTemplateId
								AND ISNULL(PT.RecordDeleted, 'N') = 'N'
								AND dbo.ssf_GetGlobalCodeNameById(PT.PermissionTemplateType) = 'Flags'
							INNER JOIN StaffRoles SR ON SR.RoleId = PT.RoleId
								AND ISNULL(SR.RecordDeleted, 'N') = 'N'
							WHERE ISNULL(PTI.RecordDeleted, 'N') = 'N'
								AND PTI.PermissionItemId = FT.FlagTypeId
								AND SR.StaffId = @StaffId
							)
						OR EXISTS (
							SELECT 1
							FROM StaffPermissionExceptions SPE
							WHERE SPE.StaffId = @StaffId
								AND ISNULL(SPE.RecordDeleted, 'N') = 'N'
								AND dbo.ssf_GetGlobalCodeNameById(SPE.PermissionTemplateType) = 'Flags'
								AND SPE.PermissionItemId = FT.FlagTypeId
								AND SPE.Allow = 'Y'
								AND (
									SPE.StartDate IS NULL
									OR CAST(SPE.StartDate AS DATE) <= CAST(GETDATE() AS DATE)
									)
								AND (
									SPE.EndDate IS NULL
									OR CAST(SPE.EndDate AS DATE) >= CAST(GETDATE() AS DATE)
									)
							)
						)
					AND NOT EXISTS (
						SELECT 1
						FROM StaffPermissionExceptions SPE
						WHERE SPE.StaffId = @StaffId
							AND ISNULL(SPE.RecordDeleted, 'N') = 'N'
							AND dbo.ssf_GetGlobalCodeNameById(SPE.PermissionTemplateType) = 'Flags'
							AND SPE.PermissionItemId = FT.FlagTypeId
							AND SPE.Allow = 'N'
							AND (
								SPE.StartDate IS NULL
								OR CAST(SPE.StartDate AS DATE) <= CAST(GETDATE() AS DATE)
								)
							AND (
								SPE.EndDate IS NULL
								OR CAST(SPE.EndDate AS DATE) >= CAST(GETDATE() AS DATE)
								)
						)
					)
				)
			)
	WHERE CN.Active = 'Y'
		AND isNull(CN.RecordDeleted, 'N') = 'N'
		AND CN.clientid = @clientid
		AND (
			(
				GETDATE() >= isnull(CN.StartDate, GETDATE())
				AND GETDATE() <= isnull(DATEADD(Day, 1, CN.EndDate), '01/01/2070')
				)
			)
	ORDER BY CN.ClientNoteId DESC

	RETURN @ReturnNoteId
END
GO


