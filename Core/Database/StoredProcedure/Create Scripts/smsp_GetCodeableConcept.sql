/****** Object:  StoredProcedure [dbo].[smsp_GetCodeableConcept]    Script Date: 10/04/2017 13:24:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[smsp_GetCodeableConcept]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[smsp_GetCodeableConcept]
GO


/****** Object:  StoredProcedure [dbo].[smsp_GetCodeableConcept]    Script Date: 10/04/2017 13:24:05 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

  
    
CREATE PROCEDURE [dbo].[smsp_GetCodeableConcept] @ClientId INT =null    
, @Text VARCHAR(100) =null    
, @Type VARCHAR(100) =null    
, @FromDate DATETIME =null    
, @ToDate DATETIME =null    
, @JsonResult VARCHAR(MAX) OUTPUT  
-- =============================================                                
-- Author:  Vijay                                
-- Create date: 9/8/2017                
-- Description: Retrieves CCD XML for Summary Of Care      
-- Task:   MUS3 - Task#30 Application Access - Patient Selection (G7)                
/*                                
 Author   Modified Date   Reason                                
*/      
AS    
BEGIN    
 BEGIN TRY      
      
  IF(@Text = 'MaritalStatus')    
   --A Annulled Marriage contract has been declared null and to not have existed    
   --D Divorced  Marriage contract has been declared dissolved and inactive    
   --I Interlocutory  Subject to an Interlocutory Decree.    
   --L Legally Separated  Legally Separated    
   --M Married  A current marriage contract is active    
   --P Polygamous  More than 1 current spouse    
   --S Never Married No marriage contract has ever been entered    
   --T Domestic  partner Person declares that a domestic partner relationship exists.    
   --U unmarried  Currently not in a marriage contract.    
   --W Widowed  The spouse has died    
   --UNK unknown  Description:    
  BEGIN    
   SELECT @JsonResult = dbo.smsf_FlattenedJSON((    
    SELECT DISTINCT c.ClientId    
     ,'http://hl7.org/fhir/ValueSet/marital-status' as [System] --Identity of the terminology system    
     ,'2016-11-11' as [Version] --Version of the system - if relevant    
     ,CASE gc.CodeName   --Symbol in syntax defined by the system    
      WHEN 'Divorced/Annulled'    
       THEN 'A'    
      WHEN 'Divorced'    
       THEN 'D'    
      WHEN 'Interlocutory'    
       THEN 'I'    
      WHEN 'Separated'    
       THEN 'L'    
      WHEN 'Married'    
       THEN 'M'    
      WHEN 'Remarried'    
       THEN 'P'    
      WHEN 'Never married'    
       THEN 'S'    
      WHEN 'Domestic partner'    
       THEN 'T'    
      WHEN 'Single / Never Married'    
       THEN 'U'    
      WHEN 'Widowed'    
       THEN 'W'    
      ELSE 'UNK'    
      END AS [Code]    
     ,CASE gc.CodeName   --Representation defined by the system    
      WHEN 'Divorced/Annulled'    
       THEN 'Annulled'    
      WHEN 'Divorced'    
       THEN 'Divorced'    
      WHEN 'Interlocutory'    
       THEN 'Interlocutory'    
      WHEN 'Separated'    
       THEN 'Legally Separated'    
      WHEN 'Married'    
       THEN 'Married'    
      WHEN 'Remarried'    
       THEN 'Polygamous'    
      WHEN 'Never married'    
       THEN 'Never Married'    
      WHEN 'Domestic partner'    
       THEN 'Domestic partner'    
      WHEN 'Single / Never Married'    
       THEN 'Unmarried'    
      WHEN 'Widowed'    
       THEN 'Widowed'    
      ELSE 'unknown'    
      END AS Display    
     ,'false' as userSelected --If this coding was chosen directly by the user    
    FROM Clients c    
    INNER JOIN GlobalCodes gc ON gc.GlobalCodeId = c.MaritalStatus    
    WHERE c.ClientId = @ClientId        
    FOR XML path    
     ,root    
    ))              
   END    
  ELSE IF(@Text = 'Relationship')    
   --BP Billing contact person - deprecated - added v2.3, removed after v2.3    
   --C  Emergency Contact  - added v2.5    
   --CP Contact person - deprecated - added v2.3, removed after v2.3    
   --E  Employer  - added v2.5    
   --EP Emergency contact person - deprecated - added v2.3, removed after v2.3    
   --F  Federal Agency  - added v2.5    
   --I  Insurance Company  - added v2.5    
   --N  Next-of-Kin  - added v2.5    
   --O  Other  - added v2.5    
   --PR Person preparing referral - deprecated - added v2.3, removed after v2.3    
   --S  State Agency  - added v2.5    
   --U  Unknown  - added v2.5    
   BEGIN    
   SELECT @JsonResult = dbo.smsf_FlattenedJSON((    
    SELECT DISTINCT c.ClientId    
     ,'http://hl7.org/fhir/v2/0131' as [System] --Identity of the terminology system    
     ,'v2.5' as [Version]  --Version of the system - if relevant    
     ,CASE gc.CodeName   --Symbol in syntax defined by the system    
      WHEN 'Emergency Contact'    
       THEN 'C'    
      WHEN 'Contact person'    
       THEN 'CP'    
      WHEN 'Employer'    
       THEN 'E'    
      WHEN 'Emergency contact person'    
       THEN 'EP'    
      WHEN 'Federal Agency'    
       THEN 'F'    
      WHEN 'Insurance Company'    
       THEN 'I'    
      WHEN 'Next-of-Kin'    
       THEN 'N'    
      WHEN 'Other'    
       THEN 'O'    
      WHEN 'Person preparing referral'    
       THEN 'PR'    
      WHEN 'State Agency'    
       THEN 'S'    
      ELSE 'U' --Unknown    
      END AS [Code]    
     ,gc.CodeName  AS Display   --Representation defined by the system    
     ,'false' as userSelected --If this coding was chosen directly by the user    
    FROM Clients c    
    INNER JOIN GlobalCodes gc ON gc.GlobalCodeId = c.MaritalStatus    
    WHERE c.ClientId = @ClientId     
    AND c.Active = 'Y' AND ISNULL(c.RecordDeleted,'N')='N'        
    FOR XML path    
     ,root    
    ))    
   END    
   ELSE IF(@Text = 'Species')     
   BEGIN    
   SELECT @JsonResult = dbo.smsf_FlattenedJSON((    
    SELECT DISTINCT c.ClientId    
     ,'' as [System]  --Identity of the terminology system    
     ,'' as [Version] --Version of the system - if relevant    
     ,''AS [Code]    
     ,'' AS Display    
     ,'false' as userSelected --If this coding was chosen directly by the user    
    FROM Clients c    
    WHERE c.ClientId = @ClientId     
    AND c.Active = 'Y' AND ISNULL(c.RecordDeleted,'N')='N'        
    FOR XML path    
     ,root    
    ))    
   END    
   ELSE IF(@Text = 'Breed')     
   BEGIN    
   SELECT @JsonResult = dbo.smsf_FlattenedJSON((    
    SELECT DISTINCT c.ClientId    
     ,'' as [System]  --Identity of the terminology system    
     ,'' as [Version] --Version of the system - if relevant    
     ,''AS [Code]    
     ,'' AS Display    
     ,'false' as userSelected --If this coding was chosen directly by the user    
    FROM Clients c    
    WHERE c.ClientId = @ClientId     
    AND c.Active = 'Y' AND ISNULL(c.RecordDeleted,'N')='N'        
    FOR XML path    
     ,root    
    ))    
   END    
   ELSE IF(@Text = 'GenderStatus')     
   BEGIN    
   SELECT @JsonResult = dbo.smsf_FlattenedJSON((    
    SELECT DISTINCT c.ClientId    
     ,'' as [System]  --Identity of the terminology system    
     ,'' as [Version] --Version of the system - if relevant    
     ,''AS [Code]    
     ,'' AS Display    
     ,'false' as userSelected --If this coding was chosen directly by the user    
    FROM Clients c    
    WHERE c.ClientId = @ClientId     
    AND c.Active = 'Y' AND ISNULL(c.RecordDeleted,'N')='N'        
    FOR XML path    
     ,root    
    ))    
   END    
   ELSE IF(@Text = 'Language')    
   BEGIN    
   SELECT @JsonResult = dbo.smsf_FlattenedJSON((    
    SELECT DISTINCT c.ClientId    
     ,'http://hl7.org/fhir/ValueSet/languages' as [System] --Identity of the terminology system    
     ,'' as [Version]  --Version of the system - if relevant    
     ,CASE gc.CodeName   --Symbol in syntax defined by the system    
      WHEN 'Arabic' THEN 'ar'    
      WHEN 'Bengali' THEN 'bn'    
      WHEN 'Czech' THEN 'cs'    
      WHEN 'Danish' THEN 'da'    
      WHEN 'German' THEN 'de'    
      WHEN 'German (Austria)' THEN 'de-AT'    
      WHEN 'German (Switzerland)' THEN 'de-CH'    
      WHEN 'German (Germany)' THEN 'de-DE'    
      WHEN 'Greek' THEN 'el'      
      WHEN 'English' THEN 'en'    
      WHEN 'English (Australia)' THEN 'en-AU'    
      WHEN 'English (Canada)' THEN 'en-CA'    
      WHEN 'English (Great Britain)' THEN 'en-GB'    
      WHEN 'English (India)' THEN 'en-IN'    
      WHEN 'English (New Zeland)' THEN 'en-NZ'    
      WHEN 'English (Singapore)' THEN 'en-SG'    
      WHEN 'English (United States)' THEN 'en-US'    
      WHEN 'Spanish' THEN 'es'    
      WHEN 'Spanish (Argentina)' THEN 'es-AR'    
      WHEN 'Spanish (Spain)' THEN 'es-ES'    
      WHEN 'Spanish (Uruguay)' THEN 'es-UY'    
      WHEN 'Finnish' THEN 'fi'    
      WHEN 'French' THEN 'fr'    
      WHEN 'French (Belgium)' THEN 'fr-BE'      
      WHEN 'French (Switzerland)' THEN 'fr-CH'      
      WHEN 'French (France)' THEN 'fr-FR'      
      WHEN 'Frysian' THEN 'fy'      
      WHEN 'Frysian (Netherlands)' THEN 'fy-NL'      
      WHEN 'Hindi' THEN 'hi'      
      WHEN 'Croatian' THEN 'hr'      
      WHEN 'Italian' THEN 'it'    
      WHEN 'Italian (Switzerland)' THEN 'it-CH'    
      WHEN 'Italian (Italy)' THEN 'it-IT'    
      WHEN 'Japanese' THEN 'ja'    
      WHEN 'Korean' THEN 'ko'    
      WHEN 'Dutch' THEN 'nl'    
      WHEN 'Dutch (Belgium)' THEN 'nl-BE'    
      WHEN 'Dutch (Netherlands)' THEN 'nl-NL'    
      WHEN 'Norwegian' THEN 'no'    
      WHEN 'Norwegian (Norway)' THEN 'no-NO'      
      WHEN 'Punjabi' THEN 'pa'      
      WHEN 'Portuguese' THEN 'pt'      
      WHEN 'Portuguese (Brazil)' THEN 'pt-BR'      
      WHEN 'Russian' THEN 'ru'      
      WHEN 'Russian (Russia)' THEN 'ru-RU'      
      WHEN 'Serbian' THEN 'sr'    
      WHEN 'Serbian (Serbia)' THEN 'sr-SP'      
      WHEN 'Swedish' THEN 'sv'      
      WHEN 'Swedish (Sweden)' THEN 'sv-SE'      
      WHEN 'Telegu' THEN 'te'      
      WHEN 'Chinese' THEN 'zh'      
      WHEN 'Chinese (China)' THEN 'zh-CN'      
      WHEN 'Chinese (Hong Kong)' THEN 'zh-HK'    
      WHEN 'Chinese (Singapore)' THEN 'zh-SG'      
      WHEN 'Chinese (Taiwan)' THEN 'zh-TW'    
      ELSE 'U' --Unknown    
      END AS [Code]    
     ,gc.CodeName AS Display --Representation defined by the system           
     ,'false' as userSelected  --If this coding was chosen directly by the user    
    FROM Clients c    
    INNER JOIN GlobalCodes gc ON gc.GlobalCodeId = c.PrimaryLanguage    
    WHERE c.ClientId = @ClientId     
    AND c.Active = 'Y' AND ISNULL(c.RecordDeleted,'N')='N'        
    FOR XML path    
     ,root    
    ))    
   END    
--ALLERGIES       
   ELSE IF(@Text = 'AllergiesCode')    
   BEGIN    
   SELECT @JsonResult = dbo.smsf_FlattenedJSON((    
    SELECT DISTINCT c.ClientId    
     ,'http://hl7.org/fhir/ValueSet/allergyintolerance-code' as [System] --Identity of the terminology system    
     ,'' as [Version]  --Version of the system - if relevant    
     ,g.Code AS [Code]   --Symbol in syntax defined by the system    
     ,g.CodeName AS Display --Representation defined by the system           
     ,'false' as userSelected  --If this coding was chosen directly by the user    
    FROM Clients c    
    INNER JOIN ClientAllergies ca ON ca.ClientId = c.ClientId    
    LEFT JOIN GlobalCodes g ON g.GlobalCodeId = ca.SNOMEDCode        
    WHERE c.ClientId = @ClientId     
    AND c.Active = 'Y' AND ISNULL(c.RecordDeleted,'N')='N'        
    FOR XML path    
     ,root    
    ))    
   END    
  ELSE IF(@Text = 'Substance')    
   BEGIN    
   SELECT @JsonResult = dbo.smsf_FlattenedJSON((    
    SELECT DISTINCT c.ClientId    
     ,'http://hl7.org/fhir/ValueSet/substance-code' as [System] --Identity of the terminology system    
     ,'' as [Version]  --Version of the system - if relevant    
     ,g.Code AS [Code]   --Symbol in syntax defined by the system    
     ,g.CodeName AS Display --Representation defined by the system          
     ,'false' as userSelected  --If this coding was chosen directly by the user    
    FROM Clients c    
    INNER JOIN ClientAllergies ca ON ca.ClientId = c.ClientId    
    LEFT JOIN GlobalCodes g ON g.GlobalCodeId = ca.SNOMEDCode     
    WHERE c.ClientId = @ClientId     
    AND c.Active = 'Y' AND ISNULL(c.RecordDeleted,'N')='N'        
    FOR XML path    
     ,root    
    ))    
   END    
  ELSE IF(@Text = 'Manifestation')    
   BEGIN    
   SELECT @JsonResult = dbo.smsf_FlattenedJSON((    
    SELECT DISTINCT c.ClientId    
     ,'http://hl7.org/fhir/ValueSet/clinical-findings' as [System] --Identity of the terminology system    
     ,'' as [Version]  --Version of the system - if relevant    
     ,g.Code AS [Code]   --Symbol in syntax defined by the system    
     ,g.CodeName AS Display --Representation defined by the system            
     ,'false' as userSelected  --If this coding was chosen directly by the user    
    FROM Clients c    
    INNER JOIN ClientAllergies ca ON ca.ClientId = c.ClientId    
    LEFT JOIN GlobalCodes g ON g.GlobalCodeId = ca.SNOMEDCode     
    WHERE c.ClientId = @ClientId     
    AND c.Active = 'Y' AND ISNULL(c.RecordDeleted,'N')='N'        
    FOR XML path    
     ,root    
    ))    
   END    
  ELSE IF(@Text = 'ExposureRoute')    
   BEGIN    
   SELECT @JsonResult = dbo.smsf_FlattenedJSON((    
    SELECT DISTINCT c.ClientId    
     ,'http://hl7.org/fhir/ValueSet/route-codes' as [System] --Identity of the terminology system    
     ,'' as [Version]  --Version of the system - if relevant    
     ,g.Code AS [Code]   --Symbol in syntax defined by the system    
     ,g.CodeName AS Display --Representation defined by the system           
     ,'false' as userSelected  --If this coding was chosen directly by the user    
    FROM Clients c    
    INNER JOIN ClientAllergies ca ON ca.ClientId = c.ClientId    
    LEFT JOIN GlobalCodes g ON g.GlobalCodeId = ca.SNOMEDCode     
    WHERE c.ClientId = @ClientId     
    AND c.Active = 'Y' AND ISNULL(c.RecordDeleted,'N')='N'        
    FOR XML path    
     ,root    
    ))    
   END    
