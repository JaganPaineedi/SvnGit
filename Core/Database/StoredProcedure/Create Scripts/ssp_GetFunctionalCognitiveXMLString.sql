/****** Object:  StoredProcedure [dbo].[ssp_GetFunctionalCognitiveXMLString]    Script Date: 09/22/2017 18:00:01 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetFunctionalCognitiveXMLString]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetFunctionalCognitiveXMLString]
GO


/****** Object:  StoredProcedure [dbo].[ssp_GetFunctionalCognitiveXMLString]    Script Date: 09/22/2017 18:00:01 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_GetFunctionalCognitiveXMLString] @ClientId INT = NULL    
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
			<templateId root="2.16.840.1.113883.10.20.22.2.14"/>
			<!--  ******** Functional status section template   ******** -->
			<code code="47420-5" codeSystem="2.16.840.1.113883.6.1"/>
			<title>FUNCTIONAL STATUS</title>
			<text>No Records Found</text>
			<entry
			   typeCode="DRIV">
				<observation classCode="OBS" moodCode="EVN">
					<!-- Problem observation template -->
					<templateId root="2.16.840.1.113883.10.20.22.4.68"/>
					<id root="ab1791b0-5c71-11db-b0de-0800200c9a66"/>
					<code xsi:type="CE" code="409586006" codeSystem="2.16.840.1.113883.6.96" displayName="Complaint"/>
					<text>
						<reference value="#fs1"/>
					</text>
					<statusCode code="completed"/>
					<effectiveTime>
						<low value="20120806"/>
					</effectiveTime>
					<value xsi:type="CD" code="105504002" codeSystem="2.16.840.1.113883.6.96" displayName="Dependence on Cane"/>
				</observation>
			</entry>
			<entry typeCode="DRIV">
				<observation classCode="OBS" moodCode="EVN">
					<!-- Cognitive Status Problem observation template -->
					<templateId root="2.16.840.1.113883.10.20.22.4.73"/>
					<id root="ab1791b0-5c71-11db-b0de-0800200c9a66"/>
					<code xsi:type="CE" code="373930000" codeSystem="2.16.840.1.113883.6.96" displayName="Cognitive Function Finding"/>
					<text>
						<reference value="#fs2"/>
					</text>
					<statusCode code="completed"/>
					<effectiveTime>
						<low value="20120806"/>
					</effectiveTime>
					<value xsi:type="CD" code="48167000" codeSystem="2.16.840.1.113883.6.96" displayName="Amnesia"/>
				</observation>
			</entry>
		</section>
	</component>'  
 
 SET @OutputComponentXML = NULL    
 IF EXISTS (  
  SELECT *  
  FROM sys.objects  
  WHERE object_id = OBJECT_ID(N'[dbo].[csp_GetFunctionalCognitiveXMLString]')  
   AND type IN (  
    N'P'  
    ,N'PC'  
    )  
  )  
  BEGIN  
   EXEC csp_GetFunctionalCognitiveXMLString @ClientId  
    ,@Type  
    ,@DocumentVersionId  
    ,@FromDate  
    ,@ToDate  
    ,@OutputComponentXML  OUTPUT
  END  
 
  IF @OutputComponentXML IS NULL OR @OutputComponentXML = '' 
  BEGIN  
   SET @OutputComponentXML = @DefaultComponentXML  
  END   
   
END  
  
GO


