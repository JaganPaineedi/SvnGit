IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_PMReception]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_PMReception]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_PMReception]
    @PageNumber INT ,
    @PageSize INT ,
    @SortExpression VARCHAR(100) ,
    @SelectedDate DATETIME ,
    @ReceptionViewId INT ,
    @Status INT ,
    @ClinicianId INT ,
    @OtherFilter INT ,
    @StaffId INT 
/********************************************************************************                                                  
-- Stored Procedure: ssp_PMReception
--
-- Copyright: Streamline Healthcate Solutions
--
-- Purpose: Procedure to return data for the Reception list page.
--
-- Author:  Girish Sanaba
-- Date:    20 May 2011
--
-- *****History****
23 Aug 2011		Suma			Added RowNumber and PageNumber to the final resultset
27 Aug 2011		Girish			Moved 'StaffClients' from 'where' clause to 'join'
22 Nov 2011		MSuma			Renamed column Procedure to ProcedureNAme as per standards
19 Jan 2012		WButt			Added column GroupServiceId to allow reschedule of Group Services
12.03.2012		Ponnin Selvan	Redesigned for Performance Tunning.
21.03.2012		MSuma			Modified GlobalCodeId for ReceptionStatus
4.04.2012		Ponnin Selvan	Conditions added for Export 
12.04.2012		MSuma			Dropped Temp table at the end
13.04.2012      PSelvan         Added Conditions for NumberOfPages.
JUN-12-2012		dharvey			Revised to concatenate the Note Details if more the 6 per client 
21.09.2012		Pselvan			Check condition for deleted Client.
5/Nov/2012		Mamta Gupta		#Task No. 35 (Primary Care Summit Pointe ) - To Show Appointments and 
								Services both with reception page.
7/Jul/2012		Mamta Gupta		#Task No. 35 (Primary Care Summit Pointe ) -
								NumberOfTimeRescheduled column set in case  of only primary care visits
OCT-6-2013		dharvey			Merged 2x and 3.5x 
Mar 04 2014		PradeepA		ClientFlags are selected for PC Appointments. #125 Primary Care-Summit Pointe.
04 Mar 2014		Rohith Uppin	Task#352 - Core bugs
								Modified sorting order by time and then within each time block alphabetically ascending order by client.
MAY-20-2014		dharvey			Modified logic to improve performance & Merged previous changes
JUN-09-2014		Akwinass		Modified the code to Avoid Error Status as per Task #134 in Core Bugs project.
July-10-2014    Varun			Modified logic to display flags for PC Appointments. Task #143 Primary Care-Summit Pointe
15 Dec 2014		Avi Goyal		What :Modified logic to display records for Triage also.
								Why : Task #614 Walk-Ins-Customer Flow ; Project: Network 180 - Customizations
16 Jan 2015		Avi Goyal		What : Changed NoteType Join to FlagTypes & applied Permissioned & display checks 
								Why : Task # 600 Securiry Alerts ; Project : Network-180 Customizations
Feb-13-2015		Ponnin			Returning Copayamount for the services by calling 'ssp_GetCopayAmountForServices' Stored procedure. For task #135 of Philhaven Development.
/* Mar-5-2015	Ponnin			Reduced CopayReceived Amount from the TotalCopay of the Client. For task #135 of Philhaven Development.*/
Apr-30-2015		Gautam			Added code to excludes 'Medication Procedure Codes','Bed Procedure Codes' and Procedures  that 
								are marked as 'Do not show this service on the staff calendar.' from ProcedureCodes , Task#1264,Philhaven - Customization Issues Tracking
/* May-14-2015	Ponnin			Returing Copay amount instead of showing unapplied Copay amount. For task #135.1 of Philhaven Development.*/
/* May-14-2015	Ponnin			Changed Status column to StatusId for the temp table #tempReception. Why: For task #580 of Care Management to SmartCare Env. Issues Tracking.*/
/* June-15-2015	Anto			Adding Client Id with Client name. For task #133 of Woodlands - 3.5 Implementation
.*/
/* June-17-2015	Gautam			Changed the time format in RankResultset. */
30 Jul 2015		Avi Goyal		What : Modified @ReceptionViewId condition
								Why  : Task # 269 ReceptionView Filter not working correctly on Reception List Page ; Project : Valley Client Acceptance Testing Issues
--16 Dec 2015		Basudev Sahu		Modified For Task #609 Network180 Customization						
--19 Jan 2016		Venkatesh	Added ClientPhoneNumber column in the result set per task Valley Go Live Support - 747
--27 July 2016		Basudev Sahu	What : Added logic to color change to look at the time and the date for Reception List Page.
									Why : Task #303 Network 180 Environment Issues Tracking .
--29 Aug 2016		Basudev Sahu	What : Removed order by time for walk in  for Reception List Page.
									Why : Task #369 Network 180 Environment Issues Tracking .
22-Nov-2016 Sachin Borgave		Added Cast([ClientBalance] AS Money) for Getting ASC and DESC Sort Expression For Core Bugs #2329
--21 Sept 2017      PradeepT    What: Made check for recorddeleted to get only non deleted recodes
--                              Why: earlier it was fetching those recodes which are recorddeleted.Task Renaissance - Core System Setup-#4060
--15 Jan 2018       Gautam      What: Added code to display Copay Collect Up Front with copay amount as tooltip on CP icon.
								Why: As per task#619, Engineering Improvement Initiatives- NBL(I),Show Copay Collect Up Front on Reception 
--16 May 2018		Msood		What: Added a new SystemConfigurationKeys 'ShowAllTypesOfServicesOnReception' to display the Services which are Bed Procedure Code, Medication Procedure and Not On Calendar on Reception list page
								Why: Journey - Support Go Live Task #23			
