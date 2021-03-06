/****** Object:  StoredProcedure [dbo].[ssp_CCRSCGetMedicationListServiceSummary]    Script Date: 06/09/2015 03:48:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_CCRSCGetMedicationListServiceSummary]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[ssp_CCRSCGetMedicationListServiceSummary] (  
 @ClientId INT  
 ,@ServiceId INT  
 ,@DocumentVersionId INT =NULL  
 )  
AS  
-- =============================================        
-- Author:  Pradeep        
-- Create date: Sept 19, 2014        
-- Description: Retrieves CCR Message        
/*        
 Author   Modified Date   Reason        
     
        
*/  
-- =============================================     
BEGIN  
 BEGIN TRY  
   
  DECLARE @LastScriptIdTable TABLE (
			ClientMedicationInstructionId INT
			,ClientMedicationScriptId INT
			)

		INSERT INTO @LastScriptIdTable (
			ClientMedicationInstructionId
			,ClientMedicationScriptId
			)
		SELECT ClientMedicationInstructionId
			,ClientMedicationScriptId
		FROM (
			SELECT cmsd.ClientMedicationInstructionId
				,cmsd.ClientMedicationScriptId
				,cms.OrderDate
				,ROW_NUMBER() OVER (
					PARTITION BY cmsd.ClientMedicationInstructionId ORDER BY cms.OrderDate DESC
						,cmsd.ClientMedicationScriptId DESC
					) AS rownum
			FROM ClientMedicationScriptDrugs cmsd
			INNER JOIN ClientMedicationScripts cms ON (cmsd.ClientMedicationScriptId = cms.ClientMedicationScriptId)
			WHERE ClientMedicationInstructionId IN (
					SELECT ClientMedicationInstructionId
					FROM clientmedications a
					INNER JOIN dbo.ClientMedicationInstructions b ON (a.ClientMedicationId = b.ClientMedicationId)
					WHERE a.ClientId = @ClientId
						AND ISNULL(a.RecordDeleted, ''N'') = ''N''
						AND ISNULL(b.Active, ''Y'') = ''Y''
						AND ISNULL(b.RecordDeleted, ''N'') = ''N''
					)
				AND ISNULL(cmsd.RecordDeleted, ''N'') = ''N''
				AND ISNULL(cms.RecordDeleted, ''N'') = ''N''
				AND ISNULL(cms.Voided, ''N'') = ''N''
			) AS a
		WHERE rownum = 1
  
  SELECT DISTINCT ISNULL(CONVERT(VARCHAR(10), cm.MedicationStartDate, 21), '''') AS ExactDateTime  
     ,CONVERT(VARCHAR(100), cm.MedicationStartDate, 101) AS ''StartDate''  
     ,cm.ClientMedicationId AS ID1_ActorID  
     ,''ClientMedication.'' + CAST(cm.ClientMedicationId AS VARCHAR(100)) AS CCRDataObjectID  
     ,''Medication Start Date'' AS DateType  
     ,''Medication'' AS [Type]  
     ,''Medication ID'' AS ID1_IDType  
     ,''SmartcareWeb'' AS ID1_Source_ActorID  
     ,''SmartcareWeb'' AS SLRCGroup_Source_ActorID  
     ,''Active'' AS STATUS  
     ,MDM.MedicationName AS ProductName  
     ,'''' AS Product_ID1_ActorID   
     ,''MedicationName ID'' AS Product_ID1_IDType  
     ,''SmartcareWeb'' AS Product_ID1_Source_ActorID  
     ,'''' AS PC1_Code_Value  
     ,''RxNorm'' AS PC1_Code_CodingSystem  
     ,NC.RXNormcode AS PC2_Code_Value  
     ,''NDC'' AS PC2_Code_CodingSystem  
     ,MDM.MedicationName AS BrandName --Brand Name   
     ,ISNULL(MD.Strength, '''') + '' '' + ISNULL(MD.StrengthUnitOfMeasure, '''') AS ProductStrength_Value  
     ,ISNULL(CONVERT(VARCHAR(20), CMI.Quantity), '''') + '' '' + ISNULL(GC.CodeName, '''') AS Direction_Description --Dose    
     ,MR.RouteAbbreviation AS Direction_Route  
     ,ISNULL(GC1.CodeName, '''') AS Direction_Frequency_Description       
  FROM ClientMedicationInstructions CMI
		INNER JOIN ClientMedications CM ON (
				CMI.ClientMedicationId = CM.ClientMedicationId
				AND ISNULL(cm.RecordDeleted, ''N'') <> ''Y''
				)
		LEFT JOIN GlobalCodes GC ON (GC.GlobalCodeID = CMI.Unit)
			AND ISNULL(gc.RecordDeleted, ''N'') <> ''Y''
		LEFT JOIN GlobalCodes GC1 ON (GC1.GlobalCodeId = CMI.Schedule)
			AND ISNULL(gc1.RecordDeleted, ''N'') <> ''Y''
		INNER JOIN MDMedicationNames MDM ON (
				CM.MedicationNameId = MDM.MedicationNameId
				AND ISNULL(mdm.RecordDeleted, ''N'') <> ''Y''
				)
		INNER JOIN MDMedications MD ON (
				MD.MedicationID = CMI.StrengthId
				AND ISNULL(md.RecordDeleted, ''N'') <> ''Y''
				)
		INNER JOIN MDRoutes MR ON (
				MD.RouteID = MR.RouteID
				AND ISNULL(md.RecordDeleted, ''N'') <> ''Y''
				)
		LEFT JOIN MDDrugs DR ON (
				DR.ClinicalFormulationId = md.ClinicalFormulationId
				AND ISNULL(md.RecordDeleted, ''N'') <> ''Y''
				)
		LEFT JOIN MDRxNormCodes NC ON (
				NC.NationalDrugCode = DR.NationalDrugCode
				AND ISNULL(DR.RecordDeleted, ''N'') <> ''Y''
				)
		INNER JOIN ClientMedicationScriptDrugs CMSD ON (
				CMI.ClientMedicationInstructionId = CMSD.ClientMedicationInstructionId
				AND ISNULL(CMSD.RecordDeleted, ''N'') <> ''Y''
				)
		LEFT JOIN @LastScriptIdTable LSId ON (
				cmi.ClientMedicationInstructionId = LSId.ClientMedicationInstructionId
				AND cmsd.ClientMedicationScriptId = LSId.ClientMedicationScriptId
				)
		LEFT JOIN dbo.ClientMedicationScripts AS cms ON cms.ClientMedicationScriptId = LSId.ClientMedicationScriptId
		WHERE cm.ClientId = @ClientId
			AND cm.discontinuedate IS NULL
			AND Isnull(Discontinued, ''N'') <> ''Y''
			AND (isnull(MedicationEndDate, Getdate()) >= GetDate())
			AND (isnull(MedicationStartDate, Getdate()) <= GetDate())
			AND ISNULL(cmi.Active, ''Y'') = ''Y''
			AND ISNULL(cmi.RecordDeleted, ''N'') <> ''Y''
			AND (
				CMSD.ClientMedicationScriptId IS NULL
				OR CMSD.ClientMedicationScriptId = LSId.ClientMedicationScriptId
				)
		ORDER BY MDM.MedicationName
 END TRY  
  
 BEGIN CATCH  
  DECLARE @Error VARCHAR(8000)  
  
  SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + ''*****'' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + ''*****'' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), ''[ssp_CCRSCGetMedicationListServiceSummary]'') + ''*****'' + CONVERT(VARCHAR, ERROR_LINE()) + ''*****'' 
+ CONVERT(VARCHAR, ERROR_SEVERITY()) + ''*****'' + CONVERT(VARCHAR, ERROR_STATE())  
  
  RAISERROR (  
    @Error  
    ,-- Message text.                                                                                              
    16  
    ,-- Severity.                                                                                              
    1 -- State.                                                                                              
    );  
 END CATCH  
END  
' 
END
GO
