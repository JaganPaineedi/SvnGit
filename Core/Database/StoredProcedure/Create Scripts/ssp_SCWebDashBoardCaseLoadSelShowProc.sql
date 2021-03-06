 /****** Object:  StoredProcedure [dbo].[ssp_SCWebDashBoardCaseLoadSelShowProc]    Script Date: 12/04/2012 11:07:35 ******/
IF EXISTS (SELECT *
           FROM   sys.objects
           WHERE  object_id =
                  Object_id(N'[dbo].[ssp_SCWebDashBoardCaseLoadSelShowProc]')
                  AND type IN ( N'P', N'PC' ))
  DROP PROCEDURE [dbo].[ssp_SCWebDashBoardCaseLoadSelShowProc]

go

/****** Object:  StoredProcedure [dbo].[ssp_SCWebDashBoardCaseLoadSelShowProc]    Script Date: 12/04/2012 11:07:35 ******/
SET ansi_nulls ON

go

SET quoted_identifier ON

go

CREATE PROCEDURE [dbo].[Ssp_scwebdashboardcaseloadselshowproc] (@StaffId
INT,
                                                                @LoggedInStaffId
INT,
                                                                @RefreshData
CHAR(1) = NULL)
--/*********************************************************************/
--/* Stored Procedure: dbo.ssp_SCWebDashBoardCaseLoadSelShowProc                */
-- 
-- Copyright: Streamline Healthcate Solutions
-- 
-- Purpose: used by Caseload Dashboard Widget
-- 
-- Updates:
-- Date        Author      Purpose
-- 08.27.2010  TER         Redesigned based on the SC My Caseload List Page
-- 08.27.2012   TRemisoski Changed where clause for non-primary caseload so only clients with past show/complete services or future scheduled services are included.
/* 9/Nov/2012  Mamta Gupta  @UsePrimaryProgramForCaseload checkbox condition added in in select query where clinical is primaryClinician for clients
        Task No. 220 3x.Issues*/
--01 Mar 2013 Praveen Potnuru What: add new checks according to new property added in staff table 'DetermineCaseloadBy'							 
--why: w.r.t Task #183(3.5x issues).
--27 Mar 2013 Praveen Potnuru What: commented where check 	(c.PrimaryClinicianId <> @StaffId  OR c.PrimaryClinicianId is null)						 
                           -- why: w.r.t Task #204(3.5x issues).
