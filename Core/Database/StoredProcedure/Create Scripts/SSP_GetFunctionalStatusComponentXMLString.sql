
GO

/****** Object:  StoredProcedure [dbo].[ssp_GetFunctionalStatusComponentXMLString]    Script Date: 06/09/2015 00:51:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetFunctionalStatusComponentXMLString]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetFunctionalStatusComponentXMLString]
GO


GO

/****** Object:  StoredProcedure [dbo].[ssp_GetFunctionalStatusComponentXMLString]    Script Date: 06/09/2015 00:51:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




-- =============================================            
-- Author:  Pradeep            
-- Create date: Nov 07, 2014           
-- Description: Retrieves CCD Component XML for Functional Status      
/*            
 Author   Modified Date   Reason            
 Shankha        11/04/2014              Initial      
            
*/
CREATE PROCEDURE [dbo].[ssp_GetFunctionalStatusComponentXMLString] @ServiceId INT = NULL
	,@ClientId INT = NULL
	,@DocumentVersionId INT = NULL
	,@OutputComponentXML VARCHAR(MAX) OUTPUT
AS
BEGIN
	DECLARE @FinalComponentXML VARCHAR(MAX)
	DECLARE @PLACEHOLDERXML VARCHAR(MAX) = '<component typeCode="COMP" contextConductionInd="true">
	<section classCode="DOCSECT" moodCode="EVN">
	<templateId root="2.16.840.1.113883.10.20.22.2.14"/>
	<code code="47420-5" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Functional Status"/>   
	<title>Functional Status</title>
	<text>###PARAGRAPH###</text>  
 	###ENTRYFORMEMORY###
 	###ENTRYFORCANE###
 	###ENTRYFORNOIMPAIRMENT###  
 	</section>
 	</component>'
 	
	DECLARE @DEFAULTCOMPONENTXML VARCHAR(MAX) = '<component typeCode="COMP" contextConductionInd="true">  
  <section classCode="DOCSECT" moodCode="EVN">  
    <templateId root="2.16.840.1.113883.10.20.22.2.14"/>  
    <code code="47420-5" codeSystem="2.16.840.1.113883.6.1"  
 codeSystemName="LOINC" displayName="Functional Status"/>  
    <title>Functional Status</title>  
    <text>No Information Available</text>    
  </section>  
