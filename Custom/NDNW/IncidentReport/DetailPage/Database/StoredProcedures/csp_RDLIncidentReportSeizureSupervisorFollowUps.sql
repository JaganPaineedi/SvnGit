IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLIncidentReportSeizureSupervisorFollowUps]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLIncidentReportSeizureSupervisorFollowUps]
GO

/****** Object:  StoredProcedure [dbo].[csp_RDLIncidentReportSeizureSupervisorFollowUps]    Script Date:  ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE  [dbo].[csp_RDLIncidentReportSeizureSupervisorFollowUps]  
(                                                                                                                                                                                        
  @IncidentReportSeizureSupervisorFollowUpId int                                                                                                                                                        
)                                                     
AS 

/*********************************************************************/                                                                                                                                      
/* Stored Procedure: dbo.[csp_RDLIncidentReportSeizureSupervisorFollowUps]                */                                                                                                                                      
/* Copyright: 2008 Streamline Healthcare Solutions,  LLC             */                                                                                                                                      
/* Creation Date:   06-May-2015                                     */                                                                                                                                      
/*                                                                   */                                                                                                                                      
/* Purpose:  Get Data for CustomIncidentReportSeizureSupervisorFollowUps Pages */                                                                                                                                    
/*                                                                   */                                                                                                                                    
/* Input Parameters:  @IncidentReportFallFollowUpOfIndividualStatusId           */                                                                                                                                    
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
*/                                                                                                           
/*********************************************************************/                                                                                                                              
                                                                                                                                                                                                                                 
BEGIN
BEGIN TRY  
		
		SELECT
			 (S.LastName +', '+ S.FirstName) AS SupervisorName
			,(S1.LastName +', '+ S1.FirstName) AS Administrator
			,(S2.LastName +', '+ S2.FirstName) AS StaffCompletedNotification
			,(S3.LastName +', '+ S3.FirstName) AS SignedBy
			,CIRSS.SeizureSupervisorFollowUpFollowUp AS FollowUp
			,CASE CIRSS.SeizureSupervisorFollowUpAdministratorNotified
			   WHEN 'Y' THEN 'Yes' 
			   WHEN 'N' THEN 'NO' 
			   END   AS AdministratorNotified
			,CONVERT(VARCHAR(10),CIRSS.SeizureSupervisorFollowUpAdminDateOfNotification, 101) AS AdminDateOfNotification
			,(right('0' + LTRIM(SUBSTRING(CONVERT(varchar, CIRSS.SeizureSupervisorFollowUpAdminTimeOfNotification, 100), 13, 2)),2)+ ':'
 + SUBSTRING(CONVERT(varchar, CIRSS.SeizureSupervisorFollowUpAdminTimeOfNotification, 100), 16, 2) + ' '
 + SUBSTRING(CONVERT(varchar, CIRSS.SeizureSupervisorFollowUpAdminTimeOfNotification, 100), 18, 2)) AS TimeOfNotification
			,CASE CIRSS.SeizureSupervisorFollowUpFamilyGuardianCustodianNotified
			   WHEN 'Y' THEN 'Yes' 
			   WHEN 'N' THEN 'NO' 
			   END   AS FamilyGuardianCustodianNotified
			,CONVERT(VARCHAR(10),CIRSS.SeizureSupervisorFollowUpFGCDateOfNotification, 101)AS FGCDateOfNotification
			,(right('0' + LTRIM(SUBSTRING(CONVERT(varchar, CIRSS.SeizureSupervisorFollowUpFGCTimeOfNotification, 100), 13, 2)),2)+ ':'
 + SUBSTRING(CONVERT(varchar,CIRSS.SeizureSupervisorFollowUpFGCTimeOfNotification, 100), 16, 2) + ' '
 + SUBSTRING(CONVERT(varchar, CIRSS.SeizureSupervisorFollowUpFGCTimeOfNotification, 100), 18, 2))FGCTimeOfNotification
			,CIRSS.SeizureSupervisorFollowUpNameOfFamilyGuardianCustodian AS NameOfFamilyGuardianCustodian
			,CIRSS.SeizureSupervisorFollowUpDetailsOfNotification AS DetailsOfNotification
			,CONVERT(VARCHAR(10),CIRSS.SignedDate, 101) AS SignedDate
			,CIRSS.PhysicalSignature
			,dbo.csf_GetGlobalCodeNameById(CIRSS.CurrentStatus) AS CurrentStatus
			,dbo.csf_GetGlobalCodeNameById(CIRSS.InProgressStatus) AS InProgressStatus
			,(case when isnull(CIRSS.SupervisorFollowUpManagerNotified,'N') = 'Y' then 'Yes'
		   else 'No' end) as  SupervisorFollowUpManagerNotified 
		,SM.LastName + ',' + SM.FirstName AS SupervisorFollowUpManager
		,Convert(VARCHAR(10), CIRSS.SupervisorFollowUpManagerDateOfNotification, 101) AS SupervisorFollowUpManagerDateOfNotification
	,(right('0' + LTRIM(SUBSTRING(CONVERT(VARCHAR, CIRSS.SupervisorFollowUpManagerTimeOfNotification, 100), 13, 2)), 2) + ':' + SUBSTRING(CONVERT(VARCHAR, CIRSS.SupervisorFollowUpManagerTimeOfNotification, 100), 16, 2) + ' ' + SUBSTRING(CONVERT(VARCHAR, CIRSS.SupervisorFollowUpManagerTimeOfNotification, 100), 18, 2)) AS SupervisorFollowUpManagerTimeOfNotification
			FROM CustomIncidentReportSeizureSupervisorFollowUps CIRSS
			LEFT JOIN Staff S ON CIRSS.SeizureSupervisorFollowUpSupervisorName = S.StaffId  
			AND isnull(S.RecordDeleted, 'N') <> 'Y'
			LEFT JOIN Staff S1 ON CIRSS.SeizureSupervisorFollowUpAdministrator = S1.StaffId 
			AND isnull(S1.RecordDeleted, 'N') <> 'Y'
			LEFT JOIN Staff S2 ON CIRSS.SeizureSupervisorFollowUpStaffCompletedNotification = S2.StaffId   
			AND isnull(S2.RecordDeleted, 'N') <> 'Y'
			LEFT JOIN Staff S3 ON CIRSS.SignedBy = S3.StaffId   
			AND isnull(S3.RecordDeleted, 'N') <> 'Y'
			LEFT JOIN Staff SM ON SM.StaffId = CIRSS.SupervisorFollowUpManager
			WHERE CIRSS.IncidentReportSeizureSupervisorFollowUpId = @IncidentReportSeizureSupervisorFollowUpId AND isnull(CIRSS.RecordDeleted, 'N') = 'N'  
  
 END TRY  
  
 BEGIN CATCH  
  DECLARE @Error VARCHAR(8000)  
  
  SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'csp_RDLIncidentReportSeizureSupervisorFollowUps') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())  
  
  RAISERROR (  
    @Error  
    ,-- Message text.  
    16  
    ,-- Severity.  
    1 -- State.  
    );  
 END CATCH  
END 