--MEDICATIONS       
  ELSE IF(@Text = 'CurrentMedicationsCode')    
   BEGIN    
   SELECT @JsonResult = dbo.smsf_FlattenedJSON((    
    SELECT DISTINCT CM.ClientId    
     ,'http://hl7.org/fhir/ValueSet/medication-codes' as [System] --Identity of the terminology system    
     ,'' as [Version]  --Version of the system - if relevant    
     ,MDM.MedicationName AS Code   --Symbol in syntax defined by the system    
     ,MDM.MedicationName AS Display --Representation defined by the system           
     ,'false' as userSelected  --If this coding was chosen directly by the user    
     FROM ClientMedicationInstructions CMI    
     INNER JOIN ClientMedications CM ON (    
       CMI.ClientMedicationId = CM.ClientMedicationId    
       AND ISNULL(cm.RecordDeleted, 'N') <> 'Y'    
       )    
     LEFT JOIN GlobalCodes GC ON (GC.GlobalCodeID = CMI.Unit)    
      AND ISNULL(gc.RecordDeleted, 'N') <> 'Y'    
     LEFT JOIN GlobalCodes GC1 ON (GC1.GlobalCodeId = CMI.Schedule)    
      AND ISNULL(gc1.RecordDeleted, 'N') <> 'Y'    
     INNER JOIN MDMedicationNames MDM ON (    
       CM.MedicationNameId = MDM.MedicationNameId    
       AND ISNULL(mdm.RecordDeleted, 'N') <> 'Y'    
       )    
     INNER JOIN MDMedications MD ON (    
       MD.MedicationID = CMI.StrengthId    
       AND ISNULL(MD.RecordDeleted, 'N') <> 'Y'    
       )    
     LEFT JOIN MDDrugs MDD ON MDD.ClinicalFormulationId = md.ClinicalFormulationId AND  ISNULL(mdm.RecordDeleted, 'N') <> 'Y'    
     LEFT JOIN [Services] s ON (s.ClientId = cm.ClientId AND (s.DateOfService >= @FromDate and s.EndDateOfService <= @ToDate))    
     LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = cm.ClientId    
     LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId AND (ba.StartDate >= @FromDate and ba.EndDate <= @ToDate))     
     WHERE cm.ClientId = @ClientId    
      AND cm.discontinuedate IS NULL    
      AND Isnull(Discontinued, 'N') <> 'Y'    
      AND (isnull(cm.MedicationStartDate, Getdate()) <= GetDate())    
      AND ISNULL(cmi.Active, 'Y') = 'Y'    
      AND ISNULL(cmi.RecordDeleted, 'N') <> 'Y'    
     --ORDER BY MDM.MedicationName       
    FOR XML path    
     ,root    
    ))    
   END    
  ELSE IF(@Text = 'CurrentMedicationsForm')    
   BEGIN    
   SELECT @JsonResult = dbo.smsf_FlattenedJSON((    
    SELECT DISTINCT CM.ClientId    
     ,'http://hl7.org/fhir/ValueSet/medication-form-codes' as [System] --Identity of the terminology system    
     ,'' as [Version]  --Version of the system - if relevant    
     ,'' AS Code   --Symbol in syntax defined by the system    
     ,'' AS Display --Representation defined by the system           
     ,'false' as userSelected  --If this coding was chosen directly by the user    
    FROM ClientMedicationInstructions CMI    
     INNER JOIN ClientMedications CM ON (    
       CMI.ClientMedicationId = CM.ClientMedicationId    
       AND ISNULL(cm.RecordDeleted, 'N') <> 'Y'    
       )    
     LEFT JOIN GlobalCodes GC ON (GC.GlobalCodeID = CMI.Unit)    
      AND ISNULL(gc.RecordDeleted, 'N') <> 'Y'    
     LEFT JOIN GlobalCodes GC1 ON (GC1.GlobalCodeId = CMI.Schedule)    
      AND ISNULL(gc1.RecordDeleted, 'N') <> 'Y'    
     INNER JOIN MDMedicationNames MDM ON (    
       CM.MedicationNameId = MDM.MedicationNameId    
       AND ISNULL(mdm.RecordDeleted, 'N') <> 'Y'    
       )    
     INNER JOIN MDMedications MD ON (    
       MD.MedicationID = CMI.StrengthId    
       AND ISNULL(MD.RecordDeleted, 'N') <> 'Y'    
       )    
     LEFT JOIN MDDrugs MDD ON MDD.ClinicalFormulationId = md.ClinicalFormulationId AND  ISNULL(mdm.RecordDeleted, 'N') <> 'Y'    
     LEFT JOIN [Services] s ON (s.ClientId = cm.ClientId AND (s.DateOfService >= @FromDate and s.EndDateOfService <= @ToDate))    
     LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = cm.ClientId    
     LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId AND (ba.StartDate >= @FromDate and ba.EndDate <= @ToDate))     
     WHERE cm.ClientId = @ClientId    
      AND cm.discontinuedate IS NULL    
      AND Isnull(Discontinued, 'N') <> 'Y'    
      AND (isnull(cm.MedicationStartDate, Getdate()) <= GetDate())    
      AND ISNULL(cmi.Active, 'Y') = 'Y'    
      AND ISNULL(cmi.RecordDeleted, 'N') <> 'Y'    
      --ORDER BY MDM.MedicationName       
    FOR XML path    
     ,root    
    ))    
   END    
  ELSE IF(@Text = 'IngredientItemCodeableConcept')    
   BEGIN    
   SELECT @JsonResult = dbo.smsf_FlattenedJSON((    
    SELECT DISTINCT CM.ClientId    
     ,'' as [System] --Identity of the terminology system    
     ,'' as [Version]  --Version of the system - if relevant    
     ,'' AS Code   --Symbol in syntax defined by the system    
     ,'' AS Display --Representation defined by the system           
     ,'false' as userSelected  --If this coding was chosen directly by the user    
    FROM ClientMedicationInstructions CMI    
     INNER JOIN ClientMedications CM ON (    
       CMI.ClientMedicationId = CM.ClientMedicationId    
       AND ISNULL(cm.RecordDeleted, 'N') <> 'Y'    
       )    
     LEFT JOIN GlobalCodes GC ON (GC.GlobalCodeID = CMI.Unit)    
      AND ISNULL(gc.RecordDeleted, 'N') <> 'Y'    
     LEFT JOIN GlobalCodes GC1 ON (GC1.GlobalCodeId = CMI.Schedule)    
      AND ISNULL(gc1.RecordDeleted, 'N') <> 'Y'    
     INNER JOIN MDMedicationNames MDM ON (    
       CM.MedicationNameId = MDM.MedicationNameId    
       AND ISNULL(mdm.RecordDeleted, 'N') <> 'Y'    
       )    
     INNER JOIN MDMedications MD ON (    
       MD.MedicationID = CMI.StrengthId    
       AND ISNULL(MD.RecordDeleted, 'N') <> 'Y'    
       )    
     LEFT JOIN MDDrugs MDD ON MDD.ClinicalFormulationId = md.ClinicalFormulationId AND  ISNULL(mdm.RecordDeleted, 'N') <> 'Y'    
     LEFT JOIN [Services] s ON (s.ClientId = cm.ClientId AND (s.DateOfService >= @FromDate and s.EndDateOfService <= @ToDate))    
     LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = cm.ClientId    
     LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId AND (ba.StartDate >= @FromDate and ba.EndDate <= @ToDate))     
     WHERE cm.ClientId = @ClientId    
      AND cm.discontinuedate IS NULL    
      AND Isnull(Discontinued, 'N') <> 'Y'    
      AND (isnull(cm.MedicationStartDate, Getdate()) <= GetDate())    
      AND ISNULL(cmi.Active, 'Y') = 'Y'    
      AND ISNULL(cmi.RecordDeleted, 'N') <> 'Y'    
      --ORDER BY MDM.MedicationName       
    FOR XML path    
     ,root    
    ))    
   END       
  ELSE IF(@Text = 'PackageContainer')    
   BEGIN    
   SELECT @JsonResult = dbo.smsf_FlattenedJSON((    
    SELECT DISTINCT CM.ClientId    
     ,'' as [System] --Identity of the terminology system    
     ,'' as [Version]  --Version of the system - if relevant    
     ,'' AS Code   --Symbol in syntax defined by the system    
     ,'' AS Display --Representation defined by the system           
     ,'false' as userSelected  --If this coding was chosen directly by the user    
    FROM ClientMedicationInstructions CMI    
     INNER JOIN ClientMedications CM ON (    
       CMI.ClientMedicationId = CM.ClientMedicationId    
       AND ISNULL(cm.RecordDeleted, 'N') <> 'Y'    
       )    
     LEFT JOIN GlobalCodes GC ON (GC.GlobalCodeID = CMI.Unit)    
      AND ISNULL(gc.RecordDeleted, 'N') <> 'Y'    
     LEFT JOIN GlobalCodes GC1 ON (GC1.GlobalCodeId = CMI.Schedule)    
      AND ISNULL(gc1.RecordDeleted, 'N') <> 'Y'    
     INNER JOIN MDMedicationNames MDM ON (    
       CM.MedicationNameId = MDM.MedicationNameId    
       AND ISNULL(mdm.RecordDeleted, 'N') <> 'Y'    
       )    
     INNER JOIN MDMedications MD ON (    
       MD.MedicationID = CMI.StrengthId    
       AND ISNULL(MD.RecordDeleted, 'N') <> 'Y'    
       )    
     LEFT JOIN MDDrugs MDD ON MDD.ClinicalFormulationId = md.ClinicalFormulationId AND  ISNULL(mdm.RecordDeleted, 'N') <> 'Y'    
     LEFT JOIN [Services] s ON (s.ClientId = cm.ClientId AND (s.DateOfService >= @FromDate and s.EndDateOfService <= @ToDate))    
     LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = cm.ClientId    
     LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId AND (ba.StartDate >= @FromDate and ba.EndDate <= @ToDate))     
     WHERE cm.ClientId = @ClientId    
      AND cm.discontinuedate IS NULL    
      AND Isnull(Discontinued, 'N') <> 'Y'    
      AND (isnull(cm.MedicationStartDate, Getdate()) <= GetDate())    
      AND ISNULL(cmi.Active, 'Y') = 'Y'    
      AND ISNULL(cmi.RecordDeleted, 'N') <> 'Y'    
      --ORDER BY MDM.MedicationName       
    FOR XML path    
     ,root    
    ))    
   END    
  ELSE IF(@Text = 'ContentItemCodeableConcept')    
   BEGIN    
   SELECT @JsonResult = dbo.smsf_FlattenedJSON((    
    SELECT DISTINCT CM.ClientId    
     ,'' as [System] --Identity of the terminology system    
     ,'' as [Version]  --Version of the system - if relevant    
     ,'' AS Code   --Symbol in syntax defined by the system    
     ,'' AS Display --Representation defined by the system           
     ,'false' as userSelected  --If this coding was chosen directly by the user    
    FROM ClientMedicationInstructions CMI    
     INNER JOIN ClientMedications CM ON (    
       CMI.ClientMedicationId = CM.ClientMedicationId    
       AND ISNULL(cm.RecordDeleted, 'N') <> 'Y'    
       )    
     LEFT JOIN GlobalCodes GC ON (GC.GlobalCodeID = CMI.Unit)    
      AND ISNULL(gc.RecordDeleted, 'N') <> 'Y'    
     LEFT JOIN GlobalCodes GC1 ON (GC1.GlobalCodeId = CMI.Schedule)    
      AND ISNULL(gc1.RecordDeleted, 'N') <> 'Y'    
     INNER JOIN MDMedicationNames MDM ON (    
       CM.MedicationNameId = MDM.MedicationNameId    
       AND ISNULL(mdm.RecordDeleted, 'N') <> 'Y'    
       )    
     INNER JOIN MDMedications MD ON (    
       MD.MedicationID = CMI.StrengthId    
       AND ISNULL(MD.RecordDeleted, 'N') <> 'Y'    
       )    
     LEFT JOIN MDDrugs MDD ON MDD.ClinicalFormulationId = md.ClinicalFormulationId AND  ISNULL(mdm.RecordDeleted, 'N') <> 'Y'    
     LEFT JOIN [Services] s ON (s.ClientId = cm.ClientId AND (s.DateOfService >= @FromDate and s.EndDateOfService <= @ToDate))    
     LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = cm.ClientId    
     LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId AND (ba.StartDate >= @FromDate and ba.EndDate <= @ToDate))     
     WHERE cm.ClientId = @ClientId    
      AND cm.discontinuedate IS NULL    
      AND Isnull(Discontinued, 'N') <> 'Y'    
      AND (isnull(cm.MedicationStartDate, Getdate()) <= GetDate())    
      AND ISNULL(cmi.Active, 'Y') = 'Y'    
      AND ISNULL(cmi.RecordDeleted, 'N') <> 'Y'    
      --ORDER BY MDM.MedicationName       
    FOR XML path    
     ,root    
    ))    
   END    
