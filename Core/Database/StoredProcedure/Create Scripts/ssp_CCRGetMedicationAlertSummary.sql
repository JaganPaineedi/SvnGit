/****** Object:  StoredProcedure [dbo].[ssp_CCRGetMedicationAlertSummary]    Script Date: 06/09/2015 03:48:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_CCRGetMedicationAlertSummary]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'


CREATE PROCEDURE [dbo].[ssp_CCRGetMedicationAlertSummary] ( @ClientId INT )
AS /******************************************************************************                                              
**  File: [ssp_CCRGetMedicationAlertSummary]                                          
**  Name: [ssp_CCRGetMedicationAlertSummary]                     
**  Desc:    
**  Return values:                                          
**  Called by:                                               
**  Parameters:                          
**  Auth:  srf
**  Date:  12/13/2011                                         
*******************************************************************************                                              
**  Change History                                              
*******************************************************************************                                              
**  Date:       Author:       Description:                            
**  
**  -------------------------------------------------------------------------            
*******************************************************************************/                                            
  
  
    BEGIN                                                            
                  
        BEGIN TRY   
 
            SELECT  ''AL.'' + CAST(ca.ClientAllergyId AS VARCHAR(100)) AS CCRDataObjectID ,
                    ''SmartcareWeb'' AS ID1_Source_ActorID ,
                    ''Client Allergy ID'' AS ID1_IDType ,
                    --SUBSTRING(CONVERT(VARCHAR(50), ca.CreatedDate, 127), 1, 22)
                    --+ ''-5:00'' AS ExactDateTime ,
                    SUBSTRING(CONVERT(VARCHAR(50), ca.CreatedDate, 127), 1, 22) AS ApproximateDateTime ,
                    ca.ClientAllergyId AS ID1_ActorID ,
                    ''SmartcareWeb'' AS SLRCGroup_Source_ActorID ,
                    CASE WHEN ca.AllergyType = ''A'' THEN ''Allergy''
						WHEN ca.AllergyType = ''I'' THEN ''Intolerance''
						WHEN ca.AllergyType = ''F'' THEN ''Failed Trial'' ELSE '''' END AS [Type] ,
                    ''416098002'' AS Code_Value ,
                    ''SNOMED CT'' AS Code_CodingSystem ,
                    mn.MedicationName AS Description ,
                    ''Active'' AS Status ,
                    mn.MedicationNameId AS Product_ID1_ActorID ,
                    ''MedicationName ID'' AS Product_ID1_IDType ,
                    ''SmartcareWeb'' AS Product_ID1_Source_ActorID ,
                    mn.MedicationName AS ProductName ,
                    CONVERT(VARCHAR(30), ( SELECT TOP 1
                                                    RxNormCode
                                           FROM     MDRxNormCodes nc
                                           WHERE    nc.NationalDrugCode = d.NationalDrugCode
                                         )) AS PC1_Code_Value ,
                    ''RxNorm'' AS PC1_Code_CodingSystem ,
                    '''' AS Result1_CCRDataObjectID ,
                    ca.Comment AS Reaction1_Description
            FROM    ClientAllergies ca
                    JOIN MDAllergenConcepts ac ON ac.AllergenConceptId = ca.AllergenConceptId
                    LEFT JOIN MDMedicationNames mn ON mn.MedicationNameId = ac.MedicationNameId
                    LEFT JOIN ( SELECT  *
                                FROM    ( SELECT    d1.DrugId ,
                                                    d1.NationalDrugCode ,
                                                    ca1.AllergenConceptId ,
                                                    mn1.MedicationNameId ,
                                                    row_number() OVER ( PARTITION BY ca1.AllergenConceptId ORDER BY mn1.MedicationType DESC, d1.dateofadd DESC ) AS rownum
                                          FROM      ClientAllergies ca1
                                                    JOIN MDAllergenConcepts ac1 ON ac1.AllergenConceptId = ca1.AllergenConceptId
                                                    JOIN MDMedicationNames mn1 ON mn1.MedicationNameId = ac1.MedicationNameId
                                                    JOIN MDMedications m1 ON m1.MedicationNameId = mn1.MedicationNameId
                                                    JOIN MDDrugs d1 ON d1.ClinicalFormulationId = m1.ClinicalFormulationId
                                          WHERE     ISNULL(d1.RecordDeleted,
                                                           ''N'') = ''N''
                                                    AND ISNULL(ca1.RecordDeleted,
                                                              ''N'') = ''N''
                                                    AND ISNULL(ac1.RecordDeleted,
                                                              ''N'') = ''N''
                                                    AND ISNULL(mn1.RecordDeleted,
                                                              ''N'') = ''N''
                                                    AND ISNULL(m1.RecordDeleted,
                                                              ''N'') = ''N''
                                                    AND ca1.ClientId = @ClientId 
                                        ) AS agg
                                WHERE   rownum = 1
                              ) d ON d.MedicationNameId = ac.MedicationNameId
            WHERE   ca.ClientId = @ClientId
                    AND ISNULL(ca.RecordDeleted, ''N'') = ''N''
                    AND ISNULL(ac.RecordDeleted, ''N'') = ''N''
                    AND ISNULL(mn.RecordDeleted, ''N'') = ''N''

        END TRY                                                            
                                                                                            
        BEGIN CATCH                
              
            DECLARE @Error VARCHAR(8000)                                                             
            SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + ''*****''
                + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + ''*****''
                + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()),
                         ''[ssp_CCRGetMedicationAlertSummary]'') + ''*****''
                + CONVERT(VARCHAR, ERROR_LINE()) + ''*****''
                + CONVERT(VARCHAR, ERROR_SEVERITY()) + ''*****''
                + CONVERT(VARCHAR, ERROR_STATE())
            RAISERROR                                                                                           
 (                                                             
  @Error, -- Message text.                                                                                          
  16, -- Severity.                                                                                          
  1 -- State.                                                                                          
 ) ;                                                                                       
        END CATCH                                      
    END



' 
END
GO
