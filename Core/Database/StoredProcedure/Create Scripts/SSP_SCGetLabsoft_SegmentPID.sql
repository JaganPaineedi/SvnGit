/****** Object:  StoredProcedure [dbo].[SSP_SCGetLabsoft_SegmentPID]    Script Date: 09/06/2015 17:41:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SSP_SCGetLabsoft_SegmentPID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SSP_SCGetLabsoft_SegmentPID]
GO


/****** Object:  StoredProcedure [dbo].[SSP_SCGetLabsoft_SegmentPID]    Script Date: 09/06/2015 17:41:05 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[SSP_SCGetLabsoft_SegmentPID] 
	@ClientId INT,
	@EncodingChars nVarchar(5),
	@PIDSegmentRaw nVarchar(Max) Output
AS
/*
-- ================================================================  
-- Stored Procedure: SSP_SCGetLabsoft_SegmentPID  
-- Create Date : Sep 09 2015 
-- Purpose : Get PID Segment for Labsoft  
-- Created By : Gautam  
	declare @PIDSegmentRaw nVarchar(max)
	exec SSP_SCGetLabsoft_SegmentPID 2, '|^~\&' ,@PIDSegmentRaw Output
	select @PIDSegmentRaw
-- ================================================================  
-- History --  

-- ================================================================  
*/

BEGIN
	BEGIN TRY
		DECLARE @SegmentName VARCHAR(3)		
		DECLARE @PatientId VARCHAR(20)
		DECLARE @PatientName VARCHAR(48)
		DECLARE @PatientBirthDate VARCHAR(26)
		DECLARE @PatientGender CHAR(1)
		DECLARE @PatientAddress VARCHAR(106)
		DECLARE @PatientSocSecNo nVarchar(75)
		DECLARE @PatientCity VARCHAR(50)
		DECLARE @PIDSegment VARCHAR(500)
		DECLARE @PatientState VARCHAR(2)
		DECLARE @PatientZip VARCHAR(15)
		DECLARE @HomePhone VARCHAR(30)
		DECLARE @WorkPhone VARCHAR(30)
		
		-- pull out encoding characters
		DECLARE @FieldChar char 
		DECLARE @CompChar char
		DECLARE @RepeatChar char
		DECLARE @EscChar char
		DECLARE @SubCompChar char
		EXEC SSP_SCGetLabSoft_EncChars @EncodingChars, @FieldChar output, @CompChar output, @RepeatChar output, @EscChar output, @SubCompChar output

		SET @SegmentName ='PID'
		
		SELECT Top 1 @PatientId = dbo.GetParseLabSoft_OUTBOUND_XFORM(@ClientId, @EncodingChars),
			   @PatientName = dbo.GetPatientNameForLabSoft(@ClientId, @EncodingChars),
			   @PatientBirthDate =CONVERT(VARCHAR(10), CL.DOB, 112) ,
			   @PatientGender = dbo.GetParseLabSoft_OUTBOUND_XFORM(ISNULL(CL.Sex,''), @EncodingChars),
			   @PatientAddress = dbo.GetParseLabSoft_OUTBOUND_XFORM(ISNULL(CA.Address,''),@EncodingChars)	,
			   @PatientSocSecNo = 	dbo.GetParseLabSoft_OUTBOUND_XFORM(ISNULL(CL.SSN,''), @EncodingChars),
			   @PatientCity=dbo.GetParseLabSoft_OUTBOUND_XFORM(ISNULL(CA.City,''),@EncodingChars),
			   @PatientState= dbo.GetParseLabSoft_OUTBOUND_XFORM(ISNULL(CA.State,''),@EncodingChars),
			   @PatientZip=  dbo.GetParseLabSoft_OUTBOUND_XFORM(ISNULL(CA.Zip,''),@EncodingChars),
			   @HomePhone=case when CP.PhoneType = 30 then PhoneNumber else '' end,
			   @WorkPhone=case when CP.PhoneType = 31 then PhoneNumber else '' end
		FROM Clients CL 
		 Left Join ClientAddresses CA On CL.ClientId=CA.ClientId AND CA.AddressType= 90 --Home
						AND ISNULL(CA.RecordDeleted,'N')='N'
		 Left Join ClientPhones CP On CL.ClientId=CP.ClientId 
					AND ISNULL(CP.RecordDeleted,'N')='N'
		WHERE  CL.ClientId = @ClientId AND ISNULL(CL.RecordDeleted,'N')='N'
        
        IF ISNULL(@PatientGender,'')=''  or ISNULL(@PatientBirthDate,'')=''  
			Begin
				SET @PIDSegmentRaw=null
			End
		Else
			Begin
				set @PatientState = case when @PatientState is not null and @PatientState<>'' then substring(@PatientState,1,2) else '' end
		
				SET @PIDSegment =@SegmentName+@FieldChar+@PatientId+@FieldChar+@PatientName +@FieldChar +@FieldChar + ISNULL(@PatientGender,'') +
					@FieldChar +@PatientBirthDate+@FieldChar+ ISNULL(@PatientSocSecNo,'')+@FieldChar+ISNULL(@PatientAddress,'') +
					@FieldChar + ISNULL(@PatientCity,'') + @FieldChar + ISNULL(@PatientState,'') + @FieldChar + ISNULL(@PatientZip,'') + @FieldChar +
					ISNULL(@HomePhone,'') + @FieldChar + ISNULL(@WorkPhone,'')
		
				SET @PIDSegmentRaw= @PIDSegment
			END
	END TRY
	BEGIN CATCH
		DECLARE @Error varchar(8000)                                                                      
		 SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                       
		 + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'SSP_SCGetLabsoft_SegmentPID')                                            
		 + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                        
		 + '*****' + Convert(varchar,ERROR_STATE())                                                                      
		                                                                
		 Insert into ErrorLog (ErrorMessage, VerboseInfo, DataSetInfo, ErrorType, CreatedBy, CreatedDate)
		 values(@Error,NULL,NULL,'LabSoft Procedure Error','SmartCare',GetDate())    
		                                                                         
		 RAISERROR                                                                       
		 (                                                            
		 @Error, -- Message text.                                                                      
		 16, -- Severity.                                                                      
		 1 -- State.                                                                      
		 );  
	END CATCH
END

GO

