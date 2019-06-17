
GO

/****** Object:  StoredProcedure [dbo].[ssp_CCRSCMessageServiceforClientReports]    Script Date: 06/09/2015 02:36:18 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_CCRSCMessageServiceforClientReports]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_CCRSCMessageServiceforClientReports]
GO


GO

/****** Object:  StoredProcedure [dbo].[ssp_CCRSCMessageServiceforClientReports]    Script Date: 06/09/2015 02:36:18 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 
-- =============================================        
-- Author:  Veena         
-- Create date: Nov 04, 2014        
-- Description: Data for ClientReports       
/*        
 Author   Modified Date   Reason        
        
*/  
-- =============================================        
CREATE PROCEDURE [dbo].[ssp_CCRSCMessageServiceforClientReports] @DocumentVersionId BIGINT  
 ,@StaffId BIGINT  
 ,@ClientId BIGINT  
AS  
BEGIN  
 SET NOCOUNT ON;  
  IF @DocumentVersionId= 0
  SET @DocumentVersionId =NULL
  
    IF (@DocumentVersionId IS NOT NULL AND @ClientId IS NULL)  
    BEGIN  
 SELECT @ClientId = D.ClientId  
 FROM DocumentVersions DV  
 INNER JOIN Documents D ON D.InProgressDocumentVersionId = DV.DocumentVersionId  
 WHERE DV.DocumentVersionId = @DocumentVersionId  
  
 --UPDATE TransitionOfCareDocuments  
 --SET ExportedDate = GetDate()  
 --WHERE DocumentVersionId = @DocumentVersionId  
 -- AND ISNULL(RecordDeleted, 'N') = 'N'  
 END  
  
 --Main  
 SELECT CAST(NEWID() AS VARCHAR(50)) AS CCRDocumentObjectID  
  ,'English' AS LANGUAGE  
  ,'V1.0' AS Version  
  ,'CCR Creation DateTime' AS [DateTime_Type]  
  ,replace(replace(replace(convert(varchar(19), getdate(), 126),'-',''),'T',''),':','')AS DateTime_ApproximateDateTime  
  ,'Patient.' + CAST(@ClientId AS VARCHAR(100)) AS ActorID  
  ,'Patient' AS ActorRole  
  ,'For the patient' AS Purpose_Description;  
  
 --FromStaff  
 SELECT 'Staff.' + CAST(@StaffId AS VARCHAR(100)) AS ActorID  
  ,CAST(@StaffId AS VARCHAR(100)) AS ID1_ActorID  
  ,'Provider' AS ActorRole  
  ,ISNULL(LastName, '') AS Current_Family  
  ,ISNULL(FirstName, '') AS Current_Given  
  ,ISNULL(MiddleName, '') AS Current_Middle  
  ,CASE   
   WHEN lastname IS NULL  
    THEN ''  
   ELSE ISNULL(FirstName, '') + ' ' + ISNULL(LastName, '')  
   END AS Current_DisplayName  
  ,'' AS From_Actor_Title  
  ,ISNULL(CONVERT(VARCHAR(10), DOB, 21), '') AS DOB_ApproximateDateTime  
  ,CASE sex  
   WHEN 'F'  
    THEN 'Female'  
   WHEN 'M'  
    THEN 'Male'  
   ELSE 'Unknown'  
   END AS Gender  
  ,ISNULL(Email, '') AS CT1_Email_Value  
  ,'' AS ActorSpecialty  
  ,'Staff ID' AS ID1_IDType  
  ,'SmartCareEHR4.0' AS ID1_Source_ActorID  
  ,'SmartCareEHR4.0' AS SLRCGroup_Source_ActorID  
  ,'EHR' AS ID1_Source_ActorRole  
 FROM staff  
 WHERE StaffId = @StaffId;  
  
 --FromOrganization  
 SELECT TOP (1) REPLACE(A.AgencyName, ' ', '_') AS ActorID  
  ,A.AgencyName AS DisplayName  
  ,'Organization' AS ActorRole  
  ,'SmartCareEHR4.0' AS SLRCGroup_Source_ActorID  
  ,A.Address AS SLRCGroup_Source_ActorAddress  
  ,A.City AS SLRCGroup_Source_ActorCity  
  ,A.State AS SLRCGroup_Source_ActorState  
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
  
 EXEC ssp_CCRCSGetClientInfo @ClientId --(PatientInfo)  
  
 EXEC ssp_CCRCSGetMedicationAlertServiceSummary @ClientId --(Allergies)  
  ,NULL  
  
 EXEC ssp_CCRSCGetMedicationListServiceSummary @ClientId -- (Medications)  
  ,NULL  
  ,NULL  
  
 EXEC ssp_CCRCSGetProblemListSummary @ClientId -- (Problems)  
  ,NULL  
  ,@DocumentVersionId  
  
 EXEC ssp_CCRCSGetProcedureListServiceSummary @ClientId --(Procedures)  
  ,NULL  
  ,@DocumentVersionId  
  
 EXEC ssp_CCRCSGetResultReviewdVisit @ClientId -- (Results)  
  ,NULL  
  ,@DocumentVersionId  
  
 EXEC ssp_CCRCSEncounters @ClientId -- (Encounters)  
  ,NULL  
  ,@DocumentVersionId  
  
 --EXEC ssp_CCRCSGetLabResultsVitalsSmokeSummary @ClientId -- (ResultVitalsSmoke)  
 -- ,NULL  
 -- ,@DocumentVersionId  
  
 EXEC ssp_CCRCSGetImmunizations @ClientId -- (Immunizations)  
  ,NULL  
  ,@DocumentVersionId  
  
 EXEC ssp_CCRCSGetLabResultsServiceSummary @ClientId -- (ResultVitals)  
  ,NULL  
  ,@DocumentVersionId  
  
 EXEC ssp_CCRCSReasonforVisit @ClientId -- (ReasonforVisit)  
  ,NULL  
  ,@DocumentVersionId  
  
 EXEC ssp_CCRSCReasonforReferral @ClientId -- (ReasonforReferral)  
  ,NULL  
  ,@DocumentVersionId  
   
 --EXEC ssp_CCRSCPlanofCare @ClientId -- (PlanofCare)  
 -- ,NULL  
 -- ,@DocumentVersionId  
  
 EXEC ssp_CCRCSMedicationAdministrated @ClientId -- (MedicationAdministrated)  
  ,NULL  
  ,@DocumentVersionId  
  
 --EXEC ssp_CCRCSInstructions @ClientId -- (Instructions)  
 -- ,NULL  
 -- ,@DocumentVersionId  
END  
GO

