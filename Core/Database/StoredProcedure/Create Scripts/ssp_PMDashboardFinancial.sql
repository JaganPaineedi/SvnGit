
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_PMDashboardFinancial]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_PMDashboardFinancial] 
GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


create procedure [dbo].[ssp_PMDashboardFinancial]  
(  
 @StaffId INT  
)      
AS  
BEGIN                                                                
 BEGIN TRY     
      
/******************************************************************************      
**  File: dbo.ssp_PMDashboardFinancial.prc      
**  Name: dbo.ssp_PMDashboardFinancial      
**  Desc: This SP returns the data required by dashboard  for Incomplete Financial Activities    
**      
**  Auth: Mary Suma     
**  Date:  17/08/2011      
*******************************************************************************      
**  Change History      
*******************************************************************************      
**  Date:     Author:     Description:      
**  --------  --------    -------------------------------------------      
 17.08.11  msuma			Created New SP for Dashboard (Incomplete Financial Activities)  
 23.08.11  msuma			Removed the condition for AllStaff  
 15.12.11  msuma		    Moved the  filer on staffClients as Join
 08.06.12  msuma		    Added Distinct on Count 
 23.06.12  MSuma			Added JOIn on servicearea to coverage plans as in Plan List Page
 29.06.12  MSuma			Changed to Local Variable
 08.29.13  SFarber          Changed logic for ClientMonthlyDeductibleCount
 16.09.16  Himmat          Changed logic for  Harbor Support#1022
*******************************************************************************/      
      
--INCOMPLETE FININCIAL RECORDS    
  DECLARE	@local_StaffId INT
  SET		@local_StaffId = @StaffId
      
 SELECT  
 (--( > 1 visit Clients)      
  SELECT count(DISTINCT C.ClientId)      
    FROM Clients c  
   LEFT JOIN ClientEpisodes ce on ce.ClientId=c.ClientId AND c.CurrentEpisodeNumber = ce.episodenumber  AND isnull(ce.RecordDeleted, 'N') = 'N'
       --Moved this to join
   join StaffClients sc on sc.StaffId = @local_StaffId and sc.ClientId = c.ClientId
   WHERE EXISTS (SELECT ServiceId      
       FROM Services s      
       WHERE s.ClientId = c.ClientId      
       AND s.Status in (71, 75) -- Show/Complete       
       AND isnull(s.RecordDeleted, 'N') = 'N')      
     AND isnull(c.RecordDeleted, 'N') = 'N'      
     AND isNull(c.InformationComplete, 'N') = 'N'      
    AND isnull(c.active,'n')='Y'  
  -- AND ce.Status<>102  
    AND CE.STATUS IN ( 100, 101 )
 ) AS ClientsCount,      
 (--Plans      
  SELECT count(DISTINCT cp.CoveragePlanId)      
    FROM CoveragePlans cp  
    --Added by MSuma to match count with PlanList page   
    LEFT JOIN CoveragePlanServiceAreas CPSA ON CP.CoveragePlanId = CPSA.CoveragePlanId  
    LEFT JOIN ServiceAreas SA ON SA.ServiceAreaId = CPSA.ServiceAreaId 
    
   WHERE isnull(cp.InformationComplete, 'N') = 'N'      
  AND isnull(cp.RecordDeleted, 'N') = 'N'       
  AND cp.Active = 'Y'   
  
  AND ISNULL(SA.RecordDeleted,'N')= 'N'   
   AND ISNULL(CPSA.RecordDeleted,'N')= 'N'  
       
 ) AS PlansCount   ,   
  (--ClientMonthlyDeductibleCount      
  select count(*) AS 'ClientMonthlyDeductibleCount'  
    from Clients c  
         join StaffClients sc on sc.StaffId = @local_StaffId and sc.ClientId = c.ClientId
   where isnull(c.RecordDeleted, 'N') = 'N' 
     and ((c.Active = 'Y' and 
           exists(select *
                    from ClientEpisodes ce    
                   where ce.ClientId = c.ClientId   
                     and ce.Status in (100, 101) -- Registered, In Treatment
                     and ce.EpisodeNumber = c.CurrentEpisodeNumber  
                     and isnull(ce.RecordDeleted, 'N') = 'N')) or
          exists(select *
                   from ClientEpisodes ce    
                  where ce.ClientId = c.ClientId   
                    and ce.Status = 102 -- Discharged 
                    and convert(char(6), ce.DischargeDate, 112) = convert(char(6), dateadd(mm, -1, getdate()), 112)  
                    and isnull(ce.RecordDeleted, 'N') = 'N') or
          exists(select *
                  from Services s
                 where s.ClientId = c.ClientId
                   and s.Billable = 'Y'
                   and s.Status in (70, 71, 75)
                   and convert(char(6), s.DateOfService, 112) = convert(char(6), dateadd(mm, -1, getdate()), 112)  
                   and isnull(s.RecordDeleted, 'N') = 'N'))
     and exists(select *
                  from ClientCoveragePlans cp  
                       join ClientCoverageHistory cch on cch.ClientCoveragePlanId = cp.ClientCoveragePlanId  
                 where cp.ClientId = c.ClientId  
                   and convert(char(6), cch.StartDate, 112) <= convert(char(6), dateadd(mm, -1, getdate()), 112)  
                   and (convert(char(6), cch.EndDate, 112) >= convert(char(6), dateadd(mm, -1, getdate()), 112) or cch.EndDate is null)  
                   and isnull(cch.RecordDeleted, 'N') = 'N'   
                   and isnull(cp.RecordDeleted, 'N') = 'N'  
                   and exists (select * 
                                 from ClientMonthlyDeductibles cmd 
                                where cmd.ClientCoveragePlanId = cp.ClientCoveragePlanId
                                  and cmd.DeductibleYear = year(dateadd(mm, -1, getdate())) 
                                  and cmd.DeductibleMonth = month(dateadd(mm, -1, getdate()))
                                  and (cmd.DeductibleMet = 'U' or (cmd.DeductibleMet = 'Y' and cmd.DateMet is null))
                                  and isnull(cmd.RecordDeleted,'N') = 'N'))
  
) AS ClientMonthlyDeductibleCount   
  
  
  
END TRY  
   
 BEGIN CATCH  
  DECLARE @Error VARCHAR(8000)         
  SET @Error= CONVERT(VARCHAR,ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000),ERROR_MESSAGE())                                                                                              
   + '*****' + ISNULL(CONVERT(VARCHAR,ERROR_PROCEDURE()),'ssp_PMDashboardFinancial')                                                                                               
   + '*****' + CONVERT(VARCHAR,ERROR_LINE()) + '*****' + CONVERT(VARCHAR,ERROR_SEVERITY())                                                                                                
   + '*****' + CONVERT(VARCHAR,ERROR_STATE())  
  RAISERROR  
  (  
   @Error, -- Message text.  
   16,  -- Severity.  
   1  -- State.  
  );  
 END CATCH  
END  
  

GO


