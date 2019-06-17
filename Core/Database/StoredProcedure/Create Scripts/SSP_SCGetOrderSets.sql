/****** Object:  StoredProcedure [dbo].[SSP_SCGetOrderSets]    Script Date: 07/31/2013 12:26:36 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SSP_SCGetOrderSets]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SSP_SCGetOrderSets]
GO

/****** Object:  StoredProcedure [dbo].[SSP_SCGetOrderSets]    Script Date: 07/31/2013 12:26:36 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SSP_SCGetOrderSets] 
	@OrderSetId int
AS
/*********************************************************************/                                                                                                        
/* Stored Procedure: [SSP_SCGetOrderSets]							 */                                                                                               
/* Creation Date:  27/June/2013                                      */                                                                                                        
/* Purpose: To get OrderSet											 */                                                                                                      
/* Input Parameters:@OrderSetId										 */                                  
/* Output Parameters:												 */                                                                                                                                  
/* Called By:                                                        */                                                                                              
/* Data Modifications:                                               */                                                                                                        
/* Updates:                                                          */                                                                                                        
/* Date          Author		Purpose									 */                                                                                                        
/* 27/June/2013  S Ganesh	Created									 */     
/* 17/Mar/2015  Varun		Added Sensitive column to OrderSetAttributes  */
/* 02/Mar/2018	Chethan N	What : Retrieving EMNoteOrder column
							Why : Engineering Improvement Initiatives- NBL(I)  task #585*/      
/*********************************************************************/ 
BEGIN
	BEGIN TRY
		SELECT  [OrderSetId],
				[CreatedBy],
				[CreatedDate],
				[ModifiedBy],
				[ModifiedDate],
				[RecordDeleted],
				[DeletedDate],
				[DeletedBy],
				[DisplayName],
				[Active]
		FROM OrderSets OS
		WHERE OS.OrderSetId=@OrderSetId
		AND ISNULL(OS.RecordDeleted,'N')='N'
		
		SELECT  OSA.[OrderSetAttributeId],
				OSA.[OrderSetId],
				OSA.[OrderId],
				OSA.[CreatedBy],
				OSA.[CreatedDate],
				OSA.[ModifiedBy],
				OSA.[ModifiedDate],
				OSA.[RecordDeleted],
				OSA.[DeletedDate],
				OSA.[DeletedBy],
				OSA.[DisplayOrder],
				O.[OrderType],
				GC.[CodeName] as OrderTypeText,
				O.[OrderName] + ISNULL(' (' +(SELECT  MedicationName FROM MDMedicationNames WHERE  MedicationNameId = O.MedicationNameId) + ')','') AS OrderName,
				ISNULL(O.Sensitive,'N') AS Sensitive,
				ISNULL(O.EMNoteOrder , 'N') AS EMNoteOrder
		FROM OrderSetAttributes OSA
		JOIN OrderSets OS on OSA.OrderSetId=OS.OrderSetId
		JOIN Orders O on OSA.OrderId =O.OrderId
		JOIN GlobalCodes GC on GC.GlobalCodeId=O.OrderType
		WHERE OS.OrderSetId=@OrderSetId
		AND ISNULL(OS.RecordDeleted,'N')='N'
		AND ISNULL(OSA.RecordDeleted,'N')='N'		
	END TRY
	BEGIN CATCH
		  DECLARE @Error VARCHAR(8000)           
		  SET @Error= CONVERT(VARCHAR,ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000),ERROR_MESSAGE())                                                                                                
		   + '*****' + ISNULL(CONVERT(VARCHAR,ERROR_PROCEDURE()),'SSP_SCGetOrderSets')                                                                                                 
		   + '*****' + CONVERT(VARCHAR,ERROR_LINE()) + '*****' + CONVERT(VARCHAR,ERROR_SEVERITY())                                                                                                  
		   + '*****' + CONVERT(VARCHAR,ERROR_STATE())    
		  RAISERROR    
		  (    
		   @Error, -- Message text.    
		   16,  -- Severity.    
		   1  -- State.    
		  );    
	END CATCH
END

GO


