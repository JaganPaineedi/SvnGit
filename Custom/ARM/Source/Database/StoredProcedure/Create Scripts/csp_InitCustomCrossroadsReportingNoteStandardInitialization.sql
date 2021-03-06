/****** Object:  StoredProcedure [dbo].[csp_InitCustomCrossroadsReportingNoteStandardInitialization]    Script Date: 06/19/2013 17:49:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomCrossroadsReportingNoteStandardInitialization]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_InitCustomCrossroadsReportingNoteStandardInitialization]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomCrossroadsReportingNoteStandardInitialization]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE  [dbo].[csp_InitCustomCrossroadsReportingNoteStandardInitialization]      
(                                        
 @ClientID int,        
 @StaffID int,      
 @CustomParameters xml                                       
)                                                                  
As                                                                    
 /*********************************************************************/                                                                              
 /* Stored Procedure: csp_InitCustomCrossroadsReportingNoteStandardInitialization               */      
                                                                     
 /* Creation Date:  12/April/2010                                    */                                                                              
 /*                                                                   */                                                                              
 /* Purpose: Gets Fields of CustomCrossroadsReportingNote last signed Document Corresponding to clientd */                                                                             
 /*                                                                   */                                                                            
 /* Input Parameters:  */                                                                            
 /*                                                                   */                                                                               
 /* Output Parameters:                                */                                                                              
 /*                                                                   */                                                                              
 /* Return:   */                                                                              
 /*                                                                   */                                                                              
 /* Called By:CustomDocuments Class Of DataService    */                                                                    
 /*                                                                   */                                                                              
 /* Calls:                                                            */                                                                              
 /*                                                                   */                                                                              
 /* Data Modifications:                                               */                                                                              
 /*                                                                   */                                                                              
 /*   Updates:                                                          */                                                                              
                                                                     
 /*       Date                Author                  Purpose                                    */                                                                              
 /***********************************************************************************************/         
Begin                          
          
Begin try      
 
                                                                              
if exists(Select 1 from CustomCrossroadsReportingNote C
			Join DocumentVersions dv on c.DocumentVersionId=dv.DocumentVersionId and ISNULL(dv.RecordDeleted,''N'')=''N''
			JOin Documents d on d.DocumentId=dv.DocumentId and IsNull(D.RecordDeleted,''N'')=''N''                         
			where d.ClientId=@ClientID                 
			and D.Status=22 and IsNull(C.RecordDeleted,''N'')=''N''
			)                            
	BEGIN               
		        
		Select TOP 1 ''CustomCrossroadsReportingNote'' AS TableName,  
			   C.DocumentVersionId                
			  ,[NumberOfServices]
			  ,[AssessmentDate]
			  ,[NextTxPlanDate]
			  ,[TxPlanDetails]
			  ,[ParticipationMorning]
			  ,[ParticipationClerical]
			  ,[ParticipationSnack]
			  ,[ParticipationFood]
			  ,[ParticipationMaintenance]
			  ,[ParticipationThrift]
			  ,[ParticipationComputer]
			  ,[ParticipationProfiting]
			  ,[ParticipationClub]
			  ,[MemberEntitlement]
			  ,[MemberWRAP]
			  ,[MemberPCP]
			  ,[MemberOutreach]
			  ,[MemberHousing]
			  ,[MemberFood]
			  ,[MemberClothing]
			  ,[MemberAdvocacy]
			  ,[MemberPeer]
			  ,[MemberSelf]
			  ,[MemberFamily]
			  ,[MemberFundraising]
			  ,[SocialSocialization]
			  ,[SocialPlanning]
			  ,[SocialOrganizing]
			  ,[SocialOpportunities]
			  ,[SocialParticipation]
			  ,[VocationalPsychoEd]
			  ,[VocationalAttention]
			  ,[VocationalInitiation]
			  ,[VocationalComprehension]
			  ,[VocationalVerbal]
			  ,[VocationalIntrepersonal]
			  ,[VocationalCommunication]
			  ,[VocationalPaperwork]
			  ,[VocationalAttendance]
			  ,[VocationalLearning]
			  ,[VocationalEmpathy]
			  ,[EmploymentDevelopment]
			  ,[EmploymentTransitional]
			  ,[EmploymentSupported]
			  ,[EmploymentOutreach]
			  ,[EmploymentTraining]
			  ,[VolunteerCommunity]
			  ,[EducationalInitiation]
			  ,[EducationalGED]
			  ,[EducationalCollege]
			  ,[CommunitySelf]
			  ,[CommunityCooking]
			  ,[CommunityMoney]
			  ,[CommunityPersonal]
			  ,[CommunityMaintenance]
			  ,[InterpersonalSocial]
			  ,[InterpersonalAssertiveness]
			  ,[InterpersonalSelfAware]
			  ,[InterpersonalConversational]
			  ,[InterpersonalSelfImage]
			  ,[InterpersonalFeelings]
			  ,[InterpersonalRelationships]
			  ,[LeadershipSpeaking]
			  ,[LeadershipOnSiteCommittee]
			  ,[LeadershipOffSiteCommittee]
			  ,[LeadershipEmployability]
			  ,[LeadershipPolicy]
			  ,[PersonalDeveloping]
			  ,[PersonalTimeManagement]
			  ,[PersonalCoping]
			  ,[EnvironmentalNaturalSupports]
			  ,[EnvironmentalResources]
			  ,[EnvironmentalOrientation]
			  ,[HealthLifestyle]
			  ,[HealthNeeds]
			  ,[SymptomSituations]
			  ,[SymptomCrisis]
			  ,[SymptomMedication]
			  ,[SymptomSU]
			  ,[ClientStatisfaction]
			  ,[OnSiteHealthIssues]
			  ,[AssistanceEncouragement]
			  ,[AssistanceOrientation]
			  ,[AssistanceDirection]
			  ,[AssistanceDecision]
			  ,[AssistanceCompetency]
			  ,[AssistanceInterpersonal]
			  ,[AssistanceVocational]
			  ,[AssistanceSupport]
			  ,[AssistanceSocailization]
			  ,[AssistanceHealth]
			  ,[AssistanceOperations]
			  ,[NotedChangesRecomendations]
		,C.CreatedBy,C.CreatedDate,C.ModifiedBy,C.ModifiedDate                
		from CustomCrossroadsReportingNote C
		Join DocumentVersions dv on c.DocumentVersionId=dv.DocumentVersionId and ISNULL(dv.RecordDeleted,''N'')=''N''
		Join Documents d on d.DocumentId=dv.DocumentId and IsNull(d.RecordDeleted,''N'')=''N''
		where d.ClientId=@ClientID                                
		and d.Status=22 and IsNull(C.RecordDeleted,''N'')=''N''                               
		order by d.EffectiveDate Desc,d.ModifiedDate Desc  ,dv.DocumentVersionId DESC          
	                        
	END                            

