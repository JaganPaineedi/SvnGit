/****** Object:  StoredProcedure [dbo].[csp_ViewModeCustomCrossroadsReportingNote]    Script Date: 06/19/2013 17:49:53 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ViewModeCustomCrossroadsReportingNote]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ViewModeCustomCrossroadsReportingNote]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ViewModeCustomCrossroadsReportingNote]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[csp_ViewModeCustomCrossroadsReportingNote]
(
@DocumentVersionId INT
--@DocumentId int,
--@Version int
)
AS
/*
** Object Name:		[csp_ViewModeCustomCrossroadsReportingNote]
**
**
** Notes:		Accepts two parameters (DocumentId & Version) and returns a record set 
**				which matches those parameters. 
**
** Programmers Log:
** Date		Programmer		Description
**------------------------------------------------------------------------------------------
** 17/08/2007	ETECH			Procedure Created.
** 8/31/2007	avoss		modified
** 28/06/2008	RPATIL			Added OrganizationName to the select list
** 09/14/2010	dharvey		modified to accept @DocumentVersionId parameter
*/


    -- Insert statements for procedure here
SELECT	(select organizationName from SystemConfigurations) as OrganizationName
		,cc.DocumentVersionId
		,Clients.Lastname +'', ''+ Clients.Firstname as Full_Name
		,Documents.clientid
		,S.LastName + '', '' + S.FirstName as ''ClinicianName''
		,Documents.EffectiveDate
		,NumberOfServices
		,AssessmentDate
		,NextTxPlanDate
		,TxPlanDetails
		,ParticipationMorning
		,ParticipationClerical
		,ParticipationSnack
		,ParticipationFood
		,ParticipationMaintenance
		,ParticipationThrift
		,ParticipationComputer
		,ParticipationProfiting
		,ParticipationClub
		,MemberEntitlement
		,MemberWRAP
		,MemberPCP
		,MemberOutreach
		,MemberHousing
		,MemberFood
		,MemberClothing
		,MemberAdvocacy
		,MemberPeer
		,MemberSelf
		,MemberFamily
		,MemberFundraising
		,SocialSocialization
		,SocialPlanning
		,SocialOrganizing
		,SocialOpportunities
		,SocialParticipation
		,VocationalPsychoEd
		,VocationalAttention
		,VocationalInitiation
		,VocationalComprehension
		,VocationalVerbal
		,VocationalIntrepersonal
		,VocationalCommunication
		,VocationalPaperwork
		,VocationalAttendance
		,VocationalLearning
		,VocationalEmpathy
		,EmploymentDevelopment
		,EmploymentTransitional
		,EmploymentSupported
		,EmploymentOutreach
		,EmploymentTraining
		,VolunteerCommunity
		,EducationalInitiation
		,EducationalGED
		,EducationalCollege
		,CommunitySelf
		,CommunityCooking
		,CommunityMoney
		,CommunityPersonal
		,CommunityMaintenance
		,InterpersonalSocial
		,InterpersonalAssertiveness
		,InterpersonalSelfAware
		,InterpersonalConversational
		,InterpersonalSelfImage
		,InterpersonalFeelings
		,InterpersonalRelationships
		,LeadershipSpeaking
		,LeadershipOnSiteCommittee
		,LeadershipOffSiteCommittee
		,LeadershipEmployability
		,LeadershipPolicy
		,PersonalDeveloping
		,PersonalTimeManagement
		,PersonalCoping
		,EnvironmentalNaturalSupports	
		,EnvironmentalResources
		,EnvironmentalOrientation
		,HealthLifestyle
		,HealthNeeds
		,SymptomSituations	
		,SymptomCrisis
		,SymptomMedication
		,SymptomSU
		,ClientStatisfaction
		,OnSiteHealthIssues
		,AssistanceEncouragement
		,AssistanceOrientation
		,AssistanceDirection
		,AssistanceDecision
		,AssistanceCompetency
		,AssistanceInterpersonal
		,AssistanceVocational
		,AssistanceSupport
		,AssistanceSocailization
		,AssistanceHealth
		,AssistanceOperations
		,NotedChangesRecomendations
		,Comments
From CustomCrossroadsReportingNote CC
INNER JOIN Documents ON CC.DocumentVersionId = Documents.CurrentDocumentVersionId
Left Join Staff S On Documents.AuthorId = S.StaffId AND isnull(Documents.RecordDeleted,''N'')<>''Y'' 
INNER JOIN Staff ON Staff.Staffid = Documents.AuthorId AND isnull(Staff.RecordDeleted,''N'')<>''Y'' 
INNER JOIN Clients ON Clients.Clientid = Documents.Clientid AND isnull(Clients.RecordDeleted,''N'')<>''Y''
where CC.DocumentVersionId = @DocumentVersionId
AND isnull(CC.RecordDeleted,''N'')<>''Y''



