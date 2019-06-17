/****** Object:  UserDefinedFunction [dbo].[ssf_SCAttendanceDocumentStatus]    Script Date: 05/12/2015 12:21:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssf_SCAttendanceDocumentStatus]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[ssf_SCAttendanceDocumentStatus]
GO

/****** Object:  UserDefinedFunction [dbo].[ssf_SCAttendanceDocumentStatus]    Script Date: 05/12/2015 12:21:48 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
  
CREATE FUNCTION [dbo].[ssf_SCAttendanceDocumentStatus] (@ServiceId INT,@Date DATETIME,@ScreenId INT,@GroupNoteType INT,@ClientId INT,@ClientName VARCHAR(250), @GroupId INT,@GroupNoteDocumentCodeId INT,@GroupName VARCHAR(250),@PageNumber INT,@CurrentUserId INT)
/********************************************************************************    
-- Stored Procedure: dbo.ssf_SCAttendanceDocumentStatus      
--    
-- Copyright: Streamline Healthcate Solutions 
--    
-- Updates:                                                           
-- Date			 Author			Purpose    
-- 22-Feb-2016	 Akwinass		What:To check associated document is signed or not.          
--								Why:task #167 Valley - Support Go Live
-- 22-Feb-2016	 Akwinass		What:Included @ServiceId.          
--								Why:task #167 Valley - Support Go Live
-- 29-Feb-2016	 Akwinass		What:Commented DocumentCodeId Check for GroupNotes.          
--								Why:task #167 Valley - Support Go Live
-- 13-APRIL-2016 Akwinass		What:Modified logic based on @GroupNoteType.          
--								Why:task #167.1 Valley - Support Go Live
-- 14-APRIL-2016 Akwinass	    What:Modified based on GroupStandAloneDocuments      
--							    Why:task #167.1 Valley - Support Go Live 
--02/10/2017      jcarlson       Keystone Customizations 69 - increased @ProcedureCode length to 500 to handle procedure code display as increasing to 75 
-- 16-JAN-2018   Akwinass	    What: @GroupServiceId check implemented and Modified code to check document signed status if the same client has more than one service on the same group service.    
--							    Why: Not displaying signed symbol on Attendance list page (task #55 Boundless - Support)
*********************************************************************************/ 
RETURNS VARCHAR(max)
AS
BEGIN
	DECLARE @Return NVARCHAR(max)	
	DECLARE @ProcedureCode VARCHAR(500)
	
	IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[scsf_SCAttendanceDocumentStatus]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	BEGIN
		SET @Return = dbo.scsf_SCAttendanceDocumentStatus(@ServiceId,@Date,@ScreenId,@GroupNoteType,@ClientId,@ClientName,@GroupId,@GroupNoteDocumentCodeId,@GroupName,@PageNumber,@CurrentUserId)
	END
	ELSE
	BEGIN
		DECLARE @FUNService Table(ServiceId int)
		IF ISNULL(@GroupNoteDocumentCodeId,0) > 0 AND @GroupNoteType = 9383
		BEGIN
		   DECLARE @GroupServiceId INT   
		   SELECT TOP 1 @GroupServiceId = GroupServiceId FROM Services where ServiceId = @ServiceId
   
		   INSERT INTO @FUNService(s.ServiceId)
		   SELECT DISTINCT s.ServiceId
		   FROM GroupServices gs  
		   LEFT JOIN Groups g ON g.GroupId = gs.GroupId AND ISNULL(g.RecordDeleted, 'N') = 'N'  
		   LEFT JOIN GlobalCodes gc ON gc.GlobalCodeId = g.GroupType AND ISNULL(gc.RecordDeleted, 'N') = 'N'  
		   LEFT JOIN Programs p ON p.ProgramId = gs.ProgramId AND ISNULL(p.RecordDeleted, 'N') = 'N'  
		   JOIN Services s ON s.GroupServiceId = gs.GroupServiceId AND ISNULL(s.RecordDeleted, 'N') = 'N' AND s.GroupServiceId =  @GroupServiceId
		   JOIN Documents d ON d.ServiceId = s.ServiceId AND ISNULL(d.RecordDeleted, 'N') = 'N' 
		   JOIN ProcedureCodes ON ProcedureCodes.ProcedureCodeId = s.ProcedureCodeId  
		   LEFT JOIN GroupServiceStaff ON GroupServiceStaff.GroupServiceId = gs.GroupServiceId AND ISNULL(GroupServiceStaff.RecordDeleted, 'N') = 'N'  
		   CROSS APPLY [dbo].[ssf_SCGetGroupServiceStatus](gs.GroupServiceId) svcstatus  
		   LEFT OUTER JOIN dbo.GlobalCodes svcstatusgc ON svcstatusgc.GlobalCodeId = svcstatus.[Status] AND ISNULL(svcstatusgc.RecordDeleted, 'N') = 'N'  
		   WHERE ISNULL(gs.RecordDeleted, 'N') = 'N' AND s.[Status] <> 76 AND gs.GroupId = @GroupId AND s.ClientId = @ClientId 
		END
		
		IF ISNULL(@ServiceId,0) > 0 AND ISNULL(@GroupNoteType,0) = 9383 AND ISNULL(@ScreenId,0) = 0 AND ISNULL(@GroupNoteDocumentCodeId,0) > 0
		BEGIN		
		   SET @Return = ''  
		   SELECT TOP 1 @Return = 'none'  
		   FROM Documents d  
		   INNER JOIN DocumentCodes dc ON dc.DocumentCodeId = d.DocumentCodeId  
		   INNER JOIN GlobalCodes gcs ON gcs.GlobalCodeId = CASE WHEN (d.AuthorId = @CurrentUserId OR d.ReviewerId = @CurrentUserId) THEN d.CurrentVersionStatus ELSE d.[Status] END  
		   INNER JOIN Staff a ON a.StaffId = d.AuthorId
		   WHERE EXISTS(SELECT 1 FROM @FUNService FS WHERE FS.ServiceId = d.ServiceId)
			AND isnull(d.RecordDeleted, 'N') = 'N'
			AND CAST(d.EffectiveDate AS DATE) = CAST(@Date AS DATE)  
			AND d.[Status] NOT IN (22,23,26)
		   ORDER BY d.ModifiedDate DESC
		   
		   IF ISNULL(@Return,'') = ''
		   BEGIN
			   SELECT TOP 1 @Return = 'block'  
			   FROM Documents d  
			   INNER JOIN DocumentCodes dc ON dc.DocumentCodeId = d.DocumentCodeId  
			   INNER JOIN GlobalCodes gcs ON gcs.GlobalCodeId = CASE WHEN (d.AuthorId = @CurrentUserId OR d.ReviewerId = @CurrentUserId) THEN d.CurrentVersionStatus ELSE d.[Status] END  
			   INNER JOIN Staff a ON a.StaffId = d.AuthorId
			   WHERE EXISTS(SELECT 1 FROM @FUNService FS WHERE FS.ServiceId = d.ServiceId)
				AND isnull(d.RecordDeleted, 'N') = 'N'
				AND CAST(d.EffectiveDate AS DATE) = CAST(@Date AS DATE)  
				AND d.[Status] = 22		
			   ORDER BY d.ModifiedDate DESC
		   END 
		END
		ELSE
		BEGIN
			DECLARE @DocumentCodeId INT = 0
			IF ISNULL(@GroupNoteType,0) = 9384 OR ISNULL(@GroupNoteType,0) = 9385
			BEGIN
				SELECT TOP 1 @DocumentCodeId = ServiceNoteCodeId
				FROM GroupNoteDocumentCodes
				WHERE GroupNoteDocumentCodeId = @GroupNoteDocumentCodeId
					AND ISNULL(Active, 'N') = 'Y'
					AND ISNULL(RecordDeleted, 'N') = 'N'
			END	
			
			IF ISNULL(@DocumentCodeId,0) > 0
			BEGIN
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
					SET @Return = 'none'
					SELECT TOP 1 @Return = 'block'
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
						AND d.[Status] = 22
						AND gsad.StaffId = @CurrentUserId
					ORDER BY d.ModifiedDate DESC	
				END		 	 
			END	
			ELSE IF ISNULL(@ScreenId,0) > 0
			BEGIN
				SET @Return = 'none'			
			END
		END
	END

	IF ISNULL(@Return,'') = ''
	BEGIN
		SET @Return = 'none'
	END
	
	RETURN @Return
END

GO


