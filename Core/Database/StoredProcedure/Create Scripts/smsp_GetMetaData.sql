/****** Object:  StoredProcedure [dbo].[smsp_GetMetaData]    Script Date: 09/27/2017 15:40:56 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[smsp_GetMetaData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[smsp_GetMetaData]
GO


/****** Object:  StoredProcedure [dbo].[smsp_GetMetaData]    Script Date: 09/27/2017 15:40:56 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[smsp_GetMetaData]  @ClientId INT = null
, @Text VARCHAR(100) = null
, @Type VARCHAR(10) = null
, @FromDate DATETIME = null
, @ToDate DATETIME = null
, @JsonResult VARCHAR(MAX) OUTPUT
AS
-- =============================================      
-- Author:  Vijay      
-- Create date: Oct 04, 2017      
-- Description: Retrieves MetaData details
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
					IF @Text = 'VitalSignsMeta'
						BEGIN	
							SELECT @JsonResult = dbo.smsf_FlattenedJSON((
								SELECT DISTINCT c.ClientId
							  ,'' AS VersionId    -- Version specific identifier
							  ,'' AS LastUpdated  -- When the resource version last changed
							  ,'' AS [Profile]	   -- Profiles this resource claims to conform to
							  --,'' AS [Security]	   -- Security Labels applied to this resource
							  --,'' AS Tag		   -- Tags applied to this resource  
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
					IF @Text = 'VitalSignsMeta'
					  BEGIN	
						SELECT @JsonResult = dbo.smsf_FlattenedJSON((
								SELECT DISTINCT c.ClientId
							  ,'' AS VersionId    -- Version specific identifier
							  ,'' AS LastUpdated  -- When the resource version last changed
							  ,'' AS [Profile]	   -- Profiles this resource claims to conform to
							  --,'' AS [Security]	   -- Security Labels applied to this resource
							  --,'' AS Tag		   -- Tags applied to this resource  
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

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'smsp_GetMetaData') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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