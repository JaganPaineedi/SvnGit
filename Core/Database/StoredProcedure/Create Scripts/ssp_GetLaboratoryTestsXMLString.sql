/****** Object:  StoredProcedure [dbo].[ssp_GetLaboratoryTestsXMLString]    Script Date: 09/22/2017 18:05:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetLaboratoryTestsXMLString]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetLaboratoryTestsXMLString]
GO


/****** Object:  StoredProcedure [dbo].[ssp_GetLaboratoryTestsXMLString]    Script Date: 09/22/2017 18:05:49 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

  
CREATE PROCEDURE [dbo].[ssp_GetLaboratoryTestsXMLString] @ClientId INT = NULL    
 ,@Type VARCHAR(10) = NULL    
 ,@DocumentVersionId INT = NULL    
 ,@FromDate DATETIME = NULL    
 ,@ToDate DATETIME = NULL   
 ,@OutputComponentXML VARCHAR(MAX) OUTPUT 
-- =============================================                             
/*                  
 Author   Added Date   Reason   Task                  
 Vijay    05/09/2017   Initial  MUS3 - Task#25.4 Transition of Care - CCDA Generation    
*/ 
AS  
BEGIN  
 DECLARE @DefaultComponentXML VARCHAR(MAX) =  '<component>
		<section nullFlavor="NI">
			<!-- Results Section (entries required) (V3) -->
			<templateId root="2.16.840.1.113883.10.20.22.2.3.1" extension="2015-08-01"/>
			<templateId root="2.16.840.1.113883.10.20.22.2.3.1"/>
			<code code="30954-2" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="RESULTS"/>
			<title>RESULTS</title>
			<text>Laboratory Test: None needed. Laboratory Values/Results: No Lab Result data</text>
		</section>
	</component>'  
 DECLARE @FinalComponentXML VARCHAR(MAX)  
 DECLARE @PLACEHOLDERXML VARCHAR(MAX) = '<component>
		<section>
			<templateId root="2.16.840.1.113883.10.20.22.2.3.1"/>
			<!-- Entries Required -->
			<code code="30954-2" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="RESULTS"/>
			<title>RESULTS</title>
			<text>
				<table>
					<tbody>
						<tr>
							<td colspan="2">LABORATORY INFORMATION</td>
						</tr>
						<tr>
							<td colspan="2">Chemistries and drug levels</td>
						</tr>
						###TRSECTION###
					</tbody>
				</table>
			</text>
			###ENTRYSECTION###
		</section>
	</component>'  
 DECLARE @trXML VARCHAR(MAX) = '<tr>  
       <td><content ID="result_##ID##">##Element## (##Range##)</content></td>  
       <td>##ObservationValue##</td>  
    </tr>'  
 DECLARE @finalTR VARCHAR(MAX)  
  
 SET @finalTR = ''  
  
 DECLARE @entryXML VARCHAR(MAX) = '<entry typeCode="DRIV">
			<organizer classCode="BATTERY" moodCode="EVN">
				<!-- Result organizer template -->
				<templateId root="2.16.840.1.113883.10.20.22.4.1"/>
				<id root="7d5a02b0-67a4-11db-bd13-0800200c9a66"/>
				<code xsi:type="CE" code="##SNOMEDCode##" displayName="##OrderName##" codeSystem="2.16840.1.113883.6.96" codeSystemName="SNOMED CT"/>
				<statusCode code="##Status##"/>
				<component>
					<observation classCode="OBS" moodCode="EVN">
						<!-- Result observation template -->
						<templateId root="2.16.840.1.113883.10.20.22.4.2"/>
						<id root="107c2dc0-67a5-11db-bd13-0800200c9a66"/>
						<code xsi:type="CE" code="##LONICCode##" displayName="##Element##" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"> </code>
						<text>
							<reference value="#result_##ID##"/>
						</text>
						<statusCode code="##Status##"/>
						<effectiveTime value="##TestDate##"/>
						<value xsi:type="PQ" value="##ObservationValue##" unit="##Unit##"/>
						<interpretationCode code="##Flag##" codeSystem="2.16.840.1.113883.5.83"/>
						<methodCode/>
						<targetSiteCode/>
						<author>
							<time/>
							<assignedAuthor>
								<id root="2a620155-9d11-439e-92b3-5d9816ff4de8"/>
							</assignedAuthor>
						</author>
						<referenceRange>
							<observationRange>
								<text>##Range##</text>
							</observationRange>
						</referenceRange>
					</observation>
				</component>
			</organizer>
		</entry>'  
 DECLARE @finalEntry VARCHAR(MAX)
 SET @finalEntry = ''  
  
 DECLARE @loopCOUNT INT = 0  
 DECLARE @tResults TABLE (  
  [ClientId] INT  
  ,[OrderType] VARCHAR(250)  
  ,[OrderDate] DATETIME  
  ,[TestDate] DATETIME  
  ,[OrderDescription] VARCHAR(max)  
  ,[Element] VARCHAR(200)  
  ,[Result] VARCHAR(300)  
  ,[Flag] VARCHAR(200)  
  ,[OrderingPractitioner] VARCHAR(60)  
  ,[LONICCode] VARCHAR(200)  
  ,[Unit] VARCHAR(200)  
  ,[Range] VARCHAR(400)  
  ,OrderName varchar(500)  
  ,[Status] varchar(250)  
  ,[ObservationValue] varchar(200)  
  ,[SNOMEDCode] varchar(500)  
  )  
  
 INSERT INTO @tResults  
  EXEC ssp_GetLaboratoryTests NULL  
   ,@Type   
   ,@DocumentVersionId   
   ,@FromDate   
   ,@ToDate  
   ,NULL  
  
 DECLARE @tTestDate VARCHAR(100) = ''  
 DECLARE @tElement VARCHAR(200) = ''  
 DECLARE @tResult VARCHAR(300) = ''  
 DECLARE @tLONICCode VARCHAR(200) = ''  
 DECLARE @tUnit VARCHAR(200) = ''  
 DECLARE @tFlag VARCHAR(200) = ''     
 DECLARE @tRange VARCHAR(400) = ''  
 DECLARE @tOrderName VARCHAR(500) = ''  
 DECLARE @tStatus VARCHAR(250) = ''  
 DECLARE @tObservationValue VARCHAR(200) = ''  
 DECLARE @tSNOMEDCode VARCHAR(500) = ''  
   
 IF EXISTS (  
   SELECT *  
   FROM @tResults  
   )  
 BEGIN  
  DECLARE tCursor CURSOR FAST_FORWARD  
  FOR  
  SELECT [TestDate]  
   ,[Element]  
   ,[Result]  
   ,[LONICCode]  
   ,[Unit]  
   ,[Flag]  
   ,[Range]  
   ,[OrderName]  
   ,[Status]  
   ,[ObservationValue]  
   ,[SNOMEDCode]  
  FROM @tResults TDS  
  
  OPEN tCursor  
  
  FETCH NEXT  
  FROM tCursor  
  INTO @tTestDate  
   ,@tElement  
   ,@tResult  
   ,@tLONICCode  
   ,@tUnit  
   ,@tFlag  
   ,@tRange  
   ,@tOrderName  
   ,@tStatus  
   ,@tObservationValue  
   ,@tSNOMEDCode  
  
  WHILE (@@FETCH_STATUS = 0)  
  BEGIN  
   SET @finalTR = @finalTR + @trXML  
   SET @finalEntry = @finalEntry + @entryXML  
   SET @finalTR = REPLACE(@finalTR, '##ID##', @loopCOUNT)  
   SET @finalTR = REPLACE(@finalTR, '##Element##', ISNULL(@tElement, 'UNK'))  
   SET @finalTR = REPLACE(@finalTR, '##Result##', ISNULL(@tResult, 'UNK'))  
   SET @finalTR = REPLACE(@finalTR, '##ObservationValue##', ISNULL(@tObservationValue, 'UNK'))  
   SET @finalTR = REPLACE(@finalTR, '##Range##', ISNULL(@tRange, 'UNK'))  
        
   SET @finalEntry = REPLACE(@finalEntry, '##ID##', @loopCOUNT)   
   SET @finalEntry = REPLACE(@finalEntry, '##TestDate##', convert(VARCHAR(max), convert(DATETIME, @tTestDate), 112))  
   SET @finalEntry = REPLACE(@finalEntry, '##Element##', ISNULL(@tElement, 'UNK'))  
   SET @finalEntry = REPLACE(@finalEntry, '##Result##', ISNULL(@tResult, 'UNK'))  
   SET @finalEntry = REPLACE(@finalEntry, '##LONICCode##', ISNULL(@tLONICCode, 'UNK'))  
   SET @finalEntry = REPLACE(@finalEntry, '##Unit##', ISNULL(@tUnit, 'UNK'))  
   SET @finalEntry = REPLACE(@finalEntry, '##Flag##', ISNULL(@tFlag, 'UNK'))  
   SET @finalEntry = REPLACE(@finalEntry, '##Range##', ISNULL(@tRange, 'UNK'))  
   SET @finalEntry = REPLACE(@finalEntry, '##OrderName##', ISNULL(@tOrderName, 'UNK'))  
   SET @finalEntry = REPLACE(@finalEntry, '##Status##', ISNULL(@tStatus, 'UNK'))  
   SET @finalEntry = REPLACE(@finalEntry, '##ObservationValue##', ISNULL(@tObservationValue, 'UNK'))  
   SET @finalEntry = REPLACE(@finalEntry, '##SNOMEDCode##', ISNULL(@tSNOMEDCode, 'UNK'))  
   SET @loopCOUNT = @loopCOUNT + 1  
  
   PRINT @finalTR  
   PRINT @finalEntry  
  
   FETCH NEXT  
   FROM tCursor  
   INTO @tTestDate  
    ,@tElement  
    ,@tResult  
    ,@tLONICCode  
    ,@tUnit  
    ,@tFlag  
    ,@tRange  
    ,@tOrderName  
    ,@tStatus  
    ,@tObservationValue  
    ,@tSNOMEDCode  
  END  
  
  CLOSE tCursor  
  
  DEALLOCATE tCursor  
  
  SET @FinalComponentXML = REPLACE(@PLACEHOLDERXML, '###TRSECTION###', @finalTR)  
  SET @FinalComponentXML = REPLACE(@FinalComponentXML, '###ENTRYSECTION###', @finalEntry)  
  SET @OutputComponentXML = @FinalComponentXML  
 END  
 ELSE  
 BEGIN  
  SET @OutputComponentXML = @DefaultComponentXML  
 END  
  
END  
  
GO


