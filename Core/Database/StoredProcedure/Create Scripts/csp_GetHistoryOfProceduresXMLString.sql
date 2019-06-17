/****** Object:  StoredProcedure [dbo].[csp_GetHistoryOfProceduresXMLString]    Script Date: 09/22/2017 18:36:55 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_GetHistoryOfProceduresXMLString]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_GetHistoryOfProceduresXMLString]
GO


/****** Object:  StoredProcedure [dbo].[csp_GetHistoryOfProceduresXMLString]    Script Date: 09/22/2017 18:36:55 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[csp_GetHistoryOfProceduresXMLString] @ClientId INT = NULL    
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
 DECLARE @FinalComponentXML VARCHAR(MAX)  
 DECLARE @PLACEHOLDERXML VARCHAR(MAX) = '<component>
			<section>
				<templateId root="2.16.840.1.113883.10.20.22.2.7.1"/>
				<!-- Procedures section template -->
				<code code="47519-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="HISTORY OF PROCEDURES"/>
				<title>PROCEDURES</title>
				<text>
					<table border="1" width="100%">
						<thead>
							<tr>
								<th>Procedure</th>
								<th>Date</th>
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
                      <content ID="Proc_##ID##">##Procedure##</content>  
                   </td>  
                   <td>##Date##</td>  
                </tr>'  
 DECLARE @finalTR VARCHAR(MAX)  
 SET @finalTR = ''  
  
 DECLARE @entryXML VARCHAR(MAX) =   
			'<entry typeCode="DRIV">
				<procedure classCode="PROC" moodCode="EVN">
					<templateId root="2.16.840.1.113883.10.20.22.4.14"/>
					<!-- Procedure Activity Observation -->
					<id extension="123456789" root="2.16.840.1.113883.19"/>
					<code code="##SNOMEDCode##" codeSystem="2.16.840.1.113883.6.96" displayName="##Procedure##" codeSystemName="SNOMED-CT">
						<originalText>
							<reference value="#Proc_##ID##"/>
						</originalText>
					</code>
					<statusCode code="##State##"/>
					<effectiveTime value="##Date##"/>
					<priorityCode code="CR" codeSystem="2.16.840.1.113883.5.7" codeSystemName="ActPriority" displayName="Callback results"/>
					<methodCode nullFlavor="UNK"/>
					<targetSiteCode code="##TargetSiteSNOMEDCode##" codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED CT" displayName="##TargetSiteProcedure##"/>
					<performer>
						<assignedEntity>
							<id root="2.16.840.1.113883.19.5" extension="1234"/>
							<addr>
								<streetAddressLine>##Address##</streetAddressLine>
								<city>##City##</city>
								<state>##State##</state>
								<postalCode>##ZipCode##</postalCode>
								<country>US</country>
							</addr>
							<telecom use="WP" value="##Phone##"/>
							<representedOrganization>
								<id root="2.16.840.1.113883.19.5"/>
								<name>##AgencyName##</name>
								<telecom nullFlavor="UNK"/>
								<addr nullFlavor="UNK"/>
							</representedOrganization>
						</assignedEntity>
					</performer>
					<participant typeCode="LOC">
						<participantRole classCode="SDLOC">
							<templateId root="2.16.840.1.113883.10.20.22.4.32"/>
							<!-- Service Delivery Location template -->
							<code code="1160-1" codeSystem="2.16.840.1.113883.6.259" codeSystemName="HealthcareServiceLocation" displayName="Urgent Care Center"/>
							<addr>
								<streetAddressLine>##Address##</streetAddressLine>
								<city>##City##</city>
								<state>##State##</state>
								<postalCode>##ZipCode##</postalCode>
								<country>US</country>
							</addr>
							<telecom nullFlavor="UNK"/>
							<playingEntity classCode="PLC">
								<name>Get Well Clinic</name>
							</playingEntity>
						</participantRole>
					</participant>
				</procedure>
			</entry>'  
 DECLARE @finalEntry VARCHAR(MAX)  
 SET @finalEntry = ''  
  
 DECLARE @loopCOUNT INT = 0  
 DECLARE @tResults TABLE (  
  [EffectiveDate] DATETIME  
  ,[Question] VARCHAR(300)  
  ,[answer] VARCHAR(max)  
  ,[OrderName] VARCHAR(500)  
  ,[SNOMEDCode] VARCHAR(25)  
  ,[AgencyName] varchar(250)  
  ,[Address]varchar(100)  
  ,[City] varchar(30)  
  ,[State] varchar(2)  
  ,[ZipCode] varchar(12)  
  ,[MainPhone] varchar(50)  
  )       
   
  
 INSERT INTO @tResults  
  EXEC ssp_SCGetSOCFunctionalCognitiveDetails @ClientId,        
  @FromDate,  
  @ToDate,  
  'P'  
  
 DECLARE @tEffectiveDate VARCHAR(100) = ''  
 DECLARE @tProcedure VARCHAR(MAX) = ''  
 DECLARE @tSNOMEDCode VARCHAR(MAX) = ''   
 DECLARE @tTargetSiteProcedure VARCHAR(MAX) = ''   
 DECLARE @tTargetSiteSNOMEDCode VARCHAR(MAX) = ''   
 DECLARE @tStatus VARCHAR(MAX) = ''   
 DECLARE @tAgencyName VARCHAR(250) = ''  
 DECLARE @tAddress VARCHAR(100) = ''  
 DECLARE @tCity VARCHAR(30) = ''  
 DECLARE @tState VARCHAR(2) = ''  
 DECLARE @tZipCode VARCHAR(12) = ''  
 DECLARE @tPhone VARCHAR(50) = ''  
     
 --Converting rows to columns  
 DECLARE @tempResults TABLE (  
  [EffectiveDate] DATETIME  
  ,[Procedure] VARCHAR(MAX)  
  ,[SNOMEDCode] VARCHAR(25)  
  ,[TargetSiteProcedure] VARCHAR(MAX)  
  ,[TargetSiteSNOMEDCode] VARCHAR(25)  
  ,[Status] VARCHAR(MAX)  
  ,[AgencyName] varchar(250)  
  ,[Address]varchar(100)  
  ,[City] varchar(30)  
  ,[State] varchar(2)  
  ,[ZipCode] varchar(12)  
  ,[Phone] varchar(50)     
  )    
 INSERT INTO @tempResults  
   select EffectiveDate,     
   max(case when OrderName = 'Procedures' AND Question = 'Name' then answer end) [Procedure],-- Add Question also     
   max(case when OrderName = 'Procedures' AND Question = 'Name'  then SNOMEDCode end) SNOMEDCode,  
   max(case when OrderName = 'Procedures' AND Question = 'Target Site' then answer end) [TargetSiteProcedure],-- Add Question also     
   max(case when OrderName = 'Procedures' AND Question = 'Target Site'  then SNOMEDCode end) TargetSiteSNOMEDCode,  
   max(case when OrderName = 'Procedures' AND Question = 'Status'  then answer end) [Status],  
   max(case when OrderName = 'Procedures' then AgencyName end) AgencyName,  
   max(case when OrderName = 'Procedures' then [Address] end) [Address],  
   max(case when OrderName = 'Procedures' then City end) City,  
   max(case when OrderName = 'Procedures' then [State] end) [State],  
   max(case when OrderName = 'Procedures' then ZipCode end) ZipCode,  
   max(case when OrderName = 'Procedures' then MainPhone end) Phone  
   from @tResults where OrderName = 'Procedures' group by EffectiveDate  
     
 IF EXISTS (  
   SELECT *  
   FROM @tempResults  
   )  
 BEGIN  
  DECLARE tCursor CURSOR FAST_FORWARD  
  FOR  
  SELECT [EffectiveDate]  
   ,[Procedure]  
   ,[SNOMEDCode]  
   ,[TargetSiteProcedure]  
   ,[TargetSiteSNOMEDCode]   
   ,[Status]  
   ,[AgencyName]  
   ,[Address]  
   ,[City]  
   ,[State]  
   ,[ZipCode]  
   ,[Phone]    
  FROM @tempResults  
  
  OPEN tCursor  
  
  FETCH NEXT  
  FROM tCursor  
  INTO @tEffectiveDate  
   ,@tProcedure  
   ,@tSNOMEDCode  
   ,@tTargetSiteProcedure  
   ,@tTargetSiteSNOMEDCode  
   ,@tStatus  
   ,@tAgencyName  
   ,@tAddress  
   ,@tCity  
   ,@tState  
   ,@tZipCode  
   ,@tPhone  
  
  WHILE (@@FETCH_STATUS = 0)  
  BEGIN  
   SET @finalTR = @finalTR + @trXML  
   SET @finalEntry = @finalEntry + @entryXML  
   SET @finalTR = REPLACE(@finalTR, '##ID##', @loopCOUNT)  
   SET @finalTR = REPLACE(@finalTR, '##Procedure##', ISNULL(@tProcedure, 'UNK'))  
   SET @finalTR = REPLACE(@finalTR, '##SNOMEDCode##', ISNULL(@tSNOMEDCode, 'UNK'))  
   SET @finalTR = REPLACE(@finalTR, '##TargetSiteProcedure##', ISNULL(@tTargetSiteProcedure, 'UNK'))  
   SET @finalTR = REPLACE(@finalTR, '##TargetSiteSNOMEDCode##', ISNULL(@tTargetSiteSNOMEDCode, 'UNK'))  
   SET @finalTR = REPLACE(@finalTR, '##Date##', convert(VARCHAR(max), convert(DATETIME, @tEffectiveDate), 112))  
        
   SET @finalEntry = REPLACE(@finalEntry, '##ID##', @loopCOUNT)   
   SET @finalEntry = REPLACE(@finalEntry, '##Procedure##', ISNULL(@tProcedure, 'UNK'))     
   SET @finalEntry = REPLACE(@finalEntry, '##SNOMEDCode##', ISNULL(@tSNOMEDCode, 'UNK'))  
   SET @finalEntry = REPLACE(@finalEntry, '##TargetSiteProcedure##', ISNULL(@tTargetSiteProcedure, 'UNK'))  
   SET @finalEntry = REPLACE(@finalEntry, '##TargetSiteSNOMEDCode##', ISNULL(@tTargetSiteSNOMEDCode, 'UNK'))  
   SET @finalEntry = REPLACE(@finalEntry, '##Status##', ISNULL(@tStatus, 'UNK'))     
   SET @finalEntry = REPLACE(@finalEntry, '##AgencyName##', ISNULL(@tAgencyName, 'UNK'))  
   SET @finalEntry = REPLACE(@finalEntry, '##Address##', ISNULL(@tAddress, 'UNK'))  
   SET @finalEntry = REPLACE(@finalEntry, '##City##', ISNULL(@tCity, 'UNK'))  
   SET @finalEntry = REPLACE(@finalEntry, '##State##', ISNULL(@tState, 'UNK'))  
   SET @finalEntry = REPLACE(@finalEntry, '##ZipCode##', ISNULL(@tZipCode, 'UNK'))  
   SET @finalEntry = REPLACE(@finalEntry, '##Phone##', ISNULL(@tPhone, 'UNK'))     
   SET @finalEntry = REPLACE(@finalEntry, '##Date##', convert(VARCHAR(max), convert(DATETIME, @tEffectiveDate), 112))  
   SET @loopCOUNT = @loopCOUNT + 1  
  
   PRINT @finalTR  
   PRINT @finalEntry  
  
   FETCH NEXT  
   FROM tCursor  
   INTO @tEffectiveDate      
    ,@tProcedure  
    ,@tSNOMEDCode  
    ,@tTargetSiteProcedure  
    ,@tTargetSiteSNOMEDCode  
    ,@tStatus  
    ,@tAgencyName  
    ,@tAddress  
    ,@tCity  
    ,@tState  
    ,@tZipCode  
    ,@tPhone  
  END  
  
  CLOSE tCursor  
  
  DEALLOCATE tCursor  
  
  SET @FinalComponentXML = REPLACE(@PLACEHOLDERXML, '###TRSECTION###', @finalTR)  
  SET @FinalComponentXML = REPLACE(@FinalComponentXML, '###ENTRYSECTION###', @finalEntry)  
  SET @OutputComponentXML = @FinalComponentXML  
 END 
     
END  
  
GO


