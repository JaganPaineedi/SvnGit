/****** Object:  StoredProcedure [dbo].[ssp_MMUpdateMDDosageFormCodesPotencyUnitCode]    Script Date: 03/28/2016 16:40:27 ******/
IF EXISTS (SELECT *
	FROM sys.objects
	WHERE object_id = OBJECT_ID(N'[dbo].[ssp_MMUpdateMDDosageFormCodesPotencyUnitCode]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[ssp_MMUpdateMDDosageFormCodesPotencyUnitCode]
GO

/****** Object:  StoredProcedure [dbo].[ssp_MMUpdateMDDosageFormCodesPotencyUnitCode]    Script Date: 03/28/2016 16:40:27 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



CREATE procedure [dbo].[ssp_MMUpdateMDDosageFormCodesPotencyUnitCode]
--
-- Called by the automated Medication Update Process
-- Official proc generated: 03/28/2016 praorane
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
	from MedicationDatabase..MDDosageFormCodesPotencyUnitCode
	where VersionId = @VersionId
		and updatestatus in ('A', 'D')
	group by UpdateStatus

	-- Adds
	insert into MDDosageFormCodesPotencyUnitCode ( DosageFormCodeId, NCPDPSCRIPTQuantityQualifierId )
	select df3.DosageFormCodeId
	,      n3.NCPDPScriptQuantityQualifierId
	from MedicationDatabase..MDDosageFormCodesPotencyUnitCode as a  
	join MedicationDatabase..MDNCPDPScriptQuantityQualifier   as n1  on n1.NCPDPScriptQuantityQualifierId = a.NCPDPScriptQuantityQualifierId
	join MDNCPDPScriptQuantityQualifier                       as n3  on n3.ExternalNCPDPScriptQuantityQualifierId = n1.ExternalNCPDPScriptQuantityQualifierId
			and isnull(n3.RecordDeleted, 'N') <> 'Y'
	JOIN MedicationDatabase..MDDosageFormCodes                   df1 ON df1.DosageFormCodeId = a.DosageFormCodeId
	JOIN MDDosageFormCodes                                       df3 ON df3.DosageFormCode = df1.DosageFormCode
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
	from MedicationDatabase..MDDosageFormCodesPotencyUnitCode as a  
	join MedicationDatabase..MDNCPDPScriptQuantityQualifier   as n1  on n1.NCPDPScriptQuantityQualifierId = a.NCPDPScriptQuantityQualifierId
	join MDNCPDPScriptQuantityQualifier                       as n3  on n3.ExternalNCPDPScriptQuantityQualifierId = n1.ExternalNCPDPScriptQuantityQualifierId
			and isnull(n3.RecordDeleted, 'N') <> 'Y'
	JOIN MedicationDatabase..MDDosageFormCodes                   df1 ON df1.DosageFormCodeId = a.DosageFormCodeId
	JOIN MDDosageFormCodes                                       df3 ON df3.DosageFormCode = df1.DosageFormCode
			and isnull(df3.RecordDeleted, 'N') <> 'Y'
	JOIN MDDosageFormCodesPotencyUnitCode                        b   ON b.NCPDPSCRIPTQuantityQualifierId = n3.NCPDPScriptQuantityQualifierId
			AND b.DosageFormCodeId = df3.DosageFormCodeId
			AND ISNULL(b.RecordDeleted, 'N') <> 'Y'
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

	raiserror('CheckSum error in ssp_MMUpdateMDNDCMedications', 16,1)




GO
