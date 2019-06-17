
GO

/****** Object:  StoredProcedure [dbo].[ssp_GetDischargeInstructionComponentXMLString]    Script Date: 06/09/2015 00:50:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetDischargeInstructionComponentXMLString]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetDischargeInstructionComponentXMLString]
GO


GO

/****** Object:  StoredProcedure [dbo].[ssp_GetDischargeInstructionComponentXMLString]    Script Date: 06/09/2015 00:50:51 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

  
-- =============================================        
-- Author:  Pradeep        
-- Create date: Nov 07, 2014       
-- Description: Retrieves CCD Component XML for History of Present Illness     
/*        
 Author   Modified Date   Reason        
 Shankha        11/04/2014              Initial  
        
*/  
CREATE PROCEDURE [dbo].[ssp_GetDischargeInstructionComponentXMLString] @ServiceId INT = NULL  
 ,@ClientId INT = NULL 
 ,@DocumentVersionId INT = NULL  
 ,@OutputComponentXML VARCHAR(MAX) OUTPUT  
AS  
BEGIN  
 DECLARE @FinalComponentXML VARCHAR(MAX)
 DECLARE @DEFAULTCOMPONENTXML VARCHAR(MAX)  ='<component typeCode="COMP" contextConductionInd="true">
				<section classCode="DOCSECT" moodCode="EVN">
					<templateId root="2.16.840.1.113883.10.20.22.2.41"/>
					<code code="8653-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Hospital Discharge Instructions"/>
					<title>Hospital Discharge Instructions</title>
					<text>
						<paragraph>No Information Available</paragraph>
					</text>
				</section>
			</component>'
 DECLARE @PLACEHOLDERXML VARCHAR(MAX) = '<component typeCode="COMP" contextConductionInd="true">
				<section classCode="DOCSECT" moodCode="EVN">
					<templateId root="2.16.840.1.113883.10.20.22.2.41"/>
					<code code="8653-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Hospital Discharge Instructions"/>
					<title>Hospital Discharge Instructions</title>
					<text>
						###PARAGRAPH###
					</text>
				</section>
			</component>'  
 DECLARE @tResults TABLE (AnswerText VARCHAR(max))  
  
 IF @ServiceId IS NULL  
 BEGIN  
  INSERT INTO @tResults  
  EXEC ssp_RDLClinicalSummarydischargeInstruction NULL  
   ,@ClientId  
   ,@DocumentVersionId  
 END  
 ELSE  
 BEGIN  
  INSERT INTO @tResults  
  EXEC ssp_RDLClinicalSummarydischargeInstruction @ServiceId  
   ,@ClientId  
   ,@DocumentVersionId  
 END  
 DECLARE @tAnswerText VARCHAR(MAX)  
 
  IF EXISTS(SELECT * FROM @tResults)
 BEGIN  
  
 DECLARE tCursor CURSOR FAST_FORWARD  
 FOR  
 SELECT AnswerText  
 FROM @tResults TDS  
  
 OPEN tCursor  
  
 FETCH NEXT  
 FROM tCursor  
 INTO @tAnswerText  
  
 WHILE (@@FETCH_STATUS = 0)  
 BEGIN  
  SET @FinalComponentXML = REPLACE(@PLACEHOLDERXML, '###PARAGRAPH###', '<paragraph>' + @tAnswerText + '</paragraph>' )  
  FETCH NEXT  
  FROM tCursor  
  INTO @tAnswerText  
 END  
  
 CLOSE tCursor  
  
 DEALLOCATE tCursor  
 SET @OutputComponentXML =  @FinalComponentXML  
 END
 ELSE
 BEGIN
 SET @OutputComponentXML =  @DEFAULTCOMPONENTXML
 END
END  
GO

