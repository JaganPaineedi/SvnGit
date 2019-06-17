/****** Object:  StoredProcedure [dbo].[csp_VitalsCheck]    Script Date: 06/30/2014 18:07:32 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_VitalsCheck]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_VitalsCheck]
GO

/****** Object:  StoredProcedure [dbo].[csp_VitalsCheck]    Script Date: 07/24/2015 18:07:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

    
CREATE PROCEDURE [dbo].[csp_VitalsCheck] (    
 @ClientID INT  
 ,@ServiceId INT    
 ,@DateOfService DATETIME    
 )    
AS    
/*********************************************************************/  
/* Stored Procedure: [csp_VitalsCheck] 4,4995,'09/27/2017'  */  
/*       Date              Author                  Purpose          */  
/*       14/07/2015        Pabitra              What:SubReport for Psychiatric Note AIMS tab   */  
/*             */  
/*********************************************************************/  
BEGIN  
 BEGIN TRY  
 DECLARE @CreatedBy VARCHAR(500) ='Admin' 
 SELECT TOP 1   
@CreatedBy = d.CreatedBy  
From Documents d where ServiceId=@ServiceId and ISNULL(RecordDeleted,'N')='N' 

IF EXISTS(SELECT top 1 ClientHealthDataAttributeId FROM ClientHealthDataAttributes WHERE cast(HealthRecordDate as date)=@DateOfService  AND  ClientId=@ClientID AND ISNULL(RecordDeleted,'N')='N'  Order by  ClientHealthDataAttributeId  desc ) 
BEGIN
SELECT top 1 HealthRecordDate FROM ClientHealthDataAttributes WHERE cast(HealthRecordDate as date)=@DateOfService  AND  ClientId=@ClientID AND ISNULL(RecordDeleted,'N')='N'  Order by  ClientHealthDataAttributeId  desc               
END
ELSE
BEGIN
SELECT GETDATE() AS  HealthRecordDate
END


 
 END TRY  
 BEGIN CATCH  
 DECLARE @Error VARCHAR(8000)  
  
  SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'csp_VitalsCheck') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())  
  
  RAISERROR (  
    @Error  
    ,-- Message text.  
    16  
    ,-- Severity.  
    1 -- State.  
    );  
   
 END CATCH  
END