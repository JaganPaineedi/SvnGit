/****** Object:  StoredProcedure [dbo].[ssp_GetActiveProblemsXMLString]    Script Date: 09/22/2017 18:48:26 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetActiveProblemsXMLString]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetActiveProblemsXMLString]
GO


/****** Object:  StoredProcedure [dbo].[ssp_GetActiveProblemsXMLString]    Script Date: 09/22/2017 18:48:26 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_GetActiveProblemsXMLString] @ClientId INT = NULL    
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
 DECLARE @DefaultComponentXML VARCHAR(MAX) =   
	 '<component>
		<section>
			<!--  *** Problem Section (entries required) (V3) *** -->
			<templateId root="2.16.840.1.113883.10.20.22.2.5.1" extension="2015-08-01"/>
			<templateId root="2.16.840.1.113883.10.20.22.2.5.1"/>
			<code code="11450-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="PROBLEM LIST"/>
			<title>PROBLEMS</title>
			<text ID="Concern_1">
				<content ID="problems1">
					No known <content ID="problemType1">health problems</content>
				</content>
			</text>
			<entry typeCode="DRIV">
				<!-- Problem Concern Act -->
				<act classCode="ACT" moodCode="EVN">
					<!-- ** Problem Concern Act (V3) ** -->
					<templateId root="2.16.840.1.113883.10.20.22.4.3" extension="2015-08-01" />
					<templateId root="2.16.840.1.113883.10.20.22.4.3" />
					<id root="36e3e930-7b14-11db-9fe1-0835200c9a66"/>
					<!-- SDWG supports 48765-2 or CONC in the code element -->
					<code code="CONC" codeSystem="2.16.840.1.113883.5.6"/>
					<text>
						<reference value="#Concern_1"></reference>
					</text>
					<statusCode code="active"/>
					<!-- The concern is not active, in terms of there being an active condition to be managed.-->
					<effectiveTime>
						<low value="20150722"/>
						<!-- Time at which THIS “concern” began being tracked.-->
					</effectiveTime>
					<!-- status is active so high is not applicable. If high is present it should have nullFlavor of NA-->
					<entryRelationship typeCode="SUBJ">
						<!-- Model of Meaning for No Problems -->
						<!-- The use of negationInd corresponds with the newer Observation.ValueNegationInd -->
						<!-- The negationInd = true negates the value element. -->
						<!-- problem observation template -->
						<observation classCode="OBS" moodCode="EVN" negationInd="true">
							<!-- ** Problem observation  (V3)** -->
							<templateId root="2.16.840.1.113883.10.20.22.4.4" extension="2015-08-01"/>
							<templateId root="2.16.840.1.113883.10.20.22.4.4"/>
							<id root="4adc1021-7b14-11db-9fe1-0836200c9a67"/>
							<!-- updated for R2.1 -db -->
							<code code="55607006" displayName="Problem" codeSystemName="SNOMED-CT" codeSystem="2.16.840.1.113883.6.96">
								<!-- This code SHALL contain at least one [1..*] translation, which SHOULD be selected from ValueSet Problem Type (LOINC) -->
								<translation code="75326-9" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Problem"/>
							</code>
							<text>
								<reference value="#problems1"></reference>
							</text>
							<statusCode code="completed"/>
							<!-- The time when this was biologically relevant ie True for the patient. -->
							<!-- As a minimum time interval over which this is true, populate the effectiveTime/low with the current time. -->
							<!-- It would be equally valid to have a longer range of time over which this statement was represented as being true. -->
							<!-- As a maximum, you would never indicate an effectiveTime/high that was greater than the current point in time. -->
							<effectiveTime>
								<low value="20150722"/>
							</effectiveTime>
							<!-- This idea assumes that the value element could come from the Problem value set, or-->
							<!-- when negationInd was true, is could also come from the ProblemType value set (and code would be ASSERTION). -->
							<value xsi:type="CD" code="55607006" displayName="Problem" codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED-CT">
								<originalText>
									<reference value="#problems1"></reference>
								</originalText>
							</value>
						</observation>
					</entryRelationship>
				</act>
			</entry>
		</section>
	</component>'  
 DECLARE @FinalComponentXML VARCHAR(MAX)  
 DECLARE @PLACEHOLDERXML VARCHAR(MAX) = '<component>  
	 <section>  
		<templateId root="2.16.840.1.113883.10.20.22.2.5.1"/>  
		<code code="11450-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="PROBLEM LIST"/>  
		<title>PROBLEMS</title>  
		<text><content ID="problems"/>  
			<list listType="ordered">           
				###LISTITEMSECTION###            
			</list>  
		</text>           
		###ENTRYSECTION###            
	 </section>            
   </component>'  
 DECLARE @listXML VARCHAR(MAX) = '<item><content ID="problem_##ID##">##Description## : Status - ##Status##</content></item>'  
 DECLARE @finalList VARCHAR(MAX)  
 SET @finalList = ''  
  
 DECLARE @entryXML VARCHAR(MAX) =   
    '<entry typeCode="DRIV">
		<act classCode="ACT" moodCode="EVN">
			<!-- Problem act template -->
			<templateId root="2.16.840.1.113883.10.20.22.4.3"/>
			<id root="ec8a6ff8-ed4b-4f7e-82c3-e98e58b45de7"/>
			<code code="CONC" codeSystem="2.16.840.1.113883.5.6" displayName="Concern"/>
			<statusCode code="completed"/>
			<effectiveTime>
				<low value="##EffectiveDate##"/>
				<high value="##EffectiveDate##"/>
			</effectiveTime>
			<entryRelationship typeCode="SUBJ">
				<observation classCode="OBS" moodCode="EVN">
					<!-- Problem observation template -->
					<templateId root="2.16.840.1.113883.10.20.22.4.4"/>
					<id root="ab1791b0-5c71-11db-b0de-0800200c9a66"/>
					<code code="409586006" codeSystem="2.16.840.1.113883.6.96" displayName="Complaint"/>
					<text>
						<reference value="#problem_##ID##"/>
					</text>
					<statusCode code="completed"/>
					<effectiveTime>
						<low value="##EffectiveDate##"/>
					</effectiveTime>
					<value xsi:type="CD" code="##SNOMED##" codeSystem="2.16.840.1.113883.6.96" displayName="##Description##"/>
					<entryRelationship typeCode="REFR">
						<observation classCode="OBS" moodCode="EVN">
							<!-- Problem observation template -->
							<templateId root="2.16.840.1.113883.10.20.22.4.68"/>
							<id root="ab1791b0-5c71-11db-b0de-0800200c9a66"/>
							<code code="409586006" codeSystem="2.16.840.1.113883.6.96" displayName="Complaint"/>
							<text>
								<reference value="#problem_##ID##"/>
							</text>
							<statusCode code="completed"/>
							<effectiveTime>
								<low value="##EffectiveDate##"/>
							</effectiveTime>
							<value xsi:type="CD" code="##SNOMED##" codeSystem="2.16.840.1.113883.6.96" displayName="##Description##"/>
						</observation>
					</entryRelationship>
					<entryRelationship typeCode="SUBJ" inversionInd="true">
						<observation classCode="OBS" moodCode="EVN">
							<templateId root="2.16.840.1.113883.10.20.22.4.31"/>
							<!--    Age observation template   -->
							<code code="445518008" codeSystem="2.16.840.1.113883.6.96" displayName="Age At Onset"/>
							<statusCode code="completed"/>
							<value xsi:type="PQ" value="##Age##" unit="a"/>
						</observation>
					</entryRelationship>
					<entryRelationship typeCode="REFR">
						<observation classCode="OBS" moodCode="EVN">
							<templateId root="2.16.840.1.113883.10.20.22.4.5"/>
							<!-- Health status observation template -->
							<code xsi:type="CE" code="11323-3" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Health status"/>
							<text>
								<reference value="#problems"/>
							</text>
							<statusCode code="completed"/>
							<value xsi:type="CD" code="##SNOMED##" codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED CT" displayName="Severly Ill"/>
						</observation>
					</entryRelationship>
					<entryRelationship typeCode="REFR">
						<observation classCode="OBS" moodCode="EVN">
							<!-- Status observation template -->
							<templateId root="2.16.840.1.113883.10.20.22.4.6"/>
							<code xsi:type="CE" code="33999-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Status"/>
							<text>
								<reference value="#problem_##ID##"/>
							</text>
							<statusCode code="completed"/>
							<value xsi:type="CD" code="55561003" codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED CT" displayName="Active"/>
						</observation>
					</entryRelationship>
				</observation>
			</entryRelationship>
		</act>
	</entry>'  
 DECLARE @finalEntry VARCHAR(MAX)
 SET @finalEntry = ''  
  
 DECLARE @loopCOUNT INT = 0  
 DECLARE @tResults TABLE (  
  [ClientId] INT  
  ,[ICD9Code] VARCHAR(20)  
  ,[ICD10Code] VARCHAR(20)  
  ,[SNOMED] VARCHAR(20)  
  ,[Description] VARCHAR(max)  
  ,[ClinicalStatus] VARCHAR(100)  
  ,[EffectiveDate] DATETIME  
  ,[Age] VARCHAR(20)  
  )  
  
 INSERT INTO @tResults  
  EXEC ssp_GetActiveProblems NULL  
   ,@Type   
   ,@DocumentVersionId   
   ,@FromDate   
   ,@ToDate  
   ,NULL  
  
 DECLARE @tICD9Code VARCHAR(MAX) = ''  
 DECLARE @tICD10Code VARCHAR(MAX) = ''  
 DECLARE @tSNOMED VARCHAR(MAX) = ''  
 DECLARE @tDescription VARCHAR(100) = ''  
 DECLARE @tClinicalStatus VARCHAR(100) = ''   
 DECLARE @tEffectiveDate VARCHAR(100) = ''  
 DECLARE @tAge VARCHAR(20) = ''  
   
 IF EXISTS (  
   SELECT *  
   FROM @tResults  
   )  
 BEGIN  
  DECLARE tCursor CURSOR FAST_FORWARD  
  FOR  
  SELECT [ICD9Code]  
   ,[ICD10Code]  
   ,[SNOMED]  
   ,[Description]  
   ,[ClinicalStatus]  
   ,[EffectiveDate]  
   ,[Age]  
  FROM @tResults TDS  
  
  OPEN tCursor  
  
  FETCH NEXT  
  FROM tCursor  
  INTO @tICD9Code  
   ,@tICD10Code  
   ,@tSNOMED  
   ,@tDescription  
   ,@tClinicalStatus  
   ,@tEffectiveDate  
   ,@tAge  
    
  WHILE (@@FETCH_STATUS = 0)  
  BEGIN  
   SET @finalList = @finalList + @listXML  
   SET @finalEntry = @finalEntry + @entryXML  
   SET @finalList = REPLACE(@finalList, '##ID##', @loopCOUNT)  
   SET @finalList = REPLACE(@finalList, '##Description##', ISNULL(@tDescription, 'UNK'))  
   SET @finalList = REPLACE(@finalList, '##Status##', ISNULL(@tClinicalStatus, 'UNK'))  
        
   SET @finalEntry = REPLACE(@finalEntry, '##ID##', @loopCOUNT)   
   SET @finalEntry = REPLACE(@finalEntry, '##Description##', ISNULL(@tDescription, 'UNK'))     
   SET @finalEntry = REPLACE(@finalEntry, '##ICD9Code##', ISNULL(@tICD9Code, 'UNK'))  
   SET @finalEntry = REPLACE(@finalEntry, '##ICD10Code##', ISNULL(@tICD10Code, 'UNK'))  
   SET @finalEntry = REPLACE(@finalEntry, '##SNOMED##', ISNULL(@tSNOMED, 'UNK'))     
   SET @finalEntry = REPLACE(@finalEntry, '##Status##', ISNULL(@tClinicalStatus, 'UNK'))  
   SET @finalEntry = REPLACE(@finalEntry, '##EffectiveDate##', convert(VARCHAR(max), convert(DATETIME, @tEffectiveDate), 112))  
   SET @finalEntry = REPLACE(@finalEntry, '##Age##', ISNULL(@tAge, 'UNK'))  
     
   SET @loopCOUNT = @loopCOUNT + 1  
  
   PRINT @finalList  
   PRINT @finalEntry  
  
   FETCH NEXT  
   FROM tCursor  
   INTO @tICD9Code  
    ,@tICD10Code  
    ,@tSNOMED  
    ,@tDescription  
    ,@tClinicalStatus  
    ,@tEffectiveDate  
    ,@tAge  
  END  
  
  CLOSE tCursor  
  
  DEALLOCATE tCursor  
  
  SET @FinalComponentXML = REPLACE(@PLACEHOLDERXML, '###LISTITEMSECTION###', @finalList)  
  SET @FinalComponentXML = REPLACE(@FinalComponentXML, '###ENTRYSECTION###', @finalEntry)  
  SET @OutputComponentXML = @FinalComponentXML  
 END  
 ELSE  
 BEGIN  
  SET @OutputComponentXML = @DefaultComponentXML  
 END  
  
END  
  
GO


