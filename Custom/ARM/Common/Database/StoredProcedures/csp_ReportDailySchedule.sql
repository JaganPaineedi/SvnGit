IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportDailySchedule]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportDailySchedule]
GO


/****** Object:  StoredProcedure [dbo].[csp_ReportDailySchedule]    Script Date: 05/03/2013 11:22:55 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO      
CREATE    PROCEDURE [dbo].[csp_ReportDailySchedule]        
/********************************************************************************                                                            
-- Stored Procedure: [csp_ReportDailySchedule]         
--          
-- Copyright: Streamline Healthcate Solutions          
--          
-- Purpose: Query to return data for the program assignment list page.          
--          
-- Author:  Pradeep          
-- Date:              
--          
-- *****History****          
-- 22/03/2012  MSuma  Modified ReceptionStatus          
-- 26/04/2012       Shruthi.S   Uncommented OrganizationName changes since it was required and changed the globalcodeids since for category 'receptionstatus' globalcodeids are 6852,6853,6851          
-- May 8, 2012      Kneale Alpers Modified the status (codename from globalcodes 250 chars) to substring the value to only 20 characters.          
          
-- 23/05/2012       Shruthi.S   PrimaryCoverage and SecondaryCoverage is changed to 250 chars          
-- 16-06-2012       Gayathri Naik commented the varchar DateofServices          
-- 20-JUN-2012  R Quigley Added Tertiary Coverage to results table and to output          
        Added PrimaryClinician to results table and to output          
        Removed extra update statement for OrganizationName as we are already joining that in the final select.       
--07-10-2012        Gayathri Naik  Since primaryclinician is not mandatory left join is added to retrieve clients.         
--08-10-2012  Gayathri Naik  Date Format cahnges to MM/DD/YYYY format           
--28-Feb-2013  Modified to show PrimaryCare Appoinments  w.r.t #165 in 'Primary Care Bugs/Features'       
--4/12/2013         vishant garg -- Add check of both type of services (Behavioural health care and primary care.)        
--21/11/2013  Chethan N -- Added Parameter ClinicianId to filter the services based to Clinician      
*********************************************************************************/          
    @SelectedDate SMALLDATETIME ,          
    @ReceptionViewId INT ,          
    @Status VARCHAR(100) ,      
    @AppointmentTypes INT = NULL,      
    @ClinicianId INT      
AS          
      
    DECLARE @ServiceStatuses TABLE ( Status INT )    
    IF @ReceptionViewId = -1      
  SET @ReceptionViewId = 9      
        
      IF @AppointmentTypes = NULL      
  SET @AppointmentTypes = 5401  
          
