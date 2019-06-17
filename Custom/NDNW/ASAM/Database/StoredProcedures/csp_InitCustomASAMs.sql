/****** Object:  StoredProcedure [dbo].[csp_InitCustomASAMs]    Script Date: 06/30/2014 18:06:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomASAMs]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_InitCustomASAMs]
GO

/****** Object:  StoredProcedure [dbo].[csp_InitCustomASAMs]    Script Date: 06/30/2014 18:06:43 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[csp_InitCustomASAMs] (
	@ClientID INT
	,@StaffID INT
	,@CustomParameters XML
	)
AS
-- =============================================    
-- Author      : Akwinass.D 
-- Date        : 01/DEC/2014  
-- Purpose     : Initializing SP Created. 
-- =============================================   
BEGIN
	BEGIN TRY
	DECLARE @LatestDocumentVersionID INT
	DECLARE @EffectiveDate DATETIME	
	DECLARE @Months DECIMAL(10,5)
	
	SELECT TOP 1 @LatestDocumentVersionID = CurrentDocumentVersionId, @EffectiveDate = EffectiveDate
	FROM CustomDocumentASAMs CDCD
	INNER JOIN Documents Doc ON CDCD.DocumentVersionId = Doc.CurrentDocumentVersionId
	WHERE Doc.ClientId = @ClientID
		AND Doc.[Status] = 22
		AND ISNULL(CDCD.RecordDeleted, 'N') = 'N'
		AND ISNULL(Doc.RecordDeleted, 'N') = 'N'
	ORDER BY Doc.EffectiveDate DESC
		,Doc.ModifiedDate DESC
			
	SET @LatestDocumentVersionId = ISNULL(@LatestDocumentVersionId, - 1)
	IF @EffectiveDate IS NOT NULL
	BEGIN		
		SET @Months = CASE WHEN DATEDIFF(d,@EffectiveDate, GETDATE())>30 THEN DATEDIFF(d,@EffectiveDate, GETDATE())/30.0 ELSE 0 END
		IF @Months > 6
		BEGIN
			SET @LatestDocumentVersionId = -1
		END
	END

	SELECT 'CustomDocumentASAMs' AS TableName
		,- 1 AS DocumentVersionId
		,'' AS CreatedBy
		,GETDATE() AS CreatedDate
		,'' AS ModifiedBy
		,GETDATE() AS ModifiedDate
		,ASAM.Dimension1
		,ASAM.D1Level
		,ASAM.D1Risk
		,ASAM.D1Comments
		,ASAM.Dimension2
		,ASAM.D2Level
		,ASAM.D2Risk
		,ASAM.D2Comments
		,ASAM.Dimension3
		,ASAM.D3Level
		,ASAM.D3Risk
		,ASAM.D3Comments
		,ASAM.Dimension4
		,ASAM.D4Level
		,ASAM.D4Risk
		,ASAM.D4Comments
		,ASAM.Dimension5
		,ASAM.D5Level
		,ASAM.D5Risk
		,ASAM.D5Comments
		,ASAM.Dimension6
		,ASAM.D6Level
		,ASAM.D6Risk
		,ASAM.D6Comments
	FROM systemconfigurations s
	LEFT OUTER JOIN CustomDocumentASAMs ASAM ON ASAM.DocumentVersionId = @LatestDocumentVersionID
	END TRY

	BEGIN CATCH
	END CATCH

END

GO


