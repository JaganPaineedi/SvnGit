/****** Object:  UserDefinedFunction [dbo].[GetRequestGiveCodeForHL7]    Script Date: 02/11/2016 15:14:11 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetRequestGiveCodeForHL7]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[GetRequestGiveCodeForHL7]
GO

/****** Object:  UserDefinedFunction [dbo].[GetRequestGiveCodeForHL7]    Script Date: 02/11/2016 15:14:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 CREATE FUNCTION [dbo].[GetRequestGiveCodeForHL7] (  
 @MedicationId INT  
 ,@ClientOrderId INT  
 ,@HL7EncodingChars NVARCHAR(5)  
 )  
RETURNS VARCHAR(max)  
  
BEGIN  
 DECLARE @Identifier VARCHAR(100)  
 DECLARE @Text VARCHAR(100)  
 -- pull hl7 esc chars   
 DECLARE @FieldChar CHAR  
 DECLARE @CompChar CHAR  
 DECLARE @RepeatChar CHAR  
 DECLARE @EscChar CHAR  
 DECLARE @SubCompChar CHAR  
 DECLARE @DispenseBrand CHAR(1)
  
 SET @FieldChar = SUBSTRING(@HL7EncodingChars, 1, 1)  
 SET @CompChar = SUBSTRING(@HL7EncodingChars, 2, 1)  
 SET @RepeatChar = SUBSTRING(@HL7EncodingChars, 3, 1)  
 SET @EscChar = SUBSTRING(@HL7EncodingChars, 4, 1)  
 SET @SubCompChar = SUBSTRING(@HL7EncodingChars, 5, 1)  
  
 SELECT @Identifier = REPLACE(OS.PreferredNDC, '-', ''),
 @DispenseBrand= CO.DispenseBrand ,
 @Text = O.AlternateOrderName2 
 FROM ClientOrders CO  
 JOIN Orders O ON O.OrderId = CO.OrderId
 INNER JOIN OrderStrengths OS ON CO.MedicationOrderStrengthId = OS.OrderStrengthId  
 WHERE CO.ClientOrderId = @ClientOrderId  
  
 IF (ISNULL(@DispenseBrand,'N')= 'N')
 BEGIN
 SELECT @Text = mdm.MedicationDescription  
 FROM MDMedications mdm  
 INNER JOIN (  
  SELECT ClinicalFormulationId  
   ,MAX(md.NationalDrugCode) NDC  
  FROM MDDrugs AS md  
  WHERE ISNULL(md.recorddeleted, 'N') = 'N'  
   AND md.ObsoleteDate IS NULL  
  GROUP BY md.clinicalFormulationId  
  ) AS drg ON drg.ClinicalFormulationId = mdm.ClinicalFormulationId  
 WHERE ISNULL(mdm.recorddeleted, 'N') = 'N'  
  AND mdm.MedicationId = @MedicationID  
  END
 
 RETURN ISNULL(@Identifier, '') + @CompChar + ISNULL(@Text, '') + @CompChar  
END  
GO


