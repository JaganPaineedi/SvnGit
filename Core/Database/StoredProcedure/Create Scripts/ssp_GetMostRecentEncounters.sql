/****** Object:  StoredProcedure [dbo].[ssp_GetMostRecentEncounters]    Script Date: 09/25/2017 15:48:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetMostRecentEncounters]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetMostRecentEncounters]
GO


/****** Object:  StoredProcedure [dbo].[ssp_GetMostRecentEncounters]    Script Date: 09/25/2017 15:48:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

  
CREATE PROCEDURE [dbo].[ssp_GetMostRecentEncounters]  @ClientId INT = null  
, @Type VARCHAR(10)  =null  
, @DocumentVersionId INT =null  
, @FromDate DATETIME =null  
, @ToDate DATETIME =null  
, @JsonResult VARCHAR(MAX)=null OUTPUT  
AS  
-- =============================================        
-- Author:  Vijay        
-- Create date: July 24, 2017        
-- Description: Retrieves Most Recent Encounters details
-- Task:   MUS3 - Task#25.4 Transition of Care - CCDA Generation        
/*        
 Author   Modified Date   Reason       
*/  
-- =============================================        
BEGIN  
 BEGIN TRY  
  IF @ClientId IS NOT NULL  
  BEGIN  
   IF @Type = 'Inpatient'  
    BEGIN  
     --InPatient  
     SELECT @JsonResult = dbo.smsf_FlattenedJSON((  
      SELECT DISTINCT c.ClientId  
      --,'Encounter' AS ResourceType  
      --,c.SSN AS Identifier  
      ,'' AS [Status]     --planned | arrived | triaged | in-progress | onleave | finished | cancelled +  
      ,'' AS StatusHistoryStatus --planned | arrived | triaged | in-progress | onleave | finished | cancelled +  
      ,'' AS StatusHistoryPeriodStart     --The time that the episode was in the specified status  
      ,'' AS StatusHistoryPeriodEnd  
      ,'' AS Class      -- inpatient | outpatient | ambulatory | emergency +  
      ,'' AS ClassHistoryClass  -- inpatient | outpatient | ambulatory | emergency +  
      ,'' AS ClassHistoryPeriodStart   
      ,'' AS ClassHistoryPeriodEnd   
      --,'' AS [Type]  --ADMS Annual diabetes mellitus screening     
      --,'' AS Priority  --A ASAP As soon as possible, next highest priority after stat.     
      ,'' AS [Subject]  --The patient ro group present at the encounter     
      ,'' AS EpisodeOfCare --Episode(s) of care that this encounter should be recorded against     
      ,'' AS IncomingReferral  
      ,'' AS Participant  --The list of people responsible for providing the service.  
      --,'' AS ParticipantType  
      ,'' AS ParticipantPeriodStart  
      ,'' AS ParticipantPeriodEnd  
      ,'' AS ParticipantIndividual     
      ,'' AS Appointment     
      ,'' AS Start  
      ,'' AS [End]  
      ,'' AS [Length]     
      --,'' AS Reason  
      ,'' AS Diagnosis  
      ,'' AS DiagnosisCondition  
      --,'' AS DiagnosisRole  
      ,'' AS DiagnosisRank     
      ,'' AS Account  
      ,'' AS HospitalizationPreAdmissionIdentifier --Details about the admission to a healthcare service  
      ,'' AS HospitalizationOrigin  
      --,'' AS HospitalizationAdmitSource --hosp-trans Transferred from other hospital  
      --,'' AS HospitalizationReAdmission   --R Re-admission  
      --,'' AS HospitalizationDietPreference --vegetarian Vegetarian  
      --,'' AS HospitalizationSpecialCourtesy    --EXT extended courtesy  
      --,'' AS HospitalizationSpecialArrangement  --wheel Wheelchair  
      ,'' AS HospitalizationDestination  
      --,'' AS HospitalizationDischargeDisposition --home Home     
      ,'' AS Location --Location the encounter takes place  
      ,'' AS LocationStatus -- planned | active | reserved | completed  
      ,'' AS LocationPeriodStart  
      ,'' AS LocationPeriodEnd  
      ,'' AS ServiceProvider  
      ,'' AS PartOf  
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
     ,ROOT  
     ))   
    END  
   ELSE  
    BEGIN  
     --OutPatient  
     SELECT @JsonResult = dbo.smsf_FlattenedJSON((  
      SELECT DISTINCT c.ClientId  
      --,'Encounter' AS ResourceType  
      --,c.SSN AS Identifier  
      ,'' AS [Status]     --planned | arrived | triaged | in-progress | onleave | finished | cancelled +  
      ,'' AS StatusHistoryStatus --planned | arrived | triaged | in-progress | onleave | finished | cancelled +  
      ,'' AS StatusHistoryPeriodStart     --The time that the episode was in the specified status  
      ,'' AS StatusHistoryPeriodEnd  
      ,'' AS Class      -- inpatient | outpatient | ambulatory | emergency +  
      ,'' AS ClassHistoryClass  -- inpatient | outpatient | ambulatory | emergency +  
      ,'' AS ClassHistoryPeriodStart   
      ,'' AS ClassHistoryPeriodEnd   
      --,'' AS [Type]  --ADMS Annual diabetes mellitus screening     
      --,'' AS Priority  --A ASAP As soon as possible, next highest priority after stat.     
      ,'' AS [Subject]  --The patient ro group present at the encounter     
      ,'' AS EpisodeOfCare --Episode(s) of care that this encounter should be recorded against     
      ,'' AS IncomingReferral  
      ,'' AS Participant  --The list of people responsible for providing the service.  
      --,'' AS ParticipantType  
      ,'' AS ParticipantPeriodStart  
      ,'' AS ParticipantPeriodEnd  
      ,'' AS ParticipantIndividual     
      ,'' AS Appointment     
      ,'' AS Start  
      ,'' AS [End]  
      ,'' AS [Length]     
      --,'' AS Reason  
      ,'' AS Diagnosis  
      ,'' AS DiagnosisCondition  
      --,'' AS DiagnosisRole  
      ,'' AS DiagnosisRank     
      ,'' AS Account  
      ,'' AS HospitalizationPreAdmissionIdentifier --Details about the admission to a healthcare service  
      ,'' AS HospitalizationOrigin  
      --,'' AS HospitalizationAdmitSource --hosp-trans Transferred from other hospital  
      --,'' AS HospitalizationReAdmission   --R Re-admission  
      --,'' AS HospitalizationDietPreference --vegetarian Vegetarian  
      --,'' AS HospitalizationSpecialCourtesy    --EXT extended courtesy  
      --,'' AS HospitalizationSpecialArrangement  --wheel Wheelchair  
      ,'' AS HospitalizationDestination  
      --,'' AS HospitalizationDischargeDisposition --home Home     
      ,'' AS Location --Location the encounter takes place  
      ,'' AS LocationStatus -- planned | active | reserved | completed  
      ,'' AS LocationPeriodStart  
      ,'' AS LocationPeriodEnd  
      ,'' AS ServiceProvider  
      ,'' AS PartOf  
     FROM Clients c  
     LEFT JOIN [Services] s ON (s.ClientId = c.ClientId AND (s.DateOfService >= @fromDate and s.EndDateOfService <= @toDate))  
     --LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId  
     --LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId AND (ba.StartDate >= @fromDate and ba.EndDate <= @toDate))  
     --LEFT JOIN Documents d ON d.ClientId = c.ClientId  
     WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)  
     --AND (ISNULL(@DocumentVersionId, '')='' OR d.CurrentDocumentVersionId = @DocumentVersionId)  
     AND c.Active = 'Y'   
     AND ISNULL(c.RecordDeleted,'N')='N'   
      FOR XML path  
     ,ROOT  
     ))   
    END               
    END          
   ELSE          
   IF @DocumentVersionId IS NOT NULL      --For CCDS    
    BEGIN   
          
     DECLARE @RDLFromDate Date                
     DECLARE @RDLToDate Date                 
     DECLARE @RDLClientId int                 
     Select top 1 @RDLFromDate  =cast(T.FromDate as date), @RDLToDate= cast(T.ToDate as date),@Type=TransitionType,@RDLClientId=D.ClientId                
     From TransitionOfCareDocuments T                
     JOIN Documents D ON D.InProgressDocumentVersionId=T.DocumentVersionId                
     Where ISNULL(T.RecordDeleted,'N')='N'  and DocumentVersionId=@DocumentVersionId                
     AND ISNULL(D.RecordDeleted,'N')='N'        
       
    DECLARE @LatestICD10DocumentVersionID INT    
    SET @LatestICD10DocumentVersionID = (    
    SELECT TOP 1 CurrentDocumentVersionId    
    FROM Documents a    
    INNER JOIN DocumentCodes Dc ON Dc.DocumentCodeid = a.DocumentCodeid    
    WHERE a.ClientId = @RDLClientId    
   AND a.EffectiveDate <= convert(DATETIME, convert(VARCHAR, getDate(), 101))    
   AND a.STATUS = 22    
   AND Dc.DiagnosisDocument = 'Y'    
   AND a.DocumentCodeId = 1601    
   AND isNull(a.RecordDeleted, 'N') <> 'Y'    
   AND isNull(Dc.RecordDeleted, 'N') <> 'Y'    
     ORDER BY a.EffectiveDate DESC    
   ,a.ModifiedDate DESC    
     )  
      
      SELECT DISTINCT c.ClientId  
        ,DC.CreatedDate AS [Date]  
        ,S.SNOMEDCTCode  
      ,S.SNOMEDCTDescription  
      ,sf.FirstName      
         ,sf.LastName     
         ,A.AgencyName      
         ,A.Address      
         ,A.City      
         ,A.State     
         ,A.ZipCode  
         ,L.LocationCode       
         ,L.LocationName  
         --,GC.ExternalCode1 AS LOINCCode  
         --,GC.CodeName  
     FROM Clients c  
      LEFT JOIN dbo.DocumentDiagnosisCodes DC ON DC.DocumentVersionId = @LatestICD10DocumentVersionID --For CCDS  
      LEFT JOIN ICD10SNOMEDCTMapping ICDMapping ON DC.ICD10Code=ICDMapping.ICD10CodeId --For CCDS  
      LEFT JOIN dbo.SNOMEDCTCodes S ON S.SNOMEDCTCodeId = ICDMapping.SNOMEDCTCodeId --For CCDS   
      LEFT JOIN GlobalCodes GC ON GC.GlobalCodeId = DC.DiagnosisType  
      LEFT JOIN Staff sf ON sf.StaffId = c.PrimaryClinicianId AND  sf.Prescriber = 'Y'   --For CCDS  
      LEFT JOIN Locations L ON L.LocationId = sf.DefaultPrescribingLocation  
         CROSS JOIN  Agency A               
     WHERE (ISNULL(@RDLClientId, '')='' OR c.ClientId = @RDLClientId)  
     AND c.Active = 'Y'   
     AND ISNULL(c.RecordDeleted,'N')='N'    
    END  
 END TRY  
  
 BEGIN CATCH  
  DECLARE @Error VARCHAR(8000)  
  
  SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_GetMostRecentEncounters') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())  
  
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


