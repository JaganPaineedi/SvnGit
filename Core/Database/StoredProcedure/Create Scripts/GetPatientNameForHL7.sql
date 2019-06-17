/****** Object:  UserDefinedFunction [dbo].[GetPatientNameForHL7]    Script Date: 06/21/2016 13:04:20 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetPatientNameForHL7]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[GetPatientNameForHL7]
GO

/****** Object:  UserDefinedFunction [dbo].[GetPatientNameForHL7]    Script Date: 06/21/2016 13:04:20 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 CREATE FUNCTION [dbo].[GetPatientNameForHL7](@ClientId Int,@HL7EncodingChars nVarchar(5))  
RETURNS nVarchar(250)  
BEGIN  
DECLARE @PatientName nvarchar(250)  
  
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
   
 SELECT @PatientName= dbo.HL7_OUTBOUND_XFORM(ISNULL(CL.LastName,''),@HL7EncodingChars)+@CompChar+dbo.HL7_OUTBOUND_XFORM(ISNULL(CL.FirstName,''),@HL7EncodingChars)  
 +@CompChar+dbo.HL7_OUTBOUND_XFORM(ISNULL(CL.MiddleName,''),@HL7EncodingChars)+@CompChar+@CompChar+@CompChar+@CompChar+'L' from   
 Clients CL Where CL.ClientId=@ClientId  
 RETURN ISNULL(@PatientName,'')  
END  
GO


