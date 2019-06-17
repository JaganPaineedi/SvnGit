
/****** Object:  StoredProcedure [dbo].[SSP_SCGetHL7_251_SegmentPV1]    Script Date: 04/29/2015 11:04:24 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SSP_SCGetHL7_251_SegmentPV1]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SSP_SCGetHL7_251_SegmentPV1]
GO

/****** Object:  StoredProcedure [dbo].[SSP_SCGetHL7_251_SegmentPV1]    Script Date: 04/29/2015 11:04:24 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[SSP_SCGetHL7_251_SegmentPV1] 
	@VendorId INT,
	@ClientId INT,
	@HL7EncodingChars nVarchar(5),
	@PV1SegmentRaw nVarchar(Max) Output
AS
--===========================================
/*
Declare @PV1SegmentRaw nVarchar(max)
EXEC SSP_SCGetHL7_251_SegmentPV1 1,24,'|^~\&',@PV1SegmentRaw Output
Select @PV1SegmentRaw
*/
/*
	29th Apr  2015          Shankha				Modified logic to process overrided SP Login Why : Task#236,Philhaven Development 		 */

--===========================================
BEGIN
	BEGIN TRY
		DECLARE @SegmentName VARCHAR(3)
		DECLARE @SetId nVarchar(4)
		DECLARE @PatientClass VARCHAR(1)
		DECLARE @AssignedPatientLocation VARCHAR(40)
		
		-- pull out encoding characters
		DECLARE @FieldChar char 
		DECLARE @CompChar char
		DECLARE @RepeatChar char
		DECLARE @EscChar char
		DECLARE @SubCompChar char
		EXEC SSP_SCGetHL7_EncChars @HL7EncodingChars, @FieldChar output, @CompChar output, @RepeatChar output, @EscChar output, @SubCompChar output
		
				
		DECLARE @OverrideSPName nVarchar(200)
		DECLARE @PV1Segment nVARCHAR(max)
		SET @SegmentName = 'PV1'
		SET @SetId='1'
		SET @PatientClass ='I' -- Always 'I'(Inpatient)
		
		SELECT @OverrideSPName = StoredProcedureName
		FROM HL7CPSegmentConfigurations
		WHERE VendorId = @VendorId
		AND SegmentType=@SegmentName
		AND ISNULL(RecordDeleted,'N')='N'
		
		SELECT @AssignedPatientLocation= dbo.GetAssignedPatientLocationForHL7Trun(@ClientId,@HL7EncodingChars)		
		
		-- add the facility as the Group Code
		DECLARE @ReceivingFacility nVarchar(227)
		SELECT @ReceivingFacility=dbo.HL7_OUTBOUND_XFORM(ISNULL(ReceivingFacility,''),@HL7EncodingChars)
		FROM HL7CPVendorConfigurations
		WHERE VendorId=@VendorId
		
		IF ISNULL(@ReceivingFacility,'') != ''
			BEGIN
				-- valid facility set it, but first check if have to add beginning field separators if assigned patient location empty
				IF ISNULL(@AssignedPatientLocation,'') = ''
					BEGIN
						Set @AssignedPatientLocation = @CompChar+@CompChar
					END
					
				Set @AssignedPatientLocation = @AssignedPatientLocation + @CompChar + @ReceivingFacility
			END
		
		SET @PV1Segment=@SegmentName+@FieldChar+Convert(nVarchar(4),@SetId)+@FieldChar+@PatientClass+@FieldChar+ISNULL(@AssignedPatientLocation,'')
		-- add 46 more separators
		DECLARE @cntr int =0
		WHILE @cntr < 46 BEGIN
			SET @cntr = @cntr + 1
			Set @PV1Segment=@PV1Segment + @FieldChar			
		END
		
		IF ISNULL(@OverrideSPName,'') !='' 
			BEGIN
			--Pass the resulting string and modify in the Override SP.						
				DECLARE @OutputString nVarchar(max)
				DECLARE @SPName nvarchar(max)
						
				DECLARE @ParamDef nvarchar(max)				
				DECLARE @StartingString nVarchar(max) -- starting string to work with for override sp
				--SET @StartingString = ''				
				SET @SPName='EXEC '+@OverrideSPName+' @VendorId,@ClientId,@HL7EncodingChars,@OutputString OUTPUT'
				SET @ParamDef = N'@VendorId int, @ClientId int,@HL7EncodingChars nVarchar(5),@OutputString nvarchar(max) OUTPUT'	
				EXECUTE sp_executesql @SPName,@ParamDef,@VendorId,@ClientId,@HL7EncodingChars,@OutputString OUTPUT
				
				PRINT 'I AM HERE'
				SET @PV1Segment=@OutputString
			END				
		SET @PV1SegmentRaw= @PV1Segment
	END TRY
	BEGIN CATCH
		DECLARE @Error varchar(8000)                                                                      
		 SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                       
		 + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'SSP_SCGetHL7_251_SegmentPV1')                                            
		 + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                        
		 + '*****' + Convert(varchar,ERROR_STATE())                                                                      
		                                                                
		 Insert into ErrorLog (ErrorMessage, VerboseInfo, DataSetInfo, ErrorType, CreatedBy, CreatedDate)
		 values(@Error,NULL,NULL,'HL7 Procedure Error','SmartCare',GetDate())    
		                                                                         
		 RAISERROR                                                                       
		 (                                                            
		 @Error, -- Message text.                                                                      
		 16, -- Severity.                                                                      
		 1 -- State.                                                                      
		 );  
	END CATCH
END

GO


