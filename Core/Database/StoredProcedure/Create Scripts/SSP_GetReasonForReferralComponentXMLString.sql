
GO

/****** Object:  StoredProcedure [dbo].[ssp_GetReasonForReferralComponentXMLString]    Script Date: 06/09/2015 00:52:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetReasonForReferralComponentXMLString]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetReasonForReferralComponentXMLString]
GO


GO

/****** Object:  StoredProcedure [dbo].[ssp_GetReasonForReferralComponentXMLString]    Script Date: 06/09/2015 00:52:43 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================              
-- Author:  Naveen P.              
-- Create date: Nov 07, 2014             
-- Description: Retrieves CCD Component XML for Reason for Referral        
/*              
 Author   Modified Date   Reason              
 Naveen        11/07/2014              Initial        
*/
-- =============================================               
CREATE PROCEDURE [dbo].[ssp_GetReasonForReferralComponentXMLString] @ServiceId INT = NULL
	,@ClientId INT = NULL
	,@DocumentVersionId INT = NULL
	,@OutputComponentXML VARCHAR(MAX) OUTPUT
AS
BEGIN
	DECLARE @ComponentXMLTemplate VARCHAR(MAX) = '<component>        
   <section>        
    <templateId root="1.3.6.1.4.1.19376.1.5.3.1.3.1"/>        
    <id root="2.201" extension="ReferralReason"/>        
    <code code="42349-1" displayName="REASON FOR REFERRAL" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>        
    <title>Reason For Referral</title>        
    <text>        
     <table border="1" width="100%">        
      <thead>        
       <tr>        
        <th>Reason For Referral</th>        
       </tr>        
      </thead>        
      <tbody>###TBodyRows###</tbody>        
     </table>        
    </text>        
   </section>        
  </component>'
	DECLARE @DEFAULTCOMPONENTXML VARCHAR(MAX) = 
		'<component>      
        <section>      
          <templateId root="1.3.6.1.4.1.19376.1.5.3.1.3.1"/>      
          <id root="2.201" extension="ReferralReason"/>      
          <code code="42349-1" displayName="REASON FOR REFERRAL" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>      
          <title>Reason For Referral</title>      
          <text>      
            <table border="1" width="100%">      
              <thead>      
                <tr>      
                  <th>Reason For Referral</th>      
                </tr>      
              </thead>      
              <tbody>      
                <tr>      
                  <td colspan="1">      
                    <content ID="UnknownReferral1" xmlns="urn:hl7-org:v3">No Information Available</content>      
                  </td>      
                </tr>      
              </tbody>      
            </table>      
          </text>      
        </section>      
      </component>'
	DECLARE @RowXMLTemplate VARCHAR(MAX) = '<tr>        
   <td colspan="1">        
    <content ID="UnknownReferral2" xmlns="urn:hl7-org:v3">###Reason###</content>        
   </td>        
  </tr>'

	CREATE TABLE #TempReasonsForReferral (
		Reason VARCHAR(max)
		,Provider VARCHAR(max)
		,PhoneNumber VARCHAR(max)
		,Address VARCHAR(max)
		,Comment VARCHAR(max)
		)

	IF @ServiceId IS NULL
	BEGIN
		INSERT INTO #TempReasonsForReferral
		EXEC ssp_RDLTransitionCareSummaryReasonForReferral NULL
			,@ClientId
			,@DocumentVersionId
	END
	ELSE
	BEGIN
		INSERT INTO #TempReasonsForReferral
		EXEC ssp_RDLTransitionCareSummaryReasonForReferral @ServiceId
			,@ClientId
			,@DocumentVersionId
	END

	IF EXISTS (
			SELECT *
			FROM #TempReasonsForReferral
			)
	BEGIN
		DECLARE #ReasonsForReferralCursor CURSOR FAST_FORWARD
		FOR
		SELECT Reason
			,Provider
			,Address
			,Comment
		FROM #TempReasonsForReferral

		OPEN #ReasonsForReferralCursor

		DECLARE @RowsXML VARCHAR(MAX) = ''
		DECLARE @Reason VARCHAR(max)
		DECLARE @ProviderName VARCHAR(MAX) = ''
		DECLARE @Address VARCHAR(MAX) = ''
		DECLARE @Comment VARCHAR(MAX) = ''
		
		DECLARE @FINALREASON VARCHAR(MAX) = ''
		

		FETCH NEXT
		FROM #ReasonsForReferralCursor
		INTO @Reason
			,@ProviderName
			,@Address
			,@Comment

		WHILE @@fetch_status = 0
		BEGIN
			SET @FINALREASON = ISNULL(@Reason, '') + ISNULL('<br/>Provider:' + @ProviderName, '') + ISNULL('<br/>Address:' + @Address, '')
			SET @FINALREASON = @FINALREASON + ISNULL('<br/>Comments:' +@Comment, '')
			
			SET @RowsXML = @RowsXML + Replace(@RowXMLTemplate, '###Reason###', @FINALREASON)

			FETCH NEXT
			FROM #ReasonsForReferralCursor
			INTO @Reason
				,@ProviderName
				,@Address
				,@Comment
		END

		--SELECT * FROM #TempReasonsForReferral        
		--SELECT @RowsXML RowsXML        
		CLOSE #ReasonsForReferralCursor

		DEALLOCATE #ReasonsForReferralCursor

		DROP TABLE #TempReasonsForReferral

		DECLARE @ComponentXML VARCHAR(MAX)

		SET @ComponentXML = Replace(@ComponentXMLTemplate, '###TBodyRows###', @RowsXML)
		SET @OutputComponentXML = @ComponentXML
	END
	ELSE
	BEGIN
		SET @OutputComponentXML = @DEFAULTCOMPONENTXML
	END
END

GO

