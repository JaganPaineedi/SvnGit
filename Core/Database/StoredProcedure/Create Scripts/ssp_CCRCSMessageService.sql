
/****** Object:  StoredProcedure [dbo].[ssp_CCRCSMessageService]    Script Date: 06/11/2015 18:11:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_CCRCSMessageService]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_CCRCSMessageService]
GO


/****** Object:  StoredProcedure [dbo].[ssp_CCRCSMessageService]    Script Date: 06/11/2015 18:11:48 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


    
-- =============================================                  
-- Author:  Pradeep                  
-- Create date: Sept 19, 2014                  
-- Description: Retrieves CCR Message                  
/*                  
 Author   Modified Date   Reason                  
 Veena          09/10/2014              Added insert logic to ClinicalSummaryDocuments.            
                  
*/    
-- =============================================                  
CREATE  PROCEDURE [dbo].[ssp_CCRCSMessageService] @ServiceId BIGINT = NULL    
 ,@StaffId BIGINT    
 ,@DocumentVersionId INT = NULL    
 ,@DocumentType VARCHAR(50) = NULL    
AS    
BEGIN    
 DECLARE @ClientId BIGINT    
    
 SELECT @ClientId = ClientId    
 FROM services    
 WHERE ServiceId = @ServiceId    
    
 IF @DocumentType = 'SC'    
 BEGIN    
  SELECT @DocumentVersionId = InProgressDocumentVersionId    
  FROM Documents d    
  WHERE ServiceId = @ServiceId    
 END    
 ELSE IF @DocumentType = 'SOC'    
 BEGIN    
  SELECT @ServiceId = ServiceId    
   ,@ClientId = ClientId    
  FROM Documents d    
  WHERE InProgressDocumentVersionId = @DocumentVersionId    
 END    
 ELSE IF @DocumentType = 'Client'    
 BEGIN    
  SELECT TOP 1 @DocumentVersionId = InProgressDocumentVersionId    
   ,@ClientId = ClientId    
  FROM Documents d    
  WHERE ClientID = @DocumentVersionId    
   AND STATUS = 22    
   AND DOCUMENTCODEID = 1611    
  ORDER BY DocumentID DESC    
    
  SET @DocumentType = 'SOC'    
 END    
    
 SET NOCOUNT ON;    


 --Main            
 SELECT CAST(NEWID() AS VARCHAR(50)) AS CCRDocumentObjectID    
  ,'English' AS LANGUAGE    
  ,'V1.0' AS Version    
  ,'CCR Creation DateTime' AS [DateTime_Type]    
  ,replace(replace(replace(convert(VARCHAR(19), getdate(), 126), '-', ''), 'T', ''), ':', '') AS DateTime_ApproximateDateTime    
  ,'Patient.' + CAST(@ClientId AS VARCHAR(100)) AS ActorID    
  ,'Patient' AS ActorRole    
  ,'For the patient' AS Purpose_Description;    
    
 --FromStaff            
 SELECT 'Staff.' + CAST(@StaffId AS VARCHAR(100)) AS ActorID    
  ,CAST(@StaffId AS VARCHAR(100)) AS ID1_ActorID    
  ,'Provider' AS ActorRole    
  ,ISNULL(S.LastName, '') AS Current_Family    
  ,ISNULL(S.FirstName, '') AS Current_Given    
  ,ISNULL(S.MiddleName, '') AS Current_Middle    
  ,CASE     
   WHEN S.lastname IS NULL    
    THEN ''    
   ELSE ISNULL(S.FirstName, '') + ' ' + ISNULL(S.LastName, '')    
   END AS Current_DisplayName    
  ,'' AS From_Actor_Title    
  ,ISNULL(CONVERT(VARCHAR(10), S.DOB, 21), '') AS DOB_ApproximateDateTime    
  ,CASE S.sex    
   WHEN 'F'    
    THEN 'Female'    
   WHEN 'M'    
    THEN 'Male'    
   ELSE 'Unknown'    
   END AS Gender    
  ,ISNULL(S.Email, '') AS CT1_Email_Value    
  ,'' AS ActorSpecialty    
  ,'Staff ID' AS ID1_IDType    
  ,'SmartCareEHR4.0' AS ID1_Source_ActorID    
  ,'SmartCareEHR4.0' AS SLRCGroup_Source_ActorID    
  ,'EHR' AS ID1_Source_ActorRole    
  --      
  ,ISNULL(S1.FirstName, '') AS Staff1_Given    
  ,ISNULL(S1.LastName, '') AS Staff1_Family    
  ,ISNULL(S1.AddressDisplay, '') AS STAFF1ADDRESS    
  ,ISNULL(S1.City, '') AS STAFF1CITY    
  ,ISNULL(S1.STATE, '') AS STAFF1STATE    
  ,ISNULL(S1.Zip, '') AS Staff1ZIP    
  ,ISNULL(S1.PhoneNumber, '') AS Staff1Phone    
  --      
  ,ISNULL(S2.FirstName, '') AS Staff2_Given    
  ,ISNULL(S2.LastName, '') AS Staff2_Family    
  ,ISNULL(S2.AddressDisplay, '') AS STAFF2ADDRESS    
  ,ISNULL(S2.City, '') AS STAFF2CITY    
  ,ISNULL(S2.STATE, '') AS STAFF2STATE    
  ,ISNULL(S2.Zip, '') AS Staff2ZIP    
  ,ISNULL(S2.PhoneNumber, '') AS Staff2Phone    
      
  --Include/Exclude Flag    
  --Include/Exclude Flag    
  ,CASE ISNULL(CSF.FilterString,'')    
  
   WHEN '' THEN 'Y'    
   ELSE 'N'    
          
  END  AS IncludeExclude  
  , isnull(G.ExternalCode1, 'ENG') AS PrimaryLanguageCode
  , isnull(G.CodeName, 'ENGLISH') AS PrimaryLanguage
 FROM Clients c    
 INNER JOIN STAFFCLIENTS SS ON SS.clientId = C.ClientiD    
 LEFT JOIN STAFF S ON S.STAFFID = SS.STAFFID --AND SS.STAFFID = 1      
 LEFT JOIN staff s1 ON C.PrimaryClinicianId = S1.StaffId    
 LEFT JOIN STAFF s2 ON C.PrimaryPhysicianId = S2.StaffId    
 LEFT JOIN CSFilterData CSF ON CSF.clientId = C.ClientiD AND CSF.FilterString LIKE '%Participants=N%'    
 LEFT JOIN GlobalCodes G ON G.GlobalCodeId = C.PrimaryLanguage 
 WHERE C.ClientId = @ClientId    
  AND SS.staffId = 1;    
    
 --FromOrganization            
 SELECT TOP (1) REPLACE(A.AgencyName, ' ', '_') AS ActorID    ,A.AgencyName AS DisplayName    
  ,'Organization' AS ActorRole    
  ,'SmartCareEHR4.0' AS SLRCGroup_Source_ActorID    
  ,A.Address AS SLRCGroup_Source_ActorAddress    
  ,A.City AS SLRCGroup_Source_ActorCity    
  ,A.STATE AS SLRCGroup_Source_ActorState    
  ,A.ZipCode AS SLRCGroup_Source_PostalCode    
  ,'US' AS SLRCGroup_Source_CountryCode    
  ,A.BillingPhone AS SLRCGroup_Source_Telephone_Value    
 FROM dbo.Agency A;    
    
 --FromInfoSystem            
 SELECT 'SmartCareEHR4.0' AS ActorID    
  ,'Client Medical Record' AS DisplayName    
  ,'InformationSystem' AS ActorRole    
  ,'SmartCareEHR4.0' AS SLRCGroup_Source_ActorID    
    
 --To            
 SELECT TOP (0) '' AS ActorID    
  ,'' AS ActorRole;    
 
    
 --PatientInfo            
 EXEC ssp_CCRCSGetClientInfo @ClientId --(PatientInfo)            
    
 --Allergies            
 EXEC ssp_CCRCSGetMedicationAlertServiceSummary @ClientId --(Allergies)            
  ,@ServiceId    
    
 --Medications            
 EXEC ssp_CCRCSGetMedicationListServiceSummary @ClientId -- (Medications)            
  ,@ServiceId    
    
 --Problems            
 EXEC ssp_CCRCSGetProblemListSummary @ClientId -- (Problems)            
  ,@ServiceId    
    
 --Procedures            
 EXEC ssp_CCRCSGetProcedureListServiceSummary @ClientId -- (Procedures)            
  ,@ServiceId    
  ,NULL    
    
 --Results            
 EXEC ssp_CCRCSGetResultReviewdVisit @ClientId -- (Results)            
  ,@ServiceId    
  ,NULL    
    
 --Encounters             
 EXEC ssp_CCRCSEncounters @ClientId -- (Encounters)            
  ,@ServiceID    
  ,NULL    
    
 --EXEC ssp_CCRCSGetLabResultsVitalsSmokeSummary @ClientId -- (ResultVitalsSmoke)            
 -- ,@ServiceId            
 --Immunizations            
 EXEC ssp_CCRCSGetImmunizations @ClientId -- (Immunizations)            
  ,@ServiceId    
  ,NULL    
    
 --VitalSigns            
 EXEC ssp_CCRCSGetLabResultsServiceSummary @ClientId -- (ResultVitals)            
  ,@ServiceId    
    
 --ReasonforVisit            
 EXEC ssp_CCRCSReasonforVisit @ClientId -- (ReasonforVisit)            
  ,@ServiceId    
  ,NULL    
    
 --ResonforReferral             
 EXEC ssp_CCRSCReasonforReferral @ClientId -- (ReasonforReferral)            
  ,NULL    
  ,NULL    
    
 --EXEC ssp_CCRSCPlanofCare @ClientId -- (PlanofCare)            
 -- ,NULL            
 -- ,@DocumentVersionId            
 EXEC ssp_CCRCSMedicationAdministrated @ClientId -- (MedicationAdministrated)            
  ,NULL    
  ,NULL    
    
 --EXEC ssp_CCRCSInstructions @ClientId -- (Instructions)            
 -- ,NULL            
 -- ,@DocumentVersionId          
 PRINT @ServiceId    
 PRINT @ClientId    
 PRINT @DocumentVersionId    
 PRINT @DocumentType    
    
 EXEC ssp_GetComponentXMLString @ServiceId    
  ,@ClientId    
  ,@DocumentVersionId    
  ,@DocumentType    
END 

GO


exec ssp_CCRCSMessageService @ServiceId=NULL,@StaffId=158,@DocumentVersionId=2601235,@DocumentType=N'SOC'
