
GO

/****** Object:  StoredProcedure [dbo].[ssp_GetClinicalInstructionComponentXMLString]    Script Date: 06/09/2015 00:50:15 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetClinicalInstructionComponentXMLString]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetClinicalInstructionComponentXMLString]
GO


GO

/****** Object:  StoredProcedure [dbo].[ssp_GetClinicalInstructionComponentXMLString]    Script Date: 06/09/2015 00:50:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

  
-- =============================================        
-- Author:  Pradeep        
-- Create date: Nov 07, 2014       
-- Description: Retrieves CCD Component XML for Medications Administered   
/*        
 Author   Modified Date   Reason        
 Shankha        11/04/2014              Initial  
        
*/  
CREATE PROCEDURE [dbo].[ssp_GetClinicalInstructionComponentXMLString] @ServiceId INT = NULL  
 ,@ClientId INT = NULL  
 ,@DocumentVersionId INT = NULL  
 ,@OutputComponentXML VARCHAR(MAX) OUTPUT  
AS  
BEGIN  
DECLARE @DefaultComponentXML VARCHAR(MAX)='<component>  
        <section>  
          <templateId root="2.16.840.1.113883.10.20.22.2.45"/>  
          <id root="2.201" extension="Instructions"/>  
          <code code="69730-0" displayName="INSTRUCTIONS" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>  
          <title>Instructions</title>  
          <text>  
            <table border="1" width="100%">  
              <thead>  
                <tr>  
                  <th>Date</th>  
                  <th>Instruction</th>  
                  <th>Additional Information</th>  
                </tr>  
              </thead>  
              <tbody>  
                <tr>  
                  <td colspan="3">  
                    <content ID="PatientInstruction_0" xmlns="urn:hl7-org:v3">No Information Available</content>  
                  </td> 
                </tr>  
              </tbody>  
            </table>  
          </text>  
          <entry>  
            <act moodCode="INT" classCode="ACT">  
              <templateId root="2.16.840.1.113883.10.20.22.4.20"/>  
              <id root="2.201" extension="2601fd62-f0f4-454f-b72b-204bf612b6c6"/>  
              <code code="423564006" displayName="No Information Available" codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED CT"/>  
              <text>  
                <reference value="#PatientInstruction_0"/>  
              </text>  
              <statusCode code="completed"/>  
              <effectiveTime>  
                <low value="20141107"/>  
              </effectiveTime>  
            </act>  
          </entry>  
        </section>  
      </component>'  
 DECLARE @COMPONENTXML VARCHAR(MAX) = '<component>  
 <section>  
  <templateId root="2.16.840.1.113883.10.20.22.2.45"/>  
  <id root="2.201" extension="Instructions"/>  
  <code code="69730-0" displayName="INSTRUCTIONS" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>  
  <title>Instructions</title>  
  <text>  
   <table border="1" width="100%">  
    <thead>  
     <tr>  
      <th>Date</th>  
      <th>Instruction</th>  
      <th>Additional Information</th>  
     </tr>  
    </thead>  
    <tbody>  
     ###TR###  
    </tbody>  
   </table>  
  </text>  
  ###ENTRY###  
 </section>  
</component>'  
 DECLARE @TRXML VARCHAR(MAX) = ''  
 DECLARE @ENTRYXML VARCHAR(MAX) = ''  
 DECLARE @ENTRYXMLTEMPLATE VARCHAR(MAX) = '<entry>  
 <act moodCode="INT" classCode="ACT">  
  <templateId root="2.16.840.1.113883.10.20.22.4.20"/>  
  <id root="2.201" extension="2601fd62-f0f4-454f-b72b-204bf612b6c6"/>  
  <code code="423564006" displayName="###CLINICALINSTRUCTION###" codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED CT"/>  
  <text>  
   <reference value="#PatientInstruction_###ID###"/>  
  </text>  
  <statusCode code="completed"/>  
  <effectiveTime>  
   <low value="###CLINICALINSTRUCTIONDATE###"/>  
  </effectiveTime>  
 </act>  
</entry>'  
 DECLARE @tResults TABLE (  
  CCDClinicalInstruction VARCHAR(max)  
  ,CCDCreatedDate DATETIME  
  ,CCDAdditionalInformation VARCHAR(max)  
  )  
  
 IF @ServiceId IS NULL  
 BEGIN  
  INSERT INTO @tResults  
  EXEC ssp_RDLClinicalSummaryClinicalInstruction NULL  
   ,@ClientId  
   ,@DocumentVersionId  
 END  
 ELSE  
 BEGIN  
  INSERT INTO @tResults  
  EXEC ssp_RDLClinicalSummaryClinicalInstruction NULL  
   ,@ClientId  
   ,@DocumentVersionId  
 END  
 DECLARE @tCCDClinicalInstruction VARCHAR(MAX)  
 DECLARE @tCCDAdditionalInformation VARCHAR(MAX)  
 DECLARE @tCCDCreatedDate DATETIME  
 DECLARE @loopCOUNT INT = 0  
 IF EXISTS(select * from @tResults)  
 BEGIN  
 DECLARE tCursor CURSOR FAST_FORWARD  
 FOR  
 SELECT CCDCreatedDate  
  ,CCDClinicalInstruction  
  ,CCDAdditionalInformation  
 FROM @tResults TDS  
  
 OPEN tCursor  
  
 FETCH NEXT  
 FROM tCursor  
 INTO @tCCDCreatedDate  
  ,@tCCDClinicalInstruction  
  ,@tCCDAdditionalInformation  
  
 WHILE (@@FETCH_STATUS = 0)  
 BEGIN  
  SET @TRXML = @TRXML + '<tr>'  
  SET @TRXML = @TRXML + '<td>' + ISNULL(CONVERT(VARCHAR(25), @tCCDCreatedDate, 112), '') + '</td>'  
  SET @TRXML = @TRXML + '<td><content ID="PatientInstruction_'+ Convert(varchar(2), @loopCOUNT) + '" xmlns="urn:hl7-org:v3">' + isnull(@tCCDClinicalInstruction, '') + '</content></td>'  
  SET @TRXML = @TRXML + '<td>' + isnull(@tCCDAdditionalInformation, '') + '</td>'  
  SET @TRXML = @TRXML + '</tr>'  
    
  SET @ENTRYXMLTEMPLATE = REPLACE(@ENTRYXMLTEMPLATE, '###CLINICALINSTRUCTION###', @tCCDClinicalInstruction)  
  SET @ENTRYXMLTEMPLATE = REPLACE(@ENTRYXMLTEMPLATE, '###CLINICALINSTRUCTIONDATE###', ISNULL(CONVERT(VARCHAR(25), @tCCDCreatedDate, 112), ''))  
  SET @ENTRYXMLTEMPLATE = REPLACE(@ENTRYXMLTEMPLATE, '###ID###', @loopCOUNT)  
    
  SET @ENTRYXML = @ENTRYXML + @ENTRYXMLTEMPLATE  
  
  
  FETCH NEXT  
  FROM tCursor  
  INTO @tCCDCreatedDate  
   ,@tCCDClinicalInstruction  
   ,@tCCDAdditionalInformation  
 END  
  
 CLOSE tCursor  
 DEALLOCATE tCursor  
  
 SET @COMPONENTXML = REPLACE(@COMPONENTXML, '###TR###', @TRXML)  
 SET @COMPONENTXML = REPLACE(@COMPONENTXML, '###ENTRY###', @ENTRYXML)  
 SET @OutputComponentXML = @COMPONENTXML  
 END  
 ELSE  
 BEGIN  
 SET @OutputComponentXML =@DefaultComponentXML  
 END   
END  
GO

