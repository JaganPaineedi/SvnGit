/****** Object:  StoredProcedure [dbo].[SSP_GetHL7_MU_SegmentPID]    Script Date: 07/01/2016 02:27:57 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SSP_GetHL7_MU_SegmentPID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SSP_GetHL7_MU_SegmentPID]
GO

/****** Object:  StoredProcedure [dbo].[SSP_GetHL7_MU_SegmentPID]    Script Date: 07/01/2016 02:27:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


 CREATE PROCEDURE [dbo].[SSP_GetHL7_MU_SegmentPID]   
 @VendorId INT,  
 @ClientId INT,  
 @HL7EncodingChars nVarchar(5), 
 @Type CHAR,
 @DocumentVersionId INT = NULL, 
 @PIDSegmentRaw nVarchar(Max) Output  
AS  
--===========================================  
/*  
Declare @PIDSegmentRaw nVarchar(max)  
EXEC SSP_GetHL7_MU_SegmentPID 1,127683,'|^~\&','S',3314314,@PIDSegmentRaw Output  
Select @PIDSegmentRaw  
  
-- Jun-16-2016  Chethan N: Created.  
*/  
--===========================================  
BEGIN  
 BEGIN TRY  
  DECLARE @SegmentName VARCHAR(3)    
  DECLARE @SetId CHAR(1)  
  DECLARE @IntPatientId VARCHAR(20)  
  DECLARE @AlternatePatientId VARCHAR(20)  
  DECLARE @PatientName VARCHAR(48)  
  DECLARE @PatientBirthDate VARCHAR(26)  
  DECLARE @PatientGender CHAR(1)  
  DECLARE @PatientAddress VARCHAR(106)  
  DECLARE @PatientEpisodeNumber nVarchar(200)  
  DECLARE @OverrideSPName nVarchar(200)  
  
  DECLARE @AssigningAuthority VARCHAR(250)
  DECLARE @Race VARCHAR(MAX)
  DECLARE @Ethnicity VARCHAR(MAX)
  DECLARE @DeathInfo nVarchar(15)
  DECLARE @MotherName VARCHAR(250)
  DECLARE @PatientPhoneNumber VARCHAR(250)
  DECLARE @PatientEmailAdress VARCHAR(250)
  DECLARE @PhoneNumberandEmail VARCHAR(MAX)
  DECLARE @MultipleBirthIndicator CHAR = 'N' 
  DECLARE @BirthOrder CHAR = '1'
  DECLARE @InformationNotConfirmed CHAR

      
  -- pull out encoding characters  
  DECLARE @FieldChar char   
  DECLARE @CompChar char  
  DECLARE @RepeatChar char  
  DECLARE @EscChar char  
  DECLARE @SubCompChar char  
  EXEC SSP_SCGetHL7_EncChars @HL7EncodingChars, @FieldChar output, @CompChar output, @RepeatChar output, @EscChar output, @SubCompChar output  
  
  DECLARE @PIDSegment VARCHAR(500)  
    
  SET @SegmentName ='PID'  
  SET @AlternatePatientId =''  
  SET @SetId='1'  
    
  SELECT @OverrideSPName = StoredProcedureName  
  FROM HL7CPSegmentConfigurations  
  WHERE VendorId = @VendorId  
  AND SegmentType=@SegmentName  
  AND ISNULL(RecordDeleted,'N')='N'  
  
    
  SELECT @IntPatientId = dbo.HL7_OUTBOUND_XFORM(@ClientId, @HL7EncodingChars),  
      @PatientName = dbo.GetPatientNameForHL7(@ClientId, @HL7EncodingChars),  
      @PatientBirthDate =dbo.GetDateFormatForHL7(CL.DOB, @HL7EncodingChars),  
      @PatientGender = dbo.HL7_OUTBOUND_XFORM(ISNULL(CL.Sex,''), @HL7EncodingChars),  
      @PatientAddress = dbo.SSF_GetHL7_MU_PatientAddress(@ClientId, @HL7EncodingChars) ,  
      @PatientEpisodeNumber =  dbo.HL7_OUTBOUND_XFORM(ISNULL(EpisodeNumber,''), @HL7EncodingChars),
      @Race = dbo.SSF_GETHL7_MU_Race(@ClientId, @HL7EncodingChars),
      @Ethnicity = dbo.SSF_GETHL7_MU_Ethnicity(@ClientId, @HL7EncodingChars),
      @DeathInfo = dbo.SSF_GetHL7_MU_DeathInformation(@ClientId,@DocumentVersionId, @HL7EncodingChars),
      @MotherName = dbo.HL7_OUTBOUND_XFORM(ISNULL(CC.LastName,''), @HL7EncodingChars)+@CompChar+@CompChar+@CompChar+@CompChar+@CompChar+@CompChar+'M',
      @PatientEmailAdress = CASE WHEN CL.Email IS NOT NULL THEN '^NET^^' + dbo.HL7_OUTBOUND_XFORM(CL.Email, @HL7EncodingChars) ELSE '' END      
  FROM Clients CL  
  LEFT JOIN ClientEpisodes CE ON CL.ClientId = CE.ClientId AND CE.Status = 101 AND ISNULL(CE.RecordDeleted,'N')='N' 
  LEFT JOIN ClientContacts CC ON CC.ClientId = CL. ClientId AND ISNULL(CC.RecordDeleted,'N')='N'
  LEFT JOIN GlobalCodes GC ON GC.Category = 'RELATIONSHIP' AND GC.CodeName = 'Mother' AND CC.Relationship = GC.GlobalCodeId  AND ISNULL(GC.RecordDeleted,'N')='N' 
  WHERE  CL.ClientId = @ClientId  
  
  IF object_id('dbo.SCSP_GetHL7_MU_SegmentPID') IS NOT NULL
	BEGIN
		EXEC SCSP_GetHL7_MU_SegmentPID @ClientId , @InformationNotConfirmed OUTPUT, @MultipleBirthIndicator OUTPUT, @BirthOrder OUTPUT
	END

  IF (@Type = 'S')
  BEGIN
	IF (@InformationNotConfirmed = 'Y')
	BEGIN
		SET @PatientName = '~^^^^^^U'
	END
	ELSE
	BEGIN
		SET @PatientName = '~^^^^^^S'
	END
 
  SET @AssigningAuthority = dbo.SSF_GETHL7_MU_AssigningAuthority ('|^~\&' )
  END
  
  ELSE
  BEGIN
  IF(@MotherName='^^^^^^M')
  SET @MotherName=''
  SET @AssigningAuthority = 'NIST-MPI-1&2.16.840.1.113883.3.72.5.40.5&ISO^MR'
  
  SET @PatientPhoneNumber = dbo.SSF_GetHL7_MU_PatientPhoneNumber(@ClientId, @HL7EncodingChars)
  
  SET @PhoneNumberandEmail = @PatientPhoneNumber + CASE WHEN @PatientEmailAdress = '' THEN '' ELSE '~' + @PatientEmailAdress END
  END
  
  --SET @Race = @Race+'~2028-9^Asian^CDCREC~2076-8^Native Hawaiian or Other Pacific Islander^CDCREC'
  
  IF (@Type = 'S')
  BEGIN
  SET @PIDSegment = @SegmentName+@FieldChar+@SetId+@FieldChar+@FieldChar+@IntPatientId+@CompChar+@CompChar+@CompChar+@AssigningAuthority
	+@FieldChar+@FieldChar+@PatientName+@FieldChar+@FieldChar+@FieldChar+@PatientGender+@FieldChar+@FieldChar+@Race+@FieldChar
	+@PatientAddress+@FieldChar+@FieldChar+@FieldChar+@FieldChar+@FieldChar+@FieldChar+@FieldChar+@FieldChar+@FieldChar+@FieldChar
	+@FieldChar+@Ethnicity+ CASE WHEN @DeathInfo = '' THEN @DeathInfo ELSE @FieldChar+@FieldChar+@FieldChar+@FieldChar+@FieldChar+@FieldChar+@FieldChar+@DeathInfo END
  END
  ELSE
  BEGIN
    SET @PIDSegment = @SegmentName+@FieldChar+@SetId+@FieldChar+@FieldChar+@IntPatientId+@CompChar+@CompChar+@CompChar+@AssigningAuthority
	+@FieldChar+@FieldChar+@PatientName+@FieldChar+@MotherName+@FieldChar+@PatientBirthDate+@FieldChar+@PatientGender+@FieldChar+@FieldChar+@Race+@FieldChar
	+@PatientAddress+@FieldChar+@FieldChar+@PhoneNumberandEmail+@FieldChar+@FieldChar+@FieldChar+@FieldChar+@FieldChar+@FieldChar+@FieldChar+@FieldChar
	+@FieldChar+@Ethnicity+@FieldChar+@FieldChar+@MultipleBirthIndicator+@FieldChar+@BirthOrder+@FieldChar+@FieldChar+@FieldChar+@FieldChar+ CASE WHEN @DeathInfo = '' THEN @FieldChar+'N' ELSE @DeathInfo END 
  END
  
      
  SET @PIDSegmentRaw= ISNULL(RTRIM(LTRIM(@PIDSegment)),'')
 END TRY  
 BEGIN CATCH  
  DECLARE @Error varchar(8000)                                                                        
   SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                         
   + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'SSP_GetHL7_MU_SegmentPID')                                              
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


