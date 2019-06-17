IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLIncidentReportFallAdministratorReviews]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLIncidentReportFallAdministratorReviews]
GO

/****** Object:  StoredProcedure [dbo].[csp_RDLIncidentReportFallAdministratorReviews]    Script Date: 11/27/2013 16:30:02 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE  [dbo].[csp_RDLIncidentReportFallAdministratorReviews]  
(                                                                                                                                                                                        
  @IncidentReportFallAdministratorReviewId int                                                                                                                                                        
)                                                     
AS 

/*********************************************************************/                                                                                                                                      
/* Stored Procedure: dbo.[csp_RDLIncidentReportFallAdministratorReviews]                */                                                                                                                                      
/* Copyright: 2008 Streamline Healthcare Solutions,  LLC             */                                                                                                                                      
/* Creation Date:   06-May-2015                                     */                                                                                                                                      
/*                                                                   */                                                                                                                                      
/* Purpose:  Get Data for CustomIncidentReportFallAdministratorReviews Pages */                                                                                                                                    
/*                                                                   */                                                                                                                                    
/* Input Parameters:  @IncidentReportFallAdministratorReviewId           */                                                                                                                                    
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
12 April 2019	Vithobha		Fixed the latent issue by adding label names for FallAdministratorReviewFiledReportableIncident column, New Directions - Enhancements: #26*/                                                                                                           
/*********************************************************************/                                                                                                                              
                                                                                                                                                                                                                                 
BEGIN
BEGIN TRY  
		
		SELECT
			 (S.LastName +', '+ S.FirstName) AS Administrator
			,(S1.LastName +', '+ S1.FirstName) AS SignedBy
			,CIRFA.FallAdministratorReviewAdministrativeReview  AS AdministrativeReview
			,Case CIRFA.FallAdministratorReviewFiledReportableIncident 
			WHEN 'Y'  
				THEN 'Yes'  
			WHEN 'N'  
				THEN 'No'  
			WHEN 'O'  
				THEN 'Other'  	
			END AS FiledReportableIncident 
			,CIRFA.FallAdministratorReviewComments AS Comments
			,CONVERT(VARCHAR(10),CIRFA.SignedDate, 101) AS SignedDate
			,CIRFA.PhysicalSignature
			,dbo.csf_GetGlobalCodeNameById(CIRFA.CurrentStatus) AS CurrentStatus
			,dbo.csf_GetGlobalCodeNameById(CIRFA.InProgressStatus) AS InProgressStatus
			FROM CustomIncidentReportFallAdministratorReviews CIRFA
			LEFT JOIN Staff S ON CIRFA.FallAdministratorReviewAdministrator = S.StaffId  
			AND isnull(S.RecordDeleted, 'N') <> 'Y'
			LEFT JOIN Staff S1 ON CIRFA.SignedBy = S1.StaffId 
			AND isnull(S1.RecordDeleted, 'N') <> 'Y'
			WHERE CIRFA.IncidentReportFallAdministratorReviewId = @IncidentReportFallAdministratorReviewId AND isnull(CIRFA.RecordDeleted, 'N') = 'N'  
  
 END TRY  
  
 BEGIN CATCH  
  DECLARE @Error VARCHAR(8000)  
  
  SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'csp_RDLIncidentReportFallAdministratorReviews') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())  
  
  RAISERROR (  
    @Error  
    ,-- Message text.  
    16  
    ,-- Severity.  
    1 -- State.  
    );  
 END CATCH  
END 