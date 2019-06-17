/****** Object:  StoredProcedure [dbo].[SSP_SCProcessHL7_251_Order_InboundMessage]    Script Date: 05/21/2015 15:34:53 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SSP_SCProcessHL7_251_Order_InboundMessage]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SSP_SCProcessHL7_251_Order_InboundMessage]
GO

/****** Object:  StoredProcedure [dbo].[SSP_SCProcessHL7_251_Order_InboundMessage]    Script Date: 05/21/2015 15:34:53 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[SSP_SCProcessHL7_251_Order_InboundMessage]
	@VendorId Int,
	@InboundMessage XML,
	@HL7CPQueueMessageID INT,
	@OutputParamter nvarchar(max) Output
AS
--======================================================
/*
Customize here for the order specific Inbound message processing.
Returns last inserted InboundMedicationId.

Jan-30-2014		Pradeep: Modified to get Dose and DispensedPackageSizeUnit from TQ1 segment.
Apr-09-2014		Pradeep: Modified to Get Provider Pharmacy Instrunction and InboundMessageXML to InboundMedications Table.	
Jul 12 2014     Pradeep: Insert New Record on HL7CPQueueMessageLinks Table for ClientOrders Entity and InboundMedications
May 21 2015     SHankha: Modified to parse the Entered By and Verified By segments from the ORC in to InboundMedications Table.	
*/
--======================================================
BEGIN
	BEGIN TRY
		Declare @ClientOrderId Int
		Declare @ClientId Int
		Declare @MessageControlId Varchar(20)
		Declare @DrugNDCCode nVarchar(100)
		Declare @DrugNDCDescription Varchar(250)
		Declare @DrugCode Varchar(10)
		Declare @AlternateDrugNDCCode nVarchar(100)
		Declare @AlternateDrugNDCDescription Varchar(250)
		Declare @AlternateDrugCode Varchar(10) 
		Declare @DispensedDateTime dateTime
		Declare @DispensedPackageSize Varchar(20)
		Declare @DispensedPackageSizeUnit Varchar(250)
		Declare @ExplicitTime Varchar(20)
		Declare @StartDateTime Varchar(24)
		Declare @EndDateTime Varchar(24)
		Declare @Route varchar(max)
		Declare @Frequency Varchar(max)
		Declare @Dose Varchar(max)	
		Declare @SpecialInstructions varchar(max)
		Declare @GiveStrength Varchar(max)
		Declare @GiveUnit Varchar(max)
		Declare @SubStatus Char(1)
		Declare @DispensingPharmacy nvarchar(max)
		Declare @ProviderPharmacyInstructions varchar(250)
		Declare @EntityType Int
		Declare @EntityId Int
		Declare @UserCode type_currentUser
		Declare @EnteredBy varchar(150)
		Declare @VerifiedBy varchar(150)
		
		SET @UserCode = CURRENT_USER
		
			-- in order as defined by HL7 in MSH
		DECLARE @HL7EncChars char(5) = '|^~\&'
		Set @HL7EncChars = dbo.GetHL7EncodingCharactersFromMessage(@InboundMessage)
			
		-- MSH
		Select @MessageControlId = dbo.HL7_INBOUND_XFORM(T.item.value('MSH.10[1]/MSH.10.0[1]/ITEM[1]','VARCHAR(20)'),@HL7EncChars)		  
			From @InboundMessage.nodes('HL7Message/MSH') As T(item)
			
		-- PID
		Select @ClientId = dbo.HL7_INBOUND_XFORM(T.item.value('PID.3[1]/PID.3.0[1]/ITEM[1]','VARCHAR(20)'),@HL7EncChars)		  
			From @InboundMessage.nodes('HL7Message/PID') As T(item)	
				
		-- check that this client  ID exists
		IF NOT EXISTS(select 1 from Clients C where ClientId = @ClientId and ISNULL(C.RecordDeleted,'N')='N' And C.Active='Y')
		RAISERROR                                                                       
			(                                                            
			'ClientID does not exist',                                                                     
			16, -- Severity.                                                                      
			1 -- State.                                                                      
			); 
		
		--ORC
		-- Select ClientOrderId from ORC segment as we decided to sent this value in Outbound Message
		Select @ClientOrderId = dbo.HL7_INBOUND_XFORM(T.item.value('ORC.2[1]/ORC.2.0[1]/ITEM[1]','VARCHAR(20)'),@HL7EncChars),		
			   @EnteredBy = dbo.HL7_INBOUND_XFORM(T.item.value('ORC.10[1]/ORC.10.1[1]/ITEM[1]','VARCHAR(75)'),@HL7EncChars) + ', ' + dbo.HL7_INBOUND_XFORM(T.item.value('ORC.10[1]/ORC.10.2[1]/ITEM[1]','VARCHAR(75)'),@HL7EncChars),
		       @VerifiedBy = dbo.HL7_INBOUND_XFORM(T.item.value('ORC.11[1]/ORC.11.1[1]/ITEM[1]','VARCHAR(75)'),@HL7EncChars) + ', ' + dbo.HL7_INBOUND_XFORM(T.item.value('ORC.11[1]/ORC.11.2[1]/ITEM[1]','VARCHAR(75)'),@HL7EncChars)
			From @InboundMessage.nodes('HL7Message/ORC') As T(item)
			
		-- check that this client order ID exists
		IF NOT EXISTS(select 1 from ClientOrders CO where CO.ClientOrderId = @ClientOrderId and ISNULL(CO.RecordDeleted,'N')='N')
			RAISERROR                                                                       
			(                                                            
			'ClientOrderId does not exist',                                                                     
			16, -- Severity.                                                                      
			1 -- State.                                                                      
			); 
			
		--RXO
		Select @ProviderPharmacyInstructions=dbo.HL7_INBOUND_XFORM(T.item.value('RXO.6[1]/RXO.6.0[1]/ITEM[1]','Varchar(250)'),@HL7EncChars)
			From @InboundMessage.nodes('HL7Message/RXO') As T(item)		
		
		-- RXR
		Select @Route=dbo.HL7_INBOUND_XFORM(T.item.value('RXR.1[1]/RXR.1.0[1]/ITEM[1]','Varchar(250)'),@HL7EncChars)
			From @InboundMessage.nodes('HL7Message/RXR') As T(item)
			
		-- RXD
		Select @DrugNDCCode= dbo.HL7_INBOUND_XFORM(T.item.value('RXD.2[1]/RXD.2.0[1]/ITEM[1]','nvarchar(max)'),@HL7EncChars),
			  @DrugNDCDescription= dbo.HL7_INBOUND_XFORM(T.item.value('RXD.2[1]/RXD.2.1[1]/ITEM[1]','Varchar(250)'),@HL7EncChars),
			  @DrugCode= dbo.HL7_INBOUND_XFORM(T.item.value('RXD.2[1]/RXD.2.2[1]/ITEM[1]','Varchar(10)'),@HL7EncChars),
			  @AlternateDrugNDCCode= dbo.HL7_INBOUND_XFORM(T.item.value('RXD.2[1]/RXD.2.3[1]/ITEM[1]','nvarchar(Max)'),@HL7EncChars),
			  @AlternateDrugNDCDescription= dbo.HL7_INBOUND_XFORM(T.item.value('RXD.2[1]/RXD.2.4[1]/ITEM[1]','Varchar(250)'),@HL7EncChars),
			  @AlternateDrugCode= dbo.HL7_INBOUND_XFORM(T.item.value('RXD.2[1]/RXD.2.5[1]/ITEM[1]','Varchar(10)'),@HL7EncChars),
			  @DispensedDateTime = dbo.HL7_INBOUND_XFORM(Convert(datetime, stuff(stuff(stuff(T.item.value('RXD.3[1]/RXD.3.0[1]/ITEM[1]','Varchar(250)'), 9, 0, ' '), 12, 0, ':'), 15, 0, ':')),@HL7EncChars)
			From @InboundMessage.nodes('HL7Message/RXD') As T(item)
		
		-- RXE	
		Select @DispensedPackageSize = dbo.HL7_INBOUND_XFORM(T.item.value('RXE.28[1]/RXE.28.0[1]/ITEM[1]','Varchar(20)'),@HL7EncChars),
			   @SpecialInstructions =dbo.HL7_INBOUND_XFORM(T.item.value('RXE.21[1]/RXE.21.1[1]/ITEM[1]','Varchar(max)'),@HL7EncChars),
			   @GiveStrength =dbo.HL7_INBOUND_XFORM(T.item.value('RXE.25[1]/RXE.25.0[1]/ITEM[1]','Varchar(max)'),@HL7EncChars),
			   @GiveUnit =dbo.HL7_INBOUND_XFORM(T.item.value('RXE.26[1]/RXE.26.0[1]/ITEM[1]','Varchar(max)'),@HL7EncChars),
			   @SubStatus =dbo.HL7_INBOUND_XFORM(T.item.value('RXE.9[1]/RXE.9.0[1]/ITEM[1]','Varchar(max)'),@HL7EncChars),
			   @DispensingPharmacy =dbo.HL7_INBOUND_XFORM(T.item.value('RXE.40[1]/RXE.40.1[1]/ITEM[1]','Varchar(max)'),@HL7EncChars)
			From @InboundMessage.nodes('HL7Message/RXE') As T(item)	
			
		-- TQ1
		Select @Frequency = dbo.HL7_INBOUND_XFORM(T.item.value('TQ1.3[1]/TQ1.3.0[1]/ITEM[1]','Varchar(540)'),@HL7EncChars),
				@ExplicitTime = dbo.HL7_INBOUND_XFORM(T.item.value('TQ1.4[1]/TQ1.4.0[1]/ITEM[1]','Varchar(20)'),@HL7EncChars),
				@StartDateTime = dbo.HL7_INBOUND_XFORM(T.item.value('TQ1.7[1]/TQ1.7.0[1]/ITEM[1]','Varchar(20)'),@HL7EncChars),
				@EndDateTime = dbo.HL7_INBOUND_XFORM(T.item.value('TQ1.8[1]/TQ1.8.0[1]/ITEM[1]','Varchar(20)'),@HL7EncChars),
				@Dose=dbo.HL7_INBOUND_XFORM(T.item.value('TQ1.2[1]/TQ1.2.0[1]/ITEM[1]','nvarchar(max)'),@HL7EncChars),
				@DispensedPackageSizeUnit=dbo.HL7_INBOUND_XFORM(T.item.value('TQ1.2[1]/TQ1.2.1[1]/ITEM[1]','nvarchar(max)'),@HL7EncChars)
			From @InboundMessage.nodes('HL7Message/TQ1') As T(item)		
	
		
		
		Set @EntityType = 8747 -- GlobalCodeId for ClientOrders
		Set @EntityId = @ClientOrderId -- ClientOrderId.
		
		Exec SSP_SCInsertHL7CPQueueMessageLink @UserCode,@HL7CPQueueMessageID,@EntityType,@EntityId	
		
		Insert into InboundMedications(ClientOrderId,MessageControlId,DrugNDCCode,DrugNDCDescription,DrugCode,AlternateDrugNDCCode,AlternateDrugNDCDescription,AlternateDrugCode,DispensedDateTime,DispensedPackageSize,DispensedPackageSizeUnit,ExplicitTime,StartDateTime,EndDateTime,Route,Frequency,Dose,SpecialInstructions,GiveStrength,GiveUnit,SubStatus,DispensingPharmacy,ProviderPharmacyInstructions,InboundMedicationXml, EnteredBy, VerifiedBy)
		Values(@ClientOrderId,@MessageControlId,@DrugNDCCode,@DrugNDCDescription,@DrugCode,@AlternateDrugNDCCode,@AlternateDrugNDCDescription,@AlternateDrugCode,@DispensedDateTime,@DispensedPackageSize,@DispensedPackageSizeUnit,@ExplicitTime,@StartDateTime,@EndDateTime,@Route,@Frequency,@Dose,@SpecialInstructions,@GiveStrength,@GiveUnit,@SubStatus,@DispensingPharmacy,@ProviderPharmacyInstructions,@InboundMessage,@EnteredBy,@VerifiedBy)
		
		
		Declare @InboundMedicationId Int
		Set @InboundMedicationId= SCOPE_IDENTITY()
		IF ISNULL(@InboundMedicationId,0) >0
			BEGIN
				SET @OutputParamter=NULL
				SET @EntityType = 8748 -- GlobalCodeId for InboundMedications
				SET @EntityId = @InboundMedicationId -- @InboundMedicationId.
				EXEC SSP_SCInsertHL7CPQueueMessageLink @UserCode,@HL7CPQueueMessageID,@EntityType,@EntityId	
			END
		ELSE
			BEGIN
				SET @OutputParamter='Error while inserting in to InboundMedications.'
			END
			
	END TRY
	BEGIN CATCH
		--*****************************************************************************************
		-- Set error message for .NET program to capture
		--*****************************************************************************************
		 SET @OutputParamter= ERROR_MESSAGE()

		--*****************************************************************************************
		-- Log error
		--*****************************************************************************************
		 DECLARE @Error varchar(8000)                                                                      
		 SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                       
		 + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'SSP_SCProcessHL7_251_Order_InboundMessage')                                            
		 + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                        
		 + '*****' + Convert(varchar,ERROR_STATE())                                                                      
		 
		 Insert into ErrorLog (ErrorMessage, VerboseInfo, DataSetInfo, ErrorType, CreatedBy, CreatedDate)
		 values(@Error,NULL,NULL,'HL7 Procedure Error','SmartCare',GetDate()) 
		 
	END CATCH
END

GO