--select * from globalCodes where category = 'ReceptionStatus' select * from globalCodes where category='servicestatus'          
    INSERT  INTO @ServiceStatuses          
            ( Status          
            )          
            SELECT  globalCodeId          
            FROM    GlobalCodes          
            WHERE   ( @status = 6852          
                      AND globalCodeId IN ( 70, 71 )          
                    )          
                    OR ( @status = 6853          
                         AND globalCodeId IN ( 72, 73 )          
                       )          
                    OR ( @status = 6851          
                         AND globalCodeId IN ( 70 )          
                       )        
                     OR(               
                       @status = 6855         
                         AND globalCodeId IN ( 71 )          
                       )        
                    OR ( @status = 0          
                         AND globalCodeId IN ( 70, 71, 72, 73, 76, 75 )          
                       )           
          
    CREATE TABLE #Results          
        (          
          ClientId INT ,          
          ClientName VARCHAR(100) ,          
          [Procedure] VARCHAR(300) ,          
          [DateTime] SMALLDATETIME ,          
          [Status] VARCHAR(20) ,          
          Staff VARCHAR(300) ,          
          MedicaidId VARCHAR(20) ,          
          PrimaryCoverage VARCHAR(250) ,          
          SecondaryCoverage VARCHAR(250) ,          
          TertiaryCoverage VARCHAR(250),          
          OrganizationName VARCHAR(100),          
          PrimaryClinician VARCHAR(100)          
        )         
         if(@AppointmentTypes=5401 or @AppointmentTypes=5402)      
        begin     
    INSERT  INTO #Results          
            ( ClientId ,          
              ClientName ,          
              [Procedure] ,          
              [DateTime] ,          
              Status ,          
              Staff,          
            PrimaryClinician          
            )          
            SELECT  a.clientId AS 'ClientId' ,          
                    b.LastName + ', ' + b.FirstName AS 'ClientName' ,          
                    d.displayAs AS 'Procedure' ,          
                    --CONVERT(varchar,a.DateOfService,108) AS 'DateTime' ,         
                    replace(REPLACE(right('0'+ltrim(right(CONVERT(varchar,a.DateOfService,100),7)),7),'AM',' AM'),'PM',' PM') As 'DateTime',      
                    SUBSTRING(e.CodeName, 1, 20) ,          
                    c.firstName + ' ' + c.lastName AS 'Staff',          
                    pc.firstName + ' ' + pc.lastName AS 'PrimaryClinician'          
            FROM    services a          
                    JOIN clients b ON b.clientId = a.clientId          
                    JOIN staff c ON a.clinicianId = c.staffId          
                    JOIN procedureCodes d ON a.procedureCodeId = d.procedureCodeId          
                    JOIN globalCodes e ON e.globalCodeId = a.[status]          
                    JOIN @serviceStatuses h ON a.[status] = h.[status]         
                    LEFT JOIN staff pc on b.PrimaryClinicianID = pc.staffID          
            WHERE   DATEDIFF(day, a.DateOfService, @SelectedDate) = 0       
            and (a.ClinicianId=@ClinicianId or @ClinicianId=-1)      
            and (@AppointmentTypes=5401 or  @AppointmentTypes=5402)      
                   AND EXISTS --Work through the receptionViews          
 ( SELECT  *          
        FROM    ReceptionViews rv          
                LEFT JOIN ReceptionViewLocations rvl ON rv.ReceptionViewId = rvl.ReceptionViewId          
                LEFT JOIN ReceptionViewPrograms rvp ON rv.ReceptionViewId = rvp.ReceptionViewId          
                LEFT JOIN ReceptionViewStaff rvs ON rv.ReceptionViewId = rvs.ReceptionViewId          
        WHERE   rv.ReceptionViewId = @ReceptionViewId          
                AND ( rv.AllLocations = 'Y'          
                      OR a.LocationId = rvl.LocationId          
                    )          
                AND ( rv.AllPrograms = 'Y'          
                      OR a.ProgramId = rvp.ProgramId          
                    )          
                AND ( rv.AllStaff = 'Y'          
                      OR a.clinicianId = rvs.StaffId          
                    ) )          
                    AND ISNULL(a.RecordDeleted, 'N') = 'N'          
                    AND ISNULL(b.RecordDeleted, 'N') = 'N'          
                    AND ISNULL(c.RecordDeleted, 'N') = 'N'          
                    AND ISNULL(d.RecordDeleted, 'N') = 'N'          
                    AND ISNULL(e.RecordDeleted, 'N') = 'N'          
         
   end      
     --Added by Rachna Singh to show PrimaryCare Appoinments  w.r.t #165 in 'Primary Care Bugs/Features'       
      if(@AppointmentTypes=5401 or @AppointmentTypes=5403)      
        begin                   
  CREATE TABLE #AppointmentStatusFilters (                    
 Status       INT         NULL)        
                   
 IF @Status = 0  --All Statuses                    
   INSERT INTO #AppointmentStatusFilters (Status)                    
   SELECT GlobalCodeId                    
  FROM GlobalCodes                    
    WHERE Category = 'PCAPPOINTMENTSTATUS'                    
   AND Active = 'Y'                    
   AND ISNULL(RecordDeleted, 'N') = 'N' and GlobalCodeId not in (8044,8045)      
 ELSE                    
   INSERT INTO #AppointmentStatusFilters (Status)          
   SELECT 8036 WHERE @Status In(6851,6852)      -- Scheduled                    
   UNION                    
   SELECT 8037 WHERE @Status In (6852,6855)      -- Scheduled      
   UNION                    
   SELECT 8038 WHERE @Status In (6852,6855)      -- Scheduled            
   UNION                    
   SELECT 8039 WHERE @Status In (6852,6855)     -- Scheduled        
   UNION                    
   SELECT 8040 WHERE @Status In (6852,6855)      -- Scheduled      
   UNION                    
   SELECT 8041 WHERE @Status In (6852,6855)      -- Scheduled      
   UNION                    
   SELECT 8042 WHERE @Status = 6853   -- Cancel                  
   UNION                    
   SELECT 8043 WHERE @Status = 6853   -- No Show       
       INSERT  INTO #Results          
            ( ClientId ,          
              ClientName ,          
              [Procedure] ,          
              [DateTime] ,          
              Status ,          
              Staff,          
              PrimaryClinician          
            )          
   Select       
       
    c.clientId AS 'ClientId' ,          
    c.LastName + ', ' + c.FirstName as 'ClientName' ,       
    gat.CodeName AS 'Procedure' ,      
    replace(REPLACE(right('0'+ltrim(right(CONVERT(varchar,a.StartTime,100),7)),7),'AM',' AM'),'PM',' PM') As 'DateTime',      
             gcs.CodeName as [Status],      
    st.FirstName + ', ' + st.LastName AS 'Staff',      
    pc.firstName + ' ' + pc.lastName AS 'PrimaryClinician'       
         
   From Appointments a      
   JOIN Clients c ON c.ClientId = a.ClientId      
     --JOIN StaffClients sc ON sc.ClientId = c.ClientId       
     LEFT JOIN Staff st ON st.StaffId = a.StaffId          
     LEFT JOIN staff pc on c.PrimaryClinicianID = pc.staffID      
     LEFT JOIN GlobalCodes gcs ON gcs.GlobalCodeId = a.Status and gcs.Category='PCAPPOINTMENTSTATUS'      
     LEFT JOIN GlobalCodes gat ON gat.GlobalCodeId = a.AppointmentType                    
     LEFT JOIN Locations l ON l.LocationId = a.LocationId        
     Join #AppointmentStatusFilters ASF on a.Status=ASF.Status          
     WHERE ISNULL(a.RecordDeleted,'N')='N'  and ISNULL(c.RecordDeleted,'N')='N'      
       and a.ServiceId is null      
    and a.StartTime >= @SelectedDate                    
    AND a.StartTime < DATEADD(dd, 1, @SelectedDate)          
    and @AppointmentTypes=5403       
 end        
  --Till here          
          
    UPDATE  a          
    SET     PrimaryCoverage = cp1.CoveragePlanName          
    FROM    #Results a          
            JOIN ClientCoveragePlans ccp1 ON a.clientId = ccp1.clientId          
            JOIN ClientCoverageHistory ch1 ON ccp1.clientCoveragePlanId = ch1.ClientCoveragePlanId          
            JOIN CoveragePlans cp1 ON cp1.coveragePlanId = ccp1.CoveragePlanId          
    WHERE   ch1.COBOrder = 1          
            AND ch1.StartDate <= a.[DateTime]          
            AND ( ch1.EndDate >= a.[DateTime]          
                  OR ch1.EndDate IS NULL          
                )          
          
    UPDATE  a          
    SET     SecondaryCoverage = cp1.CoveragePlanName          
    FROM    #Results a          
            JOIN ClientCoveragePlans ccp1 ON a.clientId = ccp1.clientId          
            JOIN ClientCoverageHistory ch1 ON ccp1.clientCoveragePlanId = ch1.ClientCoveragePlanId          
            JOIN CoveragePlans cp1 ON cp1.coveragePlanId = ccp1.CoveragePlanId          
    WHERE   ch1.COBOrder = 2          
            AND ch1.StartDate <= a.[DateTime]          
            AND ( ch1.EndDate >= a.[DateTime]          
                  OR ch1.EndDate IS NULL          
                )          
 UPDATE a          
 SET  TertiaryCoverage = cp1.CoveragePlanName          
 FROM #Results a          
   JOIN ClientCoveragePlans ccp1 ON a.clientId = ccp1.clientId          
   JOIN ClientCoverageHistory ch1 ON ccp1.ClientCoveragePlanId = ch1.ClientCoveragePlanId          
   JOIN CoveragePlans cp1 ON cp1.coveragePlanId = ccp1.CoveragePlanId          
 WHERE ch1.COBOrder = 3          
   AND ch1.StartDate <= a.[DateTime]          
   AND ( ch1.EndDate >= a.[DateTime]          
      OR ch1.EndDate IS NULL          
    )          
          
