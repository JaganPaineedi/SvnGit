/****** Object:  StoredProcedure [dbo].[ssp_GetAllergies]     ******/
IF EXISTS (
		SELECT 1
		FROM INFORMATION_SCHEMA.ROUTINES
		WHERE SPECIFIC_SCHEMA = 'dbo'
			AND SPECIFIC_NAME = 'ssp_GetAllergies'
		)
	DROP PROCEDURE [dbo].[ssp_GetAllergies]
GO

/****** Object:  StoredProcedure [dbo].[ssp_GetAllergies] 2    ******/
SET ANSI_NULLS ON
GO
	
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_GetAllergies] @ClientId INT = NULL  
 ,@Type VARCHAR(10) = NULL  
 ,@DocumentVersionId INT = NULL  
 ,@FromDate DATETIME = NULL  
 ,@ToDate DATETIME = NULL  
 ,@JsonResult VARCHAR(MAX) = NULL OUTPUT  
AS  
-- =============================================                    
-- Author:  Vijay                    
-- Create date: July 24, 2017                    
-- Description: Retrieves Allergy details        
-- Task:   MUS3 - Task#25.4, 30, 31 and 32                   
/*                    
 Author   Modified Date   Reason                   
*/ 
/*                    
 Modified Date	Author      Reason  
 12/12/2017		Ravichandra	changes done for new requirement 
							Meaningful Use Stage 3 task 68 - Summary of Care                  
*/ 
/* 23/07/2018  Ravichandra	What: comment the code Allergies created between the FromDate and ToDate. all Allergies reported included in the report regardless on when they were entered into the system.
							Why : KCMHSAS - Support  #1099 Summary of Care - issues (summary for all bugs)  
*/
-- =============================================                    
BEGIN  
 BEGIN TRY  
  IF @ClientId IS NOT NULL  
  BEGIN  
   SELECT @JsonResult = dbo.smsf_FlattenedJSON((  
      SELECT DISTINCT c.ClientId  
       ,CASE ca.Active  
        WHEN 'Y'  
         THEN 'Active'  
        WHEN 'N'  
         THEN 'Inactive'  
        END AS ClinicalStatus -- RDL+FHIR active | inactive | resolved        
       ,'' AS VerificationStatus -- unconfirmed | confirmed | refuted | entered-in-error        
       ,CASE ca.AllergyType  
        WHEN 'A'  
         THEN 'Allergy'  
        WHEN 'I'  
         THEN 'Intolerance'  
        WHEN 'F'  
         THEN 'Failed Trial'  
        END AS [Type] -- RDL+FHIR - allergy | intolerance - Underlying mechanism (if known)        
       ,'food' AS Category --food | medication | environment | biologic        
       ,'high' AS Criticality --low | high | unable-to-assess        
       --,'' AS Code  --102002  Hemoglobin Okaloosa              
       ,CASE   
        WHEN ISNULL(C.ClientType, 'I') = 'I'  
         THEN ISNULL(C.LastName, '') + ' ' + ISNULL(C.MiddleName, '') + ' ' + ISNULL(C.FirstName, '')  
        ELSE ISNULL(C.OrganizationName, '')  
        END AS Patient --Reference        
       ,ca.CreatedDate AS OnsetDateTime  
       --,0 AS OnsetAge        
       --,'' AS Start --OnsetPeriod        
       --,'' AS [End] --OnsetPeriod        
       --,'' AS OnsetRange        
       --,'' AS OnsetString           
       ,(  
        SELECT CONVERT(VARCHAR(10), min(AllergiesLastReviewedDate), 101)  
        FROM ClientAllergyReviews CR  
        WHERE Ca.ClientId = CR.ClientId  
        ) AS AssertedDate  
       ,Ca.CreatedBy AS Recorder --Reference        
       ,st.DisplayAs AS Asserter --Reference        
       ,(  
        SELECT CONVERT(VARCHAR(10), max(AllergiesLastReviewedDate), 101)  
        FROM ClientAllergyReviews CR  
        WHERE Ca.ClientId = CR.ClientId  
        ) AS LastOccurrence  
       --,'' AS Note --ca.Comment AS Note        
       --,'' AS Substance --102002  Hemoglobin Okaloosa        
       --,'' AS Manifestation --122003  Choroidal hemorrhage        
       ,g.CodeName AS ReactionDescription  
       ,Ca.CreatedDate AS ReactionOnset  
       ,dbo.ssf_GetGlobalCodeNameById(ca.AllergySeverity) AS ReactionSeverity  
       --,'' AS ExposureRoute        
       --,CI.ReactionNoted AS ReactionNote        
       ,ca.Comment AS [Text]  
      FROM Clients c  
      INNER JOIN ClientAllergies ca ON ca.ClientId = c.ClientId  
      LEFT JOIN Staff st ON st.StaffId = Ca.LastReviewedBy  
      LEFT JOIN GlobalCodes g ON g.GlobalCodeId = ca.AllergyReaction  
      LEFT JOIN [Services] s ON (  
        s.ClientId = c.ClientId  
        AND (  
         s.DateOfService >= @FromDate  
         AND s.EndDateOfService <= @ToDate  
         )  
        )  
      WHERE (  
        ISNULL(@ClientId, '') = ''  
        OR c.ClientId = @ClientId  
        )  
       AND c.Active = 'Y'  
       AND ISNULL(c.RecordDeleted, 'N') = 'N'  
      --AND ISNULL(ca.RecordDeleted,'N')='N'        
      --AND (ca.CreatedDate <= @ToDate or @ToDate is null)             
      FOR XML path  
       ,ROOT  
      ))  
  END  
  ELSE IF @DocumentVersionId IS NOT NULL  
  BEGIN  
   DECLARE @RDLFromDate DATE  
   DECLARE @RDLToDate DATE  
   DECLARE @RDLClientId INT  
  
   SELECT TOP 1 @RDLFromDate = cast(T.FromDate AS DATE)  
    ,@RDLToDate = cast(T.ToDate AS DATE)  
    ,@Type = T.TransitionType  
    ,@RDLClientId = D.ClientId  
   FROM TransitionOfCareDocuments T  
   JOIN Documents D ON D.InProgressDocumentVersionId = T.DocumentVersionId  
   WHERE ISNULL(T.RecordDeleted, 'N') = 'N'  
    AND T.DocumentVersionId = @DocumentVersionId  
    AND ISNULL(D.RecordDeleted, 'N') = 'N'  
  
   SELECT DISTINCT c.ClientId  
    ,CONVERT(VARCHAR, ca.CreatedDate, 107) AS [Date] --RDL            
    ,md.ConceptDescription AS [Description] --RDL              
    ,dbo.ssf_GetGlobalCodeNameById(ca.AllergyReaction) AS Reaction --RDL              
    ,dbo.ssf_GetGlobalCodeNameById(ca.AllergySeverity) AS Severity --RDL                  
    ,ca.Comment AS Comments --RDL              
    ,dbo.ssf_GetRxNormCodeByAllergenConceptId(ca.AllergenConceptId) AS RxNormCode --RDL                  
    ,CASE ca.Active  
     WHEN 'Y'  
      THEN 'Active'  
     WHEN 'N'  
      THEN 'Inactive'  
     END AS ClinicalStatus -- RDL+FHIR active | inactive | resolved              
    ,CASE ca.AllergyType  
     WHEN 'A'  
      THEN 'Allergy'  
     WHEN 'I'  
      THEN 'Intolerance'  
     WHEN 'F'  
      THEN 'Failed Trial'  
     END AS [Type] -- RDL+FHIR - allergy | intolerance - Underlying mechanism (if known)              
    ,g.ExternalCode1 AS ReactionSnomedCode  
    ,g1.ExternalCode1 AS SeveritySnomedCode  
   FROM Clients c  
   INNER JOIN ClientAllergies ca ON ca.ClientId = c.ClientId  
   INNER JOIN MDAllergenConcepts md ON md.AllergenConceptId = ca.AllergenConceptId  
   --LEFT JOIN ClientImmunizations CI ON CI.ClientId=C.ClientId  AND ISNULL(CI.RecordDeleted,'N')='N'              
   INNER JOIN Documents d ON d.ClientId = c.ClientId  
   
   --23/07/2018  Ravichandra
    --AND cast(D.EffectiveDate AS DATE) >= @RDLFromDate  
    --AND cast(D.EffectiveDate AS DATE) <= @RDLToDate  
    
   LEFT JOIN GlobalCodes g ON ca.AllergyReaction = g.GlobalCodeId  
   LEFT JOIN GlobalCodes g1 ON ca.AllergySeverity = g1.GlobalCodeId  
   WHERE C.ClientId = @RDLClientId  
    AND c.Active = 'Y'         
    AND ISNULL(ca.RecordDeleted, 'N') = 'N'   
    AND ISNULL(md.RecordDeleted, 'N') = 'N'  
    AND ISNULL(d.RecordDeleted, 'N') = 'N'  
    
--23/07/2018  Ravichandra
    --AND cast(ca.CreatedDate AS DATE) BETWEEN cast(@RDLFromDate as Date)  
    -- AND cast(@RDLToDate as Date)     
    
  END  
 END TRY  
  
 BEGIN CATCH  
  DECLARE @Error VARCHAR(8000)  
  
  SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_GetAllergies') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' +   
   CONVERT(VARCHAR, ERROR_STATE())  
  
  RAISERROR (  
    @Error  
    ,-- Message text.                                                                                   
    16  
    ,-- Severity.                                                                          
    1 -- State.                                                                       
    );  
 END CATCH  
END  