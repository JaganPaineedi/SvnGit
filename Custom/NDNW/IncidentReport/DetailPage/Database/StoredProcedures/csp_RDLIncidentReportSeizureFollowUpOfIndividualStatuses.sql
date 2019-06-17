IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLIncidentReportSeizureFollowUpOfIndividualStatuses]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLIncidentReportSeizureFollowUpOfIndividualStatuses]
GO

/****** Object:  StoredProcedure [dbo].[csp_RDLIncidentReportSeizureFollowUpOfIndividualStatuses]    Script Date: 11/27/2013 16:30:02 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE  [dbo].[csp_RDLIncidentReportSeizureFollowUpOfIndividualStatuses]  
(                                                                                                                                                                                        
  @IncidentReportSeizureFollowUpOfIndividualStatusId int                                                                                                                                                        
)                                                     
AS 

/*********************************************************************/                                                                                                                                      
/* Stored Procedure: dbo.[csp_RDLIncidentReportSeizureFollowUpOfIndividualStatuses]                */                                                                                                                                      
/* Copyright: 2008 Streamline Healthcare Solutions,  LLC             */                                                                                                                                      
/* Creation Date:   06-May-2015                                     */                                                                                                                                      
/*                                                                   */                                                                                                                                      
/* Purpose:  Get Data for CustomIncidentReportSeizureFollowUpOfIndividualStatuses Pages */                                                                                                                                    
/*                                                                   */                                                                                                                                    
/* Input Parameters:  @IncidentReportSeizureFollowUpOfIndividualStatusId           */                                                                                                                                    
/*                                                                   */                                                                                                                                      
/* Output Parameters:   None                   */                                                                                                                                      
/*                                                                   */                                                                                                                                      
/* Return:  0=success, otherwise an error number                     */                                                                                                                                      
/*                                                                   */                                                                                                                                      
/* Called By:                                                        */                                                                                                                                      
/*                                                                   */                  
/* Calls:                        */                       
/* */                                         
/* Data Modifications:   */                                          
/*      */                                                                                     
/* Updates:                                          
 Date			Author			Purpose       
 ----------		---------		--------------------------------------                                                                               
 07-May-2015	Ravichandra		what:Use For Rdl Report  
								why:task #818 Woods – Customizations 
12 April 2019	Vithobha		Fixed the latent issue by adding missing columns, New Directions - Enhancements: #26 */                                                                                                           
/*********************************************************************/                                                                                                                              
                                                                                                                                                                                                                                 
BEGIN
BEGIN TRY  
		
		SELECT
			 (S.LastName +', '+ S.FirstName) AS NurseStaffEvaluating
			,(S1.LastName +', '+ S1.FirstName) AS StaffCompletedNotification
			,(S2.LastName +', '+ S2.FirstName) AS SignedBy
			,CIRSI.SeizureFollowUpIndividualStatusCredentialTitle AS CredentialTitle
			,CIRSI.SeizureFollowUpIndividualStatusDetailsOfInjury AS DetailsOfInjury
			,CIRSI.SeizureFollowUpIndividualStatusComments AS Comments
			,CASE CIRSI.SeizureFollowUpIndividualStatusFamilyGuardianCustodianNotified
			   WHEN 'Y' THEN 'Yes' 
			   WHEN 'N' THEN 'NO' 
			   END   AS FamilyGuardianCustodianNotified
			,CONVERT(VARCHAR(10), CIRSI.SeizureFollowUpIndividualStatusDateOfNotification, 101)AS DateOfNotification
			,(right('0' + LTRIM(SUBSTRING(CONVERT(varchar, CIRSI.SeizureFollowUpIndividualStatusTimeOfNotification, 100), 13, 2)),2)+ ':'
 + SUBSTRING(CONVERT(varchar, CIRSI.SeizureFollowUpIndividualStatusTimeOfNotification, 100), 16, 2) + ' '
 + SUBSTRING(CONVERT(varchar, CIRSI.SeizureFollowUpIndividualStatusTimeOfNotification, 100), 18, 2)) AS TimeOfNotification
			,CIRSI.SeizureFollowUpIndividualStatusNameOfFamilyGuardianCustodian AS NameOfFamilyGuardianCustodian
			,CIRSI.SeizureFollowUpIndividualStatusDetailsOfNotification AS DetailsOfNotification
			,CONVERT(VARCHAR(10), CIRSI.SignedDate, 101) AS SignedDate
			,CIRSI.PhysicalSignature
			,dbo.csf_GetGlobalCodeNameById(CIRSI.CurrentStatus) AS CurrentStatus
			,dbo.csf_GetGlobalCodeNameById(CIRSI.InProgressStatus) AS InProgressStatus
			,SeizureDetailsO2Given AS  O2Given
			,SeizureDetailsLiterMin AS LiterMin
			,SeizureDetailsEmergencyMedicationsGiven AS EmergencyMedicationsGiven
			,dbo.csf_GetGlobalCodeNameById(CIRSI.NoteType) AS NoteType
			,Convert(VARCHAR(10), CIRSI.NoteStart, 101) AS  NoteStart
			,Convert(VARCHAR(10), CIRSI.NoteEnd, 101) AS  NoteEnd
			,CIRSI.NoteComment
			FROM CustomIncidentReportSeizureFollowUpOfIndividualStatuses CIRSI
			LEFT JOIN Staff S ON CIRSI.SeizureFollowUpIndividualStatusNurseStaffEvaluating = S.StaffId  
			AND isnull(S.RecordDeleted, 'N') <> 'Y'
			LEFT JOIN Staff S1 ON CIRSI.SeizureFollowUpIndividualStatusStaffCompletedNotification = S1.StaffId 
			AND isnull(S1.RecordDeleted, 'N') <> 'Y'
			LEFT JOIN Staff S2 ON CIRSI.SignedBy = S2.StaffId   
			AND isnull(S2.RecordDeleted, 'N') <> 'Y'
			WHERE CIRSI.IncidentReportSeizureFollowUpOfIndividualStatusId = @IncidentReportSeizureFollowUpOfIndividualStatusId AND isnull(CIRSI.RecordDeleted, 'N') = 'N'  
  
 END TRY  
  
 BEGIN CATCH  
  DECLARE @Error VARCHAR(8000)  
  
  SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'csp_RDLIncidentReportSeizureFollowUpOfIndividualStatuses') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())  
  
  RAISERROR (  
    @Error  
    ,-- Message text.  
    16  
    ,-- Severity.  
    1 -- State.  
    );  
 END CATCH  
END 