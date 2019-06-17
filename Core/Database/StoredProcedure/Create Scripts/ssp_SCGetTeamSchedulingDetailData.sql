/****** Object:  StoredProcedure [dbo].[ssp_SCGetTeamSchedulingDetailData]    Script Date: 09/26/2016 13:44:11 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetTeamSchedulingDetailData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetTeamSchedulingDetailData]
GO


/****** Object:  StoredProcedure [dbo].[ssp_SCGetTeamSchedulingDetailData]    Script Date: 09/26/2016 13:44:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[ssp_SCGetTeamSchedulingDetailData]     
 @ProgramId INT
,@DateFilter Datetime
,@StaffId INT
,@SchedulingPreferenceMonday CHAR(1)
,@SchedulingPreferenceTuesday CHAR(1)
,@SchedulingPreferenceWednesday CHAR(1)
,@SchedulingPreferenceThursday CHAR(1)
,@SchedulingPreferenceFriday CHAR(1) 
,@SchedulingPreferenceSaturday CHAR(1)
,@SchedulingPreferenceSunday CHAR(1)
,@IncludeAllScheduledServices CHAR(1) 
,@CopyDateFilter DATETIME
,@ScreenAction CHAR (1)   
AS    
/**************************************************************/                                                                                            
/* Stored Procedure: [ssp_SCGetTeamSchedulingDetailData]   */                                                                                   
/* Creation Date:  27March2012                                */                                                                                            
/* Purpose: To Get Team Scheduling Detail Data      */                                                                                           
/* Input Parameters:   None           */                                                                                          
/* Output Parameters:            */                                                                                            
/* Return:               */                                                                                            
/* Called By: Core Team Scheduling Detail screen     */                                                                                  
/* Calls:                                                     */                                                                                            
/*                                                            */                                                                                            
/* Data Modifications:                                        */                                                                                            
/* Updates:                                                   */                                                                                            
/* Date   Author   Purpose         */        
/* 27March2012 Shifali	Created		To get Team Scheduling Detail Data   */ 
/* 12Apr2012	Shifali	Modified	Added Discharge Status check and date filter with DischargeDate*/   
/* 12Apr2012	Shifali	Modified	Added StaffPrograms exists check to get those services where clinician is also there for the program*/
/* 12Apr2012	Shifali	Modified	Added GroupServiceId IS NULL filter when picking up Services*/
/* 12Apr2012	Shifali	Modified	Added DateFilter with Req/Enrolled/Discharge Date along with ProgramStatus filter*/
/* 16Apr2012	Davinderk			Task#-2(Team Scheduling-Threshold Phase III) Add new columns into table #TempClientServices [SchedulingPreferenceMonday],[SchedulingPreferenceTuesday],[SchedulingPreferenceWednesday],
									[SchedulingPreferenceThursday],[SchedulingPreferenceFriday],[GeographicLocation],[SchedulingComment],[SpecificLocation],[Preference]*/
/* 17Apr2012	Shifali				Added SchedulingPreference Columns, GeoLoc COlumn, Preference for Clients who all have no services but enrolled for 
									Program*/									
