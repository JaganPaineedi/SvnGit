/****** Object:  StoredProcedure [dbo].[ssp_ListPageWhiteBoard]    Script Date: 06/24/2015 14:32:35 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_ListPageWhiteBoard]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_ListPageWhiteBoard]
GO

/****** Object:  StoredProcedure [dbo].[ssp_ListPageWhiteBoard]    Script Date: 06/24/2015 14:32:35 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_ListPageWhiteBoard] @PageNumber INT
	,@PageSize INT
	,@SortExpression VARCHAR(100)
	,@DateFilter DATETIME
	,@UnitsFilter INT
	,@AttendingFilter INT
	,@DAFilter INT
	,@BedFilter INT = - 1
	,@OtherFilter INT
	,@WhiteBoardMonitor INT = 0
	,@ProgramFilter INT = -1
	,@StaffId INT=0
	-- '0' -- Call from White Board list Page. '1' -- Call from White Board Monitor to Get White Board details. '2' -- Call from White Board Monitor to get Order details.      
AS
/********************************************************************************                                                
-- Stored Procedure: dbo.ssp_ListPageWhiteBoard                                                  
-- Copyright: Streamline Healthcate Solutions                                                
-- Purpose: used by Staff Users list page                                                
-- Updates:                                                                                                       
-- Date        Author    Purpose                                                
-- 21.06.2013  Praveen Potnuru  Created.        
-- 18.09.2013  Gautam               Created temp table to get client visit details       
         and worked on bed display based on date selection         
-- 18.09.2014  Praveen Potnuru  AdministrationTimeWindow is specified order level      
             
-- 12.02.2015  Praveen Potnuru  Renewal medications check done      
-- 18.02.2015  Gautam               The column OrderFrequencyId changed to OrderTemplateFrequencyId in ClientOrders table      
         and linked directly to OrderTemplateFrequencies table, Why : Task#221,Philhaven Development      
-- 26 May 2015  Veena               Added ShowOnWhiteBoard conditions in filter Philhaven Development #248**      
-- 16 Jun 2015  Chethan N           Added Paramter @WhiteBoardMonitor with default value '0' to handle the SP call from White Board Monitor application      
-- 19 Jun 2015  Chethan N           What : Retrieving AuthorizationId and AuthorizationDocumentId to link to Authorization details from white board -- LCD column.      
--         Why : Philhaven Development task# 312      
-- 24 JUN 2015  Shankha             What : Added Recodes XBEDAUTHORIZATIONCODES to check for Bed Authorization Why : Philhaven Development task# 312      
--12 Dec 2015  Basudev Sahu  Modified For Task #609 Network180 Customization      
-- 18 JAN 2016  Seema    What : Changed code To fetch PhysicianId from ClientInPatientVisits table instead of Clients Table      
         Why:Philhaven Development task# 369      
-- 3/4/2016  Msood    Added comma after LastName       
-- 15 Mar 2015  Chethan N           What : Checking DateDiff of StartDate and EndDate      
--         Why : Philhaven - Customization Issues Tracking  task# 1485   
-- 05/May/2015	Gautam		What: Changed code to get the valid AuthorizationId for Clients    
							Why : Philhaven - Customization Issues Tracking  task# 1485       
-- 24-May-2016		PradeepA			Added @ProgramFilter filter and Primary Plan #187 Bradford Customizations
---14-Sept-2016		PradeepT  What:Set @ProgramFilter=-1 when @ProgramFilter=0 because during export it have value 0 as default and in list page it has -1 as default.Logic is based on -1 its value
                              Why:Bradford - Support Go Live - #181	
-- 19-Jan-2017      Arjun K R  	ssf_GetPrimaryPlanName function is removed and select statement is modified to improve the performance. Task #254 Bradford - Support Go Live.	
-- 03/23/2017  jcarlson    Renaissance - Dev Items 630 : Added in new columns, added in logic to handle paging, removed cte's 	
-- 04/06/2017  jcarlson	   Renaissance - Dev Items 630 : use staff.displayAs vs building the value	
--24 Apr 2017 Chita Ranjan  What:Added one more column "BedAssignmentId" in the select statement.
                             Why:AspenPointe-Environment Issues #180
-- 05/08/2017  jcarlson    Renaissance - Dev Items 630.3
-- 06/19/2017  jcarlson	   Renaissance - Dev Items 630.12 : Added in logic to handle Admission Flags column
-- 08/01/2017  jcarlson	   Renaissance - Dev Items 630.12 : Addmission Flags are no more and Precautions are now based on global codes
-- 06/07/2018  Gautam      Added code to display ClientName based on SystemConfigKeys WhiteboardLastName & WhiteboardFirstName,Westbridge-Customizations, #4750
-- 24-July-2018	Deej				Added Logic to  bind the records only for the staff has access to Units and Programs. Bradford - Enhancements #400.2
-- 30-July-2018	Bibhu		what:Added join with staffclients table to display associated clients for login staff  
          					why:Engineering Improvement Initiatives- NBL(I) task #77 
-- 29-SEP-2018	TRemisoski	what:corrected logic issue from NBL(I) task #77  
          					why:Engineering Improvement Initiatives- NBL(I) task #77 
*********************************************************************************/
BEGIN
	BEGIN TRY
		--Added by Deej 7/24/2018
	    DECLARE @ListDataBasedOnStaffsAccessToProgramsAndUnits varchar(3)
		SELECT @ListDataBasedOnStaffsAccessToProgramsAndUnits = CASE WHEN [Value]='Yes' THEN 'Y' ELSE 'N' END 
		FROM SystemConfigurationKeys WHERE [Key]= 'FilterDataBasedOnStaffAssociatedToProgramsAndUnits'       

		-- 29-SEP-2018	TRemisoski use SystemConfigurationKeys value to control using StaffClients
		DECLARE @RestrictwhiteboardListToStaffClients varchar(1)
		set @RestrictwhiteboardListToStaffClients = left(dbo.ssf_GetSystemConfigurationKeyValue('RESTRICTWHITEBOARDLISTTOSTAFFCLIENTS'), 1)

		IF(@ProgramFilter=0)---Modified by PradeepT on 14-Sept-2016
			BEGIN
			SET @ProgramFilter=-1
			END
		CREATE TABLE #UnacknowlwdgeOrders (
			ClientId INT
			,UnacknowledgeOrders INT
			);

		CREATE TABLE #LegalStatus (
			ClientId INT
			,LegalStatus VARCHAR(4000)
			);

		CREATE TABLE #OrderLevel (
			ClientId INT
			,OrderLevel VARCHAR(4000)
			);

		CREATE TABLE #OrderObservations (
			ClientId INT
			,Observations VARCHAR(4000)
			);

		CREATE TABLE #ClientOverdueMedication (
			ClientId INT
			,OverdueMedicationCount INT
			);

		CREATE TABLE #ClientDueMedication (
			ClientId INT
			,DueMedicationCount INT
			);

		CREATE TABLE #ClientRenewalMedication (
			ClientId INT
			,RenewalMedicationCount INT
			);
	    CREATE TABLE #ClientFlags 
		(
		ClientId INT,
		Flags VARCHAR(MAX)
		)
		DECLARE @CustomFilters TABLE (BedId INT);
		DECLARE @CustomFiltersApplied AS CHAR(1);
		DECLARE @OverdueHours AS INT;
		DECLARE @WhiteboardLastName AS VARCHAR(50);
		DECLARE @WhiteboardFirstName AS VARCHAR(50);

		SELECT @OverdueHours = Value
		FROM SystemConfigurationKeys
		WHERE [Key] = 'MARoverdueLookbackHours'
			AND (ISNULL(RecordDeleted, 'N') = 'N');
		-- 06/07/2018  Gautam
		SELECT @WhiteboardLastName = Value
		FROM SystemConfigurationKeys
		WHERE [Key] = 'WhiteboardLastName'
			AND (ISNULL(RecordDeleted, 'N') = 'N');
			
		SELECT @WhiteboardFirstName = Value
		FROM SystemConfigurationKeys
		WHERE [Key] = 'WhiteboardFirstName'
			AND (ISNULL(RecordDeleted, 'N') = 'N');
			
		IF @OtherFilter > 10000
		BEGIN
			SET @CustomFiltersApplied = 'Y';

			INSERT INTO @CustomFilters (BedId)
			EXECUTE scsp_ListPageWhiteBoard @DateFilter = @DateFilter
				,@UnitsFilter = @UnitsFilter
				,@AttendingFilter = @AttendingFilter
				,@DAFilter = @DAFilter
				,@OtherFilter = @OtherFilter
				,@ProgramFilter = @ProgramFilter;
		END

		-- Get Client visit details      
		CREATE TABLE #ClientInPatientVisits (
			ClientId INT
			,ClientName VARCHAR(110)
			,ClientNameDisplay VARCHAR(110)
			,PrimaryPhysicianId INT
			,ClientInpatientVisitId INT
			,PrimaryClinicianId INT
			,AdmitDate DATETIME
			,DischargedDate DATE
			,FallScrore INT
			,CurrentFallScore INT
			,ClientsAge INT
			,ClientsGender VARCHAR(10)
			,Status INT
			);

		INSERT INTO #ClientInPatientVisits
		SELECT DISTINCT C.ClientId
			,CASE -- modify by Basudev  for  network 180 task #609      
				WHEN ISNULL(C.ClientType, 'I') = 'I'
					THEN ISNULL(C.LastName, '') + ', ' + ISNULL(C.FirstName, '')
				ELSE ISNULL(C.OrganizationName, '')
				END AS ClientName   
			,CASE   
				WHEN ISNULL(C.ClientType, 'I') = 'I'
					THEN case when C.LastName is not null then
							case when @WhiteboardLastName= 'FullLastName' then
								 C.LastName
							 when @WhiteboardLastName= 'FirstInitial' then
								 substring(C.LastName,1,1)
							  when @WhiteboardLastName= 'FirstThreeLetter' then
								 substring(C.LastName,1,3)
							 else C.LastName end
						 else ISNULL(C.LastName, '') end + ', ' + 
						 case when C.FirstName is not null then
							case when @WhiteboardFirstName= 'FullFirstName' then
								 C.FirstName
							 when @WhiteboardFirstName= 'FirstInitial' then
								 substring(C.FirstName,1,1)
							  when @WhiteboardFirstName= 'FirstThreeLetter' then
								 substring(C.FirstName,1,3)
							 else ISNULL(C.FirstName, '') end
						 else ISNULL(C.FirstName, '') end
				ELSE ISNULL(C.OrganizationName, '')
				END AS ClientNameDisplay ---      
			,CPV.PhysicianId --18 JAN 2016,Seema      
			,CPV.ClientInpatientVisitId
			,CPV.ClinicianId --18 JAN 2016,Seema      
			,CPV.AdmitDate
			,CPV.DischargedDate
			,0
			,0
			,dbo.GetAge(c.DOB,GETDATE())
			,c.Sex
			,cpv.Status
		FROM ClientInpatientVisits AS CPV
		INNER JOIN Clients AS C ON CPV.ClientId = C.ClientId
			AND ISNULL(C.RecordDeleted, 'N') <> 'Y'
			AND C.Active = 'Y'
			AND ISNULL(CPV.RecordDeleted, 'N') <> 'Y'
			AND CPV.STATUS in (4982,4981,4983); --occupied

		
		
			INSERT INTO #ClientFlags ( ClientId, Flags )
			SELECT a.ClientId,
			REPLACE(REPLACE(STUFF((
							SELECT DISTINCT ', ' + ft.FlagType
							FROM ClientNotes AS cn
							JOIN dbo.FlagTypes AS ft ON ft.FlagTypeId = cn.NoteType
							AND ISNULL(ft.DoNotDisplayFlag,'N') = 'N'
							WHERE ISNULL(cn.RecordDeleted,'N')='N'
							AND cn.Active = 'Y'
							AND cn.ClientId = a.ClientId
							AND ( (CAST(cn.StartDate AS DATE) <= CAST(GETDATE() AS DATE) ) OR cn.StartDate IS NULL )
							AND ( ( CAST(cn.EndDate AS DATE) >= CAST(GETDATE() AS DATE) ) OR cn.EndDate IS NULL )

							FOR XML PATH('')
							), 1, 1, ''), '&lt;', '<'), '&gt;', '>')
			FROM #ClientInPatientVisits AS a 
			GROUP BY a.ClientId


		INSERT INTO #UnacknowlwdgeOrders
		SELECT CO.ClientId
			,CASE 
				WHEN COUNT(OrderPendAcknowledge) > 0
					THEN COUNT(OrderPendAcknowledge)
				ELSE COUNT(OrderPendRequiredRoleAcknowledge)
				END AS UnacknowledgeOrders
		FROM ClientOrders AS CO
		INNER JOIN Orders AS O ON O.OrderId = CO.OrderId
			AND Isnull(CO.RecordDeleted, 'N') = 'N'
			AND Isnull(O.RecordDeleted, 'N') = 'N'
			AND Isnull(O.Active, 'Y') = 'Y'
		WHERE (
				CO.OrderPended = 'Y'
				OR CO.OrderPendAcknowledge = 'Y'
				OR CO.OrderPendRequiredRoleAcknowledge = 'Y'
				)
			AND OrderFlag = 'Y'
			AND CO.Active = 'Y'
		GROUP BY ClientId

		INSERT INTO #LegalStatus
		SELECT CO1.ClientId
			,REPLACE(REPLACE(STUFF((
							SELECT DISTINCT ', ' + gc.CodeName
							FROM ClientOrders AS CO
							INNER JOIN GlobalCodes AS GC ON GC.GlobalCodeId = CO.Legal
								AND isNull(CO.RecordDeleted, 'N') <> 'Y'
								AND isNull(GC.RecordDeleted, 'N') <> 'Y'
								AND CO.OrderPendRequiredRoleAcknowledge <> 'Y'
								AND CO.OrderPendAcknowledge <> 'Y'
								AND CO.Active = 'Y'
							WHERE CO1.ClientId = CO.ClientId
							FOR XML PATH('')
							), 1, 1, ''), '&lt;', '<'), '&gt;', '>') AS 'LegalStatus'
		FROM ClientOrders AS CO1
		WHERE CO1.clientId IS NOT NULL
		GROUP BY CO1.ClientId;

		INSERT INTO #OrderLevel
		SELECT CO1.ClientId
			,REPLACE(REPLACE(STUFF((
							SELECT DISTINCT ', ' + gc.CodeName
							FROM ClientOrders AS CO
							INNER JOIN GlobalCodes AS GC ON GC.GlobalCodeId = CO.LEVEL
								AND isNull(CO.RecordDeleted, 'N') <> 'Y'
								AND isNull(GC.RecordDeleted, 'N') <> 'Y'
								AND CO.OrderPendRequiredRoleAcknowledge <> 'Y'
								AND CO.OrderPendAcknowledge <> 'Y'
								AND CO.Active = 'Y'
							WHERE CO1.ClientId = CO.ClientId
							FOR XML PATH('')
							), 1, 1, ''), '&lt;', '<'), '&gt;', '>') AS 'OrderLevel'
		FROM ClientOrders AS CO1
		WHERE CO1.clientId IS NOT NULL
		GROUP BY CO1.ClientId;

		INSERT INTO #OrderObservations
		SELECT CO1.ClientId
			,REPLACE(REPLACE(STUFF((
							SELECT DISTINCT ', ' + OrderName
							FROM ClientOrders AS CO
							INNER JOIN Orders AS R ON CO.OrderId = R.OrderId
								AND R.ShowOnWhiteBoard = 'Y'
								AND isNull(CO.RecordDeleted, 'N') <> 'Y'
								AND isNull(R.RecordDeleted, 'N') <> 'Y'
								AND isNull(R.Active, 'Y') = 'Y'
								AND CO.OrderPendRequiredRoleAcknowledge <> 'Y'
								AND CO.OrderPendAcknowledge <> 'Y'
							WHERE CO1.ClientId = CO.ClientId
							FOR XML PATH('')
							), 1, 1, ''), '&lt;', '<'), '&gt;', '>') AS 'Observations'
		FROM ClientOrders AS CO1
		WHERE CO1.clientId IS NOT NULL
		GROUP BY CO1.ClientId;

		INSERT INTO #ClientOverdueMedication
		SELECT CO.ClientId
			,COUNT(*)
		FROM MedAdminRecords AS MA
		INNER JOIN ClientOrders AS CO ON MA.ClientOrderId = CO.ClientOrderId
			AND ISNULL(CO.RecordDeleted, 'N') = 'N'
			AND (ISNULL(MA.RecordDeleted, 'N') = 'N')
			AND isnull(CO.OrderDiscontinued, 'N') <> 'Y'
			AND ISNULL(CO.OrderPendAcknowledge, 'N') = 'N'
		INNER JOIN Clients AS C ON C.ClientId = CO.ClientId
			AND ISNULL(C.RecordDeleted, 'N') = 'N'
		INNER JOIN Orders AS O ON CO.OrderId = O.OrderId
			AND ISNULL(O.RecordDeleted, 'N') = 'N'
			AND ISNULL(O.Active, 'Y') = 'Y'
		--INNER JOIN OrderFrequencies AS OFS ON OFS.OrderFrequencyId = CO.OrderFrequencyId      
		-- AND ISNULL(OFS.RecordDeleted, 'N') = 'N'      
		INNER JOIN OrderTemplateFrequencies AS OTF ON OTF.OrderTemplateFrequencyId = CO.OrderTemplateFrequencyId
			AND ISNULL(OTF.RecordDeleted, 'N') = 'N'
		INNER JOIN GlobalCodes AS GC1 ON GC1.GlobalCodeId = OTF.TimesPerDay
			AND ISNULL(GC1.RecordDeleted, 'N') = 'N'
		LEFT JOIN GlobalCodes AS GC2 ON GC2.GlobalCodeId = O.AdministrationTimeWindow
			AND ISNULL(GC2.RecordDeleted, 'N') = 'N'
		WHERE MA.AdministeredDate IS NULL
			AND (
				DATEDIFF(mi, CAST(CAST(MA.ScheduledDate AS DATE) AS DATETIME) + CAST(CAST(MA.Scheduledtime AS TIME(0)) AS DATETIME), GETDATE()) >= CASE 
					WHEN ISNULL(GC2.CodeName, 0) = 0
						THEN 60
					ELSE GC2.CodeName
					END
				)
			AND ISNULL(DATEDIFF(hh, CAST(CAST(MA.ScheduledDate AS DATE) AS DATETIME) + CAST(CAST(MA.Scheduledtime AS TIME(0)) AS DATETIME), GETDATE()), 0) < @OverdueHours
		GROUP BY CO.ClientId;

		EXEC scsp_GetFallScore;

		INSERT INTO #ClientDueMedication
		SELECT CO.ClientId
			,COUNT(*)
		FROM MedAdminRecords AS MA
		INNER JOIN ClientOrders AS CO ON MA.ClientOrderId = CO.ClientOrderId
			AND ISNULL(CO.RecordDeleted, 'N') = 'N'
			AND (ISNULL(MA.RecordDeleted, 'N') = 'N')
			AND isnull(CO.OrderDiscontinued, 'N') <> 'Y'
			AND ISNULL(CO.OrderPendAcknowledge, 'N') = 'N'
		INNER JOIN Clients AS C ON C.ClientId = CO.ClientId
			AND ISNULL(C.RecordDeleted, 'N') = 'N'
		INNER JOIN Orders AS O ON CO.OrderId = O.OrderId
			AND ISNULL(O.RecordDeleted, 'N') = 'N'
			AND ISNULL(O.Active, 'Y') = 'Y'
		--INNER JOIN OrderFrequencies AS OFS ON OFS.OrderFrequencyId = CO.OrderFrequencyId      
		-- AND ISNULL(OFS.RecordDeleted, 'N') = 'N'      
		INNER JOIN OrderTemplateFrequencies AS OTF ON OTF.OrderTemplateFrequencyId = CO.OrderTemplateFrequencyId
			AND ISNULL(OTF.RecordDeleted, 'N') = 'N'
		INNER JOIN GlobalCodes AS GC1 ON GC1.GlobalCodeId = OTF.TimesPerDay
			AND ISNULL(GC1.RecordDeleted, 'N') = 'N'
		LEFT JOIN GlobalCodes AS GC2 ON GC2.GlobalCodeId = O.AdministrationTimeWindow
			AND ISNULL(GC2.RecordDeleted, 'N') = 'N'
		WHERE MA.AdministeredDate IS NULL
			AND (
				DATEDIFF(mi, CAST(CAST(MA.ScheduledDate AS DATE) AS DATETIME) + CAST(CAST(MA.Scheduledtime AS TIME(0)) AS DATETIME), GETDATE()) >= - (
					CASE 
						WHEN ISNULL(GC2.CodeName, 0) = 0
							THEN 60
						ELSE GC2.CodeName
						END
					)
				AND DATEDIFF(mi, CAST(CAST(MA.ScheduledDate AS DATE) AS DATETIME) + CAST(CAST(MA.Scheduledtime AS TIME(0)) AS DATETIME), GETDATE()) < CASE 
					WHEN ISNULL(GC2.CodeName, 0) = 0
						THEN 60
					ELSE GC2.CodeName
					END
				)
		GROUP BY CO.ClientId;

		INSERT INTO #ClientRenewalMedication
		SELECT CO.ClientId
			,COUNT(*)
		FROM ClientOrders AS CO
		INNER JOIN Documents D ON CO.DocumentVersionId = D.CurrentDocumentVersionId
			AND D.STATUS = 22
			AND ISNULL(CO.RecordDeleted, 'N') = 'N'
			AND isnull(CO.OrderDiscontinued, 'N') <> 'Y'
			AND ISNULL(CO.OrderPendAcknowledge, 'N') = 'N'
		WHERE CO.OrderScheduleId <> 8823 --Standing Administered Once      
			AND (
				CO.OrderEndDateTime IS NOT NULL
				AND (
					(
						CO.OrderEndDateTime > GETDATE()
						AND DATEDIFF(hh, GETDATE(), CO.OrderEndDateTime) <= 24
						)
					OR (
						CO.OrderEndDateTime < GETDATE()
						AND DATEDIFF(hh, CO.OrderEndDateTime, GETDATE()) <= 24
						)
					)
				)
		GROUP BY CO.ClientId;
		
		CREATE TABLE #MostRecentBedAssignment (
		BedAssignmentId INT,
		BedId INT
		)
		INSERT INTO #MostRecentBedAssignment ( BedAssignmentId,BedId )
		SELECT MAX(a.BedAssignmentId),a.BedId
		FROM dbo.BedAssignments AS a
		JOIN #ClientInPatientVisits AS b ON b.ClientInpatientVisitId = a.ClientInpatientVisitId
		WHERE ISNULL(a.RecordDeleted,'N')='N'
		AND CAST(a.StartDate AS DATE) <= CAST(@DateFilter AS DATE)
		AND a.Disposition IS NULL
		AND ( 
		     ( b.Status = 4983 -- on leave and bed is not available for scheduling
		      AND ISNULL(a.BedNotAvailable,'N')='Y'
			 )
			 OR 
			 (
			  b.Status = 4981 --scheduled and bed is not currently admitted or on hold
			  AND NOT EXISTS ( SELECT 1
							   FROM dbo.BedAssignments AS a2
							   JOIN #ClientInPatientVisits AS b2 ON b2.ClientInpatientVisitId = a2.ClientInpatientVisitId
							   WHERE a2.BedId = a.BedId
							   AND ISNULL(a2.RecordDeleted,'N')='N'
							   AND a2.Disposition IS NULL
							   AND ( ( b2.Status = 4982 ) --admitted
								    OR ( b2.Status = 4983 --on leave
										AND ISNULL(a2.BedNotAvailable,'N')='Y'
									   )
								   )
							)
			 )
			 OR 
			   (
			   b.Status = 4982 --admitted
			   )
		  )
		GROUP BY a.BedId
