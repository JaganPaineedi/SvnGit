/****** Object:  StoredProcedure [dbo].[ssp_GetOrderBasedonType]    Script Date: 05/11/2017 17:06:57 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetOrderBasedonType]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetOrderBasedonType]
GO

/****** Object:  StoredProcedure [dbo].[ssp_GetOrderBasedonType]    Script Date: 05/11/2017 17:06:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 CREATE PROCEDURE [dbo].[ssp_GetOrderBasedonType] @OrderType INT  ,
 @OrderSearch varchar(max)
AS  
-- =============================================        
-- Author: Pradeep      
-- Create date:31/07/2013       
-- Description: Return the Orders data  
-- Modified: PPOTNURU 24/04/2014 Added order by statement And Added AdhocOrder check  
-- 17/Mar/2015  Varun		Returning Sensitive column   
/* 02/Mar/2018	Chethan N	What : Retrieving EMNoteOrder column
							Why : Engineering Improvement Initiatives- NBL(I)  task #585*/
-- =============================================       
BEGIN  
 BEGIN TRY  
  SELECT ORD.[OrderId]  
   ,ORD.[OrderName] + ISNULL(' (' + (  
     SELECT MedicationName  
     FROM MDMedicationNames  
     WHERE MedicationNameId = ORD.MedicationNameId  
     ) + ')', '') AS OrderName  
   ,ISNULL(ORD.Sensitive,'N') AS Sensitive 
   ,ISNULL(ORD.EMNoteOrder, 'N') AS EMNoteOrder
  FROM Orders ORD  
  WHERE ISNULL(ORD.Active, 'Y') = 'Y'  
   AND ISNULL(ORD.[RecordDeleted], 'N') = 'N'  
   AND ISNULL(ORD.AdhocOrder, 'N') = 'N'  
   AND ORD.[OrderType] = @OrderType  and ORD.OrderName like '%'+@OrderSearch+'%'
  ORDER BY OrderName  
 END TRY  
  
 BEGIN CATCH  
  DECLARE @Error VARCHAR(8000)  
  
  SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_GetOrderBasedonType') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, 
ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())  
  
  RAISERROR (  
    @Error  
    ,-- Message text.                                                                                        
    16  
    ,-- Severity.                                                                                        
    1 -- State.                                                                                        
    );  
 END CATCH  
END  
GO


