/****** Object:  StoredProcedure [dbo].[ssp_GetComponentXMLString]    Script Date: 06/09/2015 00:50:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetComponentXMLString]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetComponentXMLString]
GO

/****** Object:  StoredProcedure [dbo].[ssp_GetComponentXMLString]    Script Date: 21-07-2016 12:47:22 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================              
-- Author:  Pradeep              
-- Create date: Nov 07, 2014             
-- Description: Retrieves CCD Component XML for CCDA          
/*              
 Author   Modified Date   Reason              
 Shankha        11/04/2014              Initial        
              
*/
CREATE PROCEDURE [dbo].[ssp_GetComponentXMLString] @ServiceId INT = NULL
	,@ClientId INT = NULL
	,@DocumentVersionId INT = NULL
	,@DocumentType VARCHAR(50) = NULL
	
AS
BEGIN
	DECLARE @FinalComponentXML VARCHAR(MAX) = ''
	DECLARE @outputXML VARCHAR(MAX) = ''
	DECLARE @FilterString VARCHAR(MAX) = ''

	IF @DocumentType = 'SOC'
	BEGIN
		SET @ServiceId = NULL
	END
	ELSE
	BEGIN
		SELECT @FilterString = FilterString
		FROM CSFilterData
		WHERE ServiceId = @ServiceId
	END

	IF EXISTS (
			SELECT *
			FROM dbo.fnSplit(@FilterString, ',') AS fs
			WHERE ITEM LIKE '%Allergies=N%'
			)
	BEGIN
		EXEC ssp_GetAllergiesComponentXMLString - 1
			,- 1
			,- 1
			,@outputXML OUTPUT
	END
	ELSE
	BEGIN
		EXEC ssp_GetAllergiesComponentXMLString @ServiceId
			,@ClientId
			,@DocumentVersionId
			,@outputXML OUTPUT
	END

	SET @FinalComponentXML = @FinalComponentXML + IsNULL(@outputXML, '')
	SET @outputXML = ''
	
	IF EXISTS (
			SELECT *
			FROM dbo.fnSplit(@FilterString, ',') AS fs
			WHERE ITEM LIKE '%CurrentMediciation=N%'
			)
	BEGIN
		EXEC ssp_GetMedicationsComponentXMLString - 1
			,- 1
			,- 1
			,@outputXML OUTPUT
	END
	ELSE
	BEGIN
		EXEC ssp_GetMedicationsComponentXMLString @ServiceId
			,@ClientId
			,@DocumentVersionId
			,@outputXML OUTPUT
	END

	SET @FinalComponentXML = @FinalComponentXML + IsNULL(@outputXML, '')
	SET @outputXML = ''

	IF EXISTS (
			SELECT *
			FROM dbo.fnSplit(@FilterString, ',') AS fs
			WHERE ITEM LIKE '%Diagnosis=N%'
			)
	BEGIN
		EXEC ssp_GetProblemsComponentXMLString - 1
			,- 1
			,- 1
			,@outputXML OUTPUT
	END
	ELSE
	BEGIN
		EXEC ssp_GetProblemsComponentXMLString @ServiceId
			,@ClientId
			,@DocumentVersionId
			,@outputXML OUTPUT
	END

	SET @FinalComponentXML = @FinalComponentXML + IsNULL(@outputXML, '')
	SET @outputXML = ''

	IF EXISTS (
			SELECT *
			FROM dbo.fnSplit(@FilterString, ',') AS fs
			WHERE ITEM LIKE '%ProcedureVisit=N%'
			)
	BEGIN
		EXEC ssp_GetProceduresComponentXMLString - 1
			,- 1
			,- 1
			,@outputXML OUTPUT
	END
	ELSE
	BEGIN
		EXEC ssp_GetProceduresComponentXMLString @ServiceId
			,@ClientId
			,@DocumentVersionId
			,@outputXML OUTPUT
	END

	SET @FinalComponentXML = @FinalComponentXML + IsNULL(@outputXML, '')
	SET @outputXML = ''

	IF EXISTS (
			SELECT *
			FROM dbo.fnSplit(@FilterString, ',') AS fs
			WHERE ITEM LIKE '%ResultReviewed=N%'
			)
	BEGIN
		EXEC ssp_GetResultsComponentXMLString - 1
			,- 1
			,- 1
			,@outputXML OUTPUT
	END
	ELSE
	BEGIN
		EXEC ssp_GetResultsComponentXMLString @ServiceId
			,@ClientId
			,@DocumentVersionId
			,@outputXML OUTPUT
	END

	SET @FinalComponentXML = @FinalComponentXML + IsNULL(@outputXML, '')
	SET @outputXML = ''

	----Advance Directives        
	IF (@DocumentType = 'SOC')
	BEGIN
		--exec ssp_GetEncountersFORSOCComponentXMLString @ServiceId,@ClientId,@DocumentVersionId, @outputXML OUTPUT   
		--EXEC ssp_GetEncountersComponentXMLString @ServiceId
		--	,@ClientId
		--	,@DocumentVersionId
		--	,@outputXML OUTPUT

		SET @FinalComponentXML = @FinalComponentXML + IsNULL(@outputXML, '')
		SET @outputXML = ''
	END
	ELSE
	BEGIN
		IF EXISTS (
				SELECT *
				FROM dbo.fnSplit(@FilterString, ',') AS fs
				WHERE ITEM LIKE '%ProcedureInterventions=N%'
				)
		BEGIN
			EXEC ssp_GetEncountersComponentXMLString - 1
				,- 1
				,- 1
				,@outputXML OUTPUT
		END
		ELSE
		BEGIN
			EXEC ssp_GetEncountersComponentXMLString @ServiceId
				,@ClientId
				,@DocumentVersionId
				,@outputXML OUTPUT
		END

		SET @FinalComponentXML = @FinalComponentXML + IsNULL(@outputXML, '')
		SET @outputXML = ''
	END
