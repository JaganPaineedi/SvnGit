/****** Object:  StoredProcedure [dbo].[csp_RdlCustomSubstanceUseAssessments]    Script Date: 06/19/2013 17:49:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RdlCustomSubstanceUseAssessments]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RdlCustomSubstanceUseAssessments]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RdlCustomSubstanceUseAssessments]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[csp_RdlCustomSubstanceUseAssessments]      
--@DocumentId int,             
--@Version int            
@DocumentVersionId  int --Modified by Anuj Dated 03-May-2010   
 AS             
Begin      
/*            
** Object Name:  [csp_RdlCustomSubstanceUseAssessments]            
**            
**            
** Notes:  Accepts two parameters (DocumentId & Version) and returns a record set             
**    which matches those parameters.             
**            
** Programmers Log:            
** Date  Programmer  Description            
**------------------------------------------------------------------------------------------            
** Get Data From  CustomSubstanceUseAssessments         
** Oct 12 2007 Ranjeetb              
*/            
  
   SELECT 
      [VoluntaryAbstinenceTrial]
      ,[Comment]
      ,[HistoryOrCurrentDUI]
      ,[NumberOfTimesDUI]
      ,[HistoryOrCurrentDWI]
      ,[NumberOfTimesDWI]
      ,[HistoryOrCurrentMIP]
      ,[NumberOfTimeMIP]
      ,[HistoryOrCurrentBlackOuts]
      ,[NumberOfTimesBlackOut]
      ,[HistoryOrCurrentDomesticAbuse]
      ,[NumberOfTimesDomesticAbuse]
      ,[LossOfControl]
      ,[IncreasedTolerance]
      ,[OtherConsequence]
      ,[OtherConsequenceDescription]
      ,[RiskOfRelapse]
      ,[PreviousTreatment]
      ,[CurrentSubstanceAbuseTreatment]
      ,[CurrentTreatmentProvider]
      ,[CurrentSubstanceAbuseReferralToSAorTx]
      ,[CurrentSubstanceAbuseRefferedReason]
      ,[ToxicologyResults]
      ,[ClientSAHistory]
      ,[FamilySAHistory]
      ,[NoSubstanceAbuseSuspected]
      ,[CurrentSubstanceAbuse]
      ,[SuspectedSubstanceAbuse]
      ,[SubstanceAbuseDetail]
      ,[SubstanceAbuseTxPlan]
      ,[OdorOfSubstance]
      ,[SlurredSpeech]
      ,[WithdrawalSymptoms]
      ,[DTOther]
      ,[DTOtherText]
      ,[Blackouts]
      ,[RelatedArrests]
      ,[RelatedSocialProblems]
      ,[FrequentJobSchoolAbsence]
      ,[NoneSynptomsReportedOrObserved]
      
  FROM [CustomSubstanceUseAssessments] where ISNull(RecordDeleted,''N'')=''N'' 
--and DocumentId=@DocumentID and Version=@Version   
 and DocumentVersionId=@DocumentVersionId   --Modified by Anuj Dated 03-May-2010  
       
  
    --Checking For Errors              
  If (@@error!=0)              
  Begin              
   RAISERROR  20006   ''csp_RdlCustomSubstanceUseAssessments : An Error Occured''               
   Return              
   End              
       
            
  
End
' 
END
GO