/*20Apr2012		Shifali				Added Params @SchedulingPreferenceMonday etc & @IncludeAllScheduledServices*/
/*24Apr2012		Shifali				Added Columns UnitType,CancelReason,DiagnosisCode1 etc,Other Services table fields */
/*27Apr2012		Davinderk			Added Columns ServiceDetailTitle for display the service detail*/
/*03May2012		Shifali				Changed Column CancelReason Datatype in temp table from varchar(100) to int*/
/*08May2012		Shifali				Added Condition for Program Status - 5(added as (CP.RequestedDate <= @DateFilter OR CP.EnrolledDate <= @DateFilter) AND */
/*09May2012		Davinderk			Added new column ProcedureCodeName,StatusName in to table #TempClientServices*/
/*10May2012		Davinderk			Added new column UnitTypeName in to table #TempClientServices*/
/*10May2012		Shifali				Added Tables Appointments/Documents/DocumentVersions/DocumentSignatures */
/*11May2012		Shifali				Added services.Charge,ProcedureRateId*/
/*14May2012		Davinderk			Removed the client name from ServiceDetailTitle tool tip*/
/*14May2012		Shifali				Added Copy Date filter*/
/*14May2012		Shifali				Added Filter @ScreenAction - C(Copy) , S(Schedule)*/
/*17May2012		Shifali				Added condition WHERE TCS.ServiceId > 0 with Tables Documents/Versions/Signatures*/
/*22May2012		Shifali				Changed ServiceDetailTitlefield length of temp table to 1000 as per issue from shs team*/
/*22May2012		Shifali				Get Clients as well along with services in case of screenAction='C'(Copy) who all are carrying preference of schedule date*/
/*22May2012		Davinderk			In screenAction='C'(Copy) Removed the Case when statement on S.Unit to simply written S.Unit*/
/*25May2012		Davinderk			Added new column SavedServiceStatus*/
/*29May2012		Shifali				Picked only Active Client's Services*/
/*30May2012		Shifali				Removed Preference Day Logic from Copy Action and Rounded off unit to nearest next 5's multiple minutes*/
/*12June2012	Shifali				Replaced Field PC.ProcedureCodeName with PC.DisplayAs*/
/*15June2012	Shifali				Unit DataType  recitified from Decimal(5,2) to Decimal(18,2)*/
/*19June2012	Davinderk			Updated the requestdate and enrolleddate and DischargedDate check validation*/
/*21June2012	Davinder kumar		Convert S.Unit to CAST(CAST(S.Unit as int) as varchar)*/
/*08Aug2012	    Davinder kumar		Added new column into table Appointments - RecurringOccurrenceIndex,Status,CancelReason,ExamRoom,ClientWasPresent,OtherPersonsPresent*/
/*21Aug2012	    Davinder kumar		Added new column into table Appointments - ClientId*/
/*28Sep2012	    Rahul Aneja		    Added new column into table Appointments.SpecificLocation 
26/Oct/2012		Mamta Gupta			Added new column into table Appointments.NumberofTimeRescheduled
									To Count no of appointment rescheduling. Task No. 35 Primary Care - Summit Pointe 
10/Dec/2012		Maninder			Added column RecurringSerice to #TempClientServices 
14/Dec/2012		Manjit Singh		Write the query using Exists for optimization
17.12.2012      Rakesh Garg			W.rf to change in core datamode 12.29 in documents table by Adding new field AppointmentId for avoiding concurrency issues
5th feb 2013    Sunil               W.rf to task 220 in primarycare bugs/features increase the size of clientname to 110 instead of 50 for temp Table
18/02/2013      Maninder            w.r.f to Task#2763 in Thresholds Bugs/Feature - Passed the value of @SchedulingPreferenceMonday,@SchedulingPreferenceTuesday,@SchedulingPreferenceWednesday,@SchedulingPreferenceThursday,@SchedulingPreferenceFriday 
									from coded and modified the logic to initialize client services in case of Copy Services	
10-Dec-2013		Rohith				Included one more condition to consider latest documentVersionId for corresponding DocumnetId  - Task#405, Thresholds - Support
25/July/2014    Bernardin           Modified varchar(1000) to varchar(max). Core bugs # 95
-- OCT-07-2014  Akwinass            Removed Columns 'DiagnosisCode1,DiagnosisNumber1,DiagnosisVersion1,DiagnosisCode2,DiagnosisNumber2,DiagnosisVersion2,DiagnosisCode3,DiagnosisNumber3,DiagnosisVersion3' from Services table (Task #134 in Engineering Improvement Initiatives- NBL(I))
-- APRIL-30-2015  Akwinass     Included New Column 'ReasonForNewVersion' (Task #233 in Philhaven Development)
15/10/2015  Anto     Included New Column 'ReasonForDecline' (Task #81 in New Directions - Support Go Live )
9/25/2016       Hemant              What:- Included Order by clause for the Documents and Documentversions tables
                                    to fix the error on save.
                                    Why:- On save application fetching the wrong Documentversionid for the respective Documentid.Task#722, Thresholds - Support
-- Oct 01,2017	Anto        	    Modified code to add saturday and sunday in Team scheduling detail page - Texas Customizations - #124                                  
*************************************************************/      


BEGIN    
BEGIN TRY    
     
--CustomDetailScreenConfiguration Table
	Select 'Y' AS ValidateAppointments,'Y' AS CalculateServiceCharge,'Y' AS ValidateServices,'Y' AS DeleteAppointments,
	'Y' AS CheckForWarnings,'Y' AS UseNewTransEachRow  
  
 --Clients Temp Table who all are enrolled/requested/discharged after specified date for Program

IF OBJECT_ID('tempdb..#TempClientPrograms') IS NOT NULL    
DROP TABLE #TempClientPrograms  
  
IF OBJECT_ID('tempdb..#TempClientPrograms') IS NULL    
BEGIN    
	CREATE Table #TempClientPrograms (       
		ClientId INT    
	)    
END    
--Ends Here
    

 IF OBJECT_ID('tempdb..#TempClientServices') IS NOT NULL    
 DROP TABLE #TempClientServices 
   
 CREATE Table #TempClientServices (   
 ServiceId [int] Identity(-1,-1)
 ,ClientId INT  
 ,ClientName VARCHAR(110) 
 ,ClinicianId INT
 ,ProcedureCodeId INT 
 ,LocationId    INT
 ,ProgramId INT
 ,DateOfService DATETIME
 ,EndDateOfService DATETIME
 ,[Time] DATETIME   
 ,Unit    DECIMAL(18,2)
 ,Status INT
 ,GroupServiceId INT
 ,CreatedBy    VARCHAR(30)
 ,CreatedDate    DATETIME
 ,ModifiedBy    VARCHAR(30)
 ,ModifiedDate    DATETIME
 ,RecordDeleted   CHAR(1) 
 ,DeletedBy     VARCHAR(30)
 ,DeletedDate  DATETIME
 ,IsChecked CHAR(1)
 ,SchedulingPreferenceMonday CHAR(1)
 ,SchedulingPreferenceTuesday CHAR(1)
 ,SchedulingPreferenceWednesday CHAR(1)
 ,SchedulingPreferenceThursday CHAR(1)
 ,SchedulingPreferenceFriday CHAR(1)
 ,SchedulingPreferenceSaturday CHAR(1)  
 ,SchedulingPreferenceSunday CHAR(1) 
 ,GeographicLocation VARCHAR(50)
 ,SchedulingComment VARCHAR(MAX)
 ,SpecificLocation VARCHAR(MAX)
 ,Preference VARCHAR(100)
 ,UnitType INT
 ,CancelReason INT
 ,ProviderId INT
 ,AttendingId INT
 ,Billable CHAR(1) 
 ,ClientWasPresent CHAR(1)
 ,OtherPersonsPresent VARCHAR(250) 
 ,AuthorizationsApproved INT
 ,AuthorizationsNeeded INT
 ,AuthorizationsRequested INT
 ,NumberOfTimeRescheduled INT
 ,NumberOfTimesCancelled INT
 ,DoNotComplete  CHAR(1)
 ,Comment VARCHAR(MAX)
 ,Flag1 CHAR(1)
 ,OverrideError CHAR(1)
 ,OverrideBy VARCHAR(30) 
 ,ReferringId INT
 ,DateTimeIn DATETIME
 ,DateTimeOut DATETIME
 ,NoteAuthorId INT
 ,ModifierId1 INT
 ,ModifierId2 INT
 ,ModifierId3 INT
 ,ModifierId4 INT
 ,PlaceOfServiceId INT
 ,ServiceDetailTitle varchar(MAX)
 ,ProcedureCodeName varchar(250) 
 ,StatusName varchar(250)
 ,UnitTypeName varchar(250)
 ,DocumentId INT
 ,Charge MONEY
 ,ProcedureRateId INT
 ,SavedServiceStatus INT
 ,RecurringService CHAR(1) 
 )     


