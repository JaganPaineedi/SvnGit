/****** Object:  StoredProcedure [dbo].[smsp_GetAttachment]    Script Date: 09/27/2017 15:30:23 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[smsp_GetAttachment]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[smsp_GetAttachment]
GO


/****** Object:  StoredProcedure [dbo].[smsp_GetAttachment]    Script Date: 09/27/2017 15:30:23 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[smsp_GetAttachment]  @ClientId INT = null
, @Text VARCHAR(100) = null
, @Type VARCHAR(10) = null
, @FromDate DATETIME = null
, @ToDate DATETIME = null
, @JsonResult VARCHAR(MAX) OUTPUT
AS
-- =============================================      
-- Author:  Vijay      
-- Create date: Sept 27, 2017      
-- Description: Retrieves Attachment details
-- Task:   MUS3 - Task#30 Application Access - Patient Selection (G7)        
/*      
 Author			Modified Date			Reason     
*/
-- =============================================         
BEGIN
	BEGIN TRY
	
	SET NOCOUNT ON
	
		IF @ClientId IS NOT NULL
		BEGIN
			IF @Type = 'Inpatient'
				BEGIN	
					IF @Text = 'DemographicPhoto'
						BEGIN	
							SELECT @JsonResult = dbo.smsf_FlattenedJSON((
								SELECT DISTINCT c.ClientId
								,'' AS ContentType   --Mime type of the content, with charset etc. 
								,'' AS [Language]   --Human language of the content (BCP-47)
								,'' AS Data   --Data inline, base64ed
								,'' AS Url   --Uri where the data can be found
								,0 AS Size  --Number of bytes of content (if url provided)
								,'' AS [Hash]  --Hash of the data (sha-1, base64ed)
								,'' AS Title   --Label to display in place of the data
								,'' AS Creation 	  
							FROM Clients c
							LEFT JOIN [Services] s ON (s.ClientId = c.ClientId AND (s.DateOfService >= @fromDate and s.EndDateOfService <= @toDate))
							LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId
							LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId AND (ba.StartDate >= @fromDate and ba.EndDate <= @toDate))	
							WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)		
							AND c.Active = 'Y' 
							AND ISNULL(c.RecordDeleted,'N')='N'	
							FOR XML path
							,ROOT
							))
						END
						ELSE IF @Text = 'CurrentMedicationsImage'
						BEGIN	
							SELECT @JsonResult = dbo.smsf_FlattenedJSON((
								SELECT DISTINCT c.ClientId
								,'' AS ContentType   --Mime type of the content, with charset etc. 
								,'' AS [Language]   --Human language of the content (BCP-47)
								,'' AS Data   --Data inline, base64ed
								,'' AS Url   --Uri where the data can be found
								,0 AS Size  --Number of bytes of content (if url provided)
								,'' AS [Hash]  --Hash of the data (sha-1, base64ed)
								,'' AS Title   --Label to display in place of the data
								,'' AS Creation 	  
							FROM Clients c
							LEFT JOIN [Services] s ON (s.ClientId = c.ClientId AND (s.DateOfService >= @fromDate and s.EndDateOfService <= @toDate))
							LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId
							LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId AND (ba.StartDate >= @fromDate and ba.EndDate <= @toDate))	
							WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)		
							AND c.Active = 'Y' 
							AND ISNULL(c.RecordDeleted,'N')='N'	
							FOR XML path
							,ROOT
							))
						END
						ELSE IF @Text = 'LaboratoryTestsPresentedForm'
						BEGIN	
							SELECT @JsonResult = dbo.smsf_FlattenedJSON((
								SELECT DISTINCT c.ClientId
								,'' AS ContentType   --Mime type of the content, with charset etc. 
								,'' AS [Language]   --Human language of the content (BCP-47)
								,'' AS Data   --Data inline, base64ed
								,'' AS Url   --Uri where the data can be found
								,0 AS Size  --Number of bytes of content (if url provided)
								,'' AS [Hash]  --Hash of the data (sha-1, base64ed)
								,'' AS Title   --Label to display in place of the data
								,'' AS Creation 	  
							FROM Clients c
							LEFT JOIN [Services] s ON (s.ClientId = c.ClientId AND (s.DateOfService >= @fromDate and s.EndDateOfService <= @toDate))
							LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId
							LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId AND (ba.StartDate >= @fromDate and ba.EndDate <= @toDate))	
							WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)		
							AND c.Active = 'Y' 
							AND ISNULL(c.RecordDeleted,'N')='N'	
							FOR XML path
							,ROOT
							))
						END
						
					END
			ELSE IF @Type = 'Outpatient'
				BEGIN
					IF @Text = 'DemographicPhoto'
					  BEGIN	
						SELECT @JsonResult = dbo.smsf_FlattenedJSON((
								SELECT DISTINCT c.ClientId
							 	,'' AS ContentType   --Mime type of the content, with charset etc. 
								,'' AS [Language]   --Human language of the content (BCP-47)
								,'' AS Data   --Data inline, base64ed
								,'' AS Url   --Uri where the data can be found
								,0 AS Size  --Number of bytes of content (if url provided)
								,'' AS [Hash]  --Hash of the data (sha-1, base64ed)
								,'' AS Title   --Label to display in place of the data
								,'' AS Creation 	  		  
							FROM Clients c
							LEFT JOIN [Services] s ON (s.ClientId = c.ClientId AND (s.DateOfService >= @fromDate and s.EndDateOfService <= @toDate))
							--LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId
							--LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId AND (ba.StartDate >= @fromDate and ba.EndDate <= @toDate))	
							WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)		
							AND c.Active = 'Y' 
							AND ISNULL(c.RecordDeleted,'N')='N'	
							FOR XML path
							,ROOT
							))
						END
						ELSE IF @Text = 'CurrentMedicationsImage'
						BEGIN	
							SELECT @JsonResult = dbo.smsf_FlattenedJSON((
								SELECT DISTINCT c.ClientId
								,'' AS ContentType   --Mime type of the content, with charset etc. 
								,'' AS [Language]   --Human language of the content (BCP-47)
								,'' AS Data   --Data inline, base64ed
								,'' AS Url   --Uri where the data can be found
								,0 AS Size  --Number of bytes of content (if url provided)
								,'' AS [Hash]  --Hash of the data (sha-1, base64ed)
								,'' AS Title   --Label to display in place of the data
								,'' AS Creation 	  
							FROM Clients c
							LEFT JOIN [Services] s ON (s.ClientId = c.ClientId AND (s.DateOfService >= @fromDate and s.EndDateOfService <= @toDate))
							LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId
							LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId AND (ba.StartDate >= @fromDate and ba.EndDate <= @toDate))	
							WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)		
							AND c.Active = 'Y' 
							AND ISNULL(c.RecordDeleted,'N')='N'	
							FOR XML path
							,ROOT
							))
						END
						ELSE IF @Text = 'LaboratoryTestsPresentedForm'
						BEGIN	
							SELECT @JsonResult = dbo.smsf_FlattenedJSON((
								SELECT DISTINCT c.ClientId
								,'' AS ContentType   --Mime type of the content, with charset etc. 
								,'' AS [Language]   --Human language of the content (BCP-47)
								,'' AS Data   --Data inline, base64ed
								,'' AS Url   --Uri where the data can be found
								,0 AS Size  --Number of bytes of content (if url provided)
								,'' AS [Hash]  --Hash of the data (sha-1, base64ed)
								,'' AS Title   --Label to display in place of the data
								,'' AS Creation 	  
							FROM Clients c
							LEFT JOIN [Services] s ON (s.ClientId = c.ClientId AND (s.DateOfService >= @fromDate and s.EndDateOfService <= @toDate))
							LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId
							LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId AND (ba.StartDate >= @fromDate and ba.EndDate <= @toDate))	
							WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)		
							AND c.Active = 'Y' 
							AND ISNULL(c.RecordDeleted,'N')='N'	
							FOR XML path
							,ROOT
							))
						END
					END
			END
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'smsp_GetAttachment') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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