ELSE       
                   
	BEGIN    
	                          
		Select TOP 1 ''CustomCrossroadsReportingNote'' AS TableName
		, -1 as ''DocumentVersionId''
		--Find Crossroad services for the past month
		, isnull((Select count(s.ServiceId) from Services s
					where isnull(s.RecordDeleted,''N'')=''N'' and s.ClientId=@ClientId 
					and s.Status in (75,71,70) 
					and (s.ProgramId in (25) OR s.ProcedureCodeId in (29))
					and s.DateOfService between dateadd(MM,-1,getdate()) and getdate()
					),0) as NumberOfServices
		--Get Assessment Date
		, isnull((Select Top 1 d.EffectiveDate from Documents d 
					where isnull(d.RecordDeleted,''N'')=''N''
					and d.Status=22 and d.ClientId=@ClientId
					and d.DocumentCodeId in (101,110,354,349,1469)
					order by d.EffectiveDate Desc
					),NULL) as AssessmentDate
		--Get Next TX Plan Due Date
		, isnull((Select dateAdd(yy,1,d.EffectiveDate) from Documents d 
					where isnull(d.RecordDeleted,''N'')=''N''
					and d.Status=22 and d.ClientId=@ClientId
					and d.DocumentCodeId in (2,350)
					and not exists (Select 1 from documents as d2
									where d2.ClientId = d.ClientId
									and ( d2.EffectiveDate > d.EffectiveDate
										or (d2.EffectiveDate = d.EffectiveDate and d2.DocumentId > d.DocumentId)
										)
									and isnull(d2.RecordDeleted,''N'')=''N'' 
									and d2.status=22
									and d2.DocumentCodeId in (2,350)
									)
					),GETDATE()) as NextTxPlanDate
		--Get Tx Plan Details associated with Crossroads
		, isnull((Select top 1 cast(''Need: '' 
									+convert(varchar(max),n.NeedText)
									+char(13)+char(10)
									+''Goal: ''
									+convert(varchar(max),n.GoalText)as text) 
					From Documents d 
					join TPNeeds n on n.DocumentVersionId=d.CurrentDocumentVersionId
					and d.DocumentCodeId in (2,350)
					and isnull(n.RecordDeleted,''N'')=''N'' 
					where isnull(n.GoalHealthSafety,''N'')=''Y''
					and isnull(n.GoalActive,''N'')=''Y'' 
					and isnull(d.RecordDeleted,''N'')=''N''
					and d.Status=22 and d.ClientId=@ClientId 
					and not exists (Select 1 From Documents as d2
									where d2.ClientId = d.ClientId 
									and ( d2.EffectiveDate > d.EffectiveDate
										or (d2.EffectiveDate = d.EffectiveDate and d2.DocumentId > d.DocumentId)
										)
									and isnull(d2.RecordDeleted,''N'')=''N'' 
									and d2.status=22
									and d2.DocumentCodeId in (2,350)
									) 
					order by d.EffectiveDate desc
					), ''No Data Available'') as TxPlanDetails   
		,'''' as CreatedBy        
		,getdate() as CreatedDate        
		,'''' as ModifiedBy        
		,getdate() ModifiedDate                    
		from systemconfigurations s left outer join CustomCrossroadsReportingNote        
		on s.Databaseversion = -1     
		 
	END          
	     
	--BEGIN    
	                          
	--Select TOP 1 ''CustomCrossroadsReportingNote'' AS TableName
	--, -1 as ''DocumentVersionId''
	--, 10 as NumberOfServices
	--, GETDATE() as AssessmentDate
	--, GETDATE() as NextTxPlanDate
	--, ''TxPlanDetails'' as TxPlanDetails 
	--,'''' as CreatedBy        
	--,getdate() as CreatedDate        
	--,'''' as ModifiedBy        
	--,getdate() ModifiedDate                    
	--from systemconfigurations s left outer join CustomCrossroadsReportingNote        
	--on s.Databaseversion = -1      
	--END  

              
end try                                                    
   
BEGIN CATCH        
DECLARE @Error varchar(8000)                                                     
SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                   
    + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_InitCustomCrossroadsReportingNoteStandardInitialization'')                                                                                   
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
