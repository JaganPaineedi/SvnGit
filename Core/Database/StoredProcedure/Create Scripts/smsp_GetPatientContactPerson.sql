/****** Object:  StoredProcedure [dbo].[smsp_GetPatientContactPerson]    Script Date: 09/27/2017 15:42:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[smsp_GetPatientContactPerson]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[smsp_GetPatientContactPerson]
GO


/****** Object:  StoredProcedure [dbo].[smsp_GetPatientContactPerson]    Script Date: 09/27/2017 15:42:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[smsp_GetPatientContactPerson]  @ClientId INT
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
				SELECT @JsonResult = dbo.smsf_FlattenedJSON((
					SELECT c.ClientId
						--,cc.ClientContactId
						--,gcr.CodeName AS Relationship --BP	Billing contact person
						--,cc.LastName +' '+cc.FirstName AS Name
						--,'' AS Telecom
						--,'' AS Address
						,CASE cc.Sex
							WHEN 'M'
								THEN 'Male'
							WHEN 'F'
								THEN 'Female'
							ELSE 'Unknown'
							END AS Gender
						,cc.Organization AS Organization
						,cc.CreatedDate AS Start	--Period
						,cc.DeletedDate AS [End]	--Period
					FROM Clients c
					JOIN ClientContacts cc ON cc.ClientId = c.ClientId
					LEFT JOIN GlobalCodes gcr ON gcr.GlobalCodeId = cc.RelationShip
					LEFT JOIN [Services] s ON (s.ClientId = c.ClientId AND (s.DateOfService >= @fromDate and s.EndDateOfService <= @toDate))
					WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)		
					AND c.Active = 'Y' 
					AND ISNULL(c.RecordDeleted,'N')='N'	
					FOR XML path
					,ROOT
					))					
			END
		
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'smsp_GetPatientContactPerson') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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


