/****** Object:  StoredProcedure [dbo].[csp_RDWExtractCustomTimeliness]    Script Date: 06/19/2013 17:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDWExtractCustomTimeliness]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDWExtractCustomTimeliness]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDWExtractCustomTimeliness]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[csp_RDWExtractCustomTimeliness]
@AffiliateId	int
As

-- Clear out the existing data
delete from dbo.CustomRDWExtractCustomTimeliness

if @@error <> 0 goto error

-- Insert the new data
Insert into CustomRDWExtractCustomTimeliness
(AffiliateID,
ClientEpisodeId,
ClientId,
EpisodeNumber,
AssessmentPopulation,
AssessmentRequestSystemDate,
AssessmentRequestManualDate,
AssessmentRequestReportingDate,
AssessmentFirstOfferedDate,
AssessmentFirstOfferedReasonDeclined,
AssessmentServiceId,
AssessmentSystemDate,
AssessmentManualDate,
AssessmentReportingDate,
AssessmentReportingStatus,
AssessmentReportingStatusReason,
StartOfTreatmentPopulation,
StartOfTreatmentFirstOfferedDate,
StartOfTreatmentFirstOfferedReasonDeclined,
StartOfTreatmentServiceId,
StartOfTreatmentSystemDate,
StartOfTreatmentManualDate,
StartOfTreatmentReportingDate,
StartOfTreatmentReportingStatus,
StartOfTreatmentReportingStatusReason)

Select
	@AffiliateId as ''AffiliateId'',
	ce.ClientEpisodeId,
	ce.ClientId,
	ce.EpisodeNumber,
	ct.DiagnosticCategory as ''AssessmentPopulation'',
	ct.SystemDateOfInitialRequest as ''AssessmentRequestSystemDate'',
	ct.ManualDateOfInitialRequest as ''AssessmentRequestManualDate'',
	isnull(ct.ManualDateOfInitialRequest,ct.SystemDateOfInitialRequest) as ''AssessmentRequestReportingDate'',
	ce.AssessmentFirstOffered as ''AssessmentFirstOfferedDate'',
	gc1.CodeName as ''AssessmentFirstOfferedReasonDeclined'',
	ct.SystemInitialAssessmentServiceId as ''AssessmentServiceId'',
	ct.SystemDateOfInitialAssessment as ''AssessmentSystemDate'',
	ct.ManualDateOfInitialAssessment as ''AssessmentManualDate'',
	isnull(ct.ManualDateOfInitialAssessment,ct.SystemDateOfInitialAssessment) as ''AssessmentReportingDate'',
	case ct.InitialStatus when ''E'' then ''Exception'' when ''U'' then ''Exclusion'' else NULL end as ''AssessmentReportingStatus'',
	ct.InitialReason as ''AssessmentReportingStatusReason'',
	ct.DiagnosticCategory as ''StartOfTreatmentPopulation'',
	ce.TxStartFirstOffered as ''StartOfTreatmentFirstOfferedDate'',
	gc2.CodeName as ''StartOfTreatmentFirstOfferedReasonDeclined'',
	ct.SystemTreatmentServiceId as ''StartOfTreatmentServiceId'',
	ct.SystemDateOfTreatment as ''StartOfTreatmentSystemDate'',
	ct.ManualDateOfTreatment as ''StartOfTreatmentManualDate'',
	isnull(ct.ManualDateOfTreatment,ct.SystemDateOfTreatment) as ''StartOfTreatmentReportingDate'',
	case ct.OngoingStatus when ''E'' then ''Exception'' when ''U'' then ''Exclusion'' else NULL end as ''StartOfTreatmentReportingStatus'',
	ct.OngoingReason as ''StartOfTreatmentReportingStatusReason''
from CustomTimeliness ct
join ClientEpisodes ce on ce.ClientEpisodeId = ct.ClientEpisodeId
--Left joining globalCodes to maintain inclusion of all cases even if code is deleted.
left join GlobalCodes gc1 on gc1.GlobalCodeId = ce.AssessmentDeclinedReason
left join GlobalCodes gc2 on gc2.GlobalCodeId = ce.TxStartDeclinedReason
where isnull(ct.RecordDeleted, ''N'') = ''N''

If @@error <> 0 goto error

return

error:

exec csp_RDWExtractError @AffiliateId = @AffiliateId, @ErrorText = ''Failed to execute csp_RDWExtractCustomTimeliness''
' 
END
GO