--ACTIVEPROBLEMS       
  ELSE IF(@Text = 'ActiveProblemsCategory')
   BEGIN  
   
	 DECLARE @DocumentVersionId INT  
	 SELECT TOP 1 @DocumentVersionId = InProgressDocumentVersionId          
	 FROM Documents d          
     WHERE ClientID = @ClientId
     AND (d.EffectiveDate >= @FromDate and d.EffectiveDate <= @ToDate)
     AND STATUS = 22          
     AND DOCUMENTCODEID = 1611          
     ORDER BY DocumentID DESC   
     
   	  ;with CategoryResults 
	  as 
	  (   
		 SELECT DISTINCT c.ClientId    
		 ,'http://hl7.org/fhir/condition-category' as [System] --Identity of the terminology system    
		 ,'3.0.1' as [Version]  --Version of the system - if relevant    
		 ,'Encounter-diagnosis' AS Code   --Symbol in syntax defined by the system    
		 ,'Encounter Diagnosis' AS Display --Representation defined by the system           
		 ,'false' as userSelected  --If this coding was chosen directly by the user    
		 FROM Clients c            
		 JOIN dbo.DocumentDiagnosisCodes DC ON DC.DocumentVersionId = @DocumentVersionId            
		 LEFT JOIN dbo.SNOMEDCTCodes  s ON s.SNOMEDCTCode = DC.SNOMEDCODE             
		 WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)           
		 AND c.Active = 'Y'             
		 AND ISNULL(c.RecordDeleted,'N')='N'
		 
		 UNION
		 
		 SELECT DISTINCT c.ClientId    
		 ,'http://hl7.org/fhir/condition-category' as [System] --Identity of the terminology system    
		 ,'3.0.1' as [Version]  --Version of the system - if relevant    
		 ,'problem-list-item' AS Code   --Symbol in syntax defined by the system    
		 ,'Problem List Item' AS Display --Representation defined by the system           
		 ,'false' as userSelected  --If this coding was chosen directly by the user    
		 FROM Clients c            
		  JOIN  ClientProblems cpb ON cpb.ClientId = c.ClientId AND C.PrimaryClinicianId=cpb.StaffId            
		  LEFT JOIN dbo.SNOMEDCTCodes  s ON s.SNOMEDCTCode = cpb.SNOMEDCODE AND (cpb.StartDate >= @fromDate and cpb.EndDate <= @toDate)            
		  WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)             
		  AND c.Active = 'Y' AND cpb.StartDate between @fromDate and @toDate          
		  AND ISNULL(c.RecordDeleted,'N')='N' 
		 )
      select @JsonResult = ISNULL(dbo.smsf_FlattenedJSON((select * from CategoryResults    
      FOR XML path            
     ,ROOT            
     )) ,'')
    
  END    
  ELSE IF(@Text = 'ActiveProblemsSeverity')    
   BEGIN    
   SELECT @JsonResult = dbo.smsf_FlattenedJSON((    
    SELECT DISTINCT c.ClientId    
     ,'http://snomed.info/sct' as [System] --Identity of the terminology system    
     ,'' as [Version]  --Version of the system - if relevant    
     ,GC.GlobalCodeId AS Code   --Symbol in syntax defined by the system    
     ,GC.CodeName AS Display --Representation defined by the system           
     ,'false' as userSelected  --If this coding was chosen directly by the user    
   FROM Clients c  
	 LEFT JOIN  ClientProblems cpb ON cpb.ClientId = c.ClientId   
     LEFT JOIN GlobalCodes GC ON GC.GlobalCodeId= cpb.ProblemType
          AND (cpb.StartDate >= @fromDate and cpb.EndDate <= @toDate)     
     WHERE  c.ClientId = @ClientId 
     AND c.Active = 'Y'     
     AND ISNULL(c.RecordDeleted,'N')='N'      
    FOR XML path    
     ,root    
    ))    
  END    
  ELSE IF(@Text = 'ActiveProblemsCode')    
   BEGIN    
   SELECT @JsonResult = dbo.smsf_FlattenedJSON((    
    SELECT DISTINCT c.ClientId    
     ,'http://snomed.info/sct' as [System] --Identity of the terminology system    
     ,'' as [Version]  --Version of the system - if relevant    
     ,'' AS Code   --Symbol in syntax defined by the system    
     ,'' AS Display --Representation defined by the system           
     ,'false' as userSelected  --If this coding was chosen directly by the user    
    FROM Clients c        
     LEFT JOIN [Services] sr ON (sr.ClientId = c.ClientId AND (sr.DateOfService >= @fromDate and sr.EndDateOfService <= @toDate))    
     LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId    
     LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId AND (ba.StartDate >= @FromDate and ba.EndDate <= @ToDate))     
     WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)    
     AND c.Active = 'Y'     
     AND ISNULL(c.RecordDeleted,'N')='N'      
    FOR XML path    
     ,root    
    ))    
  END    
  ELSE IF(@Text = 'ActiveProblemsBodySite')    
   BEGIN    
   SELECT @JsonResult = dbo.smsf_FlattenedJSON((    
    SELECT DISTINCT c.ClientId    
     ,'http://snomed.info/sct' as [System] --Identity of the terminology system    
     ,'' as [Version]  --Version of the system - if relevant    
     ,'' AS Code   --Symbol in syntax defined by the system    
     ,'' AS Display --Representation defined by the system           
     ,'false' as userSelected  --If this coding was chosen directly by the user    
    FROM Clients c        
     LEFT JOIN [Services] sr ON (sr.ClientId = c.ClientId AND (sr.DateOfService >= @fromDate and sr.EndDateOfService <= @toDate))    
     LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId    
     LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId AND (ba.StartDate >= @FromDate and ba.EndDate <= @ToDate))     
     WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)    
     AND c.Active = 'Y'     
     AND ISNULL(c.RecordDeleted,'N')='N'      
    FOR XML path    
     ,root    
    ))    
  END    
  ELSE IF(@Text = 'ActiveProblemsStageSummary')    
   BEGIN    
   SELECT @JsonResult = dbo.smsf_FlattenedJSON((    
    SELECT DISTINCT c.ClientId    
     ,'http://snomed.info/sct' as [System] --Identity of the terminology system    
     ,'' as [Version]  --Version of the system - if relevant    
     ,'' AS Code   --Symbol in syntax defined by the system    
     ,'' AS Display --Representation defined by the system           
     ,'false' as userSelected  --If this coding was chosen directly by the user    
    FROM Clients c        
     LEFT JOIN [Services] sr ON (sr.ClientId = c.ClientId AND (sr.DateOfService >= @fromDate and sr.EndDateOfService <= @toDate))    
     LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId    
     LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId AND (ba.StartDate >= @FromDate and ba.EndDate <= @ToDate))     
     WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)    
     AND c.Active = 'Y'     
     AND ISNULL(c.RecordDeleted,'N')='N'      
    FOR XML path    
     ,root    
    ))    
  END    
  ELSE IF(@Text = 'ActiveProblemsEvidenceCode')    
   BEGIN    
   SELECT @JsonResult = dbo.smsf_FlattenedJSON((    
    SELECT DISTINCT c.ClientId    
     ,'http://snomed.info/sct' as [System] --Identity of the terminology system    
     ,'' as [Version]  --Version of the system - if relevant    
     ,'' AS Code   --Symbol in syntax defined by the system    
     ,'' AS Display --Representation defined by the system           
     ,'false' as userSelected  --If this coding was chosen directly by the user    
    FROM Clients c        
     LEFT JOIN [Services] sr ON (sr.ClientId = c.ClientId AND (sr.DateOfService >= @fromDate and sr.EndDateOfService <= @toDate))    
     LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId    
     LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId AND (ba.StartDate >= @FromDate and ba.EndDate <= @ToDate))     
     WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)    
     AND c.Active = 'Y'     
     AND ISNULL(c.RecordDeleted,'N')='N'      
    FOR XML path    
     ,root    
    ))    
  END      
--ENCOUNTERS    
  ELSE IF(@Text = 'EncountersType')    
   BEGIN    
   SELECT @JsonResult = dbo.smsf_FlattenedJSON((    
    SELECT DISTINCT c.ClientId    
     ,'' as [System] --Identity of the terminology system    
     ,'' as [Version]  --Version of the system - if relevant    
     ,'' AS Code   --Symbol in syntax defined by the system    
     ,'' AS Display --Representation defined by the system           
     ,'false' as userSelected  --If this coding was chosen directly by the user    
    FROM Clients c    
     LEFT JOIN [Services] s ON (s.ClientId = c.ClientId AND (s.DateOfService >= @fromDate and s.EndDateOfService <= @toDate))    
     LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId    
     LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId AND (ba.StartDate >= @fromDate and ba.EndDate <= @toDate))    
     WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)    
     AND c.Active = 'Y'     
     AND ISNULL(c.RecordDeleted,'N')='N'     
    FOR XML path    
     ,root    
    ))    
  END    
  ELSE IF(@Text = 'EncountersPriority')    
   BEGIN    
   SELECT @JsonResult = dbo.smsf_FlattenedJSON((    
    SELECT DISTINCT c.ClientId    
     ,'' as [System] --Identity of the terminology system    
     ,'' as [Version]  --Version of the system - if relevant    
     ,'' AS Code   --Symbol in syntax defined by the system    
     ,'' AS Display --Representation defined by the system           
     ,'false' as userSelected  --If this coding was chosen directly by the user    
    FROM Clients c    
     LEFT JOIN [Services] s ON (s.ClientId = c.ClientId AND (s.DateOfService >= @fromDate and s.EndDateOfService <= @toDate))    
     LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId    
     LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId AND (ba.StartDate >= @fromDate and ba.EndDate <= @toDate))    
     --LEFT JOIN Documents d ON d.ClientId = c.ClientId    
     WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)    
     --AND (ISNULL(@DocumentVersionId, '')='' OR d.CurrentDocumentVersionId = @DocumentVersionId)    
     AND c.Active = 'Y'     
     AND ISNULL(c.RecordDeleted,'N')='N'     
    FOR XML path    
     ,root    
    ))    
  END    
  ELSE IF(@Text = 'EncountersParticipantType')    
   BEGIN    
   SELECT @JsonResult = dbo.smsf_FlattenedJSON((    
    SELECT DISTINCT c.ClientId    
     ,'' as [System] --Identity of the terminology system    
     ,'' as [Version]  --Version of the system - if relevant    
     ,'' AS Code   --Symbol in syntax defined by the system    
     ,'' AS Display --Representation defined by the system           
     ,'false' as userSelected  --If this coding was chosen directly by the user    
    FROM Clients c    
     LEFT JOIN [Services] s ON (s.ClientId = c.ClientId AND (s.DateOfService >= @fromDate and s.EndDateOfService <= @toDate))    
     LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId    
     LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId AND (ba.StartDate >= @fromDate and ba.EndDate <= @toDate))    
     --LEFT JOIN Documents d ON d.ClientId = c.ClientId    
     WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)    
     --AND (ISNULL(@DocumentVersionId, '')='' OR d.CurrentDocumentVersionId = @DocumentVersionId)    
     AND c.Active = 'Y'     
     AND ISNULL(c.RecordDeleted,'N')='N'     
    FOR XML path    
     ,root    
    ))    
  END    
  ELSE IF(@Text = 'EncountersReason')    
   BEGIN    
   SELECT @JsonResult = dbo.smsf_FlattenedJSON((    
    SELECT DISTINCT c.ClientId    
     ,'' as [System] --Identity of the terminology system    
     ,'' as [Version]  --Version of the system - if relevant    
     ,'' AS Code   --Symbol in syntax defined by the system    
     ,'' AS Display --Representation defined by the system           
     ,'false' as userSelected  --If this coding was chosen directly by the user    
    FROM Clients c    
     LEFT JOIN [Services] s ON (s.ClientId = c.ClientId AND (s.DateOfService >= @fromDate and s.EndDateOfService <= @toDate))    
     LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId    
     LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId AND (ba.StartDate >= @fromDate and ba.EndDate <= @toDate))    
     --LEFT JOIN Documents d ON d.ClientId = c.ClientId    
     WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)    
     --AND (ISNULL(@DocumentVersionId, '')='' OR d.CurrentDocumentVersionId = @DocumentVersionId)    
     AND c.Active = 'Y'     
     AND ISNULL(c.RecordDeleted,'N')='N'     
    FOR XML path    
     ,root    
    ))    
  END    
  ELSE IF(@Text = 'EncountersDiagnosisRole')    
   BEGIN    
   SELECT @JsonResult = dbo.smsf_FlattenedJSON((    
    SELECT DISTINCT c.ClientId    
     ,'' as [System] --Identity of the terminology system    
     ,'' as [Version]  --Version of the system - if relevant    
     ,'' AS Code   --Symbol in syntax defined by the system    
     ,'' AS Display --Representation defined by the system           
     ,'false' as userSelected  --If this coding was chosen directly by the user    
    FROM Clients c    
     LEFT JOIN [Services] s ON (s.ClientId = c.ClientId AND (s.DateOfService >= @fromDate and s.EndDateOfService <= @toDate))    
     LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId    
     LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId AND (ba.StartDate >= @fromDate and ba.EndDate <= @toDate))    
     --LEFT JOIN Documents d ON d.ClientId = c.ClientId    
     WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)    
     --AND (ISNULL(@DocumentVersionId, '')='' OR d.CurrentDocumentVersionId = @DocumentVersionId)    
     AND c.Active = 'Y'     
     AND ISNULL(c.RecordDeleted,'N')='N'     
    FOR XML path    
     ,root    
    ))    
  END    
  ELSE IF(@Text = 'EncountersHospitalizationAdmitSource')    
   BEGIN    
   SELECT @JsonResult = dbo.smsf_FlattenedJSON((    
    SELECT DISTINCT c.ClientId    
     ,'' as [System] --Identity of the terminology system    
     ,'' as [Version]  --Version of the system - if relevant    
     ,'' AS Code   --Symbol in syntax defined by the system    
     ,'' AS Display --Representation defined by the system           
     ,'false' as userSelected  --If this coding was chosen directly by the user    
    FROM Clients c    
     LEFT JOIN [Services] s ON (s.ClientId = c.ClientId AND (s.DateOfService >= @fromDate and s.EndDateOfService <= @toDate))    
     LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId    
     LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId AND (ba.StartDate >= @fromDate and ba.EndDate <= @toDate))    
     --LEFT JOIN Documents d ON d.ClientId = c.ClientId    
     WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)    
     --AND (ISNULL(@DocumentVersionId, '')='' OR d.CurrentDocumentVersionId = @DocumentVersionId)    
     AND c.Active = 'Y'     
     AND ISNULL(c.RecordDeleted,'N')='N'     
    FOR XML path    
     ,root    
    ))    
  END    
  ELSE IF(@Text = 'EncountersHospitalizationReAdmission')    
   BEGIN    
   SELECT @JsonResult = dbo.smsf_FlattenedJSON((    
    SELECT DISTINCT c.ClientId    
     ,'' as [System] --Identity of the terminology system    
     ,'' as [Version]  --Version of the system - if relevant    
     ,'' AS Code   --Symbol in syntax defined by the system    
     ,'' AS Display --Representation defined by the system           
     ,'false' as userSelected  --If this coding was chosen directly by the user    
    FROM Clients c    
     LEFT JOIN [Services] s ON (s.ClientId = c.ClientId AND (s.DateOfService >= @fromDate and s.EndDateOfService <= @toDate))    
     LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId    
     LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId AND (ba.StartDate >= @fromDate and ba.EndDate <= @toDate))    
     --LEFT JOIN Documents d ON d.ClientId = c.ClientId    
     WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)    
     --AND (ISNULL(@DocumentVersionId, '')='' OR d.CurrentDocumentVersionId = @DocumentVersionId)    
     AND c.Active = 'Y'     
     AND ISNULL(c.RecordDeleted,'N')='N'     
    FOR XML path    
     ,root    
    ))    
  END    
  ELSE IF(@Text = 'EncountersHospitalizationDietPreference')    
   BEGIN    
   SELECT @JsonResult = dbo.smsf_FlattenedJSON((    
    SELECT DISTINCT c.ClientId    
     ,'' as [System] --Identity of the terminology system    
     ,'' as [Version]  --Version of the system - if relevant    
     ,'' AS Code   --Symbol in syntax defined by the system    
     ,'' AS Display --Representation defined by the system           
     ,'false' as userSelected  --If this coding was chosen directly by the user    
    FROM Clients c    
     LEFT JOIN [Services] s ON (s.ClientId = c.ClientId AND (s.DateOfService >= @fromDate and s.EndDateOfService <= @toDate))    
     LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId    
     LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId AND (ba.StartDate >= @fromDate and ba.EndDate <= @toDate))    
     --LEFT JOIN Documents d ON d.ClientId = c.ClientId    
     WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)    
     --AND (ISNULL(@DocumentVersionId, '')='' OR d.CurrentDocumentVersionId = @DocumentVersionId)    
     AND c.Active = 'Y'     
     AND ISNULL(c.RecordDeleted,'N')='N'     
    FOR XML path    
     ,root    
    ))    
  END    
  ELSE IF(@Text = 'EncountersHospitalizationSpecialCourtesy')    
   BEGIN    
   SELECT @JsonResult = dbo.smsf_FlattenedJSON((    
    SELECT DISTINCT c.ClientId    
     ,'' as [System] --Identity of the terminology system    
     ,'' as [Version]  --Version of the system - if relevant    
     ,'' AS Code   --Symbol in syntax defined by the system    
     ,'' AS Display --Representation defined by the system           
     ,'false' as userSelected  --If this coding was chosen directly by the user    
    FROM Clients c    
     LEFT JOIN [Services] s ON (s.ClientId = c.ClientId AND (s.DateOfService >= @fromDate and s.EndDateOfService <= @toDate))    
     LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId    
     LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId AND (ba.StartDate >= @fromDate and ba.EndDate <= @toDate))    
     --LEFT JOIN Documents d ON d.ClientId = c.ClientId    
     WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)    
     --AND (ISNULL(@DocumentVersionId, '')='' OR d.CurrentDocumentVersionId = @DocumentVersionId)    
     AND c.Active = 'Y'     
     AND ISNULL(c.RecordDeleted,'N')='N'     
    FOR XML path    
     ,root    
    ))    
  END    
  ELSE IF(@Text = 'EncountersHospitalizationSpecialArrangement')    
   BEGIN    
   SELECT @JsonResult = dbo.smsf_FlattenedJSON((    
    SELECT DISTINCT c.ClientId    
     ,'' as [System] --Identity of the terminology system    
     ,'' as [Version]  --Version of the system - if relevant    
     ,'' AS Code   --Symbol in syntax defined by the system    
     ,'' AS Display --Representation defined by the system           
     ,'false' as userSelected  --If this coding was chosen directly by the user    
    FROM Clients c    
     LEFT JOIN [Services] s ON (s.ClientId = c.ClientId AND (s.DateOfService >= @fromDate and s.EndDateOfService <= @toDate))    
     LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId    
     LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId AND (ba.StartDate >= @fromDate and ba.EndDate <= @toDate))    
     --LEFT JOIN Documents d ON d.ClientId = c.ClientId    
     WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)    
     --AND (ISNULL(@DocumentVersionId, '')='' OR d.CurrentDocumentVersionId = @DocumentVersionId)    
     AND c.Active = 'Y'     
     AND ISNULL(c.RecordDeleted,'N')='N'     
    FOR XML path    
     ,root    
    ))    
  END    
  ELSE IF(@Text = 'EncountersHospitalizationDischargeDisposition')    
   BEGIN    
   SELECT @JsonResult = dbo.smsf_FlattenedJSON((    
    SELECT DISTINCT c.ClientId    
     ,'' as [System] --Identity of the terminology system    
     ,'' as [Version]  --Version of the system - if relevant    
     ,'' AS Code   --Symbol in syntax defined by the system    
     ,'' AS Display --Representation defined by the system           
     ,'false' as userSelected  --If this coding was chosen directly by the user    
    FROM Clients c    
     LEFT JOIN [Services] s ON (s.ClientId = c.ClientId AND (s.DateOfService >= @fromDate and s.EndDateOfService <= @toDate))    
     LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId    
     LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId AND (ba.StartDate >= @fromDate and ba.EndDate <= @toDate))    
     --LEFT JOIN Documents d ON d.ClientId = c.ClientId    
     WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)    
     --AND (ISNULL(@DocumentVersionId, '')='' OR d.CurrentDocumentVersionId = @DocumentVersionId)    
     AND c.Active = 'Y'     
     AND ISNULL(c.RecordDeleted,'N')='N'     
    FOR XML path    
