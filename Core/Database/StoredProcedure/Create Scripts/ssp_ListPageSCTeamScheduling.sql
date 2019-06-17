 
/****** Object:  StoredProcedure [dbo].[ssp_ListPageSCTeamScheduling]    Script Date: 07/06/2012 14:52:27 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_ListPageSCTeamScheduling]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_ListPageSCTeamScheduling]
GO

 
/****** Object:  StoredProcedure [dbo].[ssp_ListPageSCTeamScheduling]    Script Date: 07/06/2012 14:52:27 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

   
CREATE Procedure [dbo].[ssp_ListPageSCTeamScheduling]    
@SessionId varchar(30),                                                          
@InstanceId int,                                                          
@PageNumber int = 1,                                                              
@PageSize int,                                                              
@SortExpression varchar(100),    
@LoggedInStaffId int,                 
@StaffId int,                 
@ProgramId int,    
@Date Date,                                          
@DocumentStatusFilter int,                                      
@ViewBy varchar(50)    
/********************************************************************************                                                          
-- Stored Procedure: dbo.ssp_ListPageSCTeamScheduling                                                            
--                                                          
-- Copyright: Streamline Healthcate Solutions                                                          
--                                                          
-- Purpose: used by  Team Scheduling list page                                                          
--                                                          
-- Updates:                                                                                                                 
-- Date			Author			Purpose                                                          
-- Mar 14,2012	Varinder Verma	Created.    
-- Apr 04,2012	Shifali			Modified -     
-- Apr 13,2012	Varinder Verma	Added validation that only Requested,scheduled and discharge date should be considered
-- Apr 18,2012	Varinder Verma	Modify View By Member to show Preferences day with Client Name and get Services
-- Apr 20,2012	Varinder Verma	Added Warning table if there are multiple services for the same client for the same day for the same staff
-- Apr 26,2012	Varinder Verma	Added coma, changed message and removed extra line from Title which is showing in the duplicate client message
-- Apr 27,2012	Varinder Verma	Fetch ServiceId in ServiceList
-- May 14,2012	Varinder Verma	Put a colon sign to differentiate the clients instead of comma sign on "Duplicate Client ICon's" mouse-hover as per task #695
-- May 15,2012	Varinder Verma	Created two temp tables for StaffList and Clients
-- May 17,2012	Varinder Verma	Made Staff and Client List in Ascending order as per task #1009 and 
								Added validation with 'ClientPrograms' for Enrolled programs of services against ViewBy Staff
								And change in title which is showing on mousehover of service
-- May 23,2012	Varinder Verma	Added ClientName colunm into #TempServiceDetails table
-- May 24,2012	Varinder Verma	Added Null check against date field of "ClientPrograms" and "Services" tables
-- May 25,2012	Varinder Verma	Modified date checks to get services as displaying in details page
-- May 31,2012	Davinder Kumar	Update ProcedureCodeName to DisplayAs 
-- Jun 01,2012	Varinder Verma	Fetch ServiceIds with DocumentIds to open Service Note page
-- Jun 15,2012	Davinder kumar	Convert sv.Unit to CAST(CAST(Sv.Unit as int) as varchar) in table #TempServiceDetails
-- Jun 22,2012	Varinder Verma	Fetch Service Status with ServiceId too
-- Jun 28,2012	Shifali			Modified - Added <br /> tag instead of char(10)
-- Jul 20,2012	Varinder Verma	Added GroupCode for GroupService to show in the title in case of ViewBy='Staff' only
-- Aug 07,2012	Varinder Verma	Show group-service in "Title" with "Group (GroupName)" 
-- Aug 21,2012	Vikas Kashyap	Made Changes w.r.t. Task#1721,Team Scheduling is supposed to exclude group services. - Per Javed 
-- Sep 19,2012	Vikas Kashyap	Made Changes w.r.t. Task#1721,Revert Privous changes as per Updated Comment 
--01 DEC 2015 Ravichandra		what:Changed code to display Clients LastName and FirstName when ClientType='I' else  OrganizationName.  /   
								why:task #609, Network180 Customization  
--04-01-2016    Basudev Sahu    Changed code to display Clients with Comma separated LastName and FirstName when ClientType='I'
-- Oct 01,2017	Anto            Modified code to show/hide saturday and sunday header section in Team scheduling list page based on a recode category - Texas Customizations - #124 
-- Oct 24,2017	Anto            Modified code to display the schedules on saturday and sunday based on the program selected - Texas Customizations - #124 
-- 27 July 2018	Bibhu			what:Added join with staffclients table to display associated clients for login staff  
          						why:Engineering Improvement Initiatives- NBL(I) task #77
*********************************************************************************/                                                          
as    
BEGIN    
BEGIN TRY    
  

