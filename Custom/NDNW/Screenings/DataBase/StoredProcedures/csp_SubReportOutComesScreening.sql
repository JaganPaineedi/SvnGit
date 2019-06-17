
IF EXISTS ( SELECT	 *
			FROM	 SYS.objects
			WHERE	 object_id = OBJECT_ID(N'[dbo].[csp_SubReportOutComesScreening]')
					 AND type IN (N'P', N'PC') ) 
   BEGIN 
	  DROP PROCEDURE [dbo].[csp_SubReportOutComesScreening] 
   END 
  GO              


CREATE PROCEDURE [dbo].[csp_SubReportOutComesScreening]
   @DocumentVersionId AS INT
AS /************************************************************************/                                                            
/* Stored Procedure: csp_SubReportOutComesScreening      */                                                   
/*        */                                                            
/* Creation Date:  11/05/2015           */                                                            
/*                  */                                                            
/* Purpose: Gets Data for csp_Subreport       */                                                           
/* Input Parameters: DocumentVersionId        */                                                          
/* Output Parameters:             */                                                            
/* Purpose: Use For Rdl Report           */                                                  
/* Calls:                */                                                            
/*                  */                                                            
/*Author :    Date             Purpose    */
/*Shruthi.S : 11/05/2015       Added to pull data for sub report OutComes. #39 New Directions - Customizations.*/

/*********************************************************************/           
   BEGIN     


	  SELECT   
		dbo.csf_GetGlobalCodeNameById(CO.SubstanceAbuseConsumer) AS SubstanceAbuseConsumer,
		SubstanceAbuseConsumerSteps,
		dbo.csf_GetGlobalCodeNameById(CO.MentalHealthConsumer) AS MentalHealthConsumer,
		MentalHealthConsumerSteps,
		dbo.csf_GetGlobalCodeNameById(CO.FASDAssessment) AS FASDAssessment,
		FASDAssessmentSteps,
		dbo.csf_GetGlobalCodeNameById(CO.MHAndSAConsumer) AS MHAndSAConsumer,
		MHAndSAConsumerSteps,
		dbo.csf_GetGlobalCodeNameById(CO.EvidenceOfInjury) AS EvidenceOfInjury,
		EvidenceOfInjurySteps,
		Comments
	  FROM	   CustomDocumentOutComesScreenings AS CO
			   JOIN Documents d ON d.CurrentDocumentVersionId = @DocumentVersionId
								   OR d.InProgressDocumentVersionId = @DocumentVersionId
			   JOIN Clients c ON d.ClientId = c.ClientId and c.Active='Y'
	  WHERE	   (ISNULL(CO.RecordDeleted, 'N') = 'N')
			   AND (CO.DocumentVersionId = @DocumentVersionId)  
  
--Checking For Errors  
	  IF (@@error != 0) 
		 BEGIN  
			RAISERROR  20006   'csp_SubReportOutComesScreening : An Error Occured'  
			RETURN  
		 END  
   END      
  
  