/****** Object:  StoredProcedure [dbo].[ssp_CCRCSHealthCareProviders]    Script Date: 06/09/2015 03:48:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_CCRCSHealthCareProviders]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[ssp_CCRCSHealthCareProviders] @ClientId BIGINT
	,@ServiceID INT
	,@DocumentVersionId INT
AS
-- =============================================      
-- Author:  Pradeep      
-- Create date: Sept 23, 2014      
-- Description: Retrieves CCR HealthCareProviders Data      
/*      
 Author			Modified Date			Reason      
   
      
*/
-- =============================================      
BEGIN
	BEGIN TRY
		SELECT ''PrimaryPhysician'' AS ActorID
			,SS.LastName + '', '' + SS.FirstName AS ActorRole
		FROM Clients C
		LEFT JOIN staff SS ON SS.StaffId = C.PrimaryPhysicianId
		WHERE C.ClientId = @ClientId
		
		UNION
		
		SELECT ''PhysicianPhone'' AS ActorID
			,CASE 
				WHEN (NULLIF(SS.PhoneNumber, '''') IS NOT NULL)
					THEN CASE 
							WHEN SUBSTRING(SS.PhoneNumber, 1, 1) = ''(''
								THEN SS.PhoneNumber
							ELSE (
									''( '' + (
										SELECT LEFT(SS.PhoneNumber, 3)
										) + '' ) '' + (
										SELECT SUBSTRING(SS.PhoneNumber, 4, 3)
										) + '' - '' + (
										SELECT SUBSTRING(SS.PhoneNumber, 7, LEN(SS.PhoneNumber))
										)
									)
							END
				ELSE ''''
				END AS ActorRole
		FROM Clients C
		LEFT JOIN staff SS ON SS.StaffId = C.PrimaryPhysicianId
		WHERE C.ClientId = @ClientId
		
		UNION
		
		SELECT ''PrimaryClinician'' AS ActorID
			,SSS.LastName + '', '' + SSS.FirstName AS ActorRole
		FROM Clients C
		LEFT JOIN staff SSS ON SSS.StaffId = C.PrimaryClinicianId
		WHERE C.ClientId = @ClientId
		
		UNION
		
		SELECT ''ClinicianPhone'' AS ActorID
			,CASE 
				WHEN (NULLIF(SSS.PhoneNumber, '''') IS NOT NULL)
					THEN CASE 
							WHEN SUBSTRING(SSS.PhoneNumber, 1, 1) = ''(''
								THEN SSS.PhoneNumber
							ELSE (
									''( '' + (
										SELECT LEFT(SSS.PhoneNumber, 3)
										) + '' ) '' + (
										SELECT SUBSTRING(SSS.PhoneNumber, 4, 3)
										) + '' - '' + (
										SELECT SUBSTRING(SSS.PhoneNumber, 7, LEN(SSS.PhoneNumber))
										)
									)
							END
				ELSE ''''
				END AS ActorRole
		FROM Clients C
		LEFT JOIN staff SSS ON SSS.StaffId = C.PrimaryClinicianId
		WHERE C.ClientId = @ClientId
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + ''*****'' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + ''*****'' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), ''ssp_CCRCSHealthCareProviders'') + ''*****'' + CONVERT(VARCHAR, ERROR_LINE()) + ''*****'' + CONVERT(VARCHAR, ERROR_SEVERITY()) + ''*****'' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.                                                                     
				16
				,-- Severity.                                                            
				1 -- State.                                                         
				);
	END CATCH
END
' 
END
GO
