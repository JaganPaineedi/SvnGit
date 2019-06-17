/****** Object:  UserDefinedFunction [dbo].[ssf_SCGetAttendanceBannerDetails]    Script Date: 05/12/2015 12:21:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssf_SCGetAttendanceBannerDetails]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[ssf_SCGetAttendanceBannerDetails]
GO

/****** Object:  UserDefinedFunction [dbo].[ssf_SCGetAttendanceBannerDetails]    Script Date: 05/12/2015 12:21:48 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
  
CREATE FUNCTION [dbo].[ssf_SCGetAttendanceBannerDetails] (@ServiceId INT,@Date DATETIME,@ScreenId INT,@GroupNoteType INT,@ClientId INT,@ClientName VARCHAR(250), @GroupId INT,@GroupNoteDocumentCodeId INT,@GroupName VARCHAR(250),@PageNumber INT,@CurrentUserId INT)
/********************************************************************************    
-- Stored Procedure: dbo.ssf_SCGetAttendanceBannerDetails      
--    
-- Copyright: Streamline Healthcate Solutions 
--    
-- Updates:                                                           
-- Date			 Author			Purpose    
-- 11-May-2015	 Akwinass		What:Used in ssp_SCListPageAttendance.          
--								Why:task  #915 Valley - Customizations
-- 02-SEP-2015	 Akwinass		What:Removed @ClientName.          
--								Why:task  #379 Valley Client Acceptance Testing Issues.
-- 29-SEP-2015	 Akwinass	    What:Displaying Documentation/Screen Logic Modified
--							    Why:Task #829.06 in Core Bugs
-- 22-Feb-2016	 Akwinass		What:Modified the Associated Document Logic to check any document present for the Selected Date in the Filter.          
--								Why:task #167 Valley - Support Go Live
-- 04-MAR-2016	 Akwinass		What:Modified group note logic to redirect to Group Services.          
--								Why:task #17 Woods - Support Go Live
-- 13-APRIL-2016 Akwinass		What:Modified logic based on @GroupNoteType.          
--								Why:task #167.1 Valley - Support Go Live
-- 14-APRIL-2016 Akwinass	    What:Modified based on GroupStandAloneDocuments      
--							    Why:task #167.1 Valley - Support Go Live 
--02/10/2017      jcarlson       Keystone Customizations 69 - increased @ProcedureCode length to 500 to handle procedure code display as increasing to 75 
*********************************************************************************/ 
RETURNS VARCHAR(max)
AS
BEGIN
	DECLARE @Return NVARCHAR(max)	
	DECLARE @ProcedureCode VARCHAR(500)
	DECLARE @GroupServiceId INT
	
	IF ISNULL(@GroupNoteDocumentCodeId,0) > 0 AND @GroupNoteType = 9383
	BEGIN
		SELECT TOP 1 @GroupServiceId = s.GroupServiceId,@ProcedureCode = ProcedureCodes.DisplayAs,@GroupId = gs.GroupId  
		FROM GroupServices gs
		LEFT JOIN Groups g ON g.GroupId = gs.GroupId AND ISNULL(g.RecordDeleted, 'N') = 'N'
		LEFT JOIN GlobalCodes gc ON gc.GlobalCodeId = g.GroupType AND ISNULL(gc.RecordDeleted, 'N') = 'N'
		LEFT JOIN Programs p ON p.ProgramId = gs.ProgramId AND ISNULL(p.RecordDeleted, 'N') = 'N'
		JOIN Services s ON s.GroupServiceId = gs.GroupServiceId AND ISNULL(s.RecordDeleted, 'N') = 'N'
		JOIN ProcedureCodes ON ProcedureCodes.ProcedureCodeId = s.ProcedureCodeId
		LEFT JOIN GroupServiceStaff ON GroupServiceStaff.GroupServiceId = gs.GroupServiceId AND ISNULL(GroupServiceStaff.RecordDeleted, 'N') = 'N'
		CROSS APPLY [dbo].[ssf_SCGetGroupServiceStatus](gs.GroupServiceId) svcstatus
		LEFT OUTER JOIN dbo.GlobalCodes svcstatusgc ON svcstatusgc.GlobalCodeId = svcstatus.[Status] AND ISNULL(svcstatusgc.RecordDeleted, 'N') = 'N'
		WHERE ISNULL(gs.RecordDeleted, 'N') = 'N' AND s.ServiceId = @ServiceId	
	END
	
	IF ISNULL(@ServiceId,0) > 0 AND ISNULL(@GroupNoteType,0) = 9383 AND ISNULL(@ScreenId,0) = 0
	BEGIN
		IF @PageNumber = -1
		BEGIN
			SET @Return = @ProcedureCode+' (Group Note)'
		END
		ELSE
		BEGIN
			SET @Return = '5761,46,"GroupId='+CAST(@GroupId AS VARCHAR(50))+'^GroupServiceId='+CAST(@GroupServiceId AS VARCHAR(50))+'^SelectedClientIdOnServiceTab='+CAST(@ClientId AS VARCHAR(50))+'^TabId=1"' + '|'+@ProcedureCode+' (Group Note)'			
		END
	END
	ELSE
	BEGIN	
		IF ISNULL(@GroupNoteType,0) = 9384 OR ISNULL(@GroupNoteType,0) = 9385
		BEGIN
			DECLARE @DocumentCodeId INT = 0
			SELECT TOP 1 @DocumentCodeId = ServiceNoteCodeId
			FROM GroupNoteDocumentCodes
			WHERE GroupNoteDocumentCodeId = @GroupNoteDocumentCodeId
				AND ISNULL(Active, 'N') = 'Y'
				AND ISNULL(RecordDeleted, 'N') = 'N'
			
			IF @PageNumber = -1
			BEGIN
				SELECT TOP 1 @Return = B.DisplayAs+ ' (Document)'
				FROM Banners B
				JOIN Screens S ON B.ScreenId = S.ScreenId AND ISNULL(B.Active, 'N') = 'Y' AND ISNULL(B.RecordDeleted, 'N') = 'N' AND ISNULL(S.RecordDeleted, 'N') = 'N'
				JOIN DocumentCodes DC ON S.DocumentCodeId = DC.DocumentCodeId AND ISNULL(DC.Active, 'N') = 'Y' AND ISNULL(DC.RecordDeleted, 'N') = 'N'
				WHERE S.DocumentCodeId = @DocumentCodeId
					AND DC.DocumentCodeId = @DocumentCodeId
			END
			ELSE
			BEGIN
				SET @Return = ''
				SELECT TOP 1 @Return = CAST(sr.ScreenType AS VARCHAR(50)) + ',' + CAST(sr.ScreenId AS VARCHAR(50)) + ',"DocumentId='+CAST(d.DocumentId AS VARCHAR(50))+'^ClientId='+CAST(@ClientId AS VARCHAR(50))+'^MoreDetail=Y",'+ CAST(ISNULL(sr.TabId,'') AS VARCHAR(50)) + '|' + dc.DocumentName+ ' (Document)'
				FROM GroupStandAloneDocuments gsad
				INNER JOIN Documents d ON gsad.DocumentId = d.DocumentId AND gsad.ClientId = d.ClientId
				INNER JOIN DocumentCodes dc ON dc.DocumentCodeId = d.DocumentCodeId
				INNER JOIN GlobalCodes gcs ON gcs.GlobalCodeId = d.CurrentVersionStatus
				INNER JOIN Staff a ON a.StaffId = d.AuthorId
				INNER JOIN Screens sr ON d.DocumentCodeId = sr.DocumentCodeId
				WHERE gsad.ClientId = @ClientId
					AND gsad.ServiceId = @ServiceId
					AND isnull(d.RecordDeleted, 'N') = 'N'
					AND isnull(sr.RecordDeleted, 'N') = 'N'
					AND isnull(gsad.RecordDeleted, 'N') = 'N'	
					AND d.DocumentCodeId = @DocumentCodeId
					--AND CAST(d.EffectiveDate AS DATE) = CAST(@Date AS DATE)
					AND d.[Status] = 22
					AND gsad.StaffId = @CurrentUserId
				ORDER BY d.ModifiedDate DESC
				
				IF ISNULL(@Return,'') = ''
				BEGIN
					SELECT TOP 1 @Return = CAST(sr.ScreenType AS VARCHAR(50)) + ',' + CAST(sr.ScreenId AS VARCHAR(50)) + ',"DocumentId='+CAST(d.DocumentId AS VARCHAR(50))+'^ClientId='+CAST(@ClientId AS VARCHAR(50))+'^MoreDetail=N",'+ CAST(ISNULL(sr.TabId,'') AS VARCHAR(50)) + '|' + dc.DocumentName+ ' (Document)'
					FROM GroupStandAloneDocuments gsad
					INNER JOIN Documents d ON gsad.DocumentId = d.DocumentId AND gsad.ClientId = d.ClientId
					INNER JOIN DocumentCodes dc ON dc.DocumentCodeId = d.DocumentCodeId
					INNER JOIN GlobalCodes gcs ON gcs.GlobalCodeId = d.CurrentVersionStatus
					INNER JOIN Staff a ON a.StaffId = d.AuthorId
					INNER JOIN Screens sr ON d.DocumentCodeId = sr.DocumentCodeId
					WHERE gsad.ClientId = @ClientId
						AND gsad.ServiceId = @ServiceId
						AND gsad.GroupId = @GroupId
						AND isnull(d.RecordDeleted, 'N') = 'N'
						AND isnull(sr.RecordDeleted, 'N') = 'N'
						AND isnull(gsad.RecordDeleted, 'N') = 'N'	
						AND d.DocumentCodeId = @DocumentCodeId
						--AND CAST(d.EffectiveDate AS DATE) = CAST(@Date AS DATE)
						AND d.[Status] <> 23
						AND gsad.StaffId = @CurrentUserId
					ORDER BY d.ModifiedDate DESC
				END
				
				IF ISNULL(@Return,'') = ''
				BEGIN
					SELECT TOP 1 @Return = CAST(@ServiceId AS VARCHAR(50)) + '|' + DC.DocumentName+ ' (ConnectDocument)'
					FROM Banners B
					JOIN Screens S ON B.ScreenId = S.ScreenId AND ISNULL(B.Active, 'N') = 'Y' AND ISNULL(B.RecordDeleted, 'N') = 'N' AND ISNULL(S.RecordDeleted, 'N') = 'N'
					JOIN DocumentCodes DC ON S.DocumentCodeId = DC.DocumentCodeId AND ISNULL(DC.Active, 'N') = 'Y' AND ISNULL(DC.RecordDeleted, 'N') = 'N'
					WHERE S.DocumentCodeId = @DocumentCodeId
						AND DC.DocumentCodeId = @DocumentCodeId
				END
			END		 	 
		END	
		ELSE IF ISNULL(@ScreenId,0) > 0
		BEGIN
			IF @PageNumber = -1
			BEGIN
				SELECT TOP 1 @Return = B.DisplayAs + ' (Screen)'
				FROM Banners B
				JOIN Screens S ON B.ScreenId = S.ScreenId
					AND ISNULL(B.Active, 'N') = 'Y'
					AND ISNULL(B.RecordDeleted, 'N') = 'N'
					AND ISNULL(S.RecordDeleted, 'N') = 'N'
				WHERE B.ScreenId = @ScreenId
					AND S.ScreenId = @ScreenId
			END
			ELSE
			BEGIN
				SELECT TOP 1 @Return = CAST(S.ScreenType AS VARCHAR(50)) + ',' + CAST(S.ScreenId AS VARCHAR(50)) + CASE WHEN ISNULL(S.TabId,0) = 2 THEN ',"ClientId='+CAST(@ClientId AS VARCHAR(50))+'^DocumentNavigationName=' + B.DisplayAs + '",' ELSE ',"DocumentNavigationName=' + B.DisplayAs + '",' END + CAST(S.TabId AS VARCHAR(50)) + '|' + B.DisplayAs + ' (Screen)'
				FROM Banners B
				JOIN Screens S ON B.ScreenId = S.ScreenId
					AND ISNULL(B.Active, 'N') = 'Y'
					AND ISNULL(B.RecordDeleted, 'N') = 'N'
					AND ISNULL(S.RecordDeleted, 'N') = 'N'
				WHERE B.ScreenId = @ScreenId
					AND S.ScreenId = @ScreenId
			END
			
		END
	END

	RETURN @Return
END

GO


