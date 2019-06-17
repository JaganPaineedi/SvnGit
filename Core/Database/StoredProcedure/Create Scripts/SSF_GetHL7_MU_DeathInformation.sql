/****** Object:  UserDefinedFunction [dbo].[SSF_GetHL7_MU_DeathInformation]    Script Date: 06/28/2016 15:55:21 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SSF_GetHL7_MU_DeathInformation]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[SSF_GetHL7_MU_DeathInformation]
GO

/****** Object:  UserDefinedFunction [dbo].[SSF_GetHL7_MU_DeathInformation]    Script Date: 06/28/2016 15:55:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


 CREATE FUNCTION [dbo].[SSF_GetHL7_MU_DeathInformation](@ClientId INT,
 @DocumentVersionId INT, @HL7EncodingChars nVarchar(5))  
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
   
 DECLARE @DeathInfo nVarchar(20) 
 DECLARE @DeathDateTime VARCHAR(15)  

 
 SET @DeathDateTime = (
		SELECT TOP 1 CONVERT(VARCHAR(8), DeathDateTime, 112) + REPLACE(LEFT(CAST(DeathDateTime AS TIME), 5), ':', '')
		FROM DocumentSyndromicSurveillances DSS
		WHERE DSS.DocumentVersionId = @DocumentVersionId
			AND ISNULL(DSS.RecordDeleted, 'N') = 'N'
		)

 SET @DeathInfo = CASE 
		WHEN ISNULL(@DeathDateTime, '') = ''
			THEN ''
		ELSE @DeathDateTime + @FieldChar + 'Y'
		END

 
 RETURN ISNULL(RTRIM(LTRIM(@DeathInfo)),'')  
 
END  

GO


