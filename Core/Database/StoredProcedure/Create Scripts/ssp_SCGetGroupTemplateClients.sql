/****** Object:  StoredProcedure [dbo].[ssp_SCGetGroupTemplateClients]    Script Date: 07/24/2015 12:27:37 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetGroupTemplateClients]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetGroupTemplateClients]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetGroupTemplateClients]    Script Date: 07/24/2015 12:27:37 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_SCGetGroupTemplateClients] @GroupId INT,
@StaffId INT
AS
/**************************************************************  
Created By   : Akwinass
Created Date : 13-APRIL-2016 
Description  : Used to Get Group Clients
Called From  : Group Template Screens
/*  Date			  Author				  Description */
/*  13-APRIL-2016	  Akwinass				  Created    */
**************************************************************/
BEGIN
	BEGIN TRY
		IF OBJECT_ID('tempdb..#TmpClients') IS NOT NULL
			DROP TABLE #TmpClients
			
		CREATE TABLE #TmpClients (			
			ClientId INT
			,ClientName VARCHAR(500)			
			)
		
		INSERT INTO #TmpClients(ClientId,ClientName)			
		SELECT DISTINCT C.ClientId
			,C.LastName + ', ' + C.FirstName AS ClientName
		FROM GroupClients GC
		JOIN Clients C ON GC.ClientId = C.ClientId
		WHERE GC.GroupId = @GroupId
			AND ISNULL(GC.RecordDeleted, 'N') = 'N'
			AND ISNULL(C.RecordDeleted, 'N') = 'N'
			
		DECLARE @AttendanceClientsEnrolledPrograms CHAR(1)		
		SELECT TOP 1 @AttendanceClientsEnrolledPrograms = AttendanceClientsEnrolledPrograms
		FROM Groups
		WHERE GroupId = @GroupId
			AND isnull(RecordDeleted, 'N') = 'N'
		
		IF ISNULL(@AttendanceClientsEnrolledPrograms,'N') = 'Y'
		BEGIN	
			INSERT INTO #TmpClients(ClientId,ClientName)
			SELECT DISTINCT C.ClientId
				,C.LastName + ', ' + C.FirstName AS ClientName
			FROM Services S
			JOIN Clients C ON S.ClientId = C.ClientId
			WHERE EXISTS (
					SELECT 1
					FROM GroupServices GS
					WHERE GS.GroupId = @GroupId
						AND ISNULL(GS.RecordDeleted, 'N') = 'N'
						AND GS.GroupServiceId = S.GroupServiceId
					)
				AND ISNULL(S.RecordDeleted, 'N') = 'N'
				AND S.ClinicianId = @StaffId
				AND NOT EXISTS(SELECT 1 FROM #TmpClients TC WHERE TC.ClientId = S.ClientId)
		END	
			
		SELECT DISTINCT ClientId
			,ClientName
		FROM #TmpClients
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), '[ssp_SCGetGroupTemplateClients]') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

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


