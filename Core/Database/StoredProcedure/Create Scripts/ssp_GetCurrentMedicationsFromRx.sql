IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetCurrentMedicationsFromRx]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_GetCurrentMedicationsFromRx]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



create PROCEDURE [dbo].[ssp_GetCurrentMedicationsFromRx] (
	@ClientID INT
	,@DateOfService DATETIME
	,@EffectiveDate DATETIME
	,@DocumentVersionId INT = NULL
	)
AS
/********************************************************************************                                                             
--            
-- Copyright: Streamline Healthcare Solutions            
-- "Eligibility Determination"          
-- Purpose: stored procedure for Task #12 - CCC - Customizations  - Medication section should pull latest medication from Rx and populate the table/section for Medications in SC   
--          Instead of creating custom stored procedure, This wil be in core and the Medication table will be in core folder which can be reused in all custom documents								       
-- Author:  Malathi Shiva      
-- Date:    May-18-2018   
-- *****History****            
 Date   	Author               Reason        
10/15/18	Shankha		     Modified the logic to return 1 resultset that can be used by both UI and RDL   
03/30/2019  Musman           concat function does not work on 2008 server,
                             so we replaced with COALESCE function similar to concat
            
*********************************************************************************/
BEGIN
	BEGIN TRY
		IF ISNULL(@DocumentVersionId, 0) <> 0
		BEGIN
			SELECT @ClientId = d.ClientId				
				,@EffectiveDate = D.EffectiveDate
				,@DateOfService = s.DateOfService
			FROM Documents d
			LEFT JOIN Services S ON d.ServiceId = s.ServiceId
			WHERE d.InProgressDocumentVersionId = @DocumentVersionId
		END

		IF (@DateOfService = '')
			SET @DateOfService = GETDATE()

		IF (@EffectiveDate = '')
			SET @EffectiveDate = @DateOfService -- GETDATE()

		--CURRENT MEDICATIONS
		 SELECT cm.ClientMedicationId          
   ,MDM.MedicationName AS MedicationName          
   ,STUFF((          
     SELECT COALESCE (          
       ' <br/>' + CHAR(13) + Convert(VARCHAR(10), CMS.[OrderDate], 101)         
       , ' <br/>' + CHAR(13) +Convert(VARCHAR(10), '', 101)          
       ) AS OrderDate          
     FROM ClientMedicationScriptDrugs CMSD          
     JOIN ClientMedicationInstructions cmi2 ON cmi2.ClientMedicationInstructionId = CMSD.ClientMedicationInstructionId          
     LEFT JOIN ClientMedicationScripts CMS ON CMS.ClientMedicationScriptId = CMSD.ClientMedicationScriptId          
     WHERE cmi2.ClientMedicationId = cm.ClientMedicationId          
      AND ISNULL(CMSD.RecordDeleted, 'N') = 'N'          
      AND ISNULL(cmi2.RecordDeleted, 'N') = 'N'          
     ORDER BY cm.ClientMedicationId          
     FOR XML PATH('')          
      ,type          
     ).value('.', 'nvarchar(max)'), 1, 1, ' ') AS OrderDate          
   ,STUFF((          
     SELECT COALESCE (          
       ' <br/>' + CHAR(13) + dbo.ssf_EMNoteGetMedicationInstruction(CMI2.ClientMedicationInstructionId)         
       , ' <br/>' + CHAR(13) +''         
       ) AS StrengthDescription          
     FROM ClientMedicationInstructions cmi2          
     WHERE cmi2.ClientMedicationId = cm.ClientMedicationId          
      AND ISNULL(cmi2.RecordDeleted, 'N') = 'N'          
     ORDER BY cm.ClientMedicationId          
     FOR XML PATH('')          
      ,type          
     ).value('.', 'nvarchar(max)'), 1, 1, ' ') AS StrengthDescription          
   ,STUFF((          
     SELECT COALESCE (          
       ' <br/>' + CHAR(13) + Convert(VARCHAR(10), CMSD.[StartDate], 101)           
       ,' <br/>' + CHAR(13) +Convert(VARCHAR(10), '', 101)          
       ) AS RXStartDate          
     FROM ClientMedicationScriptDrugs CMSD          
     JOIN ClientMedicationInstructions cmi2 ON cmi2.ClientMedicationInstructionId = CMSD.ClientMedicationInstructionId          
     WHERE cmi2.ClientMedicationId = cm.ClientMedicationId          
      AND ISNULL(CMSD.RecordDeleted, 'N') = 'N'          
      AND ISNULL(cmi2.RecordDeleted, 'N') = 'N'          
     ORDER BY cm.ClientMedicationId          
     FOR XML PATH('')          
      ,type          
     ).value('.', 'nvarchar(max)'), 1, 1, ' ') AS RXStartDate          
   ,STUFF((          
     SELECT COALESCE (          
       ' <br/>' + CHAR(13) + Convert(VARCHAR(10), CMSD.[EndDate], 101)            
       ,' <br/>' + CHAR(13) +Convert(VARCHAR(10), '', 101)          
       ) AS RXEndDate          
     FROM ClientMedicationScriptDrugs CMSD          
     JOIN ClientMedicationInstructions cmi2 ON cmi2.ClientMedicationInstructionId = CMSD.ClientMedicationInstructionId          
     WHERE cmi2.ClientMedicationId = cm.ClientMedicationId          
      AND ISNULL(CMSD.RecordDeleted, 'N') = 'N'          
      AND ISNULL(cmi2.RecordDeleted, 'N') = 'N'          
     ORDER BY cm.ClientMedicationId          
     FOR XML PATH('')          
      ,type          
     ).value('.', 'nvarchar(max)'), 1, 1, ' ') AS RXEndDate          
   ,STUFF((          
     SELECT COALESCE (          
       ' <br/>' + CHAR(13) + Convert(VARCHAR(10), CMSD.[Refills], 101)           
       ,' <br/>' + CHAR(13) +''         
       ) AS Refills          
     FROM ClientMedicationScriptDrugs CMSD          
     JOIN ClientMedicationInstructions cmi2 ON cmi2.ClientMedicationInstructionId = CMSD.ClientMedicationInstructionId          
     WHERE cmi2.ClientMedicationId = cm.ClientMedicationId          
      AND ISNULL(CMSD.RecordDeleted, 'N') = 'N'          
      AND ISNULL(cmi2.RecordDeleted, 'N') = 'N'          
     ORDER BY cm.ClientMedicationId          
     FOR XML PATH('')          
      ,type          
     ).value('.', 'nvarchar(max)'), 1, 1, ' ') AS Refills          
   ,PrescriberName          
   ,'CURRENTMEDS' AS ResultType          
  FROM ClientMedications cm          
  JOIN MDMedicationNames MDM ON CM.MedicationNameId = MDM.MedicationNameId          
  JOIN ClientMedicationInstructions cmi ON cmi.clientMedicationid = CM.clientMedicationid          
  WHERE CM.CLientId = @ClientID          
   AND CAST(CM.MedicationStartDate AS DATE) <= CAST(@EffectiveDate AS DATE)          
   AND (          
    ISNULL(cm.discontinued, 'N') = 'N'          
    OR (          
     ISNULL(cm.discontinued, 'N') = 'N'          
     AND cast(CM.DiscontinueDate AS DATE) >= CAST(@EffectiveDate AS DATE)          
     )          
    )          
   AND ISNULL(cm.RecordDeleted, 'N') = 'N'          
   AND ISNULL(cmi.RecordDeleted, 'N') = 'N'          
   AND ISNULL(CM.Ordered, 'N') = 'Y'          
             
   AND EXISTS (          
   SELECT 1          
   FROM dbo.ClientMedicationScriptActivities AS cmsa          
   JOIN ClientMedicationScriptDrugs CMSD ON cmsa.ClientMedicationScriptId = CMSD.ClientMedicationScriptId          
   JOIN ClientMedicationInstructions cmi3 ON cmi3.ClientMedicationInstructionId = CMSD.ClientMedicationInstructionId          
   WHERE cmi3.ClientMedicationId = cm.ClientMedicationId          
    AND ISNULL(cmsa.RecordDeleted, 'N') = 'N'          
   )          
             
  GROUP BY cm.ClientMedicationId          
   ,MedicationName          
   ,PrescriberName  
		
		UNION
		
		--DISCONTINUED MEDICATIONS
		SELECT cm.ClientMedicationId          
   ,MDM.MedicationName AS MedicationName          
   ,STUFF((          
     SELECT COALESCE (          
       ' <br/>' + CHAR(13) + Convert(VARCHAR(10), CMS.[OrderDate], 101)         
       ,' <br/>' + CHAR(13) +''          
       ) AS OrderDate          
     FROM ClientMedicationScriptDrugs CMSD          
     JOIN ClientMedicationInstructions cmi2 ON cmi2.ClientMedicationInstructionId = CMSD.ClientMedicationInstructionId          
     LEFT JOIN ClientMedicationScripts CMS ON CMS.ClientMedicationScriptId = CMSD.ClientMedicationScriptId          
     WHERE cmi2.ClientMedicationId = cm.ClientMedicationId          
      AND ISNULL(CMSD.RecordDeleted, 'N') = 'N'                AND ISNULL(cmi2.RecordDeleted, 'N') = 'N'          
     ORDER BY cm.ClientMedicationId          
     FOR XML PATH('')          
      ,type          
     ).value('.', 'nvarchar(max)'), 1, 1, ' ') AS OrderDate          
   ,STUFF((          
     SELECT COALESCE (          
       ' <br/>' + CHAR(13) + dbo.ssf_EMNoteGetMedicationInstruction(CMI2.ClientMedicationInstructionId)      
       ,' <br/>' + CHAR(13) +''         
       ) AS StrengthDescription          
     FROM ClientMedicationInstructions cmi2          
     WHERE cmi2.ClientMedicationId = cm.ClientMedicationId          
      AND ISNULL(cmi2.RecordDeleted, 'N') = 'N'          
     ORDER BY cm.ClientMedicationId          
     FOR XML PATH('')          
      ,type          
     ).value('.', 'nvarchar(max)'), 1, 1, ' ') AS StrengthDescription          
   ,STUFF((          
     SELECT COALESCE (          
       ' <br/>' + CHAR(13) + Convert(VARCHAR(10), CMSD.[StartDate], 101)         
       ,' <br/>' + CHAR(13) +Convert(VARCHAR(10), '', 101)          
       ) AS RXStartDate          
     FROM ClientMedicationScriptDrugs CMSD          
     JOIN ClientMedicationInstructions cmi2 ON cmi2.ClientMedicationInstructionId = CMSD.ClientMedicationInstructionId          
     WHERE cmi2.ClientMedicationId = cm.ClientMedicationId          
      AND ISNULL(CMSD.RecordDeleted, 'N') = 'N'          
      AND ISNULL(cmi2.RecordDeleted, 'N') = 'N'          
     ORDER BY cm.ClientMedicationId          
     FOR XML PATH('')          
      ,type          
     ).value('.', 'nvarchar(max)'), 1, 1, ' ') AS RXStartDate          
   ,STUFF((          
     SELECT COALESCE (          
       ' <br/>' + CHAR(13)  + Convert(VARCHAR(10), CMSD.[EndDate], 101)        
       ,' <br/>' + CHAR(13) +Convert(VARCHAR(10), '', 101)          
       ) AS RXEndDate          
     FROM ClientMedicationScriptDrugs CMSD          
     JOIN ClientMedicationInstructions cmi2 ON cmi2.ClientMedicationInstructionId = CMSD.ClientMedicationInstructionId          
     WHERE cmi2.ClientMedicationId = cm.ClientMedicationId          
      AND ISNULL(CMSD.RecordDeleted, 'N') = 'N'          
      AND ISNULL(cmi2.RecordDeleted, 'N') = 'N'          
     ORDER BY cm.ClientMedicationId          
     FOR XML PATH('')          
      ,type          
     ).value('.', 'nvarchar(max)'), 1, 1, ' ') AS RXEndDate          
   ,STUFF((          
     SELECT COALESCE (          
       ' <br/>' + CHAR(13) +  Convert(VARCHAR(10), CMSD.[Refills], 101)         
       ,' <br/>' + CHAR(13) +Convert(VARCHAR(10), '', 101)          
       ) AS Refills          
     FROM ClientMedicationScriptDrugs CMSD          
     JOIN ClientMedicationInstructions cmi2 ON cmi2.ClientMedicationInstructionId = CMSD.ClientMedicationInstructionId          
     WHERE cmi2.ClientMedicationId = cm.ClientMedicationId          
      AND ISNULL(CMSD.RecordDeleted, 'N') = 'N'          
      AND ISNULL(cmi2.RecordDeleted, 'N') = 'N'          
     ORDER BY cm.ClientMedicationId          
     FOR XML PATH('')          
      ,type          
     ).value('.', 'nvarchar(max)'), 1, 1, ' ') AS Refills          
   ,PrescriberName          
   ,'DISCONTINUEDMEDS' AS ResultType          
  FROM ClientMedications cm          
  JOIN MDMedicationNames MDM ON CM.MedicationNameId = MDM.MedicationNameId          
  JOIN ClientMedicationInstructions cmi ON cmi.clientMedicationid = CM.clientMedicationid          
  WHERE CM.CLientId = @ClientID          
   AND CAST(ISNULL(CM.MedicationStartDate, cm.createdDate) AS DATE) <= CAST(@EffectiveDate AS DATE)          
   AND (          
    cast(CM.DiscontinueDate AS DATE) >= CAST(@EffectiveDate AS DATE)          
    AND ISNULL(cm.discontinued, 'N') = 'Y'          
    )          
   AND ISNULL(cm.RecordDeleted, 'N') = 'N'          
   AND ISNULL(cmi.RecordDeleted, 'N') = 'N'          
  GROUP BY cm.ClientMedicationId          
   ,MedicationName          
   ,PrescriberName     
		
		UNION
		
		--SELF REPORTED MEDICATIONS
		SELECT cm.ClientMedicationId          
   ,MDM.MedicationName AS MedicationName          
   ,STUFF((          
     SELECT COALESCE (          
       ' <br/>' + CHAR(13) + Convert(VARCHAR(10), CMS.[OrderDate], 101)          
       ,' <br/>' + CHAR(13) +Convert(VARCHAR(10), '', 101)          
       ) AS OrderDate          
     FROM ClientMedicationScriptDrugs CMSD          
     JOIN ClientMedicationInstructions cmi2 ON cmi2.ClientMedicationInstructionId = CMSD.ClientMedicationInstructionId          
     LEFT JOIN ClientMedicationScripts CMS ON CMS.ClientMedicationScriptId = CMSD.ClientMedicationScriptId          
     WHERE cmi2.ClientMedicationId = cm.ClientMedicationId          
      AND ISNULL(CMSD.RecordDeleted, 'N') = 'N'          
      AND ISNULL(cmi2.RecordDeleted, 'N') = 'N'          
     ORDER BY cm.ClientMedicationId          
     FOR XML PATH('')          
      ,type          
     ).value('.', 'nvarchar(max)'), 1, 1, ' ') AS OrderDate          
   ,STUFF((          
     SELECT COALESCE (          
       ' <br/>' + CHAR(13) + dbo.ssf_EMNoteGetMedicationInstruction(CMI2.ClientMedicationInstructionId)            
       ,' <br/>' + CHAR(13) +''          
       ) AS StrengthDescription          
     FROM ClientMedicationInstructions cmi2          
     WHERE cmi2.ClientMedicationId = cm.ClientMedicationId          
      AND ISNULL(cmi2.RecordDeleted, 'N') = 'N'          
     ORDER BY cm.ClientMedicationId          
     FOR XML PATH('')          
      ,type          
     ).value('.', 'nvarchar(max)'), 1, 1, ' ') AS StrengthDescription          
   ,STUFF((          
     SELECT COALESCE (          
       ' <br/>' + CHAR(13) +  Convert(VARCHAR(10), CMSD.[StartDate], 101)         
       ,' <br/>' + CHAR(13) +Convert(VARCHAR(10), '', 101)          
       ) AS RXStartDate          
     FROM ClientMedicationScriptDrugs CMSD          
     JOIN ClientMedicationInstructions cmi2 ON cmi2.ClientMedicationInstructionId = CMSD.ClientMedicationInstructionId          
     WHERE cmi2.ClientMedicationId = cm.ClientMedicationId          
      AND ISNULL(CMSD.RecordDeleted, 'N') = 'N'          
      AND ISNULL(cmi2.RecordDeleted, 'N') = 'N'          
     ORDER BY cm.ClientMedicationId          
     FOR XML PATH('')          
      ,type          
     ).value('.', 'nvarchar(max)'), 1, 1, ' ') AS RXStartDate          
   ,STUFF((          
     SELECT COALESCE (          
       ' <br/>' + CHAR(13) + Convert(VARCHAR(10), CMSD.[EndDate], 101)             
       ,' <br/>' + CHAR(13) +Convert(VARCHAR(10), '', 101)          
       ) AS RXEndDate          
     FROM ClientMedicationScriptDrugs CMSD          
     JOIN ClientMedicationInstructions cmi2 ON cmi2.ClientMedicationInstructionId = CMSD.ClientMedicationInstructionId          
     WHERE cmi2.ClientMedicationId = cm.ClientMedicationId          
      AND ISNULL(CMSD.RecordDeleted, 'N') = 'N'          
      AND ISNULL(cmi2.RecordDeleted, 'N') = 'N'          
     ORDER BY cm.ClientMedicationId          
     FOR XML PATH('')          
      ,type          
     ).value('.', 'nvarchar(max)'), 1, 1, ' ') AS RXEndDate          
   ,STUFF((          
     SELECT COALESCE (          
       ' <br/>' + CHAR(13) + Convert(VARCHAR(10), CMSD.[Refills], 101)         
       ,' <br/>' + CHAR(13) +Convert(VARCHAR(10), '', 101)          
       ) AS Refills          
     FROM ClientMedicationScriptDrugs CMSD          
     JOIN ClientMedicationInstructions cmi2 ON cmi2.ClientMedicationInstructionId = CMSD.ClientMedicationInstructionId          
     WHERE cmi2.ClientMedicationId = cm.ClientMedicationId          
      AND ISNULL(CMSD.RecordDeleted, 'N') = 'N'          
      AND ISNULL(cmi2.RecordDeleted, 'N') = 'N'          
     ORDER BY cm.ClientMedicationId          
     FOR XML PATH('')          
      ,type          
     ).value('.', 'nvarchar(max)'), 1, 1, ' ') AS Refills          
   ,PrescriberName          
   ,'SELFREPORTEDMEDS' AS ResultType          
  FROM ClientMedications cm          
  JOIN MDMedicationNames MDM ON CM.MedicationNameId = MDM.MedicationNameId          
  JOIN ClientMedicationInstructions cmi ON cmi.clientMedicationid = CM.clientMedicationid          
  WHERE CM.CLientId = @ClientID          
   AND CAST(ISNULL(CM.MedicationStartDate, cm.createdDate) AS DATE) <= CAST(@EffectiveDate AS DATE)          
   AND (          
    ISNULL(cm.discontinued, 'N') = 'N'          
    OR (          
     ISNULL(cm.discontinued, 'N') = 'N'          
     AND cast(CM.DiscontinueDate AS DATE) >= CAST(@EffectiveDate AS DATE)          
     )          
    )          
   AND ISNULL(cm.RecordDeleted, 'N') = 'N'          
   AND ISNULL(cmi.RecordDeleted, 'N') = 'N'          
   AND ISNULL(CM.Ordered, 'N') = 'N'          
  GROUP BY cm.ClientMedicationId          
   ,MedicationName          
   ,PrescriberName          
  ORDER BY ResultType          
   ,MedicationName   
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), '[ssp_GetCurrentMedicationsFromRx]') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.  
				16
				,-- Severity.  
				1 -- State.  
				);
	END CATCH
END