</component>'

	DECLARE @ENTRYNODEXMLFORCANE VARCHAR(MAX) = '<entry typeCode="DRIV">
            <observation classCode="OBS" moodCode="EVN">
              <templateId root="2.16.840.1.113883.10.20.22.4.68"/>
              <id root="ab1791b0-5c71-11db-b0de-0800200c9a66"/>
              <code xsi:type="CE" code="409586006" codeSystem="2.16.840.1.113883.6.96" displayName="Complaint"/>
              <statusCode code="completed"/>
			  <effectiveTime>
                <low value="20141202"/>
              </effectiveTime>
              <value xsi:type="CD" code="105504002" codeSystem="2.16.840.1.113883.6.96" displayName="Dependence on Walking Stick"/>
            </observation>
          </entry>'
          
	DECLARE @ENTRYNODEXMLFORMEMORY VARCHAR(MAX) = '<entry typeCode="DRIV">
            <observation classCode="OBS" moodCode="EVN">
              <templateId root="2.16.840.1.113883.10.20.22.4.68"/>
              <id root="ab1791b0-5c71-11db-b0de-0800200c9a66"/>
              <code xsi:type="CE" code="409586006" codeSystem="2.16.840.1.113883.6.96" displayName="Complaint"/>
              <statusCode code="completed"/>
              <effectiveTime>
                <low value="20141202"/>
              </effectiveTime>
              <value xsi:type="CD" code="386807006" codeSystem="2.16.840.1.113883.6.96" displayName="Memory Impairment"/>
            </observation>
          </entry>'
          
    DECLARE @ENTRYNODEXMLFORNOIMPAIRMENT VARCHAR(MAX) = '<entry typeCode="DRIV">
            <observation classCode="OBS" moodCode="EVN">
              <templateId root="2.16.840.1.113883.10.20.22.4.68"/>
              <id root="ab1791b0-5c71-11db-b0de-0800200c9a66"/>
              <code xsi:type="CE" code="409586006" codeSystem="2.16.840.1.113883.6.96" displayName="Complaint"/>
              <statusCode code="completed"/>
              <effectiveTime>
                <low value="20141202"/>
              </effectiveTime>
              <value xsi:type="CD" code="66557003" codeSystem="2.16.840.1.113883.6.96" displayName="No Impairment"/>
            </observation>
          </entry>'      
	DECLARE @PARA VARCHAR(MAX), @ENTRY VARCHAR(MAX)

	SET @PARA = ''
	SET @ENTRY = ''

	DECLARE @tResults TABLE (
		ClientId INT
		,OrderId INT
		,FunctionalStatus VARCHAR(max)
		)

	IF @ServiceId IS NULL
	BEGIN
		INSERT INTO @tResults
		EXEC ssp_RDLClinicalSummaryfunctionalInstruction NULL
			,@ClientId
			,@DocumentVersionId
	END
	ELSE
	BEGIN
		INSERT INTO @tResults
		EXEC ssp_RDLClinicalSummaryfunctionalInstruction @ServiceId
			,@ClientId
			,@DocumentVersionId
	END

	DECLARE @tFunctionalStatus VARCHAR(MAX)

	IF EXISTS (
			SELECT *
			FROM @tResults
			)
	BEGIN
		DECLARE tCursor CURSOR FAST_FORWARD
		FOR
		SELECT FunctionalStatus
		FROM @tResults TDS

		OPEN tCursor

		FETCH NEXT
		FROM tCursor
		INTO @tFunctionalStatus

		WHILE (@@FETCH_STATUS = 0)
		BEGIN
			SET @PARA = @PARA + '<paragraph>Functional and Cognitive Status:' + ISNULL(@tFunctionalStatus, '') + '</paragraph>'
			--print @tFunctionalStatus
			
			IF CHARINDEX('stick', @tFunctionalStatus) > 0
			BEGIN
				SET @PLACEHOLDERXML = REPLACE(@PLACEHOLDERXML, '###ENTRYFORCANE###', @ENTRYNODEXMLFORCANE)
			END

			IF CHARINDEX('Memory', @tFunctionalStatus) > 0
			BEGIN
				SET @PLACEHOLDERXML= REPLACE(@PLACEHOLDERXML, '###ENTRYFORMEMORY###', @ENTRYNODEXMLFORMEMORY)
			END
			
			IF CHARINDEX('No impairment', @tFunctionalStatus) > 0
			BEGIN
				SET @PLACEHOLDERXML= REPLACE(@PLACEHOLDERXML, '###ENTRYFORNOIMPAIRMENT###', @ENTRYNODEXMLFORNOIMPAIRMENT)
			END
			--print @PLACEHOLDERXML
			
			FETCH NEXT
			FROM tCursor
			INTO @tFunctionalStatus
		END

		CLOSE tCursor

		DEALLOCATE tCursor

		SET @FinalComponentXML = REPLACE(@PLACEHOLDERXML, '###PARAGRAPH###', @PARA)
		SET @FinalComponentXML = REPLACE(@FinalComponentXML, '###ENTRYFORMEMORY###', '')
		SET @FinalComponentXML = REPLACE(@FinalComponentXML, '###ENTRYFORCANE###', '')
		SET @FinalComponentXML = REPLACE(@FinalComponentXML, '###ENTRYFORNOIMPAIRMENT###', '')
		
		print @FinalComponentXML
		SET @OutputComponentXML = @FinalComponentXML
	END
	ELSE
	BEGIN
		SET @OutputComponentXML = @DEFAULTCOMPONENTXML
	END
END


GO