,root    
    ))    
  END    
--IMMUNIZATION      
  ELSE IF(@Text = 'ImmunizationVaccineCode')    
   BEGIN    
   SELECT @JsonResult = dbo.smsf_FlattenedJSON((    
    SELECT DISTINCT c.ClientId    
     ,'' as [System] --Identity of the terminology system    
     ,'' as [Version]  --Version of the system - if relevant    
     ,'' AS Code   --Symbol in syntax defined by the system    
     ,'' AS Display --Representation defined by the system           
     ,'false' as userSelected  --If this coding was chosen directly by the user    
    FROM Clients c    
     LEFT JOIN ClientImmunizations ci ON ci.ClientId = c.ClientId    
     LEFT JOIN ImmunizationDetails id ON id.ClientImmunizationId = ci.ClientImmunizationId    
     LEFT JOIN [Services] s ON (s.ClientId = c.ClientId AND (s.DateOfService >= @fromDate and s.EndDateOfService <= @toDate))    
     LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId    
     LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId AND (ba.StartDate >= @fromDate and ba.EndDate <= @toDate))     
     WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)     
     AND c.Active = 'Y'     
     AND ISNULL(c.RecordDeleted,'N')='N'     
    FOR XML path    
     ,root    
    ))    
  END     
  ELSE IF(@Text = 'ImmunizationReportOrigin')    
   BEGIN    
   SELECT @JsonResult = dbo.smsf_FlattenedJSON((    
    SELECT DISTINCT c.ClientId    
     ,'' as [System] --Identity of the terminology system    
     ,'' as [Version]  --Version of the system - if relevant    
     ,'' AS Code   --Symbol in syntax defined by the system    
     ,'' AS Display --Representation defined by the system           
     ,'false' as userSelected  --If this coding was chosen directly by the user    
    FROM Clients c    
     LEFT JOIN ClientImmunizations ci ON ci.ClientId = c.ClientId    
     LEFT JOIN ImmunizationDetails id ON id.ClientImmunizationId = ci.ClientImmunizationId    
     LEFT JOIN [Services] s ON (s.ClientId = c.ClientId AND (s.DateOfService >= @fromDate and s.EndDateOfService <= @toDate))    
     LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId    
     LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId AND (ba.StartDate >= @fromDate and ba.EndDate <= @toDate))     
     WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)     
     AND c.Active = 'Y'     
     AND ISNULL(c.RecordDeleted,'N')='N'     
    FOR XML path    
     ,root    
    ))    
  END      
  ELSE IF(@Text = 'ImmunizationSite')    
   BEGIN    
   SELECT @JsonResult = dbo.smsf_FlattenedJSON((    
    SELECT DISTINCT c.ClientId    
     ,'' as [System] --Identity of the terminology system    
     ,'' as [Version]  --Version of the system - if relevant    
     ,'' AS Code   --Symbol in syntax defined by the system    
     ,'' AS Display --Representation defined by the system           
     ,'false' as userSelected  --If this coding was chosen directly by the user    
    FROM Clients c    
     LEFT JOIN ClientImmunizations ci ON ci.ClientId = c.ClientId    
     LEFT JOIN ImmunizationDetails id ON id.ClientImmunizationId = ci.ClientImmunizationId    
     LEFT JOIN [Services] s ON (s.ClientId = c.ClientId AND (s.DateOfService >= @fromDate and s.EndDateOfService <= @toDate))    
     LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId    
     LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId AND (ba.StartDate >= @fromDate and ba.EndDate <= @toDate))     
     WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)     
     AND c.Active = 'Y'     
     AND ISNULL(c.RecordDeleted,'N')='N'     
    FOR XML path    
     ,root    
    ))    
  END     
  ELSE IF(@Text = 'ImmunizationRoute')    
   BEGIN    
   SELECT @JsonResult = dbo.smsf_FlattenedJSON((    
    SELECT DISTINCT c.ClientId    
     ,'' as [System] --Identity of the terminology system    
     ,'' as [Version]  --Version of the system - if relevant    
     ,'' AS Code   --Symbol in syntax defined by the system    
     ,'' AS Display --Representation defined by the system           
     ,'false' as userSelected  --If this coding was chosen directly by the user    
    FROM Clients c    
     LEFT JOIN ClientImmunizations ci ON ci.ClientId = c.ClientId    
     LEFT JOIN ImmunizationDetails id ON id.ClientImmunizationId = ci.ClientImmunizationId    
     LEFT JOIN [Services] s ON (s.ClientId = c.ClientId AND (s.DateOfService >= @fromDate and s.EndDateOfService <= @toDate))    
     LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId    
     LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId AND (ba.StartDate >= @fromDate and ba.EndDate <= @toDate))     
     WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)     
     AND c.Active = 'Y'     
     AND ISNULL(c.RecordDeleted,'N')='N'     
    FOR XML path    
     ,root    
    ))    
  END     
  ELSE IF(@Text = 'ImmunizationPractitionerRole')    
   BEGIN    
   SELECT @JsonResult = dbo.smsf_FlattenedJSON((    
    SELECT DISTINCT c.ClientId    
     ,'' as [System] --Identity of the terminology system    
     ,'' as [Version]  --Version of the system - if relevant    
     ,'' AS Code   --Symbol in syntax defined by the system    
     ,'' AS Display --Representation defined by the system           
     ,'false' as userSelected  --If this coding was chosen directly by the user    
    FROM Clients c    
     LEFT JOIN ClientImmunizations ci ON ci.ClientId = c.ClientId    
     LEFT JOIN ImmunizationDetails id ON id.ClientImmunizationId = ci.ClientImmunizationId    
     LEFT JOIN [Services] s ON (s.ClientId = c.ClientId AND (s.DateOfService >= @fromDate and s.EndDateOfService <= @toDate))    
     LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId    
     LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId AND (ba.StartDate >= @fromDate and ba.EndDate <= @toDate))     
     WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)     
     AND c.Active = 'Y'     
     AND ISNULL(c.RecordDeleted,'N')='N'     
    FOR XML path    
     ,root    
    ))    
  END     
  ELSE IF(@Text = 'ImmunizationExplanationReason')    
   BEGIN    
   SELECT @JsonResult = dbo.smsf_FlattenedJSON((    
    SELECT DISTINCT c.ClientId    
     ,'' as [System] --Identity of the terminology system    
     ,'' as [Version]  --Version of the system - if relevant    
     ,'' AS Code   --Symbol in syntax defined by the system    
     ,'' AS Display --Representation defined by the system           
     ,'false' as userSelected  --If this coding was chosen directly by the user    
    FROM Clients c    
     LEFT JOIN ClientImmunizations ci ON ci.ClientId = c.ClientId    
     LEFT JOIN ImmunizationDetails id ON id.ClientImmunizationId = ci.ClientImmunizationId    
     LEFT JOIN [Services] s ON (s.ClientId = c.ClientId AND (s.DateOfService >= @fromDate and s.EndDateOfService <= @toDate))    
     LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId    
     LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId AND (ba.StartDate >= @fromDate and ba.EndDate <= @toDate))     
     WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)     
     AND c.Active = 'Y'     
     AND ISNULL(c.RecordDeleted,'N')='N'     
    FOR XML path    
     ,root    
    ))    
  END     
  ELSE IF(@Text = 'ImmunizationExplanationReasonNotGiven')    
   BEGIN    
   SELECT @JsonResult = dbo.smsf_FlattenedJSON((    
    SELECT DISTINCT c.ClientId    
     ,'' as [System] --Identity of the terminology system    
     ,'' as [Version]  --Version of the system - if relevant    
     ,'' AS Code   --Symbol in syntax defined by the system    
     ,'' AS Display --Representation defined by the system           
     ,'false' as userSelected  --If this coding was chosen directly by the user    
    FROM Clients c    
     LEFT JOIN ClientImmunizations ci ON ci.ClientId = c.ClientId    
     LEFT JOIN ImmunizationDetails id ON id.ClientImmunizationId = ci.ClientImmunizationId    
     LEFT JOIN [Services] s ON (s.ClientId = c.ClientId AND (s.DateOfService >= @fromDate and s.EndDateOfService <= @toDate))    
     LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId    
     LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId AND (ba.StartDate >= @fromDate and ba.EndDate <= @toDate))     
     WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)     
     AND c.Active = 'Y'     
     AND ISNULL(c.RecordDeleted,'N')='N'     
    FOR XML path    
     ,root    
    ))    
  END     
  ELSE IF(@Text = 'ImmunizationVaccinationProtocolTargetDisease')    
   BEGIN    
   SELECT @JsonResult = dbo.smsf_FlattenedJSON((    
    SELECT DISTINCT c.ClientId    
     ,'' as [System] --Identity of the terminology system    
     ,'' as [Version]  --Version of the system - if relevant    
     ,'' AS Code   --Symbol in syntax defined by the system    
     ,'' AS Display --Representation defined by the system           
     ,'false' as userSelected  --If this coding was chosen directly by the user    
    FROM Clients c    
     LEFT JOIN ClientImmunizations ci ON ci.ClientId = c.ClientId    
     LEFT JOIN ImmunizationDetails id ON id.ClientImmunizationId = ci.ClientImmunizationId    
     LEFT JOIN [Services] s ON (s.ClientId = c.ClientId AND (s.DateOfService >= @fromDate and s.EndDateOfService <= @toDate))    
     LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId    
     LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId AND (ba.StartDate >= @fromDate and ba.EndDate <= @toDate))     
     WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)     
     AND c.Active = 'Y'     
     AND ISNULL(c.RecordDeleted,'N')='N'     
    FOR XML path    
     ,root    
    ))    
  END     
  ELSE IF(@Text = 'ImmunizationVaccinationProtocolDoseStatus')    
   BEGIN    
   SELECT @JsonResult = dbo.smsf_FlattenedJSON((    
    SELECT DISTINCT c.ClientId    
     ,'' as [System] --Identity of the terminology system    
     ,'' as [Version]  --Version of the system - if relevant    
     ,'' AS Code   --Symbol in syntax defined by the system    
     ,'' AS Display --Representation defined by the system           
     ,'false' as userSelected  --If this coding was chosen directly by the user    
    FROM Clients c    
     LEFT JOIN ClientImmunizations ci ON ci.ClientId = c.ClientId    
     LEFT JOIN ImmunizationDetails id ON id.ClientImmunizationId = ci.ClientImmunizationId    
     LEFT JOIN [Services] s ON (s.ClientId = c.ClientId AND (s.DateOfService >= @fromDate and s.EndDateOfService <= @toDate))    
     LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId    
     LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId AND (ba.StartDate >= @fromDate and ba.EndDate <= @toDate))     
     WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)     
     AND c.Active = 'Y'     
     AND ISNULL(c.RecordDeleted,'N')='N'     
    FOR XML path    
     ,root    
    ))    
  END    
  ELSE IF(@Text = 'ImmunizationVaccinationProtocolDoseStatusReason')    
   BEGIN    
   SELECT @JsonResult = dbo.smsf_FlattenedJSON((    
    SELECT DISTINCT c.ClientId    
     ,'' as [System] --Identity of the terminology system    
     ,'' as [Version]  --Version of the system - if relevant    
     ,'' AS Code   --Symbol in syntax defined by the system    
     ,'' AS Display --Representation defined by the system           
     ,'false' as userSelected  --If this coding was chosen directly by the user    
    FROM Clients c    
     LEFT JOIN ClientImmunizations ci ON ci.ClientId = c.ClientId    
     LEFT JOIN ImmunizationDetails id ON id.ClientImmunizationId = ci.ClientImmunizationId    
     LEFT JOIN [Services] s ON (s.ClientId = c.ClientId AND (s.DateOfService >= @fromDate and s.EndDateOfService <= @toDate))    
     LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId    
     LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId AND (ba.StartDate >= @fromDate and ba.EndDate <= @toDate))     
     WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)     
     AND c.Active = 'Y'     
     AND ISNULL(c.RecordDeleted,'N')='N'     
    FOR XML path    
     ,root    
    ))    
  END      
