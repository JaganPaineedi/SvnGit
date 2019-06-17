
/****** Object:  StoredProcedure [dbo].[ssp_ProcessRecurringClientNotes]    Script Date: 07/26/2018 16:23:57 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_ProcessRecurringClientNotes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_ProcessRecurringClientNotes]
GO

/****** Object:  StoredProcedure [dbo].[ssp_ProcessRecurringClientNotes]    Script Date: 07/26/2018 16:23:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].ssp_ProcessRecurringClientNotes (@ClientNoteId INT)
AS
/******************************************************************************                                  
**  File: ssp_ProcessRecurringClientNotes.sql                
**  Name: ssp_ProcessRecurringClientNotes           
**  Desc:                 
**                                  
**  Return values: <Return Values>                                 
**                                   
**  Called by: <ssp_CompleteFlags>                                    
**                                                
**  Parameters:    @ClientNoteId                            
**  Input   Output                                  
**  ---      -----------                                  
**                                  
**  Created By: Ravi                
**  Date:  Aug 06 2018                
*******************************************************************************                                  
**  Change History                                  
*******************************************************************************                                  
**  Date:			Author:    Description: 
	Aug 06 2018		Ravi		Recreate client flags when flag is a Recurring Flag  
								Engineering Improvement Initiatives- NBL(I) > Tasks #590> Client Tracking 	                                 
**  --------  --------    -------------------------------------------                 
                              
*******************************************************************************/
BEGIN
	BEGIN TRY
		CREATE TABLE #TrackingProtocolList (
			TrackingProtocolId INT
			,TrackingProtocolFlagId INT
			,CreateProtocol VARCHAR(250)
			,FlagTypeId INT
			,ClientId INT
			,Note VARCHAR(500)
			,StartDate DATETIME
			,EndDate DATETIME
			,FlagLinkTo CHAR(1)
			,DocumentCodeId INT
			,DueDateUnits INT
			,DueDateUnitType VARCHAR(250)
			,FirstDueDate VARCHAR(250)
			,FirstDueDateDays INT
			,DueDateStartDays INT
			,DueDateStartDate VARCHAR(250)
			,WorkGroup INT
			,ProtocolName VARCHAR(30)
			,Recurring CHAR(1)
			)

		INSERT INTO #TrackingProtocolList (
			TrackingProtocolId
			,TrackingProtocolFlagId
			,CreateProtocol
			,FlagTypeId
			,ClientId
			,Note
			,StartDate
			,EndDate
			,FlagLinkTo
			,DocumentCodeId
			,DueDateUnits
			,DueDateUnitType
			,FirstDueDate
			,FirstDueDateDays
			,DueDateStartDays
			,DueDateStartDate
			,WorkGroup
			,ProtocolName
			,Recurring
			)
		SELECT DISTINCT TP.TrackingProtocolId
			,TPF.TrackingProtocolFlagId
			,Tp.CreateProtocol
			,TPF.FlagTypeId
			,CN.ClientId
			,FT.FlagType AS Note
			,TP.StartDate
			,TP.EndDate
			,CN.FlagLinkTo
			,CN.DocumentCodeId
			,TPF.DueDateUnits
			,GC.Code AS DueDateUnitType
			,GC1.Code AS FirstDueDate
			,TPF.FirstDueDateDays
			,TPF.DueDateStartDays
			,GC2.Code AS DueDateStartDate
			,CN.WorkGroup
			,LEFT(TP.ProtocolName,30)
			,CASE WHEN ISNULL(TPF.Recurring,'')='R' THEN 'Y' ELSE 'N' END AS Recurring
		FROM ClientNotes CN 
		JOIN  TrackingProtocols TP ON TP.TrackingProtocolId=CN.TrackingProtocolId
		JOIN TrackingProtocolFlags TPF ON TPF.TrackingProtocolFlagId = CN.TrackingProtocolFlagId
		JOIN FlagTypes FT ON FT.FlagTypeId = TPF.FlagTypeId
		LEFT JOIN GlobalCodes GC ON GC.GlobalCodeId = TPF.DueDateUnitType
			AND ISNULL(GC.RecordDeleted, 'N') = 'N'
		LEFT JOIN GlobalCodes GC1 ON GC1.GlobalCodeId = TPF.FirstDueDate
			AND ISNULL(GC1.RecordDeleted, 'N') = 'N'
		LEFT JOIN GlobalCodes GC2 ON GC2.GlobalCodeId = TPF.DueDateStartDate
			AND ISNULL(GC2.RecordDeleted, 'N') = 'N'
		WHERE CAST(TP.EndDate AS DATE) >= CAST(GETDATE() AS DATE)
			AND ISNULL(TP.RecordDeleted, 'N') = 'N'
			AND ISNULL(TPF.RecordDeleted, 'N') = 'N'
			AND ISNULL(TP.Active, 'N') = 'Y'
			AND ISNULL(TPF.Active, 'N') = 'Y'
			AND ISNULL(TPF.Recurring, 'N') = 'R'
			AND CN.ClientNoteId=@ClientNoteId
			
		CREATE TABLE #ClientNotesIdentity (
			ClientNoteId INT
			,TrackingProtocolFlagId INT
			)

		INSERT INTO ClientNotes (
			CreatedBy
			,CreatedDate
			,ModifiedBy
			,ModifiedDate
			,ClientId
			,NoteType
			,Note
			,Active
			,StartDate
			,EndDate
			,OpenDate
			,DueDate
			,TrackingProtocolId
			,TrackingProtocolFlagId
			,DocumentCodeId
			,FlagLinkTo
			,WorkGroup
			,FlagRecurs
			)
		OUTPUT inserted.ClientNoteId
			,inserted.TrackingProtocolFlagId
		INTO #ClientNotesIdentity(ClientNoteId, TrackingProtocolFlagId)
		SELECT T.ProtocolName
			,GETDATE()
			,T.ProtocolName
			,GETDATE()
			,T.ClientId
			,FlagTypeId
			,Note
			,'Y'
			,DATEADD(DD, - CASE 
					WHEN DueDateStartDate = '# of Days Before Due Date'
						THEN DueDateStartDays
					WHEN DueDateStartDate = 'Open Date'
						THEN 0
					ELSE 0
					END, CASE 
					WHEN DueDateUnitType = 'Day(s)'
						THEN DATEADD(DD, DueDateUnits, GETDATE())
					WHEN DueDateUnitType = 'Month(s)'
						THEN DATEADD(MM, DueDateUnits, GETDATE())
					WHEN DueDateUnitType = 'Year(s)'
						THEN DATEADD(YY, DueDateUnits, GETDATE())
					ELSE GETDATE()
					END) AS StartDate
			,NULL AS EndDate
			,GETDATE() AS OpenDate
			,CASE WHEN FirstDueDate='Same As Due Date' THEN CASE 
				WHEN DueDateUnitType = 'Day(s)'
					THEN DATEADD(DD, DueDateUnits, GETDATE())
				WHEN DueDateUnitType = 'Month(s)'
					THEN DATEADD(MM, DueDateUnits, GETDATE())
				WHEN DueDateUnitType = 'Year(s)'
					THEN DATEADD(YY, DueDateUnits, GETDATE())
				ELSE GETDATE()
				END 
				WHEN FirstDueDate='Different from Due Date' THEN 
				DATEADD(DD,FirstDueDateDays,CASE 
				WHEN DueDateUnitType = 'Day(s)'
					THEN DATEADD(DD, DueDateUnits, GETDATE())
				WHEN DueDateUnitType = 'Month(s)'
					THEN DATEADD(MM, DueDateUnits, GETDATE())
				WHEN DueDateUnitType = 'Year(s)'
					THEN DATEADD(YY, DueDateUnits, GETDATE())
				ELSE GETDATE()
				END ) ELSE  GETDATE() END AS DueDate
			,TrackingProtocolId
			,TrackingProtocolFlagId
			,DocumentCodeId
			,FlagLinkTo
			,WorkGroup
			,Recurring
		FROM #TrackingProtocolList T
		WHERE NOT EXISTS (
				SELECT 1
				FROM ClientNotes CN
				WHERE CN.ClientId = T.ClientId
					AND CN.TrackingProtocolId = T.TrackingProtocolId
					AND CN.TrackingProtocolFlagId = T.TrackingProtocolFlagId
					AND ISNULL(CN.RecordDeleted, 'N') = 'N'
					--AND CN.CompletedBy IS NULL
					AND CN.EndDate IS NULL
				)

		INSERT INTO ClientNoteAssignedRoles (
			CreatedBy
			,CreatedDate
			,ModifiedBy
			,ModifiedDate
			,ClientNoteId
			,RoleId
			)
		SELECT T.ProtocolName
			,GETDATE()
			,T.ProtocolName
			,GETDATE()
			,C.ClientNoteId
			,TR.RoleId
		FROM #TrackingProtocolList T
		JOIN #ClientNotesIdentity C ON C.TrackingProtocolFlagId = T.TrackingProtocolFlagId
		JOIN TrackingProtocolFlagRoles TR ON TR.TrackingProtocolFlagId = C.TrackingProtocolFlagId
		WHERE ISNULL(TR.RecordDeleted, 'N') = 'N'
			AND NOT EXISTS (
				SELECT 1
				FROM ClientNoteAssignedRoles CR
				WHERE CR.ClientNoteId = C.ClientNoteId
					AND TR.RoleId = CR.RoleId
					AND ISNULL(CR.RecordDeleted, 'N') = 'N'
				)
				
	DROP TABLE 	#TrackingProtocolList		
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_ProcessRecurringClientNotes') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,16
				,- 1
				);
	END CATCH
END
