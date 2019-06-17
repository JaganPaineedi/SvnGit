/****** Object:  StoredProcedure [dbo].[Csp_SCCreateNewClientOrder]    Script Date: 02/17/2014 14:30:28 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Csp_SCCreateNewClientOrder]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Csp_SCCreateNewClientOrder]
GO

/****** Object:  StoredProcedure [dbo].[Csp_SCCreateNewClientOrder]    Script Date: 02/17/2014 14:30:28 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

Create Procedure [dbo].[Csp_SCCreateNewClientOrder]
	@OrderId Int,
	@ClientId Int,
	@HL7EncChars CHAR(5),
	@InboundMessage XML
As
Begin
	Declare @OrderStatus Int
	Declare @OrderPriority Int
	Declare @OrderStartDateTime DateTime
	Declare @Error Varchar(4000)
	
	SELECT @OrderStatus =dbo.GetOrderStatus(dbo.HL7_INBOUND_XFORM(T.item.value('ORC.5[1]/ORC.5.0[1]/ITEM[1]','Varchar(100)'),@HL7EncChars)),		 		  
		   @OrderStartDateTime = dbo.GetOrderStartDate(dbo.HL7_INBOUND_XFORM(T.item.value('ORC.7[1]/ORC.7.3[1]/ITEM[1]','Varchar(100)'),@HL7EncChars)),
		   @OrderPriority = dbo.GetInboundPriority(dbo.HL7_INBOUND_XFORM(T.item.value('ORC.7[1]/ORC.7.5[1]/ORC.7.5.0[1]/ITEM[1]','Varchar(10)'),@HL7EncChars))		  
	FROM @InboundMessage.nodes('HL7Message/ORC') As T(item)
	
	Begin Try
		Insert Into ClientOrders
			(ClientId,
			 OrderType,
			 OrderedBy,
			 AssignedTo,
			 OrderFlag,
			 DocumentId,
			 OrderId,
			 MedicationOrderStrengthId,
			 MedicationOrderRouteId,
			 OrderPriorityId,
			 OrderScheduleId,
			 OrderFrequencyId,
			 Active,
			 OrderStartDateTime,
			 OrderStatus,
			 DocumentVersionId,
			 OrderingPhysician,
			 OrderEndDateTime) Values
		     (@ClientId,
		      'Labs',
		      NULL,
		      NULL,
		      'N',
		      NULL,
		      @OrderId,
		      NULL,
		      NULL,
		      @OrderPriority,
		      NULL,
		      NULL,
		      'Y',
		      @OrderStartDateTime,
		      @OrderStatus,
		      NULL,
		      NULL,
		      NULL) 
	    Return SCOPE_IDENTITY()
	End Try
	Begin Catch
		SET @Error= Convert(varchar(4000),ERROR_MESSAGE())                                                          
		 
		Insert into ErrorLog (ErrorMessage, VerboseInfo, DataSetInfo, ErrorType, CreatedBy, CreatedDate)
		values(@Error,NULL,NULL,'HL7 Procedure Error','SmartCare',GetDate()) 
		                                                        
		RAISERROR                                                                       
		(                                                            
		@Error, -- Message text.                                                                      
		16, -- Severity.                                                                      
		1 -- State.                                                                      
		); 
	End Catch     
End	
GO