--Fill Table #TempClientPrograms From Client Programs

INSERT INTO #TempClientPrograms
(ClientId)
SELECT C.ClientId
FROM Clients C
WHERE ISNULL(C.RecordDeleted,'N')='N' AND C.Active = 'Y' 
AND EXISTS(SELECT 1 FROM ClientPrograms CP WHERE CP.ClientId = C.ClientId
			AND ISNULL(CP.RecordDeleted,'N') <> 'Y' 
			AND CP.ProgramId = @ProgramId  
			AND ((CP.Status = 1 AND (Cp.RequestedDate <= @DateFilter)) 
				  OR(Cp.Status = 4 AND Cp.EnrolledDate <= @DateFilter)
				  OR (CP.Status = 5 AND (CP.RequestedDate <= @DateFilter OR CP.EnrolledDate <= @DateFilter) 
				  AND (CP.DischargedDate >= @DateFilter OR CP.DischargedDate IS NULL))
				) 
			)
-- Commented by Manjit Singh and written above with exists while optimization
--SELECT DISTINCT C.ClientId
--FROM ClientPrograms CP
--INNER JOIN Clients C ON CP.ClientId = C.ClientId
--WHERE ISNULL(C.RecordDeleted,'N')='N' AND C.Active = 'Y' 
--	AND ISNULL(CP.RecordDeleted,'N') <> 'Y'    
--	AND CP.ProgramId = @ProgramId  AND
--	((CP.Status = 1 AND (Cp.RequestedDate <= @DateFilter)) 
--	  OR(Cp.Status = 4 AND Cp.EnrolledDate <= @DateFilter)
--	  OR (CP.Status = 5 AND (CP.RequestedDate <= @DateFilter OR CP.EnrolledDate <= @DateFilter) 
--	  AND (CP.DischargedDate >= @DateFilter OR CP.DischargedDate IS NULL))) 

