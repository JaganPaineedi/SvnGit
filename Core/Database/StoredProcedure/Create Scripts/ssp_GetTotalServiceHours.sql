IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetTotalServiceHours]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetTotalServiceHours]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
           


CREATE PROCEDURE [dbo].[ssp_GetTotalServiceHours]   
(          
 @StaffID INT          
 ,@DayOfService DATETIME      
 )          
AS          
/*********************************************************************/          
/* Stored Procedure: [ssp_GetTotalServiceHours]               */          
/* Creation Date:  27/November/2015                                    */          
/* Input Parameters:   @StaffID,@DayOfService*/    
/*Author:Rajesh S*/      
/*********************************************************************/          
BEGIN          
 BEGIN TRY        
   DECLARE @ServiceHours DECIMAL(10,2)      
   DECLARE @Day DATE      
   SET @Day = DATEADD(dd, DATEDIFF(dd, 0, @DayOfService), 0)      
   
  
DECLARE @Duration1 decimal(10,2)  
  ,@Duration2 decimal(10,2) 
  ,@Duration3 decimal(10,2)  
  
  SELECT  
   @Duration1 = SUM(DURATION)  
  FROM  
  (  
   SELECT  
    --DATEDIFF(minute, DateTimeIn, DateTimeOut) DURATION  
     CONVERT(DECIMAL(10, 2), DATEDIFF(minute, DateTimeIn, DateTimeOut)/60.0)  DURATION  
   FROM       
    SERVICES SR      
    LEFT JOIN GlobalCodes GC ON GC.GlobalCodeId = SR.Status      
   WHERE       
      ClinicianId = @StaffID      
      AND (GC.Category) = 'SERVICESTATUS'      
      AND GC.ExternalCode1 IN ('SHOW','COMPLETE')
      AND @Day BETWEEN DATEADD(dd, DATEDIFF(dd, 0, DateTimeIn), 0) AND DateTimeOut    
      AND ISNULL(DateTimeIn,'')!='' AND ISNULL(DateTimeOut,'')!=''       
      AND ISNULL(SR.RecordDeleted,'N')='N'    
  ) A  
     --------------------------------------     
     
  
  
  SELECT  
   @Duration2 = SUM(DURATION)  
  FROM  
  (    
     SELECT  
   CASE WHEN GCU.ExternalCode1='MINUTES' THEN  
     --'MI'  
   -- DATEDIFF(minute, DateTimeIn, DATEADD(mi,SR.Unit,DateTimeIn))  
     CONVERT(DECIMAL(10, 2), DATEDIFF(minute, DateTimeIn, DATEADD(mi,SR.Unit,DateTimeIn))/60.0)  
    WHEN GCU.ExternalCode1='HOURS' THEN  
    -- 'HH'  
   -- DATEDIFF(minute, DateTimeIn, DATEADD(hh,SR.Unit,DateTimeIn))  
    CONVERT(DECIMAL(10, 2), DATEDIFF(minute, DateTimeIn, DATEADD(hh,SR.Unit,DateTimeIn))/60.0)   
    WHEN GCU.ExternalCode1='DAYS' THEN  
    -- 'DD'  
  --  DATEDIFF(minute, DateTimeIn, DATEADD(dd,SR.Unit,DateTimeIn))  
   CONVERT(DECIMAL(10, 2), DATEDIFF(minute, DateTimeIn, DATEADD(dd,SR.Unit,DateTimeIn))/60.0)  
   END   DURATION  
  FROM       
   SERVICES SR      
   LEFT JOIN GlobalCodes GC ON GC.GlobalCodeId = SR.Status      
   LEFT JOIN GlobalCodes GCU ON GCU.GlobalCodeId = SR.UnitType  
  WHERE       
     ClinicianId = @StaffID      
     AND (GC.Category) = 'SERVICESTATUS'      
     AND GC.ExternalCode1 IN ('SHOW','COMPLETE')       
     AND @Day=DATEADD(dd, DATEDIFF(dd, 0, DateTimeIn), 0)  
     AND ISNULL(DateTimeIn,'')!='' AND ISNULL(DateTimeOut,'')=''       
     AND ISNULL(SR.RecordDeleted,'N')='N'  
       
  ) B    
     ---------------------------------------------  
       
  SELECT  
   @Duration3 = SUM(DURATION)  
  FROM  
  (  
  
  SELECT  
  -- DATEDIFF(minute, @Day, DateTimeOut) DURATION  
  CONVERT(DECIMAL(10, 2), DATEDIFF(minute, @Day, DateTimeOut)/60.0) DURATION
  FROM       
   SERVICES SR      
   LEFT JOIN GlobalCodes GC ON GC.GlobalCodeId = SR.Status      
  WHERE       
     ClinicianId = @StaffID      
     AND (GC.Category) = 'SERVICESTATUS'      
     AND GC.ExternalCode1 IN ('SHOW','COMPLETE')      
     AND @Day>DATEADD(dd, DATEDIFF(dd, 0, DateTimeIn), 0) AND @Day<=DateTimeOut    
     AND ISNULL(DateTimeIn,'')!='' AND ISNULL(DateTimeOut,'')!=''       
     AND ISNULL(SR.RecordDeleted,'N')='N'    
       
  ) C  
  
 DECLARE @Duration decimal(10,2)  
 SET @Duration =  ISNULL(@Duration1,0)+ISNULL(@Duration2,0)+ISNULL(@Duration3,0)  
 SELECT @ServiceHours =@Duration-- CAST(SUM(@Duration)/60 + (SUM(@Duration)  % 60) /100.0 AS DECIMAL(10,2))   
 SELECT ISNULL(@ServiceHours,0) 
   
END TRY          
          
 BEGIN CATCH          
  DECLARE @Error VARCHAR(8000)          
          
  SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), '[ssp_GetTotalServiceHours]') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())          
          
  RAISERROR (          
    @Error          
    ,-- Message text.                                                                                                                
    16          
    ,-- Severity.                                                                                                                
  1 -- State.                                                                                                                
    );          
 END CATCH          
END 













