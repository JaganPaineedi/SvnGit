/****** Object:  StoredProcedure [dbo].[ssp_GetSocialHistoryXMLString]    Script Date: 09/22/2017 18:15:37 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetSocialHistoryXMLString]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetSocialHistoryXMLString]
GO


/****** Object:  StoredProcedure [dbo].[ssp_GetSocialHistoryXMLString]    Script Date: 09/22/2017 18:15:37 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_GetSocialHistoryXMLString] @ClientId INT = NULL    
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
				<section nullFlavor="NI">
					<!--  ** Social History Section (V3) ** -->
					<templateId root="2.16.840.1.113883.10.20.22.2.17" extension="2015-08-01"/>
					<templateId root="2.16.840.1.113883.10.20.22.2.17"/>
					<code code="29762-2" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Social History"/>
					<title>SOCIAL HISTORY</title>
					<text>No Social History Information</text>
				</section>
			</component>'  
 DECLARE @FinalComponentXML VARCHAR(MAX)  
 DECLARE @PLACEHOLDERXML VARCHAR(MAX) = '<component>
			<!--   Social History ******** -->
			<section>
				<templateId root="2.16.840.1.113883.10.20.22.2.17"/>
				<!--  ********  Social history section template   ******** -->
				<code code="29762-2" codeSystem="2.16.840.1.113883.6.1" displayName="Social History"/>
				<title>SOCIAL HISTORY</title>
				<text>
					<table border="1" width="100%">
						<thead>
							<tr>
								<th>Social History Element</th>
								<th>Description</th>
								<th>Effective Dates</th>
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
               <td><content ID="soc_##ID##"/>smoking</td>  
               <td>##SmokingStatus##</td>  
               <td>##DateLow## to ##DateHigh##</td>  
            </tr>'  
 DECLARE @finalTR VARCHAR(MAX)  
  
 SET @finalTR = ''  
  
 DECLARE @entryXML VARCHAR(MAX) =   
			'<entry typeCode="DRIV">
				<observation classCode="OBS" moodCode="EVN">
					<!-- Smoking status observation template -->
					<templateId root="2.16.840.1.113883.10.20.22.4.78"/>
					<id extension="123456789" root="2.16.840.1.113883.19"/>
					<code code="ASSERTION" codeSystem="2.16.840.1.113883.5.4"/>
					<statusCode code="completed"/>
					<!-- update as per errata 596 - The effective time data type is treated as a TS instead of an IVL_TS,  
								  therefore, low, center, high, and width are not allowed. Removed low and high and added a @value to effectiveTime instead. -db -->
					<effectiveTime>
						<low value="##DateLow##"/>
						<high value="##DateHigh##"/>
					</effectiveTime>
					<value xsi:type="CD" code="##SNOMED##" displayName="##SmokingStatus##" codeSystem="2.16.840.1.113883.6.96"/>
				</observation>
			</entry>'  
 DECLARE @finalEntry VARCHAR(MAX) 
 SET @finalEntry = ''  
  
 DECLARE @loopCOUNT INT = 0  
 DECLARE @tResults TABLE (  
  [SmokingStatus] VARCHAR(250)  
  ,[SmokingEndDate] DATETIME  
  ,[Date] DATETIME  
  ,[SNOMED] VARCHAR(200)  
  )  
  
  DECLARE @ServiceId INT 
 INSERT INTO @tResults  
  EXEC ssp_RDLClinicalSummarySmoking @ServiceId=NULL, @ClientId=NULL, @DocumentVersionId =@DocumentVersionId  
     
 DECLARE @tSmokingStatus VARCHAR(250) = ''  
 DECLARE @tDate VARCHAR(100) = ''  
 DECLARE @tSNOMED VARCHAR(200) = ''  
   
 IF EXISTS (  
   SELECT *  
   FROM @tResults  
   )  
 BEGIN  
  DECLARE tCursor CURSOR FAST_FORWARD  
  FOR  
  SELECT [SmokingStatus]  
   ,[Date]  
   ,[SNOMED]  
     
  FROM @tResults TDS  
  
  OPEN tCursor  
  
  FETCH NEXT  
  FROM tCursor  
  INTO @tSmokingStatus  
   ,@tDate  
   ,@tSNOMED     
  
  WHILE (@@FETCH_STATUS = 0)  
  BEGIN  
   SET @finalTR = @finalTR + @trXML  
   SET @finalEntry = @finalEntry + @entryXML  
   SET @finalTR = REPLACE(@finalTR, '##ID##', @loopCOUNT)  
   SET @finalTR = REPLACE(@finalTR, '##SmokingStatus##', ISNULL(@tSmokingStatus, 'UNK'))  
   SET @finalTR = REPLACE(@finalTR, '##DateLow##', convert(VARCHAR(max), convert(DATETIME, @tDATE), 112))  
   SET @finalTR = REPLACE(@finalTR, '##DateHigh##', convert(VARCHAR(max), convert(DATETIME, @tDATE), 112))  
   SET @finalTR = REPLACE(@finalTR, '##SNOMED##', ISNULL(@tSNOMED, 'UNK'))  
        
   SET @finalEntry = REPLACE(@finalEntry, '##ID##', @loopCOUNT)   
   SET @finalEntry = REPLACE(@finalEntry, '##SmokingStatus##', ISNULL(@tSmokingStatus, 'UNK'))  
   SET @finalEntry = REPLACE(@finalEntry, '##DateLow##', convert(VARCHAR(max), convert(DATETIME, @tDATE), 112))  
   SET @finalEntry = REPLACE(@finalEntry, '##DateHigh##', convert(VARCHAR(max), convert(DATETIME, @tDATE), 112))  
   SET @finalEntry = REPLACE(@finalEntry, '##SNOMED##', ISNULL(@tSNOMED, 'UNK'))  
     
   SET @loopCOUNT = @loopCOUNT + 1  
  
   PRINT @finalTR  
   PRINT @finalEntry  
  
   FETCH NEXT  
   FROM tCursor  
   INTO @tSmokingStatus  
    ,@tDate  
    ,@tSNOMED  
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
