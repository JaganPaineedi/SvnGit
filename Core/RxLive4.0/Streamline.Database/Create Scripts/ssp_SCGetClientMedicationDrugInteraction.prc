Create  procedure [dbo].[ssp_SCGetClientMedicationDrugInteraction]            
(            
  @MedicationIds varchar(8000)  ,            
  @ClientId int            
)            
as            
Begin Try            
/****************************************************************************/            
/* Stored Procedure: dbo.[ssp_SCGetClientMedicationDrugInteraction]   */            
/* Copyright: 2007 Streamline Healthcare Solutions,  LLC     */            
/* Creation Date:    1/Dec/07            */            
/*                   */            
/* Purpose:  To retrieve Drug Drug interaction details      */            
/* Input Parameters:              */            
/*        @MedicationIds    varchar(8000)         */            
/*            A comma-separated list of MedicationIds to check for   */            
/*            the client.             */            
/*                   */            
/* Output Parameters: None             */            
/*                   */            
/* Return:  0=success, otherwise an error number       */            
/*                   */            
/* Called By: Medication Management           */            
/*                   */            
/* Calls:                 */            
/*                   */            
/* Data Modifications:              */            
/*                   */            
/* Updates:                 */            
/*   Date     Author  Purpose           */            
/*  1/Dec/07    Sony  Created           */            
/*  4/Feb/08    TREMISOSKI Altered based on new logic for     */            
/*                          determining interactions.      */            
/****************************************************************************/            
            
--declare @query nvarchar(4000)            
declare @query nvarchar(MAX)               
            
/*Incase of Drug Drug Interaction */            
set @query='            
select di.DrugDrugInteractionId, mdm.MedicationId, di.SeverityLevel, di.DrugInteractionMonographid, di.InteractionDescription            
from MDMedications as mdm            
join MDDrugDrugInteractionFormulations as dif on dif.ClinicalFormulationid = mdm.ClinicalFormulationId            
join MDDrugDrugInteractions as di on di.DrugDrugInteractionId = dif.DrugDrugInteractionId            
cross join MDMedications as mdm2            
join MDDrugDrugInteractionFormulations as dif2 on dif2.ClinicalFormulationid = mdm2.ClinicalFormulationId            
join MDDrugDrugInteractions as di2 on di2.DrugDrugInteractionId = dif2.DrugDrugInteractionId            
where mdm.MedicationId in (' + @MedicationIds + ')            
and mdm2.MedicationId in (' + @MedicationIds + ')            
and mdm.MedicationId <> mdm2.MedicationId            
-- if drugs share the same drug monograph id, they interact with each other            
and di.DrugInteractionMonographId = di2.DrugInteractionMonographId            
-- if drugs have the same interaction id, they are related or duplicate drugs.            
-- we eventually need to flag these as duplicate therapies            
and di.DrugDrugInteractionId <> di2.DrugDrugInteractionId            
'            
print @Query    
execute sp_executesql @query            
            
/* Case Of client is allergic to a Medication Name */            
            
set @Query='Select distinct MDA.AllergenConceptId,MD.MedicationNameId,MDA.ConceptDescription            
from MDMedications MD            
inner join MDAllergenConcepts MDA on MDA.MedicationNameId=MD.MedicationNameId            
JOIN ClientAllergies CA on CA.AllergenConceptId=MDA.AllergenConceptId            
where ISNULL(CA.RecordDeleted,''N'')<>''Y'' and CA.ClientId='+ cast(@ClientId as varchar) +'  and            
MD.MedicationId in (' + @MedicationIds + ')'            
            
set @Query =  @Query + ' union '            
            
/* Case Of client is allergetic to a Ingredient*/            
            
set @Query =  @Query + 'Select distinct MDA.AllergenConceptId,MD.MedicationNameId,MDA.ConceptDescription            
from MDMedications MD            
inner join MDClinicalFormulations MDC on MD.ClinicalFormulationId=MDC.ClinicalFormulationId            
inner join MDIngredientListIngredientCodes MIC on MIC.IngredientListId=MDC.IngredientListId            
inner join MDAllergenConcepts MDA on MDA.HierarchicalIngredientCodeId=MIC.HierarchicalIngredientCodeId            
JOIN ClientAllergies CA on CA.AllergenConceptId=MDA.AllergenConceptId            
where ISNULL(CA.RecordDeleted,''N'')<>''Y'' and CA.ClientId='+ cast(@ClientId as varchar) + ' and            
MD.MedicationId in (' + @MedicationIds + ')'            
            
            
            
set @Query =  @Query + 'union '            
            
/* Case Of client is allergetic to a Allergen group*/            
            
set @Query =  @Query + 'Select distinct MDA.AllergenConceptId,MD.MedicationNameId,MDA.ConceptDescription            
from MDMedications MD            
inner join MDClinicalFormulations MDC on MD.ClinicalFormulationId=MDC.ClinicalFormulationId            
inner join MDIngredientListIngredientCodes MIC on MIC.IngredientListId=MDC.IngredientListId            
inner join MDAllergenGroupIngredients MDG on MDG.HierarchicalIngredientCodeId=MIC.HierarchicalIngredientCodeId            
inner join MDAllergenConcepts MDA on MDA.AllergenGroupId=MDG.AllergenGroupId            
JOIN ClientAllergies CA on CA.AllergenConceptId=MDA.AllergenConceptId            
where ISNULL(CA.RecordDeleted,''N'')<>''Y'' and CA.ClientId='+ cast(@ClientId as varchar) + ' and            
MD.MedicationId in (' + @MedicationIds + ')'            
   
print   @Query       
execute sp_executesql @Query            
            
end try            
            
BEGIN CATCH            
 declare @Error varchar(8000)            
 set @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())            
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_SCGetClientMedicationDrugInteraction')            
    + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())            
    + '*****' + Convert(varchar,ERROR_STATE())            
            
 RAISERROR            
 (            
  @Error, -- Message text.            
  16, -- Severity.            
  1 -- State.            
 );            
            
END CATCH   


