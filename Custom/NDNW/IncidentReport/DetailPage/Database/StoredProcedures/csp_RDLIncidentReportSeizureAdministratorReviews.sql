IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLIncidentReportSeizureAdministratorReviews]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLIncidentReportSeizureAdministratorReviews]
GO

/****** Object:  StoredProcedure [dbo].[csp_RDLIncidentReportSeizureAdministratorReviews]    Script Date: 11/27/2013 16:30:02 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE  [dbo].[csp_RDLIncidentReportSeizureAdministratorReviews]  
(                                                                                                                                                                                        
  @IncidentReportSeizureAdministratorReviewId int                                                                                                                                                        
)                                                     
AS 

/*********************************************************************/                                                                                                                                      
/* Stored Procedure: dbo.[csp_RDLIncidentReportSeizureAdministratorReviews]                */                                                                                                                                      
/* Copyright: 2008 Streamline Healthcare Solutions,  LLC             */                                                                                                                                      
/* Creation Date:   06-May-2015                                     */                                                                                                                                      
/*                                                                   */                                                                                                                                      
/* Purpose:  Get Data for CustomIncidentReportSeizureAdministratorReviews Pages */                                                                                                                                    
/*                                                                   */                                                                                                                                    
/* Input Parameters:  @IncidentReportSeizureAdministratorReviewId           */                                                                                                                                    
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
 12 April 2019	Vithobha		Fixed the latent issue by adding Label names for SeizureAdministratorReviewFiledReportableIncident column, New Directions - Enhancements: #26*/                                                                                                           
/*********************************************************************/                                                                                                                              
                                                                                                                                                                                                                                 
BEGIN
BEGIN TRY  
		
		SELECT
			 (S.LastName +', '+ S.FirstName) AS Administrator
			,(S1.LastName +', '+ S1.FirstName) AS SignedBy
			,CIRSA.SeizureAdministratorReviewAdministrativeReview AS AdministrativeReview
			,CASE CIRSA.SeizureAdministratorReviewFiledReportableIncident 
			WHEN 'Y'
				THEN 'Yes'
			WHEN 'N'
				THEN 'No'
			WHEN 'O'  
				THEN 'Other' 
			END	AS FiledReportableIncident
			,CIRSA.SeizureAdministratorReviewComments AS Comments
			,CONVERT(VARCHAR(10),CIRSA.SignedDate, 101) AS SignedDate
			,CIRSA.PhysicalSignature
			,dbo.csf_GetGlobalCodeNameById(CIRSA.CurrentStatus) AS CurrentStatus
			,dbo.csf_GetGlobalCodeNameById(CIRSA.InProgressStatus) AS InProgressStatus
			FROM CustomIncidentReportSeizureAdministratorReviews CIRSA
			LEFT JOIN Staff S ON CIRSA.SeizureAdministratorReviewAdministrator = S.StaffId  
			AND isnull(S.RecordDeleted, 'N') <> 'Y'
			LEFT JOIN Staff S1 ON CIRSA.SignedBy = S1.StaffId 
			AND isnull(S1.RecordDeleted, 'N') <> 'Y'
			WHERE CIRSA.IncidentReportSeizureAdministratorReviewId = @IncidentReportSeizureAdministratorReviewId AND isnull(CIRSA.RecordDeleted, 'N') = 'N'  
  
 END TRY  
  
 BEGIN CATCH  
  DECLARE @Error VARCHAR(8000)  
  
  SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'csp_RDLIncidentReportSeizureAdministratorReviews') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())  
  
  RAISERROR (  
    @Error  
    ,-- Message text.  
    16  
    ,-- Severity.  
    1 -- State.  
    );  
 END CATCH  
END 