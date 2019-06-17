/****** Object:  StoredProcedure [dbo].[ssp_MMUpdateMDMedicationsRxNorm]    Script Date: 02/04/2016 14:42:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_MMUpdateMDMedicationsRxNorm]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_MMUpdateMDMedicationsRxNorm]
GO

/****** Object:  StoredProcedure [dbo].[ssp_MMUpdateMDMedicationsRxNorm]    Script Date: 02/04/2016 14:42:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


CREATE procedure [dbo].[ssp_MMUpdateMDMedicationsRxNorm]
--
-- Called by the automated Medication Update Process
-- Official proc generated: 02/02/2016 praorane
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
	from MedicationDatabase..MDMedicationsRxNorm
	where VersionId = @VersionId
		and updatestatus in ('A', 'D')
	group by UpdateStatus
	-- Adds
	insert into MDMedicationsRxNorm ( RxNorm, SemanticClinicalDrug, SemanticBrandedDrug, DerivationViaClinicalFormulation, DerivationViaCommonNDC, MedicationId )
	select a.RxNorm
	,      a.SemanticClinicalDrug
	,      a.SemanticBrandedDrug
	,      a.DerivationViaClinicalFormulation
	,      a.DerivationViaCommonNDC
	,      m3.MedicationId
	from MedicationDatabase..MDMedicationsRxNorm as a 
	join MedicationDatabase..MDMedications       as m1 on m1.MedicationId = a.MedicationId
	join MDMedications                           as m3 on m3.ExternalMedicationId = m1.ExternalMedicationId and isnull(m3.RecordDeleted, 'N') <> 'Y'
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
	from MedicationDatabase..MDMedicationsRxNorm as a 
	join MedicationDatabase..MDMedications       as m1 on m1.MedicationId = a.MedicationId
	join MDMedications                           as m3 on m3.ExternalMedicationId = m1.ExternalMedicationId --and isnull(m3.RecordDeleted, 'N') <> 'Y'
	join MDMedicationsRxNorm                     as b  on a.RxNorm = b.RxNorm
			AND a.SemanticClinicalDrug = b.SemanticClinicalDrug
			AND a.SemanticBrandedDrug = b.SemanticBrandedDrug
			AND a.DerivationViaClinicalFormulation = b.DerivationViaClinicalFormulation
			AND a.DerivationViaCommonNDC = b.DerivationViaCommonNDC
			and b.Medicationid = m3.MedicationId --and isnull(b.RecordDeleted, 'N') <> 'Y'
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

	raiserror('CheckSum error in ssp_MMUpdateMDMedicationsRxNorm', 16,1)


GO


