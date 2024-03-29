/****** Object:  StoredProcedure [dbo].[csp_validateCustomHRMSUAssessments]    Script Date: 06/19/2013 17:49:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateCustomHRMSUAssessments]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_validateCustomHRMSUAssessments]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateCustomHRMSUAssessments]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE          PROCEDURE [dbo].[csp_validateCustomHRMSUAssessments]
@DocumentVersionId	Int
as

CREATE TABLE #CustomSUAssessments
(	DocumentVersionId int,
	VoluntaryAbstinenceTrial text NULL ,
	Comment text,
	HistoryOrCurrentDUI char(1),
	NumberOfTimesDUI int NULL ,
	HistoryOrCurrentDWI char(1),
	NumberOfTimesDWI int NULL ,
	HistoryOrCurrentMIP char(1),
	NumberOfTimeMIP int NULL ,
	HistoryOrCurrentBlackOuts char(1),
	NumberOfTimesBlackOut int NULL ,
	HistoryOrCurrentDomesticAbuse char(1),
	NumberOfTimesDomesticAbuse int NULL ,
	LossOfControl char(1),
	IncreasedTolerance char(1),
	OtherConsequence char(1),
	OtherConsequenceDescription varchar (1000) NULL ,
	RiskOfRelapse text NULL ,
	PreviousTreatment char(1),
	CurrentSubstanceAbuseTreatment char(1),
	CurrentTreatmentProvider varchar (100) NULL ,
	CurrentSubstanceAbuseReferralToSAorTx char(1),
	CurrentSubstanceAbuseRefferedReason text NULL ,
	ToxicologyResults text NULL ,
	ClientSAHistory char(1),
	FamilySAHistory char(1),
	NoSubstanceAbuseSuspected char(1),
	CurrentSubstanceAbuse char(1),
	SuspectedSubstanceAbuse char(1),
	SubstanceAbuseDetail text NULL ,
	SubstanceAbuseTxPlan char(1),
	OdorOfSubstance char(1),
	SlurredSpeech char(1),
	WithdrawalSymptoms char(1),
	DTOther char(1),
	DTOtherText varchar (100) NULL ,
	Blackouts char(1),
	RelatedArrests char(1),
	RelatedSocialProblems char(1),
	FrequentJobSchoolAbsence char(1),
	NoneSynptomsReportedOrObserved char(1),
	RowIdentifier char(36),
	CreatedBy varchar(100),
	CreatedDate datetime,
	ModifiedBy varchar(100),
	ModifiedDate datetime,
	RecordDeleted char(1),
	DeletedDate datetime NULL ,
	DeletedBy varchar(100)
)

Insert into #CustomSUAssessments
(DocumentVersionId,
VoluntaryAbstinenceTrial, Comment, HistoryOrCurrentDUI, NumberOfTimesDUI, HistoryOrCurrentDWI, 
NumberOfTimesDWI, HistoryOrCurrentMIP, NumberOfTimeMIP, HistoryOrCurrentBlackOuts, NumberOfTimesBlackOut,
 HistoryOrCurrentDomesticAbuse, NumberOfTimesDomesticAbuse, LossOfControl, IncreasedTolerance,
 OtherConsequence, OtherConsequenceDescription, RiskOfRelapse, PreviousTreatment, 
CurrentSubstanceAbuseTreatment, CurrentTreatmentProvider, CurrentSubstanceAbuseReferralToSAorTx,
 CurrentSubstanceAbuseRefferedReason, ToxicologyResults, ClientSAHistory, FamilySAHistory,
 NoSubstanceAbuseSuspected, CurrentSubstanceAbuse, SuspectedSubstanceAbuse, SubstanceAbuseDetail, 
SubstanceAbuseTxPlan, OdorOfSubstance, SlurredSpeech, WithdrawalSymptoms, DTOther, DTOtherText,
 Blackouts, RelatedArrests, RelatedSocialProblems, FrequentJobSchoolAbsence, NoneSynptomsReportedOrObserved,
 RowIdentifier, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, RecordDeleted, DeletedDate, DeletedBy)
select
a.DocumentVersionId, VoluntaryAbstinenceTrial, Comment, HistoryOrCurrentDUI, NumberOfTimesDUI, HistoryOrCurrentDWI, 
NumberOfTimesDWI, HistoryOrCurrentMIP, NumberOfTimeMIP, HistoryOrCurrentBlackOuts, NumberOfTimesBlackOut,
 HistoryOrCurrentDomesticAbuse, NumberOfTimesDomesticAbuse, LossOfControl, IncreasedTolerance,
 OtherConsequence, OtherConsequenceDescription, RiskOfRelapse, PreviousTreatment, 
CurrentSubstanceAbuseTreatment, CurrentTreatmentProvider, CurrentSubstanceAbuseReferralToSAorTx,
 CurrentSubstanceAbuseRefferedReason, ToxicologyResults, ClientSAHistory, FamilySAHistory,
 NoSubstanceAbuseSuspected, CurrentSubstanceAbuse, SuspectedSubstanceAbuse, SubstanceAbuseDetail,
 SubstanceAbuseTxPlan, OdorOfSubstance, SlurredSpeech, WithdrawalSymptoms, DTOther, DTOtherText, 
Blackouts, RelatedArrests, RelatedSocialProblems, FrequentJobSchoolAbsence, NoneSynptomsReportedOrObserved,
a.RowIdentifier, a.CreatedBy, a.CreatedDate, a.ModifiedBy, a.ModifiedDate, a.RecordDeleted, a.DeletedDate, a.DeletedBy
FROM CustomSubstanceUseAssessments a
where a.DocumentVersionId = @DocumentVersionId
and isnull(a.RecordDeleted,''N'') = ''N''


Insert into #validationReturnTable
(TableName,
ColumnName,
ErrorMessage,
PageIndex
)

Select ''CustomSubstanceUseAssessments'', ''DeletedBy'', ''SU - Substance Use section incomplete'', 21
	from #CustomSUAssessments
	where
	isnull(NoSubstanceAbuseSuspected,''N'') = ''N''
	and isnull(FamilySAHistory,''N'') = ''N''
	and isnull(ClientSAHistory,''N'') = ''N''
	and isnull(CurrentSubstanceAbuse,''N'') = ''N''
	and isnull(SuspectedSubstanceAbuse,''N'') = ''N''
	and isnull(SubstanceAbuseTxPlan,''N'') = ''N''

Union
Select ''CustomSubstanceUseAssessments'', ''DeletedBy'', ''SU - Substance Abuse symptoms (Reported or Observed) incomplete'', 21
	from #CustomSUAssessments
	where
	isnull(OdorOfSubstance,''N'') = ''N''
	and isnull(SlurredSpeech,''N'') = ''N''
	and isnull(WithdrawalSymptoms,''N'') = ''N''
	and isnull(DTOther,''N'') = ''N''
	and isnull(Blackouts,''N'') = ''N''
	and isnull(RelatedArrests,''N'') = ''N''
	and isnull(RelatedSocialProblems,''N'') = ''N''
	and isnull(FrequentJobSchoolAbsence,''N'') = ''N''
	and isnull(NoneSynptomsReportedOrObserved,''N'') = ''N''
	and isnull(NoSubstanceAbuseSuspected,''N'') = ''N''


Union
Select ''CustomSubstanceUseAssessments'', ''DeletedBy'', ''SU - History And Current Use of Substances must be specified.'', 21
	from #CustomSUAssessments ca
	where (isnull(ClientSAHistory,''N'') = ''Y''
		OR isnull(CurrentSubstanceAbuse, ''N'')= ''Y''
			)
	and not exists (Select 1 From CustomSubstanceUseHistory suh
			Where suh.DocumentVersionId = ca.DocumentVersionId
			and isnull(suh.recorddeleted, ''N'') = ''N'')

Union
Select ''CustomSubstanceUseAssessments'', ''DeletedBy'', ''SU - Previous substance abuse treatment must be specified'', 21
	from #CustomSUAssessments
	where isnull(PreviousTreatment,'''') not in (''N'',''Y'')
		and(isnull(ClientSAHistory,''N'') = ''Y''
			OR isnull(CurrentSubstanceAbuse, ''N'')= ''Y''
			)
Union
Select ''CustomSubstanceUseAssessments'', ''DeletedBy'', ''SU - Current substance abuse treatment must be specified'', 21
	from #CustomSUAssessments
	where isnull(CurrentSubstanceAbuseTreatment,'''') not in (''N'',''Y'')
		and(isnull(ClientSAHistory,''N'') = ''Y''
			OR isnull(CurrentSubstanceAbuse, ''N'')= ''Y''
			)
Union
Select ''CustomSubstanceUseAssessments'', ''DeletedBy'', ''SU - Current substance abuse treatment provider must be specified'', 21
	from #CustomSUAssessments
	where isnull(CurrentSubstanceAbuseTreatment,'''') = ''Y''
		and(isnull(ClientSAHistory,''N'') = ''Y''
			OR isnull(CurrentSubstanceAbuse, ''N'')= ''Y''
			)
	and isnull(convert(varchar(8000), CurrentTreatmentProvider), '''') = ''''

Union
Select ''CustomSubstanceUseAssessments'', ''DeletedBy'', ''SU - Referral to SA or Co-occuring Tx must be specified'', 21
	from #CustomSUAssessments
	where isnull(CurrentSubstanceAbuseReferralToSAorTX,'''') not in (''N'',''Y'')
		and(isnull(ClientSAHistory,''N'') = ''Y''
			OR isnull(CurrentSubstanceAbuse, ''N'')= ''Y''
			)
Union
Select ''CustomSubstanceUseAssessments'', ''DeletedBy'', ''SU - Referral to SA or Co-occuring Tx reason must be specified'', 21
	from #CustomSUAssessments
		where(isnull(ClientSAHistory,''N'') = ''Y''
			OR isnull(CurrentSubstanceAbuse, ''N'')= ''Y''
			)
	and isnull(Convert(varchar(8000), CurrentSubstanceAbuseRefferedReason), '''') = ''''

Union
Select ''CustomSubstanceUseAssessments'', ''DeletedBy'', ''SU - Family History of Substance Use must be specified.'', 21
	from #CustomSUAssessments ca
	where isnull(FamilySAHistory,'''') = ''Y''
	and not exists (Select 1 From CustomSubstanceUseFamilyHistory sufh
			Where sufh.DocumentVersionId = ca.DocumentVersionId
			and isnull(sufh.recorddeleted, ''N'') = ''N'')
--Union
--Select ''CustomSubstanceUseAssessments'', ''DeletedBy'', ''SU - Risk of Relapse must be specified''
--	from #CustomSUAssessments
--	where isnull(NoSubstanceAbuseSuspected,''N'') = ''N''
--	and isnull(Convert(Varchar(8000), RiskOfRelapse), '''') = ''''
' 
END
GO
