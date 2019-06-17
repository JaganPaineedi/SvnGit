
IF EXISTS ( SELECT	 *
			FROM	 SYS.objects
			WHERE	 object_id = OBJECT_ID(N'[dbo].[csp_SubReportSubstanceAbuseScreening]')
					 AND type IN (N'P', N'PC') ) 
   BEGIN 
	  DROP PROCEDURE [dbo].[csp_SubReportSubstanceAbuseScreening] 
   END 
  GO              


CREATE PROCEDURE [dbo].[csp_SubReportSubstanceAbuseScreening]
   @DocumentVersionId AS INT
AS /************************************************************************/                                                            
/* Stored Procedure: csp_SubReportSubstanceAbuseScreening      */                                                   
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
/*Shruthi.S : 11/05/2015       Added to pull data for sub report Substance Abuse Screening. #39 New Directions - Customizations.*/

/*********************************************************************/           
   BEGIN     


	  SELECT   
		dbo.csf_GetGlobalCodeNameById(CS.Inhalants) AS Inhalants, 
		dbo.csf_GetGlobalCodeNameById(CS.MissedSchool) AS MissedSchool,
		dbo.csf_GetGlobalCodeNameById(CS.PastYearDrunk) AS PastYearDrunk,
		dbo.csf_GetGlobalCodeNameById(CS.RiskyWhenHigh) as RiskyWhenHigh,
		dbo.csf_GetGlobalCodeNameById(CS.ProblemWithDrinking) as ProblemWithDrinking,
		dbo.csf_GetGlobalCodeNameById(CS.ThingsWithoutThinking) as ThingsWithoutThinking,
		dbo.csf_GetGlobalCodeNameById(CS.MissFamilyActivities) as MissFamilyActivities,
		dbo.csf_GetGlobalCodeNameById(CS.WorryAboutUsingAlcohol) as WorryAboutUsingAlcohol,
		dbo.csf_GetGlobalCodeNameById(CS.HurtLovedOne) as HurtLovedOne,
		dbo.csf_GetGlobalCodeNameById(CS.ToFeelNormal) as ToFeelNormal,
		dbo.csf_GetGlobalCodeNameById(CS.MakeYouMad) as MakeYouMad,
		dbo.csf_GetGlobalCodeNameById(CS.GuiltyAboutAlcohol) as GuiltyAboutAlcohol,
		dbo.csf_GetGlobalCodeNameById(CS.WorryAboutGamblingActivities) as WorryAboutGamblingActivities,
		dbo.csf_GetGlobalCodeNameById(CS.HasMotherConsumedAlcohol) as HasMotherConsumedAlcohol,
		dbo.csf_GetGlobalCodeNameById(CS.DidMotherDrinkInPregnancy) as DidMotherDrinkInPregnancy,
		Comments
	  FROM	   [CustomDocumentSubstanceAbuseScreenings] AS CS
			   JOIN Documents d ON d.CurrentDocumentVersionId = @DocumentVersionId
								   OR d.InProgressDocumentVersionId = @DocumentVersionId
			   JOIN Clients c ON d.ClientId = c.ClientId and c.Active='Y'
	  WHERE	   (ISNULL(CS.RecordDeleted, 'N') = 'N')
			   AND (CS.DocumentVersionId = @DocumentVersionId)  
 
  
--Checking For Errors  
	  IF (@@error != 0) 
		 BEGIN  
			RAISERROR  20006   'csp_SubReportSubstanceAbuseScreening : An Error Occured'  
			RETURN  
		 END  
   END      
  
  