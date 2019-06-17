/****** Object:  StoredProcedure [dbo].[ssp_SCGetDocumentSocialPsychologicalAndBehaviors]    ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetDocumentSocialPsychologicalAndBehaviors]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetDocumentSocialPsychologicalAndBehaviors]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetDocumentSocialPsychologicalAndBehaviors]    ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
/******************************************************************************                                                                          
**  Name: ssp_SCGetDocumentSocialPsychologicalAndBehaviors                        
**  Desc: GetData for Social, Psychological, and Behaviors                         
**  Auth:  Vijay                              
**  Date:  Jul 05 2017
*******************************************************************************                                                
**  Change History                                          
*******************************************************************************                                          
**  Date:       Author:       Description:                                    
*******************************************************************************/                                    
CREATE PROCEDURE  [dbo].[ssp_SCGetDocumentSocialPsychologicalAndBehaviors]                                                                   
(                                                                                                                                                           
  @DocumentVersionId int                                                                           
)                                                                              
As                                                                          
BEGIN                                                            
   BEGIN TRY    
   
   --DECLARE @ClientID INT 

   --   SET @ClientID = (SELECT ClientId 
   --                    FROM   Documents 
   --                    WHERE  InProgressDocumentVersionId = @DocumentVersionId)    
                       
     ---DocumentSocialPsychologicalAndBehaviors----                                   
		SELECT DocumentVersionId
			,CreatedBy
			,CreatedDate
			,ModifiedBy
			,ModifiedDate
			,RecordDeleted
			,DeletedBy
			,DeletedDate
			,FinancialResourceStrain
			,FinancialResourceStrainDetails
			,Education
			,EducationDetails
			,Stress
			,StressDetails
			,DepressionLittleInterest
			,DepressionFeelingDown
			,DepressionDetails
			,PhysicalActivityBriskWalk
			,PhysicalActivityExerciseMinutes
			,PhysicalActivityDeclineToSpecify
			,PhysicalActivityDetails
			,AlcoholHowAften
			,AlcoholStandardDrinks
			,AlcoholOccasionDrinks
			,AlcoholDetails
			,SocialConnectionMaritalStatus
			,SocialConnectionTalkTime
			,SocialConnectionGetTogether
			,SocialConnectionReligiousServices
			,SocialConnectionBelongsTo
			,SocialConnectionDetails
			,ViolenceHumiliated
			,ViolenceAfraid
			,ViolenceSexualActivity
			,ViolencePhysicallyHurt
			,ViolenceDetails
		FROM DocumentSocialPsychologicalAndBehaviors
		WHERE (ISNULL(RecordDeleted, 'N') = 'N')
			AND (DocumentVersionId = @DocumentVersionId) 
			
 END TRY                                        
                                                           
 BEGIN CATCH                                                            
   DECLARE @Error varchar(8000)                                                                                               
   SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                              
   + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'[ssp_SCGetDocumentSocialPsychologicalAndBehaviors]')                                                                                               
   + '*****' + Convert(varchar,ERROR_LINE()) + '*****ERROR_SEVERITY=' + Convert(varchar,ERROR_SEVERITY())                                                                                              
   + '*****ERROR_STATE=' + Convert(varchar,ERROR_STATE())                                                                                              
   RAISERROR (@Error /* Message text*/,  16 /*Severity*/,   1/*State*/   )                                                            
 END CATCH                                          
End 

GO


