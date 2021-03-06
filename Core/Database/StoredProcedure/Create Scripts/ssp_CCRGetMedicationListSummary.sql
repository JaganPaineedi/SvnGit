/****** Object:  StoredProcedure [dbo].[ssp_CCRGetMedicationListSummary]    Script Date: 06/09/2015 03:48:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_CCRGetMedicationListSummary]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE PROCEDURE [dbo].[ssp_CCRGetMedicationListSummary] ( @ClientId INT )
AS /******************************************************************************                                              
**  File: [ssp_CCRGetMedicationListSummary]                                          
**  Name: [ssp_CCRGetMedicationListSummary]                     
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
 
 
            SELECT  ISNULL(CONVERT(VARCHAR(10), cm.MedicationStartDate, 21),'''') AS ExactDateTime,
					CONVERT(VARCHAR(100), cm.MedicationStartDate, 101) AS ''StartDate'' ,
					cm.ClientMedicationId AS ID1_ActorID,
					''ClientMedication.'' + CAST(cm.ClientMedicationId AS VARCHAR(100)) AS CCRDataObjectID,
                    ''Medication Start Date'' AS DateType ,
                    ''Medication'' AS [Type],
                    ''Medication ID'' AS ID1_IDType,
                    ''SmartcareWeb'' AS ID1_Source_ActorID,
                    ''SmartcareWeb'' AS SLRCGroup_Source_ActorID,
--as Description,
                    CASE WHEN ISNULL(Discontinued, ''N'') = ''N'' THEN ''Active''
                         WHEN ISNULL(Discontinued, ''N'') = ''Y''
                         THEN ''Discontinued''
                    END AS Status , 

--
-- NEED TO DETERMINE GENERIC NAME
--
                    mn.MedicationName AS ProductName , --Generic Name
                    d.drugid AS Product_ID1_ActorID,
                    ''MedicationName ID'' AS Product_ID1_IDType,
                    ''SmartcareWeb'' AS Product_ID1_Source_ActorID,
                    CONVERT(VARCHAR(30), ( SELECT TOP 1
                                                    RxNormCode
                                           FROM     MDRxNormCodes nc
                                           WHERE    nc.NationalDrugCode = d.NationalDrugCode
                                         )) AS PC1_Code_Value ,
                    ''RxNorm'' AS PC1_Code_CodingSystem ,
                    d.NationalDrugCode AS PC2_Code_Value ,
                    ''NDC'' AS PC2_Code_CodingSystem ,
--
-- NEED TO DETERMINE BRAND NAME
--
                    mn.MedicationName AS BrandName --Brand Name
                    ,
                    ISNULL(m.Strength, '''') + '' ''
                    + ISNULL(m.StrengthUnitOfMeasure, '''') AS ProductStrength_Value,
                    ISNULL(CONVERT(VARCHAR(20), cmi.Quantity), '''') + '' ''
                    + ISNULL(gcU.CodeName, '''') AS Direction_Description  --Dose
                    ,
                    r.RouteAbbreviation AS Direction_Route ,
                    ISNULL(gcS.CodeName, '''') AS Direction_Frequency_Description
            FROM    ClientMedications AS cm
                    LEFT JOIN ClientMedicationInstructions AS cmi ON cmi.ClientMedicationId = cm.ClientMedicationId
                                                              AND ISNULL(cmi.RecordDeleted,
                                                              ''N'') <> ''Y''
                                                              AND ISNULL(cmi.Active,
                                                              ''N'') = ''Y''
                    LEFT JOIN MDMedications m ON m.MedicationId = cmi.StrengthID
                                                 AND ISNULL(m.RecordDeleted,
                                                            ''N'') <> ''Y''
                    LEFT JOIN MDRoutes r ON r.RouteID = m.RouteId
                                            AND ISNULL(r.RecordDeleted, ''N'') <> ''Y''
                    JOIN MDMedicationNames AS mn ON mn.MedicationNameId = cm.MedicationNameId
                                                    AND ISNULL(mn.RecordDeleted,
                                                              ''N'') <> ''Y''
                    LEFT JOIN ( SELECT  ClientMedicationInstructionId ,
                                        MAX(ClientMedicationScriptId) AS ClientMedicationScriptId
                                FROM    ClientMedicationScriptDrugs
                                GROUP BY ClientMedicationInstructionId
                              ) a ON a.ClientMedicationInstructionId = cmi.ClientMedicationInstructionId
                    LEFT JOIN ( SELECT  *
                                FROM    ( SELECT    d1.DrugId ,
                                                    d1.NationalDrugCode ,
                                                    d1.ClinicalFormulationId ,
                                                    mn1.MedicationNameId ,
                                                    row_number() OVER ( PARTITION BY d1.ClinicalFormulationId ORDER BY mn1.MedicationType DESC, d1.dateofadd DESC ) AS rownum
                                          FROM      MDDrugs d1
                                                    JOIN MDMedications m1 ON m1.ClinicalFormulationId = d1.ClinicalFormulationId
                                                    JOIN ClientMedicationInstructions
                                                    AS cmi ON cmi.StrengthId = m1.Medicationid
                                                    JOIN ClientMedications AS cm ON cm.ClientMedicationId = cmi.ClientMedicationid
                                                    JOIN MDMedicationNames mn1 ON mn1.MedicationNameId = m1.MedicationNameId
                                          WHERE     ISNULL(d1.RecordDeleted,
                                                           ''N'') = ''N''
                                                    AND cm.ClientId = @ClientId
                                                    AND d1.obsoletedate IS NULL
                                        ) AS agg
                                WHERE   rownum = 1
                              ) d ON d.ClinicalFormulationId = m.ClinicalFormulationId -- and d.MedicationNameId = mn.MedicationNameId
                    LEFT JOIN ClientMedicationScripts CMS ON CMS.ClientMedicationScriptId = a.ClientMedicationScriptId
                                                             AND ISNULL(CMS.RecordDeleted,
                                                              ''N'') = ''N''
                    LEFT JOIN ClientMedicationScriptDrugs CMSD ON CMSD.ClientMedicationInstructionId = a.ClientMedicationInstructionId
                                                              AND ISNULL(CMSD.RecordDeleted,
                                                              ''N'') = ''N''
                                                              AND a.ClientMedicationScriptId = cmsd.ClientMedicationScriptId
                    LEFT JOIN GlobalCodes AS gcU ON gcU.GlobalCodeId = cmi.Unit
                                                    AND ISNULL(gcU.RecordDeleted,
                                                              ''N'') <> ''Y''
                    LEFT JOIN GlobalCodes AS gcS ON gcS.GlobalCodeId = cmi.Schedule
                                                    AND ISNULL(gcS.RecordDeleted,
                                                              ''N'') <> ''Y''
            WHERE   ISNULL(cm.RecordDeleted, ''N'') <> ''Y''
--and isnull(cm.Ordered,''N'') = ''Y''
                    AND ISNULL(cm.Discontinued, ''N'') <> ''Y''
                    AND @ClientId = cm.ClientId
--and (
--	cm.MedicationStartDate <= @RunDate 
--	and 
--	( cm.MedicationEndDate >= @RunDate 
--	or cm.MedicationEndDate is null
--	)
--)
ORDER BY            mn.MedicationName


              
        END TRY                                                            
                                                                                            
        BEGIN CATCH                
              
            DECLARE @Error VARCHAR(8000)                                                             
            SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + ''*****''
                + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + ''*****''
                + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()),
                         ''[ssp_CCRGetMedicationListSummary]'') + ''*****''
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
