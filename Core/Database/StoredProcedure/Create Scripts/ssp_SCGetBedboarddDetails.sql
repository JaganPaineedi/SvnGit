/****** Object:  StoredProcedure [dbo].[ssp_SCGetBedboarddDetails]    Script Date: 04/11/2014 18:36:13 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetBedboarddDetails]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetBedboarddDetails]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetBedboarddDetails]    Script Date: 04/11/2014 18:36:13 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






CREATE PROCEDURE [dbo].[ssp_SCGetBedboarddDetails] (@BedAssignmentId INT)
AS
BEGIN
/********************************************************************************                                                
-- Copyright: Streamline Healthcate Solutions LLC                                           
--                                                
-- Purpose: Get Record for bedboard                                             
--                                                
-- Updates:                                                                                                       
-- Date    Author     Purpose                                                
-- Aug 2013    Akwinass             Copied from Bedcensus for Bedboard  
-- 13 Jan 2014 Akwinass             DRGCode Column Included in ClientInpatientVisits 
-- 20 Jan 2014 Akwinass             Removed CM from Procedure.
-- 30 Jan 2014 Akwinass             Modified to get AdmissionType.
-- 06 Mar 2014 Akwinass             DischargeType Column Included in ClientInpatientVisits
-- 07 Mar 2014 Akwinass             RowIdentifier Column Removed from ClientInpatientVisits
-- 11 April 2014 Akwinass           Program Code pulled instead program Name for task #979 in philhaven customization issues
-- 21 Oct 2014 Akwinass             EmergencyRoomDeparture Column Included in ClientInpatientVisits (Task #51 in Meaningful Use)
-- Mar 09 2014 PradeepA				AdmissionSource column has been added #227 (Philhaven Development)
-- Oct 20  2015	Revathi				what:Changed code to display Clients LastName and FirstName when ClientType=''I'' else  OrganizationName.           
--									why:task #609, Network180 Customization  
-- 27-Jan-2016  Akwinass            Time field is managed based on Bed Availability History task #372 in Philhaven Development
-- 01-AUG-2016 Akwinass				What : Added BedProcedureCodeId,LeaveProcedureCodeId in select statement
									Why : Woods - Support Go Live #43
*********************************************************************************/
	SET NOCOUNT ON;

	DECLARE @BedAssignmentEndDate VARCHAR(25);
	DECLARE @BedAssignmentStartDate VARCHAR(25);
	DECLARE @BedId INT;
	DECLARE @RecResult INT;

	BEGIN TRY
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
				-- Modified by Revathi 20/Oct/2015
			,case when  ISNULL(C.ClientType,'I')='I' then (ISNULL(C.LastName,'') + ', ' + ISNULL(C.FirstName,'')) else ISNULL(C.OrganizationName,'') end AS ClientName
			,CIV.AdmissionType
			,CIV.DRGCode
			,CIV.DischargeType
			-- 21 Oct 2014 Akwinass
			,CIV.EmergencyRoomDeparture
			,CIV.AdmissionSource
			,CIV.PhysicianId  -- 18-Jan-2016 Seema 
			,CIV.ClinicianId  -- 18-Jan-2016 Seema
			-- 01-AUG-2016 Akwinass	
			,CIV.BedProcedureCodeId
			,CIV.LeaveProcedureCodeId
		FROM ClientInpatientVisits AS CIV
		INNER JOIN Clients AS C ON CIV.ClientId = C.ClientId
			AND (
				ISNULL(C.RecordDeleted, 'N') = 'N'
				AND ISNULL(C.Active, 'Y') = 'Y'
				)
		WHERE ISNULL(CIV.RecordDeleted, 'N') = 'N'
			AND (
				CIV.ClientInpatientVisitId IN (
					SELECT ClientInpatientVisitId
					FROM BedAssignments
					WHERE (BedAssignmentId = @BedAssignmentId)
					)
				);

		WITH BedAssignments_cte (
			BedAssignmentId
			,NextBedAssignmentId
			)
		AS (
			SELECT BedAssignmentId
				,NextBedAssignmentId
			FROM BedAssignments AS BA
			WHERE (BedAssignmentId = @BedAssignmentId)
			
			UNION ALL
			
			SELECT BA.BedAssignmentId
				,BA.NextBedAssignmentId
			FROM BedAssignments AS BA
			INNER JOIN BedAssignments_cte AS BA1 ON BA1.NextBedAssignmentId = BA.BedAssignmentId
			WHERE (
					ISNULL(BA.RecordDeleted, 'N') = 'N'
					AND ISNULL(BA.Active, 'Y') = 'Y'
					)
			)
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
			,BA.NotBillable
			,BA.ProgramId
			,Programs.ProgramCode AS ProgramName
			,BA.LocationId
			,BA.ProcedureCodeId
			,BA.BedNotAvailable
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
			,'' AS Actiontype
			,Units.DisplayAs AS UnitName
			,Rooms.DisplayAs AS RoomName
			,Beds.DisplayAs AS BedName
			,Rooms.UnitId
			,Rooms.RoomId
			,GCR.CodeName ReasonName
			,GS.CodeName AS StatusName
			,NULL AS DocumentId
		FROM BedAssignments BA
		JOIN ClientInpatientVisits CIV ON CIV.ClientInpatientVisitId = BA.ClientInpatientVisitId
		JOIN Beds ON BA.BedId = Beds.BedId
			AND (ISNULL(Beds.RecordDeleted, 'N') = 'N')
		JOIN dbo.BedAvailabilityHistory BAH ON Beds.BedId = BAH.BedId			
			AND ISNULL(BAH.RecordDeleted, 'N') = 'N'
			AND (BAH.EndDate IS NULL OR (BAH.EndDate > GETDATE() AND BA.BedAssignmentId IS NOT NULL))
		JOIN Rooms ON Beds.RoomId = Rooms.RoomId
			AND (ISNULL(Rooms.RecordDeleted, 'N') = 'N')
		JOIN Units ON Rooms.UnitId = Units.UnitId
			AND (ISNULL(Units.RecordDeleted, 'N') = 'N')
		JOIN Programs ON BA.ProgramId = Programs.ProgramId
			AND (ISNULL(Programs.RecordDeleted, 'N') = 'N')
		JOIN Programs BAHP ON BAH.ProgramId = BAHP.ProgramId
			AND (ISNULL(BAHP.RecordDeleted, 'N') = 'N')
		LEFT JOIN GlobalCodes ON BA.Type = GlobalCodes.GlobalCodeId
			AND ISNULL(GlobalCodes.RecordDeleted, 'N') = 'N'
		LEFT JOIN GlobalCodes GCR ON BA.Reason = GCR.GlobalCodeId
			AND ISNULL(GCR.RecordDeleted, 'N') = 'N'
		LEFT JOIN GlobalCodes GS ON BA.Status = GS.GlobalCodeId
			AND ISNULL(GS.RecordDeleted, 'N') = 'N'
		JOIN BedAssignments_cte BA1 ON BA.BedAssignmentId = BA1.BedAssignmentId
		LEFT JOIN GlobalCodes GCCIV ON GCCIV.GlobalCodeId = civ.ClientType
			AND ISNULL(GCCIV.RecordDeleted, 'N') = 'N'
		WHERE ISNULL(BA.RecordDeleted, 'N') = 'N'
			AND ISNULL(BA.Active, 'Y') = 'Y'
		ORDER BY BA.BedAssignmentId ASC
		OPTION (MAXRECURSION 10000);
		
		SELECT NULL AS BedId
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCGetBedboarddDetails') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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


