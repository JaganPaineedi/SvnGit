/****** Object:  StoredProcedure [dbo].[ssp_MMGetNDCMedicationDetails]    Script Date: 07/31/2013 12:29:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_MMGetNDCMedicationDetails]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_MMGetNDCMedicationDetails]
GO

/****** Object:  StoredProcedure [dbo].[ssp_MMGetNDCMedicationDetails]    Script Date: 07/31/2013 12:29:40 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
--select * from MDDrugs where LabelName like '%prozac%' order by clinicalformulationid desc
--exec [ssp_MMGetNDCMedicationDetails] '54868303300'

create procedure [dbo].[ssp_MMGetNDCMedicationDetails]
   /******************************************************************/
   /* PROCEDURE: ssp_MMGetNDCMedicationDetails                 */
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
   /*    1 Result set containing MedicationNameId equivalent to NDC. */
   /*    Result set may be empty.									 */
   /*                                                                */
   /* CALLED BY: Medication Management application.                  */
   /*                                                                */
   /* CHANGE LOG:                                                    */
   /*    Wasif Butt - 05/11/2010 - Created.                          */
   /******************************************************************/
    @NationalDrugCode varchar(100)
as 
    declare @MedicationNameId int

    select top 1
            @MedicationNameId = m.MedicationNameId
    from    MDMedications as m
            join MDDrugs as d on d.ClinicalFormulationId = m.ClinicalFormulationId
    where   d.NationalDrugCode = @NationalDrugCode
            and m.Status = 4881
            and isnull(d.RecordDeleted, 'N') <> 'Y'
            and isnull(m.recordDeleted, 'N') <> 'Y'

    declare @results table
        (
          MedicationNameId int not null
                               primary key
        , MedicationType int
        , MedicationName varchar(100)
        , Strength varchar(25)
        , StrengthUnitOfMeasure varchar(25)
        , RouteId int
        , RouteAbbreviation varchar(50)
        )

    print @MedicationNameId

    insert  into @results
            ( MedicationNameId
            ,
	--MedicationType,
              MedicationName
            )
            exec ssp_MMGetAlternativeMedicationNames @MedicationNameId

    insert  into @results
            ( MedicationNameId
            , MedicationName
            )
            select  m.MedicationNameId
                  , m.MedicationName
            from    MDMedicationNames as m
            where   MedicationNameId = @MedicationNameId
                    and not exists ( select *
                                     from   @results as r
                                     where  r.MedicationNameId = m.MedicationNameId )

    select  m.MedicationNameId
          , mmn.MedicationName
          , m.Strength
          , m.StrengthUnitOfMeasure
          , case when mmn.MedicationType = 1 then 'Y'
                 else 'N'
            end as isBrand
          , m.RouteId
          , mr.RouteAbbreviation
    from    @results as r 
			join MDMedications as m on r.MedicationNameId = m.MedicationNameId
            join MDDrugs as d on d.ClinicalFormulationId = m.ClinicalFormulationId
            join dbo.MDMedicationNames as mmn on m.MedicationNameId = mmn.MedicationNameId
            join dbo.MDRoutes as mr on m.RouteId = mr.RouteId
    where   
			d.NationalDrugCode = @NationalDrugCode
            and m.Status = 4881
            and isnull(d.RecordDeleted, 'N') <> 'Y'
            and isnull(m.recordDeleted, 'N') <> 'Y'
    order by m.MedicationNameId



GO
