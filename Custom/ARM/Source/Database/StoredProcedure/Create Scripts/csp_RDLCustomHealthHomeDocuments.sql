/****** Object:  StoredProcedure [dbo].[csp_RDLCustomHealthHomeDocuments]    Script Date: 06/19/2013 17:49:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomHealthHomeDocuments]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLCustomHealthHomeDocuments]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomHealthHomeDocuments]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE   [dbo].[csp_RDLCustomHealthHomeDocuments]         
(                               
@DocumentVersionId  int           
)                      
AS                      
                
Begin                
-- =============================================
-- Author:		Bernardin
-- Create date: 31/01/2013
-- Description:	To get data for Custom Health Home Documents RDL.
-- ============================================= 

SELECT     CDHHCP.DocumentVersionId, CDHHCP.CreatedBy, 
                      CDHHCP.CreatedDate, CDHHCP.ModifiedBy, 
                      CDHHCP.ModifiedDate, CDHHCP.RecordDeleted, 
                      CDHHCP.DeletedBy, CDHHCP.DeletedDate, 
                      dbo.GetStaffMember(CDHHCP.HealthHomeTeamMember1) AS HHTeamMember1, 
                      dbo.csf_GetGlobalCodeNameById(CDHHCP.HealthHomeTeamRole1) AS HHTeamRole1, 
                      dbo.GetStaffMember(CDHHCP.HealthHomeTeamMember2) AS HHTeamMember2, 
                      dbo.csf_GetGlobalCodeNameById(CDHHCP.HealthHomeTeamRole2) AS HHTeamRole2, 
                      dbo.GetStaffMember(CDHHCP.HealthHomeTeamMember3) AS HHTeamMember3, 
                      dbo.csf_GetGlobalCodeNameById(CDHHCP.HealthHomeTeamRole3) AS HHTeamRole3, 
                      dbo.GetStaffMember(CDHHCP.HealthHomeTeamMember4) AS HHTeamMember4, 
                      dbo.csf_GetGlobalCodeNameById(CDHHCP.HealthHomeTeamRole4) AS HHTeamRole4, 
                      dbo.GetStaffMember(CDHHCP.HealthHomeTeamMember5) AS HHTeamMember5, 
                      dbo.csf_GetGlobalCodeNameById(CDHHCP.HealthHomeTeamRole5) AS HHTeamRole5, 
                      dbo.GetStaffMember(CDHHCP.HealthHomeTeamMember6) AS HHTeamMember6, 
                      dbo.csf_GetGlobalCodeNameById(CDHHCP.HealthHomeTeamRole6) AS HHTeamRole6, 
                      dbo.GetStaffMember(CDHHCP.HealthHomeTeamMember7) AS HHTeamMember7, 
                      dbo.csf_GetGlobalCodeNameById(CDHHCP.HealthHomeTeamRole7) AS HHTeamRole7, 
                      CDHHCP.PrimaryCarePhysicianName, 
                      CDHHCP.PrimaryCarePhysicianPhone, CDHHCP.PrimaryCarePhysicianFax, 
                      CDHHCP.DentistName, 
                      CDHHCP.DentistPhone, CDHHCP.DentistFax, 
                      CDHHCP.LongTermCareFacility, CDHHCP.LongTermCareFacilityNA, 
                      CDHHCP.AODRehabFacility, CDHHCP.AODRehabFacilityNA, 
                      CDHHCP.PreferredHospital, CDHHCP.PreferredPsychHospital, 
                      CDHHCP.PreferredPsychHospitalNA, CDHHCP.PreferredCMHProvider, 
                      CDHHCP.SpecialCommentsRegardingProvider, 
                      dbo.csf_GetGlobalCodeNameById(CDHHCP.MedicaidManagedCarePlan) AS MedicaidManagedCarePlan, 
                      CDHHCP.MedicaidManagedCarePlanNA, CDHHCP.LegalGuardian, 
                      CDHHCP.ClientGuardianParticipatedInPlan, 
                      CONVERT(VARCHAR(10), Documents.EffectiveDate, 101) as EffectiveDate,
                      Clients.FirstName + '' '' + Clients.LastName AS ClientName,
                      Clients.ClientId, Clients.LastName, Clients.FirstName, 
                      CONVERT(VARCHAR(10), Clients.DOB, 101) as DOB
FROM       CustomDocumentHealthHomeCommPlans AS CDHHCP INNER JOIN
                      DocumentVersions AS DV ON CDHHCP.DocumentVersionId = DV.DocumentVersionId INNER JOIN
                      Documents ON DV.DocumentId = Documents.DocumentId AND DV.DocumentVersionId = Documents.CurrentDocumentVersionId AND 
                      DV.DocumentVersionId = Documents.InProgressDocumentVersionId INNER JOIN
                      Clients ON Documents.ClientId = Clients.ClientId
WHERE     (ISNULL(CDHHCP.RecordDeleted, ''N'') = ''N'') AND (CDHHCP.DocumentVersionId = @DocumentVersionId)
             
--Checking For Errors                          
If (@@error!=0)                                                      
 Begin                                                      
  RAISERROR  20006   ''[csp_RDLCustomHealthHomeDocuments] : An Error Occured''                                                       
  Return                                                      
 End                                                               
End
' 
END
GO