--04 Apr 2013 Praveen Potnuru: Added Distint condition w.r.t task204 in 3.5x issues  
--28-Aug-2015 Deej Added logic invoke a custom sp to implement custom logic for caseload
--04-Feb-2019 Vijeta Added logic to to display the record for those clients whose client's episode to be active and should not be discharged (status should be Either 'Enrolled' or 'In Treatment')
--				Task: Spring River-Support Go Live #333										                          
--*********************************************************************************/
AS
    --If exists(Select * from CaseloadWidgetCache a
    --      cross join widgets b
    --      where b.WidgetId = 7 and datediff(mi, a.LastRefreshed, getdate()) < isnull(b.RefreshInterval,0)
    --      and a.StaffId = @StaffId and a.LoggedInStaffId = @LoggedInStaffId
    --      and isnull(@RefreshData,'') <> 'Y')
    --      Begin
    --        Goto FinalSelect
    --      End
    DELETE FROM caseloadwidgetcache
    WHERE  staffid = @StaffId
           AND loggedinstaffid = @LoggedInStaffId

    DECLARE @UsePrimaryProgramForCaseload CHAR(1),
            @PrimaryProgramId             INT,
            @DetermineCaseloadBy          INT
    DECLARE @Today DATETIME

    SET @Today = CONVERT(CHAR(10), Getdate(), 101)

    SELECT @UsePrimaryProgramForCaseload = useprimaryprogramforcaseload,
           @PrimaryProgramId = primaryprogramid,
           @DetermineCaseloadBy = determinecaseloadby
    FROM   staff
    WHERE  staffid = @StaffId

    CREATE TABLE #clients
      (
         clientid            INT,
         primaryclient       VARCHAR(3),
         mylastdateofservice DATETIME
      )

    INSERT INTO #clients
                (clientid,
                 primaryclient)
    SELECT DISTINCT c.clientid,
           cl.primaryclient
    FROM   clients c
           JOIN staffclients sc
             ON sc.staffid = @LoggedInStaffId
                AND sc.clientid = c.clientid
           JOIN (SELECT c.clientid,
                        'Yes' AS PrimaryClient
                 FROM   clients c
                 WHERE  c.primaryclinicianid = @StaffId
                        --AND Isnull(@UsePrimaryProgramForCaseload, 'N') = 'N'
                        AND @DetermineCaseloadBy = 8271---Primary Clinician
                 UNION
                 SELECT c.clientid,
                        'Yes' AS PrimaryClient
                 FROM   clients c
                 WHERE  
                        --Isnull(c.primaryclinicianid, 0) <> @StaffId
                        --AND Isnull(@UsePrimaryProgramForCaseload, 'N') = 'Y'
                        @DetermineCaseloadBy = 8272 --Primary Program
                        AND EXISTS(SELECT *
                                   FROM   clientprograms cp
                                   WHERE  cp.clientid = c.clientid
                                          AND cp.programid = @PrimaryProgramId
                                          AND cp.status <> 5
                                          AND Isnull(cp.recorddeleted, 'N') =
                                              'N')
                        
                 UNION
                 SELECT c.clientid,
                        'Yes' AS PrimaryClient
                 FROM   clients c
                 WHERE  
                        --Isnull(c.primaryclinicianid, 0) <> @StaffId
                        --AND Isnull(@UsePrimaryProgramForCaseload, 'N') = 'Y'
                        @DetermineCaseloadBy = 8273--Assigned Programs
                        AND EXISTS(SELECT *
                                   FROM   clientprograms cp
                                          INNER JOIN staffprograms sp
                                                  ON sp.programid = cp.programid
                                                     AND sp.staffid = @StaffId AND 
                                                     Isnull(sp.recorddeleted, 'N') ='N'
                                   WHERE  cp.clientid = c.clientid
                                          AND cp.status <> 5
                                          AND Isnull(cp.recorddeleted, 'N') =
                                              'N')
                        
                 UNION
                 SELECT c.clientid,
                        'No' AS PrimaryClient
                 FROM   clients c
                 WHERE  EXISTS(SELECT *
                               FROM   services s
                               WHERE  s.clientid = c.clientid
                                      AND s.clinicianid = @StaffId
                                      -- TER - 2012.08.27 - client had to have been previously seen by the clinician or is scheduled to be seen in the future
                                      -- Services in the past that are still in scheduled status do not count
                                    and (
									(
										s.Status = 70
										and DATEDIFF(DAY, s.DateOfService, @today) <= 0
									)
									or (
										s.DateOfService >= dateadd(mm, -3, @today) -- Service was done in the last 3 months
										and s.Status in (71, 75)	
									)
								)
                                and s.Status not in (72, 73)   
                                      AND Isnull(c.recorddeleted, 'N') = 'N'
                                      AND Isnull(s.recorddeleted, 'N') <> 'Y')
                       -- AND Isnull(c.primaryclinicianid, 0) <> @StaffId
                        AND ( 
                        (@DetermineCaseloadBy = 8271 and (c.PrimaryClinicianId <> @StaffId  OR c.PrimaryClinicianId is null))       
                         OR
                  (@DetermineCaseloadBy = 8272 
                               AND NOT EXISTS(SELECT *
                                             FROM   clientprograms cp
                                             WHERE  cp.clientid = c.clientid
                                                    AND cp.programid =
                                                        @PrimaryProgramId
                                                    AND cp.status <> 5
                                                    AND Isnull(cp.recorddeleted,'N') = 'N'))
                                                        OR
                (@DetermineCaseloadBy = 8273 
                               AND NOT EXISTS(SELECT *
                                             FROM   clientprograms cp
                                             INNER JOIN staffprograms sp
                                                  ON sp.programid = cp.programid
                                                     AND sp.staffid = @StaffId AND 
                                                     Isnull(sp.recorddeleted, 'N') ='N'
                                             WHERE  cp.clientid = c.clientid
                                                   -- AND cp.programid =@PrimaryProgramId
                                                    AND cp.status <> 5
                                                    AND Isnull(cp.recorddeleted,'N') = 'N'))
                                            
                                            ) ) cl
             ON cl.clientid = c.clientid
    WHERE  c.active = 'Y'
           AND Isnull(c.recorddeleted, 'N') = 'N'
	EXEC scsp_SCWebDashBoardCaseLoadSelShowProc @StaffId,@LoggedInStaffId,@RefreshData
	
	DELETE FROM #clients 
	 WHERE exists ( SELECT *    
                           FROM   ClientEpisodes AS ce  
                           JOIN  Clients c  ON ce.ClientId = c.ClientId  
                           AND ce.EpisodeNumber = c.CurrentEpisodeNumber 
                           WHERE  ce.clientid = #clients.clientid    
                              AND ce.Status IN (102)    
                              AND ISNULL(ce.RecordDeleted,'N') = 'N')                                                     

	
    -- Get date last seen by the staff
    UPDATE r
    SET    mylastdateofservice = s.dateofservice
    FROM   #clients AS r
           JOIN services AS s
             ON s.clientid = r.clientid
    WHERE  s.status IN ( 71, 75 )
           AND s.clinicianid = @StaffId
           AND Isnull(s.recorddeleted, 'N') = 'N'
           AND NOT EXISTS (SELECT *
                           FROM   services AS s2
                           WHERE  s2.clientid = s.clientid
                                  AND s2.clinicianid = s.clinicianid
                                  AND s2.status IN ( 71, 75 )
                                  AND s2.dateofservice > s.dateofservice
                                  AND Isnull(s2.recorddeleted, 'N') = 'N')
			
    DECLARE @PrimaryCurrent  INT,
            @PrimaryNotSeen  INT,
            @TotalCurrent    INT,
            @TotalNotSeen    INT,
            @PrimaryLastYear INT,
            @TotalLastYear   INT

    SELECT @TotalCurrent = 0,
           @TotalNotSeen = 0

    SELECT @PrimaryCurrent = Sum(CASE
                                   WHEN primaryclient = 'Yes' THEN 1
                                   ELSE 0
                                 END),
           @PrimaryNotSeen = Sum(CASE
                                   WHEN Isnull(mylastdateofservice, '1/1/1900')
                                        <
                                        Dateadd(
                                        month, -3, @today)
                                        AND primaryclient = 'Yes' THEN 1
                                   ELSE 0
                                 END),
           @TotalCurrent = Count(*),
           @TotalNotSeen = Sum(CASE
                                 WHEN Isnull(mylastdateofservice, '1/1/1900') <
                                      Dateadd(
                                      month, -3, @today)
                                               THEN
                                 1
                                 ELSE 0
                               END)
    FROM   #clients

    IF @@error <> 0
      GOTO error

    -- Primary Last Year
    SELECT @PrimaryLastYear = primarycaseload,
           @TotalLastYear = totalcaseload
    FROM   staffreports
    WHERE  staffid = @StaffId
           AND reportyear = ( Year(Getdate()) - 1 )
           AND reportmonth = Month(Getdate())
           AND Isnull(recorddeleted, 'N') <> 'Y'

    IF @@error <> 0
      GOTO error

    INSERT INTO caseloadwidgetcache
                (staffid,
                 loggedinstaffid,
                 lastrefreshed,
                 currentprimary,
                 currenttotal,
                 notseenprimary,
                 notseentotal,
                 lastyearprimary,
                 lastyeartotal)
    SELECT @StaffId,
           @LoggedInStaffId,
           Getdate(),
           @PrimaryCurrent,
           @TotalCurrent,
           @PrimaryNotSeen,
           @TotalNotSeen,
           @PrimaryLastYear,
           @TotalLastYear

    FINALSELECT:

    SELECT currentprimary  AS "Primary Current",
           currenttotal    AS "Total Current",
           notseenprimary  AS "Primary Not Seen",
           notseentotal    AS "Total Not Seen",
           lastyearprimary AS "Last Year Primary",
           lastyeartotal   AS "Last Year Total"
    FROM   caseloadwidgetcache
    WHERE  staffid = @StaffID
           AND loggedinstaffid = @LoggedInStaffId

    RETURN

    ERROR:

    RAISERROR ('ssp_SCWebDashBoardCaseLoadSelShowProc : An Error Occured', 16, 1)

go  