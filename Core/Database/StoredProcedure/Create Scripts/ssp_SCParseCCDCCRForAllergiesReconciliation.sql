/****** Object:  StoredProcedure [dbo].[ssp_SCParseCCDCCRForAllergiesReconciliation]    Script Date: 05/19/2016 14:54:01 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCParseCCDCCRForAllergiesReconciliation]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_SCParseCCDCCRForAllergiesReconciliation]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCParseCCDCCRForAllergiesReconciliation]    Script Date: 05/19/2016 14:54:01 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
      
          
 CREATE PROCEDURE [dbo].[ssp_SCParseCCDCCRForAllergiesReconciliation] @XMLData AS XML                
 ,@FileName AS VARCHAR(250)                
AS /*********************************************************************/                
/* Stored Procedure: dbo.ssp_SCParseCCDCCRForAllergiesReconciliation            */                
/* Creation Date:    27/Jan/2015                  */                
/* Purpose:  To Get Allergy from XML data                */                
/*    Exec ssp_SCParseCCDCCRForAllergiesReconciliation                                              */                
/* Input Parameters:                           */                
/* Date    Author   Purpose              */              
/* 28/Sep/2017  Gautam/Alok   Created  Ref: task #26.2 Meaningful Use - Stage 3   */               
/*********************************************************************/                
BEGIN                
 BEGIN TRY                
  DECLARE @XMLTempdata VARCHAR(max)                
  DECLARE @FinalXMLData XML                
  DECLARE @crlf CHAR(2)                
  DECLARE @legalAuthenticator VARCHAR(max)                
                
  SELECT @legalAuthenticator = isnull(ltrim(rtrim(@FinalXMLData.value('(ClinicalDocument/legalAuthenticator/assignedEntity/representedOrganization/telecom/@value)[1]', 'varchar(MAX)'))), 'Get Well Clinic')                
                
  SELECT @crlf = CHAR(13) + CHAR(10)                
                
  SELECT @XMLTempdata = replace(cast(@XMLData AS VARCHAR(max)), 'xmlns="urn:hl7-org:v3"', '')                
                
  SELECT @FinalXMLData = cast(@XMLTempdata AS XML)                
                
  CREATE TABLE #AllergyData (                
   RXNormCode VARCHAR(max)                
   ,AllergyDesc VARCHAR(max)                
   ,Reaction VARCHAR(max)                
   ,Severity VARCHAR(max)                
   ,LastModificationDate VARCHAR(max)                
   ,LastModificationDateFormatted DATETIME                
   ,AdditionalInfomrmation VARCHAR(max)                
   ,SourceInformation VARCHAR(max)              
   ,AllergenConceptId int         
   ,ReactionId Int        
   ,SeverityId int             
   )                
               
   CREATE TABLE #AllergenConcept (                
   RXNormCode VARCHAR(max)                
   ,AllergenConceptId int            
   ,MappingInactiveDate datetime            
   ,MappingAddDate datetime            
   ,Dayscount int)               
               
  INSERT INTO #AllergyData (                
   RXNormCode                
   ,AllergyDesc                
   ,Reaction                
   ,Severity            
   ,LastModificationDate                
   ,SourceInformation                
   )                
  SELECT isnull(ltrim(rtrim(m.c.value('data((./@code)[1])', 'varchar(MAX)'))), '')                
   ,isnull(ltrim(rtrim(m.c.value('data((./@displayName)[1])', 'varchar(MAX)'))), '')                
   ,isnull(ltrim(rtrim(m.c.value('data((../../../../entryRelationship[2]/observation/value/@displayName)[1])', 'varchar(MAX)'))), '')                
   ,isnull(ltrim(rtrim(m.c.value('data((../../../../entryRelationship[3]/observation/value/@displayName)[1])', 'varchar(MAX)'))), '')                
   ,isnull(ltrim(rtrim(m.c.value('data((../../../../entryRelationship/observation/effectiveTime/low/@value)[1])', 'varchar(MAX)'))), '')                
   ,isnull(@legalAuthenticator + ' (' + @FileName + ')', '')                
  FROM @FinalXMLData.nodes('ClinicalDocument/component/structuredBody/component/section/entry/act/entryRelationship/observation/participant/participantRole/playingEntity/code') AS m(c)                
  WHERE m.c.exist('../../../../../../../../templateId[@root ="2.16.840.1.113883.10.20.22.2.6.1"]') = 1                
                
  UPDATE AD                
  SET AD.LastModificationDateFormatted = cast(CONVERT(VARCHAR(20), CONVERT(DATE, CONVERT(VARCHAR(8), LastModificationDate), 112), 110) AS DATETIME)                  FROM #AllergyData AD                
            
            
  IF exists(Select 1 from #AllergyData where RXNormCode is not null)            
 begin            
     Insert into #AllergenConcept(RXNormCode,AllergenConceptId,MappingInactiveDate,MappingAddDate,Dayscount)            
  SELECT distinct A.RXNormCode, ac.AllergenConceptId  ,l.MappingInactiveDate,l.MappingAddDate,datediff(day, getdate(), l.MappingInactiveDate)              
  FROM MDAllergenConcepts AS ac              
  JOIN MDAllergenGroups AS ag ON ag.AllergenGroupId = ac.AllergenGroupId              
  JOIN MDExternalConceptMappings AS l ON l.FirstDatabankVocabularyType = 110              
 AND l.FirstDatabankVocabularyIdentifier = ag.ExternalAllergenGroupId              
  JOIN #AllergyData A on A.RXNormCode=l.RXNormCode            
            
   union            
  SELECT distinct A.RXNormCode, ac.AllergenConceptId,l.MappingInactiveDate,l.MappingAddDate  ,datediff(day, getdate(), l.MappingInactiveDate)              
  FROM MDAllergenConcepts AS ac              
  JOIN MDMedicationNames AS mn ON mn.MedicationNameId = ac.MedicationNameId              
  JOIN MDExternalConceptMappings AS l ON l.FirstDatabankVocabularyType = 1              
   AND l.FirstDatabankVocabularyIdentifier = mn.ExternalMedicationNameId              
  JOIN #AllergyData A on A.RXNormCode=l.RXNormCode            
                 
  union            
SELECT distinct A.RXNormCode, ac.AllergenConceptId,l.MappingInactiveDate,l.MappingAddDate,datediff(day, getdate(), l.MappingInactiveDate)              
  FROM MDAllergenConcepts AS ac              
  JOIN MDHierarchicalIngredientCodes AS hic ON hic.HierarchicalIngredientCodeId = ac.HierarchicalIngredientCodeId              
  JOIN MDExternalConceptMappings AS l ON l.FirstDatabankVocabularyType = 104              
   AND l.FirstDatabankVocabularyIdentifier = hic.ExternalHierarchicalIngredientCodeId              
  JOIN #AllergyData A on A.RXNormCode=l.RXNormCode            
  --ORDER BY CASE               
  --  WHEN l.MappingInactiveDate IS NULL              
  --   THEN 1000              
  --  ELSE datediff(day, getdate(), l.MappingInactiveDate)              
  --  END DESC              
  -- ,l.MappingAddDate DESC              
end            
            
  Insert into Globalcodes (Category,CodeName,Active,CannotModifyNameOrDelete)        
  Select distinct 'ALLERGYREACTION',M.Reaction,'Y','Y'        
  From #AllergyData M        
  Where ISNULL(M.Reaction,'') <> ''       
  and not exists(Select 1 from Globalcodes g where g.CodeName=M.Reaction  AND g.Category = 'AllergyReaction'  )        
          
  Insert into Globalcodes (Category,CodeName,Active,CannotModifyNameOrDelete)        
  Select distinct 'ALLERGYSEVERITY',M.Severity,'Y','Y'        
  From #AllergyData M        
  Where ISNULL(M.Severity,'') <> ''    
  and not exists(Select 1 from Globalcodes g where g.CodeName=M.Severity  AND g.Category = 'AllergySeverity'  )        
          
  UPDATE AD                
  SET AD.AllergenConceptId = ac.AllergenConceptId              
  FROM #AllergyData AD    join #AllergenConcept AC on AD.RXNormCode=AC.RXNormCode            
          
  UPDATE AD                
  SET AD.ReactionId = ac.GlobalcodeId              
  FROM #AllergyData AD  join Globalcodes AC on AD.Reaction=AC.CodeName         
  where AC.Category='AllergyReaction' and isnull(AC.RecordDeleted,'N')='N'            
          
  UPDATE AD                
  SET AD.SeverityId = ac.GlobalcodeId              
  FROM #AllergyData AD  join Globalcodes AC on AD.Severity=AC.CodeName         
  where AC.Category='AllergySeverity' and isnull(AC.RecordDeleted,'N')='N'          
                
  --select * from #AllergyData                
  SELECT Ad.RXNormCode                
   ,Ad.AllergyDesc                
   ,CASE                 
    WHEN Ad.RXNormCode = '7982'                
     THEN 4038                
    WHEN Ad.RXNormCode = '2670'                
     THEN 493                
    WHEN Ad.RXNormCode = '1191'                
     THEN 1162                
    WHEN Ad.RXNormCode = '10185'                
     THEN 148                
    WHEN Ad.RXNormCode = '7984'                
     THEN 2290                
    WHEN Ad.RXNormCode = '2002'                
     THEN 525                
    WHEN Ad.RXNormCode = '9524'                
     THEN 1056            
    ELSE ad.AllergenConceptId              
    END AS 'AllergenConceptId'                
   ,CASE Ad.RXNormCode                
    WHEN '2002'                
     THEN isNull('Source: ' + SourceInformation + @crlf + 'Reaction:' + Reaction + @crlf + 'Status:Inactive' + @crlf + 'Last Modification Date:' + convert(VARCHAR(20), LastModificationDateFormatted, 110), '')                
    ELSE isNull('Source: ' + SourceInformation + @crlf + 'Reaction:' + Reaction + @crlf + 'Status:Active' + @crlf + 'Last Modification Date:' + convert(VARCHAR(20), LastModificationDateFormatted, 110), '')                
    END AS AdditionalInformation              
    ,ReactionId as Reaction              
    ,SeverityId as Severity            
  FROM #AllergyData Ad                
 END TRY                
                
 BEGIN CATCH                
  DECLARE @Error VARCHAR(max)                
                
  SET @Error = convert(VARCHAR, error_number()) + '*****' + convert(VARCHAR(4000), error_message()) + '*****'              
   + isnull(convert(VARCHAR, error_procedure()), 'ssp_SCParseCCDCCRForAllergiesReconciliation') + '*****' +               
   convert(VARCHAR, error_line()) + '*****' + convert(VARCHAR, error_severity()) + '*****' + convert(VARCHAR, error_state())                
                
  RAISERROR (                
    @Error                
    ,                
    -- Message text.                                                      
    16                
    ,                
    -- Severity.                                                                                                           
    1                
    -- State.                                                                                                           
    );                
 END CATCH                
END 