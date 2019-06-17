/****** Object:  StoredProcedure [dbo].[ssp_InitASAM]    Script Date: 06/14/2016 14:48:38 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_InitASAM]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_InitASAM]
GO

/****** Object:  StoredProcedure [dbo].[ssp_InitASAM]    Script Date: 06/14/2016 14:48:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_InitASAM] (
	@ClientID INT
	,@StaffID INT
	,@CustomParameters XML
	)
AS
/*********************************************************************/
/* Stored Procedure: [ssp_InitASAM]   */
/*       Date              Author                  Purpose                   */
/*      05-06 -2016     Dhanil Manuel               To Initialize          */
/*********************************************************************/
BEGIN
	BEGIN TRY
		IF EXISTS (
				SELECT *
				FROM sys.objects
				WHERE object_id = OBJECT_ID(N'[dbo].[scsp_InitASAM]')
					AND type IN (N'P',N'PC')
				)
		BEGIN
			EXEC scsp_InitASAM @ClientID,@StaffID,@CustomParameters
			RETURN;
		END

		DECLARE @LatestDocumentVersionID INT

		SET @LatestDocumentVersionID = (
				SELECT TOP 1 CDA.DocumentVersionId
				FROM DocumentASAMs CDA
				INNER JOIN Documents Doc ON CDA.DocumentVersionId = Doc.CurrentDocumentVersionId
				WHERE Doc.ClientId = @ClientID
					AND Doc.[Status] = 22
					AND Doc.DocumentCodeId = 2701
					AND IsNull(CDA.RecordDeleted, 'N') = 'N'
					AND IsNull(Doc.RecordDeleted, 'N') = 'N'
				ORDER BY Doc.EffectiveDate DESC
					,Doc.ModifiedDate DESC
				)
		SET @LatestDocumentVersionId = ISNULL(@LatestDocumentVersionId, - 1)

		SELECT 'DocumentASAMs' AS TableName
			,- 1 AS DocumentVersionId
			,'' AS CreatedBy
			,GETDATE() AS CreatedDate
			,'' AS ModifiedBy
			,GETDATE() AS ModifiedDate
			,Dimension1LevelOfCare
			,Dimension1Level
			,Dimension1DocumentedRisk
			,Dimension1Comments
			,Dimension1Summary
			,Dimension2LevelOfCare
			,Dimension2Level
			,Dimension2DocumentedRisk
			,Dimension2Comments
			,Dimension2Summary
			,Dimension3LevelOfCare
			,Dimension3Level
			,Dimension3DocumentedRisk
			,Dimension3Comments
			,Dimension3Summary
			,Dimension4LevelOfCare
			,Dimension4Level
			,Dimension4DocumentedRisk
			,Dimension4Comments
			,Dimension4Summary
			,Dimension5LevelOfCare
			,Dimension5Level
			,Dimension5DocumentedRisk
			,Dimension5Comments
			,Dimension5Summary
			,Dimension6LevelOfCare
			,Dimension6Level
			,Dimension6DocumentedRisk
			,Dimension6Comments
			,Dimension6Summary
			,IndicatedReferredLevel
			,ProvidedLevel
			,FinalDeterminationComments
			,FinalDeterminationSummary
		FROM systemconfigurations s
		LEFT OUTER JOIN DocumentASAMs CDS ON CDS.DocumentVersionId = @LatestDocumentVersionID
	END TRY

	BEGIN CATCH
	END CATCH
END

GO


