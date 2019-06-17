 /****** Object:  StoredProcedure [dbo].[ssp_PMDashboardUnpostedPaymentbyPayerNew]    Script Date: 2/3/2016 10:09:03 AM ******/
 IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_PMDashboardUnpostedPaymentbyPayer]') AND type IN (N'P', N'PC'))
  DROP PROCEDURE [dbo].[ssp_PMDashboardUnpostedPaymentbyPayer] 
GO

/****** Object:  StoredProcedure [dbo].[ssp_PMDashboardUnpostedPaymentbyPayerNew]    Script Date: 2/3/2016 10:09:03 AM ******/
SET ANSI_NULLS ON									  
GO

SET QUOTED_IDENTIFIER ON
GO

 create procedure [dbo].[ssp_PMDashboardUnpostedPaymentbyPayer] --550   
(    
 @StaffId INT      
)        
AS    
BEGIN                                                                  
 BEGIN TRY       
        
/******************************************************************************        
**  File: dbo.ssp_PMDashboardUnpostedPaymentbyPayer.prc        
**  Name: dbo.ssp_PMDashboardUnpostedPaymentbyPayer        
**  Desc: This SP returns the data required by dashboard  for UnpostedPayment      
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
**  Date:			Author:     Description:        
**  --------		--------    -------------------------------------------        
**  June/03/2016	Gautam		what: Changed Total calculation logic to summarize Total unposted payments amount.
								Why : Total unposted payments amount was not correct. Thresholds - Support > Tasks #642 
*******************************************************************************/        
  DECLARE @local_StaffId INT  
                  
  SET @local_StaffId = @StaffId 
   
  --June/03/2016	Gautam                
  create table #results  
  (  
   SortOrder int,  
   PayerId int,  
   PayerName varchar(255),  
   Amount varchar(255),  
   AmountNumeric money -- need this to summarize the total line  
  )  
  
   insert into #results (  
   SortOrder,  
   PayerId,  
   PayerName,  
   Amount,  
   AmountNumeric  
  )       
  SELECT '1',        
     p.PayerId as PayerId,     
     p.PayerName as PayerName,        
     '$'+ISNULL(CONVERT(VARCHAR,SUM(UnpostedAmount),1),'0.00') AS Amount      --'1' Added by Gayathri for Currency 
     , isnull(sum(pa.UnpostedAmount), 0) as AmountNumeric    
  FROM Payments pa        
        LEFT JOIN CoveragePlans cp ON  cp.CoveragePlanId = pa.CoveragePlanId  AND  ISNULL(cp.RecordDeleted,'N')='N'      
        JOIN Payers p ON  (p.PayerId = cp.PayerId  or pa.PayerId = p.PayerId) AND ISNULL(p.RecordDeleted,'N')='N'   
        LEFT JOIN GlobalCodes gc ON gc.GlobalCodeId = p.PayerType  AND ISNULL(gc.RecordDeleted,'N')='N'  
  WHERE ISNULL(pa.RecordDeleted, 'N') = 'N'     
  AND ISNULL(pa.UnpostedAmount,0) <> 0    
  AND (EXISTS (Select SC.ClientId from StaffClients SC  where SC.StaffId = @local_StaffId and SC.ClientId = pa.ClientId )                                                    
    OR pa.ClientId IS NULL)        
  GROUP by p.PayerId, p.PayerName        
  
  -- June/03/2016	Gautam
  insert into #results (  
   SortOrder,  
   PayerId,  
   PayerName,  
   Amount,  
   AmountNumeric  
  )   
  select 3  
  ,-1  
  ,'Total'  
  ,'$' + ISNULL(CONVERT(VARCHAR, SUM(AmountNumeric), 1), '0.00') AS Amount  
  ,isnull(sum(AmountNumeric), 0.0) as AmountNumeric  
  from #results  
   
  select  
   SortOrder,  
   PayerId,  
   PayerName,  
   Amount  
 from #results  
  ORDER BY 1  
   ,3  
     
  --UNION        
  --SELECT '3',        
  --    -1,        
  --    'Total',        
  --    '$'+ISNULL(CONVERT(VARCHAR,SUM(pa.UnpostedAmount),1),'0.00') AS Amount      --'1' Added by Gayathri for Currency    
  -- FROM Payments pa       
  -- WHERE ISNULL(pa.RecordDeleted, 'N') = 'N'    
  -- AND ISNULL(pa.UnpostedAmount,0) <> 0    
  -- --        
  --AND (EXISTS (Select SC.ClientId from StaffClients SC  where SC.StaffId = @local_StaffId and SC.ClientId = pa.ClientId )                                                    
  --  OR pa.ClientId IS NULL)   
  --ORDER BY 1, 3        
      
    
END TRY    
     
 BEGIN CATCH    
  DECLARE @Error VARCHAR(8000)           
  SET @Error= CONVERT(VARCHAR,ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000),ERROR_MESSAGE())                                                                                                
   + '*****' + ISNULL(CONVERT(VARCHAR,ERROR_PROCEDURE()),'ssp_PMDashboardUnpostedPaymentbyPayer')                                                                                                 
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