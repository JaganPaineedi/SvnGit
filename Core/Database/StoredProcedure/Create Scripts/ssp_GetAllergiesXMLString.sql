/****** Object:  StoredProcedure [dbo].[ssp_GetAllergiesXMLString]    Script Date: 09/22/2017 18:46:09 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetAllergiesXMLString]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetAllergiesXMLString]
GO


/****** Object:  StoredProcedure [dbo].[ssp_GetAllergiesXMLString]    Script Date: 09/22/2017 18:46:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 
CREATE PROCEDURE [dbo].[ssp_GetAllergiesXMLString] @ClientId INT = NULL    
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
			<!-- *** Allergies and Intolerances Section (entries required) (V3) *** -->
			<templateId root="2.16.840.1.113883.10.20.22.2.6.1" extension="2015-08-01"/>
			<templateId root="2.16.840.1.113883.10.20.22.2.6.1"/>
			<!-- Alerts section template -->
			<code code="48765-2" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
			<title>ALLERGIES AND ADVERSE REACTIONS</title>
			<text>No Known Allergies</text>
			<!-- replaced Allergy Problem Act (R1.1) with   
			Allergy Concern Act (V3) to meet R2.1 validation requirements -DB-->
			<entry typeCode="DRIV">
				<act classCode="ACT" moodCode="EVN">
					<!-- ** Allergy Concern Act (V3) ** -->
					<templateId root="2.16.840.1.113883.10.20.22.4.30" extension="2015-08-01"/>
					<!--Critical Change-->
					<templateId root="2.16.840.1.113883.10.20.22.4.30"/>
					<id root="36e3e930-7b15-11db-9fe1-0800200c9a66"/>
					<code code="CONC" codeSystem="2.16.840.1.113883.5.6"/>
					<!-- The statusCode represents the need to continue tracking the allergy -->
					<!-- This is of ongoing concern to the provider -->
					<statusCode code="active"/>
					<effectiveTime>
						<!-- The low value represents when the allergy was first recorded in the patient''s chart -->
						<low value="20150722"/>
					</effectiveTime>
					<entryRelationship typeCode="SUBJ">
						<!-- using negationInd="true" to signify that there are is NO food allergy (disorder) allergy -db -->
						<observation classCode="OBS" moodCode="EVN" negationInd="true">
							<!-- ** Allergy observation (V2) ** -->
							<templateId root="2.16.840.1.113883.10.20.22.4.7" extension="2014-06-09"/>
							<templateId root="2.16.840.1.113883.10.20.22.4.7"/>
							<id root="4adc1020-7b16-11db-9fe1-0800200c9a66"/>
							<code code="ASSERTION" codeSystem="2.16.840.1.113883.5.4"/>
							<statusCode code="completed"/>
							<effectiveTime nullFlavor="NA"/>
							<!-- We cannot use the No known Food Allergy value/@code 429625007   
							required by the test data as it is not part of the valueSet required   
							(Allergy/Adverse Event Type 2.16.840.1.113883.3.88.12.3221.6.2 DYNAMIC CONF:1098-7390 -db -->
											<!--  
							<value xsi:type="CD" code="429625007"  
							 displayName="No known Food Allergy"  
							 codeSystem="2.16.840.1.113883.6.96"  
							 codeSystemName="SNOMED-CT">  
							 <originalText>  
							  <reference value="#reaction1"/>  
							 </originalText>  
							</value>  
							-->
							<!-- using Food allergy (disorder) along with negationInd instead -db -->
							<value xsi:type="CD" code="419199007"
							 displayName="Allergy to substance (disorder)"
							 codeSystem="2.16.840.1.113883.6.96"
							 codeSystemName="SNOMED-CT">
							</value>
							<!-- In C-CDA R2 the participant is required. The SNOMED code ="105590001" displayName="Substance" could be used in the participant-->
							<participant typeCode="CSM">
								<participantRole classCode="MANU">
									<playingEntity classCode="MMAT">
										<code nullFlavor="NA"/>
									</playingEntity>
								</participantRole>
							</participant>
						</observation>
					</entryRelationship>
				</act>
			</entry>
		</section>
	</component>'  
 DECLARE @FinalComponentXML VARCHAR(MAX)  
 DECLARE @PLACEHOLDERXML VARCHAR(MAX) = '<component>
	<section>
		<templateId root="2.16.840.1.113883.10.20.22.2.6.1" />
		<!-- Alerts section template -->
		<code code="48765-2" codeSystem="2.16.840.1.113883.6.1" />
		<title>ALLERGIES, ADVERSE REACTIONS, ALERTS</title>
		<text>
			<table border="1" width="100%">
				<thead>
					<tr>
						<th>Substance</th>
						<th>Reaction</th>
						<th>Severity</th>
						<th>Status</th>
					</tr>
				</thead>
				<tbody>
					###TRSECTION###
				</tbody>
			</table>
		</text>
		###ENTRYSECTION###
	</section>
</component>'  
 DECLARE @trXML VARCHAR(MAX) = '<tr>
		<td>
			<content ID="Drug_##ID##">##Substance##</content>
		</td>
		<td>
			<content ID="reaction_##ID##">##Reaction##</content>
		</td>
		<td>
			<content ID="severity_##ID##">##Severity##</content>
		</td>
		<td>##STATUS##</td>
	</tr>'  
 DECLARE @finalTR VARCHAR(MAX)  
  
 SET @finalTR = ''  
  
 DECLARE @entryXML VARCHAR(MAX) =   
	  '<entry typeCode="DRIV">
		<act classCode="ACT" moodCode="EVN">
			<templateId root="2.16.840.1.113883.10.20.22.4.30" />
			<!-- ** Allergy problem act ** -->
			<id root="36e3e930-7b14-11db-9fe1-0800200c9a66" />
			<code code="48765-2" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Allergies, adverse reactions, alerts" />
			<statusCode code="completed" />
			<effectiveTime value="##DATELOW##">
				<low value="##DATELOW##" />
				<high value="##DATEHIGH##" />
			</effectiveTime>
			<entryRelationship typeCode="SUBJ">
				<observation classCode="OBS" moodCode="EVN">
					<!-- allergy observation template -->
					<templateId root="2.16.840.1.113883.10.20.22.4.7" />
					<id root="4adc1020-7b14-11db-9fe1-0800200c9a66" />
					<code code="ASSERTION" codeSystem="2.16.840.1.113883.5.4" />
					<statusCode code="completed" />
					<effectiveTime>
						<low value="##DATELOW##" />
					</effectiveTime>
					<value xsi:type="CD" code="419511003" displayName="Propensity to adverse reaction to drug" codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED CT">
						<originalText>
							<reference value="#reaction_##ID##" />
						</originalText>
					</value>
					<participant typeCode="CSM">
						<participantRole classCode="MANU">
							<playingEntity classCode="MMAT">
								<code code="##RxNormCode##" displayName="##Substance##" codeSystem="2.16.840.1.113883.6.88" codeSystemName="RxNorm">
									<originalText>
										<reference value="#Drug_##ID##" />
									</originalText>
								</code>
							</playingEntity>
						</participantRole>
					</participant>
					<entryRelationship typeCode="SUBJ" inversionInd="true">
						<observation classCode="OBS" moodCode="EVN">
							<templateId root="2.16.840.1.113883.10.20.22.4.28" />
							<!-- Allergy status observation template -->
							<code code="33999-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Status" />
							<statusCode code="completed" />
							<value xsi:type="CE" code="55561003" codeSystem="2.16.840.1.113883.6.96" displayName="##STATUS##" />
						</observation>
					</entryRelationship>
					<entryRelationship typeCode="MFST" inversionInd="true">
						<observation classCode="OBS" moodCode="EVN">
							<templateId root="2.16.840.1.113883.10.20.22.4.9" />
							<!-- Reaction observation template -->
							<id root="4adc1020-7b14-11db-9fe1-0800200c9a64" />
							<code nullFlavor="NA" />
							<text>
								<reference value="#reaction_##ID##" />
							</text>
							<statusCode code="completed" />
							<effectiveTime>
								<low value="##DATELOW##" />
							</effectiveTime>
							<value xsi:type="CD" code="##ReactionSNOMEDCode##" codeSystem="2.16.840.1.113883.6.96" displayName="##Reaction##" />
						</observation>
					</entryRelationship>
					<entryRelationship typeCode="SUBJ" inversionInd="true">
						<observation classCode="OBS" moodCode="EVN">
							<templateId root="2.16.840.1.113883.10.20.22.4.8" />
							<!-- ** Severity observation template ** -->
							<code xsi:type="CE" code="SEV" displayName="Severity Observation" codeSystem="2.16.840.1.113883.5.4" codeSystemName="ActCode" />
							<text>
								<reference value="#severity_##ID##" />
							</text>
							<statusCode code="completed" />
							<value xsi:type="CD" code="##SeveritySNOMEDCode##" displayName="##Severity##" codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED CT" />
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
  ,[Date] DATETIME  
  ,[Description] VARCHAR(max)  
  ,[Reaction] VARCHAR(max)  
  ,[Severity] VARCHAR(max)  
  ,[Comments] VARCHAR(max)  
  ,[RxNormCode] VARCHAR(255)  
  ,[ClinicalStatus] VARCHAR(100)  
  ,[Type] VARCHAR(100)  
  ,[ReactionSNOMEDCode] VARCHAR(25)  
  ,[SeveritySNOMEDCode] VARCHAR(25)  
  )  
  
 INSERT INTO @tResults  
  EXEC ssp_GetAllergies NULL  
   ,@Type   
   ,@DocumentVersionId   
   ,@FromDate   
   ,@ToDate  
   ,NULL  
  
 DECLARE @tDescription VARCHAR(MAX) = ''  
 DECLARE @tReaction VARCHAR(MAX) = ''  
 DECLARE @tSeverity VARCHAR(MAX) = ''  
 DECLARE @tRxNormCode VARCHAR(100) = ''  
 DECLARE @tClinicalStatus VARCHAR(100) = ''   
 DECLARE @tReactionSNOMEDCode VARCHAR(25) = ''  
 DECLARE @tSeveritySNOMEDCode VARCHAR(25) = ''  
 DECLARE @tDate VARCHAR(100) = ''  
  
 IF EXISTS (  
   SELECT *  
   FROM @tResults  
   )  
 BEGIN  
  DECLARE tCursor CURSOR FAST_FORWARD  
  FOR  
  SELECT [Description]  
   ,[Reaction]  
   ,[Severity]  
   ,[RxNormCode]  
   ,[ClinicalStatus]  
   ,[ReactionSNOMEDCode]  
   ,[SeveritySNOMEDCode]     
   ,[Date]  
  FROM @tResults TDS  
  
  OPEN tCursor  
  
  FETCH NEXT  
  FROM tCursor  
  INTO @tDescription  
   ,@tReaction  
   ,@tSeverity  
   ,@tRxNormCode  
   ,@tClinicalStatus  
   ,@tReactionSNOMEDCode  
   ,@tSeveritySNOMEDCode  
   ,@tDate  
  
  WHILE (@@FETCH_STATUS = 0)  
  BEGIN  
   SET @finalTR = @finalTR + @trXML  
   SET @finalEntry = @finalEntry + @entryXML  
   SET @finalTR = REPLACE(@finalTR, '##ID##', @loopCOUNT)  
   SET @finalTR = REPLACE(@finalTR, '##Substance##', ISNULL(@tDescription, 'UNK'))  
   SET @finalTR = REPLACE(@finalTR, '##Reaction##', ISNULL(@tReaction, 'UNK'))  
   SET @finalTR = REPLACE(@finalTR, '##Severity##', ISNULL(@tSeverity, 'UNK'))  
   SET @finalTR = REPLACE(@finalTR, '##RxNormCode##', ISNULL(@tRxNormCode, 'UNK'))  
   SET @finalTR = REPLACE(@finalTR, '##STATUS##', ISNULL(@tClinicalStatus, 'UNK'))  
     
   SET @finalEntry = REPLACE(@finalEntry, '##ID##', @loopCOUNT)   
   SET @finalEntry = REPLACE(@finalEntry, '##Substance##', ISNULL(@tDescription, 'UNK'))  
   SET @finalEntry = REPLACE(@finalEntry, '##Reaction##', ISNULL(@tReaction, 'UNK'))  
   SET @finalEntry = REPLACE(@finalEntry, '##Severity##', ISNULL(@tSeverity, 'UNK'))  
   SET @finalEntry = REPLACE(@finalEntry, '##RxNormCode##', ISNULL(@tRxNormCode, 'UNK'))  
   SET @finalEntry = REPLACE(@finalEntry, '##STATUS##', ISNULL(@tClinicalStatus, 'UNK'))  
   SET @finalEntry = REPLACE(@finalEntry, '##ReactionSNOMEDCode##', ISNULL(@tReactionSNOMEDCode, 'UNK'))  
   SET @finalEntry = REPLACE(@finalEntry, '##SeveritySNOMEDCode##', ISNULL(@tSeveritySNOMEDCode, 'UNK'))  
   SET @finalEntry = REPLACE(@finalEntry, '##DATELOW##', convert(VARCHAR(max), convert(DATETIME, @tDATE), 112))  
   SET @finalEntry = REPLACE(@finalEntry, '##DATEHIGH##', convert(VARCHAR(max), convert(DATETIME, @tDATE), 112))  
   SET @loopCOUNT = @loopCOUNT + 1  
  
   PRINT @finalTR  
   PRINT @finalEntry  
  
   FETCH NEXT  
   FROM tCursor  
   INTO @tDescription      
    ,@tReaction  
    ,@tSeverity  
    ,@tRxNormCode  
    ,@tClinicalStatus  
    ,@tReactionSNOMEDCode  
    ,@tSeveritySNOMEDCode  
    ,@tDate  
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


