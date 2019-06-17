
/****** Object:  StoredProcedure [dbo].[SSP_SCUpdateOrderSignedInformation]    Script Date: 06/01/2015 14:29:14 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SSP_SCUpdateOrderSignedInformation]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SSP_SCUpdateOrderSignedInformation]
GO

/****** Object:  StoredProcedure [dbo].[SSP_SCUpdateOrderSignedInformation]    Script Date: 06/01/2015 14:29:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[SSP_SCUpdateOrderSignedInformation]
 @DocumentVersionId INT,
 @UserCode type_CurrentUser   
AS 
  -- =============================================      
  -- Author: Pradeep    
  -- Create date:31/07/2013     
  -- Description: Update the relevent data get updated after sign.
	/*  Date                  Author                 Purpose								*/
  -- Modified By: Praveen Potnuru - 26-Nov-2013 - Commented EXEC SSP_SCGetClientOrders @DocumentVersionId 
	/* 28th May 2015		  Chethan N				What: Updating the Status of Discontinued orders to 'Discontinued'
													Why: Philhaven Development task#264								*/
	/* Jan 02 2016			  Chethan N				What : Discontinuing Child Orders when parent order is discontinued.
													Why : Woods - Customizations task #841.02	*/
	/* Apr 13 2017			  Chethan N				What : Updating discontinued reason to 'Changed to other form of drug' when it is null.
													Why : AHN Support GO live Task #194	
	   Aug 03 2018			  Chethan N				What : Updating End Date of the previous/original Order to the End date entered in new order.
													Why : AHN Support GO live Task # 313
	   Nov 26 2018			  Chethan N				What : Discontinuing Child Orders when Parent Order is discontinued.
													Why :  Journey-Support Go Live Task #374*/
  -- =============================================  
BEGIN    
 BEGIN TRY    
 -- Update all the clientOrders as signed for the current DocumentVerionId.  
 UPDATE ClientOrders  
 SET OrderFlag = 'Y'  
  ,ModifiedBy = @UserCode  
  ,ModifiedDate = GETDATE()  
 WHERE DocumentVersionId = @DocumentVersionId  
  
 CREATE TABLE #tempClientOrders (  
  ClientOrderId INT  
  ,OrderDiscontinued CHAR(1)  
  ,PreviousClientOrderId INT  
  ,DiscontinuedReason INT  
  ,OrderEndDateTime DATETIME  
  ,MedicationDaySupply INT  
  )  
  
 --Fetch all ClientOrders which are signed for the current DocumentVersionId.   
 INSERT INTO #tempClientOrders  
 SELECT ClientOrderId  
  ,OrderDiscontinued  
  ,PreviousClientOrderId  
  ,DiscontinuedReason  
  ,OrderEndDateTime  
  ,MedicationDaySupply  
 FROM ClientOrders CO  
 WHERE DocumentVersionId = @DocumentVersionId  
  AND OrderFlag = 'Y'  
  AND ISNULL(CO.RecordDeleted, 'N') = 'N'  
  
 --Update the Previous ClientOrder as Discontinued.  
 UPDATE CO  
 SET Active = 'N'  
  ,OrderDiscontinued = 'Y'  
  ,OrderStatus = 6510  
  ,DiscontinuedDateTime = GETDATE()  
  ,ModifiedBy = @UserCode  
  ,ModifiedDate = GETDATE()  
  ,DiscontinuedReason = ISNULL(TCO.DiscontinuedReason, 10875)  
  ,OrderEndDateTime = TCO.OrderEndDateTime  
  ,MedicationDaySupply = TCO.MedicationDaySupply  
 FROM ClientOrders CO  
 JOIN #tempClientOrders TCO ON CO.ClientOrderId = TCO.PreviousClientOrderId  
  
	--Update the Discontinued orders As RecordDeleted.
 UPDATE ClientOrders  
 SET RecordDeleted = 'Y'  
  ,OrderStatus = 6510  
  ,DeletedDate = GETDATE()  
  ,DeletedBy = @UserCode  
 WHERE ClientOrderId IN (  
   SELECT ClientOrderId  
   FROM #tempClientOrders  
   WHERE OrderDiscontinued = 'Y'  
   )  
  
 -- Update Parent Order Id for the child orders when Parent Order is modified.  
 UPDATE CO  
 SET CO.ParentClientOrderId = TCO.ClientOrderId  
 FROM ClientOrders CO  
 JOIN #tempClientOrders TCO ON CO.ParentClientOrderId = TCO.PreviousClientOrderId  
 WHERE ISNULL(CO.OrderDiscontinued, 'N') = 'N'  
 AND ISNULL(TCO.OrderDiscontinued, 'N') = 'N'  
   
  
 --Update the Child ClientOrder as Discontinued if Parent Order is Discontinued.   
 UPDATE CO  
 SET Active = 'N'  
  ,OrderDiscontinued = 'Y'  
  ,OrderStatus = 6510  
  ,DiscontinuedDateTime = GETDATE()  
  ,ModifiedBy = @UserCode  
  ,ModifiedDate = GETDATE()  
  ,DiscontinuedReason = TCO.DiscontinuedReason  
  ,OrderEndDateTime = TCO.OrderEndDateTime  
  ,MedicationDaySupply = TCO.MedicationDaySupply  
 FROM ClientOrders CO  
 JOIN #tempClientOrders TCO ON CO.ParentClientOrderId = TCO.PreviousClientOrderId  
  AND ISNULL(TCO.OrderDiscontinued, 'N') = 'Y'  
 WHERE ISNULL(CO.OrderDiscontinued, 'N') = 'N'  
  
 -- EXEC SSP_SCGetClientOrders @DocumentVersionId  
 DROP TABLE #tempClientOrders  
     
 END TRY    
 BEGIN CATCH    
   declare @Error varchar(8000)                        
   set @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                         
   + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'SSP_SCValidateInprogressOrders')                         
   + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                          
   + '*****' + Convert(varchar,ERROR_STATE())                        
   RAISERROR                         
   (                        
    @Error, -- Message text.                        
    16,  -- Severity.                        
    1  -- State.                        
   );         
 END CATCH    
END    

GO