--SOCIALHISTORY    
  ELSE IF(@Text = 'SocialHistoryNotDoneReason')    
   BEGIN    
   SELECT @JsonResult = dbo.smsf_FlattenedJSON((    
    SELECT DISTINCT c.ClientId    
     ,'' as [System] --Identity of the terminology system    
     ,'' as [Version]  --Version of the system - if relevant    
     ,'' AS Code   --Symbol in syntax defined by the system    
     ,'' AS Display --Representation defined by the system           
     ,'false' as userSelected  --If this coding was chosen directly by the user    
    FROM Clients c    
     LEFT JOIN [Services] s ON (s.ClientId = c.ClientId AND (s.DateOfService >= @fromDate and s.EndDateOfService <= @toDate))    
     LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId    
     LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId AND (ba.StartDate >= @fromDate and ba.EndDate <= @toDate))     
     WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)    
     AND c.Active = 'Y'     
     AND ISNULL(c.RecordDeleted,'N')='N'      
    FOR XML path    
     ,root    
    ))    
  END    
  ELSE IF(@Text = 'SocialHistoryRelationship')    
   BEGIN    
   SELECT @JsonResult = dbo.smsf_FlattenedJSON((    
    SELECT DISTINCT c.ClientId    
     ,'' as [System] --Identity of the terminology system    
     ,'' as [Version]  --Version of the system - if relevant    
     ,'' AS Code   --Symbol in syntax defined by the system    
     ,'' AS Display --Representation defined by the system           
     ,'false' as userSelected  --If this coding was chosen directly by the user    
    FROM Clients c    
     LEFT JOIN [Services] s ON (s.ClientId = c.ClientId AND (s.DateOfService >= @fromDate and s.EndDateOfService <= @toDate))    
     LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId    
     LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId AND (ba.StartDate >= @fromDate and ba.EndDate <= @toDate))     
     WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)    
     AND c.Active = 'Y'     
     AND ISNULL(c.RecordDeleted,'N')='N'     
    FOR XML path    
     ,root    
    ))    
  END     
  ELSE IF(@Text = 'SocialHistoryReasonCode')    
   BEGIN    
   SELECT @JsonResult = dbo.smsf_FlattenedJSON((    
    SELECT DISTINCT c.ClientId    
     ,'' as [System] --Identity of the terminology system    
     ,'' as [Version]  --Version of the system - if relevant    
     ,'' AS Code   --Symbol in syntax defined by the system    
     ,'' AS Display --Representation defined by the system           
     ,'false' as userSelected  --If this coding was chosen directly by the user    
    FROM Clients c    
     LEFT JOIN [Services] s ON (s.ClientId = c.ClientId AND (s.DateOfService >= @fromDate and s.EndDateOfService <= @toDate))    
     LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId    
     LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId AND (ba.StartDate >= @fromDate and ba.EndDate <= @toDate))     
     WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)    
     AND c.Active = 'Y'     
     AND ISNULL(c.RecordDeleted,'N')='N'     
    FOR XML path    
     ,root    
    ))    
  END    
  ELSE IF(@Text = 'SocialHistoryConditionCode')    
   BEGIN    
   SELECT @JsonResult = dbo.smsf_FlattenedJSON((    
    SELECT DISTINCT c.ClientId    
     ,'' as [System] --Identity of the terminology system    
     ,'' as [Version]  --Version of the system - if relevant    
     ,'' AS Code   --Symbol in syntax defined by the system    
     ,'' AS Display --Representation defined by the system           
     ,'false' as userSelected  --If this coding was chosen directly by the user    
    FROM Clients c    
     LEFT JOIN [Services] s ON (s.ClientId = c.ClientId AND (s.DateOfService >= @fromDate and s.EndDateOfService <= @toDate))    
     LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId    
     LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId AND (ba.StartDate >= @fromDate and ba.EndDate <= @toDate))     
     WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)    
     AND c.Active = 'Y'     
     AND ISNULL(c.RecordDeleted,'N')='N'     
    FOR XML path    
     ,root    
    ))    
  END    
  ELSE IF(@Text = 'SocialHistoryConditionOutcome')    
   BEGIN    
   SELECT @JsonResult = dbo.smsf_FlattenedJSON((    
    SELECT DISTINCT c.ClientId    
     ,'' as [System] --Identity of the terminology system    
     ,'' as [Version]  --Version of the system - if relevant    
     ,'' AS Code   --Symbol in syntax defined by the system    
     ,'' AS Display --Representation defined by the system           
     ,'false' as userSelected  --If this coding was chosen directly by the user    
    FROM Clients c    
     LEFT JOIN [Services] s ON (s.ClientId = c.ClientId AND (s.DateOfService >= @fromDate and s.EndDateOfService <= @toDate))    
     LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId    
     LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId AND (ba.StartDate >= @fromDate and ba.EndDate <= @toDate))     
     WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)    
     AND c.Active = 'Y'     
     AND ISNULL(c.RecordDeleted,'N')='N'     
    FOR XML path    
     ,root    
    ))    
  END      
--VITALSIGNS    
  ELSE IF(@Text = 'VitalSignsCategory')    
   BEGIN    
   SELECT @JsonResult = dbo.smsf_FlattenedJSON((    
    SELECT DISTINCT c.ClientId    
     ,'' as [System] --Identity of the terminology system    
     ,'' as [Version]  --Version of the system - if relevant    
     ,'' AS Code   --Symbol in syntax defined by the system    
     ,'' AS Display --Representation defined by the system           
     ,'false' as userSelected  --If this coding was chosen directly by the user    
    FROM Clients c    
     LEFT JOIN ClientHealthDataAttributes ca ON ca.ClientId = c.ClientId    
     LEFT JOIN GlobalCodes gc ON gc.GlobalCodeId = c.PrimaryLanguage    
     LEFT JOIN [Services] s ON (s.ClientId = c.ClientId AND (s.DateOfService >= @FromDate and s.EndDateOfService <= @ToDate))    
     LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId    
     LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId AND (ba.StartDate >= @FromDate and ba.EndDate <= @ToDate))    
     WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)    
     AND c.Active = 'Y'     
     AND ISNULL(c.RecordDeleted,'N')='N'     
    FOR XML path    
     ,root    
    ))    
  END     
  ELSE IF(@Text = 'VitalSignsCode')    
   BEGIN    
   SELECT @JsonResult = dbo.smsf_FlattenedJSON((    
    SELECT DISTINCT c.ClientId    
     ,'' as [System] --Identity of the terminology system    
     ,'' as [Version]  --Version of the system - if relevant    
     ,'' AS Code   --Symbol in syntax defined by the system    
     ,'' AS Display --Representation defined by the system           
     ,'false' as userSelected  --If this coding was chosen directly by the user    
    FROM Clients c    
     LEFT JOIN ClientHealthDataAttributes ca ON ca.ClientId = c.ClientId    
     LEFT JOIN GlobalCodes gc ON gc.GlobalCodeId = c.PrimaryLanguage    
     LEFT JOIN [Services] s ON (s.ClientId = c.ClientId AND (s.DateOfService >= @FromDate and s.EndDateOfService <= @ToDate))    
     LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId    
     LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId AND (ba.StartDate >= @FromDate and ba.EndDate <= @ToDate))    
     WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)    
     AND c.Active = 'Y'     
  AND ISNULL(c.RecordDeleted,'N')='N'     
    FOR XML path    
     ,root    
    ))    
  END    
  ELSE IF(@Text = 'VitalSignsPerformerType')    
   BEGIN    
   SELECT @JsonResult = dbo.smsf_FlattenedJSON((    
    SELECT DISTINCT c.ClientId    
     ,'' as [System] --Identity of the terminology system    
     ,'' as [Version]  --Version of the system - if relevant    
     ,'' AS Code   --Symbol in syntax defined by the system    
     ,'' AS Display --Representation defined by the system           
     ,'false' as userSelected  --If this coding was chosen directly by the user    
    FROM Clients c    
     LEFT JOIN ClientHealthDataAttributes ca ON ca.ClientId = c.ClientId    
     LEFT JOIN GlobalCodes gc ON gc.GlobalCodeId = c.PrimaryLanguage    
     LEFT JOIN [Services] s ON (s.ClientId = c.ClientId AND (s.DateOfService >= @FromDate and s.EndDateOfService <= @ToDate))    
     LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId    
     LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId AND (ba.StartDate >= @FromDate and ba.EndDate <= @ToDate))    
     WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)    
     AND c.Active = 'Y'     
     AND ISNULL(c.RecordDeleted,'N')='N'     
    FOR XML path    
     ,root    
    ))    
  END    
  ELSE IF(@Text = 'VitalSignsReasonCode')    
   BEGIN    
   SELECT @JsonResult = dbo.smsf_FlattenedJSON((    
    SELECT DISTINCT c.ClientId    
     ,'' as [System] --Identity of the terminology system    
     ,'' as [Version]  --Version of the system - if relevant    
     ,'' AS Code   --Symbol in syntax defined by the system    
     ,'' AS Display --Representation defined by the system           
     ,'false' as userSelected  --If this coding was chosen directly by the user    
    FROM Clients c    
     LEFT JOIN ClientHealthDataAttributes ca ON ca.ClientId = c.ClientId    
     LEFT JOIN GlobalCodes gc ON gc.GlobalCodeId = c.PrimaryLanguage    
     LEFT JOIN [Services] s ON (s.ClientId = c.ClientId AND (s.DateOfService >= @FromDate and s.EndDateOfService <= @ToDate))    
     LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId    
     LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId AND (ba.StartDate >= @FromDate and ba.EndDate <= @ToDate))    
     WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)    
     AND c.Active = 'Y'     
     AND ISNULL(c.RecordDeleted,'N')='N'     
    FOR XML path    
     ,root    
    ))    
  END    
  ELSE IF(@Text = 'VitalSignsBodySite')    
   BEGIN    
   SELECT @JsonResult = dbo.smsf_FlattenedJSON((    
    SELECT DISTINCT c.ClientId    
     ,'' as [System] --Identity of the terminology system    
     ,'' as [Version]  --Version of the system - if relevant    
     ,'' AS Code   --Symbol in syntax defined by the system    
     ,'' AS Display --Representation defined by the system           
     ,'false' as userSelected  --If this coding was chosen directly by the user    
    FROM Clients c    
     LEFT JOIN ClientHealthDataAttributes ca ON ca.ClientId = c.ClientId    
     LEFT JOIN GlobalCodes gc ON gc.GlobalCodeId = c.PrimaryLanguage    
     LEFT JOIN [Services] s ON (s.ClientId = c.ClientId AND (s.DateOfService >= @FromDate and s.EndDateOfService <= @ToDate))    
     LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId    
     LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId AND (ba.StartDate >= @FromDate and ba.EndDate <= @ToDate))    
     WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)    
     AND c.Active = 'Y'     
     AND ISNULL(c.RecordDeleted,'N')='N'     
    FOR XML path    
     ,root    
    ))    
  END    
--PLANOFTREATMENT    
  ELSE IF(@Text = 'PlanOfTreatmentCategory')    
   BEGIN    
   SELECT @JsonResult = dbo.smsf_FlattenedJSON((    
    SELECT DISTINCT c.ClientId    
     ,'' as [System] --Identity of the terminology system    
     ,'' as [Version]  --Version of the system - if relevant    
     ,'' AS Code   --Symbol in syntax defined by the system    
     ,'' AS Display --Representation defined by the system           
     ,'false' as userSelected  --If this coding was chosen directly by the user    
    FROM Clients c    
      LEFT JOIN [Services] s ON (s.ClientId = c.ClientId AND (s.DateOfService >= @fromDate and s.EndDateOfService <= @toDate))    
      LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId    
      LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId AND (ba.StartDate >= @fromDate and ba.EndDate <= @toDate))    
      WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)    
      AND c.Active = 'Y'     
      AND ISNULL(c.RecordDeleted,'N')='N'     
    FOR XML path    
     ,root    
    ))    
  END    
  ELSE IF(@Text = 'PlanOfTreatmentActivityOutcomeCodeableConcept')    
   BEGIN    
   SELECT @JsonResult = dbo.smsf_FlattenedJSON((    
    SELECT DISTINCT c.ClientId    
     ,'' as [System] --Identity of the terminology system    
     ,'' as [Version]  --Version of the system - if relevant    
     ,'' AS Code   --Symbol in syntax defined by the system    
     ,'' AS Display --Representation defined by the system           
     ,'false' as userSelected  --If this coding was chosen directly by the user    
    FROM Clients c    
      LEFT JOIN [Services] s ON (s.ClientId = c.ClientId AND (s.DateOfService >= @fromDate and s.EndDateOfService <= @toDate))    
      LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId    
      LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId AND (ba.StartDate >= @fromDate and ba.EndDate <= @toDate))    
      WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)    
      AND c.Active = 'Y'     
      AND ISNULL(c.RecordDeleted,'N')='N'      
    FOR XML path    
     ,root    
    ))    
  END    
  ELSE IF(@Text = 'PlanOfTreatmentActivityDetailCategory')    
   BEGIN    
   SELECT @JsonResult = dbo.smsf_FlattenedJSON((    
    SELECT DISTINCT c.ClientId    
     ,'' as [System] --Identity of the terminology system    
     ,'' as [Version]  --Version of the system - if relevant    
     ,'' AS Code   --Symbol in syntax defined by the system    
     ,'' AS Display --Representation defined by the system           
     ,'false' as userSelected  --If this coding was chosen directly by the user    
    FROM Clients c    
      LEFT JOIN [Services] s ON (s.ClientId = c.ClientId AND (s.DateOfService >= @fromDate and s.EndDateOfService <= @toDate))    
      LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId    
      LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId AND (ba.StartDate >= @fromDate and ba.EndDate <= @toDate))    
      WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)    
      AND c.Active = 'Y'     
      AND ISNULL(c.RecordDeleted,'N')='N'     
    FOR XML path    
     ,root    
    ))    
  END    
  ELSE IF(@Text = 'PlanOfTreatmentActivityDetailCode')    
   BEGIN    
   SELECT @JsonResult = dbo.smsf_FlattenedJSON((    
    SELECT DISTINCT c.ClientId    
     ,'' as [System] --Identity of the terminology system    
     ,'' as [Version]  --Version of the system - if relevant    
     ,'' AS Code   --Symbol in syntax defined by the system    
     ,'' AS Display --Representation defined by the system           
     ,'false' as userSelected  --If this coding was chosen directly by the user    
    FROM Clients c    
      LEFT JOIN [Services] s ON (s.ClientId = c.ClientId AND (s.DateOfService >= @fromDate and s.EndDateOfService <= @toDate))    
      LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId    
      LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId AND (ba.StartDate >= @fromDate and ba.EndDate <= @toDate))    
      WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)    
      AND c.Active = 'Y'     
      AND ISNULL(c.RecordDeleted,'N')='N'     
    FOR XML path    
     ,root    
    ))    
  END    
  ELSE IF(@Text = 'PlanOfTreatmentActivityDetailReasonCode')    
   BEGIN    
   SELECT @JsonResult = dbo.smsf_FlattenedJSON((    
    SELECT DISTINCT c.ClientId    
     ,'' as [System] --Identity of the terminology system    
     ,'' as [Version]  --Version of the system - if relevant    
     ,'' AS Code   --Symbol in syntax defined by the system    
     ,'' AS Display --Representation defined by the system           
     ,'false' as userSelected  --If this coding was chosen directly by the user    
    FROM Clients c    
      LEFT JOIN [Services] s ON (s.ClientId = c.ClientId AND (s.DateOfService >= @fromDate and s.EndDateOfService <= @toDate))    
      LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId    
      LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId AND (ba.StartDate >= @fromDate and ba.EndDate <= @toDate))    
      WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)    
      AND c.Active = 'Y'     
      AND ISNULL(c.RecordDeleted,'N')='N'     
    FOR XML path    
     ,root    
    ))    
  END    
  ELSE IF(@Text = 'PlanOfTreatmentActivityDetailProductCodeableConcept')    
   BEGIN    
   SELECT @JsonResult = dbo.smsf_FlattenedJSON((    
    SELECT DISTINCT c.ClientId    
     ,'' as [System] --Identity of the terminology system    
     ,'' as [Version]  --Version of the system - if relevant    
     ,'' AS Code   --Symbol in syntax defined by the system    
     ,'' AS Display --Representation defined by the system           
     ,'false' as userSelected  --If this coding was chosen directly by the user    
    FROM Clients c    
      LEFT JOIN [Services] s ON (s.ClientId = c.ClientId AND (s.DateOfService >= @fromDate and s.EndDateOfService <= @toDate))    
      LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId    
      LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId AND (ba.StartDate >= @fromDate and ba.EndDate <= @toDate))    
      WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)    
      AND c.Active = 'Y'     
      AND ISNULL(c.RecordDeleted,'N')='N'     
    FOR XML path    
     ,root    
    ))    
  END    
