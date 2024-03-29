DROP PROCEDURE [dbo].[ssp_MMUpdateToNewVersion]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE procedure [dbo].[ssp_MMUpdateToNewVersion]
--
-- Called by the automated Medication Update Process
-- Official proc generated: 05/31/2013 by T. Remisoski
--
	@TargetVersion int
as
declare @CurrentVersion int

declare @s nvarchar(4000)

select @CurrentVersion = isnull(MedicationDatabaseVersion, 0) from SystemConfigurations

begin try

if @CurrentVersion >= @TargetVersion
begin
	set @s = 'Target Version(' + cast(@TargetVersion as varchar) + ') is less than or equal to the current Medication database version (' + cast(@CurrentVersion as varchar) + ')'
	raiserror(@s, 16, 1)
end

while @CurrentVersion < @TargetVersion
begin
	-- increment current version
	set @CurrentVersion = @CurrentVersion + 1
	begin try
		begin tran

		exec ssp_MMUpdateMDRoutes @CurrentVersion
		exec ssp_MMUpdateMDAllergenGroups @CurrentVersion
		exec ssp_MMUpdateMDDosageForms @CurrentVersion
		exec ssp_MMUpdateMDDosageFormCodes @CurrentVersion
		exec ssp_MMUpdateMDRouteAdministrations @CurrentVersion
		exec ssp_MMUpdateMDDrugCategories @CurrentVersion
		exec ssp_MMUpdateMDMedicationNames @CurrentVersion
		exec ssp_MMUpdateMDHierarchicalIngredientCodes @CurrentVersion
		exec ssp_MMUpdateMDIngredientLists @CurrentVersion
		exec ssp_MMUpdateMDClinicalFormulations @CurrentVersion
		exec ssp_MMUpdateMDIngredientListIngredientCodes @CurrentVersion
		exec ssp_MMUpdateMDRouteUnits @CurrentVersion
		exec ssp_MMUpdateMDDrugs @CurrentVersion
		exec ssp_MMUpdateMDRoutedMedications @CurrentVersion
		exec ssp_MMUpdateMDRoutedDosageFormMedications @CurrentVersion
		exec ssp_MMUpdateMDMedications @CurrentVersion
		exec ssp_MMUpdateMDAllergenConcepts @CurrentVersion
		exec ssp_MMUpdateMDMedicationConcepts @CurrentVersion
		exec ssp_MMUpdateMDAllergenGroupIngredients @CurrentVersion
		exec ssp_MMUpdateMDDrugMedications @CurrentVersion
		exec ssp_MMUpdateMDDrugDrugInteractionMonographs @CurrentVersion
		exec ssp_MMUpdateMDDrugDrugInteractionMonographText @CurrentVersion
		exec ssp_MMUpdateMDDrugDrugInteractions @CurrentVersion
		exec ssp_MMUpdateMDDrugDrugInteractionFormulations @CurrentVersion
		exec ssp_MMUpdateMDPatientEducationMonographs @CurrentVersion
		exec ssp_MMUpdateMDPatientEducationMonographText @CurrentVersion
		exec ssp_MMUpdateMDPatientEducationMonographFormulations @CurrentVersion
      		exec ssp_MDPediatricDosageRanges @CurrentVersion
      		exec ssp_MDGeriatricDosageRanges @CurrentVersion
      		exec ssp_MDAdultDosageRanges @CurrentVersion
			--exec ssp_MMUpdateMDMedicationsRxNorm @CurrentVersion

		update systemconfigurations set MedicationDatabaseVersion = @CurrentVersion

		-- update soundex values
		update MDMedicationNames set MedicationNameSoundex = soundex(MedicationName) where MedicationNameSoundex is null
		update MDAllergenconcepts set ConceptDescriptionSoundex = soundex(ConceptDescription) where ConceptDescriptionSoundex is null


		commit tran
	end try
	begin catch
		set @s = error_message()

		if @@trancount > 0 rollback tran

		raiserror(@s, 16, 1)
	end catch
end
end try
begin catch
	set @s = error_message()
	set @s = 'Failed to update to version: ' + cast(@CurrentVersion as varchar) + ' additional info: ' + substring(@s, 1, 4000 - len('Failed to update to version: ' + cast(@CurrentVersion as varchar) + 'additional info: '))
	if @@trancount > 0 rollback tran

	raiserror(@s, 16, 1)
end catch
GO
