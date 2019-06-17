/****** Object:  StoredProcedure [dbo].[ssp_SCGetBedBoardScheduledRecords]    Script Date: 04/11/2014 18:36:55 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetBedBoardScheduledRecords]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetBedBoardScheduledRecords]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetBedBoardScheduledRecords]    Script Date: 04/11/2014 18:36:55 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





CREATE PROCEDURE [dbo].[ssp_SCGetBedBoardScheduledRecords] --3,0             
	@BedAssignmentId INT
	,@GetScheduledRecord BIT = 0
	,@Status INT = 0
AS /****************************************************************************/
/* Stored Procedure: ssp_SCGetBedCensusRecords                              */
/* Copyright: 2006 Streamlin Healthcare Solutions                           */
/* Author: Akwinass               */
/* Creation Date:  Aug 8,2013            */
/* Purpose: Get Data for Bedboard Page         */
/* Input Parameters:      BedAssignmentId ,GetScheduledRecord,@Status       */
/* Output Parameters:None                                                   */
/* Return:                                                                  */
/* Calls:                                                                   */
/* Called From:                                                             */
/* Data Modifications:                                                      */
/*                                                                          */
/*--------------------------Modification History----------------------------*/
/*-------Date----Author-------Purpose---------------------------------------*/
/*-----Aug 26 2013  Akwinass   change the SP as Dynamic for On Leave        */
/*-----22-09-2013   Akwinass   change the SP for get consistence rows        */
/*---- 13 Jan 2013  Akwinass   DRGCode Column Included in ClientInpatientVisits */
/*---- 30 Jan 2013  Akwinass   AdmissionType Column Included in ClientInpatientVisits */
/*---- 06 Mar 2014  Akwinass   DischargeType Column Included in ClientInpatientVisits */
/*---- 07 Mar 2014  Akwinass   RowIdentifier Column Removed from ClientInpatientVisits  */
/*---- 11 Apr 2014  Akwinass   Program Code pulled instead program Name for task #979 in philhaven customization issues  */
/*---- 21 Oct 2014  Akwinass   EmergencyRoomDeparture Column Included in ClientInpatientVisits  (Task #51 in Meaningful Use)*/
/*---- Mar 09 2014  PradeepA   AdmissionSource column has been added #227 (Philhaven Development) */
/*---- Jan 18 2016	Seema	   What : Added PhysicianId,ClinicianId columns 
							   Why  : Philhaven Development #369 */