IF @ScreenAction = 'C'
BEGIN 						  
	INSERT INTO #TempClientPrograms
	(ClientId)
	SELECT C.ClientId
	FROM Clients C 
	WHERE ISNULL(C.RecordDeleted,'N')='N' AND C.Active = 'Y' 
	AND EXISTS(SELECT 1 FROM ClientPrograms CP WHERE  CP.ClientId = C.ClientId	
				AND ISNULL(CP.RecordDeleted,'N') <> 'Y'    
				AND CP.ProgramId = @ProgramId  
				AND ((CP.Status = 1 AND (Cp.RequestedDate <= @DateFilter)) 
				OR(Cp.Status = 4 AND Cp.EnrolledDate <= @DateFilter)
				OR (CP.Status = 5 AND (CP.RequestedDate <= @DateFilter OR CP.EnrolledDate <= @DateFilter) 
				AND (CP.DischargedDate >= @DateFilter OR CP.DischargedDate IS NULL)))		
				AND NOT EXISTS(SELECT ClientId from #TempClientPrograms WHERE ClientId = CP.ClientId)
			)
	-- Commented by Manjit Singh and written above with exists while optimization
	--SELECT DISTINCT C.ClientId
	--FROM ClientPrograms CP
	--INNER JOIN Clients C ON CP.ClientId = C.ClientId
	--WHERE ISNULL(C.RecordDeleted,'N')='N' AND C.Active = 'Y' 
	--	AND ISNULL(CP.RecordDeleted,'N') <> 'Y'    
	--	AND CP.ProgramId = @ProgramId  
	--	AND ((CP.Status = 1 AND (Cp.RequestedDate <= @DateFilter)) 
	--	OR(Cp.Status = 4 AND Cp.EnrolledDate <= @DateFilter)
	--	OR (CP.Status = 5 AND (CP.RequestedDate <= @DateFilter OR CP.EnrolledDate <= @DateFilter) 
	--	AND (CP.DischargedDate >= @DateFilter OR CP.DischargedDate IS NULL)))
	--	AND NOT EXISTS(SELECT ClientId from #TempClientPrograms WHERE ClientId = CP.ClientId)  
END

--Client Programs Fill Ends Here      
 
  
SET IDENTITY_INSERT #TempClientServices ON 
	
INSERT INTO #TempClientServices (
	ServiceId    
	,ClientId    
	,ClientName    
	,ClinicianId    
	,ProcedureCodeId    
	,LocationId    
	,ProgramId
	,DateOfService
	,EndDateOfService
	,Time    
	,Unit 
	,Status   
	,S.CreatedBy    
	,S.CreatedDate    
	,S.ModifiedBy    
	,S.ModifiedDate    
	,S.RecordDeleted    
	,S.DeletedBy    
	,S.DeletedDate
	,IsChecked
	,SchedulingPreferenceMonday
	,SchedulingPreferenceTuesday
	,SchedulingPreferenceWednesday
	,SchedulingPreferenceThursday
	,SchedulingPreferenceFriday
	,SchedulingPreferenceSaturday
    ,SchedulingPreferenceSunday
	,GeographicLocation
	,SchedulingComment
	,SpecificLocation  
	,Preference 
	,UnitType
	,CancelReason
	,ProviderId
	,AttendingId
	,Billable
	,ClientWasPresent
	,OtherPersonsPresent
	,AuthorizationsApproved
	,AuthorizationsNeeded
	,AuthorizationsRequested
	,NumberOfTimeRescheduled
	,NumberOfTimesCancelled
	,DoNotComplete
	,Comment
	,Flag1
	,OverrideError
	,OverrideBy
	,ReferringId
	,DateTimeIn
	,DateTimeOut
	,NoteAuthorId
	,ModifierId1
	,ModifierId2
	,ModifierId3
	,ModifierId4
	,PlaceOfServiceId
	,ServiceDetailTitle
	,ProcedureCodeName 
	,StatusName 
	,UnitTypeName
	,DocumentId
	,Charge
	,ProcedureRateId
	,SavedServiceStatus
	,RecurringService
	)

	SELECT     
	S.ServiceId    
	,C.ClientId    
	,C.LastName + ', ' + C.FirstName AS ClientName    
	,S.ClinicianId    
	,S.ProcedureCodeId    
	,S.LocationId  
	,S.ProgramId  
	,S.DateOfService
	,S.EndDateOfService
	,RIGHT(CONVERT(DATETIME, S.DateOfService, 100),7) AS [Time]
	,Unit
	,S.Status    
	,S.CreatedBy    
	,S.CreatedDate    
	,S.ModifiedBy    
	,S.ModifiedDate    
	,S.RecordDeleted    
	,S.DeletedBy    
	,S.DeletedDate
	,'N'
	,C.SchedulingPreferenceMonday
	,C.SchedulingPreferenceTuesday
	,C.SchedulingPreferenceWednesday
	,C.SchedulingPreferenceThursday
	,C.SchedulingPreferenceFriday
	,C.SchedulingPreferenceSaturday 
    ,C.SchedulingPreferenceSunday 
	,C.GeographicLocation
	,C.SchedulingComment
	,S.SpecificLocation 
	,SUBSTRING(CASE WHEN C.SchedulingPreferenceMonday = 'Y' THEN ',M ' ELSE '' END +
	CASE WHEN C.SchedulingPreferenceTuesday = 'Y' THEN ',TU ' ELSE '' END +
	CASE WHEN C.SchedulingPreferenceWednesday = 'Y' THEN ',W ' ELSE '' END +
	CASE WHEN C.SchedulingPreferenceThursday = 'Y' THEN ',TH ' ELSE '' END +
	CASE WHEN C.SchedulingPreferenceFriday = 'Y' THEN ',F' ELSE '' END +
    CASE WHEN C.SchedulingPreferenceSaturday = 'Y' THEN ',S' ELSE '' END +
    CASE WHEN C.SchedulingPreferenceSunday = 'Y' THEN ',Su' ELSE '' END,2,20)  
	,S.UnitType
	,S.CancelReason
	,S.ProviderId
	,S.AttendingId
	,S.Billable
	,S.ClientWasPresent
	,S.OtherPersonsPresent
	,S.AuthorizationsApproved
	,S.AuthorizationsNeeded
	,S.AuthorizationsRequested
	,S.NumberOfTimeRescheduled
	,S.NumberOfTimesCancelled
	,S.DoNotComplete
	,S.Comment
	,S.Flag1
	,S.OverrideError
	,S.OverrideBy
	,S.ReferringId
	,S.DateTimeIn
	,S.DateTimeOut
	,S.NoteAuthorId
	,S.ModifierId1
	,S.ModifierId2
	,S.ModifierId3
	,S.ModifierId4
	,S.PlaceOfServiceId
	,(SELECT '' + PC.DisplayAs +', '+ CONVERT(VARCHAR,CAST(S.DateOfService AS TIME),100)+', '+ (CAST(CAST(S.Unit as int) as varchar) 
		-- + ' '+ ISNULL((SELECT CodeName FROM GlobalCodes WHERE GlobalCodeId=S.UnitType),'')) +', '+ Commented by Manjit Singh and written below
		+ ' '+ ISNULL(GCUT.CodeName,'')) +', '+        
		GC.CodeName + 
		CASE WHEN S.Comment IS NULL THEN ''
			ELSE ' (' + CAST (S.Comment AS VARCHAR(MAX))+ ')' 
	END) 
	AS Title 
	,PC.DisplayAs   
	,GC.CodeName 
	,GCUT.CodeName 
	,D.DocumentId
	,S.Charge
	,S.ProcedureRateId
	,S.Status as SavedServiceStatus
	,S.RecurringService  
	FROM Services S     	
	JOIN #TempClientPrograms AS [TCP] ON [TCP].ClientId = S.ClientId
	JOIN Clients C ON [TCP].ClientId = C.ClientId    
	LEFT JOIN ProcedureCodes PC ON PC.ProcedureCodeId = S.ProcedureCodeId
	LEFT JOIN GlobalCodes GC ON GC.GlobalCodeId =S.Status
	LEFT JOIN  GlobalCodes GCUT ON GCUT.GlobalCodeId =S.UnitType
	LEFT JOIN Documents D ON D.ServiceId = S.ServiceId	    
	WHERE ISNULL(S.RecordDeleted,'N') <> 'Y'	
	AND S.ProgramId = @ProgramId AND S.Status IN(70,71,75) AND S.GroupServiceId IS NULL	
	AND (@StaffId = -1 OR S.ClinicianId = @StaffId)
	AND (@IncludeAllScheduledServices = 'Y' OR  (C.SchedulingPreferenceMonday = @SchedulingPreferenceMonday OR @SchedulingPreferenceMonday = 'N'))
	AND (@IncludeAllScheduledServices = 'Y' OR (C.SchedulingPreferenceTuesday = @SchedulingPreferenceTuesday OR @SchedulingPreferenceTuesday = 'N'))
	AND (@IncludeAllScheduledServices = 'Y' OR (C.SchedulingPreferenceWednesday = @SchedulingPreferenceWednesday OR @SchedulingPreferenceWednesday = 'N'))
	AND (@IncludeAllScheduledServices = 'Y' OR (C.SchedulingPreferenceThursday = @SchedulingPreferenceThursday OR @SchedulingPreferenceThursday = 'N'))
	AND (@IncludeAllScheduledServices = 'Y' OR (C.SchedulingPreferenceFriday = @SchedulingPreferenceFriday OR @SchedulingPreferenceFriday = 'N'))	
	AND (@IncludeAllScheduledServices = 'Y' OR (C.SchedulingPreferenceSaturday = @SchedulingPreferenceSaturday OR @SchedulingPreferenceSaturday = 'N'))  
    AND (@IncludeAllScheduledServices = 'Y' OR (C.SchedulingPreferenceSunday = @SchedulingPreferenceSunday OR @SchedulingPreferenceSunday = 'N')) 
	AND CAST(CONVERT(VARCHAR(10),S.DateOfService,101) AS DATETIME) = @DateFilter    
	AND EXISTS(
		SELECT 1 FROM StaffPrograms SP LEFT JOIN  Staff ON Staff.StaffId = SP.StaffId  
		WHERE Staff.Active = 'Y' AND ISNULL(SP.RecordDeleted,'N') <> 'Y' AND SP.StaffId = S.ClinicianId AND SP.ProgramId = @ProgramId 
	)	

