IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_ClientOrderSetsgetLabs]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_ClientOrderSetsgetLabs]
GO       
CREATE PROCEDURE [dbo].[ssp_ClientOrderSetsgetLabs]      
  @OrderSetId INT       
AS       
  /**************************************************************          
  Created By   : Pabitra	ssp_ClientOrderSetsgetLabs 3    
  Created Date : 13 June 2017         
  Description  : To get the orders      
  Called From  :ClientOrderUserControl.ashx   
  /*  Date        Author          Description */        
    08/21/2017    Pabitra         Texas Customizations#104
    11/07/2017    Pabitra        Engineering Improvement Initiatives- NBL(I)#585 
    14/11/2018	  Neha     		 What : Added FrequencyName to the result-set.
								 Why : Engineering Improvement Initiatives- NBL(I)  task #713                
  **************************************************************/       
  BEGIN       
      BEGIN TRY       
   -- Order Labs   
      SELECT DISTINCT L.LaboratoryId, L.LaboratoryName FROM OrderSets  OS   
      INNER JOIN  OrderSetAttributes OSA   
      ON OS.OrderSetId = OSA.OrderSetId AND ISNULL(OS.RecordDeleted,'N')='N' AND ISNULL(OSA.RecordDeleted,'N')='N'  
      INNER JOIN Orders O ON O.OrderId=OSA.OrderId AND ISNULL(O.RecordDeleted,'N')='N' AND O.EMNoteOrder='Y'--AND O.OrderType IN (6481,6482)  
      INNER JOIN OrderLabs OL ON OL.OrderId=O.OrderId and ISNULL(OL.RecordDeleted,'N')='N'  
      INNER JOIN Laboratories L ON L.LaboratoryId=OL.LaboratoryId WHERE  ISNULL(L.RecordDeleted,'N')='N' AND OS.OrderSetId=@OrderSetId-- AND OL.IsDefault='Y'   
 ----Default  Order Values    
  DECLARE @OrderSTATUS INT  
 SELECT TOP 1 @OrderSTATUS=GlobalCodeId FROM GlobalCodes   where Category='ORDERSTATUS' AND CodeName='Active'  AND ISNULL(RecordDeleted,'N')='N'  
 DECLARE @OrderMode INT
 SET @OrderMode=8550  
   
 SELECT OP.PriorityId
 ,OS.ScheduleId
 ,OFE.OrderTemplateFrequencyId
 ,GC.CodeName as OrderType
 ,GC.GlobalCodeId AS OrderTypeCodeId
 ,@OrderMode AS OrderMode
 ,@OrderSTATUS AS OrderStatus
 ,O.OrderId
 ,O.OrderName
 ,OTF.DisplayName AS FrequencyName
 FROM OrderPriorities OP   
 INNER JOIN Orders O ON O.OrderId=op.OrderId AND ISNULL(OP.RecordDeleted,'N')='N' AND OP.IsDefault='Y'  -- AND O.OrderType IN (6481,6482) 
 INNER JOIN OrderSchedules OS ON OS.OrderId=O.OrderId   AND ISNULL(OS.RecordDeleted,'N')='N' AND OS.IsDefault='Y'  
 INNER JOIN  OrderFrequencies OFE ON OFE.OrderId=O.OrderId AND ISNULL(OFE.RecordDeleted,'N')='N' AND OFE.IsDefault='Y'  
 INNER JOIN  OrderTemplateFrequencies OTF ON OFE.OrderTemplateFrequencyId=OTF.OrderTemplateFrequencyId AND ISNULL(OTF.RecordDeleted,'N')='N' 
 LEFT JOIN GlobalCodes GC ON GC.GlobalCodeId =O.OrderType AND ISNULL(GC.RecordDeleted,'N')='N'  
 WHERE  ISNULL(O.RecordDeleted,'N')='N' AND O.OrderId IN(SELECT   O.OrderId FROM OrderSets  OS   
    INNER JOIN  OrderSetAttributes OSA   
    ON OS.OrderSetId = OSA.OrderSetId AND ISNULL(OS.RecordDeleted,'N')='N' AND ISNULL(OSA.RecordDeleted,'N')='N'  
    INNER JOIN Orders O ON O.OrderId=OSA.OrderId AND ISNULL(O.RecordDeleted,'N')='N' AND O.EMNoteOrder='Y' WHERE  OS.OrderSetId=@OrderSetId--AND O.OrderType IN (6481,6482) 
    )  
         
      END TRY            
      BEGIN CATCH       
          DECLARE @Error VARCHAR(8000)       
      
          SET @Error = CONVERT(VARCHAR, Error_number()) + '*****'       
                       + CONVERT(VARCHAR(4000), Error_message())       
                       + '*****'       
                       + Isnull(CONVERT(VARCHAR, Error_procedure()),       
                       'ssp_ClientOrderSetsgetLabs')       
                       + '*****' + CONVERT(VARCHAR, Error_line())       
                       + '*****' + CONVERT(VARCHAR, Error_severity())       
                       + '*****' + CONVERT(VARCHAR, Error_state())       
      
          RAISERROR ( @Error,-- Message text.        
                      16,-- Severity.        
                      1 -- State.        
          );       
      END catch       
  END 