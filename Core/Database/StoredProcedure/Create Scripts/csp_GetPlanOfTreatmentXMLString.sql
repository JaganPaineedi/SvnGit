/****** Object:  StoredProcedure [dbo].[csp_GetPlanOfTreatmentXMLString]    Script Date: 09/22/2017 18:38:07 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_GetPlanOfTreatmentXMLString]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_GetPlanOfTreatmentXMLString]
GO


/****** Object:  StoredProcedure [dbo].[csp_GetPlanOfTreatmentXMLString]    Script Date: 09/22/2017 18:38:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[csp_GetPlanOfTreatmentXMLString] @ClientId INT = NULL      
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
		<templateId root="2.16.840.1.113883.10.20.22.2.10"/>
		<!--  **** Plan of Care section template  **** -->
		<code code="18776-5" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Treatment plan"/>
		<title>CARE PLAN</title>
		<text>
			<table border="1" width="100%">
				<thead>
					<tr>
						<th>Planned Activity</th>
						<th>Planned Date</th>
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
                           <td>##PlannedActivity##</td>    
                           <td>##EffectiveDate##</td>    
                        </tr>'    
 DECLARE @finalTR VARCHAR(MAX)    
 SET @finalTR = ''    
    
 DECLARE @entryXML VARCHAR(MAX) =     
			'<entry typeCode="DRIV">    
                  <act classCode="ACT" moodCode="INT">    
                     <templateId root="2.16.840.1.113883.10.20.22.4.20"/>    
                     <!-- ** Instructions Template ** -->    
                     <code xsi:type="CE" code="409073007" codeSystem="2.16.840.1.113883.6.96" displayName="instruction"/>    
                     <text>##PlannedActivity##</text>    
                     <statusCode code="##Status##"/>    
                  </act>    
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
  'A'    
    
 DECLARE @tPlannedActivity VARCHAR(300) = ''    
 DECLARE @tEffectiveDate VARCHAR(100) = ''    
 DECLARE @tSNOMEDCode VARCHAR(300) = ''    
 DECLARE @tStatus VARCHAR(300) = ''    
    
--Converting rows to columns    
 DECLARE @tempResults TABLE (    
  [EffectiveDate] DATETIME    
  ,[PlannedActivity] VARCHAR(MAX)     
  ,[Status] VARCHAR(MAX)     
  )      
 INSERT INTO @tempResults    
   select EffectiveDate,       
   max(case when OrderName = 'Plan of Treatment' and Question = 'Plan of Treatment'  then answer end) PlannedActivity,    
   max(case when OrderName = 'Plan of Treatment' and Question = 'Status' then Answer end) [Status]       
   from @tResults where OrderName = 'Plan of Treatment' group by EffectiveDate    
    
 IF EXISTS (    
   SELECT *    
   FROM @tempResults    
   )    
 BEGIN    
  DECLARE tCursor CURSOR FAST_FORWARD    
  FOR    
  SELECT [EffectiveDate]    
   ,[PlannedActivity]    
   ,[Status]    
  FROM @tempResults TDS    
    
  OPEN tCursor    
    
  FETCH NEXT    
  FROM tCursor    
  INTO @tEffectiveDate    
   ,@tPlannedActivity    
   ,@tStatus    
       
  WHILE (@@FETCH_STATUS = 0)    
  BEGIN    
   SET @finalTR = @finalTR + @trXML    
   SET @finalEntry = @finalEntry + @entryXML      
   SET @finalTR = REPLACE(@finalTR, '##EffectiveDate##', convert(VARCHAR(max), convert(DATETIME, @tEffectiveDate), 112))    
   SET @finalTR = REPLACE(@finalTR, '##PlannedActivity##', ISNULL(@tPlannedActivity, 'UNK'))    
        
   SET @finalEntry = REPLACE(@finalEntry, '##EffectiveDate##', convert(VARCHAR(max), convert(DATETIME, @tEffectiveDate), 112))    
   SET @finalEntry = REPLACE(@finalEntry, '##PlannedActivity##', ISNULL(@tPlannedActivity, 'UNK'))    
   SET @finalEntry = REPLACE(@finalEntry, '##Status##', ISNULL(@tStatus, 'UNK'))    
   SET @loopCOUNT = @loopCOUNT + 1    
    
   --PRINT @finalTR    
   --PRINT @finalEntry    
    
   FETCH NEXT    
   FROM tCursor    
   INTO @tEffectiveDate    
    ,@tPlannedActivity    
    ,@tStatus    
  END    
    
  CLOSE tCursor    
    
  DEALLOCATE tCursor    
    
  SET @FinalComponentXML = REPLACE(@PLACEHOLDERXML, '###TRSECTION###', @finalTR)    
  SET @FinalComponentXML = REPLACE(@FinalComponentXML, '###ENTRYSECTION###', @finalEntry)    
  SET @OutputComponentXML = @FinalComponentXML    
 END
     
END    
GO


