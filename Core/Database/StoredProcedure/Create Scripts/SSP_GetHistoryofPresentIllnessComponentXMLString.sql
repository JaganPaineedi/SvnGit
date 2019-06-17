
GO

/****** Object:  StoredProcedure [dbo].[ssp_GetHistoryofPresentIllnessComponentXMLString]    Script Date: 06/09/2015 00:51:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetHistoryofPresentIllnessComponentXMLString]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetHistoryofPresentIllnessComponentXMLString]
GO


GO

/****** Object:  StoredProcedure [dbo].[ssp_GetHistoryofPresentIllnessComponentXMLString]    Script Date: 06/09/2015 00:51:40 ******/
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
CREATE PROCEDURE [dbo].[ssp_GetHistoryofPresentIllnessComponentXMLString] @ServiceId INT = NULL  
 ,@ClientId INT = NULL  
 ,@DocumentVersionId INT = NULL  
 ,@OutputComponentXML VARCHAR(MAX) OUTPUT  
AS  
BEGIN  
 DECLARE @FinalComponentXML VARCHAR(MAX)
 DECLARE @DEFAULTCOMPONENTXML VARCHAR(MAX)  =' <component>
        <section>
          <templateId root="1.3.6.1.4.1.19376.1.5.3.1.3.4"/>
          <id root="2.201" extension="HistoryOfPresentIllness"/>
          <code code="10164-2" displayName="HISTORY OF PRESENT ILLNESS" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
          <title>History Of Present Illness</title>
          <text>
            <paragraph>
              No Information Available
            </paragraph>
          </text>
        </section>
      </component>'
 DECLARE @PLACEHOLDERXML VARCHAR(MAX) = '<component>  
 <section>  
  <templateId root="1.3.6.1.4.1.19376.1.5.3.1.3.4"/>  
  <id root="2.201" extension="HistoryOfPresentIllness"/>  
  <code code="10164-2" displayName="HISTORY OF PRESENT ILLNESS" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>  
  <title>History Of Present Illness</title>  
  <text>  
   ###PARAGRAPH###  
  </text>  
 </section>  
</component>'  
 DECLARE @tResults TABLE (CCDReasonForVisit VARCHAR(max))  
  
 IF @ServiceId IS NULL  
 BEGIN  
  INSERT INTO @tResults  
  EXEC ssp_RDLClinicalSummaryReasonForVisit NULL  
   ,@ClientId  
   ,@DocumentVersionId  
 END  
 ELSE  
 BEGIN  
  INSERT INTO @tResults  
  EXEC ssp_RDLClinicalSummaryReasonForVisit @ServiceId  
   ,@ClientId  
   ,@DocumentVersionId  
 END  
 DECLARE @tReasonforVisit VARCHAR(MAX)  
 
  IF EXISTS(SELECT * FROM @tResults)
 BEGIN  
  
 DECLARE tCursor CURSOR FAST_FORWARD  
 FOR  
 SELECT CCDReasonForVisit  
 FROM @tResults TDS  
  
 OPEN tCursor  
  
 FETCH NEXT  
 FROM tCursor  
 INTO @tReasonforVisit  
  
 WHILE (@@FETCH_STATUS = 0)  
 BEGIN  
  SET @FinalComponentXML = REPLACE(@PLACEHOLDERXML, '###PARAGRAPH###', '<paragraph>' + @tReasonforVisit + '</paragraph>' )  
  FETCH NEXT  
  FROM tCursor  
  INTO @tReasonforVisit  
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