/*---- 27-Jan-2016  Akwinass   Time field is managed based on Bed Availability History task #372 in Philhaven Development*/
-- 01-AUG-2016      Akwinass   What : Added BedProcedureCodeId,LeaveProcedureCodeId in select statement
--							   Why : Woods - Support Go Live #43
/****************************************************************************/
BEGIN
	BEGIN TRY
		DECLARE @NextBedAssignmentId INT

		IF @Status = 5006
			SELECT @NextBedAssignmentId = NextBedAssignmentId FROM BedAssignments WHERE BedAssignmentId = @BedAssignmentId

		-- RECORDS FROM ClientInpatientVisits                  
		SELECT CIV.ClientInpatientVisitId
			,CIV.ClientId
			,CIV.Status
			,CIV.RequestedDate
			,CIV.ScheduledDate
			,CIV.AdmitDate
			,CIV.DischargedDate
			,CIV.ClientType			
			,CIV.CreatedBy
			,CIV.CreatedDate
			,CIV.ModifiedBy
			,CIV.ModifiedDate
			,CIV.RecordDeleted
			,CIV.DeletedDate
			,CIV.DeletedBy
			,CIV.AdmitDecision
			,CIV.EmergencyRoomArrival
			,CONVERT(VARCHAR(10), c.DOB, 101) AS DOB
			,CASE 
				WHEN c.Sex = 'M'
					THEN 'Male'
				WHEN c.Sex = 'F'
					THEN 'Female'
				END AS [Sex]
			,C.LastName
			,C.FirstName
			,(C.LastName + ', ' + C.FirstName) AS ClientName
			,CONVERT(VARCHAR(20), CIV.RequestedDate, 103) AS FRequestedDate
			,CONVERT(VARCHAR(20), CIV.ScheduledDate, 103) AS FScheduledDate
			,CONVERT(VARCHAR(20), CIV.AdmitDate, 103) AS FAdmitDate
			,CONVERT(VARCHAR(20), CIV.DischargedDate, 103) AS FDischargedDate
			,CIV.AdmissionType
			,CIV.DRGCode
			,CIV.DischargeType
			-- 21 Oct 2014 Akwinass
			,CIV.EmergencyRoomDeparture
			,CIV.AdmissionSource
			,CIV.PhysicianId  -- 18-Jan-2016 Seema 
			,CIV.ClinicianId  -- 18-Jan-2016 Seema
			-- 01-AUG-2016      Akwinass
			,CIV.BedProcedureCodeId
			,CIV.LeaveProcedureCodeId
		FROM ClientInpatientVisits AS CIV
		INNER JOIN Clients AS C ON CIV.ClientId = C.ClientId
		WHERE (ISNULL(CIV.RecordDeleted, 'N') = 'N')
			AND (ISNULL(C.RecordDeleted, 'N') = 'N')
			AND (
				CIV.ClientInpatientVisitId IN (
					SELECT ClientInpatientVisitId
					FROM BedAssignments
					WHERE (BedAssignmentId = @BedAssignmentId)
					)
				)

		-- RECORDS FROM BedAssignments                  
		DECLARE @SQL AS NVARCHAR(MAX)

		SET @SQL = 'DECLARE @BedAssignmentId INT = ''' + CONVERT(VARCHAR, @BedAssignmentId) + ''''

		IF (@GetScheduledRecord = 1)
		BEGIN
			SET @SQL = @SQL + ', @GetScheduledRecord BIT = 1,'
		END
		ELSE
		BEGIN
			SET @SQL = @SQL + ', @GetScheduledRecord BIT = 0,'
		END

		SET @SQL = @SQL + '@Status INT = ''' + CONVERT(VARCHAR, @Status) + ''';'
		SET @SQL = @SQL + ' WITH BedAssignments_cte (
			BedAssignmentId
			,NextBedAssignmentId
			)
		AS (			              
			SELECT BedAssignmentId
				,NextBedAssignmentId
			FROM BedAssignments AS BA
			WHERE (NextBedAssignmentId = ''' + CONVERT(VARCHAR, @BedAssignmentId) + ''')
				AND @GetScheduledRecord = 1
			
			UNION ALL			
			                
			SELECT BedAssignmentId
				,NextBedAssignmentId
			FROM BedAssignments AS BA
			WHERE (BedAssignmentId = ''' + CONVERT(VARCHAR, @BedAssignmentId) + ''')
				AND @GetScheduledRecord = 0			
			
			UNION ALL			
			               
			SELECT BA.BedAssignmentId
				,BA.NextBedAssignmentId
			FROM BedAssignments AS BA
			INNER JOIN BedAssignments_cte AS BA1 ON BA1.NextBedAssignmentId = BA.BedAssignmentId
			WHERE (ISNULL(BA.RecordDeleted, ''N'') = ''N'')
				AND ('

		IF @Status = 5006
			SET @SQL = @SQL + 'BA.Status IN (5005,5007)'
		ELSE
			SET @SQL = @SQL + 'BA.Status = ''' + CONVERT(VARCHAR, @Status) + ''''

		SET @SQL = @SQL + ' OR @Status = 0
					)'

		IF @Status = 5003 OR @Status = 5004
			SET @SQL = @SQL + 'AND BA.BedAssignmentId = ''' + CONVERT(VARCHAR, @BedAssignmentId) + ''''
		ELSE IF @Status = 5006 AND @NextBedAssignmentId IS NOT NULL
			SET @SQL = @SQL + 'AND BA.BedAssignmentId in(''' + CONVERT(VARCHAR, @BedAssignmentId) + ''',''' + CONVERT(VARCHAR, @NextBedAssignmentId) + ''')'
		ELSE IF @Status = 5006 AND @NextBedAssignmentId IS NULL
			SET @SQL = @SQL + 'AND BA.BedAssignmentId = ''' + CONVERT(VARCHAR, @BedAssignmentId) + ''''
		SET @SQL = @SQL + 
			') 
			
			SELECT BA.BedAssignmentId
			,BA.ClientInpatientVisitId
			,BA.BedId
			,BA.StartDate
			,BA.EndDate
			,BA.ArrivalDate
			,BA.ExpectedDischargeDate
			,BA.Status
			,BA.Type
			,GlobalCodes.CodeName AS BedType
			,BA.Reason
			,BA.Active
			,BA.ProgramId
			,Programs.ProgramCode AS ProgramName
			,BA.LocationId
			,BA.ProcedureCodeId
			,BA.BedNotAvailable
			,BA.NotBillable
			,BA.Disposition
			,BA.Overbooked
			,BA.Priority
			,BA.LastServiceCreationDate
			,BA.Comment
			,BA.NextBedAssignmentId
			,BA.CreatedBy
			,BA.CreatedDate
			,BA.ModifiedBy
			,BA.ModifiedDate
			,BA.RecordDeleted
			,BA.DeletedDate
			,BA.DeletedBy
			,'''' AS Actiontype
			,Units.DisplayAs AS UnitName
			,Rooms.DisplayAs AS RoomName
			,Beds.DisplayAs AS BedName
			,Rooms.UnitId
			,Rooms.RoomId
			,GSC.SubCodeName AS ReasonName
		FROM BedAssignments BA
		JOIN ClientInpatientVisits CIV ON CIV.ClientInpatientVisitId = BA.ClientInpatientVisitId
		INNER JOIN Beds ON BA.BedId = Beds.BedId
		INNER JOIN Rooms ON Beds.RoomId = Rooms.RoomId
		INNER JOIN dbo.BedAvailabilityHistory BAH ON (
				BAH.BedId = BA.BedId
				AND ISNULL(BAH.RecordDeleted, ''N'') = ''N''
				AND (BAH.EndDate IS NULL OR (BAH.EndDate > GETDATE() AND BA.BedAssignmentId IS NOT NULL))
				)
		INNER JOIN Units ON Rooms.UnitId = Units.UnitId
		INNER JOIN Programs ON BA.ProgramId = Programs.ProgramId
		INNER JOIN dbo.Programs BAHP ON BAHP.ProgramId = BAH.ProgramId
		LEFT OUTER JOIN GlobalCodes ON BA.Type = GlobalCodes.GlobalCodeId
		INNER JOIN BedAssignments_cte BA1 ON BA.BedAssignmentId = BA1.BedAssignmentId
		LEFT OUTER JOIN dbo.GlobalSubCodes GSC ON GSC.GlobalSubCodeId = BA.Reason
		LEFT JOIN GlobalCodes GCCIV ON GCCIV.GlobalCodeId = civ.ClientType
			AND ISNULL(GCCIV.RecordDeleted, ''N'') = ''N''
		ORDER BY BA.BedAssignmentId ASC
		OPTION (MAXRECURSION 2000) '

		PRINT (@SQL)

		EXEC (@SQL)

		SELECT NULL AS BedId
	END TRY

	BEGIN CATCH
		DECLARE @Error AS VARCHAR(8000);

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCGetBedBoardScheduledRecords') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE());

		RAISERROR (
				@Error
				,16
				,1
				);-- Message text.
	END CATCH
END




GO