--31 July 2018      Lakshmi     What: Added null check condition for @KeyValue field in stored procedure (ssp_PMReception)
								Why:  Reception screen not pulling appointments. (Bear River - Support Go Live #454)
-- 03-Aug-2018		Sachin		What :  Reception statuses in Recode COMPLETERECEPTIONSTATUS are not falling off reception as they should.When user change the status as Departure it should not display in Reception list Page.
                                Why  : The way this should work is any status in the recode category of COMPLETERECEPTIONSTATUS should disappear from the reception list screen immediately.  It should not retain the status until the next day.
                                       Hence, Added the AND condition instead of OR condition. for Aurora-Environment Issues Tracking #18.46	
-- 10/23/2018       MD          Added record deleted check for Recodes and RecodeCategories tables w.r.t task MHP-Support Go Live #821                                          	
*********************************************************************************/    
AS 
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

    BEGIN                                                              

        BEGIN TRY
        
        ------------------------------------------------------------------------------------------------------------------------
        -- Added by Avi Goyal, on 15 Dec 2014
        ------------------------------------------------------------------------------------------------------------------------
        DECLARE @FetchServiceRecords type_YORN='N'
        DECLARE @FetchAppointmentRecords type_YORN='N'
        DECLARE @FetchTriageRecords type_YORN='N'
        -- Msood 05/16/2018
        DECLARE @KeyValue VarChar(5) ='No'
        Select @KeyValue=Value from SystemConfigurationKeys where [Key]   = 'ShowAllTypesOfServicesOnReception'
			IF (@ReceptionViewId<>-1)
			BEGIN
				IF(ISNULL((SELECT TOP 1 AllTypes FROM ReceptionViews WHERE ReceptionViewId=@ReceptionViewId),'Y')='Y')
				BEGIN
					SET @FetchServiceRecords = 'Y'
					SET @FetchAppointmentRecords = 'Y'
					SET @FetchTriageRecords = 'Y'
				END
				ELSE
				BEGIN
					IF EXISTS (SELECT 1 From ReceptionViewTypes WHERE ReceptionViewId=@ReceptionViewId AND ISNULL(RecordDeleted,'N')='N' AND dbo.GetGlobalCodeName(Type)='Services')
					BEGIN
						SET @FetchServiceRecords = 'Y'
					END
					IF EXISTS (SELECT 1 From ReceptionViewTypes WHERE ReceptionViewId=@ReceptionViewId AND ISNULL(RecordDeleted,'N')='N' AND dbo.GetGlobalCodeName(Type)='Primary Care Visits')
					BEGIN
						SET @FetchAppointmentRecords = 'Y'
					END
					IF EXISTS (SELECT 1 From ReceptionViewTypes WHERE ReceptionViewId=@ReceptionViewId AND ISNULL(RecordDeleted,'N')='N' AND dbo.GetGlobalCodeName(Type)='Triage')
					BEGIN
						SET @FetchTriageRecords = 'Y'
					END
				END
			END
			ELSE
			BEGIN
				SET @FetchServiceRecords = 'Y'
				SET @FetchAppointmentRecords = 'Y'
				SET @FetchTriageRecords = 'Y'
			END
			
			CREATE TABLE #tempReception
			(
				NumberOfTimeRescheduled VARCHAR(250),
                DateOfService DATETIME,
                Time DATETIME,
                Client VARCHAR(500),
                ProcedureName VARCHAR(500),
                Status VARCHAR(500),
                Staff VARCHAR(500),
                ClientBalance VARCHAR(500),
                Comment VARCHAR(MAX),
                ClientId INT,
                StatusId INT,
                ServiceId INT,
                ProgramId INT,
                LocationId INT,
                StaffId INT,
                ClientScanCount INT,
                GroupId INT,
                GroupServiceId INT,
                Flag INT,
                IsCrossedYellowLimit CHAR(1),
                IsCrossedRedLimit CHAR(1),
                --Added for task 747 by Venkatesh
                ClientPhonenumber VARCHAR(500)
            )
			
			CREATE TABLE #tempReceptionService
			(
				NumberOfTimeRescheduled VARCHAR(250),
				DateOfService DATETIME,
				Time DATETIME,
				Client VARCHAR(500),
				ProcedureName VARCHAR(500),
				Status VARCHAR(500),
				Staff VARCHAR(500),
				ClientBalance VARCHAR(500),
				Comment VARCHAR(MAX),
				ClientId INT,
				StatusId INT,
				ServiceId INT,
				ProgramId INT,
				LocationId INT,
				StaffId INT,
				ClientScanCount INT,
				GroupId INT,
				GroupServiceId INT,
				Flag INT,
				--Added for task 747 by Venkatesh
				ClientPhonenumber VARCHAR(500)
			)
			
			CREATE TABLE #tempReceptionAppointment
			(
				NumberOfTimeRescheduled VARCHAR(250),
				DateOfService DATETIME,
				Time DATETIME,
				Client VARCHAR(500),
				ProcedureName VARCHAR(500),
				Status VARCHAR(500),
				Staff VARCHAR(500),
				ClientBalance VARCHAR(500),
				Comment VARCHAR(MAX),
				ClientId INT,
				StatusId INT,
				ServiceId INT,
				ProgramId INT,
				LocationId INT,
				StaffId INT,
				ClientScanCount INT,
				GroupId INT,
				GroupServiceId INT,
				Flag INT,
				--Added for task 747 by Venkatesh
				ClientPhonenumber VARCHAR(500)
			)
			
			CREATE TABLE #tempReceptionTriage
			(
				NumberOfTimeRescheduled VARCHAR(250),
				DateOfService DATETIME,
				Time DATETIME,
				Client VARCHAR(500),
				ProcedureName VARCHAR(500),
				Status VARCHAR(500),
				Staff VARCHAR(500),
				ClientBalance VARCHAR(500),
				Comment VARCHAR(MAX),
				ClientId INT,
				StatusId INT,
				ServiceId INT,
				ProgramId INT,
				LocationId INT,
				StaffId INT,
				ClientScanCount INT,
				GroupId INT,
				GroupServiceId INT,
				Flag INT,
				--Added for task 747 by Venkatesh
				ClientPhonenumber VARCHAR(500)
			)
			
			CREATE TABLE #tempStatus
			(
				Status INT
			)
			INSERT INTO #tempStatus(Status)
			SELECT R.IntegerCodeID 
			FROM Recodes R
			INNER JOIN RecodeCategories RC ON R.RecodeCategoryId=RC.RecodeCategoryId
			WHERE RC.CategoryCode IN (
										SELECT RCIn.CategoryCode
										FROM RecodeCategories RCIn
										INNER JOIN Recodes RIn ON RIn.RecodeCategoryId=RCIn.RecodeCategoryId
										WHERE (RIn.IntegerCodeId=@Status OR @Status=-1)							
								  ) 
								  AND ISNULL(R.RecordDeleted,'N')='N'---21 Sept 2017, PradeepT
				  
			 
		------------------------------------------------------------------------------------------------------------------------
		
			
            DECLARE @EllipsisGlobalCodeId INT ,
                @EllipsisBitmap VARCHAR(100)
            SELECT  @EllipsisGlobalCodeId = GlobalCodeId ,
                    @EllipsisBitmap = Bitmap
            FROM    GlobalCodes
            WHERE   Category = 'CLIENTNOTETYPE'
                    AND CodeName = 'Ellipsis'
	
		------------------------------------------------------------------------------------------------------------------------
        -- Modified by Avi Goyal, on 15 Dec 2014
        ------------------------------------------------------------------------------------------------------------------------
			--DECLARE @CustomFilters TABLE
			--(
			--	ReceptionViewId INT NOT NULL
			--)
   
			CREATE TABLE #CustomFilters
			(
				ReceptionViewId INT NOT NULL
			)
        ------------------------------------------------------------------------------------------------------------------------                                                        
            DECLARE @ApplyFilterClicked CHAR(1)
            DECLARE @CustomFiltersApplied CHAR(1)
			
            SET @SortExpression = RTRIM(LTRIM(@SortExpression))
            IF ISNULL(@SortExpression, '') = '' 
                SET @SortExpression = 'Time'

			-- 
			-- New retrieve - the request came by clicking on the Apply Filter button                   
			--
            SET @ApplyFilterClicked = 'Y' 
            SET @CustomFiltersApplied = 'N'                                                 
			
	
            IF @OtherFilter > 10000 
            BEGIN
                SET @CustomFiltersApplied = 'Y'
	
                INSERT  INTO #CustomFilters
                ( 
					ReceptionViewId
                )
                EXEC scsp_PMReception @SelectedDate = @SelectedDate, @ReceptionViewId = @ReceptionViewId, @Status = @Status, @ClinicianId = @ClinicianId, @OtherFilter = @OtherFilter, @StaffId = @StaffId
            END
            
            
            
        ------------------------------------------------------------------------------------------------------------------------
        -- Added by Avi Goyal, on 15 Dec 2014
        ------------------------------------------------------------------------------------------------------------------------    
            -- Services 
            IF(@FetchServiceRecords = 'Y')
            BEGIN
				INSERT INTO #tempReceptionService
				(
					NumberOfTimeRescheduled,
					DateOfService,
					Time,
					Client,
					ProcedureName,
					Status,
					Staff,
					ClientBalance,
					Comment,
					ClientId,
					StatusId,
					ServiceId,
					ProgramId,
					LocationId,
					StaffId,
					ClientScanCount,
					GroupId,
					GroupServiceId,
					Flag,
					--Added for task 747 by Venkatesh
					ClientPhonenumber
				)
				SELECT
					'(' + CONVERT(VARCHAR, ISNULL(s.NumberOfTimeRescheduled, 0)) + ')' AS NumberOfTimeRescheduled ,
                    s.DateOfService ,
                    LTRIM(SUBSTRING(CONVERT(VARCHAR, s.DateOfService, 109), 12, 6)) + ' ' + LTRIM(SUBSTRING(CONVERT(VARCHAR, s.DateOfService, 109), 25, 2)) AS [Time] ,
                     CASE     
						WHEN ISNULL(C.ClientType, 'I') = 'I'
						 THEN ISNULL(C.LastName, '') + ', ' + ISNULL(C.FirstName, '')
						ELSE ISNULL(C.OrganizationName, '')
						END+ ' ' + '(' + CONVERT(VARCHAR,ISNULL(c.ClientId,0)) + ')' AS Client ,
                    --c.LastName + ', ' + c.FirstName AS Client,
                    pc.DisplayAs AS [ProcedureName],
                    gcs.CodeName AS [Status],
                    st.LastName + ', ' + st.FirstName + ISNULL(' ' + gcd.CodeName, '') AS Staff ,
					ISNULL(c.CurrentBalance, 0.00) AS ClientBalance,
					S.Comment ,
					c.ClientId ,
					s.[Status] AS StatusId ,
					s.ServiceId ,
					s.ProgramId ,
					s.LocationId ,
					st.StaffId ,
					ISNULL(ClientScanCount.ScanCount, 0) AS ClientScanCount ,
					ISNULL(gs.GroupId, 0) AS GroupId ,
					ISNULL(s.GroupServiceId, 0) AS GroupServiceId ,
					'1' AS Flag,
					-- Added by venkatesh
					(stuff((SELECT ', ' + cast(PhoneNumber as varchar(20))
				   FROM ClientPhones t2
				   where t2.ClientId = c.ClientId AND ISNULL(t2.RecordDeleted, 'N') = 'N'
				   FOR XML PATH('')),1,1,'') ) as ClientPhonenumber
					
                FROM Services s
                JOIN Clients c ON c.ClientId = s.ClientId
                JOIN StaffClients sc ON sc.ClientId = c.ClientId
                JOIN #tempStatus tS ON ts.Status=s.[Status]
                LEFT JOIN dbo.GroupServices gs ON s.GroupServiceId = gs.GroupServiceId
                LEFT JOIN Staff st ON st.StaffId = s.ClinicianId
                LEFT JOIN GlobalCodes gcd ON gcd.GlobalCodeId = st.Degree
                LEFT JOIN GlobalCodes gcs ON gcs.GlobalCodeId = s.Status
                JOIN ProcedureCodes pc ON pc.ProcedureCodeId = s.ProcedureCodeId
			    LEFT JOIN ( SELECT  ClientId ,
                                    COUNT(*) AS ScanCount
                            FROM    ClientScans CS
                            WHERE   CS.RecordDeleted = 'N'
                                    OR CS.RecordDeleted IS NULL
                            GROUP BY ClientId
                          ) ClientScanCount ON ClientScanCount.ClientId = s.ClientId
				WHERE ISNULL(s.RecordDeleted, 'N') = 'N'
                        AND ISNULL(c.RecordDeleted, 'N') = 'N'
                        AND ( s.ClinicianId = @ClinicianId OR @ClinicianId = -1 )
                        AND sc.StaffId = @StaffId
                         -- Msood 05/16/2018                       
						AND ((@KeyValue='Yes' and ISNULL(PC.NotOnCalendar,'N')='N' ) OR (ISNULL(@KeyValue,'No')='No' and Not exists (Select 1 from ProcedureCodes PC1 where PC1.ProcedureCodeId=s.ProcedureCodeId       
						AND  (ISNULL(PC1.BedProcedureCode,'N')='Y'or ISNULL(PC1.MedicationProcedureCode,'N')='Y' or ISNULL(PC1.NotOnCalendar,'N')='Y' ))))
						
                        AND s.DateOfService >= @SelectedDate
							AND s.DateOfService < DATEADD(dd, 1, @SelectedDate)
						AND (
									@ReceptionViewId=-1
									OR
									(ISNULL((SELECT TOP 1 AllStaff FROM ReceptionViews WHERE ReceptionViewId=@ReceptionViewId),'Y')='Y')
									OR
									(
										s.ClinicianId IN (
															SELECT DISTINCT StaffId 
															From ReceptionViewStaff
															WHERE ReceptionViewId=@ReceptionViewId 
																	AND ISNULL(RecordDeleted,'N')='N'
														) 
									
									)
							)
						AND (
								@ReceptionViewId=-1
								OR
								(ISNULL((SELECT TOP 1 AllLocations FROM ReceptionViews WHERE ReceptionViewId=@ReceptionViewId),'Y')='Y')
								OR
								(
									s.LocationId IN (
														SELECT DISTINCT LocationId 
														From ReceptionViewLocations
														WHERE ReceptionViewId=@ReceptionViewId 
																AND ISNULL(RecordDeleted,'N')='N'
													) 
								
								)
							)   
						AND (
							@ReceptionViewId=-1
							OR
							(ISNULL((SELECT TOP 1 AllPrograms FROM ReceptionViews WHERE ReceptionViewId=@ReceptionViewId),'Y')='Y')
							OR
							(
								s.ProgramId IN (
													SELECT DISTINCT ProgramId 
													From ReceptionViewPrograms
													WHERE ReceptionViewId=@ReceptionViewId 
															AND ISNULL(RecordDeleted,'N')='N'
												) 
							
							)
						) 
				
										
            END
            -- Appointment
            IF(@FetchAppointmentRecords = 'Y')
            BEGIN
				INSERT INTO #tempReceptionAppointment
					(
						NumberOfTimeRescheduled,
						DateOfService,
						Time,
						Client,
						ProcedureName,
						Status,
						Staff,
						ClientBalance,
						Comment,
						ClientId,
						StatusId,
						ServiceId,
						ProgramId,
						LocationId,
						StaffId,
						ClientScanCount,
						GroupId,
						GroupServiceId,
						Flag,
						--Added for task 747 by Venkatesh
						ClientPhonenumber
					)				
					SELECT   
						'(' + CONVERT(VARCHAR, ISNULL(a.NumberOfTimeRescheduled, 0)) + ')' AS NumberOfTimeRescheduled ,
						a.StartTime AS DateOfService ,
						RIGHT(CONVERT(VARCHAR(19), a.StartTime), 7) AS [Time] ,
						 c.LastName + ', ' + c.FirstName + ' ' + '(' + CONVERT(VARCHAR,ISNULL(c.ClientId,0)) + ')' AS Client ,
						--c.LastName + ', ' + c.FirstName AS Client ,
						gat.CodeName AS [ProcedureName] ,
						gcs.CodeName AS [Status] ,
						st.LastName + ', ' + st.FirstName + ISNULL(' ' + gcd.CodeName, '') AS Staff,
						ISNULL(c.CurrentBalance, 0.00) AS ClientBalance,
						ISNULL(a.Description, '') AS comment,
						c.ClientId,
						a.Status AS StatusId ,
						a.AppointmentId AS ServiceId ,
						0 AS ProgramId ,
						a.LocationId ,
						st.StaffId ,
						0 AS ClientScanCount ,
						0 AS GroupId ,
						0 AS GroupServiceId ,
						'2' AS Flag,
						--Added for task 747 by Venkatesh
						(stuff((SELECT ', ' + cast(PhoneNumber as varchar(20))
					   FROM ClientPhones t2
					   where t2.ClientId = c.ClientId AND ISNULL(t2.RecordDeleted, 'N') = 'N'
					   FOR XML PATH('')),1,1,'') ) as ClientPhonenumber
					   
					FROM Appointments a
					JOIN Clients c ON c.ClientId = a.ClientId
					JOIN StaffClients sc ON sc.ClientId = c.ClientId
					JOIN #tempStatus tS ON ts.Status=a.Status
					LEFT JOIN Staff st ON st.StaffId = a.StaffId
					LEFT JOIN GlobalCodes gcd ON gcd.GlobalCodeId = st.Degree
					LEFT JOIN GlobalCodes gcs ON gcs.GlobalCodeId = a.Status
												 AND gcs.Category = 'PCAPPOINTMENTSTATUS'
					LEFT JOIN GlobalCodes gat ON gat.GlobalCodeId = a.AppointmentType
					WHERE ISNULL(a.RecordDeleted, 'N') = 'N'
							AND ISNULL(c.RecordDeleted, 'N') = 'N'
							AND sc.StaffId = @StaffId
							AND a.ServiceId IS NULL
							AND ( @ClinicianId = -1
								  OR a.StaffId = @ClinicianId
								)
							AND a.StartTime >= @SelectedDate
							AND a.StartTime < DATEADD(dd, 1, @SelectedDate)
							AND (
									@ReceptionViewId=-1
									OR
									(ISNULL((SELECT TOP 1 AllStaff FROM ReceptionViews WHERE ReceptionViewId=@ReceptionViewId),'Y')='Y')
									OR
									(
										a.StaffId IN (
															SELECT DISTINCT StaffId 
															From ReceptionViewStaff
															WHERE ReceptionViewId=@ReceptionViewId 
																	AND ISNULL(RecordDeleted,'N')='N'
														) 
									
									)
								)
							AND (
									@ReceptionViewId=-1
									OR
									(ISNULL((SELECT TOP 1 AllLocations FROM ReceptionViews WHERE ReceptionViewId=@ReceptionViewId),'Y')='Y')
									OR
									(
										a.LocationId IN (
															SELECT DISTINCT LocationId 
															From ReceptionViewLocations
															WHERE ReceptionViewId=@ReceptionViewId 
																	AND ISNULL(RecordDeleted,'N')='N'
														) 
									
									)
								)
							--AND (
							--	@ReceptionViewId=-1
							--	OR
							--	(ISNULL((SELECT TOP 1 AllPrograms FROM ReceptionViews WHERE ReceptionViewId=@ReceptionViewId),'Y')='Y')
							--	OR
							--	(
							--		s.ProgramId IN (
							--							SELECT DISTINCT ProgramId 
							--							From ReceptionViewPrograms
							--							WHERE ReceptionViewId=@ReceptionViewId 
							--									AND ISNULL(RecordDeleted,'N')='N'
							--						) 
								
							--	)
							--)                  
            END
            -- Triage
            IF(@FetchTriageRecords = 'Y')
            BEGIN
				INSERT INTO #tempReceptionTriage
				(
						NumberOfTimeRescheduled,
						DateOfService,
						Time,
						Client,
						ProcedureName,
						Status,
						Staff,
						ClientBalance,
						Comment,
						ClientId,
						StatusId,
						ServiceId,
						ProgramId,
						LocationId,
						StaffId,
						ClientScanCount,
						GroupId,
						GroupServiceId,
						Flag,
						--Added for task 747 by Venkatesh
						ClientPhonenumber
					)				
					SELECT   
						'' AS NumberOfTimeRescheduled ,
						TAD.StartDate AS DateOfService ,						
						(
							SELECT TOP 1 Time 
							FROM TriageArrivalDetailStatusHistory TADSH 
							WHERE TADSH.TriageArrivalDetailId=TAD.TriageArrivalDetailId and ISNULL(TAD.RecordDeleted, 'N') = 'N'
							--ORDER BY Time ASC  -- Removed by Basudev for task #369 Network 180 Environment Issues Tracking
						) AS [Time],
						(CASE WHEN ISNULL(TAD.ClientID,0)>0
							THEN  
							CASE     
						WHEN ISNULL(C.ClientType, 'I') = 'I'
	THEN ISNULL(c.LastName,'') + ', ' + ISNULL(c.FirstName,'') + ' ' + '(' + CONVERT(VARCHAR,ISNULL(c.ClientId,0)) + ')'
						ELSE ISNULL(C.OrganizationName, '') + ' ' + '(' + CONVERT(VARCHAR,ISNULL(c.ClientId,0)) + ')'
						END 
							--c.LastName + ', ' + c.FirstName + ' ' + '(' + CONVERT(VARCHAR,ISNULL(c.ClientId,0)) + ')'   --(c.LastName + ', ' + c.FirstName)
							ELSE (TAD.ClientLastName + ', ' + TAD.ClientFirstName)
						END) AS Client ,
						gat.CodeName AS [ProcedureName] ,
						gcs.CodeName AS [Status] ,
						st.LastName + ', ' + st.FirstName + ISNULL(' ' + gcd.CodeName, '') AS Staff,
						ISNULL(c.CurrentBalance, 0.00) AS ClientBalance,
						ISNULL(TAD.Comments, '') AS comment,
						ISNULL(c.ClientId,-1) AS ClientId,
						TAD.Status AS StatusId ,
						TAD.TriageArrivalDetailId AS ServiceId ,
						0 AS ProgramId ,
						TAD.LocationId ,
						TAD.StaffId,
						0 AS ClientScanCount ,
						0 AS GroupId ,
						0 AS GroupServiceId ,
						'3' AS Flag,
						--Added for task 747 by Venkatesh
						(stuff((SELECT ', ' + cast(PhoneNumber as varchar(20))
					   FROM ClientPhones t2
					   where t2.ClientId = c.ClientId AND ISNULL(t2.RecordDeleted, 'N') = 'N'
					   FOR XML PATH('')),1,1,'') ) as ClientPhonenumber
						
					FROM TriageArrivalDetails TAD
					LEFT JOIN Clients c ON c.ClientId = TAD.ClientId
					LEFT JOIN StaffClients sc ON sc.ClientId = c.ClientId AND sc.StaffId = @StaffId
					JOIN #tempStatus tS ON ts.Status=TAD.Status
					LEFT JOIN Staff st ON st.StaffId = TAD.StaffId
					LEFT JOIN GlobalCodes gcd ON gcd.GlobalCodeId = st.Degree
					LEFT JOIN GlobalCodes gcs ON gcs.GlobalCodeId = TAD.Status
												 AND gcs.Category = 'TRIAGESTATUS'
					LEFT JOIN GlobalCodes gat ON gat.GlobalCodeId = TAD.ProcedureId
					WHERE ISNULL(TAD.RecordDeleted, 'N') = 'N'
							AND ISNULL(c.RecordDeleted, 'N') = 'N'							
							AND ( @ClinicianId = -1
								  OR TAD.StaffId = @ClinicianId
								)
							AND 
								(
										TAD.StartDate >= @SelectedDate
										AND TAD.StartDate < DATEADD(dd, 1, @SelectedDate)
								)
								AND -- Removed OR and added AND condition By Sachin
								(
										TAD.Status NOT IN (
														SELECT RComp.IntegerCodeID 
														FROM Recodes RComp
														INNER JOIN RecodeCategories RCComp ON RCComp.RecodeCategoryId=RComp.RecodeCategoryId
														WHERE RCComp.CategoryCode='COMPLETERECEPTIONSTATUS'
														-- Added by MD on 10/23/2015
														AND ISNULL(RComp.RecordDeleted, 'N') = 'N' 
														AND ISNULL(RCComp.RecordDeleted, 'N') = 'N'
													)
								)
								
									
							AND (
									@ReceptionViewId=-1
									OR
									(ISNULL((SELECT TOP 1 AllStaff FROM ReceptionViews WHERE ReceptionViewId=@ReceptionViewId),'Y')='Y')
									OR
									(
										TAD.StaffId IN (
															SELECT DISTINCT StaffId 
															From ReceptionViewStaff
															WHERE ReceptionViewId=@ReceptionViewId 
																	AND ISNULL(RecordDeleted,'N')='N'
														) 
									
									)
								)
							AND (
									@ReceptionViewId=-1
									OR
									(ISNULL((SELECT TOP 1 AllLocations FROM ReceptionViews WHERE ReceptionViewId=@ReceptionViewId),'Y')='Y')
									OR
									(
										TAD.LocationId IN (
															SELECT DISTINCT LocationId 
															From ReceptionViewLocations
															WHERE ReceptionViewId=@ReceptionViewId 
																	AND ISNULL(RecordDeleted,'N')='N'
														) 
									
									)
								)
							--AND (
							--	@ReceptionViewId=-1
							--	OR
							--	(ISNULL((SELECT TOP 1 AllPrograms FROM ReceptionViews WHERE ReceptionViewId=@ReceptionViewId),'Y')='Y')
							--	OR
							--	(
							--		s.ProgramId IN (
							--							SELECT DISTINCT ProgramId 
							--							From ReceptionViewPrograms
							--							WHERE ReceptionViewId=@ReceptionViewId 
							--									AND ISNULL(RecordDeleted,'N')='N'
							--						) 
								
							--	)
							--)    
									

	        END
	        
	        INSERT INTO #tempReception
	        (
				NumberOfTimeRescheduled,
                DateOfService,
                Time,
                Client,
                ProcedureName,
                Status,
                Staff,
                ClientBalance,
                Comment,
                ClientId,
                StatusId,
                ServiceId,
                ProgramId,
                LocationId,
                StaffId,
                ClientScanCount,
                GroupId,
                GroupServiceId,
                Flag,
                IsCrossedYellowLimit,
                IsCrossedRedLimit,
                --Added for task 747 by Venkatesh
                ClientPhonenumber
            )
           SELECT DISTINCT
				NumberOfTimeRescheduled,
                DateOfService,
                Time,
                Client,
                ProcedureName,
                Status,
                Staff,
                ClientBalance,
                Comment,
                ClientId,
                StatusId,
                ServiceId,
                ProgramId,
                LocationId,
                StaffId,
                ClientScanCount,
                GroupId,
                GroupServiceId,
                Flag,
                'N',
                'N',
                --Added for task 747 by Venkatesh
                ClientPhonenumber
            FROM #tempReceptionService
            UNION ALL
            SELECT DISTINCT
				NumberOfTimeRescheduled,
                DateOfService,
                Time,
                Client,
                ProcedureName,
                Status,
                Staff,
                ClientBalance,
                Comment,
                ClientId,
                StatusId,
                ServiceId,
                ProgramId,
                LocationId,
                StaffId,
                ClientScanCount,
                GroupId,
                GroupServiceId,
                Flag,
                'N',
                'N',
                --Added for task 747 by Venkatesh
                ClientPhonenumber
            FROM #tempReceptionAppointment
            UNION ALL
            SELECT DISTINCT
				tRT.NumberOfTimeRescheduled,
                tRT.DateOfService,
                tRT.Time,
                tRT.Client,
                tRT.ProcedureName,
                tRT.Status,
                tRT.Staff,
                tRT.ClientBalance,
                tRT.Comment,
                tRT.ClientId,
                tRT.StatusId,
                tRT.ServiceId,
                tRT.ProgramId,
                tRT.LocationId,
                tRT.StaffId,
                tRT.ClientScanCount,
                tRT.GroupId,
                tRT.GroupServiceId,
                tRT.Flag,
                (CASE 
					WHEN CAST(ISNULL(GCStat.ExternalCode1,'-1') AS INT)>0
						THEN
							CASE 
								WHEN(DATEDIFF(MINUTE,tRT.DateOfService + [Time] , GETDATE())>= CAST(ISNULL(GCStat.ExternalCode1,'-1') AS INT))    
       and (DATEDIFF(day,CAST(getdate() AS DATE), tRT.DateOfService) ) <= 0    --27 July 2016  Basudev Sahu 
								THEN 'Y'
								ELSE 'N'
							END
						ELSE 'N'
				END) AS IsCrossedYellowLimit,	
                (CASE 
					WHEN CAST(ISNULL(GCStat.ExternalCode2,'-1') AS INT)>0
						THEN
							CASE 
								WHEN(DATEDIFF(MINUTE,tRT.DateOfService + [Time] , GETDATE())> CAST(ISNULL(GCStat.ExternalCode2,'-1') AS INT))    
        and (DATEDIFF(day,CAST(getdate() AS DATE), tRT.DateOfService) ) <=0    --27 July 2016  Basudev Sahu 
								THEN 'Y'
								ELSE 'N'
							END
						ELSE 'N'
				END) AS IsCrossedRedLimit,
				--Added for task 747 by Venkatesh
				ClientPhonenumber	
            FROM #tempReceptionTriage tRT
            INNER JOIN GlobalCodes GCStat ON GCStat.GlobalCodeId=tRT.StatusId
	    ------------------------------------------------------------------------------------------------------------------------     
	    
	        
            CREATE TABLE #Notes
            (
				NoteId INT IDENTITY NOT NULL ,
				NoteOrder INT NULL ,
				ClientId INT NULL ,
				ClientNoteId INT NULL ,
				NoteType INT NULL ,
				Bitmap INT NULL ,
				NoteNumber INT NULL ,
				Note VARCHAR(100) NULL ,
				CodeName VARCHAR(250) NULL
            )   
   
			-- Get client notes    

            ;
            WITH ClientNotes_CTE AS 
            ( 
				SELECT
					cn.ClientId ,
                    cn.ClientNoteId ,
                    cn.NoteType ,
                    cn.Note ,
                    ISNULL(cn.NoteLevel, 0) AS NoteLevel ,
                    cn.StartDate ,
                    cn.EndDate ,
                    cn.CreatedDate
				FROM ClientNotes cn
				WHERE ISNULL(cn.RecordDeleted, 'N') = 'N' AND cn.Active = 'Y'
            )
            INSERT  INTO #Notes
            ( 
				NoteOrder ,
				ClientId ,
				ClientNoteId ,
				NoteType ,
				Bitmap ,
				Note ,
				CodeName
	        )
			SELECT
				ROW_NUMBER() OVER ( PARTITION BY cn.ClientId ORDER BY cn.ClientId, ISNULL(cn.NoteLevel, 0), cn.CreatedDate ) AS NoteOrder ,
				cn.ClientId ,
				cn.ClientNoteId ,
				cn.NoteType ,
				--gc.GlobalCodeId ,					-- Commented by Avi Goyal, on 16 Jan 2015 
				FT.FlagTypeId AS GlobalCodeId,		-- Added by Avi Goyal, on 16 Jan 2015  
				cn.Note ,
				--gc.CodeName						-- Commented by Avi Goyal, on 16 Jan 2015 
				FT.FlagType AS CodeName				-- Added by Avi Goyal, on 16 Jan 2015  
			FROM ClientNotes_CTE cn
            --LEFT JOIN GlobalCodes gc ON gc.GlobalCodeId = cn.NoteType		-- Commented by Avi Goyal, on 16 Jan 2015
			
			-- Added by Avi Goyal, on 16 Jan 2015
			INNER JOIN FlagTypes FT ON FT.FlagTypeId=CN.NoteType
											 AND ISNULL(FT.RecordDeleted,'N') = 'N' 
											 AND ISNULL(FT.DoNotDisplayFlag,'N')='N' 
											 AND (
													ISNULL(FT.PermissionedFlag,'N')='N'
													OR
													(
														ISNULL(FT.PermissionedFlag,'N')='Y' 
														AND 
														(
															(
																EXISTS( 
																		SELECT 1
																		FROM PermissionTemplateItems PTI 
																		INNER JOIN PermissionTemplates PT ON  PT.PermissionTemplateId=PTI.PermissionTemplateId AND ISNULL(PT.RecordDeleted,'N')='N' 
																																AND dbo.ssf_GetGlobalCodeNameById(PT.PermissionTemplateType)='Flags'
																		INNER JOIN StaffRoles SR ON SR.RoleId=PT.RoleId AND ISNULL(SR.RecordDeleted,'N')='N' 
																		WHERE ISNULL(PTI.RecordDeleted,'N')='N' 
																				AND PTI.PermissionItemId=FT.FlagTypeId 
																				AND SR.StaffId=@StaffId
																	   )
																OR
																EXISTS(
																		SELECT 1
																		FROM StaffPermissionExceptions SPE
																		WHERE SPE.StaffId=@StaffId
																			AND ISNULL(SPE.RecordDeleted,'N')='N' 
																			AND dbo.ssf_GetGlobalCodeNameById(SPE.PermissionTemplateType)='Flags'
																			AND SPE.PermissionItemId=FT.FlagTypeId AND SPE.Allow='Y'
																			AND (SPE.StartDate IS NULL OR CAST(SPE.StartDate AS DATE) <=CAST(GETDATE() AS DATE))
																			AND (SPE.EndDate IS NULL OR CAST(SPE.EndDate AS DATE) >=CAST(GETDATE() AS DATE))
																	  )
															)
															AND 
															NOT EXISTS(
																		SELECT 1
																		FROM StaffPermissionExceptions SPE
																		WHERE SPE.StaffId=@StaffId
																			AND ISNULL(SPE.RecordDeleted,'N')='N' 
																			AND dbo.ssf_GetGlobalCodeNameById(SPE.PermissionTemplateType)='Flags'
																			AND SPE.PermissionItemId=FT.FlagTypeId AND SPE.Allow='N'
																			AND (SPE.StartDate IS NULL OR CAST(SPE.StartDate AS DATE) <=CAST(GETDATE() AS DATE))
																			AND (SPE.EndDate IS NULL OR CAST(SPE.EndDate AS DATE) >=CAST(GETDATE() AS DATE))
																	  )
														)
													)
												 )    
            WHERE
				DATEDIFF(dd, cn.StartDate, @SelectedDate) >= 0
                AND ( 
						cn.EndDate IS NULL
                        OR DATEDIFF(dd, cn.EndDate, @SelectedDate) <= 0
                    ) --Code added by kuldeep ref task 476
				AND EXISTS ( 
								SELECT 1 
								FROM #tempReception T
								WHERE T.ClientId = cn.ClientId
							)
			 							
			ORDER BY cn.ClientId,cn.NoteLevel,cn.CreatedDate    



            CREATE TABLE #NoteColumns
			--DECLARE @NoteColumns TABLE
            (
				ClientId INT ,
				BitmapNo INT ,
				ClientNoteId1 INT ,
				NoteType1 INT ,
				Bitmap1 VARCHAR(200) ,
				Note1 VARCHAR(MAX) ,
				CodeName1 VARCHAR(250) ,
				ClientNoteId2 INT ,
				NoteType2 INT ,
				Bitmap2 VARCHAR(200) ,
				Note2 VARCHAR(MAX) ,
				CodeName2 VARCHAR(250) ,
				ClientNoteId3 INT ,
				NoteType3 INT ,
				Bitmap3 VARCHAR(200) ,
				Note3 VARCHAR(MAX) ,
				CodeName3 VARCHAR(250) ,
				ClientNoteId4 INT ,
				NoteType4 INT ,
				Bitmap4 VARCHAR(200) ,
				Note4 VARCHAR(MAX) ,
				CodeName4 VARCHAR(250) ,
				ClientNoteId5 INT ,
				NoteType5 INT ,
				Bitmap5 VARCHAR(200) ,
				Note5 VARCHAR(MAX) ,
				CodeName5 VARCHAR(250) ,
				ClientNoteId6 INT ,
				NoteType6 INT ,
				Bitmap6 VARCHAR(200) ,
				Note6 VARCHAR(MAX) ,
				CodeName6 VARCHAR(250)
            )
 
			 -------------
			 -------------      
            INSERT INTO #NoteColumns
            ( 
				ClientId
            )
            SELECT DISTINCT ClientId
            FROM #Notes          
 
            DECLARE @PKCounter INT
            DECLARE @LoopCounter INT
            DECLARE @ClientId INT
 
            SET @LoopCounter = ISNULL(( SELECT  COUNT(*) FROM #Notes ), 0)                                                                 
            SET @PKCounter = 1
 
            WHILE (@LoopCounter > 0 AND @PKCounter <= @LoopCounter )
            BEGIN
				SELECT @ClientId = ClientId
                FROM #Notes
                WHERE NoteId = @PKCounter
				
                UPDATE nc
                SET 
					nc.ClientId = n.ClientId,
                    nc.BitmapNo = ISNULL(nc.BitmapNo, 0) + 1,
                    -- 1					
					nc.ClientNoteId1 = CASE WHEN n.NoteOrder = 1 THEN n.ClientNoteId
											ELSE nc.ClientNoteId1
									   END ,
                    nc.NoteType1 = CASE WHEN n.NoteOrder = 1 THEN n.NoteType
                                        ELSE nc.NoteType1
                                   END ,
                    nc.Bitmap1 = CASE WHEN n.NoteOrder = 1 THEN n.Bitmap
                                      ELSE nc.Bitmap1
                                 END ,
                    nc.Note1 = CASE WHEN n.NoteOrder = 1 THEN n.Note
                                    ELSE nc.Note1
                               END ,
                    nc.CodeName1 = CASE WHEN n.NoteOrder = 1 THEN n.CodeName
                                        ELSE nc.CodeName1
                                   END,
					--2
					nc.ClientNoteId2 = CASE WHEN n.NoteOrder = 2 THEN n.ClientNoteId
                                                    ELSE nc.ClientNoteId2
                                               END ,
                    nc.NoteType2 = CASE WHEN n.NoteOrder = 2 THEN n.NoteType
                                        ELSE nc.NoteType2
                                   END ,
                    nc.Bitmap2 = CASE WHEN n.NoteOrder = 2 THEN n.Bitmap
                                      ELSE nc.Bitmap2
                                 END ,
                    nc.Note2 = CASE WHEN n.NoteOrder = 2 THEN n.Note
                                    ELSE nc.Note2
                               END ,
                    nc.CodeName2 = CASE WHEN n.NoteOrder = 2 THEN n.CodeName
                                        ELSE nc.CodeName2
                                   END,
					--3
					
                    nc.ClientNoteId3 = CASE WHEN n.NoteOrder = 3 THEN n.ClientNoteId
                                            ELSE nc.ClientNoteId3
                                       END ,
                    nc.NoteType3 = CASE WHEN n.NoteOrder = 3 THEN n.NoteType
                                        ELSE nc.NoteType3
                                   END ,
                    nc.Bitmap3 = CASE WHEN n.NoteOrder = 3 THEN n.Bitmap
                                      ELSE nc.Bitmap3
                                 END ,
                    nc.Note3 = CASE WHEN n.NoteOrder = 3 THEN n.Note
                                    ELSE nc.Note3
                               END ,
                    nc.CodeName3 = CASE WHEN n.NoteOrder = 3 THEN n.CodeName
                                        ELSE nc.CodeName3
                                   END,
					--4
					nc.ClientNoteId4 = CASE WHEN n.NoteOrder = 4 THEN n.ClientNoteId
                                                    ELSE nc.ClientNoteId4
                                               END ,
                    nc.NoteType4 = CASE WHEN n.NoteOrder = 4 THEN n.NoteType
                                        ELSE nc.NoteType4
                                   END ,
                    nc.Bitmap4 = CASE WHEN n.NoteOrder = 4 THEN n.Bitmap
                                      ELSE nc.Bitmap4
                                 END ,
                    nc.Note4 = CASE WHEN n.NoteOrder = 4 THEN n.Note
                                    ELSE nc.Note4
                               END ,
                    nc.CodeName4 = CASE WHEN n.NoteOrder = 4 THEN n.CodeName
                                        ELSE nc.CodeName4
                                   END,
					--5
					nc.ClientNoteId5 = CASE WHEN n.NoteOrder = 5 THEN n.ClientNoteId
                                                    ELSE nc.ClientNoteId5
                                               END ,
                    nc.NoteType5 = CASE WHEN n.NoteOrder = 5 THEN n.NoteType
                                        ELSE nc.NoteType5
                                   END ,
                    nc.Bitmap5 = CASE WHEN n.NoteOrder = 5 THEN n.Bitmap
                                      ELSE nc.Bitmap5
                                 END ,
                    nc.Note5 = CASE WHEN n.NoteOrder = 5 THEN n.Note
                                    ELSE nc.Note5
                               END ,
                    nc.CodeName5 = CASE WHEN n.NoteOrder = 5 THEN n.CodeName
                                        ELSE nc.CodeName5
                                   END,
					--6
					nc.ClientNoteId6 = CASE WHEN n.NoteOrder = 6 THEN n.ClientNoteId
                                                    ELSE nc.ClientNoteId6
                                               END ,
                    nc.NoteType6 = CASE WHEN n.NoteOrder = 6 THEN n.NoteType
                                        ELSE nc.NoteType6
                                   END ,
                    nc.Bitmap6 = CASE WHEN n.NoteOrder = 6 THEN n.Bitmap
                                      ELSE nc.Bitmap6
                                 END ,
                    nc.Note6 = CASE WHEN n.NoteOrder = 6 THEN n.Note
                                    ELSE nc.Note6
                               END ,
                    nc.CodeName6 = CASE WHEN n.NoteOrder = 6 THEN n.CodeName
                                        ELSE nc.CodeName6
                                   END
                FROM #Notes n
                JOIN #NoteColumns nc ON nc.ClientId = n.ClientId
                WHERE   n.NoteId = @PKCounter
					
					
				--For Notes greater than 6
				IF @EllipsisGlobalCodeId IS NOT NULL
				BEGIN 
					UPDATE  nc
					SET     nc.NoteType6 = @EllipsisGlobalCodeId ,
					--nc.Bitmap6 = @EllipsisBitmap ,
							nc.Bitmap6 = @EllipsisGlobalCodeId ,
							nc.Note6 = ISNULL(nc.Note6, '') + CHAR(10) + n.CodeName + ': ' + n.Note
					FROM    #Notes n
							JOIN #NoteColumns nc ON nc.ClientId = n.ClientId
					WHERE   n.NoteId = @PKCounter
							AND n.NoteOrder > 6
				END
				
             
                SET @PKCounter = @PKCounter + 1
            END
 

	              
			-- Reception dataset
	
			;
            WITH ListAllReceptionView AS 
            ( 
				SELECT
					NumberOfTimeRescheduled,
                    tR.DateOfService ,
                    tR.Time,
                    tR.Client ,
                    n.BitmapNo ,
                    n.ClientNoteId1 ,
                    n.NoteType1 ,
                    n.Bitmap1 ,
                    ISNULL(CodeName1 + ':' + n.Note1, '') AS Note1 ,
                    
                    CodeName1 , --n.Note1,n.CodeName1,       
                    n.ClientNoteId2 ,
                    n.NoteType2 ,
                    n.Bitmap2 ,
                    ISNULL(CodeName2 + ':' + n.Note2, '') AS Note2 ,
                    
                    CodeName2 , --n.Note2,n.CodeName2,   
                    n.ClientNoteId3 ,
                    n.NoteType3 ,
                    n.Bitmap3 ,
                    ISNULL(CodeName3 + ':' + n.Note3, '') AS Note3 ,
                                    
                    CodeName3 ,  --n.Note3,n.CodeName3,             
                    n.ClientNoteId4 ,
                    n.NoteType4 ,
                    n.Bitmap4 ,
                    ISNULL(CodeName4 + ':' + n.Note4, '') AS Note4 ,
                    
                    CodeName4 , --n.Note4,n.CodeName4,             
                    n.ClientNoteId5 ,
                    n.NoteType5 ,
                    n.Bitmap5 ,
                    ISNULL(CodeName5 + ':' + n.Note5, '') AS Note5 ,
                    
                    CodeName5 ,   -- n.Note5,n.CodeName5,          
                    n.ClientNoteId6 ,
                    n.NoteType6 ,
                    n.Bitmap6 ,
                    ISNULL(CodeName6 + ':' + n.Note6, '') AS Note6 ,
                    
                    CodeName6 ,  -- n.Note6,n.CodeName6,
                    tR.[ProcedureName] ,
                    tR.Status,
					tR.Staff ,
					ISNULL(tR.ClientBalance, 0.00) AS ClientBalance , 
					tR.Comment ,
					tR.ClientId ,
					tR.[StatusId], -- Changes made by Ponnin for task #580 of Care Management to SmartCare Env. Issues Tracking
					tR.ServiceId ,
					tR.ProgramId ,
					tR.LocationId ,
					tR.StaffId ,
					ISNULL(tR.ClientScanCount, 0) AS ClientScanCount ,
					ISNULL(tR.GroupId, 0) AS GroupId ,
					ISNULL(tR.GroupServiceId, 0) AS GroupServiceId ,
					tR.Flag,
					tR.IsCrossedYellowLimit,
					tR.IsCrossedRedLimit,
					--Added for task 747 by Venkatesh
					tR.ClientPhonenumber
                FROM #tempReception tR              
                LEFT JOIN #NoteColumns n ON n.ClientId = tR.ClientId
  
                ) 
                    ,
                    counts AS
					( 
						SELECT COUNT(*) AS totalrows
						FROM ListAllReceptionView
					) 
					,
                    RankResultSet AS 
                    ( 
						SELECT
							[NumberOfTimeRescheduled] ,
                            [DateOfService] ,
                            left(right(convert(varchar,[Time],0),7),5) + ' ' + right(convert(varchar,[Time],0),2) [Time],
                            [Client] ,
                            [BitmapNo] ,
                            [ClientNoteId1] ,
                            [NoteType1] ,
                            [Bitmap1] ,
                            [Note1] ,
                            [CodeName1] ,
                            [ClientNoteId2] ,
                            [NoteType2] ,
                            [Bitmap2] ,
                            [Note2] ,
                            [CodeName2] ,
                            [ClientNoteId3] ,
                            [NoteType3] ,
                            [Bitmap3] ,
                            [Note3] ,
                            [CodeName3] ,
                            [ClientNoteId4] ,
                            [NoteType4] ,
                            [Bitmap4] ,
                            [Note4] ,
                            [CodeName4] ,
                            [ClientNoteId5] ,
                            [NoteType5] ,
                            [Bitmap5] ,
                            [Note5] ,
                            [CodeName5] ,
                            [ClientNoteId6] ,
                            [NoteType6] ,
                            [Bitmap6] ,
                            [Note6] ,
                            [CodeName6] ,
                            [ProcedureName] ,
                            [Status] ,
                            [Staff] ,
                            [ClientBalance] ,
                            [Comment] ,
                            [ClientId] ,
                            [StatusId] ,
                            [ServiceId] ,
                            [ProgramId] ,
                            [LocationId] ,
                            [StaffId] ,
                            [ClientScanCount] ,
                            [GroupId] ,
                            [GroupServiceId] ,
                            [Flag] ,
                            [IsCrossedYellowLimit],
                            [IsCrossedRedLimit],
                            --Added for task 747 by Venkatesh
                            ClientPhonenumber,
                            COUNT(*) OVER ( ) AS TotalCount ,
                            RANK() OVER ( ORDER BY CASE WHEN @SortExpression = 'Time' THEN [Time]
                                                   END, CASE WHEN @SortExpression = 'Time desc' THEN [Time]
                                                        END DESC, CASE WHEN @SortExpression = 'Client' THEN Client
                                                                  END, CASE WHEN @SortExpression = 'Client desc' THEN Client
                                                                       END DESC, CASE WHEN @SortExpression = 'Flags' THEN ClientNoteId1
                                                                                 END, CASE WHEN @SortExpression = 'Flags' THEN ClientNoteId2
                                                                                      END, CASE WHEN @SortExpression = 'Flags' THEN ClientNoteId3
                                                                                           END, CASE WHEN @SortExpression = 'Flags' THEN ClientNoteId4
                                                                                                END, CASE WHEN @SortExpression = 'Flags' THEN ClientNoteId5
                                                                                                     END, CASE WHEN @SortExpression = 'Flags' THEN ClientNoteId6
                                                                                                          END, CASE WHEN @SortExpression = 'Flags desc' THEN ClientNoteId1
                                                                                                               END DESC, CASE WHEN @SortExpression = 'Flags desc' THEN ClientNoteId2
                                                                                                                         END DESC, CASE WHEN @SortExpression = 'Flags desc' THEN ClientNoteId3
                                                                                                                                   END DESC, CASE WHEN @SortExpression = 'Flags desc' THEN ClientNoteId4
                                                                                                                                             END DESC, CASE WHEN @SortExpression = 'Flags desc' THEN ClientNoteId5
                                                                                                                                                       END DESC, CASE WHEN @SortExpression = 'Flags desc' THEN ClientNoteId6
                                                                                                                                                                 END DESC, CASE WHEN @SortExpression = 'ProcedureName' THEN [ProcedureName]
                                                                                                                                                                           END, CASE WHEN @SortExpression = 'ProcedureName desc' THEN [ProcedureName]
                                                                                                                                                                                END DESC, CASE WHEN @SortExpression = 'Status' THEN [Status]
                                                                                                                                                                                          END, CASE WHEN @SortExpression = 'Status desc' THEN [Status]
                                                                                                                                                                                               END DESC, CASE WHEN @SortExpression = 'Staff' THEN [Staff]
                                                                                                                                                                                                         END, CASE WHEN @SortExpression = 'Staff desc' THEN [Staff]
                                                                                                                                                                                                              END DESC, CASE WHEN @SortExpression = 'ClientBalance' THEN Cast([ClientBalance] AS Money)
                                                                                                                                                                                                                        END, CASE WHEN @SortExpression = 'ClientBalance desc' THEN Cast([ClientBalance] AS Money)
                                                                                                                                                                                                                             END DESC,
							--Task#352 - Core bugs, Rohith Uppin - 04 March 2014, Starts here
							CASE WHEN @SortExpression = 'Time' THEN Client
							END, CASE WHEN @SortExpression = 'Time desc' THEN Client
							END, 
							--Task#352 - Ends Here
							ServiceId ) AS RowNumber
						FROM ListAllReceptionView
                    )
					SELECT TOP
						( CASE WHEN ( @PageNumber = -1 ) THEN ( SELECT  ISNULL(totalrows, 0)
                                                                        FROM    counts
                                                                      )
                                  ELSE ( @PageSize )
                             END ) [NumberOfTimeRescheduled] ,
                        [DateOfService] ,
                        [Time] ,
                        [Client] ,
                        [BitmapNo] ,
                        [ClientNoteId1] ,
                        [NoteType1] ,
                        [Bitmap1] ,
                        [Note1] ,
                        [CodeName1] ,
                        [ClientNoteId2] ,
                        [NoteType2] ,
                        [Bitmap2] ,
                        [Note2] ,
                        [CodeName2] ,
                        [ClientNoteId3] ,
                        [NoteType3] ,
                        [Bitmap3] ,
                        [Note3] ,
                        [CodeName3] ,
                        [ClientNoteId4] ,
                        [NoteType4] ,
                        [Bitmap4] ,
                        [Note4] ,
                        [CodeName4] ,
                        [ClientNoteId5] ,
                        [NoteType5] ,
                        [Bitmap5] ,
                        [Note5] ,
                        [CodeName5] ,
                        [ClientNoteId6] ,
                        [NoteType6] ,
                        [Bitmap6] ,
                        [Note6] ,
                        [CodeName6] ,
                        [ProcedureName] ,
                        [Status] ,
                        [Staff] ,
                        [ClientBalance] ,
                        [Comment] ,
                        [ClientId] ,
                        [StatusId] ,
                        [ServiceId] ,
                        [ProgramId] ,
                        [LocationId] ,
                        [StaffId] ,
                        [ClientScanCount] ,
                        [GroupId] ,
                        [GroupServiceId] ,
                        TotalCount ,
                        RowNumber ,
                        Flag,
                        IsCrossedYellowLimit,
                        IsCrossedRedLimit,
                        --Added for task 747 by Venkatesh
                        ClientPhonenumber
					INTO #FinalResultSet
                FROM  RankResultSet
                WHERE RowNumber > ( ( @PageNumber - 1 ) * @PageSize ) 
				

            IF (( SELECT ISNULL(COUNT(*), 0) FROM   #FinalResultSet ) < 1 )
            BEGIN
                SELECT  
					0 AS PageNumber ,
					0 AS NumberOfPages ,
					0 NumberOfRows
            END
            ELSE 
            BEGIN                                
                SELECT TOP 1
					@PageNumber AS PageNumber,
					CASE ( TotalCount % @PageSize )
					  WHEN 0 THEN ISNULL(( TotalCount / @PageSize ), 0)
					  ELSE ISNULL(( TotalCount / @PageSize ), 0) + 1
					END AS NumberOfPages ,
					ISNULL(TotalCount, 0) AS NumberOfRows
                FROM #FinalResultSet  
            END     
            
            ------------- Ponnin changes starts here.... 
        ----- Create temp table to store the final resultset-------------------------------------------------
        
          CREATE TABLE #ReceptionResult ( 
					Id INT IDENTITY,
					RowNumber INT ,
                     PageNumber INT ,
                    [NumberOfTimeRescheduled] varchar(30),
                    [DateOfService] DATETIME,
                    [Time] VARCHAR(20),
                    [Client] VARCHAR(100),
                    [BitmapNo] INT,
                    [ClientNoteId1] INT,
                    [NoteType1] INT ,
                    [Bitmap1] VARCHAR(200),
                    [Note1] VARCHAR(MAX),
                    [CodeName1] VARCHAR(250) ,
                    [ClientNoteId2] INT,
                    [NoteType2] INT,
                    [Bitmap2] VARCHAR(200) ,
                    [Note2] VARCHAR(MAX),
                    [CodeName2] VARCHAR(250) ,
                    [ClientNoteId3] INT,
                    [NoteType3] INT,
                    [Bitmap3] VARCHAR(200),
                    [Note3] VARCHAR(MAX),
                    [CodeName3] VARCHAR(250) ,
                    [ClientNoteId4] INT,
                    [NoteType4] INT,
                    [Bitmap4] VARCHAR(200),
                    [Note4] VARCHAR(MAX),
                    [CodeName4] VARCHAR(250) ,
                    [ClientNoteId5] INT,
                    [NoteType5] INT,
                    [Bitmap5] VARCHAR(200),
                    [Note5] VARCHAR(MAX),
                    [CodeName5] VARCHAR(250) ,
                    [ClientNoteId6] INT,
                    [NoteType6] INT,
                    [Bitmap6] VARCHAR(200),
                    [Note6] VARCHAR(MAX),
                    [CodeName6] VARCHAR(250) ,
                    ProcedureName VARCHAR(250) ,
                    [Status] VARCHAR(250),
                    [Staff] VARCHAR(350),
                    [ClientBalance] MONEY,
                    [Comment] VARCHAR(MAX),
                    [ClientId] INT,
                    [StatusId] INT,
                    [ServiceId] INT,
                    [ProgramId] INT,
                    [LocationId] INT,
                    [StaffId] INT,
                    [ClientScanCount] INT,
                    [GroupId] INT,
                    [GroupServiceId] INT,
                    Flag VARCHAR(1),
                    IsCrossedYellowLimit CHAR(1),
					IsCrossedRedLimit CHAR(1),
                    Copayamount VARCHAR(250),  --MONEY
                    --Added for task 747 by Venkatesh
                    ClientPhonenumber VARCHAR(500)
            )
                
                INSERT INTO  #ReceptionResult (
					RowNumber,
                    PageNumber ,
                    [NumberOfTimeRescheduled],
                    [DateOfService],
                    [Time],
                    [Client],
                    [BitmapNo],
                    [ClientNoteId1],
                    [NoteType1],
                    [Bitmap1],
                    [Note1],
                    [CodeName1] ,
                    [ClientNoteId2],
                    [NoteType2],
                    [Bitmap2] ,
                    [Note2],
                    [CodeName2],
                    [ClientNoteId3],
                    [NoteType3],
                    [Bitmap3],
                    [Note3],
                    [CodeName3],
                    [ClientNoteId4],
                    [NoteType4],
                    [Bitmap4],
                    [Note4],
                    [CodeName4],
                    [ClientNoteId5],
                    [NoteType5],
                    [Bitmap5],
                    [Note5],
                    [CodeName5],
                    [ClientNoteId6],
                    [NoteType6],
                    [Bitmap6],
                    [Note6],
                    [CodeName6] ,
                    ProcedureName,
                    [Status],
                    [Staff],
                    [ClientBalance],
                    [Comment],
                    [ClientId],
                    [StatusId],
                    [ServiceId],
                    [ProgramId],
                    [LocationId],
                    [StaffId],
                    [ClientScanCount],
                    [GroupId],
                    [GroupServiceId],
                    Flag,
                    IsCrossedYellowLimit,
                    IsCrossedRedLimit,
                    Copayamount,
                    --Added for task 747 by Venkatesh
                    ClientPhonenumber
            )                     

            SELECT
				RowNumber ,
                @PageNumber AS PageNumber ,
                [NumberOfTimeRescheduled] ,
                [DateOfService] ,
                [Time] ,
                [Client] ,
                [BitmapNo] ,
                [ClientNoteId1] ,
                [NoteType1] ,
                [Bitmap1] ,
                [Note1] ,
                [CodeName1] ,
                [ClientNoteId2] ,
                [NoteType2] ,
                [Bitmap2] ,
                [Note2] ,
                [CodeName2] ,
                [ClientNoteId3] ,
                [NoteType3] ,
                [Bitmap3] ,
                [Note3] ,
                [CodeName3] ,
                [ClientNoteId4] ,
                [NoteType4] ,
                [Bitmap4] ,
                [Note4] ,
                [CodeName4] ,
                [ClientNoteId5] ,
                [NoteType5] ,
                [Bitmap5] ,
                [Note5] ,
                [CodeName5] ,
                [ClientNoteId6] ,
                [NoteType6] ,
                [Bitmap6] ,
                [Note6] ,
                [CodeName6] ,
                [ProcedureName] AS ProcedureName ,
                [Status] ,
                [Staff] ,
                [ClientBalance] ,
                [Comment] ,
                [ClientId] ,
                [StatusId] ,
                [ServiceId] ,
                [ProgramId] ,
                [LocationId] ,
                [StaffId] ,
                [ClientScanCount] ,
                [GroupId] ,
                [GroupServiceId] ,
                Flag,
                IsCrossedYellowLimit,
                IsCrossedRedLimit,
                '0.00' as Copayamount,
                --Added for task 747 by Venkatesh
                ClientPhonenumber
            FROM #FinalResultSet
            ORDER BY RowNumber
DECLARE	@RowCount INT  
DECLARE	@Counter INT
DECLARE @CopayServiceId INT
DECLARE @ClientCopay DECIMAL(18, 2)
DECLARE @CopayReceived DECIMAL(18, 2)
            
SET @RowCount = @@RowCount
SET @Counter = 1        
 WHILE @Counter <= @RowCount 
  BEGIN
  
  SET @CopayServiceId = 0
  SELECT	@CopayServiceId =  ServiceId
					FROM	#ReceptionResult
					WHERE	Id = @Counter 
					
	CREATE TABLE #ClientCopay ( Copay DECIMAL(18, 2) )
	
	INSERT  INTO #ClientCopay
	EXEC ssp_GetCopayAmountForServices @CopayServiceId
	SELECT  @ClientCopay = NULLIF(Copay, 0)
    FROM    #ClientCopay  
    
    Select @CopayReceived=sum(Copayment) From PaymentCopayments where serviceId=@CopayServiceId and  ISNULL(RecordDeleted,'N')='N' 
  
  IF(@ClientCopay is not null)
  BEGIN
		--15 Jan 2018       Gautam
		CREATE TABLE #ClientCopayUpfront ( CollectUpFront char(1) )
		
		INSERT  INTO #ClientCopayUpfront
		EXEC ssp_SCGetCopayCollectUpFront @CopayServiceId
		
		If exists(Select 1 From #ClientCopayUpfront where isnull(CollectUpFront,'N')='Y')
			begin
				UPDATE #ReceptionResult SET Copayamount = '$' + cast(@ClientCopay as varchar) + ' ' + '– Up Front' WHERE Id = @Counter
			end
		else
			begin
				UPDATE #ReceptionResult SET Copayamount = '$' + cast(@ClientCopay as varchar) + ' ' + '– Not Up Front' WHERE Id = @Counter
			end
				
		drop table #ClientCopayUpfront
  END	
  
  DROP TABLE #ClientCopay
  
  SET @Counter = @Counter + 1 
  END 
            
            
SELECT  RowNumber ,
                    @PageNumber AS PageNumber ,
                    [NumberOfTimeRescheduled] ,
                    [DateOfService] ,
                    [Time] ,
                    [Client] ,
                    [BitmapNo] ,
                    [ClientNoteId1] ,
                    [NoteType1] ,
                    [Bitmap1] ,
                    [Note1] ,
                    [CodeName1] ,
                    [ClientNoteId2] ,
                    [NoteType2] ,
                    [Bitmap2] ,
                    [Note2] ,
                    [CodeName2] ,
                    [ClientNoteId3] ,
                    [NoteType3] ,
                    [Bitmap3] ,
                    [Note3] ,
                    [CodeName3] ,
                    [ClientNoteId4] ,
                    [NoteType4] ,
                    [Bitmap4] ,
                    [Note4] ,
                    [CodeName4] ,
                    [ClientNoteId5] ,
                    [NoteType5] ,
                    [Bitmap5] ,
                    [Note5] ,
                    [CodeName5] ,
                    [ClientNoteId6] ,
                    [NoteType6] ,
                    [Bitmap6] ,
                    [Note6] ,
                    [CodeName6] ,
                    ProcedureName ,
                    [Status] ,
                    [Staff] ,
                    [ClientBalance] ,
                    [Comment] ,
                    [ClientId] ,
                    [StatusId] ,
                    [ServiceId] ,
                    [ProgramId] ,
                    [LocationId] ,
                    [StaffId] ,
                    [ClientScanCount] ,
                    [GroupId] ,
                    [GroupServiceId] ,
                    Flag,
                    IsCrossedYellowLimit,
                    IsCrossedRedLimit,
                    Copayamount,
                    ClientPhonenumber
            FROM    #ReceptionResult
            ORDER BY RowNumber
            
              ------------- Ponnin changes Ends here.... 
            
		END TRY
		BEGIN CATCH
            DECLARE @Error VARCHAR(8000)       
            SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_PMReception') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())
			RAISERROR
			(
				@Error, -- Message text.
				16,		-- Severity.
				1		-- State.
			);
        END CATCH
    END

    SET TRANSACTION ISOLATION LEVEL READ COMMITTED
	
	------------------------------------------------------------------------------------------------------------------------
        -- Modified by Avi Goyal, on 15 Dec 2014
    ------------------------------------------------------------------------------------------------------------------------
    ----DROP TABLE #ServiceFilters,#AppointmentFilters,#TriageFilters, #Notes, #NoteColumns, #FinalResultSet,#tempReception,#tempReceptionService,#tempReceptionAppointment,#tempReceptionTriage
    --DROP TABLE #Notes, #NoteColumns, #FinalResultSet,#tempReception,#tempReceptionService,#tempReceptionAppointment,#tempReceptionTriage,#tempStatus,#CustomFilters
	------------------------------------------------------------------------------------------------------------------------

GO


