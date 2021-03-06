/****** Object:  StoredProcedure [dbo].[csp_RDLCustomPsychiatricEvaluations]    Script Date: 06/19/2013 17:49:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomPsychiatricEvaluations]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLCustomPsychiatricEvaluations]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomPsychiatricEvaluations]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE  [dbo].[csp_RDLCustomPsychiatricEvaluations]                         
(                            
--@DocumentId int,             
--@Version int            
@DocumentVersionId  int --Modified by Anuj Dated 03-May-2010                            
)                            
As                            
                                    
Begin                                    
/************************************************************************/                                      
/* Stored Procedure: csp_RDLCustomPsychiatricEvaluations				*/                                                         
/* Copyright: 2006 Streamline SmartCare									*/                                                                  
/* Creation Date:  Oct 26 ,2007											*/                                      
/*																		*/                                      
/* Purpose: Gets Data for CrisisInterventions							*/                                     
/*																		*/                                    
/* Input Parameters: DocumentID,Version									*/                                    
/*																		*/                                       
/* Output Parameters:													*/                                      
/* Purpose Use For Rdl Report											*/                            
/* Calls:																*/                                      
/*																		*/                                      
/* Author: Rishu Chopra													*/                                      
/* Modified by: Rupali Patil											*/                                      
/* Modified date: 6/5/2008                                              */                                      
/* Modified: Added ClientID to the select list                          */         
/* Modified by: avoss											*/                                      
/* Modified date: 7/22/2008                                              */                                      
/* Modified: corrected join                           */                               
/************************************************************************/                   
DECLARE @StandardPatientInstructions varchar(max)

SET @StandardPatientInstructions=''• If you experience a psychiatric or medical emergency, call 911.

• If thoughts of harming yourself or someone else occur:
       o Call 911
       o Call Rescue Crisis – 24 hours/day 7 days/week at 419-255-9585
       o Call the National Suicide Prevention Hotline at 1-800-273-TALK (8255)
       o Call Harbor after hours at 419-475-4449
       o Seek help at the nearest emergency room

• Take all medications as prescribed. Should you have questions or concerns regarding your medication, or if you experience side effects to your medication, call the Harbor location where you see your prescriber.

• If you need refills before your next appointment, contact the Harbor location at which you attend at least 5 days before running out of medications.

• Obtain all medical tests including lab work if ordered by your prescriber.

• Pay special attention to instructions for your particular medications, such as whether to take with food, if you should take special precautions in the sunlight, etc.

• Do not take any prescription medications that are not prescribed to you by your provider(s). 

• Do not give your prescription medication to others.

• Make sure that at every appointment you let the medical staff know of any changes in your medication, herbs and supplements including those provided by prescribers not at Harbor.
''

SELECT	d.ClientID
		,IdentifyingData
		,ChiefComplaint
		,HistoryofPresentIllness
		,PastPsychiatricHistory
		,MedicalHistory
		,SocialHistory
		,MentalStatusExam
		,Prognosis
		,OtherTherapyInterventionsPlanned1
		,OtherTherapyInterventionsPlanned2
		,MedicationCompliance
		,OtherConcernsNotAddressed
		,OtherIndividuals
		,PlanReviewFrequency
		,@StandardPatientInstructions as StandardPatientInstructions
FROM  Documents d
Join DocumentVersions dv on dv.DocumentId=d.DocumentId and isnull(dv.RecordDeleted,''N'')=''N''
--left JOIN CustomPsychiatricEvaluations CPE on CPE.DocumentID = d.DocumentID 
--	and CPE.Version = @Version    
left JOIN CustomPsychiatricEvaluations CPE on CPE.DocumentVersionId = d.CurrentDocumentVersionId   --Modified by Anuj Dated 03-May-2010
where ISNull(CPE.RecordDeleted,''N'') = ''N'' 
--and d.Documentid = @DocumentId 
and dv.DocumentVersionId = @DocumentVersionId  --Modified by Anuj Dated 03-May-2010
and ISNull(d.RecordDeleted,''N'') = ''N'' 
         
          
                            
--Checking For Errors                            
If (@@error!=0)                            
	Begin                            
		RAISERROR  20006   ''csp_RDLCustomPsychiatricEvaluations : An Error Occured''                             
		Return                            
	End
End

' 
END
GO