SET IDENTITY_INSERT #TempClientServices OFF	
	
IF @ScreenAction = 'C'
BEGIN

	INSERT INTO #TempClientServices (
	ClientId    
	,ClientName    
	,ClinicianId    
	,ProcedureCodeId    
	,LocationId    
	,ProgramId
	,DateOfService
	,EndDateOfService
	,Time    
	,UNIT 
	,[Status]
	,S.CreatedBy    
	,S.CreatedDate    
	,S.ModifiedBy    
	,S.ModifiedDate    
	,S.RecordDeleted    
	,S.DeletedBy    
	,S.DeletedDate
	,IsChecked
	,SchedulingPreferenceMonday
	,SchedulingPreferenceTuesday
	,SchedulingPreferenceWednesday
	,SchedulingPreferenceThursday
	,SchedulingPreferenceFriday
	,SchedulingPreferenceSaturday 
    ,SchedulingPreferenceSunday  
	,GeographicLocation
	,SchedulingComment
	,SpecificLocation  
	,Preference 
	,UnitType
	,CancelReason
	,ProviderId
	,AttendingId
	,Billable
	,ClientWasPresent
	,OtherPersonsPresent
	,AuthorizationsApproved
	,AuthorizationsNeeded
	,AuthorizationsRequested
	,NumberOfTimeRescheduled
	,NumberOfTimesCancelled
	,DoNotComplete
	,Comment
	,Flag1
	,OverrideError
	,OverrideBy
	,ReferringId
	,DateTimeIn
	,DateTimeOut
	,NoteAuthorId
	,ModifierId1
	,ModifierId2
	,ModifierId3
	,ModifierId4
	,PlaceOfServiceId
	,ServiceDetailTitle
	,ProcedureCodeName 
	,StatusName 
	,UnitTypeName
	,DocumentId
	,Charge
	,ProcedureRateId
	,SavedServiceStatus
	)

	SELECT	
	C.ClientId    
	,C.LastName + ', ' + C.FirstName AS ClientName    
	,S.ClinicianId    
	,S.ProcedureCodeId    
	,S.LocationId  
	,S.ProgramId  
	,CAST(@DateFilter AS DATETIME) + CAST(RIGHT(CONVERT(DATETIME, S.DateOfService, 100),7) AS DATETIME)
	,CAST(@DateFilter AS DATETIME) + CAST(RIGHT(CONVERT(DATETIME, S.EndDateOfService, 100),7) AS DATETIME)
	,RIGHT(CONVERT(DATETIME, S.DateOfService, 100),7) AS [Time]
	/*,S.Unit */
	,CONVERT(DECIMAL(18,2),ROUND(S.Unit/5,0) * 5) /*Round off to nearest next minutes say 32 to 30, 33 to 35 */
	,70 --For Copy Services, we need to set status as schedule    
	,S.CreatedBy    
	,S.CreatedDate    
	,S.ModifiedBy    
	,S.ModifiedDate    
	,S.RecordDeleted    
	,S.DeletedBy    
	,S.DeletedDate
	,'Y'
	,C.SchedulingPreferenceMonday
	,C.SchedulingPreferenceTuesday
	,C.SchedulingPreferenceWednesday
	,C.SchedulingPreferenceThursday
	,C.SchedulingPreferenceFriday
	,C.SchedulingPreferenceSaturday 
    ,C.SchedulingPreferenceSunday  
	,C.GeographicLocation
	,C.SchedulingComment
	,S.SpecificLocation 
	,SUBSTRING(CASE WHEN C.SchedulingPreferenceMonday = 'Y' THEN ',M ' ELSE '' END +
	CASE WHEN C.SchedulingPreferenceTuesday = 'Y' THEN ',TU ' ELSE '' END +
	CASE WHEN C.SchedulingPreferenceWednesday = 'Y' THEN ',W ' ELSE '' END +
	CASE WHEN C.SchedulingPreferenceThursday = 'Y' THEN ',TH ' ELSE '' END +	
	CASE WHEN C.SchedulingPreferenceFriday = 'Y' THEN ',F' ELSE '' END +
	CASE WHEN C.SchedulingPreferenceSaturday = 'Y' THEN ',S' ELSE '' END +
	CASE WHEN C.SchedulingPreferenceSunday = 'Y' THEN ',Su' ELSE '' END ,2,20)
	,S.UnitType
	,S.CancelReason
	,S.ProviderId
	,S.AttendingId
	,S.Billable
	,S.ClientWasPresent
	,S.OtherPersonsPresent
	,S.AuthorizationsApproved
	,S.AuthorizationsNeeded
	,S.AuthorizationsRequested
	,S.NumberOfTimeRescheduled
	,S.NumberOfTimesCancelled
	,S.DoNotComplete
	,S.Comment
	,S.Flag1
	,S.OverrideError
	,S.OverrideBy
	,S.ReferringId
	,S.DateTimeIn
	,S.DateTimeOut
	,S.NoteAuthorId
	,S.ModifierId1
	,S.ModifierId2
	,S.ModifierId3
	,S.ModifierId4
	,S.PlaceOfServiceId
	,(SELECT '' + PC.DisplayAs +', '+ CONVERT(VARCHAR,CAST(S.DateOfService AS TIME),100)+', '+ (CAST(CAST(S.Unit as int) as varchar) + ' '+ ISNULL((SELECT CodeName FROM GlobalCodes WHERE GlobalCodeId=S.UnitType),'')) +', '+        
	GC.CodeName + 
		CASE WHEN S.Comment IS NULL THEN ''
			ELSE ' (' + CAST (S.Comment AS VARCHAR(MAX))+ ')' 
		END) 
	AS Title 
	,PC.DisplayAs   
	,'Scheduled' --GC.CodeName 
	,GCUT.CodeName 
	,D.DocumentId
	,S.Charge
	,S.ProcedureRateId
	,70 as SavedServiceStatus  
	FROM  Services S      	   
	INNER JOIN #TempClientPrograms [TCP] ON [TCP].ClientId = S.ClientId
	JOIN Clients C ON [TCP].ClientId = C.ClientId 
	LEFT JOIN ProcedureCodes PC ON PC.ProcedureCodeId = S.ProcedureCodeId
	LEFT JOIN GlobalCodes GC ON GC.GlobalCodeId =S.Status
	LEFT JOIN  GlobalCodes GCUT ON GCUT.GlobalCodeId =S.UnitType
	LEFT JOIN Documents D ON D.ServiceId = S.ServiceId
	WHERE ISNULL(S.RecordDeleted,'N') <> 'Y'	   
	AND S.ProgramId = @ProgramId AND S.Status IN(70,71,75) AND S.GroupServiceId IS NULL 
	AND (@StaffId = -1 OR S.ClinicianId = @StaffId)
	--Modified by Maninder for task#2763 in Thresholds Bugs/Feature
	--AND (@IncludeAllScheduledServices = 'Y' OR  (C.SchedulingPreferenceMonday = @SchedulingPreferenceMonday OR @SchedulingPreferenceMonday = 'N'))  
	--AND (@IncludeAllScheduledServices = 'Y' OR (C.SchedulingPreferenceTuesday = @SchedulingPreferenceTuesday OR @SchedulingPreferenceTuesday = 'N'))  
	--AND (@IncludeAllScheduledServices = 'Y' OR (C.SchedulingPreferenceWednesday = @SchedulingPreferenceWednesday OR @SchedulingPreferenceWednesday = 'N'))  
	--AND (@IncludeAllScheduledServices = 'Y' OR (C.SchedulingPreferenceThursday = @SchedulingPreferenceThursday OR @SchedulingPreferenceThursday = 'N'))  
	--AND (@IncludeAllScheduledServices = 'Y' OR (C.SchedulingPreferenceFriday = @SchedulingPreferenceFriday OR @SchedulingPreferenceFriday = 'N'))  
 
	AND ((@IncludeAllScheduledServices = 'Y' AND  (C.SchedulingPreferenceMonday = @SchedulingPreferenceMonday))  
	OR (@IncludeAllScheduledServices = 'Y' AND (C.SchedulingPreferenceTuesday = @SchedulingPreferenceTuesday ))  
	OR (@IncludeAllScheduledServices = 'Y' and (C.SchedulingPreferenceWednesday = @SchedulingPreferenceWednesday ))  
	OR (@IncludeAllScheduledServices = 'Y' and (C.SchedulingPreferenceThursday = @SchedulingPreferenceThursday ))  
	OR (@IncludeAllScheduledServices = 'Y' and (C.SchedulingPreferenceFriday = @SchedulingPreferenceFriday ))  
	OR (@IncludeAllScheduledServices = 'Y' and (C.SchedulingPreferenceSaturday = @SchedulingPreferenceSaturday )) 
    OR (@IncludeAllScheduledServices = 'Y' and (C.SchedulingPreferenceSunday = @SchedulingPreferenceSunday )) )
 
	--Ends
	AND CAST(CONVERT(VARCHAR(10),S.DateOfService,101) AS DATETIME) = @CopyDateFilter 		
	AND EXISTS(
	SELECT 1 FROM StaffPrograms SP LEFT JOIN  Staff ON Staff.StaffId = SP.StaffId  
	WHERE Staff.Active = 'Y' AND ISNULL(SP.RecordDeleted,'N') <> 'Y' AND SP.StaffId = S.ClinicianId AND SP.ProgramId = @ProgramId 
	)	
