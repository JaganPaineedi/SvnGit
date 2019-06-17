/****** Object:  StoredProcedure [dbo].[smsp_GetHumanName]    Script Date: 09/27/2017 15:34:04 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[smsp_GetHumanName]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[smsp_GetHumanName]
GO


/****** Object:  StoredProcedure [dbo].[smsp_GetHumanName]    Script Date: 09/27/2017 15:34:04 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[smsp_GetHumanName]  @ClientId INT
, @Text VARCHAR(100)
, @Type VARCHAR(10)
, @FromDate DATETIME
, @ToDate DATETIME
, @JsonResult VARCHAR(MAX) OUTPUT
AS
-- =============================================      
-- Author:  Vijay      
-- Create date: Oct 04, 2017      
-- Description: Retrieves Patient details
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
			IF @Text = 'DemographicHumanName'
				BEGIN		
					SELECT @JsonResult = dbo.smsf_FlattenedJSON((
					SELECT DISTINCT c.ClientId
						  ,'official' AS [Use]			-- usual | official | temp | nickname | anonymous | old | maiden
						  ,ISNULL(c.FirstName,'')+' '+ISNULL(c.LastName,'') AS [Text]	 -- Text representation of the full name
						  ,'' AS Family	 -- Family name (often called 'Surname')
						  ,ISNULL(c.FirstName,'')+' '+ISNULL(c.MiddleName,'')+' '+ISNULL(c.LastName,'') AS Given -- Given names (not always 'first'). Includes middle names
						  ,c.Prefix AS Prefix	 -- Parts that come before the name
						  ,c.Suffix AS Suffix	 -- Parts that come after the name
						  ,c.CreatedDate AS Start	-- Time period when name was/is in use
						  ,c.DeletedDate AS [End]	-- Time period when name was/is in use
						FROM Clients c
						LEFT JOIN [Services] s ON (s.ClientId = c.ClientId AND (s.DateOfService >= @fromDate and s.EndDateOfService <= @toDate))
						WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)		
						AND c.Active = 'Y' 
						AND ISNULL(c.RecordDeleted,'N')='N'	
					FOR XML path
					,ROOT
					))
			END
			ELSE IF @Text = 'DemographicContactPersonHumanName'
			BEGIN
				SELECT @JsonResult = dbo.smsf_FlattenedJSON((
				SELECT DISTINCT c.ClientId
					  ,'official' AS [Use]			-- usual | official | temp | nickname | anonymous | old | maiden
					  ,cc.FirstName+' '+cc.LastName AS [Text]	 -- Text representation of the full name
					  ,'' AS Family	 -- Family name (often called 'Surname')
					  ,cc.FirstName+' '+ISNULL(c.MiddleName,'')+' '+cc.LastName AS Given -- Given names (not always 'first'). Includes middle names
					  ,cc.Prefix AS Prefix	 -- Parts that come before the name
					  ,cc.Suffix AS Suffix	 -- Parts that come after the name
					  ,cc.CreatedDate AS Start	-- Time period when name was/is in use
					  ,cc.DeletedDate AS [End]	-- Time period when name was/is in use
					FROM Clients c
					LEFT JOIN ClientContacts cc ON cc.ClientId = c.ClientId
					LEFT JOIN [Services] s ON (s.ClientId = c.ClientId AND (s.DateOfService >= @fromDate and s.EndDateOfService <= @toDate))
					WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)		
					AND c.Active = 'Y' 
					AND ISNULL(c.RecordDeleted,'N')='N'	
				FOR XML path
				,ROOT
				))
			END	
		END			
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'smsp_GetHumanName') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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