DECLARE @RecodeCategoryid INT  
SELECT @RecodeCategoryid = RecodeCategoryid FROM RecodeCategories  WHERE  CategoryCode = 'TEAMSCHEDULING7DAYS' and ISNULL (Recorddeleted, 'N') = 'N'    
DECLARE @Teamschedulingprogram Char(1) = 'N'      
   
IF EXISTS (SELECT 1 FROM   Recodes WHERE IntegerCodeId = @ProgramId and RecodeCategoryId = @RecodeCategoryid and ISNULL (Recorddeleted, 'N') = 'N')  
BEGIN  
SET @Teamschedulingprogram = 'Y'  
END  

    
  
--Set Date Filter to Get Week Start Date And Week End Date  
  
  
--DECLARE @datecol datetime = @Date;  
DECLARE @StartDate Date  
DECLARE @EndDate Date  
       
SELECT @StartDate = DATEADD(dd,2-DATEPART(DW, @Date),@Date)

IF @Teamschedulingprogram = 'Y'
BEGIN
SELECT @EndDate = DATEADD(DD,7, @StartDate)  
END
ELSE
BEGIN
SELECT @EndDate = DATEADD(DD,5, @StartDate)  
END

CREATE TABLe #TempStaffList
	(LastName VARCHAR(100),FirstName VARCHAR(100),Name VARCHAR(200),StaffId INT, Id INT, ProgramId INT)
	
CREATE TABLE #TempClients
	(ClientId INT, Id INT,LastName VARCHAR(100),FirstName VARCHAR(100),Name VARCHAR(200), ProgramId INT)  
  
  
SELECT TOP 1    
 @PageNumber AS PageNumber ,    
 --ISNULL(( TotalCount / @PageSize ), 0) + 1 AS NumberOfPages ,    
 --ISNULL(TotalCount, 0) AS NumberOfRows    
 10 AS NumberOfPages,    
 10 AS NumberOfRows    
    
CREATE TABLE #TempServiceDetails(    
	StaffId INT,ClientId INT,ServiceId INT,DocumentId INT,LastName VARCHAR(100),FirstName VARCHAR(100),ProcedureCodeName VARCHAR(500),DateOfService DATETIME,
	Duration VARCHAR(50), Status VARCHAR(50),Comment NVARCHAR(MAX), Name VARCHAR(100), ClientName VARCHAR(100),GroupCode VARCHAR(50),GroupId INT
)    

DECLARE @Warning AS TABLE (ClientId INT, DateOfService Date,Name Varchar(100))
  
