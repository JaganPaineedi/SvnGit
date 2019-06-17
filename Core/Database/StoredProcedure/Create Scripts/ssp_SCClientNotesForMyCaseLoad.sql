IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCClientNotesForMyCaseLoad]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_SCClientNotesForMyCaseLoad]
GO

CREATE PROCEDURE [dbo].ssp_SCClientNotesForMyCaseLoad @NoteType INT
	,@StaffId INT
AS
/**********************************************************************/
/* Stored Procedure: dbo.[ssp_SCClientNotesForMyCaseLoad]             */
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */
/* Creation Date:    10/01/2012                      */
/*                                                                   */
/* Purpose:It is used in get the Client Notes                           */
/*                                                                   */
/* Input Parameters:                                  */
/*                                                                   */
/* Output Parameters:   None                               */
/*                                                                   */
/* Return:  0=success, otherwise an error number                     */
/*                                                                   */
/* Called By:                                                        */
/*                                                                   */
/* Calls:                                                            */
/*                                                                   */
/* Data Modifications:                                               */
/*                                                                   */
/* Updates:                                                          */
/*  Date			Author		Purpose								 */
/*  -----------------------------------------------------------------*/
/*  01.10.2012		Karan		To get the Dataset of Client Notes    */
/*  16 Jan 2015		Avi Goyal	What : Changed NoteType Join to FlagTypes & applied Permissioned & display checks  */
/*								Why : Task # 600 Securiry Alerts ; Project : Network-180 Customizations   */
/* 29 Nov 2017     Aravind      What:Modified the Ordere By Logic 
                                Why: “Notes/Icons” column of “My Caseload” often pops up an inconsistent note
                                Task #891 - Pines-Support   
	04/09/2018		Gautam		What: Removed the hardcoded date '01/01/2070' for date comparison
								Why : It was throwing overflow error  Journey-Support Go Live Task #21
                                                                   */
/*****************************************************************************************************************/
BEGIN
	BEGIN TRY
		--For Client Notes          
		SELECT CN.clientNoteId
			,CN.ClientId
			,CN.NoteType
			,CN.Note
			,
			--GC.CodeName,					-- Commented by Avi Goyal, on 16 Jan 2015                   
			FT.FlagType AS CodeName
			,-- Added by Avi Goyal, on 16 Jan 2015  
			--GC.Bitmap,					-- Commented by Avi Goyal, on 16 Jan 2015
			FT.Bitmap
			,-- Added by Avi Goyal, on 16 Jan 2015 
			--GC.BitmapImage				-- Commented by Avi Goyal, on 16 Jan 2015
			FT.BitmapImage -- Added by Avi Goyal, on 16 Jan 2015  
		FROM clientNotes CN
		--left outer join GlobalCodes GC on CN.NoteType=GC.GlobalCodeId		-- Commented by Avi Goyal, on 16 Jan 2015
		-- Added by Avi Goyal, on 16 Jan 2015
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
		WHERE
			--GC.Category='ClientNoteType'  and        -- Commented by Avi Goyal, on 16 Jan 2015
			--and CN.ClientId=@ClientId
			IsNull(CN.RecordDeleted, 'N') = 'N'
			AND CN.Active = 'Y'
			AND (
				(
					GETDATE() >= isnull(CN.StartDate, GETDATE())
					---- Gautam 4/9/2018
					AND ( CN.EndDate is null or cast(CN.EndDate as date) >= GETDATE())
					--AND GETDATE() <= isnull(DATEADD(Day, 1, CN.EndDate), '01/01/2070')
					)
				)
			--order by CN.ClientId, CN.clientNoteId desc 
			AND (
				CN.NoteType = @NoteType
				OR @NoteType = 0
				)
		ORDER BY CN.NoteType ASC
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCClientNotesForMyCaseLoad') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.                                                
				16
				,-- Severity.                                                
				1 -- State.                                                
				);
	END CATCH
END