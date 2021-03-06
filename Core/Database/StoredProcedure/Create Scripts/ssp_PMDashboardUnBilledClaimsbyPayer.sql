/****** Object:  StoredProcedure [dbo].[ssp_PMDashboardUnBilledClaimsbyPayer]    Script Date: 11/18/2011 16:25:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_PMDashboardUnBilledClaimsbyPayer]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_PMDashboardUnBilledClaimsbyPayer]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[ssp_PMDashboardUnBilledClaimsbyPayer] -- 550
(  
 @StaffId INT  
)      
AS  
BEGIN                                                                
 BEGIN TRY     
      
/******************************************************************************      
**  File: dbo.ssp_PMDashboardUnBilledClaimsbyPayer.prc      
**  Name: dbo.ssp_PMDashboardUnBilledClaimsbyPayer      
**  Desc: This SP returns the data required by dashboard  for Incomplete Financial Activities    
**      
**  This template can be customized:      
**                    
**  Return values:      
**       
**  Called by:         
**                    
**  Parameters:      
**  Input       Output      
**     ----------       -----------      
**      
**  Auth: Veena     
**  Date:   09-06-2015   
*******************************************************************************      
**  Change History      
*******************************************************************************      
**  Date:     Author:     Description:      
**  --------  --------    -------------------------------------------      
*******************************************************************************/        
  DECLARE @local_StaffId INT
                
  SET @local_StaffId = @StaffId
                
--UNBILLED CLAIMS---  
         
  SELECT '1' as SortOrder,      
         p.PayerId as PayerId,   
     p.PayerName as PayerName,          
      '$'+ISNULL(CONVERT(VARCHAR,sum(oc.Balance),1),'0.00') AS Amount    --'1' Added by Gayathri for currency  
    FROM OpenCharges oc   
      JOIN Charges c on c.ChargeId = oc.ChargeId      
      JOIN ClientCoveragePlans ccp on  ccp.ClientCoveragePlanId = c.ClientCoveragePlanId   AND ISNULL(ccp.RecordDeleted,'N')='N'    
      JOIN CoveragePlans cp on  cp.CoveragePlanId = ccp.CoveragePlanId AND ISNULL(cp.RecordDeleted,'N')='N'      
      JOIN Payers p on  p.PayerId = cp.PayerId     AND ISNULL(p.RecordDeleted,'N')='N'    
       join Services s on s.ServiceId = c.ServiceId   AND ISNULL(S.RecordDeleted,'N')='N'  
      join Clients c1 on c1.ClientId = s.ClientId		AND ISNULL(c1.RecordDeleted,'N')='N' 
      join ProcedureCodes pc ON pc.ProcedureCodeId = s.ProcedureCodeId    AND ISNULL(PC.RecordDeleted,'N')='N' 
		--Moved this to join
		join StaffClients sc on sc.StaffId = @local_StaffId and sc.ClientId = ccp.ClientId 
		      LEFT JOIN GlobalCodes gc on gc.GlobalCodeId = p.PayerType  AND ISNULL(gc.RecordDeleted,'N')='N' 
 
   WHERE c.LastBilledDate is null  
    AND ISNULL(cp.Capitated, 'N') = 'N'  
	and isnull(c.DoNotBill,'N') <> 'Y'
  GROUP by p.PayerId, p.PayerName       
  UNION      
  SELECT '3',      
      -1,      
      'Total',       
      '$'+ISNULL(CONVERT(VARCHAR,SUM(oc.Balance),1),'0.00') AS Amount     --'1' Added by Gayathri for currency   
    FROM OpenCharges oc      
      JOIN Charges c on c.ChargeId = oc.ChargeId     
      --join Services s on s.ServiceId = ch.ServiceId     
      JOIN ClientCoveragePlans ccp on  ccp.ClientCoveragePlanId = c.ClientCoveragePlanId AND ISNULL(ccp.RecordDeleted,'N')='N'      
      JOIN CoveragePlans cp on  cp.CoveragePlanId = ccp.CoveragePlanId AND ISNULL(cp.RecordDeleted,'N')='N'      
      JOIN Payers p on  p.PayerId = cp.PayerId  AND ISNULL(p.RecordDeleted,'N')='N'      
         join Services s on s.ServiceId = c.ServiceId   AND ISNULL(S.RecordDeleted,'N')='N'  
      join Clients c1 on c1.ClientId = s.ClientId		AND ISNULL(c1.RecordDeleted,'N')='N' 
      join ProcedureCodes pc ON pc.ProcedureCodeId = s.ProcedureCodeId    AND ISNULL(PC.RecordDeleted,'N')='N' 
		--Moved this to join
		join StaffClients sc on sc.StaffId = @local_StaffId and sc.ClientId = ccp.ClientId  
   WHERE c.LastBilledDate is null 
   AND ISNULL(cp.Capitated, 'N') = 'N'  
	and isnull(c.DoNotBill,'N') <> 'Y'
   ORDER BY 1, 3      
   
  
END TRY  
   
 BEGIN CATCH  
  DECLARE @Error VARCHAR(8000)         
  SET @Error= CONVERT(VARCHAR,ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000),ERROR_MESSAGE())                                                                                              
   + '*****' + ISNULL(CONVERT(VARCHAR,ERROR_PROCEDURE()),'ssp_PMDashboardUnBilledClaimsbyPayer')                                                                                               
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
