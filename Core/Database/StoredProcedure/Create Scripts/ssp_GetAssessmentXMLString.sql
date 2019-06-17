/****** Object:  StoredProcedure [dbo].[ssp_GetAssessmentXMLString]    Script Date: 09/22/2017 18:47:19 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetAssessmentXMLString]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetAssessmentXMLString]
GO



/****** Object:  StoredProcedure [dbo].[ssp_GetAssessmentXMLString]    Script Date: 09/22/2017 18:47:19 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_GetAssessmentXMLString] @ClientId INT = NULL    
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
			<!-- Assessment Section -db -->
			<!-- There is no R2.1 (or 2.0) version of Assessment Section, using R1.1 templateId only -db -->
			<templateId root="2.16.840.1.113883.10.20.22.2.8"/>
			<code codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" code="51848-0" displayName="ASSESSMENTS"/>
			<title>ASSESSMENTS</title>
			<text>No Records Found</text>
		</section>
	</component>'
	
 SET @OutputComponentXML = NULL	 
 IF EXISTS (  
  SELECT *  
  FROM sys.objects  
  WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetSOCFunctionalCognitiveDetails]')  
   AND type IN (  
    N'P'  
    ,N'PC'  
    )  
  )  
  BEGIN  
   EXEC csp_GetAssessmentXMLString @ClientId  
    ,@Type  
    ,@DocumentVersionId  
    ,@FromDate  
    ,@ToDate  
    ,@OutputComponentXML OUTPUT
  END  
 
  IF @OutputComponentXML IS NULL OR @OutputComponentXML = '' 
  BEGIN  
   SET @OutputComponentXML = @DefaultComponentXML  
  END  
     
END  
  
GO