--Check for MedVenture coverage IP or OP.  If both exist, get the ID from the OP coverage          
    UPDATE  a          
    SET     MedicaidId = ccp1.InsuredId          
    FROM    #Results a          
            JOIN ClientCoveragePlans ccp1 ON a.clientId = ccp1.clientId          
            JOIN ClientCoverageHistory ch1 ON ccp1.clientCoveragePlanId = ch1.ClientCoveragePlanId          
            JOIN CoveragePlans cp1 ON cp1.coveragePlanId = ccp1.CoveragePlanId          
    WHERE   ch1.StartDate <= a.[DateTime]          
            AND ( ch1.EndDate >= a.[DateTime]          
                  OR ch1.EndDate IS NULL          
                )          
            AND cp1.MedicaidPlan = 'Y'          
            AND NOT EXISTS ( SELECT *          
                             FROM   clientCoveragePlans ccp2          
                                    JOIN coveragePlans cp2 ON ccp2.coveragePlanId = cp2.CoveragePlanId          
                             WHERE  ccp2.ClientCoveragePlanId = ccp1.ClientCoveragePlanId          
                                    AND cp2.CoveragePlanId > cp1.CoveragePlanId )          
          
-- Duplicate of functionality in final SELECT.            
/*          
    UPDATE  a          
    SET     a.OrganizationName = sc.OrganizationName          
    FROM    #Results a          
            CROSS JOIN SystemConfigurations sc          
*/          
    SELECT  a.ClientId ,          
            a.ClientName ,          
            replace(REPLACE(right('0'+ltrim(right(CONVERT(varchar,a.[DateTime],100),7)),7),'AM',' AM'),'PM',' PM') as [DateTime],          
            a.MedicaidId ,          
            a.PrimaryCoverage ,          
            a.[Procedure] ,          
           a.SecondaryCoverage ,          
            a.Staff ,          
            a.[Status] ,          
            sc.OrganizationName,          
            a.TertiaryCoverage,          
            a.PrimaryClinician          
    FROM    dbo.SystemConfigurations sc          
            LEFT JOIN #results a ON 1 = 1          
    ORDER BY [DateTime] ,          
            ClientName ,          
            Staff         
                  
                   
          
          