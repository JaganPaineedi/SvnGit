/****** Object:  StoredProcedure [dbo].[ssp_SCGetClientDrugAllergyInteractionWithOverrides]    Script Date: 10/21/2013 14:42:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

if object_id('ssp_SCGetClientDrugAllergyInteractionWithOverrides', 'P') is not null
	drop procedure ssp_SCGetClientDrugAllergyInteractionWithOverrides
go

create PROCEDURE [dbo].[ssp_SCGetClientDrugAllergyInteractionWithOverrides]
    (
      @ClientId INT ,
      @PrescriberId INT
    )
AS 
/****************************************************************************/
 --Stored Procedure: dbo.ssp_SCGetClientDrugAllergyInteractionWithOverrides
 --Copyright: 2007-2011 Streamline Healthcare Solutions,  LLC
 --Creation Date: 2011.08.17

 --Purpose:  To retrieve Drug Drug interaction details (replaces ssp_SCGetClientDrugAllergyInteractionWithOverrides)
 --Input Parameters:
 --       @ClientId    int
 --           The client for whom interactions will be checked.
 --       @PrescriberId
 --			  Staff Id of the prescriber (needed to check for overrides).

 --Output Parameters: None

 --Return:   data tables:
 --     Data table 1: Client alergy interactions.

 --Called By: Medication Management

 --Calls:

 --Data Modifications:

 --Updates:
 --  Date			Author			Purpose
 --  2011.08.17		T. Remisoski	Created based on ssp_SCGetClientDrugAllergyInteractions
 --  2011.08.19		T. Remisoski	Fixed problem where client has no actively order medications
 --  2013.10.21		T. Remisoski	Find allergies to medications related by clinical formulation or by generic
 --  2017 Jan 04	Vithobha		Added missing logic for Drug Allergy Interactions, Thresholds - Support: #830 RX
/****************************************************************************/

-- staff-specific attributes which may result in override.
    DECLARE @StaffDegree INT
    DECLARE @TaxonomyCode INT

    SELECT  @StaffDegree = s.Degree ,
            @TaxonomyCode = s.TaxonomyCode
    FROM    Staff AS s
    WHERE   s.StaffId = @PrescriberId

    BEGIN TRY

        DECLARE @CurrentMedicationIds VARCHAR(4000)
        DECLARE @Query NVARCHAR(MAX)
        DECLARE @CurrMedId INT
        DECLARE @retval INT                --
-- Build a list of current medication ids for the client
--
        DECLARE cCurrentMeds CURSOR
        FOR
            SELECT DISTINCT
                    cmi.StrengthId
            FROM    ClientMedicationInstructions AS cmi
                    JOIN ClientMedications AS cm ON cm.ClientMedicationId = cmi.ClientMedicationId
            WHERE   cm.ClientId = @ClientId
                    AND ISNULL(cm.Discontinued, 'N') <> 'Y'
                    AND ISNULL(cm.RecordDeleted, 'N') <> 'Y'
                    AND ISNULL(cmi.RecordDeleted, 'N') <> 'Y' AND ISNULL(cmi.Active,'Y')='Y'
--and datediff(day, cmi.StartDate, getdate()) >= 0
--and ((datediff(day, cmi.EndDate, getdate()) <= 0) or (cmi.EndDate is null))

        SET @CurrentMedicationIds = ''

        OPEN cCurrentMeds

        FETCH cCurrentMeds INTO @CurrMedId

        WHILE @@fetch_status = 0 
            BEGIN

                IF LEN(@CurrentMedicationIds) > 0 
                    SET @CurrentMedicationIds = @CurrentMedicationIds + ','

                SET @CurrentMedicationIds = @CurrentMedicationIds
                    + CAST(@CurrMedId AS VARCHAR)

                FETCH cCurrentMeds INTO @CurrMedId

            END

        CLOSE cCurrentMeds

        DEALLOCATE cCurrentMeds


/* Case Of client is allergic to a Medication Name */

        SET @query = '
