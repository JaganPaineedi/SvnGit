/****** Object:  StoredProcedure [dbo].[smsp_GetTelecom]    Script Date: 09/27/2017 15:50:03 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[smsp_GetTelecom]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[smsp_GetTelecom]
GO


/****** Object:  StoredProcedure [dbo].[smsp_GetTelecom]    Script Date: 09/27/2017 15:50:03 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[smsp_GetTelecom]  @ClientId INT = null
, @Text VARCHAR(100) = null
, @Type VARCHAR(10) = null
, @FromDate DATETIME = null
, @ToDate DATETIME = null
, @JsonResult VARCHAR(MAX) OUTPUT
AS
-- =============================================      
-- Author:  Vijay      
-- Create date: Sept 27, 2017      
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
			IF @Type = 'Inpatient'
				BEGIN	
					IF @Text = 'DemographicTelecom'
						BEGIN	
							SELECT @JsonResult = dbo.smsf_FlattenedJSON((
								SELECT DISTINCT c.ClientId
							  --resourceType : ContactPoint		  
							  ,'' AS [System]	-- phone | fax | email | pager | url | sms | other
							  ,cp.PhoneNumber AS Value	-- The actual contact point details
							  ,gc.CodeName AS [Use]	-- home | work | temp | old | mobile - purpose of this contact point
							  ,CASE cp.IsPrimary
									WHEN 'Y'
										THEN '1'
									WHEN 'N'
										THEN '2'
									ELSE '0'
									END AS [Rank]	-- Specify preferred order of use (1 = highest)
							  ,cp.CreatedDate AS Start	-- Time period when the contact point was/is in use
							  ,cp.DeletedDate AS [End]		  
							FROM Clients c
							LEFT JOIN ClientPhones cp ON cp.ClientId = c.ClientId
							LEFT JOIN GlobalCodes gc ON gc.GlobalCodeId = cp.PhoneType
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
						ELSE IF @Text = 'DemographicContactPersonTelecom'
						BEGIN	
							SELECT @JsonResult = dbo.smsf_FlattenedJSON((
								SELECT DISTINCT c.ClientId
								  --resourceType : ContactPoint		  
								  ,'' AS [System]	-- phone | fax | email | pager | url | sms | other
								  ,cp.PhoneNumber AS Value	-- The actual contact point details
								  ,gc.CodeName AS [Use]	-- home | work | temp | old | mobile - purpose of this contact point
								  ,0 AS [Rank]	-- Specify preferred order of use (1 = highest)
								  ,cp.CreatedDate AS Start	-- Time period when the contact point was/is in use
								  ,cp.DeletedDate AS [End]	  
								FROM Clients c
								LEFT JOIN ClientContacts cc on cc.ClientId = c.ClientId
								LEFT JOIN ClientContactPhones cp ON cp.ClientContactId = cc.ClientContactId
								LEFT JOIN GlobalCodes gc ON gc.GlobalCodeId = cp.PhoneType
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
						ELSE IF @Text = 'UniqueDeviceIdentifierContact'
						BEGIN	
							SELECT @JsonResult = dbo.smsf_FlattenedJSON((
								SELECT DISTINCT c.ClientId
							  --resourceType : ContactPoint		  
							  ,'' AS [System]	-- phone | fax | email | pager | url | sms | other
							  ,'' AS Value	-- The actual contact point details
							  ,'' AS [Use]	-- home | work | temp | old | mobile - purpose of this contact point
							  ,0 AS [Rank]	-- Specify preferred order of use (1 = highest)
							  ,'' AS Start	-- Time period when the contact point was/is in use
							  ,'' AS [End]		  
							FROM Clients c
							LEFT JOIN ClientPhones cp ON cp.ClientId = c.ClientId
							LEFT JOIN GlobalCodes gc ON gc.GlobalCodeId = cp.PhoneType
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
					IF @Text = 'DemographicTelecom'
					  BEGIN	
						SELECT @JsonResult = dbo.smsf_FlattenedJSON((
								SELECT DISTINCT c.ClientId
							  ,'' AS [System]	-- phone | fax | email | pager | url | sms | other
							  ,cp.PhoneNumber AS Value	-- The actual contact point details
							  ,gc.CodeName AS [Use]	-- home | work | temp | old | mobile - purpose of this contact point
							  ,CASE cp.IsPrimary
									WHEN 'Y'
										THEN '1'
									WHEN 'N'
										THEN '2'
									ELSE '0'
									END AS [Rank]	-- Specify preferred order of use (1 = highest)
							  ,cp.CreatedDate AS Start	-- Time period when the contact point was/is in use
							  ,cp.DeletedDate AS [End]		  
							FROM Clients c
							LEFT JOIN ClientPhones cp ON cp.ClientId = c.ClientId
							LEFT JOIN GlobalCodes gc ON gc.GlobalCodeId = cp.PhoneType
							LEFT JOIN [Services] s ON (s.ClientId = c.ClientId AND (s.DateOfService >= @fromDate and s.EndDateOfService <= @toDate))
							WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)		
							AND c.Active = 'Y' 
							AND ISNULL(c.RecordDeleted,'N')='N'	
							FOR XML path
							,ROOT
							))
						END
						ELSE IF @Text = 'DemographicContactPersonTelecom'
						BEGIN	
							SELECT @JsonResult = dbo.smsf_FlattenedJSON((
								SELECT DISTINCT c.ClientId
								  --resourceType : ContactPoint		  
								  ,'' AS [System]	-- phone | fax | email | pager | url | sms | other
								  ,cp.PhoneNumber AS Value	-- The actual contact point details
								  ,gc.CodeName AS [Use]	-- home | work | temp | old | mobile - purpose of this contact point
								  ,0 AS [Rank]	-- Specify preferred order of use (1 = highest)
								  ,cp.CreatedDate AS Start	-- Time period when the contact point was/is in use
								  ,cp.DeletedDate AS [End]	  
								FROM Clients c
								LEFT JOIN ClientContacts cc on cc.ClientId = c.ClientId
								LEFT JOIN ClientContactPhones cp ON cp.ClientContactId = cc.ClientContactId
								LEFT JOIN GlobalCodes gc ON gc.GlobalCodeId = cp.PhoneType
								LEFT JOIN [Services] s ON (s.ClientId = c.ClientId AND (s.DateOfService >= @fromDate and s.EndDateOfService <= @toDate))
								WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)		
								AND c.Active = 'Y' 
								AND ISNULL(c.RecordDeleted,'N')='N'	
							FOR XML path
							,ROOT
							))
						END
						ELSE IF @Text = 'UniqueDeviceIdentifierContact'
						BEGIN	
							SELECT @JsonResult = dbo.smsf_FlattenedJSON((
								SELECT DISTINCT c.ClientId
							   --resourceType : ContactPoint		  
							  ,'' AS [System]	-- phone | fax | email | pager | url | sms | other
							  ,'' AS Value	-- The actual contact point details
							  ,'' AS [Use]	-- home | work | temp | old | mobile - purpose of this contact point
							  ,0 AS [Rank]	-- Specify preferred order of use (1 = highest)
							  ,'' AS Start	-- Time period when the contact point was/is in use
							  ,'' AS [End]		  
							FROM Clients c
							LEFT JOIN ClientPhones cp ON cp.ClientId = c.ClientId
							LEFT JOIN GlobalCodes gc ON gc.GlobalCodeId = cp.PhoneType
							LEFT JOIN [Services] s ON (s.ClientId = c.ClientId AND (s.DateOfService >= @fromDate and s.EndDateOfService <= @toDate))
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

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'smsp_GetTelecom') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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


