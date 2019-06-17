IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLDocumentSocialPsychologicalAndBehaviors]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_RDLDocumentSocialPsychologicalAndBehaviors]
GO

CREATE PROCEDURE  [dbo].[ssp_RDLDocumentSocialPsychologicalAndBehaviors]          
(                              
	@DocumentVersionId INT                                                                                                                                                 
)                              
AS
 /*********************************************************************/                                                                                        
 /* Stored Procedure: [ssp_RDLDocumentSocialPsychologicalAndBehaviors]              */                                                                             
 /* Creation Date:  24-04-2017                                  */                                                                                        
 /* Purpose: To RDL Get Data DocumentSocialPsychologicalAndBehaviors	 Document			  */                                                                                       
 /* Input Parameters:   @DocumentVersionId							  */                                                                                      
 /* Output Parameters:											      */                                                                                        
 /* Return:															  */                                                                                        
 /* Called By:					                                       */                                           
 /* Calls:                                                            */                                                                                        
 /* CreatedBy: Ravichandra 	                                          */                                                                                        
 /* Data Modifications:                                               */                                                                                        
 /*   Updates:                                                        */                                                                                        
 /*   Date               Author                  Purpose              */   
 /*   06-07-2017		 Ravichandra			 Meaningful Use - Stage 3 - Task#42   */ 
 /*********************************************************************/ 
 BEGIN
