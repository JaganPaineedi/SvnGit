IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetOrderDefaultValues]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetOrderDefaultValues]
GO  
CREATE PROCEDURE [dbo].[ssp_GetOrderDefaultValues]    
@OrderId INT           
AS         
  /**************************************************************            
  Created By   : Pabitra [ssp_GetOrderDefaultValues] 26         
  Created Date : 28 June 2017           
  Description  : To get the orders        
  Called From  :ClientOrderUserControl.ashx     
  /*  Date        Author          Description */ 
    08/21/2017    Pabitra         Texas Customizations#104
    11/07/2017    Pabitra        Engineering Improvement Initiatives- NBL(I)#585           
 **************************************************************/         
  BEGIN         
      BEGIN try         
         DECLARE @OrderMode INT  
         DECLARE @PriorityId INT  
         DECLARE @ScheduleId INT  
         DECLARE @OrderTemplateFrequencyId INT  
         DECLARE @OrderType INT  
         DECLARE @OrderText VARCHAR(200)
         DECLARE @OrderLabId INT    
           
         SELECT @OrderType=OrderType FROM Orders where OrderId=@OrderId AND ISNULL(RecordDeleted,'N')='N'  
         SELECT TOP 1 @OrderText=CodeName FROM GlobalCodes where GlobalCodeId=@OrderType AND ISNULL(RecordDeleted,'N')='N'  
         SELECT top 1  @PriorityId=PriorityId FROM OrderPriorities OP where  OP.OrderId=@OrderId AND IsDefault='Y' and ISNULL(RecordDeleted,'N')='N'  
         SELECT top 1  @ScheduleId=ScheduleId FROM OrderSchedules OP where  OP.OrderId=@OrderId AND IsDefault='Y' and ISNULL(RecordDeleted,'N')='N'  
         SELECT top 1  @OrderTemplateFrequencyId=OrderTemplateFrequencyId FROM OrderFrequencies OP where  OP.OrderId=@OrderId AND IsDefault='Y' and ISNULL(RecordDeleted,'N')='N'  
         SELECT top 1  @OrderLabId=LaboratoryId FROM OrderLabs OL where  OL.OrderId=@OrderId AND IsDefault='Y' and ISNULL(RecordDeleted,'N')='N'  
         SET  @OrderMode=8550
          
         SELECT   
         TOP 1 GlobalCodeId  AS OrderStatus  
         ,@OrderMode  AS OrderMode     
         ,@PriorityId AS PriorityId    
         ,@ScheduleId AS ScheduleId     
         ,@OrderTemplateFrequencyId AS OrderTemplateFrequencyId  
         ,@OrderText AS OrderType
         ,@OrderLabId AS LaboratoryId     
         FROM GlobalCodes where Category='ORDERSTATUS' AND CodeName='Active'  AND ISNULL(RecordDeleted,'N')='N'  
           
          
      END try         
        
      BEGIN catch         
          DECLARE @Error VARCHAR(8000)         
        
          SET @Error = CONVERT(VARCHAR, Error_number()) + '*****'         
                       + CONVERT(VARCHAR(4000), Error_message())         
                       + '*****'         
                       + Isnull(CONVERT(VARCHAR, Error_procedure()),         
                       'ssp_GetOrderDefaultValues')         
                       + '*****' + CONVERT(VARCHAR, Error_line())         
                       + '*****' + CONVERT(VARCHAR, Error_severity())         
                       + '*****' + CONVERT(VARCHAR, Error_state())         
        
          RAISERROR ( @Error,-- Message text.          
                      16,-- Severity.          
                      1 -- State.          
          );         
      END catch         
  END 