/****** Object:  UserDefinedFunction [dbo].[csf_GetMedicationInstruction]    Script Date: 06/12/2015 15:59:33 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csf_GetMedicationInstruction]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[csf_GetMedicationInstruction]
GO


/****** Object:  UserDefinedFunction [dbo].[csf_GetMedicationInstruction]    Script Date: 06/12/2015 15:59:33 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


Create FUNCTION [dbo].[csf_GetMedicationInstruction]
	(
	  @ClientMedicationInstructionId INT
	)
RETURNS VARCHAR(1000)

/*********************************************************************************/          
/* FUNCTION: csf_GetMedicationInstruction										 */ 
/* Copyright: Streamline Healthcare Solutions									 */          
/* Creation Date:  11-April-2012												 */   
/* Created By   :  Jagdeep Hundal												 */          
/* Purpose: Used by psychNote													 */         
/* Input Parameters: @ClientMedicationId										 */        
/* Output Parameters:															 */
/* Return:																	     */          
/* Called By: 																	 */          
/* Calls:																		 */          
/* Data Modifications:															 */          
/* Updates:																		 */          
/* Date				Author        Purpose						 */       
/* 09-May -2013     Jagdeep       What:   Added ClientMedicationInstructions.Active check 
								  Why: As per task #3107-Psych Note; SmartCareRx medication- Thresholds-Bugs/Features (Offshore)				  
	Oct 7 2013		Chuck Blaine	Changed function so that it pulls text for individual instructions rather than combining all instruction text
									for a client medication Ref task (Thresholds - Support #252)*/
/*  3/25/2015		Steczynski	  Format Quantity to drop trailing zeros, applied dbo.ssf_RemoveTrailingZeros, Task 215 */
/*********************************************************************************/
AS 
	BEGIN
		DECLARE	@MedicationInstruction VARCHAR(MAX)
		SELECT DISTINCT
				@MedicationInstruction = COALESCE(@MedicationInstruction
												  + ', ', '')
				+ ( MD.StrengthDescription + ' '
					+ dbo.ssf_RemoveTrailingZeros(CMI.Quantity) + ' '
					+ CONVERT(VARCHAR, GC.CodeName) + ' '
					+ CONVERT(VARCHAR, GC1.CodeName) )
		FROM	ClientMedicationInstructions CMI
				LEFT JOIN GlobalCodes GC ON ( GC.GlobalCodeID = CMI.Unit )
											AND ISNULL(gc.RecordDeleted, 'N') <> 'Y'
				LEFT JOIN GlobalCodes GC1 ON ( GC1.GlobalCodeId = CMI.Schedule )
											 AND ISNULL(gc1.RecordDeleted, 'N') <> 'Y'
				JOIN MDMedications MD ON ( MD.MedicationID = CMI.StrengthId )
				JOIN ClientMedicationScriptDrugs CMSD ON CMI.ClientMedicationInstructionId = CMSD.ClientMedicationInstructionId
														 AND ISNULL(CMSD.RecordDeleted,
															  'N') <> 'Y'
		WHERE	CMI.ClientMedicationInstructionId = @ClientMedicationInstructionId
				AND ISNULL(CMI.Active, 'Y') = 'Y' 

		RETURN @MedicationInstruction;
	END   

GO