Select distinct z.AllergenConceptId, z.MedicationNameId, z.ConceptDescription, z.AllergyType from ('

        SET @query = @query
            + 'Select distinct MDA.AllergenConceptId,MD.MedicationNameId,MDA.ConceptDescription,CA.AllergyType
from MDMedications MD
inner join MDAllergenConcepts MDA on MDA.MedicationNameId=MD.MedicationNameId
JOIN ClientAllergies CA on CA.AllergenConceptId=MDA.AllergenConceptId
where ISNULL(CA.RecordDeleted,''N'')<>''Y'' and CA.Active = ''Y'' and CA.Active = ''Y'' and CA.ClientId='
            + CAST(@ClientId AS VARCHAR)
            + CASE WHEN LEN(@CurrentMedicationIds) > 0 THEN '  and
MD.MedicationId in (' + @CurrentMedicationIds + ')'
                   ELSE ' and 1=0 '
              END

        SET @Query = @Query + ' union '

        SET @Query = @Query
            + 'Select distinct MDA.AllergenConceptId,cmd2.MedicationNameId,MDA.ConceptDescription,CA.AllergyType
from MDMedications md
join MDAllergenConcepts mda on mda.MedicationNameId = md.MedicationNameId
join ClientAllergies ca on ca.AllergenConceptId = mda.AllergenConceptId
join ClientMedications as cm on cm.ClientId = ca.ClientId
join MDMedications as cmd2 on cmd2.ClinicalFormulationId = md.ClinicalFormulationId
where isnull(ca.RecordDeleted, ''N'') <> ''Y''
and isnull(cm.RecordDeleted, ''N'') <> ''Y''
and CA.Active = ''Y''
and ca.ClientId = ' + CAST(@ClientId AS VARCHAR)
            + CASE WHEN LEN(@CurrentMedicationIds) > 0 THEN '  and
cmd2.MedicationId in (' + @CurrentMedicationIds + ')'
                   ELSE ' and 1=0 '
              END

        SET @Query = @Query + ' union '

        SET @Query = @Query
            + 'Select distinct MDA.AllergenConceptId,cmd4.MedicationNameId,MDA.ConceptDescription,CA.AllergyType
from MDMedications md
join MDAllergenConcepts mda on mda.MedicationNameId = md.MedicationNameId
join ClientAllergies ca on ca.AllergenConceptId = mda.AllergenConceptId
join ClientMedications as cm on cm.ClientId = ca.ClientId
join MDMedications as cmd2 on cmd2.ClinicalFormulationId = md.ClinicalFormulationId
join MDMedicationNames as mn2 on mn2.MedicationNameId = cmd2.MedicationNameId
join MDMedications as cmd3 on cmd3.MedicationNameId = cmd2.MedicationNameId
join MDMedications as cmd4 on cmd4.ClinicalFormulationId = cmd3.ClinicalFormulationId
where isnull(ca.RecordDeleted, ''N'') <> ''Y''
and isnull(cm.RecordDeleted, ''N'') <> ''Y''
and isnull(cmd2.RecordDeleted, ''N'') <> ''Y''
and isnull(cmd3.RecordDeleted, ''N'') <> ''Y''
and isnull(cmd4.RecordDeleted, ''N'') <> ''Y''
and CA.Active = ''Y''
and mn2.MedicationType = 2  -- generic
and ca.ClientId = ' + CAST(@ClientId AS VARCHAR)
            + CASE WHEN LEN(@CurrentMedicationIds) > 0 THEN '  and
cmd4.MedicationId in (' + @CurrentMedicationIds + ')'
                   ELSE ' and 1=0 '
              END


/* Case Of client is allergetic to a Ingredient*/
        SET @Query = @Query + ' union '

        SET @Query = @Query
            + 'Select distinct MDA.AllergenConceptId,MD.MedicationNameId,MDA.ConceptDescription,CA.AllergyType
from MDMedications MD
inner join MDClinicalFormulations MDC on MD.ClinicalFormulationId=MDC.ClinicalFormulationId
inner join MDIngredientListIngredientCodes MIC on MIC.IngredientListId=MDC.IngredientListId
inner join MDAllergenConcepts MDA on MDA.HierarchicalIngredientCodeId=MIC.HierarchicalIngredientCodeId
JOIN ClientAllergies CA on CA.AllergenConceptId=MDA.AllergenConceptId
where ISNULL(CA.RecordDeleted,''N'')<>''Y'' and CA.Active = ''Y'' and  CA.ClientId='
            + CAST(@ClientId AS VARCHAR)
            + CASE WHEN LEN(@CurrentMedicationIds) > 0 THEN '  and
MD.MedicationId in (' + @CurrentMedicationIds + ')'
                   ELSE ' and 1=0 '
              END
              
SET @Query = @Query + ' union '  
        
        --  2017 Jan 04	Vithobha
        -- parent ingredient code  
        SET @Query = @Query  
            + 'Select distinct MDA.AllergenConceptId,MD.MedicationNameId,MDA.ConceptDescription,CA.AllergyType  
from MDMedications MD  
inner join MDClinicalFormulations MDC on MD.ClinicalFormulationId=MDC.ClinicalFormulationId  
inner join MDIngredientListIngredientCodes MIC on MIC.IngredientListId=MDC.IngredientListId  
inner join MDHIerarchicalIngredientCodes as HIC on HIC.HierarchicalIngredientCodeId = MIC.HierarchicalIngredientCodeId  
inner join MDAllergenConcepts MDA on MDA.HierarchicalIngredientCodeId=HIC.ParentHierarchicalIngredientCodeId  
JOIN ClientAllergies CA on CA.AllergenConceptId=MDA.AllergenConceptId  
where ISNULL(CA.RecordDeleted,''N'')<>''Y'' and CA.Active = ''Y'' and CA.ClientId='  
            + CAST(@ClientId AS VARCHAR)  
            + CASE WHEN LEN(@CurrentMedicationIds) > 0 THEN '  and  
MD.MedicationId in (' + @CurrentMedicationIds + ')'  
                   ELSE ' and 1=0 '  
              END  


        SET @Query = @Query + ' union '

/* Case Of client is allergetic to a Allergen group*/

        SET @Query = @Query
            + 'Select distinct MDA.AllergenConceptId,MD.MedicationNameId,MDA.ConceptDescription,CA.AllergyType
from MDMedications MD
inner join MDClinicalFormulations MDC on MD.ClinicalFormulationId=MDC.ClinicalFormulationId
inner join MDIngredientListIngredientCodes MIC on MIC.IngredientListId=MDC.IngredientListId
inner join MDAllergenGroupIngredients MDG on MDG.HierarchicalIngredientCodeId=MIC.HierarchicalIngredientCodeId
inner join MDAllergenConcepts MDA on MDA.AllergenGroupId=MDG.AllergenGroupId
JOIN ClientAllergies CA on CA.AllergenConceptId=MDA.AllergenConceptId
where ISNULL(CA.RecordDeleted,''N'')<>''Y'' and CA.Active = ''Y'' and  CA.ClientId='
            + CAST(@ClientId AS VARCHAR)
            + CASE WHEN LEN(@CurrentMedicationIds) > 0 THEN '  and
MD.MedicationId in (' + @CurrentMedicationIds + ')'
                   ELSE ' and 1=0 '
              END

        SET @Query = @Query + ' union '

/* Case Of allergy override */

        SET @Query = @Query
            + 'Select distinct daio.AllergenConceptId,MD.MedicationNameId,MDA.ConceptDescription,CA.AllergyType
from MDMedications MD
join DrugAllergyInteractionOverrides daio on daio.MedicationNameId = MD.MedicationNameId
join ClientAllergies CA on CA.AllergenConceptId=daio.AllergenConceptId
join MDAllergenConcepts as MDA on MDA.AllergenConceptId = daio.AllergenConceptId
where ISNULL(CA.RecordDeleted,''N'')<>''Y'' 
and CA.Active = ''Y''
and CA.ClientId=' + CAST(@ClientId AS VARCHAR)
            + CASE WHEN LEN(@CurrentMedicationIds) > 0 THEN '  and
MD.MedicationId in (' + @CurrentMedicationIds + ')'
                   ELSE ' and 1=0 '
              END + '
and daio.MedicationNameId = md.MedicationNameId
--and daio.DefaultInteractionLevel = ''N''
and daio.AdjustedInteractionLevel = ''Y''
and ((daio.Degree is null) or (daio.Degree ='
            + CAST(ISNULL(@StaffDegree, -1) AS VARCHAR) + '))
and ((daio.PrescriberId is null) or (daio.PrescriberId ='
            + CAST(ISNULL(@PrescriberId, -1) AS VARCHAR) + '))
and ((daio.Specialty is null) or (daio.Specialty ='
            + CAST(ISNULL(@TaxonomyCode, -1) AS VARCHAR) + '))
and isnull(daio.RecordDeleted, ''N'') <> ''Y'''


        SET @query = @query + ') as z 
where not exists (
select *
from DrugAllergyInteractionOverrides as daio
where daio.AllergenConceptId = z.AllergenConceptId
and daio.MedicationNameId = z.MedicationNameId
--and daio.DefaultInteractionLevel = ''Y''
and daio.AdjustedInteractionLevel = ''N''
and ((daio.Degree is null) or (daio.Degree ='
            + CAST(ISNULL(@StaffDegree, -1) AS VARCHAR) + '))
and ((daio.PrescriberId is null) or (daio.PrescriberId ='
            + CAST(ISNULL(@PrescriberId, -1) AS VARCHAR) + '))
and ((daio.Specialty is null) or (daio.Specialty ='
            + CAST(ISNULL(@TaxonomyCode, -1) AS VARCHAR) + '))
and isnull(daio.RecordDeleted, ''N'') <> ''Y''
)'

        PRINT @Query

        EXECUTE sp_executesql @Query


        RETURN @retval

    END TRY
    BEGIN CATCH
        DECLARE @Error VARCHAR(8000)
        SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****'
            + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****'
            + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()),
                     '[ssp_SCGetClientDrugAllergyInteractionWithOverrides]') + '*****'
            + CONVERT(VARCHAR, ERROR_LINE()) + '*****'
            + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****'
            + CONVERT(VARCHAR, ERROR_STATE())

        RAISERROR
 (
  @Error, -- Message text.
  16, -- Severity.
  1 -- State.
 ) ;

    END CATCH

