
GO

/****** Object:  StoredProcedure [dbo].[ssp_GetReasonForVisitComponentXMLString]    Script Date: 06/09/2015 00:52:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetReasonForVisitComponentXMLString]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetReasonForVisitComponentXMLString]
GO


GO

/****** Object:  StoredProcedure [dbo].[ssp_GetReasonForVisitComponentXMLString]    Script Date: 06/09/2015 00:52:51 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

  
-- =============================================        
-- Author:  Naveen P.        
-- Create date: Nov 07, 2014       
-- Description: Retrieves CCD Component XML for Reason for Visit  
/*        
 Author   Modified Date   Reason        
 Naveen        11/07/2014              Initial  
*/   
-- =============================================         
CREATE PROCEDURE [dbo].[ssp_GetReasonForVisitComponentXMLString]    
    @ServiceId INT = NULL,  
    @ClientId INT  = NULL ,  
    @DocumentVersionId INT = NULL,  
    @OutputComponentXML VARCHAR(MAX) OUTPUT   
AS   
BEGIN  
 DECLARE @DefaultComponentXML VARCHAR(MAX)='<component>  
        <section>  
          <templateId root="1.3.6.1.4.1.19376.1.5.3.1.3.1"/>  
          <id root="2.201" extension="ReferralReason"/>  
          <code code="42349-1" displayName="REASON FOR VISIT/HOSPITALIZATION" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>  
          <title>Reason For Visit/Hospitalization</title>  
          <text>  
            <table border="1" width="100%">  
              <thead>  
                <tr>  
                  <th>Reason For Visit/Hospitalization</th>  
                </tr>  
              </thead>  
              <tbody>  
                <tr>  
                  <td colspan="1">  
                    <content ID="UnknownReferral" xmlns="urn:hl7-org:v3">No Information Available</content>  
                  </td>  
                </tr>  
              </tbody>  
            </table>  
          </text>  
        </section>  
      </component>'  
 DECLARE @ComponentXMLTemplate VARCHAR(MAX) =   
  '<component>  
   <section>  
    <templateId root="2.16.840.1.113883.10.20.22.2.12"/>  
    <id root="2.201" extension="ReasonForVisit"/>  
    <code code="29299-5" displayName="REASON FOR VISIT/HOSPITALIZATION" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>  
    <title>Reason For Visit/Hospitalization</title>  
    <text>  
     <paragraph>###ReasonForVisit###</paragraph>  
    </text>  
   </section>  
  </component>'  
  
 CREATE TABLE #TempReasonForVisit (     
  ReasonForVisit varchar(max)  
 )  
   
 DECLARE @Reason varchar(max)  
   
 IF @ServiceId IS NULL  
 BEGIN  
  INSERT INTO #TempReasonForVisit   
   EXEC ssp_RDLClinicalSummaryReasonForVisit NULL, @ClientId, @DocumentVersionId  
 END  
 ELSE  
 BEGIN  
   INSERT INTO #TempReasonForVisit   
   EXEC ssp_RDLClinicalSummaryReasonForVisit @ServiceId, @ClientId, @DocumentVersionId  
 END  
 IF EXISTS(select * from #TempReasonForVisit)  
 BEGIN  
 DECLARE #ReasonForVisitCursor CURSOR FAST_FORWARD  
 FOR  
  SELECT  ReasonForVisit  
  FROM    #TempReasonForVisit  
   
 OPEN #ReasonForVisitCursor  
 FETCH #ReasonForVisitCursor INTO @Reason  
  
 --SELECT * FROM #TempReasonForVisit  
 --SELECT @Reason Reason  
  
 CLOSE #ReasonForVisitCursor  
 DEALLOCATE #ReasonForVisitCursor  
 DROP TABLE #TempReasonForVisit  
  
 DECLARE @ComponentXML VARCHAR(MAX)  
 SET @ComponentXML = Replace(@ComponentXMLTemplate, '###ReasonForVisit###', @Reason)  
   
 SET @OutputComponentXML = @ComponentXML  
 END  
   
 ELSE  
 BEGIN  
 SET @OutputComponentXML =@DefaultComponentXML  
 END   
END  
GO