IF(@ViewBy = 'Staff')
	BEGIN
		-- Staff List     
		INSERT INTO #TempStaffList 
		SELECT S.LastName,S.FirstName,(S.LastName + ', '+ S.FirstName), S.StaffId, S.StaffId,SP.ProgramId
		FROM Staff S     
			INNER JOIN StaffPrograms SP ON S.StaffId = SP.StaffId    
			INNER JOIN Programs P on P.ProgramId = SP.ProgramId     
		WHERE P.ProgramId = @ProgramId    
			AND ISNULL(S.RecordDeleted,'N')='N'  AND S.Active = 'Y'
			AND ISNULL(P.RecordDeleted,'N')='N'  AND ISNULL(SP.RecordDeleted,'N')='N'     
		GROUP BY S.FirstName,S.MiddleName ,S.LastName,S.StaffId, SP.ProgramId
		ORDER BY S.LastName,S.FirstName   
		
		SELECT * FROM #TempStaffList ORDER BY LastName, FirstName
		
		-- Service List  
		INSERT INTO #TempServiceDetails     
		SELECT SL.Id,C.ClientId,SV.ServiceId,Doc.DocumentId, C.LastName,c.FirstName,PC.DisplayAs,sv.DateOfService,
		(CAST(CAST(Sv.Unit as int) as varchar) + ' '+ ISNULL(Gc.CodeName,'')) AS Duration, sv.Status,sv.Comment, SL.Name
		,CASE  -- added by Ravichandra 01 DEC 2015
		WHEN ISNULL(C.ClientType, 'I') = 'I'
		 THEN ISNULL(C.LastName, '') + ', ' + ISNULL(C.FirstName, '')
		ELSE ISNULL(C.OrganizationName, '')
		END 	
		--,C.LastName+', ' + c.FirstName
		, G.GroupCode, G.GroupId	
		FROM #TempStaffList SL
			INNER JOIN Services SV ON (SV.ClinicianId = SL.Id and SV.ProgramId=SL.ProgramId)
			INNER JOIN Clients C ON C.ClientId = SV.ClientId   
			INNER JOIN ClientPrograms CP ON CP.ClientId = SV.ClientId 
			LEFT JOIN GlobalCodes GC ON GC.GlobalCodeId = SV.UnitType AND ISNULL(GC.RecordDeleted,'N')='N'    
			LEFT JOIN ProcedureCodes PC ON PC.ProcedureCodeId = SV.ProcedureCodeId  AND ISNULL(PC.RecordDeleted,'N')='N'     
			LEFT JOIN Documents Doc ON Doc.ServiceId= SV.ServiceId AND ISNULL(Doc.RecordDeleted,'N')='N'
			LEFT JOIN GroupServices GS ON GS.GroupServiceId = SV.GroupServiceId AND ISNULL(GS.RecordDeleted,'N')='N' 
			LEFT JOIN Groups G ON G.GroupId = GS.GroupId AND ISNULL(G.RecordDeleted,'N')='N' AND G.Active = 'Y'
		WHERE SL.ProgramId = @ProgramId     
			AND SV.DateOfService >= @StartDate AND SV.DateOfService < @EndDate --AND (SV.EndDateOfService IS NULL OR SV.EndDateOfService < @EndDate OR @EndDate < SV.EndDateOfService)
			AND SV.Status IN(70,71,75) -- here 70=Scheduled, 71=Show and 75=Complete 	
			--AND SV.GroupServiceId IS NULL
			AND ISNULL(SV.RecordDeleted,'N')='N' AND ISNULL(C.RecordDeleted,'N')='N' AND C.Active = 'Y'
			AND CP.ProgramId = @ProgramId  
					AND ((CP.Status = 1 AND (CP.RequestedDate IS NULL OR CP.RequestedDate < @EndDate)) 
						OR	 (Cp.Status = 4 AND (CP.EnrolledDate IS NULL OR CP.EnrolledDate < @EndDate))
						OR	 (CP.Status = 5 AND ((CP.RequestedDate IS NULL OR CP.RequestedDate < @EndDate) OR (CP.EnrolledDate IS NULL OR CP.EnrolledDate < @EndDate))
								AND (CP.DischargedDate IS NULL OR CP.DischargedDate >= @StartDate))  
							)
			AND Exists (Select 1 From  StaffClients SC Where  SC.ClientId=CP.ClientId AND SC.StaffId=@StaffId)   -- 27 July 2018	Bibhu		
			AND ISNULL(CP.RecordDeleted,'N')='N'
			
		-- Adding values into @Warning table if there are multiple services for the same client for the same day for the same staff
			INSERT INTO @Warning
			SELECT ClientId, DateOfService,
			(LastName+', '+FirstName)Name
			FROM -- Below sub-query is grouping because there are multiple services for the same client for the same day for the same staff
				(SELECT StaffId,ClientId, CAST(DateOfService As DATE)DateOfService,LastName,FirstName
				FROM #TempServiceDetails  Group BY StaffId,ClientId, CAST(DateOfService As DATE),LastName,FirstName)AS MultupleClents
			GROUP BY DateOfService,ClientId,LastName,FirstName
			HAVING COUNT(StaffId)> 1			
	END
 ELSE -- View By Client
	BEGIN
		-- Clients List
		INSERT INTO #TempClients
		SELECT C.ClientId, C.ClientId AS Id,C.LastName,C.FirstName,'<div>'+CASE 
																		WHEN ISNULL(C.ClientType, 'I') = 'I'
																		 THEN ISNULL(C.LastName, '') + ' ,' + ISNULL(C.FirstName, '')
																		ELSE ISNULL(C.OrganizationName, '')
																		END + '</div>' + 
		
		
		 --C.LastName + ', ' + C.FirstName + '</div>' + 
			CASE WHEN
			LEN(
			COALESCE(SchedulingPreferenceMonday,SchedulingPreferenceTuesday,SchedulingPreferenceWednesday,SchedulingPreferenceThursday,SchedulingPreferenceFriday,SchedulingPreferenceSaturday,SchedulingPreferenceSunday)
			)>0 
			THEN '<div>('+ SUBSTRING(
			CASE ISNULL(SchedulingPreferenceMonday,'N') WHEN 'Y' THEN ',M' ELSE '' END +
			CASE ISNULL(SchedulingPreferenceTuesday,'N') WHEN 'Y' THEN ',TU' ELSE '' END +
			CASE ISNULL(SchedulingPreferenceWednesday,'N') WHEN 'Y' THEN ',W' ELSE '' END +
			CASE ISNULL(SchedulingPreferenceThursday,'N') WHEN 'Y' THEN ',TH' ELSE '' END +
			CASE ISNULL(SchedulingPreferenceFriday,'N') WHEN 'Y' THEN ',F' ELSE '' END +
			CASE ISNULL(SchedulingPreferenceSaturday,'N') WHEN 'Y' THEN ',S' ELSE '' END +
			CASE ISNULL(SchedulingPreferenceSunday,'N') WHEN 'Y' THEN ',Su' ELSE '' END
			,2,20)+')</div>'
			ELSE ''
			END AS Name,
			CP.ProgramId 
		FROM Clients C INNER JOIN  ClientPrograms CP ON C.ClientId = CP.ClientId
		WHERE CP.ProgramId = @ProgramId  
					AND ((CP.Status = 1 AND (CP.RequestedDate IS NULL OR CP.RequestedDate < @EndDate))  
						OR	 (Cp.Status = 4 AND (CP.EnrolledDate IS NULL OR CP.EnrolledDate < @EndDate))
						OR	 (CP.Status = 5 AND ((CP.RequestedDate IS NULL OR CP.RequestedDate < @EndDate) OR (CP.EnrolledDate IS NULL OR CP.EnrolledDate < @EndDate))
								AND (CP.DischargedDate IS NULL OR CP.DischargedDate >= @StartDate))  
							)
			AND ISNULL(C.RecordDeleted,'N')='N' AND C.Active = 'Y'
			AND ISNULL(CP.RecordDeleted,'N')='N'	
			AND Exists (Select 1 From  StaffClients SC Where  SC.ClientId=CP.ClientId AND SC.StaffId=@StaffId)   -- 27 July 2018	Bibhu		
		GROUP BY C.ClientId,C.ClientType,C.FirstName, C.MiddleName, C.LastName,C.OrganizationName, C.ClientId,SchedulingPreferenceMonday,SchedulingPreferenceTuesday
			,SchedulingPreferenceWednesday,SchedulingPreferenceThursday,SchedulingPreferenceFriday,SchedulingPreferenceSaturday,SchedulingPreferenceSunday, CP.ProgramId
		ORDER BY C.LastName,C.FirstName    
		
		SELECT ClientId, Id, LastName, FirstName, [Name]
		FROM #TempClients	  	  
			GROUP BY ClientId, Id, LastName, FirstName, [Name]
			ORDER BY LastName, FirstName	
	  
		-- Service List   
		INSERT INTO #TempServiceDetails   
		  
		SELECT  S.StaffId,SV.ClientId,SV.ServiceId,Doc.DocumentId, S.LastName,S.FirstName,PC.DisplayAs,sv.DateOfService
			,(CAST(CAST(Sv.Unit as int) as varchar) + ' '+ ISNULL(Gc.CodeName,'')) AS Duration, sv.Status,SV.Comment, TmpC.LastName + ', ' + TmpC.FirstName
			,TmpC.LastName + ', ' + TmpC.FirstName,NULL,NULL
		FROM Services SV		 		
			LEFT JOIN GlobalCodes GC ON GC.GlobalCodeId = SV.UnitType AND ISNULL(GC.RecordDeleted,'N')='N'
			INNER JOIN ProcedureCodes PC ON PC.ProcedureCodeId = SV.ProcedureCodeId 
			INNER JOIN StaffPrograms SP ON (SP.StaffId = SV.ClinicianId AND SP.ProgramId = SV.ProgramId)
			INNER JOIN Staff S ON S.StaffId = SV.ClinicianId
			INNER JOIN #TempClients TmpC ON TmpC.Id = SV.ClientId AND TmpC.ProgramId = SP.ProgramId
			LEFT JOIN Documents Doc ON Doc.ServiceId= SV.ServiceId AND ISNULL(Doc.RecordDeleted,'N')='N'
		WHERE SV.ProgramId = @ProgramId
			AND SV.DateOfService >= @StartDate AND SV.DateOfService < @EndDate --AND (SV.EndDateOfService IS NULL OR SV.EndDateOfService < @EndDate OR @EndDate <= SV.EndDateOfService)
			AND SV.Status IN(70,71,75) -- here 70=Scheduled, 71=Show and 75=Complete   		 
			--AND SV.GroupServiceId IS NULL			
			AND ISNULL(SV.RecordDeleted,'N')='N'      
			AND ISNULL(PC.RecordDeleted,'N')='N'		 
		ORDER By sv.ClientId,SV.ServiceId, sv.DateOfService	 
   END 
  
  
-- Return values from the #TempServiceDetails table for both the views(By Staff OR By Client)    
SELECT StaffId,ClientId, LastName,FirstName,CAST(DateOfService As DATE)DateOfService,     
 CASE WHEN COUNT(ClientId)>1 THEN 'Y' ELSE 'N' END AS 'IsMultipleServices',ClientName,  
 --------------------------- Making Title --------------------------------
 SUBSTRING(REPLACE( 
  (SELECT '' + CASE WHEN GroupCode IS NOT NULL THEN 'Group ' + GroupCode + ' ' ELSE Name END
  + ' - ' + ProcedureCodeName +', '+ CONVERT(VARCHAR,CAST(DateOfService AS TIME),100)+', '+
	CASE WHEN Duration IS NULL THEN '' ELSE Duration +', ' END +        
   GC.CodeName + 
		CASE WHEN Comment IS NULL THEN ''
			ELSE ' (' + CAST (Comment AS VARCHAR(MAX))+ ')' 
		END	+ '<br />'	
  FROM #TempServiceDetails    
   INNER JOIN GlobalCodes GC ON GC.GlobalCodeId = Status    
  WHERE StaffId = SD.StaffId AND Clientid=SD.Clientid AND CAST(SD.DateOfService As DATE)= CAST(DateOfService As DATE) 
  GROUP BY Name,ProcedureCodeName,CONVERT(VARCHAR,CAST(DateOfService AS TIME),100),Duration,GC.CodeName,Comment, ServiceId,GroupCode
  FOR XML PATH('')    
  ),'&lt;br /&gt;','<br />'),1,2500) AS Title
  --------------------------- End Making Title --------------------------------
  --------------------------- Fetching ServiceIds,Status and GroupId --------------------------------
  , SUBSTRING(
		(SELECT ','+ CAST(ServiceId AS VARCHAR(50)) + '^' + CAST([Status] AS VARCHAR(10)) + 
			CASE WHEN GroupId IS NOT NULL THEN '^' +  CAST(GroupId AS VARCHAR(50)) ELSE '' END
		FROM #TempServiceDetails 
		WHERE StaffId = SD.StaffId AND Clientid=SD.Clientid AND CAST(SD.DateOfService As DATE)= CAST(DateOfService As DATE) 
			GROUP BY ServiceId,[Status],GroupId
		FOR XML PATH('')
	),2,500)AS ServiceId
	--------------------------- End Fetching ServiceIds,Status and GroupId --------------------------------	
	--------------------------- ServiceAndDocumentIds --------------------------------------------------
	,SUBSTRING( 
	  (SELECT '' + CAST(ServiceId AS VARCHAR(50)) + 	
		'^'+ ISNULL(CAST(DocumentId AS VARCHAR(50)),'')	+ ','  
	  FROM #TempServiceDetails    	   
	  WHERE StaffId = SD.StaffId AND Clientid=SD.Clientid AND CAST(SD.DateOfService As DATE)= CAST(DateOfService As DATE) 
		GROUP BY ServiceId,DocumentId
		FOR XML PATH('')    
	  ),1,2500) AS ServiceAndDocumentIds	
	--------------------------- ServiceAndDocIds --------------------------------------------------	
FROM #TempServiceDetails SD  WHERE GroupCode IS NULL
GROUP BY StaffId,ClientId, LastName,FirstName,CAST(DateOfService As DATE), ClientName
ORDER BY ClientId, CAST(DateOfService As DATE)    
    
-- Returns values from the table to show warning image in View By Staff page
SELECT DateOfService, 
	SUBSTRING(
			(Select '; ' + Name FROM @Warning WHERE DateOfService=Warning.DateOfService FOR XML PATH(''))
			,2,1200)+' assigned to multiple staff on this day.' As Name
FROM @Warning Warning GROUP BY DateOfService

SELECT @Teamschedulingprogram as programstatus  
    
END TRY    
     
 BEGIN CATCH    
  DECLARE @Error VARCHAR(8000)           
  SET @Error= CONVERT(VARCHAR,ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000),ERROR_MESSAGE())                                                                                                
   + '*****' + ISNULL(CONVERT(VARCHAR,ERROR_PROCEDURE()),'ssp_ListPageSCTeamScheduling')                                                                                                 
   + '*****' + CONVERT(VARCHAR,ERROR_LINE()) + '*****' + Convert(VARCHAR,ERROR_SEVERITY())                                                                                                  
   + '*****' + CONVERT(VARCHAR,ERROR_STATE())    
  RAISERROR    
  (    
   @Error, -- Message text.    
   16,  -- Severity.    
   1  -- State.    
  );    
 END CATCH    
 SET TRANSACTION ISOLATION LEVEL READ COMMITTED     
    
END





GO


