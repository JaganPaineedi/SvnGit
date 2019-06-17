/****** Object:  StoredProcedure [dbo].[ssp_CheckForDuplicateOrderName]    Script Date: 07/31/2013 12:09:57 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_CheckForDuplicateOrderName]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_CheckForDuplicateOrderName]
GO

/****** Object:  StoredProcedure [dbo].[ssp_CheckForDuplicateOrderName]    Script Date: 07/31/2013 12:09:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
    
CREATE Procedure [dbo].[ssp_CheckForDuplicateOrderName]      
 @OrderType INT,
 @OrderName Varchar(500),
 @OrderId int,
 @IsAdhocOrder BIT,
 @LoggedInUser Varchar(200),
 @DuplicateCount int output
                                 
AS     
/*********************************************************************/                                                                                          
 /* Stored Procedure: [ssp_CheckForDuplicateOrderName]                        */                                                                                 
 /* Creation Date:  18/Jul/2013                                      */                                                                                          
 /* Purpose: To Validate the Order Name based on Order Type          */                                                                                        
 /* Output Parameters:                                               */              
 /*Returns The Table for Order Details                               */                                                                                          
 /* Called By:                                                       */ 
 /* Modified By: PPOTNURU 28 FEB 2014  
  Date    Author   Purpose 
  10/11/2018 Shivam Kumar   What: Allowing to have same Order name for an normal order and Adhoc order.
                            Why:AHN-Support Go Live#393
                                                  */                                                                                                                                                                    
 /********************************************************************/   
    BEGIN   
    BEGIN try 
    
    SELECT @DuplicateCount = COUNT(*)
	FROM Orders
	WHERE OrderType = @OrderType
		AND UPPER(OrderName) = UPPER(@OrderName)
		AND ISNULL(RecordDeleted, 'N') = 'N'
		AND (
			(
				@IsAdhocOrder = 0
				AND OrderId <> @OrderId
				AND ISNULL(AdhocOrder, 'N') = 'N'
				)
			OR (
				@IsAdhocOrder = 1
				AND @LoggedInUser = CreatedBy
				AND OrderId <> @OrderId
				AND ISNULL(AdhocOrder, 'N') = 'Y'
				)
			)
    
    END try   
    BEGIN catch   
        DECLARE @Error VARCHAR(8000)   
        SET @Error= CONVERT(VARCHAR, Error_number()) + '*****'   
                    + CONVERT(VARCHAR(4000), Error_message())   
                    + '*****'   
                    + Isnull(CONVERT(VARCHAR, Error_procedure()),   
                    'ssp_GetOrders')   
                    + '*****' + CONVERT(VARCHAR, Error_line())   
                    + '*****' + CONVERT(VARCHAR, Error_severity())   
                    + '*****' + CONVERT(VARCHAR, Error_state())   
  
        RAISERROR ( @Error,-- Message text.       
                    16,-- Severity.       
                    1 -- State.       
        );   
    END catch   
  
    RETURN   
END 

GO


