  /****** Object:  StoredProcedure [dbo].[ssp_PMReception]    Script Date: 04/16/2011 06:58:04 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[ssp_PMAppointmentSearchInitData]') AND TYPE IN (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_PMAppointmentSearchInitData]
GO

/****** Object:  StoredProcedure [dbo].[ssp_PMAppointmentSearchInitData]    Script Date: 04/16/2011 06:58:04 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ssp_PMAppointmentSearchInitData]  
/********************************************************************************                                                    
-- Stored Procedure: ssp_PMAppointmentSearchInitData  81300 
--  
-- Copyright: Streamline Healthcate Solutions  
--  
-- Purpose: Get data to be used to fill the plan dropdown in the list page  
--  
-- Author:  Sunil.D
-- Date:    07/08/2017
--  
-- *****History****  
--  07/08/2017   Sunil.D    What:Moved From 3.5X to 4.0X 
							Why: Harbor-Enhancements  #1335 Require to change the logic to get data to plan dropdown in appointment search.
--  07/08/2017   Sunil.D    What:Created 2 temp table and from temp tables we are selecting coverage plans for plan dropdown, Added error handling syntax.
							Why: Harbor-Enhancements  #1335 Require to change the logic to get data to plan dropdown in appointment search.
*********************************************************************************/  
  
(  
 @ClientID INT                 
)                  
AS  
  
BEGIN
begin try   
CREATE TABLE #ClientCoveragePlan(  
     CoveragePlanId int,  
     PlanName varchar(max),  
     COBOrder int  
     )  
CREATE TABLE #AllCoveragePlans(  
     CoveragePlanId int,  
     PlanName varchar(max),  
     COBOrder int  
     )   
  INSERT INTO #ClientCoveragePlan  
  SELECT DISTINCT CP.CoveragePlanId,     
  CP.DisplayAs AS PlanName,    
  MIN(CCH.COBOrder)                 
    FROM ClientCoveragePlans CCP                            
    INNER JOIN ClientCoverageHistory CCH ON CCH.ClientCoveragePlanId = CCP.ClientCoveragePlanId                             
    INNER JOIN CoveragePlans CP ON CP.CoveragePlanId = CCP.CoveragePlanId                               
    WHERE ( CCP.ClientId = @ClientID)    
    AND ISNULL(CCP.RecordDeleted,'N') = 'N'     
    AND ISNULL(CCH.RecordDeleted,'N') = 'N'     
    AND ISNULL(CP.RecordDeleted,'N') = 'N'     
    AND ((GETDATE()>= CCH.StartDate and GETDATE() <= isnull(DATEADD(Day,1,CCH.EndDate),'01/01/2070')))        
    GROUP BY CP.CoveragePlanId, CP.DisplayAs    
    ORDER BY MIN(CCH.COBOrder),PlanName ASC  
    
	INSERT INTO #AllCoveragePlans   
    SELECT  CP.CoveragePlanId,  
   CP.DisplayAs AS PlanName,  
   NULL  
   FROM CoveragePlans CP    
    WHERE  ISNULL(CP.RecordDeleted,'N') = 'N'     
    AND Active='Y'  
	AND  CP.CoveragePlanId NOT IN(select CoveragePlanId from #ClientCoveragePlan )  
	order by  PlanName      
            
     if exists(SELECT 1 FROM #ClientCoveragePlan)  
   begin  
    SELECT * FROM #ClientCoveragePlan 
    union all select 0,'--------------------------------------',0  
    union all  
    SELECT * FROM #AllCoveragePlans    
   end  
     else  
   begin  
    SELECT * FROM #AllCoveragePlans  
   end  
 RETURN    
     
END TRY                                                                
                                                                                                           
BEGIN CATCH                      
DECLARE @Error varchar(8000)                                                                   
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                                 
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_PMAppointmentSearchInitData')                                                                                                 
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

