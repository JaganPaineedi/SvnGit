/****** Object:  UserDefinedFunction [dbo].[sfn_GetClientOrderDiagnosis]    Script Date: 04/07/2016 17:24:59 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[sfn_GetClientOrderDiagnosis]')
			AND type IN (
				N'FN'
				,N'IF'
				,N'TF'
				,N'FS'
				,N'FT'
				)
		)
	DROP FUNCTION [dbo].[sfn_GetClientOrderDiagnosis]
GO

/****** Object:  UserDefinedFunction [dbo].[sfn_GetClientOrderDiagnosis]    Script Date: 04/07/2016 17:24:59 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[sfn_GetClientOrderDiagnosis] (
	@ClientOrderId INT
	,@HL7EncodingChars NVARCHAR(5)
	)
RETURNS NVARCHAR(250)

BEGIN
	DECLARE @Diagnosis VARCHAR(100) = ''
	DECLARE @DiagnosisFinal VARCHAR(250) = ''

	DECLARE Diag CURSOR LOCAL FAST_FORWARD
	FOR
	SELECT DC.ICD10Code
	FROM ClientOrdersDiagnosisIIICodes CO
	INNER JOIN DiagnosisICD10Codes DC ON DC.ICD10CodeId = CO.ICD10CodeId
	WHERE ClientOrderId = @ClientOrderId
		AND ISNULL(CO.RecordDeleted, 'N') = 'N'
		AND ISNULL(DC.RecordDeleted, 'N') = 'N'

	OPEN Diag

	WHILE 1 = 1
	BEGIN
		FETCH Diag
		INTO @Diagnosis

		IF @@fetch_status <> 0
			BREAK

		-- ======================================  
		IF ISNULL(@DiagnosisFinal, '') = ''
			SET @DiagnosisFinal = @Diagnosis
		ELSE
			SET @DiagnosisFinal = @DiagnosisFinal + '|' + @Diagnosis
		-- ======================================     
	END

	CLOSE Diag

	DEALLOCATE Diag

	RETURN dbo.HL7_OUTBOUND_XFORM(ISNULL(@DiagnosisFinal, ''), @HL7EncodingChars)
END
GO


