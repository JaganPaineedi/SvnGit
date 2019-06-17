if exists ( select  *
            from    sys.objects
            where   OBJECT_ID = object_id(N'[dbo].[ssp_SCUpdateUserDefinedAllergenConcepts]')
                    and TYPE in ( N'P', N'PC' ) ) 
    drop procedure [dbo].[ssp_SCUpdateUserDefinedAllergenConcepts]
GO

set QUOTED_IDENTIFIER on
set ANSI_NULLS on
GO

create proc [dbo].[ssp_SCUpdateUserDefinedAllergenConcepts] ( @ClientId int )
as /***************************************************************************/
/* Stored Procedure: ssp_SCUpdateUserDefinedAllergenConcepts	           */
/* Purpose: Merge data from UserDefinedAllergies to MDAllergenConcepts     */
/* Author: Wasif Butt													   */
/* Data Modifications: MDAllergenConcepts insert/update                    */
/***************************************************************************/
/*       Date       Author          Purpose								   */
/*	Sep 30 2014		Wasif Butt		Created - Allow user defined allergies */
/*												in SC/RX				   */
/***************************************************************************/ 
    begin try
        begin tran
/**Insert New User Defined Allergen Concepts **/
;
        with    cte_insert
                  as ( select   *
                       from     dbo.UserDefinedAllergies
                       where    AllergenConceptId is null
                     )
            insert  into dbo.MDAllergenConcepts
                    ( CreatedBy
                    , CreatedDate
                    , ModifiedBy
                    , ModifiedDate
                    , RecordDeleted
                    , DeletedBy
                    , DeletedDate
                    , ConceptDescription
		            )
                    select  'UserDefinedSync'
                          , CreatedDate
                          , 'UserDefinedSync'
                          , ModifiedDate
                          , RecordDeleted
                          , DeletedBy
                          , DeletedDate
                          , ConceptDescription
                    from    cte_insert
/** Update AllergenConceptIds for inserted rows **/
        update  uda
        set     AllergenConceptId = mac.AllergenConceptId
        from    dbo.UserDefinedAllergies as uda
                join dbo.MDAllergenConcepts as mac on uda.ConceptDescription = mac.ConceptDescription
        where   uda.AllergenConceptId is null
                and mac.ExternalConceptId is null
                and mac.ConceptIdType is null
/** Update allergies updated since last sync **/
        update  mac
        set     ConceptDescription = uda.ConceptDescription
              , ModifiedDate = uda.ModifiedDate
              , RecordDeleted = uda.RecordDeleted
              , DeletedBy = uda.DeletedBy
              , DeletedDate = uda.DeletedDate
        from    dbo.UserDefinedAllergies as uda
                join dbo.MDAllergenConcepts as mac on uda.AllergenConceptId = mac.AllergenConceptId
        where   uda.ModifiedDate <> mac.ModifiedDate
                and mac.ExternalConceptId is null
                and mac.ConceptIdType is null
	commit
    end try

    begin catch
        declare @Error varchar(8000)

        set @Error = convert(varchar, error_number()) + '*****'
            + convert(varchar(4000), error_message()) + '*****'
            + isnull(convert(varchar, error_procedure()),
                     'ssp_SCUpdateUserDefinedAllergenConcepts') + '*****'
            + convert(varchar, error_line()) + '*****'
            + convert(varchar, error_severity()) + '*****'
            + convert(varchar, error_state())

        raiserror (
			@Error
			,-- Message text.                            
			16
			,-- Severity.                            
			1 -- State.                            
			);
    end catch
GO