END
	
INSERT INTO #TempClientServices (ClientId,
	ClientName,DateOfService,IsChecked,Status
	,ProgramId
	,SchedulingPreferenceMonday
	,SchedulingPreferenceTuesday
	,SchedulingPreferenceWednesday
	,SchedulingPreferenceThursday
	,SchedulingPreferenceFriday
	,SchedulingPreferenceSaturday 
    ,SchedulingPreferenceSunday
	,GeographicLocation
	,SchedulingComment 
	,Preference
	,StatusName
	,SavedServiceStatus )

	SELECT  
	DISTINCT C.ClientId,	
	LastName+', '+ FirstName as ClientName
	,@DateFilter
	,'N'
	,70
	,@ProgramId
	,C.SchedulingPreferenceMonday
	,C.SchedulingPreferenceTuesday
	,C.SchedulingPreferenceWednesday
	,C.SchedulingPreferenceThursday
	,C.SchedulingPreferenceFriday	
	,C.SchedulingPreferenceSaturday 
    ,C.SchedulingPreferenceSunday  
	,C.GeographicLocation
	,C.SchedulingComment 
	,SUBSTRING(CASE WHEN C.SchedulingPreferenceMonday = 'Y' THEN ',M ' ELSE '' END +
	CASE WHEN C.SchedulingPreferenceTuesday = 'Y' THEN ',TU ' ELSE '' END +
	CASE WHEN C.SchedulingPreferenceWednesday = 'Y' THEN ',W ' ELSE '' END +
	CASE WHEN C.SchedulingPreferenceThursday = 'Y' THEN ',TH ' ELSE '' END +	
	CASE WHEN C.SchedulingPreferenceFriday = 'Y' THEN ',F' ELSE '' END +
	CASE WHEN C.SchedulingPreferenceSaturday = 'Y' THEN ',S' ELSE '' END +
	CASE WHEN C.SchedulingPreferenceSunday = 'Y' THEN ',Su' ELSE '' END,2,20)  
	,'Scheduled'  
	,70
	from #TempClientPrograms [TCP]
	join clients C on [TCP].ClientId =C.ClientId 	
	AND (@IncludeAllScheduledServices = 'Y' OR  (C.SchedulingPreferenceMonday = @SchedulingPreferenceMonday OR @SchedulingPreferenceMonday = 'N'))
	AND (@IncludeAllScheduledServices = 'Y' OR (C.SchedulingPreferenceTuesday = @SchedulingPreferenceTuesday OR @SchedulingPreferenceTuesday = 'N'))
	AND (@IncludeAllScheduledServices = 'Y' OR (C.SchedulingPreferenceWednesday = @SchedulingPreferenceWednesday OR @SchedulingPreferenceWednesday = 'N'))
	AND (@IncludeAllScheduledServices = 'Y' OR (C.SchedulingPreferenceThursday = @SchedulingPreferenceThursday OR @SchedulingPreferenceThursday = 'N'))
	AND (@IncludeAllScheduledServices = 'Y' OR (C.SchedulingPreferenceFriday = @SchedulingPreferenceFriday OR @SchedulingPreferenceFriday = 'N'))
	AND (@IncludeAllScheduledServices = 'Y' OR (C.SchedulingPreferenceSaturday = @SchedulingPreferenceSaturday OR @SchedulingPreferenceSaturday = 'N'))  
    AND (@IncludeAllScheduledServices = 'Y' OR (C.SchedulingPreferenceSunday = @SchedulingPreferenceSunday OR @SchedulingPreferenceSunday = 'N'))
	AND NOT EXISTS(
		SELECT ClientId FROM #TempClientServices WHERE ClientId = [TCP].ClientId)

--GET Services and Clients Finally 
SELECT TCS.* FROM #TempClientServices TCS ORDER BY ClientName     
 
--ServiceErrors Table
SELECT [ServiceErrorId]
      ,SE.[ServiceId]
      ,SE.[CoveragePlanId]
      ,SE.[ErrorType]
      ,SE.[ErrorSeverity]
      ,SE.[ErrorMessage]
      ,SE.[NextStep]
      ,SE.[RowIdentifier]
      ,SE.[CreatedBy]
      ,SE.[CreatedDate]
      ,SE.[ModifiedBy]
      ,SE.[ModifiedDate]
      ,SE.[RecordDeleted]
      ,SE.[DeletedDate]
      ,SE.[DeletedBy]
  --FROM #TempClientServices TCS  INNER JOIN [ServiceErrors] SE ON  TCS.ServiceId = SE.ServiceId
  FROM #TempClientServices TCS  INNER JOIN [ServiceErrors] SE ON  SE.ServiceId = -1
  WHERE ISNULL(SE.RecordDeleted, 'N') <> 'Y' ORDER BY SE.ServiceId
  
--Appointments
SELECT AP.[AppointmentId]
      ,AP.[StaffId]
      ,AP.[Subject]
      ,AP.[StartTime]
      ,AP.[EndTime]
      ,AP.[AppointmentType]
      ,AP.[Description]
      ,AP.[ShowTimeAs]
      ,AP.[LocationId]
      ,AP.[ServiceId]
      ,AP.[GroupServiceId]
      ,AP.[AppointmentProcedureGroupId]
      ,AP.[RecurringAppointment]
      ,AP.[RecurringDescription]
      ,AP.[RecurringAppointmentId]
      ,AP.[RecurringServiceId]
      ,AP.[RecurringGroupServiceId]
      ,AP.[RowIdentifier]
      ,AP.[CreatedBy]
      ,AP.[CreatedDate]
      ,AP.[ModifiedBy]
      ,AP.[ModifiedDate]
      ,AP.[RecordDeleted]
      ,AP.[DeletedDate]
      ,AP.[DeletedBy]
      ,AP.[RecurringOccurrenceIndex]
      ,AP.[Status]
      ,AP.[CancelReason]
      ,AP.[ExamRoom]
      ,AP.[ClientWasPresent]
      ,AP.[OtherPersonsPresent]
      ,AP.[ClientId]
      ,AP.[SpecificLocation] --Added By Raul Aneja 
      ,AP.[NumberofTimeRescheduled]--Added By Mamta Gupta
  FROM [Appointments] AP INNER JOIN #TempClientServices TCS ON AP.ServiceId = TCS.ServiceId
  
--Documents
SELECT D.[DocumentId]
      ,D.[CreatedBy]
      ,D.[CreatedDate]
      ,D.[ModifiedBy]
      ,D.[ModifiedDate]
      ,D.[RecordDeleted]
      ,D.[DeletedDate]
      ,D.[DeletedBy]
      ,D.[ClientId]
      ,D.[ServiceId]
      ,D.[GroupServiceId]
      ,D.[EventId]
      ,D.[ProviderId]
      ,D.[DocumentCodeId]
      ,D.[EffectiveDate]
      ,D.[DueDate]
      ,D.[Status]
      ,D.[AuthorId]
      ,D.[CurrentDocumentVersionId]
      ,D.[DocumentShared]
      ,D.[SignedByAuthor]
      ,D.[SignedByAll]
      ,D.[ToSign]
      ,D.[ProxyId]
      ,D.[UnderReview]
      ,D.[UnderReviewBy]
      ,D.[RequiresAuthorAttention]
      ,D.[InitializedXML]
      ,D.[BedAssignmentId]
      ,D.[ReviewerId]
      ,D.[InProgressDocumentVersionId]
      ,D.[CurrentVersionStatus]
      ,D.[ClientLifeEventId]
      ,D.[AppointmentId]  --Added by Rakesh Garg w.rf to change in core datamode 12.29 in documents table by Adding new field AppointmentId , As there columns are missing in get sp
  FROM [Documents] [D] INNER JOIN #TempClientServices TCS ON [D].ServiceId = TCS.ServiceId
  WHERE TCS.ServiceId > 0
  order by [D].DocumentId --Added by Hemant For Task#722, Thresholds - Support 
  
--DocumentVersions
SELECT DV.[DocumentVersionId]
      ,DV.[CreatedBy]
      ,DV.[CreatedDate]
      ,DV.[ModifiedBy]
      ,DV.[ModifiedDate]
      ,DV.[RecordDeleted]
      ,DV.[DeletedBy]
      ,DV.[DeletedDate]
      ,DV.[DocumentId]
      ,DV.[Version]
      ,DV.[AuthorId]
      ,DV.[EffectiveDate]
      ,DV.[DocumentChanges]
      ,DV.[ReasonForChanges]
      ,DV.[RevisionNumber]
      ,DV.[RefreshView]
      ,DV.[ReasonForNewVersion]
  FROM [DocumentVersions] DV INNER JOIN #TempClientServices TCS ON DV.DocumentId = TCS.DocumentId
   INNER JOIN [Documents] [D] on D.InProgressDocumentVersionId=DV.DocumentversionId		-- For Task#405, Thresholds - Support
  WHERE TCS.ServiceId > 0
  order by [D].DocumentId --Added by Hemant For Task#722, Thresholds - Support 
  
--DocumentSignatures
SELECT DS.[SignatureId]
      ,DS.[CreatedBy]
      ,DS.[CreatedDate]
      ,DS.[ModifiedBy]
      ,DS.[ModifiedDate]
      ,DS.[RecordDeleted]
      ,DS.[DeletedDate]
      ,DS.[DeletedBy]
      ,DS.[DocumentId]
      ,DS.[SignedDocumentVersionId]
      ,DS.[StaffId]
      ,DS.[ClientId]
      ,DS.[IsClient]
      ,DS.[RelationToClient]
      ,DS.[RelationToAuthor]
      ,DS.[SignerName]
      ,DS.[SignatureOrder]
      ,DS.[SignatureDate]
      ,DS.[VerificationMode]
      ,DS.[PhysicalSignature]
      ,DS.[DeclinedSignature]
      ,DS.[ClientSignedPaper]
      ,DS.[RevisionNumber]
      ,DS.[ReasonForDecline]
  FROM [DocumentSignatures] DS INNER JOIN #TempClientServices TCS ON DS.DocumentId = TCS.DocumentId
  WHERE TCS.ServiceId > 0
     
END TRY    
BEGIN CATCH                                
DECLARE @Error varchar(8000)                                                                          
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                       
+ '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_SCGetTeamSchedulingDetailData')                                                                                                           
+ '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                                                            
+ '*****' + Convert(varchar,ERROR_STATE())                                                        
RAISERROR                                                                                                           
(                                                                             
@Error, -- Message text.         
16, -- Severity.         
1 -- State.                                                           
);                                                                                                        
END CATCH     
END  


GO


