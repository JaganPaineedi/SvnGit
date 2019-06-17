IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetSearchOrder]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetSearchOrder]
GO        
CREATE PROCEDURE [dbo].[ssp_GetSearchOrder]   
@OrderSearch VARCHAR(50)
AS           
  /**************************************************************              
  Created By   : Pabitra [ssp_GetSearchOrder] 'Cho'           
  Created Date : 13 June 2017             
  Description  : To get the orders          
  Called From  :ClientOrderUserControl.ashx       
  /*Date        Author          Description */            
	08/21/2017  Pabitra         Texas Customizations#104
    11/07/2017  Pabitra			Engineering Improvement Initiatives- NBL(I)#585 
	02/26/2018	Chethan N		What : Retrieving Orders based on Searched text.
								Why : Engineering Improvement Initiatives- NBL(I)  task #585  
	03/07/2018	Chethan N		What : Retrieving LocationId.
								Why : Engineering Improvement Initiatives- NBL(I)  task #667  
	17/07/2018	Chethan N		What : Retrieving Laboratory name for the Lab Orders 
								and sorting results that start with searched text first, then followed by results with Like match .
								Why : Engineering Improvement Initiatives- NBL(I)  task #694                      
  **************************************************************/           
  BEGIN           
      BEGIN try         
		
		DECLARE @StartWith VARCHAR(50)
		SET @StartWith = @OrderSearch + '%'
		SET @OrderSearch = '%' + @OrderSearch + '%'
		  
		SELECT OrderId, OrderName FROM(
        SELECT  (Cast(O.OrderId AS VARCHAR(10))+'$'+ CAST(O.OrderType AS VARCHAR(10))+'$N$'+CAST(ISNULL(O.LocationId, -1) AS VARCHAR(10))) AS  OrderId,
        CASE 
			WHEN L.LaboratoryId IS NOT NULL
				THEN O.OrderName + ' ('+ ISNULL(LaboratoryName, '') +')'
			ELSE O.OrderName
			END AS OrderName 
        FROM Orders O 
		LEFT JOIN OrderLabs OL ON OL.OrderId = O.OrderId AND ISNULL(Isdefault, 'N') = 'Y' AND ISNULL(OL.RecordDeleted, 'N') = 'N'
		LEFT JOIN Laboratories L ON L.LaboratoryId = OL.LaboratoryId AND ISNULL(L.RecordDeleted, 'N') = 'N'
        WHERE ISNULL(O.RecordDeleted,'N')='N'  AND O.EMNoteOrder='Y' AND O.OrderName LIKE @OrderSearch
        UNION       
        SELECT Distinct (Cast(OS.OrderSetId AS VARCHAR(10)) +'$0000$Y') AS  OrderId ,DisplayName+' (Order Set)'  AS OrderName 
        FROM OrderSets OS     
        JOIN OrderSetAttributes OSA ON OSA.OrderSetId= OS.OrderSetId  AND ISNULL(OS.RecordDeleted,'N')='N' AND ISNULL(OSA.RecordDeleted,'N')='N'    
        JOIN Orders O ON O.OrderId = OSA.OrderId 
        WHERE  ISNULL(OS.RecordDeleted,'N')='N' AND ISNULL(O.RecordDeleted,'N')='N' AND O.EMNoteOrder='Y'
         AND OS.DisplayName LIKE @OrderSearch   --AND O.OrderType IN (6481,6482)
         ) T 
         ORDER BY 
		CASE 
		  WHEN OrderName LIKE @StartWith THEN 1
		  WHEN OrderName LIKE @OrderSearch THEN 2
		END, OrderName, OrderId  
              
          
      END try           
          
      BEGIN catch           
          DECLARE @Error VARCHAR(8000)           
          
          SET @Error = CONVERT(VARCHAR, Error_number()) + '*****'           
                       + CONVERT(VARCHAR(4000), Error_message())           
                       + '*****'           
                       + Isnull(CONVERT(VARCHAR, Error_procedure()),           
                       'ssp_GetSearchOrder')           
                       + '*****' + CONVERT(VARCHAR, Error_line())           
                       + '*****' + CONVERT(VARCHAR, Error_severity())           
                       + '*****' + CONVERT(VARCHAR, Error_state())           
          
          RAISERROR ( @Error,-- Message text.            
                      16,-- Severity.            
                      1 -- State.            
          );           
      END catch           
  END 