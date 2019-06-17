/****** Object:  StoredProcedure [dbo].[ssp_MMGetAlternativeMedicationNamesNDC]    Script Date: 07/31/2013 12:29:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_MMGetAlternativeMedicationNamesNDC]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_MMGetAlternativeMedicationNamesNDC]
GO

/****** Object:  StoredProcedure [dbo].[ssp_MMGetAlternativeMedicationNamesNDC]    Script Date: 07/31/2013 12:29:40 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
--select * from MDDrugs where LabelName like '%prozac%' order by clinicalformulationid desc
--exec [ssp_MMGetAlternativeMedicationNamesNDC] '54868303300'

CREATE procedure [dbo].[ssp_MMGetAlternativeMedicationNamesNDC]
   /******************************************************************/
   /* PROCEDURE: ssp_MMGetAlternativeMedicationNamesNDC                 */
   /*                                                                */
   /* PURPOSE: Retrieve equivalent medication name for a			 */
   /* given NDC.  Include the MedicationNameId for the NDC passed to */
   /* proc.                                                          */
   /*                                                                */
   /* PARAMETERS:                                                    */
   /*    - @NationalDrugCode (varchar) - the NDC for which all       */
   /*    medication names should be found.                           */
   /*                                                                */
   /* RETURNS:                                                       */
   /*    1 Result set containing a distinct list of addtional        */
   /*    MedicationNameId's that are equivalent to the NDC           */
   /*    in formulation.  Result set may be empty.                   */
   /*                                                                */
   /* CALLED BY: Medication Management application.                  */
   /*                                                                */
   /* CHANGE LOG:                                                    */
   /*    TER - 02/11/2010 - Created.                                 */
   /******************************************************************/

   @NationalDrugCode varchar(100)
as

declare @MedicationNameId int

select top 1 @MedicationNameId = m.MedicationNameId
from MDMedications as m
join MDDrugs as d on d.ClinicalFormulationId = m.ClinicalFormulationId
where d.NationalDrugCode = @NationalDrugCode
and m.Status = 4881
and ISNULL(d.RecordDeleted, 'N') <> 'Y'
and ISNULL(m.recordDeleted, 'N') <> 'Y'

declare @results table (
   MedicationNameId int not null primary key,
   MedicationType int,
   MedicationName varchar(100)
)

print @MedicationNameId

insert into @results (
	MedicationNameId,
	--MedicationType,
	MedicationName
)
exec ssp_MMGetAlternativeMedicationNames @MedicationNameId

insert into @results (
	MedicationNameId,
	MedicationType,
	MedicationName
)
select m.MedicationNameId,
	m.MedicationType,
	m.MedicationName
from MDMedicationNames as m
where MedicationNameId = @MedicationNameId
and not exists (
	select *
	from @results as r
	where r.MedicationNameId = m.MedicationNameId
)


select r.MedicationNameId, r.MedicationName
from @results as r
order by r.MedicationName

GO
