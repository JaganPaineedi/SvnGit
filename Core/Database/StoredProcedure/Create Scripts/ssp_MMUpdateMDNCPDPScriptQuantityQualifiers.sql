/****** Object:  StoredProcedure [dbo].[ssp_MMUpdateMDNCPDPScriptQuantityQualifiers]    Script Date: 03/28/2016 16:42:47 ******/
IF EXISTS (SELECT *
	FROM sys.objects
	WHERE object_id = OBJECT_ID(N'[dbo].[ssp_MMUpdateMDNCPDPScriptQuantityQualifiers]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[ssp_MMUpdateMDNCPDPScriptQuantityQualifiers]
GO

/****** Object:  StoredProcedure [dbo].[ssp_MMUpdateMDNCPDPScriptQuantityQualifiers]    Script Date: 03/28/2016 16:42:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


CREATE procedure [dbo].[ssp_MMUpdateMDNCPDPScriptQuantityQualifiers]
--
-- Called by the automated Medication Update Process
-- Official proc generated: 03/28/2016 by praorane
--
@VersionId int
as
	begin tran
	-- Adds
	declare @CheckSum table ( UpdateStatus char(1)
	,                         Expected     int
	,                         Actual       int )

	insert into @CheckSum ( UpdateStatus, Expected )
	select UpdateStatus
	,      count(*)
	from MedicationDatabase..MDNCPDPScriptQuantityQualifiers
	where VersionId = @VersionId
	group by UpdateStatus

	insert into MDNCPDPScriptQuantityQualifiers ( ExternalNCPDPScriptQuantityQualifierId, QuantityQualifierCode, QualityQuantifierDescription, XRefSourceId, ObsoleteDate )
	select a.ExternalNCPDPScriptQuantityQualifierId
	,      a.QuantityQualifierCode
	,      a.QualityQuantifierDescription
	,      a.XRefSourceId
	,      a.ObsoleteDate
	from MedicationDatabase..MDNCPDPScriptQuantityQualifiers as a

	where a.VersionId = @VersionId
		and a.UpdateStatus = 'A'

	update @CheckSum
	set Actual = @@rowcount
	where UpdateStatus = 'A'

	-- changes
	update b
	set b.QuantityQualifierCode        = a.QuantityQualifierCode
	,   b.QualityQuantifierDescription = a.QualityQuantifierDescription
	,   b.XRefSourceId                 = a.XRefSourceId
	,   b.ObsoleteDate                 = a.ObsoleteDate
	from MedicationDatabase..MDNCPDPScriptQuantityQualifiers as a
	join MDNCPDPScriptQuantityQualifiers                     as b on b.ExternalNCPDPScriptQuantityQualifierId = a.ExternalNCPDPScriptQuantityQualifierId
			and isnull(b.RecordDeleted, 'N') <> 'Y'
	where a.VersionId = @VersionId
		and a.UpdateStatus = 'C'

	update @CheckSum
	set Actual = @@rowcount
	where UpdateStatus = 'C'


	-- Deletes
	update b
	set RecordDeleted = 'Y'
	,   DeletedBy     = 'MMUpdateProc'
	,   DeletedDate   = getdate()
	from MedicationDatabase..MDNCPDPScriptQuantityQualifiers as a
	join MDNCPDPScriptQuantityQualifiers                     as b on b.ExternalNCPDPScriptQuantityQualifierId = a.ExternalNCPDPScriptQuantityQualifierId
			and isnull(b.RecordDeleted, 'N') <> 'Y'
	where a.VersionId = @VersionId
		and a.UpdateStatus = 'D'

	update @CheckSum
	set Actual = @@rowcount
	where UpdateStatus = 'D'

	if exists (select *
		from @CheckSum
		where isnull(Expected,0) <> isnull(Actual,0))
		goto checksum_error
	commit tran
	return 0

	checksum_error:

	select *
	from @CheckSum

	rollback tran

	raiserror('CheckSum error in ssp_MMUpdateMDNCPDPScriptQuantityQualifiers', 16,1)

GO
