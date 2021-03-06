/****** Object:  StoredProcedure [dbo].[csp_SCGetCustomPsychAssessment]    Script Date: 06/19/2013 17:49:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetCustomPsychAssessment]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCGetCustomPsychAssessment]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetCustomPsychAssessment]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*********************************************************************/                        
/*
	Stored Procedure: dbo.csp_SCGetCustomPsychAssessment                             
	Copyright: 2006 Streamline SmartCare                        
	Creation Date: 25-07-07                                                      
	Purpose: Gets Data for CustomBasis32                        
	Input Parameters: DocumentID,Version                    
	Output Parameters:                                                        
	Return:                           
	Called By: getPharmacies() Method in MSDE Class Of DataService  in "Always Online Application"                
	Calls:                                                                                    
	Data Modifications:                                                                       
	Updates:                                                                                  
	Date              Author                  Purpose                                                            
	25-07-07           Rajinder Singh    To Retrieve Data                                            
	15-Sep-2009  Ankesh Bharti       Made changes as per dataModel Venture3.0       
	28 Sept 2009  Pradeep      deleted selection from SystemConfigurations as it is not in use              
	03/04/2010 Vikas Monga               
    Remove [Documents] and [DocumentVersions]                               
 */
/*********************************************************************/                         
CREATE PROCEDURE  [dbo].[csp_SCGetCustomPsychAssessment]           
  @DocumentVersionId int              
AS              
BEGIN                            
  BEGIN TRY            
   --For CustomPersonalCareAssessment Table                                                               
	SELECT     DocumentVersionId, Type, PrimaryClinician, CurrentDiagnosis, IdentifyingInformation, MedType1, MedDosage1, MedPurpose1, MedPhysician1, MedType2, 
					  MedDosage2, MedPurpose2, MedPhysician2, MedType3, MedDosage3, MedPurpose3, MedPhysician3, MedType4, MedDosage4, MedPurpose4, MedPhysician4, 
					  MedType5, MedDosage5, MedPurpose5, MedPhysician5, MedType6, MedDosage6, MedPurpose6, MedPhysician6, MedType7, MedDosage7, MedPurpose7, 
					  MedPhysician7, MedType8, MedDosage8, MedPurpose8, MedPhysician8, MedType9, MedDosage9, MedPurpose9, MedPhysician9, BackgroundInformation, 
					  ReasonForAssessment, ChallengingBehaviors, BehavioralHistory, ReinforcerAssessment, ObservationsMentalStatus, EvaluationCriteria, TestResults, 
					  ClinicalImpressions, Recommendations, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, RecordDeleted, DeletedDate, DeletedBy
	FROM         CustomPsychAssessment
	WHERE     (ISNULL(RecordDeleted, ''N'') = ''N'') AND (DocumentVersionId = @DocumentVersionId)      
 END TRY                            
 BEGIN CATCH                            
  DECLARE @Error varchar(8000)                                                               
  SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                              
  + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''[ssp_SCGetCustomPsychAssessment]'')                                                               
  + ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****ERROR_SEVERITY='' + Convert(varchar,ERROR_SEVERITY())                                                              
  + ''*****ERROR_STATE='' + Convert(varchar,ERROR_STATE())                                                              
  RAISERROR ( @Error, /* Message text.*/16, /* Severity.*/ 1 /*State.*/ );                                                  
 END CATCH                                          
End
' 
END
GO
