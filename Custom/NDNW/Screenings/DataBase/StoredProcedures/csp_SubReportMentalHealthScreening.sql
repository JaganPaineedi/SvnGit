
IF EXISTS ( SELECT	 *
			FROM	 SYS.objects
			WHERE	 object_id = OBJECT_ID(N'[dbo].[csp_SubReportMentalHealthScreening]')
					 AND type IN (N'P', N'PC') ) 
   BEGIN 
	  DROP PROCEDURE [dbo].[csp_SubReportMentalHealthScreening] 
   END 
  GO              


CREATE PROCEDURE [dbo].[csp_SubReportMentalHealthScreening]
   @DocumentVersionId AS INT
AS /************************************************************************/                                                            
/* Stored Procedure: csp_SubReportMentalHealthScreening      */                                                   
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
/*Shruthi.S : 11/05/2015       Added to pull data for sub report Mental Health Screening. #39 New Directions - Customizations.*/

/*********************************************************************/           
   BEGIN     


	  SELECT   
		dbo.csf_GetGlobalCodeNameById(CS.PayingAttentionAtSchool) AS PayingAttentionAtSchool,
		dbo.csf_GetGlobalCodeNameById(CS.CanNotGetRidOfThought) AS CanNotGetRidOfThought,
		dbo.csf_GetGlobalCodeNameById(CS.HearVoices) AS HearVoices,
		dbo.csf_GetGlobalCodeNameById(CS.SpendTimeKilling) as SpendTimeKilling,
		dbo.csf_GetGlobalCodeNameById(CS.TriedToCommitSuicide) as TriedToCommitSuicide,
		dbo.csf_GetGlobalCodeNameById(CS.WatchYourStep) as WatchYourStep,
		dbo.csf_GetGlobalCodeNameById(CS.FeelAnxious) as FeelAnxious,
		dbo.csf_GetGlobalCodeNameById(CS.ThoughtsComeQuickly) as ThoughtsComeQuickly,
		dbo.csf_GetGlobalCodeNameById(CS.DestroyedProperty) as DestroyedProperty,
		dbo.csf_GetGlobalCodeNameById(CS.FeelTrapped) as FeelTrapped,
		dbo.csf_GetGlobalCodeNameById(CS.DissatifiedWithLife) as DissatifiedWithLife,
		dbo.csf_GetGlobalCodeNameById(CS.UnPleasantThoughts) as UnPleasantThoughts,
		dbo.csf_GetGlobalCodeNameById(CS.DifficultyInSleeping) as DifficultyInSleeping,
		dbo.csf_GetGlobalCodeNameById(CS.PhysicallyHarmed) as PhysicallyHarmed,
		dbo.csf_GetGlobalCodeNameById(CS.LostInterest) as LostInterest,
		dbo.csf_GetGlobalCodeNameById(CS.FeelAngry) as FeelAngry,
		dbo.csf_GetGlobalCodeNameById(CS.GetIntoTrouble) as GetIntoTrouble,
		dbo.csf_GetGlobalCodeNameById(CS.FeelAfraid) as FeelAfraid,
		dbo.csf_GetGlobalCodeNameById(CS.FeelDepressed) as FeelDepressed,
        dbo.csf_GetGlobalCodeNameById(CS.SpendTimeOnThinkingAboutWeight) as SpendTimeOnThinkingAboutWeight,
		Comments
	  FROM	   CustomDocumentMentalHealthScreenings AS CS
			   JOIN Documents d ON d.CurrentDocumentVersionId = @DocumentVersionId
								   OR d.InProgressDocumentVersionId = @DocumentVersionId
			   JOIN Clients c ON d.ClientId = c.ClientId and c.Active='Y'
	  WHERE	   (ISNULL(CS.RecordDeleted, 'N') = 'N')
			   AND (CS.DocumentVersionId = @DocumentVersionId)  
 
  
--Checking For Errors  
	  IF (@@error != 0) 
		 BEGIN  
			RAISERROR  20006   'csp_SubReportMentalHealthScreening : An Error Occured'  
			RETURN  
		 END  
   END      
  
  