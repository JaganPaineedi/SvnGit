/****** Object:  StoredProcedure [dbo].[csp_InitCustomPsychAssessmentStandardInitialization]    Script Date: 06/19/2013 17:49:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomPsychAssessmentStandardInitialization]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_InitCustomPsychAssessmentStandardInitialization]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomPsychAssessmentStandardInitialization]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE  [dbo].[csp_InitCustomPsychAssessmentStandardInitialization]            
(                          
 @ClientID int,    
 @StaffID int,  
 @CustomParameters xml                          
)                                                  
As                     
                                                           
 /*********************************************************************/                                                              
 /* Stored Procedure: [csp_InitCustomPsychAssessmentStandardInitialization]               */                                                     
                                                     
 /* Copyright: 2006 Streamline SmartCare*/                                                              
                                                     
 /* Creation Date:  14/Jan/2008                                    */                                                              
 /*                                                                   */                                                              
 /* Purpose: To Initialize */                                                             
 /*                                                                   */                                                            
 /* Input Parameters:  */                                                            
 /*                                                                   */                                                               
 /* Output Parameters:                                */                                                              
 /*                                                                   */                                                              
 /* Return:   */                                                              
 /*                                                                   */                                                              
 /* Called By:CustomDocuments Class Of DataService    */                                                    
 /*      */                                                    
                                                     
 /*                                                                   */                                                              
 /* Calls:                                                            */                                                              
 /*                                                                   */                                                              
 /* Data Modifications:                                               */                                                              
 /*                                                                   */                                                              
 /*   Updates:                                                          */                                                              
                                                     
 /*       Date              Author                  Purpose                                    */                                                              
 /*       14/Jan/2008        Rishu Chopra          To Retrieve Data      */      
 /*       Nov18,2009         Ankesh                Made changes as paer dataModel SCWebVenture3.0  */     
 /*       July 15,2010       Mahesh S              These columns are removed as they add blank / white space values on table - 15 July 2010*/                                                                                                                                                     
 /*********************************************************************/
                  
                                                                              
Begin                                              
    
Begin try
	if exists(Select 1 from CustomPsychAssessment C
				Join DocumentVersions dv on dv.DocumentVersionId=c.DocumentVersionId and ISNULL(dv.RecordDeleted,''N'')=''N''   
				Join Documents d on d.DocumentId=dv.DocumentId and ISNULL(d.RecordDeleted,''N'')=''N''
				Where d.ClientId=@ClientID                                  
				and D.Status=22 and IsNull(C.RecordDeleted,''N'')=''N'' 
				)                              
BEGIN                   
            
                    
	SELECT     TOP (1) ''CustomPsychAssessment'' AS TableName, C.DocumentVersionId, D.DocumentId, C.Type, C.PrimaryClinician, C.CurrentDiagnosis, C.IdentifyingInformation, 
						  C.MedType1, C.MedDosage1, C.MedPurpose1, C.MedPhysician1, C.MedType2, C.MedDosage2, C.MedPurpose2, C.MedPhysician2, C.MedType3, C.MedDosage3, 
						  C.MedPurpose3, C.MedPhysician3, C.MedType4, C.MedDosage4, C.MedPurpose4, C.MedPhysician4, C.MedType5, C.MedDosage5, C.MedPurpose5, 
						  C.MedPhysician5, C.MedType6, C.MedDosage6, C.MedPurpose6, C.MedPhysician6, C.MedType7, C.MedDosage7, C.MedPurpose7, C.MedPhysician7, C.MedType8, 
						  C.MedDosage8, C.MedPurpose8, C.MedPhysician8, C.MedType9, C.MedDosage9, C.MedPurpose9, C.MedPhysician9, C.BackgroundInformation, 
						  C.ReasonForAssessment, C.ChallengingBehaviors, C.BehavioralHistory, C.ReinforcerAssessment, C.ObservationsMentalStatus, C.EvaluationCriteria, C.TestResults, 
						  C.ClinicalImpressions, C.Recommendations, C.CreatedBy, C.CreatedDate, C.ModifiedBy, C.ModifiedDate
	FROM         DocumentVersions AS V INNER JOIN
						  Documents AS D ON V.DocumentId = D.DocumentId INNER JOIN
						  CustomPsychAssessment AS C ON V.DocumentVersionId = C.DocumentVersionId AND D.CurrentDocumentVersionId = C.DocumentVersionId
	WHERE     (D.ClientId = @ClientID) AND (D.Status = 22) AND (ISNULL(C.RecordDeleted, ''N'') = ''N'') AND (ISNULL(D.RecordDeleted, ''N'') = ''N'')
	ORDER BY D.EffectiveDate DESC    ,V.DocumentVersionId DESC                      
END                              
else                              
BEGIN
--sp_help CustomPsychAssessment 
-- select * from screens where screenname like''%Entrance%''                             
Select TOP 1 ''CustomPsychAssessment'' AS TableName
,-1 as ''DocumentVersionId''                  
              
               
--Custom data              
,''AS'' as [Type]    
/*
These columns are removed as they add blank / white space values on table - 15 July 2010
,'''' as PrimaryClinician    
,'''' as CurrentDiagnosis    
,'''' as IdentifyingInformation    
,'''' as MedType1    
,'''' as MedDosage1    
,'''' as MedPurpose1    
,'''' as MedPhysician1    
,'''' as MedType2    
,'''' as MedDosage2    
,'''' as MedPurpose2    
,'''' as MedPhysician2    
,'''' as MedType3    
,'''' as MedDosage3    
,'''' as MedPurpose3    
,'''' as MedPhysician3    
,'''' as MedType4    
,'''' as MedDosage4    
,'''' as MedPurpose4    
,'''' as MedPhysician4    
,'''' as MedType5    
,'''' as MedDosage5    
,'''' as MedPurpose5    
,'''' as MedPhysician5    
,'''' as MedType6    
,'''' as MedDosage6    
,'''' as MedPurpose6    
,'''' as MedPhysician6    
,'''' as MedType7    
,'''' as MedDosage7    
,'''' as MedPurpose7    
,'''' as MedPhysician7    
,'''' as MedType8    
,'''' as MedDosage8    
,'''' as MedPurpose8    
,'''' as MedPhysician8    
,'''' as MedType9    
,'''' as MedDosage9    
,'''' as MedPurpose9    
,'''' as MedPhysician9    
,'''' as BackgroundInformation    
,'''' as ReasonForAssessment    
,'''' as ChallengingBehaviors    
,'''' as BehavioralHistory    
,'''' as ReinforcerAssessment    
,'''' as ObservationsMentalStatus    
,'''' as EvaluationCriteria    
,'''' as TestResults    
,'''' as ClinicalImpressions    
,'''' as Recommendations   
*/ 
--Custom Data              
       
,'''' as CreatedBy,                
getdate() as CreatedDate,                
'''' as ModifiedBy,                
getdate() as ModifiedDate                  
from systemconfigurations s left outer join CustomPsychAssessment                                                                    
on s.Databaseversion = -1    
                    
END                            
end try                                              
                                                                                       
BEGIN CATCH  
DECLARE @Error varchar(8000)                                               
SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                                             
    + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_InitCustomPsychAssessmentStandardInitialization'')                                                                             
    + ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****'' + Convert(varchar,ERROR_SEVERITY())                                                                              
    + ''*****'' + Convert(varchar,ERROR_STATE())                          
 RAISERROR                                                                             
 (                                               
  @Error, -- Message text.                                                                            
  16, -- Severity.                                                                            
  1 -- State.                                                                            
 );                                                                          
END CATCH                         
END
' 
END
GO