--GOALS      
  ELSE IF(@Text = 'GoalsCategory')    
   BEGIN    
   SELECT @JsonResult = dbo.smsf_FlattenedJSON((    
    SELECT DISTINCT c.ClientId    
     ,'' as [System] --Identity of the terminology system    
     ,'' as [Version]  --Version of the system - if relevant    
     ,'' AS Code   --Symbol in syntax defined by the system    
     ,'' AS Display --Representation defined by the system           
     ,'false' as userSelected  --If this coding was chosen directly by the user    
    FROM Clients c    
     LEFT JOIN [Services] s ON (s.ClientId = c.ClientId AND (s.DateOfService >= @fromDate and s.EndDateOfService <= @toDate))    
     LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId    
     LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId AND (ba.StartDate >= @fromDate and ba.EndDate <= @toDate))    
     WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)     
     AND c.Active = 'Y'     
     AND ISNULL(c.RecordDeleted,'N')='N'    
    FOR XML path    
     ,root    
    ))    
  END    
  ELSE IF(@Text = 'GoalsPriority')    
   BEGIN    
   SELECT @JsonResult = dbo.smsf_FlattenedJSON((    
    SELECT DISTINCT c.ClientId    
     ,'' as [System] --Identity of the terminology system    
     ,'' as [Version]  --Version of the system - if relevant    
     ,'' AS Code   --Symbol in syntax defined by the system    
     ,'' AS Display --Representation defined by the system           
     ,'false' as userSelected  --If this coding was chosen directly by the user    
    FROM Clients c    
     LEFT JOIN [Services] s ON (s.ClientId = c.ClientId AND (s.DateOfService >= @fromDate and s.EndDateOfService <= @toDate))    
     LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId    
     LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId AND (ba.StartDate >= @fromDate and ba.EndDate <= @toDate))    
     WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)     
     AND c.Active = 'Y'     
     AND ISNULL(c.RecordDeleted,'N')='N'    
    FOR XML path    
     ,root    
    ))    
  END    
  ELSE IF(@Text = 'GoalsDescription')    
   BEGIN    
   SELECT @JsonResult = dbo.smsf_FlattenedJSON((    
    SELECT DISTINCT c.ClientId    
     ,'' as [System] --Identity of the terminology system    
     ,'' as [Version]  --Version of the system - if relevant    
     ,'' AS Code   --Symbol in syntax defined by the system    
     ,'' AS Display --Representation defined by the system           
     ,'false' as userSelected  --If this coding was chosen directly by the user    
    FROM Clients c    
     LEFT JOIN [Services] s ON (s.ClientId = c.ClientId AND (s.DateOfService >= @fromDate and s.EndDateOfService <= @toDate))    
     LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId    
     LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId AND (ba.StartDate >= @fromDate and ba.EndDate <= @toDate))    
     WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)     
     AND c.Active = 'Y'     
     AND ISNULL(c.RecordDeleted,'N')='N'    
    FOR XML path    
     ,root    
    ))    
  END    
  ELSE IF(@Text = 'GoalsTargetMeasure')    
   BEGIN    
   SELECT @JsonResult = dbo.smsf_FlattenedJSON((    
    SELECT DISTINCT c.ClientId    
     ,'' as [System] --Identity of the terminology system    
     ,'' as [Version]  --Version of the system - if relevant    
     ,'' AS Code   --Symbol in syntax defined by the system    
     ,'' AS Display --Representation defined by the system           
     ,'false' as userSelected  --If this coding was chosen directly by the user    
    FROM Clients c    
     LEFT JOIN [Services] s ON (s.ClientId = c.ClientId AND (s.DateOfService >= @fromDate and s.EndDateOfService <= @toDate))    
     LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId    
     LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId AND (ba.StartDate >= @fromDate and ba.EndDate <= @toDate))    
     WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)     
     AND c.Active = 'Y'     
     AND ISNULL(c.RecordDeleted,'N')='N'    
    FOR XML path    
     ,root    
    ))    
  END    
  ELSE IF(@Text = 'GoalsTargetMeasure')    
   BEGIN    
   SELECT @JsonResult = dbo.smsf_FlattenedJSON((    
    SELECT DISTINCT c.ClientId    
     ,'' as [System] --Identity of the terminology system    
     ,'' as [Version]  --Version of the system - if relevant    
     ,'' AS Code   --Symbol in syntax defined by the system    
     ,'' AS Display --Representation defined by the system           
     ,'false' as userSelected  --If this coding was chosen directly by the user    
    FROM Clients c    
     LEFT JOIN [Services] s ON (s.ClientId = c.ClientId AND (s.DateOfService >= @fromDate and s.EndDateOfService <= @toDate))    
     LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId    
     LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId AND (ba.StartDate >= @fromDate and ba.EndDate <= @toDate))    
     WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)     
     AND c.Active = 'Y'     
     AND ISNULL(c.RecordDeleted,'N')='N'    
    FOR XML path    
     ,root    
    ))    
  END    
  ELSE IF(@Text = 'GoalsOutcomeCode')    
   BEGIN    
   SELECT @JsonResult = dbo.smsf_FlattenedJSON((    
    SELECT DISTINCT c.ClientId    
     ,'' as [System] --Identity of the terminology system    
     ,'' as [Version]  --Version of the system - if relevant    
     ,'' AS Code   --Symbol in syntax defined by the system    
     ,'' AS Display --Representation defined by the system           
     ,'false' as userSelected  --If this coding was chosen directly by the user    
    FROM Clients c    
     LEFT JOIN [Services] s ON (s.ClientId = c.ClientId AND (s.DateOfService >= @fromDate and s.EndDateOfService <= @toDate))    
     LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId    
     LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId AND (ba.StartDate >= @fromDate and ba.EndDate <= @toDate))    
     WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)     
     AND c.Active = 'Y'     
     AND ISNULL(c.RecordDeleted,'N')='N'    
    FOR XML path    
     ,root    
    ))    
  END    
--HISTORYOFPROCEDURES    
  ELSE IF(@Text = 'HistoryOfProceduresNotDoneReason')     
   BEGIN    
   SELECT @JsonResult = dbo.smsf_FlattenedJSON((    
    SELECT DISTINCT c.ClientId    
     ,'' as [System] --Identity of the terminology system    
     ,'' as [Version]  --Version of the system - if relevant    
     ,'' AS Code   --Symbol in syntax defined by the system    
     ,'' AS Display --Representation defined by the system           
     ,'false' as userSelected  --If this coding was chosen directly by the user    
    FROM Clients c    
      LEFT JOIN [Services] s ON (s.ClientId = c.ClientId) --AND (s.DateOfService >= @fromDate and s.EndDateOfService <= @toDate))    
      LEFT JOIN ProcedureCodes pc ON pc.ProcedureCodeId = s.ProcedureCodeId    
      LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId    
      LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId) --AND (ba.StartDate >= @fromDate and ba.EndDate <= @toDate))     
      WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)    
      AND c.Active = 'Y'     
      AND ISNULL(c.RecordDeleted,'N')='N'    
    FOR XML path    
     ,root    
    ))    
  END    
  ELSE IF(@Text = 'HistoryOfProceduresCategory')     
   BEGIN    
   SELECT @JsonResult = dbo.smsf_FlattenedJSON((    
    SELECT DISTINCT c.ClientId    
     ,'' as [System] --Identity of the terminology system    
     ,'' as [Version]  --Version of the system - if relevant    
     ,'' AS Code   --Symbol in syntax defined by the system    
     ,'' AS Display --Representation defined by the system           
     ,'false' as userSelected  --If this coding was chosen directly by the user    
    FROM Clients c    
      LEFT JOIN [Services] s ON (s.ClientId = c.ClientId) --AND (s.DateOfService >= @fromDate and s.EndDateOfService <= @toDate))    
      LEFT JOIN ProcedureCodes pc ON pc.ProcedureCodeId = s.ProcedureCodeId    
      LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId    
      LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId) --AND (ba.StartDate >= @fromDate and ba.EndDate <= @toDate))     
      WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)    
      AND c.Active = 'Y'     
      AND ISNULL(c.RecordDeleted,'N')='N'    
    FOR XML path    
     ,root    
    ))    
  END    
  ELSE IF(@Text = 'HistoryOfProceduresCode')     
   BEGIN    
   SELECT @JsonResult = dbo.smsf_FlattenedJSON((    
    SELECT DISTINCT c.ClientId    
     ,'' as [System] --Identity of the terminology system    
     ,'' as [Version]  --Version of the system - if relevant    
     ,'' AS Code   --Symbol in syntax defined by the system    
     ,'' AS Display --Representation defined by the system           
     ,'false' as userSelected  --If this coding was chosen directly by the user    
    FROM Clients c    
      LEFT JOIN [Services] s ON (s.ClientId = c.ClientId) --AND (s.DateOfService >= @fromDate and s.EndDateOfService <= @toDate))    
      LEFT JOIN ProcedureCodes pc ON pc.ProcedureCodeId = s.ProcedureCodeId    
      LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId    
      LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId) --AND (ba.StartDate >= @fromDate and ba.EndDate <= @toDate))     
      WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)    
      AND c.Active = 'Y'     
      AND ISNULL(c.RecordDeleted,'N')='N'    
    FOR XML path    
     ,root    
    ))    
  END    
  ELSE IF(@Text = 'HistoryOfProceduresPerformerRole')     
   BEGIN    
   SELECT @JsonResult = dbo.smsf_FlattenedJSON((    
    SELECT DISTINCT c.ClientId    
     ,'' as [System] --Identity of the terminology system    
     ,'' as [Version]  --Version of the system - if relevant    
     ,'' AS Code   --Symbol in syntax defined by the system    
     ,'' AS Display --Representation defined by the system           
     ,'false' as userSelected  --If this coding was chosen directly by the user    
    FROM Clients c    
      LEFT JOIN [Services] s ON (s.ClientId = c.ClientId) --AND (s.DateOfService >= @fromDate and s.EndDateOfService <= @toDate))    
      LEFT JOIN ProcedureCodes pc ON pc.ProcedureCodeId = s.ProcedureCodeId    
      LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId    
      LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId) --AND (ba.StartDate >= @fromDate and ba.EndDate <= @toDate))     
      WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)    
      AND c.Active = 'Y'     
      AND ISNULL(c.RecordDeleted,'N')='N'    
    FOR XML path    
     ,root    
    ))    
  END    
  ELSE IF(@Text = 'HistoryOfProceduresReasonCode')     
   BEGIN    
   SELECT @JsonResult = dbo.smsf_FlattenedJSON((    
    SELECT DISTINCT c.ClientId    
     ,'' as [System] --Identity of the terminology system    
     ,'' as [Version]  --Version of the system - if relevant    
     ,'' AS Code   --Symbol in syntax defined by the system    
     ,'' AS Display --Representation defined by the system           
     ,'false' as userSelected  --If this coding was chosen directly by the user    
    FROM Clients c    
      LEFT JOIN [Services] s ON (s.ClientId = c.ClientId) --AND (s.DateOfService >= @fromDate and s.EndDateOfService <= @toDate))    
      LEFT JOIN ProcedureCodes pc ON pc.ProcedureCodeId = s.ProcedureCodeId    
      LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId    
      LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId) --AND (ba.StartDate >= @fromDate and ba.EndDate <= @toDate))     
      WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)    
      AND c.Active = 'Y'     
      AND ISNULL(c.RecordDeleted,'N')='N'    
    FOR XML path    
     ,root    
    ))    
  END    
  ELSE IF(@Text = 'HistoryOfProceduresBodySite')     
   BEGIN    
   SELECT @JsonResult = dbo.smsf_FlattenedJSON((    
    SELECT DISTINCT c.ClientId    
     ,'' as [System] --Identity of the terminology system    
     ,'' as [Version]  --Version of the system - if relevant    
     ,'' AS Code   --Symbol in syntax defined by the system    
     ,'' AS Display --Representation defined by the system           
     ,'false' as userSelected  --If this coding was chosen directly by the user    
    FROM Clients c    
      LEFT JOIN [Services] s ON (s.ClientId = c.ClientId) --AND (s.DateOfService >= @fromDate and s.EndDateOfService <= @toDate))    
      LEFT JOIN ProcedureCodes pc ON pc.ProcedureCodeId = s.ProcedureCodeId    
      LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId    
      LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId) --AND (ba.StartDate >= @fromDate and ba.EndDate <= @toDate))     
      WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)    
      AND c.Active = 'Y'     
      AND ISNULL(c.RecordDeleted,'N')='N'    
    FOR XML path    
     ,root    
    ))    
  END    
  ELSE IF(@Text = 'HistoryOfProceduresOutcome')     
   BEGIN    
   SELECT @JsonResult = dbo.smsf_FlattenedJSON((    
    SELECT DISTINCT c.ClientId    
     ,'' as [System] --Identity of the terminology system    
     ,'' as [Version]  --Version of the system - if relevant    
     ,'' AS Code   --Symbol in syntax defined by the system    
     ,'' AS Display --Representation defined by the system           
     ,'false' as userSelected  --If this coding was chosen directly by the user    
    FROM Clients c    
      LEFT JOIN [Services] s ON (s.ClientId = c.ClientId) --AND (s.DateOfService >= @fromDate and s.EndDateOfService <= @toDate))    
      LEFT JOIN ProcedureCodes pc ON pc.ProcedureCodeId = s.ProcedureCodeId    
      LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId    
      LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId) --AND (ba.StartDate >= @fromDate and ba.EndDate <= @toDate))     
      WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)    
      AND c.Active = 'Y'     
      AND ISNULL(c.RecordDeleted,'N')='N'    
    FOR XML path    
     ,root    
    ))    
  END    
  ELSE IF(@Text = 'HistoryOfProceduresComplication')     
   BEGIN    
   SELECT @JsonResult = dbo.smsf_FlattenedJSON((    
    SELECT DISTINCT c.ClientId    
     ,'' as [System] --Identity of the terminology system    
     ,'' as [Version]  --Version of the system - if relevant    
     ,'' AS Code   --Symbol in syntax defined by the system    
     ,'' AS Display --Representation defined by the system           
     ,'false' as userSelected  --If this coding was chosen directly by the user    
    FROM Clients c    
      LEFT JOIN [Services] s ON (s.ClientId = c.ClientId) --AND (s.DateOfService >= @fromDate and s.EndDateOfService <= @toDate))    
      LEFT JOIN ProcedureCodes pc ON pc.ProcedureCodeId = s.ProcedureCodeId    
      LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId    
      LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId) --AND (ba.StartDate >= @fromDate and ba.EndDate <= @toDate))     
      WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)    
      AND c.Active = 'Y'     
      AND ISNULL(c.RecordDeleted,'N')='N'    
    FOR XML path    
     ,root    
    ))    
  END    
  ELSE IF(@Text = 'HistoryOfProceduresFollowUp')     
   BEGIN    
   SELECT @JsonResult = dbo.smsf_FlattenedJSON((    
    SELECT DISTINCT c.ClientId    
     ,'' as [System] --Identity of the terminology system    
     ,'' as [Version]  --Version of the system - if relevant    
     ,'' AS Code   --Symbol in syntax defined by the system    
     ,'' AS Display --Representation defined by the system           
     ,'false' as userSelected  --If this coding was chosen directly by the user    
    FROM Clients c    
      LEFT JOIN [Services] s ON (s.ClientId = c.ClientId) --AND (s.DateOfService >= @fromDate and s.EndDateOfService <= @toDate))    
      LEFT JOIN ProcedureCodes pc ON pc.ProcedureCodeId = s.ProcedureCodeId    
      LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId    
      LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId) --AND (ba.StartDate >= @fromDate and ba.EndDate <= @toDate))     
      WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)    
      AND c.Active = 'Y'     
      AND ISNULL(c.RecordDeleted,'N')='N'    
    FOR XML path    
     ,root    
    ))    
  END    
  ELSE IF(@Text = 'HistoryOfProceduresFocalDeviceAction')     
   BEGIN    
   SELECT @JsonResult = dbo.smsf_FlattenedJSON((    
    SELECT DISTINCT c.ClientId    
     ,'' as [System] --Identity of the terminology system    
     ,'' as [Version]  --Version of the system - if relevant    
     ,'' AS Code   --Symbol in syntax defined by the system    
     ,'' AS Display --Representation defined by the system           
     ,'false' as userSelected  --If this coding was chosen directly by the user    
    FROM Clients c    
      LEFT JOIN [Services] s ON (s.ClientId = c.ClientId) --AND (s.DateOfService >= @fromDate and s.EndDateOfService <= @toDate))    
      LEFT JOIN ProcedureCodes pc ON pc.ProcedureCodeId = s.ProcedureCodeId    
      LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId    
      LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId) --AND (ba.StartDate >= @fromDate and ba.EndDate <= @toDate))     
      WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)    
      AND c.Active = 'Y'     
      AND ISNULL(c.RecordDeleted,'N')='N'    
    FOR XML path    
     ,root    
    ))    
  END    
  ELSE IF(@Text = 'HistoryOfProceduresUsedCode')     
   BEGIN    
   SELECT @JsonResult = dbo.smsf_FlattenedJSON((    
    SELECT DISTINCT c.ClientId    
     ,'' as [System] --Identity of the terminology system    
     ,'' as [Version]  --Version of the system - if relevant    
     ,'' AS Code   --Symbol in syntax defined by the system    
     ,'' AS Display --Representation defined by the system           
     ,'false' as userSelected  --If this coding was chosen directly by the user    
    FROM Clients c    
      LEFT JOIN [Services] s ON (s.ClientId = c.ClientId) --AND (s.DateOfService >= @fromDate and s.EndDateOfService <= @toDate))    
      LEFT JOIN ProcedureCodes pc ON pc.ProcedureCodeId = s.ProcedureCodeId    
      LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId    
      LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId) --AND (ba.StartDate >= @fromDate and ba.EndDate <= @toDate))     
      WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)    
      AND c.Active = 'Y'     
      AND ISNULL(c.RecordDeleted,'N')='N'    
    FOR XML path    
     ,root    
    ))    
  END    
