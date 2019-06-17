IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetFlagAlerts]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetFlagAlerts]
GO

CREATE PROCEDURE [dbo].[ssp_GetFlagAlerts]
/********************************************************************************                                                  
-- Stored Procedure: ssp_GetFlagAlerts
-- Copyright: Streamline Healthcate Solutions
-- Purpose: Procedure to return data for the Flag Types list page.
-- Author:  Avi Goyal
-- Date:    12 Jan 2015
--
-- *****History****
-- Date			Author			Purpose
--------------------------------------------------------------------------------
-- 12 Jan 2015	Avi Goyal		What: Created
								Why : Network-180 Customizaions Task #600
*********************************************************************************/
@ClientId INT,
@StaffId INT
AS
BEGIN
	BEGIN TRY
		SELECT 
			CONVERT(VARCHAR(10), CN.StartDate, 101) AS StartDate,    
			(CASE 
				WHEN CN.EndDate IS NULL 
					THEN 'No End Date'
				ELSE
					CONVERT(VARCHAR(10), CN.EndDate, 101)
			END) AS EndDate,
			FT.FlagType,
			CN.Note,
			CN.Comment,
			CN.NoteType AS FlagTypeId,
			CN.ClientNoteId
		FROM ClientNotes AS CN 	
		INNER JOIN FlagTypes FT ON FT.FlagTypeId=CN.NoteType AND FT.NeverPopup='N' AND ISNULL(FT.RecordDeleted,'N') = 'N' 
															 AND ISNULL(FT.DoNotDisplayFlag,'N')='N' 
															 AND (
																	ISNULL(FT.PermissionedFlag,'N')='N'
																	OR
																	(
																		ISNULL(FT.PermissionedFlag,'N')='Y' 
																		AND 
																		(
																			(
																				EXISTS( 
																						SELECT 1
																						FROM PermissionTemplateItems PTI 
																						INNER JOIN PermissionTemplates PT ON  PT.PermissionTemplateId=PTI.PermissionTemplateId AND ISNULL(PT.RecordDeleted,'N')='N' 
																																				AND dbo.ssf_GetGlobalCodeNameById(PT.PermissionTemplateType)='Flags'
																						INNER JOIN StaffRoles SR ON SR.RoleId=PT.RoleId AND ISNULL(SR.RecordDeleted,'N')='N' 
																						WHERE ISNULL(PTI.RecordDeleted,'N')='N' 
																								AND PTI.PermissionItemId=FT.FlagTypeId 
																								AND SR.StaffId=@StaffId
																					   )
																				OR
																				EXISTS(
																						SELECT 1
																						FROM StaffPermissionExceptions SPE
																						WHERE SPE.StaffId=@StaffId
																							AND ISNULL(SPE.RecordDeleted,'N')='N' 
																							AND dbo.ssf_GetGlobalCodeNameById(SPE.PermissionTemplateType)='Flags'
																							AND SPE.PermissionItemId=FT.FlagTypeId AND SPE.Allow='Y'
																							AND (SPE.StartDate IS NULL OR CAST(SPE.StartDate AS DATE) <=CAST(GETDATE() AS DATE))
																							AND (SPE.EndDate IS NULL OR CAST(SPE.EndDate AS DATE) >=CAST(GETDATE() AS DATE))
																					  )
																			)
																			AND 
																			NOT EXISTS(
																						SELECT 1
																						FROM StaffPermissionExceptions SPE
																						WHERE SPE.StaffId=@StaffId
																							AND ISNULL(SPE.RecordDeleted,'N')='N' 
																							AND dbo.ssf_GetGlobalCodeNameById(SPE.PermissionTemplateType)='Flags'
																							AND SPE.PermissionItemId=FT.FlagTypeId AND SPE.Allow='N'
																							AND (SPE.StartDate IS NULL OR CAST(SPE.StartDate AS DATE) <=CAST(GETDATE() AS DATE))
																							AND (SPE.EndDate IS NULL OR CAST(SPE.EndDate AS DATE) >=CAST(GETDATE() AS DATE))
																					  )
																		)
																	)
																 )
																		
		WHERE ISNULL(CN.RecordDeleted,'N') = 'N' 
			AND CN.Active='Y'
			AND CN.ClientId=@ClientId
			AND CAST(CN.StartDate AS DATE) <=CAST(GETDATE() AS DATE)
			AND (CN.EndDate IS NULL OR CAST(CN.EndDate AS DATE) >=CAST(GETDATE() AS DATE))
		ORDER BY CN.StartDate ASC
	
	END TRY
	BEGIN CATCH  
		DECLARE @Error VARCHAR(8000)         
		SET @Error= CONVERT(VARCHAR,ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000),ERROR_MESSAGE())                                                                                              
					+ '*****' + ISNULL(CONVERT(VARCHAR,ERROR_PROCEDURE()),'ssp_GetFlagAlerts')                                                                                               
					+ '*****' + CONVERT(VARCHAR,ERROR_LINE()) + '*****' + CONVERT(VARCHAR,ERROR_SEVERITY())                                                                                                
					+ '*****' + CONVERT(VARCHAR,ERROR_STATE())  
		RAISERROR  
		(  
			@Error, -- Message text.  
			16,  -- Severity.  
			1  -- State.  
		);  
	END CATCH  
END
GO