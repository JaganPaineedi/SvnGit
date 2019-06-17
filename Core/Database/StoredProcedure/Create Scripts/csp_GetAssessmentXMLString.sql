/****** Object:  StoredProcedure [dbo].[csp_GetAssessmentXMLString]    Script Date: 09/24/2017 14:53:25 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_GetAssessmentXMLString]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_GetAssessmentXMLString]
GO


/****** Object:  StoredProcedure [dbo].[csp_GetAssessmentXMLString]    Script Date: 09/24/2017 14:53:25 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[csp_GetAssessmentXMLString] @ClientId INT = NULL    
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
			<!-- Assessment Section -db -->
			<!-- There is no R2.1 (or 2.0) version of Assessment Section, using R1.1 templateId only -db -->
			<templateId root="2.16.840.1.113883.10.20.22.2.8"/>
			<code codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" code="51848-0" displayName="ASSESSMENTS"/>
			<title>ASSESSMENTS</title>
			###ENTRYSECTION###
		</section>
	</component>'  
   
 DECLARE @entryXML VARCHAR(MAX) =   
    '<text>##Assessment##</text>'  
     
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
  
 DECLARE @tAssessment VARCHAR(300) = ''  
 DECLARE @tEffectiveDate VARCHAR(100) = ''  
   
--Converting rows to columns  
 DECLARE @tempResults TABLE (  
  [EffectiveDate] DATETIME  
  ,[Assessment] VARCHAR(MAX)  
  )    
 INSERT INTO @tempResults  
   select EffectiveDate,     
   max(case when OrderName = 'Assessment' and Question = 'Assessment'  then answer end) Assessment     
   from @tResults where OrderName = 'Assessment' group by EffectiveDate  
  
 IF EXISTS (  
   SELECT *  
   FROM @tempResults  
   )  
	 BEGIN  
	  DECLARE tCursor CURSOR FAST_FORWARD  
	  FOR  
	  SELECT [EffectiveDate]  
	   ,[Assessment]  
	  FROM @tempResults TDS  
	  
	  OPEN tCursor  
	  
	  FETCH NEXT  
	  FROM tCursor  
	  INTO @tEffectiveDate  
	   ,@tAssessment  
	     
	  WHILE (@@FETCH_STATUS = 0)  
	  BEGIN  
	   SET @finalEntry = @finalEntry + @entryXML  
	   SET @finalEntry = REPLACE(@finalEntry, '##Assessment##', ISNULL(@tAssessment, 'UNK'))  
	   SET @loopCOUNT = @loopCOUNT + 1  
	  
	   --PRINT @finalEntry  
	  
	   FETCH NEXT  
	   FROM tCursor  
	   INTO @tEffectiveDate  
		,@tAssessment  
	  END  
	  
	  CLOSE tCursor  
	  
	  DEALLOCATE tCursor  
	  
	  SET @FinalComponentXML = REPLACE(@PLACEHOLDERXML, '###ENTRYSECTION###', @finalEntry)  
	  SET @OutputComponentXML = @FinalComponentXML  
	 END  
	  
END  
  
GO