--STUDIESSUMMARY    
  ELSE IF(@Text = 'StudiesSummaryCategory')     
   BEGIN    
   SELECT @JsonResult = dbo.smsf_FlattenedJSON((    
    SELECT DISTINCT c.ClientId    
     ,'' as [System] --Identity of the terminology system    
     ,'' as [Version]  --Version of the system - if relevant    
     ,'' AS Code   --Symbol in syntax defined by the system    
     ,'' AS Display --Representation defined by the system           
     ,'false' as userSelected  --If this coding was chosen directly by the user    
    FROM Clients c    
     LEFT JOIN [Services] s ON (s.ClientId = c.ClientId AND (s.DateOfService >= @fromDate and s.EndDateOfService <= @toDate))    
     LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId    
     LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId AND (ba.StartDate >= @fromDate and ba.EndDate <= @toDate))     
     WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)    
     AND c.Active = 'Y'     
     AND ISNULL(c.RecordDeleted,'N')='N'    
    FOR XML path    
     ,root    
    ))    
  END     
  ELSE IF(@Text = 'StudiesSummaryCode')     
   BEGIN    
   SELECT @JsonResult = dbo.smsf_FlattenedJSON((    
    SELECT DISTINCT c.ClientId    
     ,'' as [System] --Identity of the terminology system    
     ,'' as [Version]  --Version of the system - if relevant    
     ,'' AS Code   --Symbol in syntax defined by the system    
     ,'' AS Display --Representation defined by the system           
     ,'false' as userSelected  --If this coding was chosen directly by the user    
    FROM Clients c    
     LEFT JOIN [Services] s ON (s.ClientId = c.ClientId AND (s.DateOfService >= @fromDate and s.EndDateOfService <= @toDate))    
     LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId    
     LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId AND (ba.StartDate >= @fromDate and ba.EndDate <= @toDate))     
     WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)    
     AND c.Active = 'Y'     
     AND ISNULL(c.RecordDeleted,'N')='N'    
    FOR XML path    
     ,root    
    ))    
  END     
  ELSE IF(@Text = 'StudiesSummaryDataAbsentReason')     
   BEGIN    
   SELECT @JsonResult = dbo.smsf_FlattenedJSON((    
    SELECT DISTINCT c.ClientId    
     ,'' as [System] --Identity of the terminology system    
     ,'' as [Version]  --Version of the system - if relevant    
     ,'' AS Code   --Symbol in syntax defined by the system    
     ,'' AS Display --Representation defined by the system           
     ,'false' as userSelected  --If this coding was chosen directly by the user    
    FROM Clients c    
     LEFT JOIN [Services] s ON (s.ClientId = c.ClientId AND (s.DateOfService >= @fromDate and s.EndDateOfService <= @toDate))    
     LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId    
     LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId AND (ba.StartDate >= @fromDate and ba.EndDate <= @toDate))     
     WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)    
     AND c.Active = 'Y'     
     AND ISNULL(c.RecordDeleted,'N')='N'    
    FOR XML path    
     ,root    
    ))    
  END     
  ELSE IF(@Text = 'StudiesSummaryInterpretation')     
   BEGIN    
   SELECT @JsonResult = dbo.smsf_FlattenedJSON((    
    SELECT DISTINCT c.ClientId    
     ,'' as [System] --Identity of the terminology system    
     ,'' as [Version]  --Version of the system - if relevant    
     ,'' AS Code   --Symbol in syntax defined by the system    
     ,'' AS Display --Representation defined by the system           
     ,'false' as userSelected  --If this coding was chosen directly by the user    
    FROM Clients c    
     LEFT JOIN [Services] s ON (s.ClientId = c.ClientId AND (s.DateOfService >= @fromDate and s.EndDateOfService <= @toDate))    
     LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId    
     LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId AND (ba.StartDate >= @fromDate and ba.EndDate <= @toDate))     
     WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)    
     AND c.Active = 'Y'     
     AND ISNULL(c.RecordDeleted,'N')='N'    
    FOR XML path    
     ,root    
    ))    
  END     
  ELSE IF(@Text = 'StudiesSummaryBodySite')     
   BEGIN    
   SELECT @JsonResult = dbo.smsf_FlattenedJSON((    
    SELECT DISTINCT c.ClientId    
     ,'' as [System] --Identity of the terminology system    
     ,'' as [Version]  --Version of the system - if relevant    
     ,'' AS Code   --Symbol in syntax defined by the system    
     ,'' AS Display --Representation defined by the system           
     ,'false' as userSelected  --If this coding was chosen directly by the user    
    FROM Clients c    
     LEFT JOIN [Services] s ON (s.ClientId = c.ClientId AND (s.DateOfService >= @fromDate and s.EndDateOfService <= @toDate))    
     LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId    
     LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId AND (ba.StartDate >= @fromDate and ba.EndDate <= @toDate))     
     WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)    
     AND c.Active = 'Y'     
     AND ISNULL(c.RecordDeleted,'N')='N'    
    FOR XML path    
     ,root    
    ))    
  END     
  ELSE IF(@Text = 'StudiesSummaryMethod')     
   BEGIN    
   SELECT @JsonResult = dbo.smsf_FlattenedJSON((    
    SELECT DISTINCT c.ClientId    
     ,'' as [System] --Identity of the terminology system    
     ,'' as [Version]  --Version of the system - if relevant    
     ,'' AS Code   --Symbol in syntax defined by the system    
     ,'' AS Display --Representation defined by the system           
     ,'false' as userSelected  --If this coding was chosen directly by the user    
    FROM Clients c    
     LEFT JOIN [Services] s ON (s.ClientId = c.ClientId AND (s.DateOfService >= @fromDate and s.EndDateOfService <= @toDate))    
     LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId    
     LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId AND (ba.StartDate >= @fromDate and ba.EndDate <= @toDate))     
     WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)    
     AND c.Active = 'Y'     
     AND ISNULL(c.RecordDeleted,'N')='N'    
    FOR XML path    
     ,root    
    ))    
  END     
  ELSE IF(@Text = 'StudiesSummaryReferenceRangeType')     
   BEGIN    
   SELECT @JsonResult = dbo.smsf_FlattenedJSON((    
    SELECT DISTINCT c.ClientId    
     ,'' as [System] --Identity of the terminology system    
     ,'' as [Version]  --Version of the system - if relevant    
     ,'' AS Code   --Symbol in syntax defined by the system    
     ,'' AS Display --Representation defined by the system           
     ,'false' as userSelected  --If this coding was chosen directly by the user    
    FROM Clients c    
     LEFT JOIN [Services] s ON (s.ClientId = c.ClientId AND (s.DateOfService >= @fromDate and s.EndDateOfService <= @toDate))    
     LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId    
     LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId AND (ba.StartDate >= @fromDate and ba.EndDate <= @toDate))     
     WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)    
     AND c.Active = 'Y'     
     AND ISNULL(c.RecordDeleted,'N')='N'    
    FOR XML path    
     ,root    
    ))    
  END     
  ELSE IF(@Text = 'StudiesSummaryReferenceRangeAppliesTo')     
   BEGIN    
   SELECT @JsonResult = dbo.smsf_FlattenedJSON((    
    SELECT DISTINCT c.ClientId    
     ,'' as [System] --Identity of the terminology system    
     ,'' as [Version]  --Version of the system - if relevant    
     ,'' AS Code   --Symbol in syntax defined by the system    
     ,'' AS Display --Representation defined by the system           
     ,'false' as userSelected  --If this coding was chosen directly by the user    
    FROM Clients c    
     LEFT JOIN [Services] s ON (s.ClientId = c.ClientId AND (s.DateOfService >= @fromDate and s.EndDateOfService <= @toDate))    
     LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId    
     LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId AND (ba.StartDate >= @fromDate and ba.EndDate <= @toDate))     
     WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)    
     AND c.Active = 'Y'     
     AND ISNULL(c.RecordDeleted,'N')='N'    
    FOR XML path    
     ,root    
    ))    
  END     
  ELSE IF(@Text = 'StudiesSummaryComponentCode')     
   BEGIN    
   SELECT @JsonResult = dbo.smsf_FlattenedJSON((    
    SELECT DISTINCT c.ClientId    
     ,'' as [System] --Identity of the terminology system    
     ,'' as [Version]  --Version of the system - if relevant    
     ,'' AS Code   --Symbol in syntax defined by the system    
     ,'' AS Display --Representation defined by the system           
     ,'false' as userSelected  --If this coding was chosen directly by the user    
    FROM Clients c    
     LEFT JOIN [Services] s ON (s.ClientId = c.ClientId AND (s.DateOfService >= @fromDate and s.EndDateOfService <= @toDate))    
     LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId    
     LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId AND (ba.StartDate >= @fromDate and ba.EndDate <= @toDate))     
     WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)    
     AND c.Active = 'Y'     
     AND ISNULL(c.RecordDeleted,'N')='N'    
    FOR XML path    
     ,root    
    ))    
  END     
  ELSE IF(@Text = 'StudiesSummaryComponentDataAbsentReason')     
   BEGIN    
   SELECT @JsonResult = dbo.smsf_FlattenedJSON((    
    SELECT DISTINCT c.ClientId    
     ,'' as [System] --Identity of the terminology system    
     ,'' as [Version]  --Version of the system - if relevant    
     ,'' AS Code   --Symbol in syntax defined by the system    
     ,'' AS Display --Representation defined by the system           
     ,'false' as userSelected  --If this coding was chosen directly by the user    
    FROM Clients c    
     LEFT JOIN [Services] s ON (s.ClientId = c.ClientId AND (s.DateOfService >= @fromDate and s.EndDateOfService <= @toDate))    
     LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId    
     LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId AND (ba.StartDate >= @fromDate and ba.EndDate <= @toDate))     
     WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)    
     AND c.Active = 'Y'     
     AND ISNULL(c.RecordDeleted,'N')='N'    
    FOR XML path    
     ,root    
    ))    
  END    
  ELSE IF(@Text = 'StudiesSummaryComponentInterpretation')     
   BEGIN    
   SELECT @JsonResult = dbo.smsf_FlattenedJSON((    
    SELECT DISTINCT c.ClientId    
     ,'' as [System] --Identity of the terminology system    
     ,'' as [Version]  --Version of the system - if relevant    
     ,'' AS Code   --Symbol in syntax defined by the system    
     ,'' AS Display --Representation defined by the system           
     ,'false' as userSelected  --If this coding was chosen directly by the user    
    FROM Clients c    
     LEFT JOIN [Services] s ON (s.ClientId = c.ClientId AND (s.DateOfService >= @fromDate and s.EndDateOfService <= @toDate))    
     LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId    
     LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId AND (ba.StartDate >= @fromDate and ba.EndDate <= @toDate))     
     WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)    
     AND c.Active = 'Y'     
     AND ISNULL(c.RecordDeleted,'N')='N'    
    FOR XML path    
     ,root    
    ))    
  END    
