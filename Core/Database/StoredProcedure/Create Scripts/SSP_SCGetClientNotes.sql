IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[SSP_SCGetClientNotes]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[SSP_SCGetClientNotes]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SSP_SCGetClientNotes] @ClientId INT
	,@StaffId INT
AS
/**********************************************************************/
/* Stored Procedure: dbo.[SSP_SCGetClientNotes]             */
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */
/* Creation Date:    12/052010                      */
/*                                                                   */
/* Purpose:It is used in get the Client Notes                           */
/*                                                                   */
/* Input Parameters: @ClientId                                 */
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
/*  Date                Author       Purpose                         */
/*  14 March 2012       Karan        Removed ordering of Dataset*/
/*  16 Jan 2015			Avi Goyal	 What : Changed NoteType Join to FlagTypes & applied Permissioned & display checks   */
/*									 Why : Task # 600 Securiry Alerts ; Project : Network-180 Customizations   */
/*  11 March 2016       Himmat       What : Commented  DEALLOCATE cur_ClientNeeds beacause they deallocated without Allocating  */
/*                                   Why  : KCMHSAS - Support#417  */
/*  20 Apr 2017         Bibhu        What : Call Scsp_SCGetClientNotes to implement Custom Logic */    
/*                                   Why : Task # 143 AspenPointe-Implementation  */ 
/*********************************************************************/
BEGIN
	BEGIN TRY
		----- 20 Apr 2017         Bibhu          
      IF EXISTS ( SELECT  *  
            FROM    sys.objects  
            WHERE   object_id = OBJECT_ID(N'scsp_SCGetClientNotes')  
                    AND type IN ( N'P', N'PC' ) ) 
    BEGIN     
    EXEC Scsp_SCGetClientNotes @ClientID
    END  
		--For Client Notes            
		SELECT CN.clientNoteId
			,CN.ClientId
			,CN.NoteType
			,CN.Note
			,
			--GC.CodeName, GC.Bitmap,GC.BitmapImage				-- Commented by Avi Goyal, on 16 Jan 2015 
			FT.FlagType AS CodeName
			,FT.Bitmap
			,FT.BitmapImage -- Added by Avi Goyal, on 16 Jan 2015 
		FROM clientNotes CN
		--left outer join GlobalCodes GC on CN.NoteType=GC.GlobalCodeId     -- Commented by Avi Goyal, on 16 Jan 2015
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
		WHERE --GC.Category='ClientNoteType' and								-- Commented by Avi Goyal, on 16 Jan 2015
			CN.ClientId = @ClientId
			AND IsNull(CN.RecordDeleted, 'N') = 'N'
			AND CN.Active = 'Y'
			AND (
				(
					GETDATE() >= isnull(CN.StartDate, GETDATE())
					AND GETDATE() <= isnull(DATEADD(Day, 1, CN.EndDate), '01/01/2070')
					)
				)
			--order by CN.ClientId, CN.clientNoteId desc     
			--order by 1 desc   
			
		
              
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'SSP_SCGetClientNotes') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

		--DEALLOCATE cur_ClientNeeds

		RAISERROR (
				@Error
				,-- Message text.                                                  
				16
				,-- Severity.                                                  
				1 -- State.                                                  
				);
	END CATCH
END
GO

