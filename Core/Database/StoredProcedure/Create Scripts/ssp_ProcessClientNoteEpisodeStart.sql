
/****** Object:  StoredProcedure [dbo].[ssp_ProcessClientNoteEpisodeStart]    Script Date: 07/26/2018 16:23:57 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_ProcessClientNoteEpisodeStart]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_ProcessClientNoteEpisodeStart]
GO

/****** Object:  StoredProcedure [dbo].[ssp_ProcessClientNoteEpisodeStart]    Script Date: 07/26/2018 16:23:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].ssp_ProcessClientNoteEpisodeStart (@ClientId INT)
AS
/******************************************************************************                                  
**  File: ssp_ProcessClientNoteEpisodeStart.sql                
**  Name: ssp_ProcessClientNoteEpisodeStart           
**  Desc:                 
**                                  
**  Return values: <Return Values>                                 
**                                   
**  Called by: <Code file that calls>                                    
**                                                
**  Parameters:    @ClientId                              
**  Input   Output                                  
**  ----    -----------                                  
**                                  
**  Created By: Ravi                
**  Date:  Aug 06 2018                
*******************************************************************************                                  
**  Change History                                  
*******************************************************************************                                  
**  Date:			Author:    Description: 
	-----			-------		-----------
	Aug 06 2018		Ravi		Create Client Flags when Client  EpisodeStart
								Engineering Improvement Initiatives- NBL(I) > Tasks #590> Client Tracking 
    Feb 12 2019		Vijay		When logged in staff starts the Episode for a client, we look for logged in staff’s role under ClientTreatmentTeamMembers 
								and if it matches to protocolmappings, system creates the respective flags.
								Engineering Improvement Initiatives- NBL(I) > Tasks #590.1> Client Tracking	                                     
*******************************************************************************/
BEGIN
	BEGIN TRY
		

		CREATE TABLE #TrackingProtocolList (
			TrackingProtocolId INT
			,TrackingProtocolFlagId INT
			,CreateProtocol VARCHAR(250)
			,FlagTypeId INT
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
			,TP.CreateProtocol
			,TPF.FlagTypeId
			,FT.FlagType AS Note
			,TP.StartDate
			,TP.EndDate
			,CASE WHEN ISNULL(FT.FlagLinkTo,'')='C' THEN NULL ELSE FT.FlagLinkTo END AS FlagLinkTo
			,FT.DocumentCodeId
			,TPF.DueDateUnits
			,GC.Code AS DueDateUnitType
			,GC1.Code AS FirstDueDate
			,TPF.FirstDueDateDays
			,TPF.DueDateStartDays
			,GC2.Code AS DueDateStartDate
			,FT.DefaultWorkGroup
			,LEFT(TP.ProtocolName,30)
			,CASE WHEN ISNULL(TPF.Recurring,'')='R' THEN 'Y' ELSE 'N' END AS Recurring
		FROM TrackingProtocols TP
		JOIN TrackingProtocolFlags TPF ON TPF.TrackingProtocolId = TP.TrackingProtocolId
		JOIN FlagTypes FT ON FT.FlagTypeId = TPF.FlagTypeId
		LEFT JOIN GlobalCodes GC ON GC.GlobalCodeId = TPF.DueDateUnitType
			AND ISNULL(GC.RecordDeleted, 'N') = 'N'
		LEFT JOIN GlobalCodes GC1 ON GC1.GlobalCodeId = TPF.FirstDueDate
			AND ISNULL(GC1.RecordDeleted, 'N') = 'N'
		LEFT JOIN GlobalCodes GC2 ON GC2.GlobalCodeId = TPF.DueDateStartDate
			AND ISNULL(GC2.RecordDeleted, 'N') = 'N'
		LEFT JOIN GLobalCodes GC3 ON GC3.GlobalCodeId=TP.CreateProtocol
		WHERE CAST(TP.StartDate AS DATE) <= CAST(GETDATE() AS DATE)
			AND (TP.EndDate IS NULL OR (CAST(TP.EndDate AS DATE) >= CAST(GETDATE() AS DATE)))
			AND ISNULL(TP.RecordDeleted, 'N') = 'N'
			AND ISNULL(TPF.RecordDeleted, 'N') = 'N'
			AND ISNULL(TP.Active, 'N') = 'Y'
			AND ISNULL(TPF.Active, 'N') = 'Y'
			AND ISNULL(TPF.DueDateType, 'N') = 'U'
			AND GC3.Code='On Episode Start'
			AND EXISTS (
				SELECT C.ClientId
				FROM Clients C
				JOIN ClientEpisodes CE ON CE.ClientId = C.ClientId
				WHERE CE.STATUS != 102
					AND CE.ClientId=@ClientId
					AND CAST(CE.RegistrationDate AS DATE) > = CAST(TP.StartDate AS DATE)
					AND CAST(CE.RegistrationDate AS DATE) < = CAST(TP.EndDate AS DATE)
					AND ISNULL(CE.RecordDeleted, 'N') = 'N'
				)
			AND (TPF.FlagAssignment = 'M'
			OR EXISTS (
				SELECT CE.ClientId
				FROM ClientEpisodes CE 
				JOIN Staff S ON S.UserCode = CE.ModifiedBy
				JOIN ClientTreatmentTeamMembers CTTM ON CTTM.StaffId = S.StaffId AND CTTM.ClientId = CE.ClientId
				JOIN TrackingProtocolFlagRoles TPFR ON TPFR.RoleId = CTTM.TreatmentTeamRole	AND TPFR.TrackingProtocolFlagId = TPF.TrackingProtocolFlagId
				WHERE CE.ClientId=@ClientId
					AND (CTTM.StartDate IS NULL OR (CAST(CTTM.StartDate AS DATE) <= CAST(GETDATE() AS DATE))) 
					AND (CTTM.EndDate IS NULL OR (CAST(CTTM.EndDate AS DATE) >= CAST(GETDATE() AS DATE)))
					AND ISNULL(CE.RecordDeleted, 'N') = 'N'
					AND ISNULL(CTTM.RecordDeleted, 'N') = 'N'
					AND ISNULL(TPFR.RecordDeleted, 'N') = 'N'
					AND ISNULL(CTTM.Active, 'N') = 'Y'
				))

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
		SELECT ProtocolName
			,GETDATE()
			,ProtocolName
			,GETDATE()
			,@ClientId
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
			,CASE 
				WHEN DueDateUnitType = 'Day(s)'
						THEN DATEADD(DD, DueDateUnits, GETDATE()) 
				WHEN DueDateUnitType = 'Month(s)'
					THEN DATEADD(MM, DueDateUnits, GETDATE())
				WHEN DueDateUnitType = 'Year(s)'
					THEN DATEADD(YY, DueDateUnits, GETDATE())
				ELSE GETDATE()
				END AS DueDate
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
				WHERE CN.ClientId = @ClientId
					AND CN.TrackingProtocolId = T.TrackingProtocolId
					AND CN.TrackingProtocolFlagId = T.TrackingProtocolFlagId
					AND CN.DocumentCodeId = T.DocumentCodeId
					AND ISNULL(CN.RecordDeleted, 'N') = 'N'
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
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_ProcessClientNoteEpisodeStart') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,16
				,- 1
				);
	END CATCH
END
