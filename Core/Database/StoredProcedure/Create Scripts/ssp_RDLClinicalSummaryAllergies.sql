/****** Object:  StoredProcedure [dbo].[ssp_RDLClinicalSummaryAllergies]    Script Date: 06/11/2015 17:28:02 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLClinicalSummaryAllergies]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_RDLClinicalSummaryAllergies]
GO

/****** Object:  StoredProcedure [dbo].[ssp_RDLClinicalSummaryAllergies]    Script Date: 06/11/2015 17:28:02 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_RDLClinicalSummaryAllergies]
    @ServiceId INT = NULL ,
    @ClientId INT ,
    @DocumentVersionId INT = NULL
AS /******************************************************************************
**  File: ssp_RDLClinicalSummaryAllergies.sql
**  Name: ssp_RDLClinicalSummaryAllergies
**  Desc:
**
**  Return values: <Return Values>
**
**  Called by: <Code file that calls>
**
**  Parameters:
**  Input   Output
**  ServiceId      -----------
**
**  Created By: Veena S Mani
**  Date:  Feb 24 2014
*******************************************************************************
**  Change History
*******************************************************************************
**  Date:  Author:    Description:
**  --------  --------    -------------------------------------------
**  02/05/2014   Veena S Mani        Added parameters ClientId and EffectiveDate-Meaningful Use #18
**  19/05/2014  Veena S Mani        Added parameters DocumentId and removed EffectiveDate to make SP reusable for MeaningfulUse #7,#18 and #24.Also added the logic for the same.

*******************************************************************************/
    BEGIN
        --SET NOCOUNT ON;

        BEGIN TRY
        
            DECLARE @DisplayTable INT 
			
            IF NOT EXISTS ( SELECT  *
                            FROM    dbo.ClientAllergies
                            WHERE   ClientId = @ClientId
                                    AND ISNULL(RecordDeleted, 'N') = 'N' )
                OR EXISTS ( SELECT  *
                            FROM    CLients
                            WHERE   CLientId = @ClientId
                                    AND ISNULL(NoKnownAllergies, 'N') = 'Y' )
                BEGIN
			
                    SELECT  @DisplayTable = 0
			
                END
        
            SELECT  ac.ConceptDescription AS Description ,
                    CA.Comment AS Comments ,
                    CASE ca.AllergyType
                      WHEN 'A' THEN 'Allergy'
                      WHEN 'I' THEN 'Intolerance'
                      WHEN 'F' THEN 'Failed Trial'
                    END AS Allergy ,
                    CASE ca.Active
                      WHEN 'Y' THEN 'Active'
                      ELSE 'Inactive'
                    END AS STATUS ,
                    CA.SNOMEDCode ,
                    CONVERT(VARCHAR(12), CA.CreatedDate, 101) AS DATE ,
                    CONVERT(VARCHAR(30), ( SELECT TOP 1
                                                    RxNormCode
                                           FROM     MDRxNormCodes nc
                                           WHERE    nc.NationalDrugCode = d.NationalDrugCode
                                                    AND ISNULL(nc.RecordDeleted, 'N') <> 'Y'
                                           ORDER BY CASE WHEN nc.RxNormCode IN ( 7982, 2670, 1191 ) THEN 0
                                                         ELSE 1
                                                    END
                                         )) AS NormCode ,
                    --DBO.ssf_GetRxNormCodeByAllergenConceptId(CA.AllergenConceptId) AS NormCode ,
                    d.NationalDrugCode ,
                   -- '' AS NationalDrugCode,
                    @DisplayTable AS DisplayTable
            FROM    ClientAllergies CA
                    INNER JOIN MDAllergenConcepts ac ON ac.AllergenConceptId = ca.AllergenConceptId
                    LEFT JOIN ( SELECT  *
                                FROM    ( SELECT    d1.DrugId ,
                                                    d1.NationalDrugCode ,
                                                    ca1.AllergenConceptId ,
                                                    mn1.MedicationNameId ,
                                                    ROW_NUMBER() OVER ( PARTITION BY ca1.AllergenConceptId ORDER BY mn1.MedicationType DESC
       , d1.dateofadd DESC ) AS rownum
                                          FROM      ClientAllergies ca1
                                                    INNER JOIN MDAllergenConcepts ac1 ON ac1.AllergenConceptId = ca1.AllergenConceptId
                                                    INNER JOIN MDMedicationNames mn1 ON mn1.MedicationNameId = ac1.MedicationNameId
                                                    INNER JOIN MDMedications m1 ON m1.MedicationNameId = mn1.MedicationNameId
                                                    INNER JOIN MDDrugs d1 ON d1.ClinicalFormulationId = m1.ClinicalFormulationId
                                          WHERE     ISNULL(d1.RecordDeleted, 'N') = 'N'
                                                    AND ISNULL(ca1.RecordDeleted, 'N') = 'N'
                                                    AND ISNULL(ac1.RecordDeleted, 'N') = 'N'
                                                    AND ISNULL(mn1.RecordDeleted, 'N') = 'N'
                                                    AND ISNULL(m1.RecordDeleted, 'N') = 'N'
                                                    AND ca1.ClientId = @ClientId
                                        ) AS agg
                                WHERE   rownum = 1
                                UNION
                                SELECT  *
                                FROM    ( SELECT    dg.DrugId ,
                                                    dg.NationalDrugCode ,
                                                    ac.AllergenConceptId ,
                                                    m1.MedicationNameId ,
                                                    ROW_NUMBER() OVER ( PARTITION BY ca1.AllergenConceptId ORDER BY CASE WHEN rxn.RxNormCode IN ( 7982, 2670, 1191 ) THEN 0
                                                                                                                         ELSE 1
                                                                                                                    END, mn1.MedicationType DESC
       , dg.dateofadd DESC ) AS rownum
                                          FROM      ClientAllergies AS ca1
                                                    JOIN MDAllergenConcepts AS ac ON ac.AllergenConceptId = ca1.AllergenConceptId
                                                    JOIN MDHierarchicalIngredientCodes AS hic ON hic.HierarchicalIngredientCodeId = ac.HierarchicalIngredientCodeId
                                                    JOIN MDIngredientListIngredientCodes AS ilic ON ilic.HierarchicalIngredientCodeId = hic.HierarchicalIngredientCodeId
                                                    JOIN MDClinicalFormulations AS cf ON cf.IngredientListId = ilic.IngredientListId
                                                    JOIN MDDrugs AS dg ON dg.ClinicalFormulationId = cf.ClinicalFormulationId
                                                    JOIN MDMedications AS m1 ON m1.ClinicalFormulationId = dg.ClinicalFormulationId
                                                    JOIN MDMedicationNames AS mn1 ON mn1.MedicationNameId = m1.MedicationNameId
                                                    LEFT JOIN dbo.MDRxNormCodes AS rxn ON rxn.NationalDrugCode = dg.NationalDrugCode
                                                                                          AND ISNULL(rxn.RecordDeleted, 'N') <> 'Y'
                                          WHERE     ca1.ClientId = @ClientId
                                                    AND ISNULL(ca1.RecordDeleted, 'N') = 'N'
                                                    AND ISNULL(ac.RecordDeleted, 'N') = 'N'
                                                    AND ISNULL(ilic.RecordDeleted, 'N') = 'N'
                                                    AND ISNULL(cf.RecordDeleted, 'N') = 'N'
                                                    AND ISNULL(dg.RecordDeleted, 'N') = 'N'
                                                    AND ISNULL(m1.RecordDeleted, 'N') = 'N'
                                                    AND ISNULL(mn1.RecordDeleted, 'N') = 'N'
                                        ) AS agg
                                WHERE   rownum = 1
                                UNION
   -- speical case when hierarchical ingredient code has no ingredient list entries
                                SELECT  *
                                FROM    ( SELECT    dg.DrugId ,
                                                    dg.NationalDrugCode ,
                                                    ac1.AllergenConceptId ,
                                                    m1.MedicationNameId ,
                                                    ROW_NUMBER() OVER ( PARTITION BY ca1.AllergenConceptId ORDER BY mn1.MedicationType DESC
       , dg.dateofadd DESC ) AS rownum
                                          FROM      ClientAllergies AS ca1
                                                    JOIN MDAllergenConcepts AS ac1 ON ac1.AllergenConceptId = ca1.AllergenConceptId
                                                    JOIN ( SELECT   dg.ClinicalFormulationId ,
                                                                    4977 AS ExternalConceptId ,
                                                                    COUNT(*) AS NumDrugs
                                                           FROM     MDDrugs AS dg
                                                                    JOIN dbo.MDRxNormCodes AS rxn ON rxn.NationalDrugCode = dg.NationalDrugCode
                                                           WHERE    LabelName LIKE 'Penicillin G%'
                                                                    AND rxn.RxNormCode = 7982
                                                                    AND ISNULL(dg.RecordDeleted, 'N') = 'N'
                                                                    AND ISNULL(rxn.RecordDeleted, 'N') = 'N'
                                                           GROUP BY dg.ClinicalFormulationId
                                                         ) AS cf ON ac1.ExternalConceptId = 4977
                                                    JOIN MDDrugs AS dg ON dg.ClinicalFormulationId = cf.ClinicalFormulationId
                                                    JOIN MDMedications AS m1 ON m1.ClinicalFormulationId = dg.ClinicalFormulationId
                                                    JOIN MDMedicationNames AS mn1 ON mn1.MedicationNameId = m1.MedicationNameId
                                          WHERE     ca1.ClientId = @ClientId
                                                    AND NOT EXISTS ( SELECT *
                                                                     FROM   MDIngredientListIngredientCodes AS ilic
                                                                     WHERE  ilic.HierarchicalIngredientCodeId = ac1.HierarchicalIngredientCodeId
                                                                            AND ISNULL(ilic.RecordDeleted, 'N') = 'N' )
                                                    AND ISNULL(ca1.RecordDeleted, 'N') = 'N'
                                                    AND ISNULL(ac1.RecordDeleted, 'N') = 'N'
                                                    AND ISNULL(dg.RecordDeleted, 'N') = 'N'
                                                    AND ISNULL(m1.RecordDeleted, 'N') = 'N'
                                                    AND ISNULL(mn1.RecordDeleted, 'N') = 'N'
                                        ) AS agg
                                WHERE   rownum = 1
                              ) d ON d.AllergenConceptId = ac.AllergenConceptId
                    LEFT JOIN MDMedicationNames mn ON mn.MedicationNameId = d.MedicationNameId
            WHERE   ca.ClientId = @ClientId
                    AND ISNULL(ca.RecordDeleted, 'N') = 'N'
                    AND ISNULL(ac.RecordDeleted, 'N') = 'N'
                    --AND ISNULL(mn.RecordDeleted, 'N') = 'N'
        END TRY

        BEGIN CATCH
            DECLARE @Error VARCHAR(8000)

            SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_RDLClinicalSummaryAllergies') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

            RAISERROR (
    @Error
    ,-- Message text.
    16
    ,-- Severity.
    1 -- State.
    );
        END CATCH
    END


GO


