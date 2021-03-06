/****** Object:  StoredProcedure [dbo].[ssp_CCRCSGetImmunizations]    Script Date: 06/09/2015 03:48:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_CCRCSGetImmunizations]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[ssp_CCRCSGetImmunizations] (	
	 @ClientId INT
	,@ServiceId INT = NULL
	,@DocumentVersionId INT = NULL
	)
AS
BEGIN
	BEGIN TRY
		DECLARE @DOS DATETIME = NULL
		DECLARE @DocumentCodeId INT

		IF (@ServiceId IS NOT NULL)
		BEGIN
			SELECT @DOS = DateOfService
			FROM Services
			WHERE ServiceId = @ServiceId
		END
		ELSE IF (@ServiceId IS NULL	AND @DocumentVersionId IS NOT NULL)
		BEGIN
			SELECT TOP 1 @DOS = EffectiveDate
				,@DocumentCodeId = DocumentCodeId
			FROM Documents
			WHERE InProgressDocumentVersionId = @DocumentVersionId
			AND ISNULL(RecordDeleted,''N'')=''N''
		END

		IF ((@DocumentCodeId = 1611) OR (@ServiceId IS NULL	AND @DocumentVersionId IS NULL))
			SET @DOS = NULL
 
		SELECT DISTINCT CONVERT(VARCHAR(10), ci.AdministeredDateTime, 101) AS ExactDateTime
			,CONVERT(VARCHAR(100), ci.AdministeredDateTime, 101) AS ''StartDate''
			,ci.ClientImmunizationId AS ID1_ActorID
			,''ClientImmunization.'' + CAST(ci.ClientImmunizationId AS VARCHAR(100)) AS CCRDataObjectID
			,''Immunization Start Date'' AS DateType
			,''Immunization'' AS [Type]
			,''Immunization ID'' AS ID1_IDType
			,''SmartcareWeb'' AS ID1_Source_ActorID
			,''SmartcareWeb'' AS SLRCGroup_Source_ActorID
			,dbo.ssf_GetGlobalCodeNameById(ci.VaccineStatus) AS STATUS
			,dbo.csf_GetGlobalCodeNameById(ci.VaccineNameId) AS ProductName
			,'''' AS Product_ID1_ActorID
			,''Immunization ID'' AS Product_ID1_IDType
			,''SmartcareWeb'' AS Product_ID1_Source_ActorID
			,'''' AS PC1_Code_Value
			,'''' AS PC1_Code_CodingSystem
			,'''' AS PC2_Code_Value
			,'''' AS PC2_Code_CodingSystem
			,dbo.ssf_GetGlobalCodeNameById(ci.ManufacturerId) AS BrandName
			,CONVERT(VARCHAR(100), ci.AdministeredAmount) + '' '' + dbo.ssf_GetGlobalCodeNameById(ci.AdministedAmountType) AS ProductStrength_Value
			,'''' AS Direction_Description
			,'''' AS Direction_Route
			,'''' AS Direction_Frequency_Description
		FROM ClientImmunizations ci
		WHERE ClientId = @ClientId
			AND ISNULL(RecordDeleted, ''N'') = ''N''			
			AND (@DOS IS NULL OR (CAST(AdministeredDateTime AS DATE) = CAST(@DOS AS DATE)))
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + ''*****'' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + ''*****'' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), ''ssp_CCRCSGetImmunizations'') + ''*****'' + CONVERT(VARCHAR, ERROR_LINE()) + ''*****'' + CONVERT(VARCHAR, ERROR_SEVERITY()) + ''*****'' + CONVERT(VARCHAR, ERROR_STATE())

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
