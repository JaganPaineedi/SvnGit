/****** Object:  StoredProcedure [dbo].[csp_GetFunctionalCognitiveXMLString]    Script Date: 09/22/2017 18:35:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_GetFunctionalCognitiveXMLString]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_GetFunctionalCognitiveXMLString]
GO


/****** Object:  StoredProcedure [dbo].[csp_GetFunctionalCognitiveXMLString]    Script Date: 09/22/2017 18:35:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

    
CREATE PROCEDURE [dbo].[csp_GetFunctionalCognitiveXMLString] @ClientId INT = NULL      
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
			<templateId root="2.16.840.1.113883.10.20.22.2.14"/>
			<!--  ******** Functional status section template   ******** -->
			<code code="47420-5" codeSystem="2.16.840.1.113883.6.1"/>
			<title>FUNCTIONAL STATUS</title>
			<text>
				<table border="1" width="100%">
					<thead>
						<tr>
							<th>Functional Condition</th>
							<th>Effective Dates</th>
							<th>Condition Status</th>
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
                           <td><content ID="fs_##ID##">##FunctionalCondition##</content></td>    
                           <td>##EffectiveDate##</td>    
                           <td>Active</td>    
                        </tr>'    
 DECLARE @finalTR VARCHAR(MAX)    
 SET @finalTR = ''    
    
 DECLARE @entryXML VARCHAR(MAX) =     
		 '<entry typeCode="DRIV">    
              <observation classCode="OBS" moodCode="EVN">    
                 <!-- Problem observation template -->    
                 <templateId root="2.16.840.1.113883.10.20.22.4.68"/>    
                 <id root="ab1791b0-5c71-11db-b0de-0800200c9a66"/>    
                 <code xsi:type="CE" code="409586006" codeSystem="2.16.840.1.113883.6.96" displayName="Complaint"/>    
                 <text>    
                    <reference value="#fs_##ID##"/>    
                 </text>    
                 <statusCode code="##Status##"/>    
                 <effectiveTime>    
                    <low value="##EffectiveDate##"/>    
                 </effectiveTime>    
                 <value xsi:type="CD" code="##SNOMEDCode##" codeSystem="2.16.840.1.113883.6.96" displayName="##FunctionalCondition##"/>    
              </observation>    
           </entry>'    
           DECLARE @CogEntryXML VARCHAR(MAX) ='<entry typeCode="DRIV">    
              <observation classCode="OBS" moodCode="EVN">    
                 <!-- Cognitive Status Problem observation template -->    
                 <templateId root="2.16.840.1.113883.10.20.22.4.73"/>    
                 <id root="ab1791b0-5c71-11db-b0de-0800200c9a66"/>    
                 <code xsi:type="CE" code="373930000" codeSystem="2.16.840.1.113883.6.96" displayName="Cognitive Function Finding"/>    
                 <text>    
                    <reference value="#fs_##ID##"/>    
                 </text>    
                 <statusCode code="##Status##"/>    
                 <effectiveTime>    
                    <low value="##EffectiveDate##"/>    
                 </effectiveTime>    
                 <value xsi:type="CD" code="##SNOMEDCode##" codeSystem="2.16.840.1.113883.6.96" displayName="##FunctionalCondition##"/>    
              </observation>    
           </entry>'    
 DECLARE @finalEntry VARCHAR(MAX)    
 SET @finalEntry = ''    
 DECLARE @finalCogEntry VARCHAR(MAX)    
 SET @finalCogEntry = ''    
    
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
  'F'    
    
 DECLARE @tFunCondition VARCHAR(300) = ''    
 DECLARE @tEffectiveDate VARCHAR(100) = ''    
 DECLARE @tSNOMEDCode VARCHAR(300) = ''    
 DECLARE @tStatus VARCHAR(300) = ''    
    
--Converting rows to columns    
 DECLARE @tempResults TABLE (    
  [EffectiveDate] DATETIME    
  ,[FunCondition] VARCHAR(max)    
  ,[SNOMEDCode] VARCHAR(300)    
  ,[Status] VARCHAR(max)     
       
  )      
 INSERT INTO @tempResults    
 select    
   EffectiveDate,       
   max(case when [OrderName] = 'Functional Status' AND Question = 'Functional Condition' then Answer end) FunCondition,    
   max(case when [OrderName] = 'Functional Status' AND Question = 'Functional Condition' then SNOMEDCode end) SNOMEDCode,      
   max(case when [OrderName] = 'Functional Status' AND Question = 'Status' then answer end) [Status]        
 from @tResults where [OrderName] = 'Functional Status' group by EffectiveDate    
    
 IF EXISTS (    
   SELECT *    
   FROM @tempResults    
   )    
 BEGIN    
  DECLARE tCursor CURSOR FAST_FORWARD    
  FOR    
  SELECT [EffectiveDate]    
   ,[FunCondition]    
   ,[SNOMEDCode]    
   ,[Status]    
  FROM @tempResults TDS    
    
  OPEN tCursor    
    
  FETCH NEXT    
  FROM tCursor    
  INTO @tEffectiveDate    
   ,@tFunCondition    
   ,@tSNOMEDCode    
   ,@tStatus    
    
  WHILE (@@FETCH_STATUS = 0)    
  BEGIN    
   SET @finalTR = @finalTR + @trXML    
   SET @finalEntry = @finalEntry + @entryXML    
   SET @finalTR = REPLACE(@finalTR, '##ID##', @loopCOUNT)    
   SET @finalTR = REPLACE(@finalTR, '##EffectiveDate##', LTRIM(STR(DATEPART(yyyy, @tEffectiveDate))))    
   SET @finalTR = REPLACE(@finalTR, '##FunctionalCondition##', ISNULL(@tFunCondition, 'UNK'))    
   SET @finalTR = REPLACE(@finalTR, '##SNOMEDCode##', ISNULL(@tSNOMEDCode, 'UNK'))    
        
   SET @finalEntry = REPLACE(@finalEntry, '##ID##', @loopCOUNT)    
   SET @finalEntry = REPLACE(@finalEntry, '##EffectiveDate##', convert(VARCHAR(max), convert(DATETIME, @tEffectiveDate), 112))    
   SET @finalEntry = REPLACE(@finalEntry, '##FunctionalCondition##', ISNULL(@tFunCondition, 'UNK'))    
   SET @finalEntry = REPLACE(@finalEntry, '##SNOMEDCode##', ISNULL(@tSNOMEDCode, 'UNK'))    
   SET @finalEntry = REPLACE(@finalEntry, '##Status##', ISNULL(@tStatus, 'UNK'))    
   SET @loopCOUNT = @loopCOUNT + 1    
    
   PRINT @finalTR    
   PRINT @finalEntry    
    
   FETCH NEXT    
   FROM tCursor    
   INTO @tEffectiveDate    
    ,@tFunCondition    
    ,@tSNOMEDCode    
    ,@tStatus    
  END    
    
  CLOSE tCursor    
    
  DEALLOCATE tCursor    
    
--***********COGNITIVE STATUS START************    
    
 SET @loopCOUNT = 0    
 DECLARE @tCogResults TABLE (    
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
      
 INSERT INTO @tCogResults    
  EXEC ssp_SCGetSOCFunctionalCognitiveDetails @ClientId,          
  @FromDate,    
  @ToDate,    
  'C'    
    
  SET @tFunCondition = ''    
  SET @tEffectiveDate = ''    
  SET @tSNOMEDCode = ''    
  SET @tStatus = ''    
      
 --Converting rows to columns    
 DECLARE @tempCogResults TABLE (    
  [EffectiveDate] DATETIME    
  ,[FunCondition] VARCHAR(MAX)    
  ,[SNOMEDCode] VARCHAR(25)    
  ,[Status] VARCHAR(MAX)    
  )      
 INSERT INTO @tempCogResults     
 select    
   EffectiveDate,       
   max(case when [OrderName] = 'Functional Status' AND Question = 'Functional Condition' then Answer end) FunCondition,    
   max(case when [OrderName] = 'Functional Status' AND Question = 'Functional Condition' then SNOMEDCode end) SNOMEDCode,    
   max(case when [OrderName] = 'Functional Status' AND Question = 'Status' then answer end) [Status]             
 from @tCogResults  where [OrderName] = 'Functional Status' group by EffectiveDate    
    
 IF EXISTS (    
   SELECT *    
   FROM @tempCogResults    
   )    
 BEGIN    
  DECLARE tCursor CURSOR FAST_FORWARD    
  FOR    
  SELECT [EffectiveDate]    
   ,[FunCondition]    
   ,[SNOMEDCode]    
   ,[Status]    
  FROM @tempCogResults    
    
  OPEN tCursor    
    
  FETCH NEXT    
  FROM tCursor    
  INTO @tEffectiveDate    
   ,@tFunCondition    
   ,@tSNOMEDCode    
   ,@tStatus    
    
  WHILE (@@FETCH_STATUS = 0)    
  BEGIN    
   SET @finalCogEntry = @finalCogEntry + @CogEntryXML       
   SET @finalCogEntry = REPLACE(@finalCogEntry, '##ID##', @loopCOUNT)    
   SET @finalCogEntry = REPLACE(@finalCogEntry, '##EffectiveDate##', convert(VARCHAR(max), convert(DATETIME, @tEffectiveDate), 112))    
   SET @finalCogEntry = REPLACE(@finalCogEntry, '##FunctionalCondition##', ISNULL(@tFunCondition, 'UNK'))    
   SET @finalCogEntry = REPLACE(@finalCogEntry, '##SNOMEDCode##', ISNULL(@tSNOMEDCode, 'UNK'))    
   SET @finalCogEntry = REPLACE(@finalCogEntry, '##Status##', ISNULL(@tStatus, 'UNK'))    
   SET @loopCOUNT = @loopCOUNT + 1    
    
   PRINT @finalCogEntry    
    
   FETCH NEXT    
   FROM tCursor    
   INTO @tEffectiveDate    
    ,@tFunCondition    
    ,@tSNOMEDCode    
    ,@tStatus    
  END    
    
  CLOSE tCursor    
    
  DEALLOCATE tCursor    
 END    
--*************END OF COGNITIVE STATUS*****************    
    
  SET @FinalComponentXML = REPLACE(@PLACEHOLDERXML, '###TRSECTION###', @finalTR)    
  SET @finalEntry = @finalEntry+@finalCogEntry    
  SET @FinalComponentXML = REPLACE(@FinalComponentXML, '###ENTRYSECTION###', @finalEntry)    
  SET @OutputComponentXML = @FinalComponentXML    
 END    
   
END    
GO


