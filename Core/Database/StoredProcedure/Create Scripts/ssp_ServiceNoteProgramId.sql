/****** Object:  StoredProcedure [dbo].[ssp_ServiceNoteProgramId]    Script Date: 02/12/2016 13:30:11 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_ServiceNoteProgramId]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_ServiceNoteProgramId]
GO


/****** Object:  StoredProcedure [dbo].[ssp_ServiceNoteProgramId]    Script Date: 02/12/2016 13:30:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

    
CREATE PROCEDURE [dbo].[ssp_ServiceNoteProgramId]      
 @ClientId int,      
 @DateOfService datetime,      
 @ProgramId int,      
 @AttendingId int,      
 @ProcedureCodeId int,      
 @LocationId int,      
 @PlaceOfServiceId int,      
 @ClinicianId int  
/********************************************************************************                                                              
-- Stored Procedure: dbo.ssp_ServiceNoteProgramId                                                                
--                                                              
-- Copyright: Streamline Healthcate Solutions                                                              
--                                                              
-- Purpose: To get Programs based to ClientPrograms and StaffPrograms  to bind on service screens                                                              
--                                                              
-- Updates:                                                                                                                     
-- Date			Author				Purpose                           
-- 02/12/2016	Chethan N			Converted to Core      
-- 02/23/2017   jcarlson		    Keystone Customizations 55 - Added logic to handle effective dates being added to programprocedure table         
-- 02/12/2016	Chethan N			What : Including No Episode program when the client doesn't have an episode
--									Why : Core Bugs task #2393   
-- 10/16/2017	Chethan N			What : Assigning '-1' as default Value
--									Why : Boundless-Environment Issues Tracking task #1
*********************************************************************************/  
       
AS      
BEGIN      
IF @DateofService IS NULL 
  SET @DateOfService = Getdate()     
      
IF @ProcedureCodeId = 0  
 SET @ProcedureCodeId = -1   

DECLARE @Results TABLE 
  ( 
     attendingid       INT, 
     attendingname     VARCHAR(1), 
     programid         INT, 
     programname       VARCHAR(250), 
     locationid        INT, 
     locationname      VARCHAR(1), 
     procedurecodeid   INT, 
     procedurecodename VARCHAR(1), 
     clinicianid       INT, 
     clinicianname     VARCHAR(1) 
  ) 

-- Get team list       
INSERT INTO @Results 
            (attendingid, 
             attendingname, 
             programid, 
             programname, 
             locationid, 
             locationname, 
             procedurecodeid, 
             procedurecodename, 
             clinicianid, 
             clinicianname) 
SELECT DISTINCT -1, 
                '', 
                p.programid, 
                p.programname, 
                -1, 
                '', 
                -1, 
                '', 
                -1, 
                '' 
FROM   clientprograms cp 
       LEFT JOIN programs p 
              ON p.programid = cp.programid 
                 AND Isnull(p.recorddeleted, 'N') = 'N' 
WHERE  cp.clientid = @ClientId 
       AND p.active = 'Y' 
       AND ( CONVERT(DATE, cp.requesteddate, 101) <= 
             CONVERT(DATE, @DateOfService, 101) 
              OR ( cp.requesteddate IS NULL 
                   AND CONVERT(DATE, cp.enrolleddate, 101) <= 
                       CONVERT(DATE, @DateOfService, 101) ) ) 
       AND ( cp.dischargeddate IS NULL 
              OR CONVERT(DATE, cp.dischargeddate, 101) >= 
                 CONVERT(DATE, @DateOfService, 101) ) 
       AND Isnull(cp.recorddeleted, 'N') = 'N' 
       AND EXISTS (SELECT * 
                   FROM   staffprograms sp 
                   WHERE  sp.programid = p.programid 
                          AND sp.staffid = @ClinicianId 
                          AND Isnull(sp.recorddeleted, 'N') = 'N') 
       ---- if a procedure has been selected, only look at programs that are effective for the procedure code on DOS or today if DOS is null
       AND ( ( EXISTS(SELECT 1 
                            FROM   programprocedures pp 
                            WHERE  pp.programid = p.programid 
                                   AND Isnull(pp.recorddeleted, 'N') = 'N' 
                                   AND pp.procedurecodeid = @ProcedureCodeId 
                                   AND ( ( pp.startdate IS NULL 
                                            OR CONVERT(DATE, pp.startdate) <= 
                                               CONVERT(DATE, Isnull( 
                                               @DateOfService, 
                                                             Getdate())) ) 
                                         AND ( pp.enddate IS NULL 
                                                OR CONVERT(DATE, pp.enddate) >= 
                                                   CONVERT(DATE, Isnull( 
                                                   @DateOfService 
                                                                 , 
                                                                 Getdate( 
                                                                 ))) ) )) 
                      OR EXISTS (SELECT 1 
                                 FROM   procedurecodes AS pc 
                                 WHERE  pc.procedurecodeid = @ProcedureCodeId 
                                        AND pc.allowallprograms = 'Y') )
              --no procedure selected, then all programs can be displayed 
              OR Isnull(@ProcedureCodeId, -1) = -1 ) 
UNION  
SELECT -1 AS AttendingId, 
       '' AS AttendingName, 
       P.programid, 
       P.programname, 
       -1 AS LocationId, 
       '' AS LocationName, 
       -1 AS ProcedureCodeId, 
       '' AS ProcedureCodeName, 
       -1 AS ClinicianId, 
       '' AS ClinicianName 
FROM   programs p 
       JOIN globalcodes gc 
         ON gc.globalcodeid = p.programtype 
            AND gc.category = 'PROGRAMTYPE' 
            AND gc.code = 'NO EPISODE' 
WHERE  p.active = 'Y' 
       AND Isnull(P.recorddeleted, 'N') <> 'Y' 
       AND P.programid <> @ProgramId 
       AND NOT EXISTS (SELECT * 
                       FROM   clientepisodes ce 
                       WHERE  ce.clientid = @ClientId 
                              AND ce.registrationdate <= @DateOfService 
                              AND ( ce.dischargedate >= Cast( 
                                    @DateOfService AS DATE) 
                                     OR ce.dischargedate IS NULL ) 
                              AND Isnull(ce.recorddeleted, 'N') = 'N') 

SELECT attendingid, 
       attendingname, 
       programid, 
       programname, 
       locationid, 
       locationname, 
       procedurecodeid, 
       procedurecodename, 
       clinicianid, 
       clinicianname 
FROM   @Results       
       
END 
GO


