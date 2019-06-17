/****** Object:  StoredProcedure [dbo].[ssp_MMUpdateMDDosageFormsPotencyUnitCodes]    Script Date: 03/28/2016 16:39:04 ******/
IF EXISTS (SELECT *
	FROM sys.objects
	WHERE object_id = OBJECT_ID(N'[dbo].[ssp_MMUpdateMDDosageFormsPotencyUnitCodes]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[ssp_MMUpdateMDDosageFormsPotencyUnitCodes]
GO

/****** Object:  StoredProcedure [dbo].[ssp_MMUpdateMDDosageFormsPotencyUnitCodes]    Script Date: 03/28/2016 16:39:04 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



CREATE procedure [dbo].[ssp_MMUpdateMDDosageFormsPotencyUnitCodes]
--
-- Called by the automated Medication Update Process
-- Official proc generated: 02/01/2016 praorane
--
@VersionId int
as
	begin tran
	declare @CheckSum table ( UpdateStatus char(1)
	,                         Expected     int
	,                         Actual       int )

	insert into @CheckSum ( UpdateStatus, Expected )
	select UpdateStatus
	,      count(*)
	from MedicationDatabase..MDDosageFormsPotencyUnitCodes
	where VersionId = @VersionId
		and updatestatus in ('A', 'D')
	group by UpdateStatus

	-- Adds
	insert into MDDosageFormsPotencyUnitCodes ( DosageFormId, NCPDPSCRIPTQuantityQualifierId )
	select df3.DosageFormId
	,      n3.NCPDPScriptQuantityQualifierId
	from MedicationDatabase..MDDosageFormsPotencyUnitCodes   as a  
	join MedicationDatabase..MDNCPDPScriptQuantityQualifiers as n1  on n1.NCPDPScriptQuantityQualifierId = a.NCPDPScriptQuantityQualifierId
	join MDNCPDPScriptQuantityQualifiers                     as n3  on n3.ExternalNCPDPScriptQuantityQualifierId = n1.ExternalNCPDPScriptQuantityQualifierId
			and isnull(n3.RecordDeleted, 'N') <> 'Y'
	JOIN MedicationDatabase..MDDosageForms                     df1 ON df1.DosageFormId = a.DosageFormId
	JOIN MDDosageForms                                         df3 ON df3.ExternalDosageFormId = df1.ExternalDosageFormId
			and isnull(df3.RecordDeleted, 'N') <> 'Y'
	where a.VersionId = @VersionId
		and a.UpdateStatus = 'A'

	update @CheckSum
	set Actual = @@rowcount
	where UpdateStatus = 'A'

	-- Deletes
	update b
	set RecordDeleted = 'Y'
	,   DeletedBy     = 'MMUpdateProc'
	,   DeletedDate   = getdate()
	from MedicationDatabase..MDDosageFormsPotencyUnitCodes   as a  
	join MedicationDatabase..MDNCPDPScriptQuantityQualifiers as n1  on n1.NCPDPScriptQuantityQualifierId = a.NCPDPScriptQuantityQualifierId
	join MDNCPDPScriptQuantityQualifiers                     as n3  on n3.ExternalNCPDPScriptQuantityQualifierId = n1.ExternalNCPDPScriptQuantityQualifierId
			and isnull(n3.RecordDeleted, 'N') <> 'Y'
	JOIN MedicationDatabase..MDDosageForms                     df1 ON df1.DosageFormId = a.DosageFormId
	JOIN MDDosageForms                                         df3 ON df3.ExternalDosageFormId = df1.ExternalDosageFormId
			and isnull(df3.RecordDeleted, 'N') <> 'Y'
	JOIN MDDosageFormsPotencyUnitCodes                          b   ON b.DosageFormId = df3.DosageFormId
			AND b.NCPDPSCRIPTQuantityQualifierId = n3.NCPDPSCRIPTQuantityQualifierId
	where a.VersionId = @VersionId
		and a.UpdateStatus = 'D'

	update @CheckSum
	set Actual = @@rowcount
	where UpdateStatus = 'D'
	-- no changes

	if exists (select *
		from @CheckSum
		where isnull(Expected,0) <> isnull(Actual,0) and UpdateStatus = 'A')
		goto checksum_error
	if exists (select *
		from @CheckSum
		where isnull(Expected,0) > isnull(Actual,0) and UpdateStatus = 'D')
		goto checksum_error

	commit tran
	return 0

	checksum_error:

	select *
	from @CheckSum

	rollback tran

	raiserror('CheckSum error in ssp_MMUpdateMDDosageFormsPotencyUnitCodes', 16,1)




GO