/*
	----Family History        
	IF EXISTS (
			SELECT *
			FROM dbo.fnSplit(@FilterString, ',') AS fs
			WHERE ITEM LIKE '%ImmunizationAdministrated=N%'
			)
	BEGIN
		EXEC ssp_GetImmunizationsComponentXMLString - 1
			,- 1
			,- 1
			,@outputXML OUTPUT
	END
	ELSE
	BEGIN
		EXEC ssp_GetImmunizationsComponentXMLString @ServiceId
			,@ClientId
			,@DocumentVersionId
			,@outputXML OUTPUT
	END

	SET @FinalComponentXML = @FinalComponentXML + IsNULL(@outputXML, '')
	SET @outputXML = ''
*/
	
	
	----Payers        
	IF EXISTS (
			SELECT *
			FROM dbo.fnSplit(@FilterString, ',') AS fs
			WHERE ITEM LIKE '%SmokingStatus=N%'
			)
	BEGIN
		EXEC ssp_GetSocialHistoryComponentXMLString - 1
			,- 1
			,- 1
			,@outputXML OUTPUT
	END
	ELSE
	BEGIN
		EXEC ssp_GetSocialHistoryComponentXMLString @ServiceId
			,@ClientId
			,@DocumentVersionId
			,@outputXML OUTPUT
	END

	SET @FinalComponentXML = @FinalComponentXML + IsNULL(@outputXML, '')
	SET @outputXML = ''

	IF EXISTS (
			SELECT *
			FROM dbo.fnSplit(@FilterString, ',') AS fs
			WHERE ITEM LIKE '%ShowVitals=N%'
			)
	BEGIN
		EXEC ssp_GetVitalSignsComponentXMLString - 1
			,- 1
			,- 1
			,@outputXML OUTPUT
	END
	ELSE
	BEGIN
		EXEC ssp_GetVitalSignsComponentXMLString @ServiceId
			,@ClientId
			,@DocumentVersionId
			,@outputXML OUTPUT
	END

	SET @FinalComponentXML = @FinalComponentXML + IsNULL(@outputXML, '')
	SET @outputXML = ''
	
	IF EXISTS (
			SELECT *
			FROM dbo.fnSplit(@FilterString, ',') AS fs
			WHERE ITEM LIKE '%VisitReason=N%'
			)
	BEGIN
		EXEC ssp_GetReasonForVisitComponentXMLString - 1
			,- 1
			,- 1
			,@outputXML OUTPUT
	END
	ELSE
	BEGIN
		EXEC ssp_GetReasonForVisitComponentXMLString @ServiceId
			,@ClientId
			,@DocumentVersionId
			,@outputXML OUTPUT
	END
	
	IF (@DocumentType <>  'SOC')
	BEGIN
		SET @FinalComponentXML = @FinalComponentXML + IsNULL(@outputXML, '')
	END
	
	SET @outputXML = ''

	IF EXISTS (
			SELECT *
			FROM dbo.fnSplit(@FilterString, ',') AS fs
			WHERE ITEM LIKE '%ReferralProviders=N%'
			)
	BEGIN
		EXEC ssp_GetReasonForReferralComponentXMLString - 1
			,- 1
			,- 1
			,@outputXML OUTPUT
	END
	ELSE
	BEGIN
		EXEC ssp_GetReasonForReferralComponentXMLString @ServiceId
			,@ClientId
			,@DocumentVersionId
			,@outputXML OUTPUT
	END

	SET @FinalComponentXML = @FinalComponentXML + IsNULL(@outputXML, '')
	SET @outputXML = ''

	--IF EXISTS (
	--		SELECT *
	--		FROM dbo.fnSplit(@FilterString, ',') AS fs
	--		WHERE ITEM LIKE '%PlanofCare=N%'
	--		)
	--BEGIN
	--	EXEC ssp_GetPlanOfCareComponentXMLString - 1
	--		,- 1
	--		,- 1
	--		,@outputXML OUTPUT
	--END
	--ELSE
	/*
	BEGIN
		EXEC ssp_GetPlanOfCareComponentXMLString @ServiceId
			,@ClientId
			,@DocumentVersionId
			,@outputXML OUTPUT
	END

	SET @FinalComponentXML = @FinalComponentXML + IsNULL(@outputXML, '')
	SET @outputXML = ''
*/
	IF EXISTS (
			SELECT *
			FROM dbo.fnSplit(@FilterString, ',') AS fs
			WHERE ITEM LIKE '%VisitReason=N%'
			)
	BEGIN
		EXEC ssp_GetHistoryofPresentIllnessComponentXMLString - 1
			,- 1
			,- 1
			,@outputXML OUTPUT
	END
	ELSE
	BEGIN
		EXEC ssp_GetHistoryofPresentIllnessComponentXMLString @ServiceId
			,@ClientId
			,@DocumentVersionId
			,@outputXML OUTPUT
	END

	SET @FinalComponentXML = @FinalComponentXML + IsNULL(@outputXML, '')
	SET @outputXML = ''

	----Functional Status        
	IF EXISTS (
			SELECT *
			FROM dbo.fnSplit(@FilterString, ',') AS fs
			WHERE ITEM LIKE '%MedicationAdministrated=N%'
			)
	BEGIN
		EXEC ssp_GetMedAdministeredComponentXMLString - 1
			,- 1
			,- 1
			,@outputXML OUTPUT
	END
	ELSE
	BEGIN
		EXEC ssp_GetMedAdministeredComponentXMLString @ServiceId
			,@ClientId
			,@DocumentVersionId
			,@outputXML OUTPUT
	END

	SET @FinalComponentXML = @FinalComponentXML + IsNULL(@outputXML, '')
	SET @outputXML = ''

	IF EXISTS (
			SELECT *
			FROM dbo.fnSplit(@FilterString, ',') AS fs
			WHERE ITEM LIKE '%ClinicalInstruction=N%'
			)
	BEGIN
		EXEC ssp_GetClinicalInstructionComponentXMLString - 1
			,- 1
			,- 1
			,@outputXML OUTPUT
	END
	ELSE
	BEGIN
		EXEC ssp_GetClinicalInstructionComponentXMLString @ServiceId
			,@ClientId
			,@DocumentVersionId
			,@outputXML OUTPUT
	END

	SET @FinalComponentXML = @FinalComponentXML + IsNULL(@outputXML, '')
	SET @outputXML = ''

	IF @DocumentType = 'SOC'
	BEGIN
		EXEC ssp_GetFunctionalStatusComponentXMLString @ServiceId
			,@ClientId
			,@DocumentVersionId
			,@outputXML OUTPUT

		SET @FinalComponentXML = @FinalComponentXML + IsNULL(@outputXML, '')
		SET @outputXML = ''
	END

	IF @DocumentType = 'SOC'
	BEGIN
		EXEC ssp_GetDischargeInstructionComponentXMLString @ServiceId
			,@ClientId
			,@DocumentVersionId
			,@outputXML OUTPUT

		SET @FinalComponentXML = @FinalComponentXML + IsNULL(@outputXML, '')
		SET @outputXML = ''
	END

	SET @FinalComponentXML = '<component><structuredBody>' + @FinalComponentXML + '</structuredBody></component>'

	PRINT @FinalComponentXML

	SELECT @FinalComponentXML
END


GO