BEGIN TRY
		SELECT 
		 (select top 1 OrganizationName from SystemConfigurations ) as OrganizationName,
		C.ClientId,
		ISNULL(C.LastName, '') + ' ' + ISNULL(C.FirstName, '') AS ClientName,    
		Convert(varchar(10),C.DOB,101) AS  DOB, 
		Convert(varchar(10),D.EffectiveDate,101) AS  EffectiveDate,   
		SPB.DocumentVersionId,
		DC.DocumentName,
		dbo.ssf_GetGlobalCodeNameById(SPB.FinancialResourceStrain) AS FinancialResourceStrain,
		SPB.FinancialResourceStrainDetails,
		dbo.ssf_GetGlobalCodeNameById(SPB.Education) AS  Education,
		SPB.EducationDetails,
		dbo.ssf_GetGlobalCodeNameById(SPB.Stress) AS  Stress,
		SPB.StressDetails,
		dbo.ssf_GetGlobalCodeNameById(SPB.DepressionLittleInterest) AS  DepressionLittleInterest,
		dbo.ssf_GetGlobalCodeNameById(SPB.DepressionFeelingDown) AS  DepressionFeelingDown,
		SPB.DepressionDetails,
		dbo.ssf_GetGlobalCodeNameById(SPB.PhysicalActivityBriskWalk) AS  PhysicalActivityBriskWalk,
		SPB.PhysicalActivityExerciseMinutes,
		SPB.PhysicalActivityDeclineToSpecify,
		SPB.PhysicalActivityDetails,
		dbo.ssf_GetGlobalCodeNameById(SPB.AlcoholHowAften) AS  AlcoholHowAften,
		dbo.ssf_GetGlobalCodeNameById(SPB.AlcoholStandardDrinks) AS  AlcoholStandardDrinks,
		dbo.ssf_GetGlobalCodeNameById(SPB.AlcoholOccasionDrinks) AS  AlcoholOccasionDrinks,
		SPB.AlcoholDetails,
		dbo.ssf_GetGlobalCodeNameById(SPB.SocialConnectionMaritalStatus) AS  SocialConnectionMaritalStatus,
		dbo.ssf_GetGlobalCodeNameById(SPB.SocialConnectionTalkTime) AS  SocialConnectionTalkTime,
		dbo.ssf_GetGlobalCodeNameById(SPB.SocialConnectionGetTogether) AS  SocialConnectionGetTogether,
		dbo.ssf_GetGlobalCodeNameById(SPB.SocialConnectionReligiousServices) AS  SocialConnectionReligiousServices,
		dbo.ssf_GetGlobalCodeNameById(SPB.SocialConnectionBelongsTo) AS  SocialConnectionBelongsTo,
		SPB.SocialConnectionDetails,
		dbo.ssf_GetGlobalCodeNameById(SPB.ViolenceHumiliated) AS  ViolenceHumiliated,
		dbo.ssf_GetGlobalCodeNameById(SPB.ViolenceAfraid) AS  ViolenceAfraid,
		dbo.ssf_GetGlobalCodeNameById(SPB.ViolenceSexualActivity) AS  ViolenceSexualActivity,
		dbo.ssf_GetGlobalCodeNameById(SPB.ViolencePhysicallyHurt) AS  ViolencePhysicallyHurt,
		SPB.ViolenceDetails
		,CASE WHEN dbo.ssf_GetGlobalCodeNameById(SPB.DepressionLittleInterest)='Declined to Specify' AND  dbo.ssf_GetGlobalCodeNameById(SPB.DepressionFeelingDown)='Declined to Specify'
		 THEN ''
		 ELSE CASE
		 WHEN dbo.ssf_GetGlobalCodeNameById(SPB.DepressionLittleInterest) ='Not at all' then 0 
			  WHEN dbo.ssf_GetGlobalCodeNameById(SPB.DepressionLittleInterest) ='Several Days' then 1
			   WHEN dbo.ssf_GetGlobalCodeNameById(SPB.DepressionLittleInterest) ='More than half the days' then 2
			   WHEN dbo.ssf_GetGlobalCodeNameById(SPB.DepressionLittleInterest) ='Nearly every day' then 3
			   ELSE 0
			    end  +
			  CASE WHEN dbo.ssf_GetGlobalCodeNameById(SPB.DepressionFeelingDown) ='Not at all' then 0 
			  WHEN dbo.ssf_GetGlobalCodeNameById(SPB.DepressionFeelingDown) ='Several Days' then 1
			   WHEN dbo.ssf_GetGlobalCodeNameById(SPB.DepressionFeelingDown) ='More than half the days' then 2
			   WHEN dbo.ssf_GetGlobalCodeNameById(SPB.DepressionFeelingDown) ='Nearly every day' then 3
			   ELSE 0
			    END 
			    END AS DepressionTotalScore
		,CASE WHEN dbo.ssf_GetGlobalCodeNameById(SPB.AlcoholHowAften)='Declined to Specify' 
		AND  dbo.ssf_GetGlobalCodeNameById(SPB.AlcoholStandardDrinks)='Declined to Specify'
		AND dbo.ssf_GetGlobalCodeNameById(SPB.AlcoholOccasionDrinks)='Declined to Specify' THEN ''
		 ELSE 	    
		CASE WHEN dbo.ssf_GetGlobalCodeNameById(SPB.AlcoholHowAften)='Never' THEN 0
			  WHEN dbo.ssf_GetGlobalCodeNameById(SPB.AlcoholHowAften)='Monthly or less' THEN 1
			  WHEN dbo.ssf_GetGlobalCodeNameById(SPB.AlcoholHowAften)='2-4 times a month' THEN 2
			  WHEN dbo.ssf_GetGlobalCodeNameById(SPB.AlcoholHowAften)='2-3 times a week' THEN 3
			  WHEN dbo.ssf_GetGlobalCodeNameById(SPB.AlcoholHowAften)='4 or more times a week' THEN 4 
			  ELSE 0
			   END
		+CASE WHEN dbo.ssf_GetGlobalCodeNameById(SPB.AlcoholStandardDrinks)='1 or 2' THEN 0
			  WHEN dbo.ssf_GetGlobalCodeNameById(SPB.AlcoholStandardDrinks)='3 or 4' THEN 1
			  WHEN dbo.ssf_GetGlobalCodeNameById(SPB.AlcoholStandardDrinks)='5 or 6' THEN 2
			  WHEN dbo.ssf_GetGlobalCodeNameById(SPB.AlcoholStandardDrinks)='7 to 9' THEN 3
			  WHEN dbo.ssf_GetGlobalCodeNameById(SPB.AlcoholStandardDrinks)='10 or more' THEN 4 
			  ELSE 0
			  END
		+CASE WHEN dbo.ssf_GetGlobalCodeNameById(SPB.AlcoholOccasionDrinks)='Never' THEN 0
			  WHEN dbo.ssf_GetGlobalCodeNameById(SPB.AlcoholOccasionDrinks)='Less than monthly' THEN 1
			  WHEN dbo.ssf_GetGlobalCodeNameById(SPB.AlcoholOccasionDrinks)='Monthly' THEN 2
			  WHEN dbo.ssf_GetGlobalCodeNameById(SPB.AlcoholOccasionDrinks)='Weekly' THEN 3
			  WHEN dbo.ssf_GetGlobalCodeNameById(SPB.AlcoholOccasionDrinks)='Daily or almost daily' THEN 4 
			  ELSE 0
			  END
			END  
			  AS  AlcoholTotalScore,
			  
		CASE WHEN  dbo.ssf_GetGlobalCodeNameById(SPB.SocialConnectionMaritalStatus)='Declined to Specify' AND 
					   dbo.ssf_GetGlobalCodeNameById(SPB.SocialConnectionTalkTime)='Declined to Specify' AND
					   dbo.ssf_GetGlobalCodeNameById(SPB.SocialConnectionGetTogether)='Declined to Specify' AND 
					   dbo.ssf_GetGlobalCodeNameById(SPB.SocialConnectionReligiousServices)='Declined to Specify'  AND
					   dbo.ssf_GetGlobalCodeNameById(SPB.SocialConnectionBelongsTo)='Declined to Specify'
					   
					THEN ''
					ELSE
		CASE WHEN dbo.ssf_GetGlobalCodeNameById(SPB.SocialConnectionMaritalStatus)='Married' THEN 1
			  WHEN dbo.ssf_GetGlobalCodeNameById(SPB.SocialConnectionMaritalStatus)='Widowed' THEN 0
			  WHEN dbo.ssf_GetGlobalCodeNameById(SPB.SocialConnectionMaritalStatus)='Divorced' THEN 0
			  WHEN dbo.ssf_GetGlobalCodeNameById(SPB.SocialConnectionMaritalStatus)='Separated' THEN 0
			  WHEN dbo.ssf_GetGlobalCodeNameById(SPB.SocialConnectionMaritalStatus)='Never married' THEN 0
			   WHEN dbo.ssf_GetGlobalCodeNameById(SPB.SocialConnectionMaritalStatus)='Living with partner' THEN 1
			    WHEN dbo.ssf_GetGlobalCodeNameById(SPB.SocialConnectionMaritalStatus)='Refused' THEN 0 
			    WHEN dbo.ssf_GetGlobalCodeNameById(SPB.SocialConnectionMaritalStatus)='Don''t know' THEN 0 
			   ELSE 0
			    END
	  
	   +CASE WHEN dbo.ssf_GetGlobalCodeNameById(SPB.SocialConnectionTalkTime)='3 or more interactions per week' THEN 1
			  WHEN dbo.ssf_GetGlobalCodeNameById(SPB.SocialConnectionTalkTime)='Less than 3 interactions per week' THEN 0
			 ELSE 0
			 END
	    +CASE WHEN dbo.ssf_GetGlobalCodeNameById(SPB.SocialConnectionGetTogether)='3 or more interactions per week' THEN 1
			  WHEN dbo.ssf_GetGlobalCodeNameById(SPB.SocialConnectionGetTogether)='Less than 3 interactions per week' THEN 0
			 ELSE 0
			  END
		 +CASE WHEN dbo.ssf_GetGlobalCodeNameById(SPB.SocialConnectionReligiousServices)='More than 4 times per year' THEN 1
			  WHEN dbo.ssf_GetGlobalCodeNameById(SPB.SocialConnectionReligiousServices)='4 or less times per year' THEN 0
			 ELSE 0
			 END
		+CASE WHEN dbo.ssf_GetGlobalCodeNameById(SPB.SocialConnectionBelongsTo)='Yes' THEN 1
			  WHEN dbo.ssf_GetGlobalCodeNameById(SPB.SocialConnectionBelongsTo)='No' THEN 0
			  ELSE 0
			 END 
			 END AS SocialTotalScore,
		
		
		CASE WHEN  dbo.ssf_GetGlobalCodeNameById(SPB.ViolenceHumiliated)='Declined to Specify' AND 
					   dbo.ssf_GetGlobalCodeNameById(SPB.ViolenceAfraid)='Declined to Specify' AND
					   dbo.ssf_GetGlobalCodeNameById(SPB.ViolenceSexualActivity)='Declined to Specify' AND 
					   dbo.ssf_GetGlobalCodeNameById(SPB.ViolencePhysicallyHurt)='Declined to Specify'  					   
					THEN ''
					ELSE
		 
		CASE WHEN dbo.ssf_GetGlobalCodeNameById(SPB.ViolenceHumiliated)='Yes' THEN 1
			  WHEN dbo.ssf_GetGlobalCodeNameById(SPB.ViolenceHumiliated)='No' THEN 0
			 ELSE 0
			 END 
		+CASE WHEN dbo.ssf_GetGlobalCodeNameById(SPB.ViolenceAfraid)='Yes' THEN 1
			  WHEN dbo.ssf_GetGlobalCodeNameById(SPB.ViolenceAfraid)='No' THEN 0
			 ELSE 0
			 END
		+CASE WHEN dbo.ssf_GetGlobalCodeNameById(SPB.ViolenceSexualActivity)='Yes' THEN 1
			  WHEN dbo.ssf_GetGlobalCodeNameById(SPB.ViolenceSexualActivity)='No' THEN 0
			 ELSE 0
			 END
		+CASE WHEN dbo.ssf_GetGlobalCodeNameById(SPB.ViolencePhysicallyHurt)='Yes' THEN 1
			  WHEN dbo.ssf_GetGlobalCodeNameById(SPB.ViolencePhysicallyHurt)='No' THEN 0
			 ELSE 0
			 END
		END
			 AS ViolenceTotalScore
			 
		 FROM  Documents D
		  JOIN DocumentVersions DV ON DV.DocumentId=D.DocumentId 
		  JOIN  DocumentSocialPsychologicalAndBehaviors SPB  ON DV.DocumentVersionId=SPB.DocumentVersionId  
		  JOIN Clients C ON C.ClientId=D.ClientId   
		  JOIN DocumentCodes DC ON D.DocumentCodeId=DC.DocumentCodeId  
		  WHERE ISNull(DV.RecordDeleted,'N')='N' AND ISNull(D.RecordDeleted,'N')='N' AND ISNull(SPB.RecordDeleted,'N')='N'   
		  AND SPB.DocumentVersionId=@DocumentVersionId         
     
END TRY            
BEGIN CATCH      
	DECLARE @Error VARCHAR(8000)                            
	SET @Error= CONVERT(VARCHAR,ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000),ERROR_MESSAGE())                                                           
				+ '*****' + ISNULL(CONVERT(VARCHAR,ERROR_PROCEDURE()),'ssp_RDLDocumentSocialPsychologicalAndBehaviors')                                                           
				+ '*****' + CONVERT(VARCHAR,ERROR_LINE()) + '*****' + CONVERT(VARCHAR,ERROR_SEVERITY())                                                            
				+ '*****' + CONVERT(VARCHAR,ERROR_STATE())                                                          
	RAISERROR                                                           
	(                                                          
		@Error, -- Message text.                                                          
		16, -- Severity.                                                          
		1 -- State.                                                          
	);                                                          
END CATCH
END
GO


