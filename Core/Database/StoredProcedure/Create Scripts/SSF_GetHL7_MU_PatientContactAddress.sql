/****** Object:  UserDefinedFunction [dbo].[SSF_GetHL7_MU_PatientContactAddress]    Script Date: 06/16/2016 12:50:15 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SSF_GetHL7_MU_PatientContactAddress]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[SSF_GetHL7_MU_PatientContactAddress]
GO


/****** Object:  UserDefinedFunction [dbo].[SSF_GetHL7_MU_PatientContactAddress]    Script Date: 06/16/2016 12:50:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--Select dbo.SSF_GetHL7_MU_PatientContactAddress (43148,'|^~\&')

 CREATE FUNCTION [dbo].[SSF_GetHL7_MU_PatientContactAddress](@ClientContactId INT,@HL7EncodingChars nVarchar(5))  
RETURNS nVarchar(250)  
BEGIN  
 -- pull hl7 esc chars   
 DECLARE @FieldChar char   
 DECLARE @CompChar char  
 DECLARE @RepeatChar char  
 DECLARE @EscChar char  
 DECLARE @SubCompChar char  
   
 SET @FieldChar  = SUBSTRING(@HL7EncodingChars,1,1)  
 SET @CompChar  = SUBSTRING(@HL7EncodingChars,2,1)  
 SET @RepeatChar  = SUBSTRING(@HL7EncodingChars,3,1)  
 SET @EscChar  = SUBSTRING(@HL7EncodingChars,4,1)  
 SET @SubCompChar = SUBSTRING(@HL7EncodingChars,5,1)  
   
 DECLARE @PatientContactAddress nVarchar(250)  
 
 --SELECT @PatientAddress=dbo.HL7_OUTBOUND_XFORM(ISNULL(CA.Address,''),@HL7EncodingChars)+'^^'+dbo.HL7_OUTBOUND_XFORM(ISNULL(CA.City,''),@HL7EncodingChars)  
 --+@CompChar+dbo.HL7_OUTBOUND_XFORM(ISNULL(CA.State,''),@HL7EncodingChars)+@CompChar+dbo.HL7_OUTBOUND_XFORM(ISNULL(CA.Zip,''),@HL7EncodingChars)  
 --FROM ClientAddresses CA  
 --WHERE CA.ClientId=@ClientId  
 --AND CA.AddressType= 90 --Home  
 
 SELECT @PatientContactAddress=dbo.HL7_OUTBOUND_XFORM(ISNULL(RTRIM(LTRIM(CA.Address)),''),@HL7EncodingChars)+@CompChar+@CompChar+dbo.HL7_OUTBOUND_XFORM(ISNULL(RTRIM(LTRIM(CA.City)),''),@HL7EncodingChars)  
 +@CompChar+dbo.HL7_OUTBOUND_XFORM(ISNULL(S.StateFIPS,''),@HL7EncodingChars)+@CompChar+dbo.HL7_OUTBOUND_XFORM(ISNULL(RTRIM(LTRIM(CA.Zip)),''),@HL7EncodingChars)
 +@CompChar+'USA'+@CompChar+ CASE CA.AddressType WHEN 90 THEN 'P' WHEN 91 THEN 'O' ELSE 'C' END
 FROM ClientContactAddresses CA  
 LEFT JOIN States S ON S.StateAbbreviation = CA.State
 WHERE CA.ClientContactId=@ClientContactId  
 AND CA.AddressType= 90 --Home  
 
 RETURN ISNULL(RTRIM(LTRIM(@PatientContactAddress)),'')  
END  
GO


