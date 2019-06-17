
/****** Object:  StoredProcedure [dbo].[scsp_MMDosageRangeInfoByMedicationNamePediatric]    Script Date: 08/03/2015 17:51:15 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[scsp_MMDosageRangeInfoByMedicationNamePediatric]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[scsp_MMDosageRangeInfoByMedicationNamePediatric]
GO

/****** Object:  StoredProcedure [dbo].[scsp_MMDosageRangeInfoByMedicationNamePediatric]    Script Date: 08/03/2015 17:51:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

  
create procedure [dbo].[scsp_MMDosageRangeInfoByMedicationNamePediatric]  
/***************************************************************************************************/    
/* PROCEDURE: scsp_MMDosageRangeInfoByMedicationNamePediatric                   */    
/*                                                 */    
/* PURPOSE: Calculate the dosage ranges for a medication name based on the Pediatric dosage range */  
/* tables.                                            */    
/*                                                 */    
/* CALLED BY: SmartCareRx                                     */    
/*                                                 */    
/* CHANGE LOG:                                           */    
/* TER - 03/04/2010 - Created.                                 */  
/* TER - 05/25/2010 - Remove trailing zeroes from dosage ranges.                  */  
/*                                                 */    
/***************************************************************************************************/    
   @MedicationNameId int,  
   @DOB datetime,  
   @EffectiveDate datetime = null  
as  
  
declare @DosageString varchar(500)  
declare @ClinicalFormulationId int, @CountFormulations int  
declare @AgeInDays int  
  
if @EffectiveDate is null begin set @EffectiveDate = getdate() end  
   
set @DosageString = ''  
set @AgeInDays = datediff(day, @DOB, @EffectiveDate)  
  
select @ClinicalFormulationId = max(mdm.ClinicalFormulationId), @CountFormulations = count(*)  
from MDMedications as mdm  
join MDPediatricDosageRanges as pdr on pdr.ClinicalFormulationId = mdm.ClinicalFormulationId  
where mdm.MedicationNameId = @MedicationNameId  
and mdm.Status = 4881  
and pdr.MinimumAgeInDays <= @AgeInDays  
and pdr.MaximumAgeInDays >= @AgeInDays  
and isnull(mdm.RecordDeleted, 'N') <> 'Y'  
and isnull(pdr.RecordDeleted, 'N') <> 'Y'  
  
if @ClinicalFormulationId is not null  
begin  
  
   select @DosageString = isnull('Recommended Min/Max Daily Dose Strength: '  
    + dbo.scsf_MMDosageRangeRemoveTrailingZeroes(cast(MinimumDailyDoseStrengthQuantity as varchar))  
      + ' ' + MinimumDailyDoseStrengthUnitsDescriptionAbbreviation  
      + ' - '  
      + dbo.scsf_MMDosageRangeRemoveTrailingZeroes(cast(MaximumDailyDoseStrengthQuantity as varchar))  
      + ' ' + MaximumDailyDoseStrengthUnitsDescriptionAbbreviation, '')  
   from MDPediatricDosageRanges  
   where ClinicalFormulationId = @ClinicalFormulationId  
   and MinimumAgeInDays <= @AgeInDays  
   and MaximumAgeInDays >= @AgeInDays  
   and isnull(RecordDeleted, 'N') <> 'Y'  
  
  
end  
  
if @DosageString = ''  
begin  
   set @DosageString = 'Pediatric Recommended Dosage Ranges Not Available For This Medication.'  
end  
  
select @DosageString  
  
  
GO