--ADDED ON 19-Jan-2017 BY Arjun K R

		CREATE TABLE #MainListPageTable (
		    BedId INT,
		    BedAssignmentId INT,
		    BedName VARCHAR(200),
		    DisplayAs VARCHAR(200),
		    ClientId INT,
		    ClientName VARCHAR(200),
		    ClientNameDisplay VARCHAR(200),
		    PrimaryClinicianId INT,
		    PrimaryPhysicianId INT,
		    Therapist VARCHAR(200),
		    Attending VARCHAR(200),
		    DOA DATE,
		    EDD DATE,
		    LCD DATE,
		    LOS INT,
		    MiscellaneousText VARCHAR(2000),
		    DandA INT,
		    DandAText VARCHAR(200),
		    WhiteBoardInfoId INT,
		    Color VARCHAR(200),
		    LegalStatusOrders VARCHAR(4000),
		    OrderLevel VARCHAR(4000),
		    UO INT,
		    Observations VARCHAR(4000),
		    OverdueMedicationCount INT,
		    ClientInpatientVisitId INT,
		    Unit VARCHAR(200),
		    DueMedicationCount INT,
		    RenewalFlag CHAR(1),
		    AuthorizationId INT,
		    AuthorizationDocumentId INT,
		    PrimaryPlan VARCHAR(500),
			ClientsAge INT,
			CompetencyStatus INT,
			CompetencyStatusText VARCHAR(100),
			LegalStatus INT,
			LegalStatusText VARCHAR(100),
			ClientGender VARCHAR(10),
			PapersToCourt DATETIME,
			ClientFlags VARCHAR(MAX)
		)
		INSERT INTO #MainListPageTable ( BedId, BedAssignmentId, BedName, DisplayAs, ClientId, ClientName,ClientNameDisplay, PrimaryClinicianId, PrimaryPhysicianId, Therapist, Attending,
		                                  DOA, EDD, LCD, LOS, MiscellaneousText, DandA, DandAText, WhiteBoardInfoId, Color, LegalStatusOrders, OrderLevel, UO,
		                                  Observations, OverdueMedicationCount, ClientInpatientVisitId, Unit, DueMedicationCount, RenewalFlag, AuthorizationId,
		                                  AuthorizationDocumentId, PrimaryPlan, ClientsAge, CompetencyStatus, CompetencyStatusText, LegalStatus, LegalStatusText,
		                                  ClientGender, PapersToCourt, ClientFlags )
		
		
		SELECT DISTINCT B.BedId,
		         BA.BedAssignmentId 
				,B.BedName
				,B.DisplayAs
				,CPV.ClientId
				, CASE WHEN ba.Status <> 5001 THEN CPV.ClientName ELSE NULL END AS ClientName
				, CASE WHEN ba.Status <> 5001 THEN CPV.ClientNameDisplay ELSE NULL END AS ClientNameDisplay
				,CASE WHEN cpv.ClientInpatientVisitId IS NOT NULL AND ba.Status <> 5001  THEN CPV.PrimaryClinicianId else null end  AS PrimaryClinicianId
				,CASE WHEN cpv.ClientInpatientVisitId IS NOT NULL AND ba.Status <> 5001  THEN CPV.PrimaryPhysicianId else null end AS PrimaryPhysicianId
				,CASE WHEN cpv.ClientInpatientVisitId IS NOT NULL AND ba.Status <> 5001  THEN ISNULL(SPC.DisplayAs,'Select') ELSE NULL END  AS Therapist
				,CASE WHEN cpv.ClientInpatientVisitId IS NOT NULL AND ba.Status <> 5001  THEN ISNULL(SPA.DisplayAs,'Select') ELSE NULL END  AS Attending
				,CASE WHEN cpv.ClientInpatientVisitId IS NOT NULL AND ba.Status <> 5001  then CPV.AdmitDate else null end  AS DOA
				,BA.EndDate AS EDD
				,CA.ToDate AS LCD
				,DATEDIFF(DAY, CPV.AdmitDate, GETDATE())  AS LOS
				,WB.MiscellaneousText
				,WB.DandA
				,CASE WHEN cpv.ClientInpatientVisitId IS NOT NULL AND ba.Status <> 5001 THEN ISNULL(GC.CodeName,'Select') ELSE NULL END AS DandAText
				,WB.WhiteBoardInfoId
				,SPA.Color
				,LS.LegalStatus
				,OL.OrderLevel
				,UAO.UnacknowledgeOrders AS UO
				,OB.Observations
				,COM.OverdueMedicationCount
				,CPV.ClientInpatientVisitId
				,U.DisplayAs AS Unit
				,CDM.DueMedicationCount
				,(
					CASE 
						WHEN ISNULL(CRM.RenewalMedicationCount, 0) > 0
							THEN 'Y'
						ELSE 'N'
						END
					) AS RenewalFlag
				,CA.AuthorizationId
				,CA.AuthorizationDocumentId
				--,dbo.ssf_GetPrimaryPlanName(CPV.ClientId) AS PrimaryPlan	
				,NULL AS PrimaryPlan
				, CASE WHEN ba.Status <> 5001 THEN cpv.ClientsAge ELSE NULL END AS ClientsAge
				, wb.CompetencyStatus
				,  CASE WHEN cpv.ClientInpatientVisitId IS NOT NULL			AND ba.Status <> 5001  THEN ISNULL(gccs.Code,'Select') ELSE NULL END AS CompetencyStatusText
				, wb.LegalStatus
				, CASE WHEN cpv.ClientInpatientVisitId IS NOT NULL			AND ba.Status <> 5001 THEN ISNULL(gcls.Code,'Select') ELSE NULL END   AS LegalStatusText
				, CASE WHEN ba.Status <> 5001 THEN cpv.ClientsGender ELSE NULL END AS ClientsGender
				, CASE WHEN cpv.ClientInpatientVisitId IS NOT NULL			AND ba.Status <> 5001  THEN ISNULL(wb.PapersToCourt,DATEADD(DAY,3,cpv.AdmitDate)) ELSE NULL END AS PapersToCourt
				, cf.Flags AS ClientFlags
			FROM BedAvailabilityhistory AS BAH
			INNER JOIN Programs AS PGM ON BAH.ProgramId = PGM.ProgramId
				AND PGM.InpatientProgram = 'Y'
				AND ISNULL(PGM.RecordDeleted, 'N') <> 'Y'
			INNER JOIN Beds AS B ON BAH.BedId = B.BedId
				AND ISNULL(B.RecordDeleted, 'N') <> 'Y'
			INNER JOIN Rooms AS R ON B.RoomId = R.RoomId
				AND ISNULL(R.RecordDeleted, 'N') <> 'Y'
			INNER JOIN Units AS U ON R.UnitId = U.UnitId
				AND ISNULL(U.RecordDeleted, 'N') <> 'Y'
			LEFT JOIN BedAssignments AS BA ON B.BedId = BA.BedId
				AND ISNULL(BA.RecordDeleted, 'N') <> 'Y'
			    AND CONVERT(DATE,ba.StartDate) <= CONVERT(DATE,@DateFilter)
				AND EXISTS ( SELECT 1
							 FROM #MostRecentBedAssignment AS mr 
							 WHERE mr.BedAssignmentId = ba.BedAssignmentId
							 AND mr.BedId = ba.BedId
							 )
				AND BA.Disposition IS NULL
			LEFT JOIN GlobalCodes AS gcbs ON ba.Status = gcbs.GlobalCodeId
			LEFT JOIN #ClientInPatientVisits AS CPV ON BA.ClientInpatientVisitId = CPV.ClientInpatientVisitId			
			LEFT JOIN #UnacknowlwdgeOrders AS UAO ON CPV.ClientId = UAO.ClientId
				AND ba.Status <> 5001 --scheduled
			LEFT JOIN #LegalStatus AS LS ON CPV.ClientId = LS.ClientId
				AND ba.Status <> 5001 --scheduled
			LEFT JOIN #ClientFlags AS cf ON cf.ClientId = CPV.ClientId
				AND ba.Status <> 5001 --scheduled
			LEFT JOIN #OrderLevel AS OL ON CPV.ClientId = OL.ClientId
				AND ba.Status <> 5001 --scheduled
			LEFT JOIN #OrderObservations AS OB ON CPV.ClientId = OB.ClientId
				AND ba.Status <> 5001 --scheduled
			LEFT JOIN #ClientOverdueMedication AS COM ON CPV.ClientId = COM.ClientId
				AND ba.Status <> 5001 --scheduled
			LEFT JOIN #ClientDueMedication AS CDM ON CPV.ClientId = CDM.ClientId			
				AND ba.Status <> 5001 --scheduled
			LEFT JOIN #ClientRenewalMedication AS CRM ON CPV.ClientId = CRM.ClientId
				AND ba.Status <> 5001 --scheduled
			LEFT JOIN WhiteBoard AS WB ON CPV.ClientInpatientVisitId = WB.ClientInpatientVisitId
				AND ISNULL(WB.RecordDeleted, 'N') <> 'Y'
				AND ba.Status <> 5001 --scheduled
			LEFT JOIN GlobalCodes AS gccs ON wb.CompetencyStatus = gccs.GlobalCodeId
			LEFT JOIN GlobalCodes AS gcls ON wb.LegalStatus = gcls.GlobalCodeId
			LEFT JOIN Staff AS SPC ON CPV.PrimaryClinicianId = SPC.StaffId
			LEFT JOIN Staff AS SPA ON CPV.PrimaryPhysicianId = SPA.StaffId        
			
			LEFT JOIN (
				SELECT DENSE_RANK() OVER (
						PARTITION BY CCP.ClientId ORDER BY A.EndDate DESC
						) AS RowNo
					,A.EndDate AS ToDate
					,CCP.ClientId
					,A.AuthorizationId AS AuthorizationId
					,AD.AuthorizationDocumentId AS AuthorizationDocumentId
				FROM Clients AS C
				INNER JOIN ClientCoveragePlans AS CCP ON CCP.ClientId = C.ClientId
					AND ISNULL(CCP.RecordDeleted, 'N') <> 'Y'
				INNER JOIN AuthorizationDocuments AS AD ON AD.ClientCoveragePlanId = CCP.ClientCoveragePlanId
					AND ISNULL(AD.RecordDeleted, 'N') <> 'Y'
				INNER JOIN Authorizations AS A ON A.AuthorizationDocumentId = AD.AuthorizationDocumentId
					AND ISNULL(A.RecordDeleted, 'N') <> 'Y'
					AND A.STATUS = 4243 --Approved      
					AND A.AuthorizationCodeId IN (
						SELECT integercodeid
						FROM dbo.Ssf_recodevaluescurrent('XBEDAUTHORIZATIONCODES')
						)
				) AS CA ON CPV.ClientId = CA.ClientId
				AND CA.RowNo = 1     
			LEFT JOIN GlobalCodes AS GC ON WB.DandA = GC.GlobalCodeId
			WHERE  
			--Added by Deej 7/24/2018
                     (@ListDataBasedOnStaffsAccessToProgramsAndUnits='N' or (@ListDataBasedOnStaffsAccessToProgramsAndUnits='Y' and
				(EXISTS(select 1 from StaffUnits SU WHERE SU.StaffId=@StaffId AND SU.UnitId=U.UnitId and ISNULL(SU.Recorddeleted,'N')='N' )
				AND EXISTS(SELECT 1 FROM StaffPrograms SP WHERE SP.StaffId=@StaffId AND SP.ProgramId=PGM.ProgramId AND ISNULL(SP.RecordDeleted,'N')='N'  ) ))) AND
			(BAH.StartDate <= @DateFilter)
				AND (
					BAH.EndDate IS NULL
					OR BAH.EndDate >= @DateFilter
					)
				AND (
					@AttendingFilter = - 1 --All Attending          
					OR CPV.PrimaryPhysicianId = @AttendingFilter
					)
				AND (
					@DAFilter = - 1 -- All D&A          
					OR WB.DandA = @DAFilter
					)
				AND (
					@UnitsFilter = - 1
					OR U.UnitId = @UnitsFilter
					)
				AND (
					@BedFilter = - 1 -- All Beds      
					OR (
						@BedFilter = 2
						AND BA.STATUS = 5002
						) --Occupied Beds      
					OR (
						@BedFilter = 1
						AND NOT EXISTS (
							SELECT BedId
							FROM BedAssignments BAS
							WHERE BAS.BedId = B.BedId
								AND ISNULL(BAS.RecordDeleted, 'N') <> 'Y'
								AND BAS.STATUS = 5002
								AND CONVERT(VARCHAR(10), BAS.StartDate, 101) <= CONVERT(VARCHAR(10), @DateFilter, 101)
								AND BAS.Disposition IS NULL
							) --Open Beds      
						)
					)
				--   Added ShowOnWhiteBoard conditions in filter Philhaven Development #248      
				AND ISNULL(U.ShowOnWhiteBoard, 'N') = 'Y'
				AND (
					@ProgramFilter = - 1
					OR BAH.ProgramId = @ProgramFilter
					)
					-- if client inpatient visit is not assigned, then the bed is considered unoccupied, therefore it can be displayed
					AND (
							(@RestrictwhiteboardListToStaffClients <> 'Y') -- only restrict to staff clients if systemconfiguration key is set to Y
							OR (
								(CPV.ClientId is null)
									OR (Exists (Select 1 From  StaffClients SC Where  SC.ClientId=CPV.ClientId AND SC.StaffId=@StaffId ))
							)
						) -- 30-July-2018  Bibhu
					
		UPDATE M
		SET M.PrimaryPlan= c.CoveragePlanName
		FROM #MainListPageTable M join (
		   SELECT CCP.ClientId ,CP.CoveragePlanName
			 FROM ClientCoveragePlans CCp  
			 INNER JOIN ClientCoverageHistory CCH ON CCH.ClientCoveragePlanId = CCP.ClientCoveragePlanId  
			  AND ISNULL(CCP.RecordDeleted, 'N') = 'N'  
			  AND CCH.StartDate <= getdate()  
			  AND (  
			   CCH.EndDate IS NULL  
			   OR CCH.EndDate > dateadd(dd, 1, getdate())  
			   )  
			  AND CCH.COBOrder = 1  
			 LEFT JOIN CoveragePlans CP ON CP.CoveragePlanId = CCP.CoveragePlanId  
			  AND CP.Active = 'Y'  
			  AND ISNULL(CP.RecordDeleted, 'N') = 'N'  
		) C ON M.ClientId=C.ClientId
    		
			DECLARE @TotalCount INT = 0;					
		
