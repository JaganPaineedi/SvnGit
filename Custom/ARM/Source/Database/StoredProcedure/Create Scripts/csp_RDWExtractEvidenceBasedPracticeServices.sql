/****** Object:  StoredProcedure [dbo].[csp_RDWExtractEvidenceBasedPracticeServices]    Script Date: 06/19/2013 17:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDWExtractEvidenceBasedPracticeServices]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDWExtractEvidenceBasedPracticeServices]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDWExtractEvidenceBasedPracticeServices]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE procedure [dbo].[csp_RDWExtractEvidenceBasedPracticeServices]
@AffiliateId		int
/*********************************************************************
-- Stored Procedure: dbo.csp_RDWExtractEvidenceBasedPracticeServices
-- Creation Date:    11/06/2008
--
-- Purpose: populates CustomRDWExtractEvidenceBasedPracticeServices table
--
-- Updates:
--   Date         Author      Purpose
--   11.06.2010   RNoble      Created.
--   09.29.2010   DHarvey     Modified to use DocumentVersionId
*********************************************************************/
as

declare @cutoffDate		datetime
select @cutoffDate = ''10/01/2006''

-- Clear out the existing data
delete from dbo.CustomRDWExtractEvidenceBasedPracticeServices

if @@error <> 0 goto error

Insert into CustomRDWExtractEvidenceBasedPracticeServices
(AffiliateId,
ServiceId,
EvidenceBasedPracticeId)
-- Get services where modality is specified on the attached note
	Select @AffiliateId, a.serviceId,
	case when isnull(c.DBT,''N'') = ''Y'' then ''DBT'' -- DBT
	else case isnull(c.CBT,''N'') when ''Y'' then ''CBT'' -- CBT
	/*else case d.modality when GlobalCodeId for DBT then ''DBT'' -- Crisis DBT
	else '''' end*/ end end 
	From services a
	left join Documents b on a.ServiceId = b.ServiceId
	left join Notes c on b.CurrentDocumentVersionId = c.DocumentVersionId
	left join CustomCrisisInterventions d on c.DocumentVersionId = d.DocumentVersionId
	where isnull(a.RecordDeleted,''N'') <> ''Y''
	and isnull(b.RecordDeleted,''N'') <> ''Y''
	and isnull(c.RecordDeleted,''N'') <> ''Y''
	and -- Determine if the note was marked as CBT, or DBT
		(isnull(c.DBT,''N'') = ''Y''
		or
		isnull(c.CBT,''N'') = ''Y''
		-- The following line is a placeholder which needs to be implemented when
		-- SmartCare is modified to support modality of treatment on the Crisis Intervention document.
		--or
		--isnull(d.Modality,'''') <> ''''
		)
	and a.DateOfService >= @cutoffDate

-- Get services where the procedureCode itself indicates an EBP.  This will vary by Affiliate
Insert into CustomRDWExtractEvidenceBasedPracticeServices
(AffiliateId,
ServiceId,
EvidenceBasedPracticeId)
	select @affiliateId, a.serviceId,
	case when a.procedureCodeId in (199,200,201,202,203) then ''FPE'' -- Family Psycho Ed
	when a.procedureCodeId in (147,148,149,150,151,534,536) then ''DBT'' -- DBT
	else '''' end
	from Services a
	where isnull(a.RecordDeleted,''N'') <> ''Y''
	and a.DateOfService >= @cutoffDate
	and -- Procedure codes are broken up to allow easier maintenance if new codes are added for a modality.
		(a.procedureCodeId in (199,200,201,202,203) -- Family Psycho Ed
		or
		a.procedureCodeId in (147,148,149,150,151,534,536) -- DBT
		)
	and not exists -- In the event that the service uses an EBP procedure code and has a note indicating an EBP
	(select 1 from CustomRDWExtractEvidenceBasedPracticeServices b
	where a.ServiceId = b.ServiceId)

if @@error <> 0 goto error

return

error:

exec csp_RDWExtractError @AffiliateId = @AffiliateId, @ErrorText = ''Failed to execute csp_RDWExtractEvidenceBasedPracticeServices''
' 
END
GO
