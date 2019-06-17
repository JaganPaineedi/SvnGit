/****** Object:  StoredProcedure [dbo].[ssp_SCWebDashBoardTrackingWidget]    Script Date: 07/26/2018 16:23:57 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCWebDashBoardTrackingWidget]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCWebDashBoardTrackingWidget]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCWebDashBoardTrackingWidget]    Script Date: 07/26/2018 16:23:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SCWebDashBoardTrackingWidget] (
	@LoggedInStaffId INT
	,@Type CHAR(1)
	,@WorkGroup INT
	,@AssignedStaffId INT
	,@RoleId INT
	,@TrackingProtocolId INT
	)
AS
/******************************************************************************                                  
**  File: ssp_SCWebDashBoardTrackingWidget.sql                
**  Name: ssp_SCWebDashBoardTrackingWidget           
**  Desc:                 
**                                  
**  Return values: <Return Values>                                 
**                                   
**  Called by: <Post update in Client  Program Assignment Screen>                                    
**                                                
**  Parameters:                                
**  Input   Output                                  
**  ---      -----------                                  
**                                  
**  Created By: Ravi                
**  Date:  Aug 06 2018                
*******************************************************************************                                  
**  Change History                                  
*******************************************************************************                                  
**  Date:			Author:    Description: 
	Aug 06 2018		Ravi		created Dash board for Tracking Protocol 
								Engineering Improvement Initiatives- NBL(I) > Tasks #590> Client Tracking 	                                 
**  --------  --------    -------------------------------------------                 
                              
*******************************************************************************/
BEGIN
	BEGIN TRY
		CREATE TABLE #ResultSet (
			TrackingProtocolId INT
			,TrackingProtocolFlagId INT
			,FlagTypeId INT
			,FlagType VARCHAR(250)
			,DueDate DATETIME
			,Due90To61Days INT
			,Due60To31Days INT
			,Due30OrLessDays INT
			,Overdue INT
			)

		INSERT INTO #ResultSet (
			TrackingProtocolId
			,TrackingProtocolFlagId
			,FlagTypeId
			,FlagType
			,DueDate
			)
		SELECT DISTINCT CN.TrackingProtocolId
			,CN.TrackingProtocolFlagId
			,CN.NoteType
			,FT.FlagType AS FlagType
			,CN.DueDate
		FROM ClientNotes CN
		JOIN TrackingProtocolFlags TPF ON TPF.FlagTypeId = CN.NoteType
		JOIN TrackingProtocols TP ON TP.TrackingProtocolId = CN.TrackingProtocolId
		JOIN FlagTypes FT ON CN.NoteType = FT.FlagTypeId
		WHERE (
				@TrackingProtocolId = - 1
				OR CN.TrackingProtocolId = @TrackingProtocolId
				)
			AND (
				@Type = ''
				OR (
					@Type = 'W'
					AND (
						CN.WorkGroup = @WorkGroup
						OR @WorkGroup = - 1
						)
					)
				OR @Type = 'A'
				AND (
					@AssignedStaffId = - 1
					OR EXISTS (
						SELECT 1
						FROM ClientNoteAssignedUsers CNA
						WHERE CNA.ClientNoteId = CN.ClientNoteId
							AND ISNULL(CNA.RecordDeleted, 'N') = 'N'
							AND (@AssignedStaffId = CNA.StaffId)
						)
					)
				OR @Type = 'R'
				AND (
					@RoleId = - 1
					OR EXISTS (
						SELECT 1
						FROM ClientNoteAssignedRoles CNR
						WHERE CNR.ClientNoteId = CN.ClientNoteId
							AND ISNULL(CNR.RecordDeleted, 'N') = 'N'
							AND (@RoleId = CNR.RoleId)
						)
					)
				)
			AND ISNULL(CN.RecordDeleted, 'N') = 'N'
			AND ISNULL(TPF.RecordDeleted, 'N') = 'N'
			AND ISNULL(TP.RecordDeleted, 'N') = 'N'

		
		SELECT R.FlagType
			,(
				SELECT Count(RR.FlagTypeId)
				FROM #ResultSet RR
				WHERE R.FlagTypeId = RR.FlagTypeId
					AND DATEDIFF(dd, getdate(), RR.DueDate) <= 90
					AND DATEDIFF(dd, getdate(), RR.DueDate) >= 61
				) AS Due90To61Days
			,(
				SELECT Count(RR.FlagTypeId)
				FROM #ResultSet RR
				WHERE R.FlagTypeId = RR.FlagTypeId
					AND DATEDIFF(dd, getdate(), RR.DueDate) <= 60
					AND DATEDIFF(dd, getdate(), RR.DueDate) >= 31
				) AS Due60To31Days
			,(
				SELECT Count(RR.FlagTypeId)
				FROM #ResultSet RR
				WHERE R.FlagTypeId = RR.FlagTypeId
					AND DATEDIFF(dd, getdate(), RR.DueDate) <= 30
				) AS Due30OrLessDays
			,(
				SELECT Count(RR.FlagTypeId)
				FROM #ResultSet RR
				WHERE R.FlagTypeId = RR.FlagTypeId
					AND DATEDIFF(dd, getdate(), RR.DueDate) > 90
				) AS Overdue
		FROM #ResultSet R
		GROUP BY R.FlagTypeId
			,R.FlagType
		
			
			
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCWebDashBoardDocumentWidget') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.                                                                                                              
				16
				,-- Severity.                                                                                                              
				1 -- State.                                                                                                              
				);
	END CATCH
END