-- Modified on 19-Jan-2017 by Arjun K R
		
		
			SELECT BedId,
			BedAssignmentId,
		    BedName,
		    DisplayAs,
		    ClientId,
		    ClientName,
		    ClientNameDisplay,
		    PrimaryClinicianId,
		    PrimaryPhysicianId,
		    Therapist,
		    Attending,
		    DOA,
		    EDD,
		    LCD,
		    LOS,
		    MiscellaneousText,
		    DandA,
		    DandAText,
		    WhiteBoardInfoId,
		    Color,
		    LegalStatusOrders,
		    OrderLevel,
		    UO,
		    Observations,
		    OverdueMedicationCount,
		    ClientInpatientVisitId,
		    Unit,
		    DueMedicationCount,
		    RenewalFlag,
		    AuthorizationId,
		    AuthorizationDocumentId,
		    PrimaryPlan,
			ClientsAge,
			CompetencyStatus ,
			CompetencyStatusText,
			LegalStatus,
		    LegalStatusText,
			ClientGender ,
			PapersToCourt,
			ClientFlags
			INTO #GetListPageWhiteBoard
		    FROM #MainListPageTable
			
			SELECT @TotalCount = ISNULL(COUNT(*),0)
			FROM #GetListPageWhiteBoard
			
			SELECT BedId,
			BedAssignmentId
				,BedName
				,DisplayAs
				,ClientId
				,ClientNameDisplay
				
				,PrimaryClinicianId
				,PrimaryPhysicianId
				,Therapist
				,Attending
				,DOA
				,EDD
				,LCD
				,LOS
				,MiscellaneousText
				,DandA
				,DandAText
				,WhiteBoardInfoId
				,Color
				,LegalStatusOrders
				,OrderLevel
				,UO
				,Observations
				,OverdueMedicationCount
				,ClientInpatientVisitId
				,Unit
				,DueMedicationCount
				,RenewalFlag
				,AuthorizationId
				,AuthorizationDocumentId
				,PrimaryPlan
			    ,ClientsAge
			    ,CompetencyStatus 
				,CompetencyStatusText
				,LegalStatus
				,LegalStatusText
			    ,ClientGender 
			    ,PapersToCourt
			    ,ClientFlags
				,COUNT(*) OVER () AS TotalCount
				,ROW_NUMBER() OVER (
					ORDER BY CASE 
							WHEN @SortExpression = 'DisplayAs'
								THEN DisplayAs
							END
						,CASE 
							WHEN @SortExpression = 'DisplayAs desc'
								THEN DisplayAs
							END DESC
						,CASE 
							WHEN @SortExpression = 'ClientName'
								THEN ClientName
							END
						,CASE 
							WHEN @SortExpression = 'ClientName desc'
								THEN ClientName
							END DESC
						,CASE 
							WHEN @SortExpression = 'Therapist'
								THEN Therapist
							END
						,CASE 
							WHEN @SortExpression = 'Therapist desc'
								THEN Therapist
							END DESC
						,CASE 
							WHEN @SortExpression = 'Attending'
								THEN Attending
							END
						,CASE 
							WHEN @SortExpression = 'Attending desc'
								THEN Attending
							END DESC
						,CASE 
							WHEN @SortExpression = 'DOA'
								THEN DOA
							END
						,CASE 
							WHEN @SortExpression = 'DOA desc'
								THEN DOA
							END DESC
						,CASE 
							WHEN @SortExpression = 'EDD'
								THEN EDD
							END
						,CASE 
							WHEN @SortExpression = 'EDD desc'
								THEN EDD
							END DESC
						,CASE 
							WHEN @SortExpression = 'LCD'
								THEN LCD
							END
						,CASE 
							WHEN @SortExpression = 'LCD desc'
								THEN LCD
							END DESC
						,CASE 
							WHEN @SortExpression = 'LOS'
								THEN LOS
							END
						,CASE 
							WHEN @SortExpression = 'LOS desc'
								THEN LOS
							END DESC
						,CASE 
							WHEN @SortExpression = 'DandAText'
								THEN DandAText
							END
						,CASE 
							WHEN @SortExpression = 'DandAText desc'
								THEN DandAText
							END DESC
						,CASE 
							WHEN @SortExpression = 'OrderLevel'
								THEN OrderLevel
							END
						,CASE 
							WHEN @SortExpression = 'OrderLevel desc'
								THEN OrderLevel
							END DESC
						,CASE 
							WHEN @SortExpression = 'UO'
								THEN UO
							END
						,CASE 
							WHEN @SortExpression = 'UO desc'
								THEN UO
							END DESC
						,CASE 
							WHEN @SortExpression = 'Unit'
								THEN Unit
							END
						,CASE 
							WHEN @SortExpression = 'Unit desc'
								THEN Unit
							END DESC
						,CASE 
							WHEN @SortExpression = 'Unit'
								THEN DisplayAs
							END
						,CASE 
							WHEN @SortExpression = 'Unit desc'
								THEN DisplayAs
							END DESC
						,CASE 
							WHEN @SortExpression = 'PrimaryPlan'
								THEN PrimaryPlan
							END
						,CASE 
							WHEN @SortExpression = 'PrimaryPlan desc'
								THEN PrimaryPlan
							END DESC
							,CASE 
							WHEN @SortExpression = 'ClientsAge'
								THEN ClientsAge
							END
						,CASE 
							WHEN @SortExpression = 'ClientsAge desc'
								THEN ClientsAge
							END DESC
							,CASE 
							WHEN @SortExpression = 'CompetencyStatus'
								THEN CompetencyStatus
							END
						,CASE 
							WHEN @SortExpression = 'CompetencyStatus desc'
								THEN CompetencyStatus
							END DESC							
						,CASE 
							WHEN @SortExpression = 'ClientGender'
								THEN ClientGender 
							END
						,CASE 
							WHEN @SortExpression = 'ClientGender desc'
								THEN ClientGender 
							END DESC							
						,CASE 
							WHEN @SortExpression = 'PapersToCourt'
								THEN PapersToCourt
							END
						,CASE 
							WHEN @SortExpression = 'PapersToCourt desc'
								THEN PapersToCourt
							END DESC							
						,CASE 
							WHEN @SortExpression = 'ClientFlags'
								THEN ClientFlags
							END
						,CASE 
							WHEN @SortExpression = 'ClientFlags desc'
								THEN ClientFlags
							END DESC
						,CASE 
							WHEN @SortExpression = 'Observations'
								THEN Observations
							END
						,CASE 
							WHEN @SortExpression = 'Observations desc'
								THEN Observations
							END DESC
						,CASE 
							WHEN @SortExpression = 'LegalStatusOrders'
								THEN LegalStatusOrders
							END
						,CASE 
							WHEN @SortExpression = 'LegalStatusOrders desc'
								THEN LegalStatusOrders
							END DESC
						,CASE 
							WHEN @SortExpression = 'LegalStatus'
								THEN LegalStatus
							END
						,CASE 
							WHEN @SortExpression = 'LegalStatus desc'
								THEN LegalStatus
							END DESC
						
						,CASE 
							WHEN @SortExpression = 'DandAText'
								THEN DandAText
							END
						,CASE 
							WHEN @SortExpression = 'DandAText desc'
								THEN DandAText
							END DESC
						
						,CASE 
							WHEN @SortExpression = 'PrimaryPlan'
								THEN PrimaryPlan
							END
						,CASE 
							WHEN @SortExpression = 'PrimaryPlan desc'
								THEN PrimaryPlan
							END DESC
					--	,BedId
					) AS RowNumber
					INTO #RankResultSet
			FROM #GetListPageWhiteBoard
			PRINT CONVERT(VARCHAR(max),@TotalCount) + ' Total Count'
			PRINT CONVERT(VARCHAR(max),@PageNumber) + ' Page Number'
			PRINT CONVERT(VARCHAR(max),@PageSize) + ' Page Size'
		SELECT TOP (
				CASE 
					WHEN @PageNumber = -1
						THEN @TotalCount
					ELSE @PageSize
					END
				) 
		     BedId,
		     BedAssignmentId
			,BedName
			,DisplayAs
			,ClientId
			,ClientNameDisplay
			,PrimaryClinicianId
			,PrimaryPhysicianId
			,Therapist
			,Attending
			,DOA
			,EDD
			,LCD
			,LOS
			,MiscellaneousText
			,DandA
			,DandAText
			,WhiteBoardInfoId
			,Color
			,LegalStatusOrders
			,OrderLevel
			,TotalCount
			,UO
			,Observations
			,OverdueMedicationCount
			,ClientInpatientVisitId
			,RowNumber
			,Unit
			,DueMedicationCount
			,RenewalFlag
			,AuthorizationId
			,AuthorizationDocumentId
			,PrimaryPlan
			,ClientsAge
			,CompetencyStatus 
			,CompetencyStatusText
		    ,LegalStatus
			,LegalStatusText
			,ClientGender 
			,PapersToCourt
			,ClientFlags
			, CASE WHEN @TotalCount = 0 THEN -1 ELSE @PageNumber END AS PageNumber
	        , @TotalCount AS NumberOfRows
            , CASE WHEN @TotalCount = 0 THEN 0 ELSE  CASE (TotalCount % @PageSize)
					WHEN 0
						THEN ISNULL((@TotalCount / @PageSize), 0)
					ELSE ISNULL((@TotalCount / @PageSize), 0) + 1
					END 
					END AS NumberOfPages
		INTO #FinalResultSet
		FROM #RankResultSet
		WHERE RowNumber > ((@PageNumber - 1) * @PageSize);

		IF (
				@WhiteBoardMonitor = 0
				OR @WhiteBoardMonitor = 1
				)
		BEGIN
			SELECT BedId,
			BedAssignmentId
				,BedName
				,DisplayAs
				,ClientId
				,ClientNameDisplay as ClientName
				,PrimaryClinicianId
				,PrimaryPhysicianId
				,Therapist
				,Attending
				,DOA
				,EDD
				,LCD
				,LOS
				,MiscellaneousText
				,DandA
				,DandAText
				,WhiteBoardInfoId
				,Color
				,LegalStatusOrders
				,OrderLevel
				,UO
				,Observations
				,OverdueMedicationCount
				,ClientInpatientVisitId
				,Unit
				,DueMedicationCount
				,RenewalFlag
				,AuthorizationId
				,AuthorizationDocumentId
				,PrimaryPlan
				,RowNumber
			    ,ClientsAge
			    ,CompetencyStatus 
				,CompetencyStatusText
				,LegalStatus
				,LegalStatusText
				,ClientGender 
				,PapersToCourt
				,ClientFlags
				,PageNumber
				,NumberOfRows
				,NumberOfPages
			FROM #FinalResultSet
			ORDER BY RowNumber;
		END

		IF (
				@WhiteBoardMonitor = 0
				OR @WhiteBoardMonitor = 2
				)
		BEGIN
			SELECT CO.ClientId
				,CO.ClientOrderId
				,O.OrderName
			FROM ClientOrders AS CO
			INNER JOIN Orders AS O ON CO.OrderId = O.OrderId
				AND ISNULL(O.RecordDeleted, 'N') = 'N'
				AND ISNULL(O.Active, 'Y') = 'Y'
				AND ISNULL(CO.RecordDeleted, 'N') = 'N'
				AND isnull(CO.OrderDiscontinued, 'N') <> 'Y'
				AND ISNULL(CO.OrderPendAcknowledge, 'N') = 'N'
			INNER JOIN Documents D ON CO.DocumentVersionId = D.CurrentDocumentVersionId
				AND D.STATUS = 22
				AND ISNULL(D.RecordDeleted, 'N') = 'N'
			WHERE CO.OrderScheduleId <> 8823 --Standing Administered Once      
				AND (
					CO.OrderEndDateTime IS NOT NULL
					AND (
						(
							CO.OrderEndDateTime > GETDATE()
							AND DATEDIFF(hh, GETDATE(), CO.OrderEndDateTime) <= 24
							)
						OR (
							CO.OrderEndDateTime < GETDATE()
							AND DATEDIFF(hh, CO.OrderEndDateTime, GETDATE()) <= 24
							)
						)
					)
		END
		IF (
		@WhiteBoardMonitor = 0
		OR @WhiteBoardMonitor = 1
		)
		BEGIN
		IF @WhiteBoardMonitor <> 0
		BEGIN 
		SELECT NULL AS MedicationsTable
		END
		SELECT a.PrecautionId, a.PrecautionComment,gc.CodeName,gc.Code,a.WhiteBoardPrecautionId,a.WhiteBoardInfoId
		FROM dbo.WhiteBoardPrecautions AS a
		JOIN #FinalResultSet AS b ON a.WhiteBoardInfoId = b.WhiteBoardInfoId
		AND ISNULL(a.RecordDeleted,'N')='N'
		JOIN GlobalCodes AS gc ON a.PrecautionId = gc.GlobalCodeId
		AND ISNULL(gc.RecordDeleted,'N')='N'

		END
		DROP TABLE #UnacknowlwdgeOrders;

		DROP TABLE #LegalStatus;

		DROP TABLE #OrderLevel;

		DROP TABLE #OrderObservations;

		DROP TABLE #ClientOverdueMedication;

		DROP TABLE #ClientInPatientVisits;

		DROP TABLE #ClientDueMedication;
	END TRY

	BEGIN CATCH
		DECLARE @Error AS VARCHAR(8000);

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_ListPageWhiteBoard') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE());

		RAISERROR (
				@Error
				,16
				,1
				);-- Message text.                                                                                                             Severity.                                          State.                                                                   
	END CATCH
END
