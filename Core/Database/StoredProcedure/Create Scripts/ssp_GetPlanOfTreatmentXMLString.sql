/****** Object:  StoredProcedure [dbo].[ssp_GetPlanOfTreatmentXMLString]    Script Date: 09/22/2017 18:10:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetPlanOfTreatmentXMLString]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetPlanOfTreatmentXMLString]
GO



/****** Object:  StoredProcedure [dbo].[ssp_GetPlanOfTreatmentXMLString]    Script Date: 09/22/2017 18:10:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_GetPlanOfTreatmentXMLString] @ClientId INT = NULL    
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
               <templateId root="2.16.840.1.113883.10.20.22.2.10"/>  
               <!--  **** Plan of Care section template  **** -->  
               <code code="18776-5" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Treatment plan"/>  
               <title>CARE PLAN</title>  
               <text>No Recors Found</text>  
               <entry typeCode="DRIV">  
                  <act classCode="ACT" moodCode="INT">  
                     <templateId root="2.16.840.1.113883.10.20.22.4.20"/>  
                     <!-- ** Instructions Template ** -->  
                     <code xsi:type="CE" code="409073007" codeSystem="2.16.840.1.113883.6.96" displayName="instruction"/>  
                     <text>Admit Yourself to Community Health and Hospitals for Pnuemonia</text>  
                     <statusCode code="completed"/>  
                  </act>  
               </entry>  
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
   
   EXEC csp_GetPlanOfTreatmentXMLString @ClientId  
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


