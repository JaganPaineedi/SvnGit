/****** Object:  StoredProcedure [dbo].[ssp_PMGetClientPlansAndTimeSpans]    Script Date: 02/23/2016 17:51:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[ssp_PMGetClientPlansAndTimeSpans]  
/********************************************************************************                                                    
-- Stored Procedure: [ssp_PMGetClientPlansAndTimeSpans]  
--  
-- Copyright: Streamline Healthcare Solutions  
--  
-- Purpose: Procedure to return data for the Client Spans list page.  
--  
-- Author:  Girish Sanaba  
-- Date:    Aug 05 2011  
--  
-- *****History****  
--08.30.2011  Girish  Removed parameters and caching logic; added CurrentFlag to history resultset  
--28.09.2011  Girish  Added resultset for serviceareas dropdown  
--14.10.2011  Girish  Changed resultset for serviceareas dropdown AND client coverage history resultset  
--11/8/2011   Kneale  Updated the hard coded ClientID to use @ClientID  
--11/18/2011  Suma  Modified Order by to GroupNumber  
--11/18/2011  MSuma  Modified Order by on COB Order  
--05/18/2012        Shruthi.S   Included ClientCoveragePlans.InsuredId  
--2/27/2013 JHB	Added Insured Id to Address Display field  
--12/17/2013  Akwinass Included Conditions to get address display based on Override Claim.
--10/16/2014 Md Hussain Khusro Moved the Record Deleted to ON Clause from Where condition w.r.t Core Bugs #1646
--05/27/2015  NJain		Updated the Service Area drop-down selection (at the end) to limit to those present in ClientCoverageHistory, Philhaven Development #288
--02/23/2015  NJain		Updated Service Area logic to get from ClientCoverageHistory
*********************************************************************************/  
                     
 /* Param List */ @ClientID INT
AS
    BEGIN  
                                                    
        BEGIN TRY                
  
   --Client Plans                
            SELECT  CP.CoveragePlanId ,
                    CCP.ClientCoveragePlanId ,
                    CP.DisplayAs AS PlanName ,
                    CCP.InsuredId AS Insured ,
                    dbo.GetCoPay(CCP.ClientCoveragePlanId) AS CoPay
            FROM    ClientCoveragePlans CCP
                    INNER JOIN CoveragePlans CP ON CP.CoveragePlanId = CCP.CoveragePlanId 
                    --16/10/2014 - Moved the RecordDeleted condition to ON Clause from Where condition by Khusro 
                    LEFT JOIN ClientContacts CC ON CC.ClientContactId = CCP.SubscriberContactId
                                                   AND ISNULL(CC.RecordDeleted, 'N') = 'N'
                    LEFT JOIN GlobalCodes GC ON GC.GlobalCodeId = CC.Relationship
                                                AND ISNULL(GC.RecordDeleted, 'N') = 'N'
            WHERE   CCP.ClientId = @ClientId
                    AND ISNULL(CP.RecordDeleted, 'N') = 'N'
                    AND ISNULL(CCP.RecordDeleted, 'N') = 'N'
            ORDER BY PlanName      
  
  --Client Coverage History  
            SELECT  RANK() OVER ( ORDER BY CCH.StartDate, CCH.EndDate, ServiceAreaId ) AS GroupNumber ,
                    CASE WHEN CAST(CONVERT(VARCHAR(10), CCH.StartDate, 101) AS DATETIME) <= CAST(CONVERT(VARCHAR(10), GETDATE(), 101) AS DATETIME)
                              AND CAST(ISNULL(CONVERT(VARCHAR(10), EndDate, 101), '01/01/2070') AS DATETIME) >= CAST(CONVERT(VARCHAR(10), GETDATE(), 101) AS DATETIME) THEN 'C'
                         ELSE 'P'
                    END AS CurrentFlag ,
                    CCH.ClientCoverageHistoryId ,
                    CP.DisplayAs AS PlanName ,  
                    --12/17/2013 - Akwinass - Included Conditions to get address display based on Override Claim.
                    ISNULL(CCP.InsuredId + '-', '') + CASE WHEN ISNULL(CCP.OverrideClaim, 'N') = 'N' THEN ISNULL(CP.AddressDisplay, '')
                                                           ELSE ISNULL(CCP.AddressDisplay, '')
                                                      END AddressDisplay ,
                    CCH.StartDate ,
                    CCH.EndDate ,
                    CCH.COBOrder ,
                    ISNULL(CCH.ServiceAreaId, -2) AS ServiceAreaId ,
                    CONVERT(VARCHAR, CCH.StartDate, 101) AS StartDateFormat ,
                    ISNULL(CONVERT(VARCHAR, CCH.EndDate, 101), 'No End Date') AS EndDateFormat
            FROM    ClientCoveragePlans CCP
                    INNER JOIN ClientCoverageHistory CCH ON CCH.ClientCoveragePlanId = CCP.ClientCoveragePlanId
                    INNER JOIN CoveragePlans CP ON CP.CoveragePlanId = CCP.CoveragePlanId
            WHERE   CCP.ClientId = @ClientID
                    AND ISNULL(CCP.RecordDeleted, 'N') = 'N'
                    AND ISNULL(CCH.RecordDeleted, 'N') = 'N'
                    AND ISNULL(CP.RecordDeleted, 'N') = 'N'
            ORDER BY GroupNumber DESC ,
                    ServiceAreaId DESC ,
                    CCH.COBOrder ASC ,
                    PlanName   
                        
    
    
            SELECT DISTINCT
                    CPS.CoveragePlanId ,
                    SA.ServiceAreaId ,
                    SA.ServiceAreaName
            FROM    CoveragePlanServiceAreas CPS
                    INNER JOIN ServiceAreas SA ON SA.ServiceAreaId = CPS.ServiceAreaId
                    LEFT JOIN ClientCoveragePlans CCP ON CPS.CoveragePlanId = CCP.CoveragePlanId
                                                         AND ISNULL(CCP.RecordDeleted, 'N') = 'N'
            WHERE   CCP.ClientId = @ClientId
                    AND ISNULL(SA.RecordDeleted, 'N') = 'N'
                    AND ISNULL(CPS.RecordDeleted, 'N') = 'N'
            ORDER BY SA.ServiceAreaName
            
            --
            ;   
            WITH    ServiceAreaList ( ServiceAreaId, ServiceAreaName )
                      AS ( SELECT   SA.ServiceAreaId ,
                                    SA.ServiceAreaName
                           FROM     ClientCoveragePlans CCP
                                    JOIN dbo.ClientCoverageHistory cch ON cch.ClientCoveragePlanId = CCP.ClientCoveragePlanId
                                                                          AND ISNULL(cch.RecordDeleted, 'N') = 'N'
                                    JOIN ServiceAreas SA ON SA.ServiceAreaId = cch.ServiceAreaId
                                                            AND ISNULL(SA.RecordDeleted, 'N') = 'N'
                           WHERE    CCP.ClientId = @ClientID
                                    AND ISNULL(CCP.RecordDeleted, 'N') = 'N'
                         )
                SELECT DISTINCT
                        ServiceAreaId ,
                        serviceareaname
                FROM    ServiceAreaList
                ORDER BY ServiceAreaName  
  
        END TRY  
  
                
        BEGIN CATCH  
            DECLARE @Error VARCHAR(8000)         
            SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_PMGetClientPlansAndTimeSpans') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())  
            RAISERROR  
  (  
   @Error, -- Message text.  
   16,  -- Severity.  
   1  -- State.  
  );  
        END CATCH  
    END  

GO
