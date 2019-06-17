/****** Object:  UserDefinedFunction [dbo].[SSF_GetHL7_MU_PatientPhoneNumber]    Script Date: 06/16/2016 12:50:15 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SSF_GetHL7_MU_PatientPhoneNumber]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[SSF_GetHL7_MU_PatientPhoneNumber]
GO


/****** Object:  UserDefinedFunction [dbo].[SSF_GetHL7_MU_PatientPhoneNumber]    Script Date: 06/16/2016 12:50:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 CREATE FUNCTION [dbo].[SSF_GetHL7_MU_PatientPhoneNumber](@ClientId INT,@HL7EncodingChars nVarchar(5))  
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
   
 DECLARE @PatientPhoneNumber nVarchar(250)   
 
SET @PatientPhoneNumber = STUFF((
			SELECT '~' + @CompChar + CASE CP.PhoneType
					WHEN 30
						THEN 'PRN'
					WHEN 31
						THEN 'WPN'
					WHEN 34
						THEN 'CP'
					ELSE 'ORN'
					END + @CompChar + 'PH' + @CompChar + @CompChar + @CompChar + SUBSTRING(PhoneNumber, 2, CHARINDEX(')', PhoneNumber) - 2) + @CompChar + REPLACE(SUBSTRING(PhoneNumber, CHARINDEX(')', PhoneNumber) + 2, LEN(PhoneNumber)), '-', '')
			FROM ClientPhones CP
			WHERE CP.ClientId = @ClientId
				AND CP.ClientPhoneId IN (
					SELECT ClientPhoneId
					FROM ClientPhones CP
					JOIN Clients C ON C.ClientId = CP.ClientId
					WHERE CP.ClientId = @ClientId
						AND ISNULL(CP.RecordDeleted, 'N') = 'N'
					)
			--AND CP.IsPrimary = 'Y'  
			FOR XML PATH('')
			), 1, 1, '')


			
			
 RETURN ISNULL(RTRIM(LTRIM(@PatientPhoneNumber)),'')  
 
 
 -- dbo.HL7_OUTBOUND_XFORM(ISNULL(CA.Address,''),@HL7EncodingChars)+@CompChar+@CompChar+dbo.HL7_OUTBOUND_XFORM(ISNULL(CA.City,''),@HL7EncodingChars)  
 --+@CompChar+dbo.HL7_OUTBOUND_XFORM(ISNULL(S.StateFIPS,''),@HL7EncodingChars)+@CompChar+dbo.HL7_OUTBOUND_XFORM(ISNULL(CA.Zip,''),@HL7EncodingChars)
 --+@CompChar+'USA'+@CompChar+@CompChar+@CompChar+dbo.HL7_OUTBOUND_XFORM(ISNULL(C.CountyOfResidence,''),@HL7EncodingChars)
END  
GO