/*
    -- Insert statements for procedure here
SELECT	(select organizationName from SystemConfigurations) as OrganizationName
		,cc.DocumentId
		,cc.Version
		,Clients.Lastname +'', ''+ Clients.Firstname as Full_Name
		,Documents.clientid
		,S.LastName + '', '' + S.FirstName as ''ClinicianName''
		,Documents.EffectiveDate
		,NumberOfServices
		,AssessmentDate
		,NextTxPlanDate
		,TxPlanDetails
		,ParticipationMorning
		,ParticipationClerical
		,ParticipationSnack
		,ParticipationFood
		,ParticipationMaintenance
		,ParticipationThrift
		,ParticipationComputer
		,ParticipationProfiting
		,ParticipationClub
		,MemberEntitlement
		,MemberWRAP
		,MemberPCP
		,MemberOutreach
		,MemberHousing
		,MemberFood
		,MemberClothing
		,MemberAdvocacy
		,MemberPeer
		,MemberSelf
		,MemberFamily
		,MemberFundraising
		,SocialSocialization
		,SocialPlanning
		,SocialOrganizing
		,SocialOpportunities
		,SocialParticipation
		,VocationalPsychoEd
		,VocationalAttention
		,VocationalInitiation
		,VocationalComprehension
		,VocationalVerbal
		,VocationalIntrepersonal
		,VocationalCommunication
		,VocationalPaperwork
		,VocationalAttendance
		,VocationalLearning
		,VocationalEmpathy
		,EmploymentDevelopment
		,EmploymentTransitional
		,EmploymentSupported
		,EmploymentOutreach
		,EmploymentTraining
		,VolunteerCommunity
		,EducationalInitiation
		,EducationalGED
		,EducationalCollege
		,CommunitySelf
		,CommunityCooking
		,CommunityMoney
		,CommunityPersonal
		,CommunityMaintenance
		,InterpersonalSocial
		,InterpersonalAssertiveness
		,InterpersonalSelfAware
		,InterpersonalConversational
		,InterpersonalSelfImage
		,InterpersonalFeelings
		,InterpersonalRelationships
		,LeadershipSpeaking
		,LeadershipOnSiteCommittee
		,LeadershipOffSiteCommittee
		,LeadershipEmployability
		,LeadershipPolicy
		,PersonalDeveloping
		,PersonalTimeManagement
		,PersonalCoping
		,EnvironmentalNaturalSupports	
		,EnvironmentalResources
		,EnvironmentalOrientation
		,HealthLifestyle
		,HealthNeeds
		,SymptomSituations	
		,SymptomCrisis
		,SymptomMedication
		,SymptomSU
		,ClientStatisfaction
		,OnSiteHealthIssues
		,AssistanceEncouragement
		,AssistanceOrientation
		,AssistanceDirection
		,AssistanceDecision
		,AssistanceCompetency
		,AssistanceInterpersonal
		,AssistanceVocational
		,AssistanceSupport
		,AssistanceSocailization
		,AssistanceHealth
		,AssistanceOperations
		,NotedChangesRecomendations
		,Comments
From CustomCrossroadsReportingNote CC
INNER JOIN Documents ON CC.DocumentId = Documents.DocumentId
Left Join Staff S On Documents.AuthorId = S.StaffId  
AND isnull(Documents.RecordDeleted,''N'')<>''Y'' 
--Removed Old Signature Logic and Replaced.  Please Use this logic -avoss
/*Not Needed
Left outer JOIN DocumentSignatures DocumentSignatures
	ON DocumentSignatures.DocumentId = cc.DocumentId
	AND DocumentSignatures.Version = cc.Version
	AND isnull(DocumentSignatures.RecordDeleted,''N'')<>''Y''
	AND DocumentSignatures.StaffId = Documents.AuthorId
--INNER JOIN DocumentSignatures DocumentSignatures
--ON DocumentSignatures.DocumentId = Documents.DocumentId
--AND isnull(DocumentSignatures.RecordDeleted,''N'')<>''Y''
*/
INNER JOIN Staff ON Staff.Staffid = Documents.AuthorId AND isnull(Staff.RecordDeleted,''N'')<>''Y'' 
INNER JOIN Clients ON Clients.Clientid = Documents.Clientid AND isnull(Clients.RecordDeleted,''N'')<>''Y''
where CC.DocumentId = @DocumentId
and cc.Version = @Version
AND isnull(CC.RecordDeleted,''N'')<>''Y''
*/
' 
END
GO
