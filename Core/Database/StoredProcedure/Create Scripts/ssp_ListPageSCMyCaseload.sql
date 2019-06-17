IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'ssp_ListPageSCMyCaseload')
                    AND type IN ( N'P', N'PC' ) )
				BEGIN 
				DROP PROCEDURE ssp_ListPageSCMyCaseload 
				END
                    GO
SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[ssp_ListPageSCMyCaseload]
    @SessionId VARCHAR(30) ,
    @InstanceId INT ,
    @PageNumber INT ,
    @PageSize INT ,
    @SortExpression VARCHAR(100) ,
    @LoggedInStaffId INT ,
    @StaffId INT ,
    @ClientFilter INT ,
    @DaysFilter INT ,
    @NameFilter INT ,
    @ProgramFilter INT ,
    @OtherFilter INT ,
    @EpisodeStatus INT ,
    @NoteType INT 
/********************************************************************************   
-- Stored Procedure: dbo.ssp_ListPageSCMyCaseload   
--   
-- Copyright: Streamline Healthcate Solutions   
--   
-- Purpose: used by MyCaseload list page   
--   
-- Updates:   
-- Date			Author			Purpose   
-- 06.01.2010	SweetyK			Created.   
-- 07.10.2010	Mahesh			Removed Doc and Alert columns from the My Caseload list page.As per task ace #93 under SC Web Stream line Testing  project  
-- 07.21.2010	SFarber			Redesinged and optimized performance.   
-- 03.01.2011	SFarber			Fixed issues when Clients.PrimaryClinicianId is null 
-- 09.01.2012	Karan			Added two parameters @EpisodeStatus and @NoteType     
-- 02.05.2012	Vikas			Added CustomLogic w.r.t. Task#10 Threshold Phase III    
-- 05.30.2012	Sourabh			Added SET NOCOUNT ON, don't display effected rows   
-- 08.23.2012	Shifali			Modified - Added Checks @UsePrimaryProgramForCaseload = 'N'/ClientPrograms.PrimaryAssignment filters as per task# 1841 after                  discussion with Javed as -     
								The logic for Primary Clincian is - If isnull(Staff.UsePrimaryProgramForCaseload,'N') = Y then use the primary program of the client and see if clinician's primary program is the same as the client's to determine if they are a primary clinician.
								If isnull(Staff.UsePrimaryProgramForCaseload,'N') = N then use Clients.PrimaryClinician.          
-- 25/Sep/2012	Vikas kashyap	Made Changes w.r.t. Task#1965 Threshold Phase III bugs  
--12Nov2012		Shifali			Optimized - Removed '*' from the queries in sp with exists   
-- 09.18.2012	Rakesh-II		Changes in procedure raleted to  task  #19 in 3.x Issues (primary clinician caseload is only dependent on Primary Clinician field in Smartcare) 
-- Dec 17,2012  Manjit			Commented script which were creating index on the permanent tables because:
								1. Index should not be dropped or created on permanent tables in application stored-procedures. 
								2. Indexes were already there on the 'Services' table which were creating in the script 
--27 Dec 2012	Vikas Kashyap	What: Optimaization SP with remove all '*' in this sp 
--								Why: My CaseLoad:- Database timeout comes while clicking on banner, w.r.t. Task#68 in 3.5x Issues
--14 Jan 2013	Varinder Verma	What : add check c.PrimaryClinicianId is null and comment  --ISNULL(cp.PrimaryAssignment,'N') = 'Y' 
								Why CaseLoad:- counting miss match w.r.t. task# 30 3.5x Issue 
--01 Mar 2013	Praveen Potnuru	What: add new checks according to new property added in staff table 'DetermineCaseloadBy'               
								why: w.r.t Task #183(3.5x issues). 
--27 Mar 2013	Praveen Potnuru	What: commented where check   (c.PrimaryClinicianId <> @StaffId  OR c.PrimaryClinicianId is null)             
								why: w.r.t Task #204(3.5x issues). 
--31 May 2013	Gayathri Naik	What: Commented the csp_ListPageSCMyCaseload as csp cannot be called inside an ssp.
								So scsp_ListPageSCMyCaseload procedure is called. 
--24 JUN 2014	Revathi			What:Remove ListPageSCMyCaseload table
								Why:task #107 Engineering Improvement Initiatives- NBL(I) 	 
--28-Aug-2015 Deej Added logic invoke a custom sp to implement custom logic for caseload		
--21-DEC-2015   Basudev Sahu Modified For Task #609 Network180 Customization to Get Organisation  As ClientName	
--25-march-2016 Hemant	     Modified logic "<" to ">" to retrieve proper records for "Not Seen in 14 Days","Not Seen in 30 Days","Not Seen in 60 Days" cases.WMU - Support Go Live #242 
--26 April 2016 Aravind      Modified For the Task #156(CEI - Support Go Live) - to show correct Client Episodes on filter in My Caseload Screen 
--05 July 2016	 jcarlson	    added not exists statement to union statements in insert into #ResultSet to stop duplicate clients inserted into #Results by custom case load logic
--18 July 2016	 jcarlson	    modified logic, made sure the script is follows the standardized list page format
--22 Aug 2016    Shruthi.S      Added conditions to pull only recent Client Episode with highest EpisodeNumber.Ref : #306 CEI Support Go Live.							 
--06 Jul 2017	Msood			Removed the @ApplyCustomLogic ='N' check condition for Days Filters code
								Why: Valley - Support Go Live Task #1250
******************************************************************************************************************************************************************************************/
AS
    BEGIN 
        BEGIN TRY 
            DECLARE @CustomFiltersApplied CHAR(1); 
            DECLARE @ApplyFilterClicked CHAR(1); 
            DECLARE @UsePrimaryProgramForCaseload CHAR(1); 
            DECLARE @PrimaryProgramId INT; 
            DECLARE @Today DATETIME; 
            DECLARE @DetermineCaseloadBy INT; 
            DECLARE @ApplyCustomLogic VARCHAR(10);
            SELECT
                    @ApplyCustomLogic = ISNULL([Value] , 'N')
                FROM
                    dbo.SystemConfigurationKeys
                WHERE
                    [Key] = 'ApplyCustomCaseLoadLogic';
            CREATE TABLE #CustomResultSet
                (
                  ClientId INT ,
                  ClientName VARCHAR(100) ,
                  PrimaryClinician CHAR(3) ,
                  EpisodeStatus VARCHAR(250)
                ); 

            CREATE TABLE #ResultSet
                (
                  ClientId INT ,
                  ClientName VARCHAR(100) ,
                  LastName VARCHAR(100) ,
                  PhoneNumber VARCHAR(80) ,
                  AxisV INT ,
                  AxisVDocumentId INT ,
                  LastDateOfService DATETIME ,
                  LastServiceDocumentId INT ,
                  LastServiceServiceId INT ,
                  MyLastDateOfService DATETIME ,
                  MyLastServiceDocumentId INT ,
                  MyLastServiceServiceId INT ,
                  PrimaryClinician CHAR(3) ,
                  EpisodeStatus VARCHAR(250)
                ); 

            SET @Today = CONVERT(CHAR(10) , GETDATE() , 101); 
            SET @CustomFiltersApplied = 'N';
            SET @SortExpression = RTRIM(LTRIM(@SortExpression));

            IF ISNULL(@SortExpression , '') = ''
                SET @SortExpression = 'ClientName';

        

            SELECT
                    @UsePrimaryProgramForCaseload = s.UsePrimaryProgramForCaseload ,
                    @PrimaryProgramId = s.PrimaryProgramId ,
                    @DetermineCaseloadBy = s.DetermineCaseloadBy
                FROM
                    dbo.Staff s
                WHERE
                    s.StaffId = @StaffId; 

            IF @OtherFilter > 10000
                OR @ApplyCustomLogic = 'Y'
                BEGIN 
                    SET @CustomFiltersApplied = 'Y'; 
				
                    IF OBJECT_ID('dbo.scsp_ListPageSCMyCaseload' , 'P') IS NOT NULL
                        BEGIN
                            INSERT INTO #CustomResultSet
                                    ( ClientId ,
                                      ClientName ,
                                      PrimaryClinician ,
                                      EpisodeStatus
                                    )
                                    EXEC dbo.scsp_ListPageSCMyCaseload @LoggedInStaffId = @LoggedInStaffId , @StaffId = @StaffId , @ClientFilter = @ClientFilter ,
                                        @DaysFilter = @DaysFilter , @NameFilter = @NameFilter , @ProgramFilter = @ProgramFilter , @OtherFilter = @OtherFilter ,
                                        @EpisodeStatus = @EpisodeStatus , @NoteType = @NoteType; 
                        END;
                END; 

		  --This is needed to insert clients where the staff is on the clients care team... custom clients, otherwise the core logic can miss some as the core logic does not look at care team
            IF @CustomFiltersApplied = 'Y'
                BEGIN
                    INSERT INTO #ResultSet
                            ( ClientId ,
                              ClientName ,
                              PrimaryClinician ,
                              EpisodeStatus
                            )
                        SELECT
                                ClientId ,
                                ClientName ,
                                PrimaryClinician ,
                                EpisodeStatus
                            FROM
                                #CustomResultSet;

                END;
                      

          --  
            INSERT INTO #ResultSet
                    ( ClientId ,
                      ClientName ,
                      PrimaryClinician ,
                      EpisodeStatus
                    )
                SELECT DISTINCT
                        c.ClientId ,
                        CASE WHEN ISNULL(c.ClientType , 'I') = 'I' THEN ISNULL(c.LastName , '') + ', ' + ISNULL(c.FirstName , '')
                             ELSE ISNULL(c.OrganizationName , '')
                        END ,
          --                c.LastName + ', ' + c.FirstName, 
                        cl.PrimaryClient ,
                        GC.CodeName
                    FROM
                        dbo.Clients c
                    JOIN dbo.StaffClients sc ON sc.StaffId = @LoggedInStaffId
                                                AND sc.ClientId = c.ClientId
                    JOIN (
                           SELECT
                                c.ClientId ,
                                'Yes' AS PrimaryClient
                            FROM
                                dbo.Clients c
                            WHERE
                                @ClientFilter IN ( 80 , 81 ) 
                              -- All, My Primary       
                                AND c.PrimaryClinicianId = @StaffId 
                              --and ISNULL(@UsePrimaryProgramForCaseload,'N') = 'N'   
                                AND @DetermineCaseloadBy = 8271
                                AND NOT EXISTS ( SELECT
                                                        1
                                                    FROM
                                                        #ResultSet AS a
                                                    WHERE
                                                        a.ClientId = c.ClientId )
                       ---Primary Clinician     
                           UNION
                           SELECT
                                c.ClientId ,
                                'Yes' AS PrimaryClient
                            FROM
                                dbo.Clients c
                            WHERE
                                @ClientFilter IN ( 80 , 81 ) 
                              -- All, My Primary       
                              --and c.PrimaryClinicianId <> @StaffId       
                              --and isnull(c.PrimaryClinicianId, 0) = @StaffId -- commented above line & added this one for Task #19 in 3.x issues BY Rakesh-II  
                              --and (c.PrimaryClinicianId <> @StaffId  OR c.PrimaryClinicianId is null)--commented above line & added this one for task #30 in 3.5x Issue Varinderv 
                              --and ISNULL(@UsePrimaryProgramForCaseload,'N') = 'Y'   
                              --commented above line for the task #204 in 3.5x issues     
                                AND @DetermineCaseloadBy = 8272 --Primary Program 
                                AND EXISTS ( SELECT
                                                    1
                                                FROM
                                                    dbo.ClientPrograms cp
                                                WHERE
                                                    cp.ClientId = c.ClientId
                                                    AND cp.ProgramId = @PrimaryProgramId
                                                    AND cp.Status <> 5 
                                                -- and ISNULL(cp.PrimaryAssignment,'N') = 'Y' --commented above line & added this one for task #30 in 3.5x Issue Varinderv 
                                                    AND ISNULL(cp.RecordDeleted , 'N') = 'N' )
                                AND NOT EXISTS ( SELECT
                                                        1
                                                    FROM
                                                        #CustomResultSet AS a
                                                    WHERE
                                                        a.ClientId = c.ClientId )
                           UNION
                           SELECT
                                c.ClientId ,
                                'Yes' AS PrimaryClient
                            FROM
                                dbo.Clients c
                            WHERE
                                @ClientFilter IN ( 80 , 81 ) 
                              -- All, My Primary       
                              --and c.PrimaryClinicianId <> @StaffId       
                              --and isnull(c.PrimaryClinicianId, 0) = @StaffId -- commented above line & added this one for Task #19 in 3.x issues BY Rakesh-II  
                              --and (c.PrimaryClinicianId <> @StaffId  OR c.PrimaryClinicianId is null)--commented above line & added this one for task #30 in 3.5x Issue Varinderv 
                              --and ISNULL(@UsePrimaryProgramForCaseload,'N') = 'Y'  
                              --commented above line for the task #204 in 3.5x issues      
                                AND @DetermineCaseloadBy = 8273--Assigned Programs 
                                AND EXISTS ( SELECT
                                                    *
                                                FROM
                                                    dbo.ClientPrograms cp
                                                INNER JOIN dbo.StaffPrograms sp ON sp.ProgramId = cp.ProgramId
                                                                                   AND sp.StaffId = @StaffId
                                                                                   AND ISNULL(sp.RecordDeleted , 'N') = 'N'
                                                WHERE
                                                    cp.ClientId = c.ClientId 
                                                --and cp.ProgramId = @PrimaryProgramId       
                                                    AND cp.Status <> 5 
                                                -- and ISNULL(cp.PrimaryAssignment,'N') = 'Y' --commented above line & added this one for task #30 in 3.5x Issue Varinderv 
                                                    AND ISNULL(cp.RecordDeleted , 'N') = 'N' )
                                AND NOT EXISTS ( SELECT
                                                        1
                                                    FROM
                                                        #CustomResultSet AS a
                                                    WHERE
                                                        a.ClientId = c.ClientId )
                           UNION
                           SELECT
                                c.ClientId ,
                                'No' AS PrimaryClient
                            FROM
                                dbo.Clients c
                            WHERE
                                @ClientFilter IN ( 80 , 82 ) 
                              -- All, Not My Primary       
                                AND EXISTS ( SELECT
                                                    1
                                                FROM
                                                    dbo.Services s
                                                WHERE
                                                    s.ClientId = c.ClientId
                                                    AND s.ClinicianId = @StaffId
                                                    AND ( ( s.Status = 70
                                                            AND DATEDIFF(DAY , s.DateOfService , @Today) <= 0
                                                          )
                                                          OR ( s.DateOfService >= DATEADD(mm , -3 , @Today) 
                                                            -- Service was done in the last 3 months 
                                                               AND s.Status IN ( 71 , 75 )
                                                             )
                                                        )
                                                    AND s.Status NOT IN ( 72 , 73 )
                                                    AND ISNULL(s.RecordDeleted , 'N') = 'N' 
                                                --- Added By Daman       
                                                    AND ISNULL(c.RecordDeleted , 'N') = 'N' ) 
                              -- and c.PrimaryClinicianId <> @StaffId    
                              -- and (c.PrimaryClinicianId <> @StaffId  OR c.PrimaryClinicianId is null)--commented above line & added this one for task #30 in 3.5x Issue Varinderv                    
                              --commented above line for the task #204 in 3.5x issues 
                                AND ( ( @DetermineCaseloadBy = 8271
                                        AND ( c.PrimaryClinicianId <> @StaffId
                                              OR c.PrimaryClinicianId IS NULL
                                            )
                                      )
                                      OR ( @DetermineCaseloadBy = 8272
                                           AND NOT EXISTS ( SELECT
                                                                    *
                                                                FROM
                                                                    dbo.ClientPrograms cp
                                                                WHERE
                                                                    cp.ClientId = c.ClientId
                                                                    AND cp.ProgramId = @PrimaryProgramId
                                                                    AND cp.Status <> 5
                                                                    AND ISNULL(cp.RecordDeleted , 'N') = 'N' )
                                         )
                                      OR ( @DetermineCaseloadBy = 8273
                                           AND NOT EXISTS ( SELECT
                                                                    *
                                                                FROM
                                                                    dbo.ClientPrograms cp
                                                                INNER JOIN dbo.StaffPrograms sp ON sp.ProgramId = cp.ProgramId
                                                                                                   AND sp.StaffId = @StaffId
                                                                                                   AND ISNULL(sp.RecordDeleted , 'N') = 'N'
                                                                WHERE
                                                                    cp.ClientId = c.ClientId
                                                                    AND cp.Status <> 5
                                                                    AND ISNULL(cp.RecordDeleted , 'N') = 'N' )
                                         )
                                    )
                         ) cl ON cl.ClientId = c.ClientId
                         --Added conditions to pull episodes 22nd Aug Shruthi.S
                        LEFT JOIN (select   
							  CE1.[Status] ,  
							  ResPreFinal.ClientId  
							  from    
							 (  
							  select   
							  max(CE.EpisodeNumber) as EpisodeNumber,  
							  CE.ClientId as ClientId  
							  from ClientEpisodes CE   
							  where ISNULL(CE.RecordDeleted , 'N') = 'N'  
							  group by CE.ClientId  
							 ) ResPreFinal  join  ClientEpisodes CE1 on ResPreFinal.ClientId = CE1.ClientId and CE1.episodenumber=ResPreFinal.episodenumber  
							  and ISNULL(CE1.RecordDeleted , 'N') = 'N'  
           --join GlobalCodes GC on GC.GlobalCodeId = CE1.[Status]   
                        )CE  ON CE.ClientId = c.ClientId    
                    LEFT OUTER JOIN dbo.GlobalCodes GC ON GC.GlobalCodeId = CE.[Status]  
                    LEFT OUTER JOIN (
                                      SELECT
                                            ClientId ,
                                            NoteType
                                        FROM
                                            dbo.ClientNotes
                                        WHERE
                                            ISNULL(RecordDeleted , 'N') = 'N'
                                    ) CN ON CN.ClientId = c.ClientId
                    LEFT OUTER JOIN dbo.ClientPrograms CPE ON CPE.ClientId = c.ClientId
                                                              AND CPE.Status = 4
                                                              AND ( ISNULL(CPE.EnrolledDate , '1 January 1900') >= GETDATE()
                                                                    AND ISNULL(CPE.DischargedDate , '1 January 2100') <= GETDATE()
                                                                  )
                    WHERE
                        c.Active = 'Y'
                        AND ISNULL(c.RecordDeleted , 'N') = 'N'
                        AND ( ISNULL(@ProgramFilter , 0) <= 0
                              OR EXISTS ( SELECT
                                                1
                                            FROM
                                                dbo.ClientPrograms cp
                                            WHERE
                                                cp.ClientId = c.ClientId
                                                AND cp.ProgramId = @ProgramFilter
                                                AND cp.Status <> 5
                                                AND ISNULL(cp.RecordDeleted , 'N') = 'N' )
                            )
                        AND ( @NameFilter IN ( 0 , 92 )
                              OR -- All  
                              ( @NameFilter = 93
                                AND LEFT(c.LastName , 1) BETWEEN 'A' AND 'E'
                              )
                              OR -- Last name begins with A-E       
                              ( @NameFilter = 94
                                AND LEFT(c.LastName , 1) BETWEEN 'F' AND 'J'
                              )
                              OR -- Last name begins with F-J       
                              ( @NameFilter = 95
                                AND LEFT(c.LastName , 1) BETWEEN 'K' AND 'O'
                              )
                              OR -- Last name begins with K-O       
                              ( @NameFilter = 96
                                AND LEFT(c.LastName , 1) BETWEEN 'P' AND 'S'
                              )
                              OR -- Last name begins with P-S       
                              ( @NameFilter = 97
                                AND LEFT(c.LastName , 1) BETWEEN 'T' AND 'Z'
                              )
                            ) 
							  -- Last name begins with T-Z      
                        AND ( CE.Status = @EpisodeStatus
                              OR @EpisodeStatus = 0
                            )
                        AND ( CN.NoteType = @NoteType
                              OR @NoteType = 0
                            )
                        AND ISNULL(CPE.RecordDeleted , 'N') = 'N'
                        AND NOT EXISTS ( SELECT
                                                1
                                            FROM
                                                #CustomResultSet AS a
                                            WHERE
                                                a.ClientId = c.ClientId )
                    ORDER BY
                        c.ClientId; 

            UPDATE
                    r
                SET
                    r.LastDateOfService = s.DateOfService ,
                    r.LastServiceDocumentId = d.DocumentId ,
                    r.LastServiceServiceId = s.ServiceId ,
                    r.MyLastDateOfService = CASE WHEN s.ClinicianId = @StaffId
                                                      AND r.MyLastServiceServiceId IS NULL THEN s.DateOfService
                                                 ELSE r.MyLastDateOfService
                                            END ,
                    r.MyLastServiceDocumentId = CASE WHEN s.ClinicianId = @StaffId
                                                          AND r.MyLastServiceServiceId IS NULL THEN d.DocumentId
                                                     ELSE r.MyLastServiceDocumentId
                                                END ,
                    r.MyLastServiceServiceId = CASE WHEN s.ClinicianId = @StaffId
                                                         AND r.MyLastServiceServiceId IS NULL THEN s.ServiceId
                                                    ELSE r.MyLastServiceServiceId
                                               END
                FROM
                    #ResultSet AS r
                JOIN dbo.Services AS s ON s.ClientId = r.ClientId
                                          AND ISNULL(s.RecordDeleted , 'N') = 'N'
                LEFT JOIN dbo.Documents AS d ON d.ServiceId = s.ServiceId
                                                AND ISNULL(d.RecordDeleted , 'N') = 'N'
                WHERE
                    s.Status IN ( 71 , 75 )
                    AND ISNULL(s.RecordDeleted , 'N') = 'N'
                    AND NOT EXISTS ( SELECT
                                            1
                                        FROM
                                            dbo.Services AS s2
                                        WHERE
                                            s2.ClientId = s.ClientId
                                            AND s2.Status IN ( 71 , 75 )
                                            AND s2.DateOfService > s.DateOfService
                                            AND ISNULL(s2.RecordDeleted , 'N') = 'N' ); 

            UPDATE
                    r
                SET
                    r.MyLastDateOfService = s.DateOfService ,
                    r.MyLastServiceDocumentId = d.DocumentId ,
                    r.MyLastServiceServiceId = s.ServiceId
                FROM
                    #ResultSet AS r
                JOIN dbo.Services AS s ON s.ClientId = r.ClientId
                LEFT JOIN dbo.Documents AS d ON d.ServiceId = s.ServiceId
                                                AND ISNULL(d.RecordDeleted , 'N') = 'N'
                WHERE
                    s.Status IN ( 71 , 75 )
                    AND r.MyLastServiceServiceId IS NULL
                    AND s.ClinicianId = @StaffId
                    AND ISNULL(s.RecordDeleted , 'N') = 'N'
                    AND NOT EXISTS ( SELECT
                                            1
                                        FROM
                                            dbo.Services AS s2
                                        WHERE
                                            s2.ClientId = s.ClientId
                                            AND s2.ClinicianId = s.ClinicianId
                                            AND s2.Status IN ( 71 , 75 )
                                            AND s2.DateOfService > s.DateOfService
                                            AND ISNULL(s2.RecordDeleted , 'N') = 'N' ); 

            IF @DaysFilter <> 83 -- Msood 7/6/2017
                BEGIN 
  --Select Convert(varchar(10),@DaysFilter)+'Demo'+@CustomFiltersApplied;  
                    DELETE
                            r
                        FROM
                            #ResultSet r
                        WHERE
                            ( ( @DaysFilter = 84
                                AND ISNULL(r.MyLastDateOfService , '1/1/1900') < DATEADD(DAY , -7 , @Today)
                              )
                              OR -- Seen in last 7 days           
                              ( @DaysFilter = 85
                                AND ISNULL(r.MyLastDateOfService , '1/1/1900') < DATEADD(WEEK , -2 , @Today)
                              )
                              OR -- Seen in last 2 weeks           
                              ( @DaysFilter = 86
                                AND ISNULL(r.MyLastDateOfService , '1/1/1900') < DATEADD(MONTH , -1 , @Today)
                              )
                              OR -- Seen in last month           
                              ( @DaysFilter = 87
                                AND ISNULL(r.MyLastDateOfService , '1/1/1900') < DATEADD(MONTH , -3 , @Today)
                              )
                              OR -- Seen in last 3 month           
                              ( @DaysFilter = 88
                                AND ISNULL(r.MyLastDateOfService , '1/1/1900') >= DATEADD(MONTH , -1 , @Today)
                              )
                              OR -- not Seen in last month           
                              ( @DaysFilter = 89
                                AND ISNULL(r.MyLastDateOfService , '1/1/1900') >= DATEADD(MONTH , -2 , @Today)
                              )
                              OR -- not seen in last 2 months           
                              ( @DaysFilter = 90
                                AND ISNULL(r.MyLastDateOfService , '1/1/1900') >= DATEADD(MONTH , -3 , @Today)
                              )
                              OR -- not seen in last 3 months           
                              ( @DaysFilter = 91
                                AND ISNULL(r.MyLastDateOfService , '1/1/1900') >= DATEADD(MONTH , -6 , @Today)
                              )
                              OR -- not seen in last 6 months           
	  --(@DaysFilter = 4110 and ISNULL(MyLastDateOfService,'1/1/1900') <= DATEADD(DAY, -0, @today)) or -- Current
	  --Start:25-march-2016 Hemant	          
                              ( @DaysFilter = 4112
                                AND ISNULL(r.MyLastDateOfService , '1/1/1900') > DATEADD(DAY , -14 , @Today)
                                AND ISNULL(r.MyLastDateOfService , '1/1/1900') <= @Today
                              )
                              OR -- not seen in last 14 Days           
                              ( @DaysFilter = 4113
                                AND ISNULL(r.MyLastDateOfService , '1/1/1900') > DATEADD(DAY , -30 , @Today)
                                AND ISNULL(r.MyLastDateOfService , '1/1/1900') <= @Today
                              )
                              OR -- not seen in last 30 Days           
                              ( @DaysFilter = 4114
                                AND ISNULL(r.MyLastDateOfService , '1/1/1900') > DATEADD(DAY , -60 , @Today)
                                AND ISNULL(r.MyLastDateOfService , '1/1/1900') <= @Today
                              ) -- not seen in last 60 Days  
	  --End:25-march-2016 Hemant      
                            ); 
                END; 
            ELSE
                BEGIN  
  -- Get home phone       
                    UPDATE
                            r
                        SET
                            r.PhoneNumber = p.PhoneNumber
                        FROM
                            #ResultSet r
                        JOIN dbo.ClientPhones p ON p.ClientId = r.ClientId
                        WHERE
                            p.PhoneType = 30
                            AND ISNULL(p.RecordDeleted , 'N') = 'N'; 

		-- Get AxisV       
                    UPDATE
                            r
                        SET
                            r.AxisV = a.AxisV ,
                            r.AxisVDocumentId = d.DocumentId
                        FROM
                            #ResultSet r
                        JOIN dbo.Documents d ON d.ClientId = r.ClientId
                        JOIN dbo.DocumentVersions dv ON dv.DocumentVersionId = d.CurrentDocumentVersionId
                        JOIN dbo.DiagnosesV a ON a.DocumentVersionId = dv.DocumentVersionId
                        WHERE
                            d.Status = 22
                            AND a.AxisV IS NOT NULL
                            AND d.DocumentCodeId = 5
                            AND ISNULL(d.RecordDeleted , 'N') = 'N'
                            AND NOT EXISTS ( SELECT
                                                    1
                                                FROM
                                                    dbo.Documents d2
                                                JOIN dbo.DocumentVersions dv2 ON dv2.DocumentVersionId = d2.CurrentDocumentVersionId
                                                JOIN dbo.DiagnosesV a2 ON a2.DocumentVersionId = dv2.DocumentVersionId
                                                WHERE
                                                    d2.ClientId = r.ClientId
                                                    AND d2.Status = 22
                                                    AND d2.DocumentCodeId = 5
                                                    AND ISNULL(d2.RecordDeleted , 'N') = 'N'
                                                    AND d2.EffectiveDate > d.EffectiveDate ); 
                END;
            WITH    counts
                      AS (
                           SELECT
                                COUNT(*) AS TotalRows
                            FROM
                                #ResultSet
                         ),
                    RankResultSet
                      AS (
                           SELECT
                                ClientId ,
                                ClientName ,
                                PhoneNumber ,
                                AxisV ,
                                AxisVDocumentId ,
                                LastDateOfService ,
                                LastServiceDocumentId ,
                                LastServiceServiceId ,
                                MyLastDateOfService ,
                                MyLastServiceDocumentId ,
                                MyLastServiceServiceId ,
                                PrimaryClinician ,
                                EpisodeStatus ,
                                COUNT(*) OVER ( ) AS TotalCount ,
                                ROW_NUMBER() OVER ( ORDER BY CASE WHEN @SortExpression = 'ClientId' THEN ClientId
                                                             END, CASE WHEN @SortExpression = 'ClientId desc' THEN ClientId
                                                                  END DESC, CASE WHEN @SortExpression = 'ClientName' THEN ClientName
                                                                            END, CASE WHEN @SortExpression = 'ClientName desc' THEN ClientName
                                                                                 END DESC, CASE WHEN @SortExpression = 'PhoneNumber' THEN PhoneNumber
                                                                                           END, CASE WHEN @SortExpression = 'PhoneNumber desc' THEN PhoneNumber
                                                                                                END DESC, CASE WHEN @SortExpression = 'AxisV' THEN AxisV
                                                                                                          END, CASE WHEN @SortExpression = 'AxisV desc'
                                                                                                                    THEN AxisV
                                                                                                               END DESC, CASE WHEN @SortExpression = 'LastDateOfService'
                                                                                                                              THEN LastDateOfService
                                                                                                                         END, CASE WHEN @SortExpression = 'LastDateOfService desc'
                                                                                                                                   THEN LastDateOfService
                                                                                                                              END DESC, CASE WHEN @SortExpression = 'MyLastDateOfService'
                                                                                                                                             THEN MyLastDateOfService
                                                                                                                                        END, CASE
                                                                                                                                                WHEN @SortExpression = 'MyLastDateOfService desc'
                                                                                                                                                THEN MyLastDateOfService
                                                                                                                                             END DESC, CASE
                                                                                                                                                WHEN @SortExpression = 'PrimaryClinician'
                                                                                                                                                THEN PrimaryClinician
                                                                                                                                                END, CASE
                                                                                                                                                WHEN @SortExpression = 'PrimaryClinician desc'
                                                                                                                                                THEN PrimaryClinician
                                                                                                                                                END DESC, ClientName, ClientId ) AS RowNumber
                            FROM
                                #ResultSet
                         )
                SELECT TOP ( CASE WHEN ( @PageNumber = -1 ) THEN (
                                                                   SELECT
                                                                        ISNULL(counts.TotalRows , 0)
                                                                    FROM
                                                                        counts
                                                                 )
                                  ELSE ( @PageSize )
                             END )
                        RankResultSet.ClientId ,
                        RankResultSet.ClientName ,
                        RankResultSet.PhoneNumber ,
                        RankResultSet.AxisV ,
                        RankResultSet.AxisVDocumentId ,
                        RankResultSet.LastDateOfService ,
                        RankResultSet.LastServiceDocumentId ,
                        RankResultSet.LastServiceServiceId ,
                        RankResultSet.MyLastDateOfService ,
                        RankResultSet.MyLastServiceDocumentId ,
                        RankResultSet.MyLastServiceServiceId ,
                        RankResultSet.PrimaryClinician ,
                        RankResultSet.EpisodeStatus ,
                        RankResultSet.TotalCount ,
                        RankResultSet.RowNumber
                    INTO
                        #FinalResultSet
                    FROM
                        RankResultSet
                    WHERE
                        RankResultSet.RowNumber > ( ( @PageNumber - 1 ) * @PageSize ); 

            IF (
                 SELECT
                        ISNULL(COUNT(*) , 0)
                    FROM
                        #FinalResultSet
               ) < 1
                BEGIN 
                    SELECT
                            0 AS PageNumber ,
                            0 AS NumberOfPages ,
                            0 NumberofRows; 
                END; 
            ELSE
                BEGIN 
                    SELECT TOP 1
                            @PageNumber AS PageNumber ,
                            CASE ( TotalCount % @PageSize )
                              WHEN 0 THEN ISNULL(( TotalCount / @PageSize ) , 0)
                              ELSE ISNULL(( TotalCount / @PageSize ) , 0) + 1
                            END AS NumberOfPages ,
                            ISNULL(TotalCount , 0) AS NumberofRows
                        FROM
                            #FinalResultSet; 
                END; 

            SELECT
                    ClientId ,
                    ClientName ,
                    PhoneNumber ,
                    AxisV ,
                    AxisVDocumentId ,
                    LastDateOfService ,
                    LastServiceDocumentId ,
                    LastServiceServiceId ,
                    MyLastDateOfService ,
                    MyLastServiceDocumentId ,
                    MyLastServiceServiceId ,
                    PrimaryClinician ,
                    EpisodeStatus
                FROM
                    #FinalResultSet
                ORDER BY
                    RowNumber; 
        END TRY 

        BEGIN CATCH 
            DECLARE @Error VARCHAR(8000); 

            SET @Error = CONVERT(VARCHAR , ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000) , ERROR_MESSAGE()) + '*****'
                + ISNULL(CONVERT(VARCHAR , ERROR_PROCEDURE()) , 'ssp_ListPageSCMyCaseload') + '*****' + CONVERT(VARCHAR , ERROR_LINE()) + '*****'
                + CONVERT(VARCHAR , ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR , ERROR_STATE()); 

            RAISERROR ( @Error, 
                  -- Message text.                                                                                                              
                  16,-- Severity.                                            
                  1 
      -- State.                                                                                                              
      ); 
        END CATCH; 
    END; 

GO