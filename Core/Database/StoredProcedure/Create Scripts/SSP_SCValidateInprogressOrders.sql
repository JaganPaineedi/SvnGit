/****** Object:  StoredProcedure [dbo].[SSP_SCValidateInprogressOrders]    Script Date: 07/31/2013 12:10:23 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SSP_SCValidateInprogressOrders]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SSP_SCValidateInprogressOrders]
GO

/****** Object:  StoredProcedure [dbo].[SSP_SCValidateInprogressOrders]    Script Date: 07/31/2013 12:10:23 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

    
CREATE PROCEDURE [dbo].[SSP_SCValidateInprogressOrders]
 @ClientId INT,    
 @StaffId INT    
AS    
  -- =============================================      
  -- Author: Pradeep    
  -- Create date:31/07/2013     
  -- Description: Validates the ClientOrders data.
  /*  Date				Author			Purpose              */  
  /* 22/Jun/2017		Chethan N		What: Changed Inprogress Client Orders validation message to include Author Name..
										Why:  Core Bugs task #2391	
	30/Jul/2018			Chethan N		What: Removed In-progress Client Order Validation.
										Why:  Allegan - Enhancements task #1121						
	30/Jan/2019			Chethan N		What : Changes to ignore Rx medication mapped Client Orders.*/			
  -- =============================================   
BEGIN    
 DECLARE @InprogressCount INT    
 DECLARE @CreatedUser INT    
 DECLARE @ErrorMessage VARCHAR(MAX)    
 DECLARE @ValidationFlag CHAR(1)    
 DECLARE @SignedOrderCount INT    
 DECLARE @CreatedUserName VARCHAR(MAX)
     
 BEGIN TRY      
  SELECT @InprogressCount=1,@CreatedUser=D.AuthorId, @CreatedUserName = S.DisplayAs FROM    
  ClientOrders CO     
  JOIN Documents D on D.DocumentId=CO.DocumentId 
  JOIN Staff S ON S.StaffId = D.AuthorId
  WHERE CO.ClientId=@ClientId    
  and CO.OrderFlag = 'N'
  AND D.AuthorId = @StaffId
  and ISNULL(CO.RecordDeleted,'N')='N'    
  and ISNULL(D.RecordDeleted,'N')='N'   
  and ISNULL(CO.OrderDiscontinued,'N')='N'   
      
  SELECT @SignedOrderCount=1  FROM    
  ClientOrders CO     
  JOIN Documents D on D.DocumentId=CO.DocumentId    
  WHERE CO.ClientId=@ClientId    
  and CO.OrderFlag = 'Y'    
  and ISNULL(CO.RecordDeleted,'N')='N'  
  and ISNULL(D.RecordDeleted,'N')='N'  
  and ISNULL(CO.OrderDiscontinued,'N')='N'  
  AND (NOT EXISTS( SELECT 1 FROM Recodes R JOIN RecodeCategories RC ON RC.CategoryName = 'RxOrder' 
							AND RC.RecodeCategoryId = R.RecodeCategoryId WHERE ISNULL(R.RecordDeleted, 'N') = 'N' 
							AND R.IntegerCodeId = CO.OrderId ))
  
  SELECT @SignedOrderCount=1  FROM  
  ClientMedications CM WHERE ISNULL(CM.RecordDeleted, 'N') != 'Y' AND CM.ClientId = @ClientId 
  AND CM.ClientMedicationId NOT IN (SELECT ClientMedicationId FROM ClientOrderMedicationReferences CMR INNER JOIN ClientOrders CO ON CMR.ClientOrderId = CO.ClientOrderId AND CO.ClientId = @ClientId) 
        
  IF (@InprogressCount=1)    
  BEGIN    
   IF (@StaffId=@CreatedUser)    
    BEGIN    
     SET @ErrorMessage=''    
     SET @ValidationFlag='E'    
    END    
   ELSE IF (@StaffId <> @CreatedUser)    
    BEGIN    
     SET @ErrorMessage='You cannot create a new client order untill the un-signed order(s) from ' + @CreatedUserName + ' are signed or discarded'   
     SET @ValidationFlag='O'    
    END    
  END    
  ELSE    
  BEGIN    
   SET @ErrorMessage=''    
   SET @ValidationFlag='N'    
  END    
      
  select ISNULL(@InprogressCount,0) AS InprogressCount,ISNULL(@SignedOrderCount,0) AS SignedOrderCount,@ValidationFlag AS Flag,@ErrorMessage AS ErrorMessage    
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


