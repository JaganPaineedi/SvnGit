IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_ClientOrdergetLabs]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_ClientOrdergetLabs]
GO      
  CREATE PROCEDURE [dbo].[ssp_ClientOrdergetLabs]      
  @OrderId INT       
AS       
  /**************************************************************          
  Created By   : Pabitra [ssp_ClientOrdergetLabs]  2      
  Created Date : 13 June 2017         
  Description  : To get the orders      
  Called From  :ClientOrderUserControl.ashx   
  /*  Date        Author          Description */        
    08/21/2017    Pabitra         Texas Customizations#104   
    11/07/2017    Pabitra        Engineering Improvement Initiatives- NBL(I)#585              
  **************************************************************/       
  BEGIN       
      BEGIN try       
            
          SELECT L.LaboratoryId,L.LaboratoryName,OL.IsDefault  FROM  OrderLabs OL   
          INNER JOIN  Orders O ON O.OrderId=OL.OrderId AND ISNULL(OL.RecordDeleted,'N')='N' AND ISNULL(O.RecordDeleted,'N')='N' AND O.EMNoteOrder='Y'
          LEFT JOIN Laboratories L ON L.LaboratoryId= OL.LaboratoryId where O.OrderId=@OrderId  AND ISNULL(L.RecordDeleted,'N')='N'  
      
      END try       
      
      BEGIN catch       
          DECLARE @Error VARCHAR(8000)       
      
          SET @Error = CONVERT(VARCHAR, Error_number()) + '*****'       
                       + CONVERT(VARCHAR(4000), Error_message())       
                       + '*****'       
                       + Isnull(CONVERT(VARCHAR, Error_procedure()),       
                       'ssp_ClientOrdergetLabs')       
                       + '*****' + CONVERT(VARCHAR, Error_line())       
                       + '*****' + CONVERT(VARCHAR, Error_severity())       
                       + '*****' + CONVERT(VARCHAR, Error_state())       
      
          RAISERROR ( @Error,-- Message text.        
                      16,-- Severity.        
                      1 -- State.        
          );       
      END catch       
  END 