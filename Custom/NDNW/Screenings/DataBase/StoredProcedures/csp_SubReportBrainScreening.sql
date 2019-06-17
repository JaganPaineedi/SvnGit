
IF EXISTS ( SELECT	 *
			FROM	 SYS.objects
			WHERE	 object_id = OBJECT_ID(N'[dbo].[csp_SubReportBrainScreening]')
					 AND type IN (N'P', N'PC') ) 
   BEGIN 
	  DROP PROCEDURE [dbo].[csp_SubReportBrainScreening] 
   END 
  GO              


CREATE PROCEDURE [dbo].[csp_SubReportBrainScreening]
   @DocumentVersionId AS INT
AS /************************************************************************/                                                            
/* Stored Procedure: csp_SubReportBrainScreening      */                                                   
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
/*Shruthi.S : 11/05/2015       Added to pull data for sub report Brain. #39 New Directions - Customizations.*/

/*********************************************************************/           
   BEGIN     


	  SELECT   
		dbo.csf_GetGlobalCodeNameById(CO.BlowToTheHead) AS BlowToTheHead,
			HeadBlowWhenDidItOccur,
			HowLongUnconscious,
			dbo.csf_GetGlobalCodeNameById(CO.CauseAConcussion) AS CauseAConcussion,
			ConcussionWhenDidItOccur, 
			HowLongConcussionLast,
			dbo.csf_GetGlobalCodeNameById(CO.ReceiveTreatmentForHeadInjury) AS ReceiveTreatmentForHeadInjury,
			dbo.csf_GetGlobalCodeNameById(CO.PhysicalAbilities) AS PhysicalAbilities,
			dbo.csf_GetGlobalCodeNameById(CO.Mood) AS Mood,
			dbo.csf_GetGlobalCodeNameById(CO.CareForYourSelf) AS CareForYourSelf,
			dbo.csf_GetGlobalCodeNameById(CO.Temper) AS Temper,
			dbo.csf_GetGlobalCodeNameById(CO.Speech) AS Speech,
			dbo.csf_GetGlobalCodeNameById(CO.RelationshipWithOthers) AS RelationshipWithOthers,
			dbo.csf_GetGlobalCodeNameById(CO.Hearing) AS Hearing,
			dbo.csf_GetGlobalCodeNameById(CO.Memory) AS Memory,
			dbo.csf_GetGlobalCodeNameById(CO.AbilityToConcentrate) AS AbilityToConcentrate,
			dbo.csf_GetGlobalCodeNameById(CO.UseOfAlcohol) AS UseOfAlcohol,
			dbo.csf_GetGlobalCodeNameById(CO.AbilityToWork) AS AbilityToWork,
			dbo.csf_GetGlobalCodeNameById(CO.ChangedAfterInjury) AS ChangedAfterInjury,
		    Comments
	  FROM	   CustomDocumentTraumaticBrainInjuryScreenings AS CO
			   JOIN Documents d ON d.CurrentDocumentVersionId = @DocumentVersionId
								   OR d.InProgressDocumentVersionId = @DocumentVersionId
			   JOIN Clients c ON d.ClientId = c.ClientId and c.Active='Y'
	  WHERE	   (ISNULL(CO.RecordDeleted, 'N') = 'N')
			   AND (CO.DocumentVersionId = @DocumentVersionId)  
			   

  
--Checking For Errors  
	  IF (@@error != 0) 
		 BEGIN  
			RAISERROR  20006   'csp_SubReportBrainScreening : An Error Occured'  
			RETURN  
		 END  
   END      
  
  