--LABORATORYTESTS     
  ELSE IF(@Text = 'LaboratoryTestsCategory')     
   BEGIN    
   SELECT @JsonResult = dbo.smsf_FlattenedJSON((    
    SELECT DISTINCT c.ClientId    
     ,'https://www.hl7.org/' as [System] --Identity of the terminology system    
     ,'2.82' as [Version]  --Version of the system - if relevant    
     ,'LAB' AS Code   --Symbol in syntax defined by the system    
     ,'Laboratory' AS Display --Representation defined by the system           
     ,'false' as userSelected  --If this coding was chosen directly by the user    
    FROM Clients c    
      JOIN ClientOrders co ON co.ClientId = c.ClientId     
      WHERE  c.ClientId = @ClientId    
      AND c.Active = 'Y'     
      AND ISNULL(c.RecordDeleted,'N')='N'     
       AND (co.OrderType =6481 and CO.ReviewedFlag='Y' ) -- 6481 (lab) ,6482 (Radiology)      
       AND(co.OrderDateTime >= @fromDate and co.OrderDateTime <= @toDate)     
    FOR XML path    
     ,root    
    ))    
  END     
  ELSE IF(@Text = 'LaboratoryTestsCode')     
   BEGIN    
   SELECT @JsonResult = dbo.smsf_FlattenedJSON((    
    SELECT DISTINCT c.ClientId    
     ,'http://loinc.org' as [System] --Identity of the terminology system    
     ,'' as [Version]  --Version of the system - if relevant    
     ,L.LOINCCode AS Code   --Symbol in syntax defined by the system    
     ,L.LOINCCode AS Display --Representation defined by the system           
     ,'false' as userSelected  --If this coding was chosen directly by the user    
    FROM Clients c    
      JOIN ClientOrders co ON co.ClientId = c.ClientId    
      JOIN Orders O ON O.OrderId=CO.OrderId  
      JOIN LOINCCodeOrders L ON L.OrderId=O.OrderId   
      WHERE  c.ClientId = @ClientId    
      AND c.Active = 'Y'     
      AND ISNULL(c.RecordDeleted,'N')='N'    
      AND ISNULL(co.RecordDeleted,'N')='N'   
      AND ISNULL(O.RecordDeleted,'N')='N'     
      AND ISNULL(L.RecordDeleted,'N')='N'     
       AND (co.OrderType =6481 and CO.ReviewedFlag='Y' ) -- 6481 (lab) ,6482 (Radiology)      
       AND(co.OrderDateTime >= @fromDate and co.OrderDateTime <= @toDate)     
    FOR XML path    
     ,root    
    ))    
  END     
  ELSE IF(@Text = 'LaboratoryTestsPerformerRole')     
   BEGIN    
   SELECT @JsonResult = dbo.smsf_FlattenedJSON((    
    SELECT DISTINCT c.ClientId    
     ,'' as [System] --Identity of the terminology system    
     ,'' as [Version]  --Version of the system - if relevant    
     ,'' AS Code   --Symbol in syntax defined by the system    
     ,'' AS Display --Representation defined by the system           
     ,'false' as userSelected  --If this coding was chosen directly by the user    
    FROM Clients c    
      LEFT JOIN ClientOrders co ON co.ClientId = c.ClientId    
      LEFT JOIN [Services] s ON (s.ClientId = c.ClientId AND (s.DateOfService >= @fromDate and s.EndDateOfService <= @toDate))    
      LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId    
      LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId AND (ba.StartDate >= @fromDate and ba.EndDate <= @toDate))    
      WHERE  (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)    
      AND c.Active = 'Y'     
      AND ISNULL(c.RecordDeleted,'N')='N'     
      AND co.OrderType = 'Labs'     
    FOR XML path    
     ,root    
    ))    
  END     
  ELSE IF(@Text = 'LaboratoryTestsCodedDiagnosis')     
   BEGIN    
   SELECT @JsonResult = dbo.smsf_FlattenedJSON((    
    SELECT DISTINCT c.ClientId    
     ,'' as [System] --Identity of the terminology system    
     ,'' as [Version]  --Version of the system - if relevant    
     ,'' AS Code   --Symbol in syntax defined by the system    
     ,'' AS Display --Representation defined by the system           
     ,'false' as userSelected  --If this coding was chosen directly by the user    
    FROM Clients c    
      LEFT JOIN ClientOrders co ON co.ClientId = c.ClientId    
      LEFT JOIN [Services] s ON (s.ClientId = c.ClientId AND (s.DateOfService >= @fromDate and s.EndDateOfService <= @toDate))    
      LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId    
      LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId AND (ba.StartDate >= @fromDate and ba.EndDate <= @toDate))    
      WHERE  (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)    
      AND c.Active = 'Y'     
      AND ISNULL(c.RecordDeleted,'N')='N'     
      AND co.OrderType = 'Labs'     
    FOR XML path    
     ,root    
    ))    
  END     
--CARETEAMMEMBERS    
  ELSE IF(@Text = 'CareTeamMembersCategory')     
   BEGIN    
   SELECT @JsonResult = dbo.smsf_FlattenedJSON((    
    SELECT DISTINCT c.ClientId    
     ,'' as [System] --Identity of the terminology system    
     ,'' as [Version]  --Version of the system - if relevant    
     ,'' AS Code   --Symbol in syntax defined by the system    
     ,'' AS Display --Representation defined by the system           
     ,'false' as userSelected  --If this coding was chosen directly by the user    
    FROM Clients C    
       LEFT JOIN ClientContacts CC ON CC.ClientId=C.ClientId  AND (ISNULL(CC.Guardian,'')='Y' OR ISNULL(CC.EmergencyContact,'')='Y') AND ISNULL(CC.RecordDeleted,'N')='N'    
       LEFT JOIN ClientTreatmentTeamMembers CTT ON CTT.StaffId=C.PrimaryClinicianId    
       LEFT JOIN [Services] s ON (s.ClientId = c.ClientId AND (s.DateOfService >= @FromDate and s.EndDateOfService <= @ToDate))    
       LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId    
       LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId AND (ba.StartDate >= @FromDate and ba.EndDate <= @ToDate))    
       WHERE C.ClientId=@ClientId    
       AND ISNULL(C.RecordDeleted,'N')='N'    
    FOR XML path    
     ,root    
    ))    
  END     
  ELSE IF(@Text = 'CareTeamMembersParticipantRole')     
   BEGIN    
   SELECT @JsonResult = dbo.smsf_FlattenedJSON((    
    SELECT DISTINCT c.ClientId    
     ,'' as [System] --Identity of the terminology system    
     ,'' as [Version]  --Version of the system - if relevant    
     ,'' AS Code   --Symbol in syntax defined by the system    
     ,'' AS Display --Representation defined by the system           
     ,'false' as userSelected  --If this coding was chosen directly by the user    
    FROM Clients C    
       LEFT JOIN ClientContacts CC ON CC.ClientId=C.ClientId  AND (ISNULL(CC.Guardian,'')='Y' OR ISNULL(CC.EmergencyContact,'')='Y') AND ISNULL(CC.RecordDeleted,'N')='N'    
       LEFT JOIN ClientTreatmentTeamMembers CTT ON CTT.StaffId=C.PrimaryClinicianId    
       LEFT JOIN [Services] s ON (s.ClientId = c.ClientId AND (s.DateOfService >= @FromDate and s.EndDateOfService <= @ToDate))    
       LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId    
       LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId AND (ba.StartDate >= @FromDate and ba.EndDate <= @ToDate))    
       WHERE C.ClientId=@ClientId    
    FOR XML path    
     ,root    
    ))    
  END     
  ELSE IF(@Text = 'CareTeamMembersReasonCode')     
   BEGIN    
   SELECT @JsonResult = dbo.smsf_FlattenedJSON((    
    SELECT DISTINCT c.ClientId    
     ,'' as [System] --Identity of the terminology system    
     ,'' as [Version]  --Version of the system - if relevant    
     ,'' AS Code   --Symbol in syntax defined by the system    
     ,'' AS Display --Representation defined by the system           
     ,'false' as userSelected  --If this coding was chosen directly by the user    
    FROM Clients C    
       LEFT JOIN ClientContacts CC ON CC.ClientId=C.ClientId  AND (ISNULL(CC.Guardian,'')='Y' OR ISNULL(CC.EmergencyContact,'')='Y') AND ISNULL(CC.RecordDeleted,'N')='N'    
       LEFT JOIN ClientTreatmentTeamMembers CTT ON CTT.StaffId=C.PrimaryClinicianId    
       LEFT JOIN [Services] s ON (s.ClientId = c.ClientId AND (s.DateOfService >= @FromDate and s.EndDateOfService <= @ToDate))    
       LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId    
       LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId AND (ba.StartDate >= @FromDate and ba.EndDate <= @ToDate))    
       WHERE C.ClientId=@ClientId    
    FOR XML path    
     ,root    
    ))    
  END     
--UNIQUEDEVICEIDENTIFIER     
  ELSE IF(@Text = 'UniqueDeviceIdentifierType')     
   BEGIN    
   SELECT @JsonResult = dbo.smsf_FlattenedJSON((    
    SELECT DISTINCT c.ClientId    
     ,'' as [System] --Identity of the terminology system    
     ,'' as [Version]  --Version of the system - if relevant    
     ,'' AS Code   --Symbol in syntax defined by the system    
     ,'' AS Display --Representation defined by the system           
     ,'false' as userSelected  --If this coding was chosen directly by the user    
    FROM Clients c    
     JOIN ImplantableDevices ID ON ID.ClientId=C.ClientId    
     LEFT JOIN [Services] s ON (s.ClientId = c.ClientId AND (s.DateOfService >= @FromDate and s.EndDateOfService <= @ToDate))    
     LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId    
     LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId AND (ba.StartDate >= @FromDate and ba.EndDate <= @ToDate))     
     WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)    
     AND c.Active = 'Y'     
     AND ISNULL(c.RecordDeleted,'N')='N'     
    FOR XML path    
     ,root    
    ))    
  END      
  ELSE IF(@Text = 'UniqueDeviceIdentifierSafety')     
   BEGIN    
   SELECT @JsonResult = dbo.smsf_FlattenedJSON((    
    SELECT DISTINCT c.ClientId    
     ,'' as [System] --Identity of the terminology system    
     ,'' as [Version]  --Version of the system - if relevant    
     ,'' AS Code   --Symbol in syntax defined by the system    
     ,'' AS Display --Representation defined by the system           
     ,'false' as userSelected  --If this coding was chosen directly by the user    
    FROM Clients c    
     JOIN ImplantableDevices ID ON ID.ClientId=C.ClientId    
     LEFT JOIN [Services] s ON (s.ClientId = c.ClientId AND (s.DateOfService >= @FromDate and s.EndDateOfService <= @ToDate))    
     LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId    
     LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId AND (ba.StartDate >= @FromDate and ba.EndDate <= @ToDate))     
     WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)    
     AND c.Active = 'Y'     
     AND ISNULL(c.RecordDeleted,'N')='N'     
    FOR XML path    
     ,root    
    ))    
  END    
  ELSE IF(@Text = 'TimingCode')     
   BEGIN    
   SELECT @JsonResult = dbo.smsf_FlattenedJSON((    
    SELECT DISTINCT c.ClientId    
     ,'' as [System] --Identity of the terminology system    
     ,'' as [Version]  --Version of the system - if relevant    
     ,'' AS Code   --Symbol in syntax defined by the system    
     ,'' AS Display --Representation defined by the system           
     ,'false' as userSelected  --If this coding was chosen directly by the user    
    FROM Clients c    
     --JOIN ImplantableDevices ID ON ID.ClientId=C.ClientId    
     LEFT JOIN [Services] s ON (s.ClientId = c.ClientId AND (s.DateOfService >= @FromDate and s.EndDateOfService <= @ToDate))    
     LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId    
     LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId AND (ba.StartDate >= @FromDate and ba.EndDate <= @ToDate))     
     WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)    
     AND c.Active = 'Y'     
     AND ISNULL(c.RecordDeleted,'N')='N'     
    FOR XML path    
     ,root    
    ))    
  END     
  ELSE IF(@Text = 'MetaDataSecurity')     
   BEGIN    
   SELECT @JsonResult = dbo.smsf_FlattenedJSON((    
    SELECT DISTINCT c.ClientId    
     ,'' as [System] --Identity of the terminology system    
     ,'' as [Version]  --Version of the system - if relevant    
     ,'' AS Code   --Symbol in syntax defined by the system    
     ,'' AS Display --Representation defined by the system           
     ,'false' as userSelected  --If this coding was chosen directly by the user    
    FROM Clients c    
     --JOIN ImplantableDevices ID ON ID.ClientId=C.ClientId    
     LEFT JOIN [Services] s ON (s.ClientId = c.ClientId AND (s.DateOfService >= @FromDate and s.EndDateOfService <= @ToDate))    
     LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId    
     LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId AND (ba.StartDate >= @FromDate and ba.EndDate <= @ToDate))     
     WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)    
     AND c.Active = 'Y'     
     AND ISNULL(c.RecordDeleted,'N')='N'     
    FOR XML path    
     ,root    
    ))    
  END     
  ELSE IF(@Text = 'MetaDataTag')     
   BEGIN    
   SELECT @JsonResult = dbo.smsf_FlattenedJSON((    
    SELECT DISTINCT c.ClientId    
     ,'' as [System] --Identity of the terminology system    
     ,'' as [Version]  --Version of the system - if relevant    
     ,'' AS Code   --Symbol in syntax defined by the system    
     ,'' AS Display --Representation defined by the system           
     ,'false' as userSelected  --If this coding was chosen directly by the user    
    FROM Clients c    
     --JOIN ImplantableDevices ID ON ID.ClientId=C.ClientId    
     LEFT JOIN [Services] s ON (s.ClientId = c.ClientId AND (s.DateOfService >= @FromDate and s.EndDateOfService <= @ToDate))    
     LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId    
     LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId AND (ba.StartDate >= @FromDate and ba.EndDate <= @ToDate))     
     WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)    
     AND c.Active = 'Y'     
     AND ISNULL(c.RecordDeleted,'N')='N'     
    FOR XML path    
     ,root    
    ))    
  END     
      
      
    
 END TRY    
    
 BEGIN CATCH    
  DECLARE @Error VARCHAR(8000)    
    
  SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'smsp_GetCodeableConcept') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR,
  
 ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())    
    
  RAISERROR (    
    @Error    
    ,-- Message text.                                                                         
    16    
    ,-- Severity.                                                                
    1 -- State.                                                             
    );    
 END CATCH    
END    
GO


